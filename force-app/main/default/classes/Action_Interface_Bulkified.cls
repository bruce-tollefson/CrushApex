public interface Action_Interface_Bulkified {

    SObject runAction( SObject actionObject, Decimal sumAmount );
    boolean continueToNextStep();
    SObject processNextStep( Boolean continueToNextStep );
    
}

