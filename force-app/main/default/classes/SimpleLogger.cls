public virtual class SimpleLogger {

    protected String cause;
    protected String message;
    protected String stackTrace;
    protected String type;
    protected String lineNumber;

    public SimpleLogger() {}
    public SimpleLogger(String message){
        this.message = message;
    }

    public void setMessage(String message){
        this.message = message;
    }
    public void setStackTrace(String stackTrace){
        this.stackTrace = stackTrace;
    }
    public void setType(String type){
        this.type = type;
    }
    public void setCause(String cause){
        this.cause = cause;
    }
    public void setLineNumber(String lineNumber){
        this.lineNumber = lineNumber;
    }

    public virtual Logger__c commitLogger(){
        Logger__c log = new Logger__c();
        log.Message__c = message;
        log.Stack_Trace__c = stackTrace;
        log.Type__c = type;
        log.Line_Number__c = lineNumber;
        log.Cause__c = cause;
        insert log;
        return log;
    }
}
