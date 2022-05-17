public with sharing class AccountService {
    public static void addAccountTask(List<Account> accountList) {
        system.debug(accountList.size());
        List<Task> taskList = new List<Task>();
        for(Account acct : accountList){
            Task tsk = new Task(Subject=acct.Name+' Account Call', OwnerId=acct.OwnerId, ActivityDate=Date.today().addDays(1),WhatId =acct.Id);
            taskList.add(tsk);
        }
        insert taskList;
    }


    public static void closeAccountTasks(Set<Id> accountIdSet ){
        List<Task> taskList = [Select Id, Status from Task where Id IN :accountIdSet];
        for(Task tsk :taskList){
            tsk.Status = 'Completed';
        }
        update taskList;
    }

    public static void updateInsertedAccounts(List<Account> accountList){
        for(Account acct :accountList){
            acct.Name = 'Updated Name from updateInsertedAccounts method';
        }
    }

    public static void secondUpdateInsertedAccounts(List<Account> accountList){
        for(Account acct :accountList){
            system.debug(acct.Name);
            acct.Name = 'Updated Name from secondUpdateInsertedAccounts method';
        }
    }
}
