import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EmpApiLWC extends LightningElement {
    channelName = '/data/ChangeEvents'; //subscribing channel
    isSubscribeDisabled = false; //disable subscribe button
    unsubOption = '';
    isUnsubscribeDisabled = true; //disable unsubscribe button
    lastMessage = ''; //last message read
    singleEvent = true; //single event mode - only shows last read message
    multiEvent = false; //multiple event mode - shows all read messages
    hasCustomReplay = false; //if the custom replay option was selected
    isSingleReplayId = false; //if the custom replay option was selected and the user only wants to view the one replay id instead of viewing everythign from this event
    replayIdNumber = '-1'; //initial replay Id -1 is new events from the sibscribed point in time
    showSpinner = false; // for spinner
    events = []; //array of events
    subscribedChannels = [];//array of subscribed channels
    isSubscribedChannels = false; //used for showing unsubscribe button and channels
    mapSubscription; //map of subscriptions based on replayId --> subscription proxy object used for unsubscribing
    subChannelMap; //map of subscriptions based on replayId --> subsctiption option label and values used for tracking current channels
    multiEventStr = 'Multiple Events'; //button label

    get options() { // different replay options
        return [
            { label: 'First Event on Bus', value: '-2' }, //get events from the beginning of the last 72 hours
            { label: 'New Events', value: '-1' }, //get only current events after subscribing
            { label: 'I have a Replay Id', value: 'hasId' }, //start from a specified replay id
        ];
    }

    // Fires right away and creates the maps adn register listener
    connectedCallback() {       
        // Register error listener       
        this.registerErrorListener();
        this.mapSubscription = new Map();//instantiate map
        this.subChannelMap = new Map();//instantiate map
    }

    // Tracks changes to channelName text field
    handleChannelName(event) {
        this.channelName = event.target.value;
    }

    // Handles subscribe button click - Subscribe to the specified channel
    handleSubscribe() {
        this.showSpinner = true;
        if(!this.subChannelMap.get(this.channelName)){ //check to see if this is a new channel from the subscribed channel map

            // Callback invoked whenever a new event message is received
            const messageCallback = (response) => {
                this.showSpinner = false;
                let sEvent = () => {
                    return{
                    ReplayId : '',
                    message : ''
                    }
                } // create new event object
                sEvent.ReplayId = response.data.event.replayId; //get replayId
                sEvent.message = JSON.stringify(response, null, 2); //get the event
                this.events.push({ReplayId: `${sEvent.ReplayId}${Date.now()}`, message: sEvent.message}); //push event object
                this.multiEventStr = `Multiple Events (${this.events.length})`; //add length to the button
                this.lastMessage = JSON.stringify(response, null, 2); //put last event into the string

                //if the single replay id is checked and there is a custom replay id - used to unsubscribe and not view/use a bunch of other events
                if(this.isSingleReplayId === true && sEvent.ReplayId === (this.replayIdNumber + 1)){
                    this.unsubOption = this.channelName; //get current channel name
                    this.handleUnsubscribe(); //unsubscribe
                }
            };

            // Invoke subscribe method of empApi. Pass reference to messageCallback
            subscribe(this.channelName, this.replayIdNumber, messageCallback).then(response => {
                // Response contains the subscription information on successful subscribe call
                this.isSubscribedChannels = true;
                if(response){
                    //create subscribed channel object for the list of channels
                    this.subchannel = {
                        label : response.channel,
                        value : response.channel
                    };
                    this.subChannelMap.set(response.channel,this.subchannel);//add channel to map
                    this.subscribedChannels = Array.from(this.subChannelMap.values());//convert values to array
                    this.mapSubscription.set(response.channel, response);//add subscription(returned as response) to map

                    //send toast successful subscribe
                    const evt = new ShowToastEvent({
                        message: `Successfully subscribed to : ${JSON.stringify(response.channel)}`,
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                }
            });
        }else{
            //send notification already subscribed
            const evt = new ShowToastEvent({
                message: `${JSON.stringify(this.channelName)} has already been subscribed if you are trying to change Replay Type unsubscribe from channel then resubscribe`,
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.showSpinner = true;
        }
    }

    // Handles unsubscribe button click
    handleUnsubscribe() {
        this.showSpinner = false;

        // Invoke unsubscribe method of empApi
        unsubscribe(this.mapSubscription.get(this.unsubOption), response => {
            // send unsubscribe toast
            const evt = new ShowToastEvent({
                message: `Successfully unsubscribed from : ${JSON.stringify(response.subscription)}`,
                variant: 'warning',
            });
            this.dispatchEvent(evt);

            this.mapSubscription.delete(this.unsubOption);// delete from the subscription map

            this.deleteSubChannel(this.unsubOption); //delete from the subscribe channel map
        });
    }

    //when single event is clicked change to single event mode
    handleSingleEvent(){
        this.toggleSingleEvent(true);
    }

    //when multi event is clicked change to mulit event mode
    handleMultiEvent(){
        this.toggleSingleEvent(false);
    }

    //toggle handler
    toggleSingleEvent(singleEvent){
        this.singleEvent = singleEvent;
        this.multiEvent = !singleEvent;
    }

    //Replay Event Type picklist has been clicked, make sure the values are changed to determine what to show for subscribing
    handleReplayIdList(evt){
        
        if(evt.detail.value === 'hasId'){
             this.hasCustomReplay = true; //shows the replay id input field
         }else{
             this.replayIdNumber = Number(evt.target.value); //get the replay id type number and make sure it is a number
             this.hasCustomReplay = false; //don't show custom replay input field
         }
    }

    updateReplayId(evt){
        this.replayIdNumber = Number(evt.target.value) - 1;//subtract 1 from the replayId when you put the replay id in the subscriber it will start from this number, as in it will 
    }

    registerErrorListener() {
        // Invoke onError empApi method
        // Error contains the server-side error
        onError(error => {
            //send error toast
            console.log('Received error from server: ', JSON.stringify(error));
            const evt = new ShowToastEvent({
                title: error.subscription,
                message: error.error,
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.deleteSubChannel(error.subscription);//delete from subscribe channel map
            this.showSpinner = true;
        });
    }

    //delete subscribe channel map handler
    deleteSubChannel(unsubChannel){
        this.subChannelMap.delete(unsubChannel);
        this.subscribedChannels = Array.from(this.subChannelMap.values());//convert values to array for new list of channels
        this.isUnsubscribeDisabled = true;
        if(this.subscribedChannels.length <=0 ){
            this.isSubscribedChannels = false; 
        }
    }

    //clear events array for multi event mode, single event for single event mode, clear the number of events in the multiple events button
    handleClear(){
        this.events = [];
        this.lastMessage = '';
        this.multiEventStr = `Multiple Events`;
    }

    //only get the single replay id otherwise the rest of the events on the bus that occured after this will fire
    handleSingleReplayId(){
        this.isSingleReplayId = !this.isSingleReplayId;
    }

    //unsubscribe channel list button has been clicked/changed
    handleUnsubChannelChange(evt){
        this.unsubOption = evt.detail.value;
        this.isUnsubscribeDisabled = false;
    }

}