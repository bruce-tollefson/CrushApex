@isTest
public class ActionInterface_Test {
    @testSetup
    static void setupData(){//setup setups up the data for all these test classes
        List<Account> accountList = TestDataFactory.createAccounts(3, true);//needs to get the account Ids
        List<Opportunity> oppList = TestDataFactory.createOpportunities(6, Date.today().addMonths(-3), false);
        //Gold Tier
        accountList[0].Tier__c = 'Gold';
        accountList[0].Name = 'Gold Account';
        oppList[0].AccountId = accountList[0].Id;
        oppList[0].Amount = 1200000.00;
        oppList[1].AccountId = accountList[0].Id;
        oppList[1].Amount = 1200000.00;
        //Silver Tier
        accountList[1].Tier__c = 'Silver';
        accountList[1].Name = 'Silver Account';
        oppList[2].AccountId = accountList[1].Id;
        oppList[2].Amount = 600000.00;
        oppList[3].AccountId = accountList[1].Id;
        oppList[3].Amount = 600000.00;
        //Bronze Tier
        accountList[2].Tier__c = 'Bronze';
        accountList[2].Name = 'Bronze Account';
        oppList[4].AccountId = accountList[2].Id;
        oppList[4].Amount = 300000.00;
        oppList[5].AccountId = accountList[2].Id;
        oppList[5].Amount = 300000.00;
        
        update accountList;
        insert oppList;
    }
    
    @isTest
    static void testGoldActionDiscount(){
        Id accountId = [Select Id from Account where Name = 'Gold Account' Limit 1].Id;
        Opportunity opp = [Select FIELDS(STANDARD) from Opportunity where AccountId = :accountId Limit 1];
        Test.startTest();
        OpportunityWonGoldTierAction owgta = new OpportunityWonGoldTierAction();
        owgta.runAction(opp);
        //OpportunityActionService.checkOppWonAction(opp);
        Test.stopTest();

        Opportunity additionalValueOpp = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id = :opp.Id Limit 1];
        Opportunity_Tier_Milestone__mdt goldMilestone = Opportunity_Tier_Milestone__mdt.getInstance('GOLD');
        system.assertEquals(goldMilestone.Discount_Percent__c, additionalValueOpp.Discount_Percent__c);
        
    }
    
        @isTest
    static void testSilverActionDiscount(){
        Account accountObj = [Select Id, Tier__c from Account where Name = 'Silver Account' Limit 1];
        Opportunity opp = [Select FIELDS(STANDARD) from Opportunity where AccountId = :accountObj.Id Limit 1];
        Test.startTest();
        OpportunityWonSilverTierAction owsta = new OpportunityWonSilverTierAction();
        owsta.runAction(opp);
        //OpportunityActionService.checkOppWonAction(opp);
        Test.stopTest();

        Account accountObjRequerySilver = [Select Id, Tier__c from Account where Id = :accountObj.Id Limit 1];
        Opportunity additionalValueOppSilver = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id = :opp.Id Limit 1];
        Opportunity_Tier_Milestone__mdt silverMilestone = Opportunity_Tier_Milestone__mdt.getInstance('SILVER');
        system.assertEquals(silverMilestone.Discount_Percent__c, additionalValueOppSilver.Discount_Percent__c);
        system.assertEquals(silverMilestone.Next_Upgraded_Membership__c, accountObjRequerySilver.Tier__c);
        
    }
    
            @isTest
    static void testBronzeActionDiscount(){
        Account accountObj = [Select Id, Tier__c from Account where Name = 'Bronze Account' Limit 1];
        Opportunity opp = [Select FIELDS(STANDARD) from Opportunity where AccountId = :accountObj.Id Limit 1];
        Test.startTest();
        OpportunityWonBronzeTierAction owbta = new OpportunityWonBronzeTierAction();
        owbta.runAction(opp);
        //OpportunityActionService.checkOppWonAction(opp);
        Test.stopTest();

        Account accountObjRequeryBronze = [Select Id, Tier__c from Account where Id = :accountObj.Id Limit 1];
        Opportunity additionalValueOppBronze = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id = :opp.Id Limit 1];
        Opportunity_Tier_Milestone__mdt bronzeMilestone = Opportunity_Tier_Milestone__mdt.getInstance('BRONZE');
        system.assertEquals(bronzeMilestone.Discount_Percent__c, additionalValueOppBronze.Discount_Percent__c);
        system.assertEquals(bronzeMilestone.Next_Upgraded_Membership__c, accountObjRequeryBronze.Tier__c);
        
    }

        @isTest
    static void testBulkifiedActionDiscount(){
        List<Opportunity> oppList = new List<Opportunity>();
        Id accountId = [Select Id from Account where Name = 'Gold Account' Limit 1].Id;
        Opportunity oppGold = [Select FIELDS(STANDARD) from Opportunity where AccountId = :accountId Limit 1];
        oppList.add(oppGold);
        Account accountObjSilver = [Select Id, Tier__c from Account where Name = 'Silver Account' Limit 1];
        Opportunity oppSilver = [Select FIELDS(STANDARD) from Opportunity where AccountId = :accountObjSilver.Id Limit 1];
        oppList.add(oppSilver);        
        Account accountObjBronze = [Select Id, Tier__c from Account where Name = 'Bronze Account' Limit 1];
        Opportunity oppBronze = [Select FIELDS(STANDARD) from Opportunity where AccountId = :accountObjBronze.Id Limit 1];
        oppList.add(oppBronze);  
        Test.startTest();
        OpportunityActionService.checkOppWonAction(oppList);
        Test.stopTest();

        Opportunity additionalValueOpp = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id = :oppGold.Id Limit 1];
        Opportunity_Tier_Milestone__mdt goldMilestone = Opportunity_Tier_Milestone__mdt.getInstance('GOLD');
        system.assertEquals(goldMilestone.Discount_Percent__c, additionalValueOpp.Discount_Percent__c);
        
        
        Account accountObjRequerySilver = [Select Id, Tier__c from Account where Id = :accountObjSilver.Id Limit 1];
        Opportunity additionalValueOppSilver = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id = :oppSilver.Id Limit 1];
        Opportunity_Tier_Milestone__mdt silverMilestone = Opportunity_Tier_Milestone__mdt.getInstance('SILVER');
        system.assertEquals(additionalValueOppSilver.Discount_Percent__c, additionalValueOppSilver.Discount_Percent__c);
        system.assertEquals(silverMilestone.Next_Upgraded_Membership__c, accountObjRequerySilver.Tier__c);
        
        Account accountObjRequeryBronze = [Select Id, Tier__c from Account where Id = :accountObjBronze.Id Limit 1];
        Opportunity additionalValueOppBronze = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id = :oppBronze.Id Limit 1];
        Opportunity_Tier_Milestone__mdt bronzeMilestone = Opportunity_Tier_Milestone__mdt.getInstance('BRONZE');
        system.assertEquals(additionalValueOppBronze.Discount_Percent__c, additionalValueOppBronze.Discount_Percent__c);
        system.assertEquals(bronzeMilestone.Next_Upgraded_Membership__c, accountObjRequeryBronze.Tier__c);
        
    }
}