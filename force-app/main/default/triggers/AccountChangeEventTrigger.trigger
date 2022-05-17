trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    for(AccountChangeEvent ace :Trigger.New){
        system.debug(JSON.serializePretty(ace));
    }
}