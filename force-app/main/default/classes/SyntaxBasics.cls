public class SyntaxBasics {

    public SyntaxBasics(Id accountId, String accountName){
        Account acct = [Select Id, Name from Account where Id = :accountId];
        acct.Name = accountName;
        update acct;
        System.debug(acct);
        method6(accountId, accountName);
    }

    public static void method1(){
        Account acct = [Select Id, Name from Account Limit 1];
        acct.Name = 'Updated Account Name';
        update acct;
    }

    /*
    @description update account and return account object
    @return Account - Account object records not updated
    */
    public static Account method2(){
        Account acct = [Select Id, Name from Account Limit 1];
        acct.Name = 'Updated Account Name';
        //update acct;
        return acct;
    }

    /*
    @description update account and return account object
    @param Id - Id of account to update
    @param String - Account Name Change
    */
    public static void method3(Id accountId, String accountName){
        //null check
        if(accountId != null){
            /*
            Account acct = [Select Id, Name from Account where Id = :accountId];
            acct.Name = accountName;
            update acct;
            */
        }
    }

    public void method4(){
        Account acct = [Select Id, Name from Account Limit 1];
        acct.Name = 'Updated Account Name';
        update acct;
    }

    public Account method5(){
        Account acct = [Select Id, Name from Account Limit 1];
        acct.Name = 'Updated Account Name';
        update acct;
        return acct;
    }

    public void method6(Id accountId, String accountName){
        Account acct = [Select Id, Name from Account where Id = :accountId];
        acct.Name = accountName;
        update acct;
    }
}
