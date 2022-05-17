public with sharing class OpportunityWonGoldTierAction_Bulkified implements Action_Interface_Bulkified {

        Private Opportunity opp;
        Private Decimal discountMilestone;
        Private Decimal discountPercentage;
        Private Decimal currentOppAmount;
        Private Decimal discountedAmount;
        Private Decimal amountAfterDiscount;
        Private Boolean updatedOpp = false;
    
    
        public OpportunityWonGoldTierAction_Bulkified(){
            Opportunity_Tier_Milestone__mdt goldTierMDT = Opportunity_Tier_Milestone__mdt.getInstance('GOLD');
            this.discountMilestone = goldTierMDT.Discount_Milestone__c;
            this.discountPercentage = goldTierMDT.Discount_Percent__c / 100;
        }
    
        public SObject runAction( SObject opp, Decimal sumAmount ){
            this.opp = (Opportunity)opp;
            this.currentOppAmount = this.opp.Amount;
            Decimal oppSumAmount = sumAmount;
            Decimal previousAmount = oppSumAmount - this.currentOppAmount;
            if(this.discountMilestone >= previousAmount){
                calculateAppliedDiscountAmount();
                calculateAmountAfterDiscount();
    
                if((previousAmount + this.amountAfterDiscount) >= this.discountMilestone){
                    updateOpportunity();
                }
            }
            return this.updatedOpp ? this.opp : null;
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
            this.updatedOpp = true;
        }
    
        public boolean continueToNextStep(){
            return false;
        }
        public SObject processNextStep( Boolean upgradeMembership ){ return null; }
    }
    