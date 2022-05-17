public interface Action_Interface {

    void runAction( SObject actionObject);
    boolean continueToNextStep();
    void processNextStep( Boolean continueToNextStep );
    
}
