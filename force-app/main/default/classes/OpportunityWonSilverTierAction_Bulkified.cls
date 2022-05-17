public with sharing class OpportunityWonSilverTierAction_Bulkified implements Action_Interface_Bulkified {

        Private Opportunity opp;
        Private Decimal discountMilestone;
        Private Decimal discountPercentage;
        Private Decimal currentOppAmount;
        Private Decimal discountedAmount;
        Private Decimal amountAfterDiscount;
        Private String nextUpgradedMembership;
        Private Boolean updatedOpp = false;
        Private Boolean continueToNextStep = false;
    
    
        public OpportunityWonSilverTierAction_Bulkified(){
            Opportunity_Tier_Milestone__mdt silverTierMDT = Opportunity_Tier_Milestone__mdt.getInstance('SILVER');
            this.discountMilestone = silverTierMDT.Discount_Milestone__c;
            this.discountPercentage = silverTierMDT.Discount_Percent__c / 100;
            this.nextUpgradedMembership = silverTierMDT.Next_Upgraded_Membership__c;
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
            this.continueToNextStep = true;
            this.updatedOpp = true;
        }
    
        public boolean continueToNextStep(){
            return this.continueToNextStep;
        }
        public SObject processNextStep( Boolean upgradeMembership ){
            Account oppAccount = new Account(Id=this.opp.AccountId, Tier__c=this.nextUpgradedMembership);
            return oppAccount;
        }
    }
    
    
