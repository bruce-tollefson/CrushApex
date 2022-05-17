public abstract class SimpleLoggerAbstract implements LoggerInterface {

protected String cause;
protected String message;
protected String stackTrace;
protected String type;
protected String lineNumber;

public SimpleLoggerAbstract() {}
public SimpleLoggerAbstract(String message){
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

public abstract Logger__c commitLogger();
}
