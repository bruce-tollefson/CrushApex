public with sharing class OpportunityWonGoldTierAction implements Action_Interface {

    Private Opportunity opp;
    Private Decimal discountMilestone;
    Private Decimal discountPercentage;
    Private Decimal currentOppAmount;
    Private Decimal discountedAmount;
    Private Decimal amountAfterDiscount;


    public OpportunityWonGoldTierAction(){
        Opportunity_Tier_Milestone__mdt goldTierMDT = Opportunity_Tier_Milestone__mdt.getInstance('GOLD');
        this.discountMilestone = goldTierMDT.Discount_Milestone__c;
        this.discountPercentage = goldTierMDT.Discount_Percent__c / 100;
    }

    public void runAction( SObject opp ){
        this.opp = (Opportunity)opp;
        this.currentOppAmount = this.opp.Amount;
        Decimal oppSumAmount = getOppSumAmount();
        Decimal previousAmount = oppSumAmount - this.currentOppAmount;
        if(this.discountMilestone >= previousAmount){
            calculateAppliedDiscountAmount();
            calculateAmountAfterDiscount();

            if((previousAmount + this.amountAfterDiscount) >= this.discountMilestone){
                updateOpportunity();
            }
        }

    }

    private Decimal getOppSumAmount(){
        return (Decimal)[Select SUM(Amount) from Opportunity where IsClosed = TRUE and AccountId = :this.opp.AccountId][0].get('expr0');
    }

    private void calculateAppliedDiscountAmount(){
        this.discountedAmount = this.currentOppAmount * this.discountPercentage;
    }

    private void calculateAmountAfterDiscount(){
        this.amountAfterDiscount = this.currentOppAmount - this.discountedAmount;
    }

    private void updateOpportunity(){
        this.opp.Discount_Percent__c = this.discountPercentage * 100;
        this.opp.Discounted_Amount__c = this.discountedAmount;
        this.opp.Amount = this.amountAfterDiscount;
        update this.opp;
    }

    public boolean continueToNextStep(){
        return false;
    }
    public void processNextStep( Boolean upgradeMembership ){}
}
