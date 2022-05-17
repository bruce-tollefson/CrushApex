public with sharing class OpportunityWonBronzeTierAction implements Action_Interface {

    Private Opportunity opp;
    Private Decimal discountMilestone;
    Private Decimal discountPercentage;
    Private Decimal currentOppAmount;
    Private Decimal discountedAmount;
    Private Decimal amountAfterDiscount;
    Private String nextUpgradedMembership;


    public OpportunityWonBronzeTierAction(){
        Opportunity_Tier_Milestone__mdt bronzeTierMDT = Opportunity_Tier_Milestone__mdt.getInstance('BRONZE');
        this.discountMilestone = bronzeTierMDT.Discount_Milestone__c;
        this.discountPercentage = bronzeTierMDT.Discount_Percent__c / 100;
        this.nextUpgradedMembership = bronzeTierMDT.Next_Upgraded_Membership__c;
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
        this.opp.Discount_Percent__c = this.discountPercentage*100;
        this.opp.Discounted_Amount__c = this.discountedAmount;
        this.opp.Amount = this.amountAfterDiscount;
        processNextStep( continueToNextStep() );
        update this.opp;
    }

    public boolean continueToNextStep(){
        return true;
    }
    public void processNextStep( Boolean upgradeMembership ){
        Account oppAccount = new Account(Id=this.opp.AccountId, Tier__c=this.nextUpgradedMembership);
        update oppAccount;
    }
}


