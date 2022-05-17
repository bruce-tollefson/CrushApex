public with sharing class BatchClass implements Database.Batchable<Account>, Database.Stateful {

    private Integer numberOfErrors = 0;

    public Iterable<Account> start(Database.BatchableContext bc){
        return [Select Id, Name from Account];
    }

    public void execute(Database.BatchableContext bc, List<Account> scope){
        system.debug(scope.size());
        List<Account> accountList = (List<Account>)scope;
        List<Task> taskList = new List<Task>();
        for(Account acct :accountList){
            Task tsk = new Task(Subject=acct.Name);
            taskList.add(tsk);
        }

        List<Database.SaveResult> dbSaveList = Database.insert(taskList, false);
        for(Database.SaveResult sr :dbSaveList){
            if(sr.isSuccess()){
                system.debug('Successfully inserted record');
            }else{
                this.numberOfErrors++;
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        system.debug(numberOfErrors);
        if(numberOfErrors > 0){
            Logger__c log = new Logger__c();
            log.Cause__c = 'BatchClass '+bc.getJobId();
            log.Message__c = numberOfErrors+ ' records had errors';
            insert log;
        }
    }
}
