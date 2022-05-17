public with sharing class OpportunityActionService {
    public static void checkOppWonAction(List<Opportunity> oppList) {

        Set<Id> accountIdSet = new Set<Id>();

        for(Opportunity opp :oppList){
            if(opp.isWon && opp.AccountId != null) accountIdSet.add(opp.AccountId);
        }

        Map<Id, Account> accountIdToTierMap = new Map<Id, Account>([Select Tier__c from Account where Id IN :accountIdSet]);

        Map<Id, Decimal> accountSumMap = new Map<Id, Decimal>();
        for(AggregateResult ar :[Select AccountId, SUM(Amount)sum from Opportunity where IsClosed = True 
                                                                    and AccountId in :accountIdSet
                                                                    Group BY AccountId]){
                            accountSumMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('sum'));
        }

        Set<SObject> sobjectUpdateSet = new Set<SObject>();
        List<SOBject> sObjectList = new List<SObject>();

        for(Opportunity opp :oppList){
            if(opp.isWon && opp.AccountId != null){
                String oppAction = 'OpportunityWon'+accountIdToTierMap.get(opp.AccountId).Tier__c+'TierAction_Bulkified';
                Action_Interface_Bulkified tierAction = (Action_Interface_Bulkified)Type.forName(oppAction).newInstance();
                sobjectUpdateSet.add(tierAction.runAction(opp, accountSumMap.get(opp.AccountId)));
                if(tierAction.continueToNextStep()){
                    sobjectUpdateSet.add(tierAction.processNextStep(tierAction.continueToNextStep()));
                }
            }
        }
        sobjectUpdateSet.remove(null);
        sObjectList.addAll(sobjectUpdateSet);
        update sObjectList;
    }
}