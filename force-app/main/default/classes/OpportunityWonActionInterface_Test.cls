@isTest
public with sharing class OpportunityWonActionInterface_Test {

    @TestSetup
    static void setupData(){
        List<Account> accountList = TestDataFactory.createAccounts(3, true);
        List<Opportunity> oppList = TestDataFactory.createOpportunities(6, Date.today().addMonths(-3), false);
        //Gold Tier
        accountList[0].Tier__c = 'Gold';
        accountList[0].Name = 'Gold Account';
        oppList[0].AccountId = accountList[0].Id;
        oppList[0].Amount = 1200000;
        oppList[1].AccountId = accountList[0].Id;
        oppList[1].Amount = 1200000;
        //Silver Tier
        accountList[1].Tier__c = 'Silver';
        accountList[1].Name = 'Silver Account';
        oppList[2].AccountId = accountList[1].Id;
        oppList[2].Amount = 600000;
        oppList[3].AccountId = accountList[1].Id;
        oppList[3].Amount = 600000;
        //Bronze Tier
        accountList[2].Tier__c = 'Bronze';
        accountList[2].Name = 'Bronze Account';
        oppList[4].AccountId = accountList[2].Id;
        oppList[4].Amount = 300000;
        oppList[5].AccountId = accountList[2].Id;
        oppList[5].Amount = 300000;

        update accountList;
        insert oppList;
    }

    @isTest
    static void testGoldActionDiscount(){
        Id accountId = [Select Id from Account where Name = 'Gold Account' limit 1].Id;
        Opportunity opp = [Select FIELDS(STANDARD) from Opportunity where AccountId =:accountId limit 1];
        Test.startTest();
        OpportunityWonGoldTierAction owgta = new OpportunityWonGoldTierAction();
        owgta.runAction(opp);
        owgta.processNextStep(owgta.continueToNextStep());
        Test.stopTest();

        Opportunity additionalValueOpp = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id =:opp.Id limit 1];
        Opportunity_Tier_Milestone__mdt goldMilestone = Opportunity_Tier_Milestone__mdt.getInstance('GOLD');
        system.assertEquals(goldMilestone.Discount_Percent__c, additionalValueOpp.Discount_Percent__c);
    }

    @isTest
    static void testSilverActionDiscount(){
        Id accountId = [Select Id from Account where Name = 'Silver Account' limit 1].Id;
        Opportunity opp = [Select FIELDS(STANDARD) from Opportunity where AccountId =:accountId limit 1];
        Test.startTest();
        OpportunityWonSilverTierAction owsta = new OpportunityWonSilverTierAction();
        owsta.runAction(opp);
        Test.stopTest();

        Opportunity additionalValueOpp = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id =:opp.Id limit 1];
        Opportunity_Tier_Milestone__mdt silverMilestone = Opportunity_Tier_Milestone__mdt.getInstance('SILVER');
        system.assertEquals(silverMilestone.Discount_Percent__c, additionalValueOpp.Discount_Percent__c);
    }

    @isTest
    static void testBronzeActionDiscount(){
        Id accountId = [Select Id from Account where Name = 'Bronze Account' limit 1].Id;
        Opportunity opp = [Select FIELDS(STANDARD) from Opportunity where AccountId =:accountId limit 1];
        Test.startTest();
        OpportunityWonBronzeTierAction owsta = new OpportunityWonBronzeTierAction();
        owsta.runAction(opp);
        Test.stopTest();

        Opportunity additionalValueOpp = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id =:opp.Id limit 1];
        Opportunity_Tier_Milestone__mdt bronzeMilestone = Opportunity_Tier_Milestone__mdt.getInstance('BRONZE');
        system.assertEquals(bronzeMilestone.Discount_Percent__c, additionalValueOpp.Discount_Percent__c);
    }




    @isTest
    static void testBulkifiedActionDiscount(){
        List<Opportunity> oppList = new List<Opportunity>();
        Id accountId = [Select Id from Account where Name = 'Gold Account' limit 1].Id;
        Opportunity oppGold = [Select FIELDS(STANDARD) from Opportunity where AccountId =:accountId limit 1];
        oppList.add(oppGold);
        Id accountSilverObjId = [Select Id from Account where Name = 'Silver Account' limit 1].Id;
        Opportunity oppSilver = [Select FIELDS(STANDARD) from Opportunity where AccountId =:accountSilverObjId limit 1];
        oppList.add(oppSilver);
        Id accountBronzeObjId = [Select Id from Account where Name = 'Bronze Account' limit 1].Id;
        Opportunity oppBronze = [Select FIELDS(STANDARD) from Opportunity where AccountId =:accountBronzeObjId limit 1];
        oppList.add(oppBronze);

        Test.startTest();
        OpportunityActionService.checkOppWonAction(oppList);
        Test.stopTest();

        Opportunity additionalValueOpp = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id =:oppGold.Id limit 1];
        Opportunity_Tier_Milestone__mdt goldMilestone = Opportunity_Tier_Milestone__mdt.getInstance('GOLD');
        system.assertEquals(goldMilestone.Discount_Percent__c, additionalValueOpp.Discount_Percent__c);
        Opportunity additionalValueOppSilver = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id =:oppSilver.Id limit 1];
        Opportunity_Tier_Milestone__mdt silverMilestone = Opportunity_Tier_Milestone__mdt.getInstance('SILVER');
        system.assertEquals(silverMilestone.Discount_Percent__c, additionalValueOppSilver.Discount_Percent__c);
        Opportunity additionalValueOppBronze = [Select Amount, Discounted_Amount__c, Discount_Percent__c, AccountId from Opportunity where Id =:oppBronze.Id limit 1];
        Opportunity_Tier_Milestone__mdt bronzeMilestone = Opportunity_Tier_Milestone__mdt.getInstance('BRONZE');
        system.assertEquals(bronzeMilestone.Discount_Percent__c, additionalValueOppBronze.Discount_Percent__c);
    }

}
