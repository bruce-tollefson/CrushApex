public class SimpleLoggerAbstractExtended extends SimpleLoggerAbstract {
    public SimpleLoggerAbstractExtended(String message) {
        super(message);
    }

    public override Logger__c commitLogger(){
        Logger__c log = new Logger__c();
        log.Message__c = message;
        log.Stack_Trace__c = stackTrace;
        log.Type__c = type;
        log.Line_Number__c = lineNumber;
        log.Cause__c = cause;
        insert log;
        return log;
    }

    public void debugLogger(Logger__c log){
        System.debug(log);
    }
}
