public class UpdatedLogger extends SimpleLogger implements LoggerInterface {


    public UpdatedLogger(String message, String stackTrace){
        super(message);
        this.stackTrace = stackTrace;
    }


    public override Logger__c commitLogger(){
        System.debug('This method has been overridden');
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

    public void newMethod(){
        System.debug('Only available from the updatedlogger');
    }

}
