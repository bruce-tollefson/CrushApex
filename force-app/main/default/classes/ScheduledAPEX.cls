global class ScheduledAPEX implements Schedulable {
    global void execute(SchedulableContext sc) {
        Integer numberOfFailedRecords = [Select Id from AsyncApexJob where Status = 'Failed'].size();
        Logger__c log = new Logger__c(Cause__c = 'ScheduledAPEX',Message__c=numberOfFailedRecords+' records have failed today');
        insert log;
    }
}
