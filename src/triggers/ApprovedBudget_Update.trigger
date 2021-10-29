/** * File Name: Opportunity_UpdateStatus
* Description : Trigger to throw Error if the Approved Budget field is updated/inserted by someone else other than the approver of the CBT of opportunity.
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
8/12/2010 -Added code to update the Is_Opportunity_Closed__c field in Opportunity when the stage is closed or not applicable
24/5/2016 - Added code to check SBU and allow Approver, Growth Leader, and Sales Operations Analyst, not just Approver. INC000010189348

Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger ApprovedBudget_Update on Discretionary_Plan__c (After Insert, After Update) {
String userID = UserInfo.getUserId();
System.debug('Current User Id : '+userID);
String ApproverID;
/******** Changes for INC000010189348 by TCS RUN ***********/
String GrowthID;
String OpsID;
/******** Changes for INC000010189348 by TCS RUN ***********/
System.debug('ApproverID : '+ApproverID); 
List<Opportunity> OPP = new List<Opportunity>();
List<DR_Approvers_List__c> DRAL = new List<DR_Approvers_List__c>();

    for(Discretionary_Plan__c Dplan : Trigger.new){
        if((Trigger.Isinsert && Dplan.Approved_Budget__c !=null) || (Trigger.Isupdate && (System.Trigger.OldMap.get(Dplan.id).Approved_Budget__c != System.Trigger.NewMap.get(Dplan.id).Approved_Budget__c))){
            OPP = [Select CBT_Tier_2__c,SBU__C from Opportunity where id =: Dplan.Opportunity__c]; 
            System.debug('aaaaaaaaaaaaaaa'+OPP);
            
            if(OPP.size()>0)
            DRAL = [Select Id, CBT__c, Approver__c, Growth_Leader__c, Sales_Operations_Analyst__c  from DR_Approvers_List__c where CBT__c =: OPP[0].CBT_Tier_2__c] ;
              
            if(DRAL.size()>0)
            if(OPP[0].CBT_Tier_2__c == DRAL[0].CBT__c){
                ApproverID = DRAL[0].Approver__c;
                System.debug('CBT User Id : '+ApproverID); 
                /******** Changes for INC000010189348 by TCS RUN ***********/
                GrowthID = DRAL[0]. Growth_Leader__c;
                OpsID = DRAL[0]. Sales_Operations_Analyst__c;
                /******** Changes for INC000010189348 by TCS RUN ***********/
                if(userID != ApproverID &&  userID != GrowthID &&  userID != OpsID ) 
                Dplan.addError(' You are not authorized to add/change the Approved Budget.');
                
            }    
        }
    }
}