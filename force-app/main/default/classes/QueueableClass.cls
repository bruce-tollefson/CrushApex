public with sharing class QueueableClass implements Queueable, Finalizer, Database.AllowsCallouts {

    private Integer numberOfErrors = 0;

    public QueueableClass(){}

    public QueueableClass(Integer numberOfErrors){
        this.numberOfErrors = numberOfErrors;
    }

    public void execute(System.QueueableContext qc){
        List<Task> tskList = new List<Task>();
        for(Account acct :[Select Id, Name from Account]){
            Task tsk = new Task(Subject=acct.Name);
            tskList.add(tsk);
        }

        List<Database.SaveResult> dbSaveList = Database.insert(tskList, false);
        for(Database.SaveResult sr :dbSaveList){
            if(sr.isSuccess()){
                system.debug('Successfully inserted record');
            }else{
                this.numberOfErrors++;
            }
        }

        QueueableClass q = new QueueableClass(numberOfErrors);
        system.attachFinalizer(q);
    }


    public void execute(FinalizerContext ctx){
        if(numberOfErrors > 0){
            Logger__c log = new Logger__c();
            log.Cause__c = 'QueueableClass '+ctx.getAsyncApexJobId();
            log.Message__c = numberOfErrors+ ' records had errors';
            insert log;
        }
    }
}
