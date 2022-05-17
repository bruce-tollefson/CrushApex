trigger TestEventTrigger on Test_Event__e (after insert) {
    for(Test_Event__e te :Trigger.New){
        system.debug(JSON.serializePretty(te));
    }
}