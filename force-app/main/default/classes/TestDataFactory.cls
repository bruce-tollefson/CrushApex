@isTest
public class TestDataFactory {

    public static List<Account> createAccounts(Integer noOfAccounts, Boolean isCreate){
        List<Account> accountList = new List<Account>();
        for(Integer i=0; i<noOfAccounts;i++){
            Account ac = new Account();
            ac.Name = 'Test Account: '+i;
            accountList.add(ac);
        }
        if(isCreate) insert accountList;
        return accountList;
    }

    public static List<Opportunity> createOpportunities(Integer noOfOpps, Date closeDate, Boolean isCreate){
        List<Opportunity> oppList = new List<Opportunity>();

        for(Integer i=0;i<noOfOpps;i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity: '+i;
            opp.CloseDate = closeDate;
            opp.StageName = 'Closed Won';
            oppList.add(opp);
        }

        if(isCreate) insert oppList;
        return oppList;
    }
}
