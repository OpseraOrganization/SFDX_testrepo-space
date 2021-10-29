/**********************************************************************************************


AERO
Name         : updateRecipientNames
Created By   : Shrivaths Kulkarni
Company Name : NTT Data
Project      : Gift and Hospitality 
Created Date : 29-Dec-2014
Description  : This trigger updates the names of all the recipients associated to a single request and calculates the score for Approval/Rejection process.
               It is used to calculate multiple values when the request is made, while inserting. editing or deleting through the G&H App (Requester).

**********************************************************************************************/

trigger updateRecipientNames on GH_Request_Recipient__c (after insert, after update, after delete, before insert, before update) {
    User currentUserDetails =  [select SBU_User__c, SBG__c, Id from User where id =: UserInfo.getUserId()];
    String OrReqStatus = '';
    if(Trigger.isAfter) {
        if(Trigger.isinsert || Trigger.isupdate){
        
            set<id> parentReqIds = new set<id>();
            
            for(GH_Request_Recipient__c rec: Trigger.New){
                if(Trigger.IsUpdate){
                    if(rec.Name_of_Recipient__c != Trigger.OldMap.get(rec.Id).Name_of_Recipient__c){
                        parentReqIds.add(rec.GH_Request__c);
                    }
                }else{
                    parentReqIds.add(rec.GH_Request__c);    
                }
            }
            
            List<Order_Request__c> listAllGH = [select id, Recipient_Name_List__c, (select id, Name_of_Recipient__c from GH_Request_Recipients__r) from Order_Request__c where id in: parentReqIds];
            List<Order_Request__c> listUpdateRecipients = new List<Order_Request__c>();
            
            for(Order_Request__c ghRequest: listAllGH){
                string recipientNameList = '';
                for(GH_Request_Recipient__c  ghRecipient: ghRequest.GH_Request_Recipients__r){
                    recipientNameList  += ghRecipient.Name_of_Recipient__c +'; ';
                }
                ghRequest.Recipient_Name_List__c = recipientNameList;
                listUpdateRecipients.add(ghRequest);
            }
            
            if(listUpdateRecipients.size() > 0){
                update listUpdateRecipients;
            }
        }
        
        if(Trigger.isdelete){
            set<id> parentReqIds = new set<id>();
            for(GH_Request_Recipient__c rec: Trigger.Old){
                parentReqIds.add(rec.GH_Request__c);
            }
            
            List<Order_Request__c> listAllGH = [select id, Recipient_Name_List__c, (select id, Name_of_Recipient__c from GH_Request_Recipients__r) from Order_Request__c where id in: parentReqIds];
            List<Order_Request__c> listUpdateRecipients = new List<Order_Request__c>();
            
            for(Order_Request__c ghRequest: listAllGH){
                string recipientNameList = '';
                for(GH_Request_Recipient__c  ghRecipient: ghRequest.GH_Request_Recipients__r){
                    recipientNameList  += ghRecipient.Name_of_Recipient__c +'; ';
                }
                ghRequest.Recipient_Name_List__c = recipientNameList;
                listUpdateRecipients.add(ghRequest);
            }
            
            if(listUpdateRecipients.size() > 0){
                update listUpdateRecipients;
            }
        }
        
        if(!Trigger.isdelete){
            // Logic to update the parent status when the approver approves or rejects the request Starts
            id ParentRecId;
            for(GH_Request_Recipient__c rec: Trigger.New){
                ParentRecId = rec.GH_Request__c;
            }
            List<GH_Request_Recipient__c> RecipientList = [Select Id,Name,Company__c,Country__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,
                                                             Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,Gift_Value_of_gift__c,Gift_Description__c, Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,
                                                             ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,ME_Value_of_Meals_Entertainment__c, ME_Description__c, ME_Business_Purpose__c, ME_Additional_Comments__c,
                                                             Name_of_Recipient__c,Name_of_Recipient_Lookup__c,Position__c,Score__c,Status__c,Type_of_Gift__c, GH_Request__r.SBU__c, GH_Request__r.SBG__c from GH_Request_Recipient__c where GH_Request__c =:ParentRecId AND (Status__c != 'Approved' AND Status__c != 'Rejected')];
            Order_Request__c  ORUpdate = [Select Id,Status__c,SBU__c,SBG__c from Order_Request__c where Id =:ParentRecId];   
                if(RecipientList.size() == 0) {
                    system.debug('<<<SBG>>>'+ORUpdate.SBG__c +'<<<SBU>>>'+ORUpdate.SBU__c);
                    if(ORUpdate.Status__c != 'Draft'){
                        if((ORUpdate.SBU__c == Label.GH_D_S && ORUpdate.SBG__c == Label.GH_Aero)){
                            ORUpdate.Status__c = 'Pending';
                        }else{
                            ORUpdate.Status__c = 'Complete';
                        }
                        system.debug('ORUpdate.Status__c != Draft && (ORUpdate.SBU__c != Label.GH_D_S && ORUpdate.SBG__c != Label.GH_Aero)');
                        update ORUpdate; 
                    }
                     
                }else{
                    if(ORUpdate.Status__c != 'Draft'){
                    ORUpdate.Status__c = 'Pending';
                    update ORUpdate;
                    }
                }
            if(ORUpdate.status__c == 'Draft'){
                OrReqStatus='Draft';
                system.debug('OrReqStatus=Draft');
            }
        }
        // Logic to update the parent status when the approver approves or rejects the request Starts
    }
    // ScoreCard Logic
    string RecipientContactStatus;
    if(Trigger.Isbefore) {
        integer GiftScore = 0;
        integer MealScore = 0;
        integer ProGiftScore = 0;
        integer ProMealScore = 0;
        integer GiftScoreSummary = 0;
        integer MealScoreSummary = 0;
        double GiftAggregateValue=0;
        double MEAggregateValue=0;
        boolean CheckForPending = false;
        integer RecentGiftValue = 0;
        integer RecentMealValue = 0;
        integer OldGiftValue = 0;
        integer oldMealValue = 0;
        String RecipientNumber = '';
        //id RecParentId;
        id RecipientContactId;
        id CurrentRecipientContactId;
        id CurrentRecipientId;
        list<GH_Request_Recipient__c> lstGHReqRecip = new list<GH_Request_Recipient__c>();
        for(GH_Request_Recipient__c rec: Trigger.New) {
            //Score logic
            List<integer> giftMealValues = GHAPPOperations.calculateScore(rec);
            
            system.debug('---->'+ giftMealValues[0]);
            rec.Gift_Score__c = giftMealValues[0];
            rec.Meal_Score__c = giftMealValues[1];
            //Score logic Ends
           // RecParentId = rec.GH_Request__c;
            RecipientContactId = rec.Name_of_Recipient_Lookup__c;
            RecipientContactStatus = rec.Status__c;
            CurrentRecipientId = rec.Id;
            if(trigger.isUpdate){
                CurrentRecipientContactId=rec.Name_of_Recipient_Lookup__c;
                RecipientNumber=rec.Name;
            }
            system.debug('rec.Gift_Value_of_gift__c--->' + rec.Gift_Value_of_gift__c);
            if(rec.Gift_Value_of_gift__c != null){
                RecentGiftValue = integer.valueOf(rec.Gift_Value_of_gift__c);
            }    
            if(rec.ME_Value_of_Meals_Entertainment__c != null){
                RecentMealValue = integer.valueOf(rec.ME_Value_of_Meals_Entertainment__c);  
            }
            
        }
        if(RecipientContactId != null) {
            date TodaysDate = system.today().addDays(-365);
            
            List<GH_Request_Recipient__c> RecipientList = [Select Id,Name,Company__c,Country__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,
                                                           Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,
                                                           Gift_Value_of_gift__c,Gift_Description__c, Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,
                                                           ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,
                                                           ME_Value_of_Meals_Entertainment__c, ME_Description__c, ME_Business_Purpose__c, ME_Additional_Comments__c,Name_of_Recipient__c,Name_of_Recipient_Lookup__c,
                                                           Position__c,Gift_Score__c,Meal_Score__c,Status__c,Type_of_Gift__c,CreatedDate, GH_Request__r.SBU__c, GH_Request__r.SBG__c, 
                                                           Pro_Gift_Embarrassing_If_Public__c,Pro_Gift_Manager_Approved_Gift__c, Pro_Gift_Occasion_Award_Placement__c, Pro_Gift_Occasion_Business_Meeting__c, Pro_Gift_Offered_To_Spouse__c, 
                                                           Pro_Gift_Value_of_Gift__c, Pro_Meal_Description__c, Pro_ME_Embarrassing_If_Public__c, Pro_ME_Manager_Approved__c, Pro_ME_Occasion_Award_Placement__c, 
                                                           Pro_ME_Occasion_Business_Meeting__c,Pro_ME_Offered_To_Spouse__c, Pro_ME_Solicited_By_You__c, Pro_ME_Value_of_Meal_Entertainment__c
                                                           from GH_Request_Recipient__c where Name_of_Recipient_Lookup__c =:RecipientContactId AND CreatedDate >: TodaysDate AND GH_Request__r.status__c != 'Modified' AND status__c != 'Cancelled' AND status__c != 'Rejected' AND status__c != 'Pending' ];
            
                                                   
            if(RecipientList.size() > 0) {
                for(GH_Request_Recipient__c gr: RecipientList) {
                    if(gr.Gift_Score__c != null) {
                        GiftScoreSummary += integer.valueOf(gr.Gift_Score__c);  
                    }
                    if(gr.Meal_Score__c != null) {
                        MealScoreSummary += integer.valueOf(gr.Meal_Score__c);
                    }
                    if(gr.Gift_Value_of_gift__c != null){
                        GiftAggregateValue+= double.valueOf(gr.Gift_Value_of_gift__c);
                    }
                    if(gr.ME_Value_of_Meals_Entertainment__c != null){
                        MEAggregateValue+= double.valueOf(gr.ME_Value_of_Meals_Entertainment__c);
                    }
                }
                system.debug('>>>GiftAggregateValue>>>>'+GiftAggregateValue+'>MEAggregateValue>>>'+ MEAggregateValue);
            }



            
            if((RecipientContactStatus == 'Approved' && Trigger.isUpdate) || (Trigger.isInsert)){ 
                system.debug('In condition-->'); 
                List<GH_Request_Recipient__c> pandingRecipientList = [Select Id, Gift_Twelve_Months_Aggregate_Value__c, ME_Twelve_Months_Aggregate_Value__c
                                                               from GH_Request_Recipient__c where Name_of_Recipient_Lookup__c =:RecipientContactId AND CreatedDate >: TodaysDate AND GH_Request__r.status__c = 'Pending' and id !=: CurrentRecipientId];
                system.debug('In pandingRecipientList-->' + pandingRecipientList);       
            
                                                  
                List<GH_Request_Recipient__c> pandingRecipientListToUpdate = new List<GH_Request_Recipient__c>();
                for(GH_Request_Recipient__c pendingRec: pandingRecipientList){
                    //pendingRec.Gift_Twelve_Months_Aggregate_Value__c = GiftAggregateValue; //To avoid update from overriding the total value
                    //pendingRec.ME_Twelve_Months_Aggregate_Value__c = MEAggregateValue; //To avoid update from overriding the total value
                    pandingRecipientListToUpdate.add(pendingRec);
                    system.debug('In adding rec-->' + pendingRec); 
                }
                if(pandingRecipientListToUpdate.size() > 0){
                    try{
                        system.debug('In pandingRecipientListToUpdate---> here');
                        update pandingRecipientListToUpdate;
                    }catch(Exception ex){
                        system.debug('Error while updating Aggregate Value for Pending Records:' + ex.getMessage());
                    }
                }
                
            }
        }


        
        
                
        if(Trigger.isInsert || Trigger.isUpdate){
            for(GH_Request_Recipient__c rec: Trigger.New) {
                system.debug('rec.Status__c----->' + rec.Status__c);
                if(rec.Status__c == 'Submitted' || rec.Status__c == 'Draft' || (rec.Status__c == 'Approved' && rec.Approver_Name__c == null)) {
                    rec.Three_Months_Gift_Score__c = GiftScoreSummary;
                    rec.Three_Months_Meal_Score__c = MealScoreSummary;
                    //rec.Gift_Twelve_Months_Aggregate_Value__c=GiftAggregateValue;// + RecentGiftValue;//Excluding current value
                    //rec.ME_Twelve_Months_Aggregate_Value__c=MEAggregateValue;// + RecentMealValue; //Excluding current value
                       
                    /*   
                    if(Label.GH_Request_Org == 'AERO') {
                        rec.Status__c = 'Pending';
                        rec.Gift_Needs_Approval__c = true;
                        rec.ME_Needs_Approval__c = true;
                    }
                    */
                    /***********Start*********Receiver Qualifier*******************************************************/
                    if(rec.Gift_Recipient__c != true){ 
                        if(rec.Gifts__c == true){ // If Gift is Checked
                            
                            if(currentUserDetails.SBU_User__c == Label.GH_D_S && currentUserDetails.SBG__c == Label.GH_Aero){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                //system.debug('Is the value of this gift within your SEA guidelines?');
                                
                            }
                            // Is the value of this gift within your SEA guidelines?
                            else if(rec.Gift_Line_Manager_Informed__c != true){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('Is the value of this gift within your SEA guidelines?');
                            }
                            // if 12 months Gift Aggregate value is more than $300 
                            else if(rec.Gift_Twelve_Months_Aggregate_Value__c > double.valueOf(Label.GH_GiftValueLimit)){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('if 12 months Gift Aggregate value is more than $300');
                            }
                            //if SBU equal D&S AND SBG equals Aero
                            else if(rec.GH_Request__r.SBU__c == Label.GH_D_S && rec.GH_Request__r.SBG__c == Label.GH_Aero){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('D&S and Aero');
                            }
                            // if Gift is offered to Spouse/Life Partner/Relative/Guest
                            else if(rec.Gift_Gift_offered_to_spouse__c == true) {
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('Gift_Gift_offered_to_spouse__c == true');
                                //rec.Gift_Needs_Approval__c = true;    
                            }
                            // If gift given to govt. official and value is more than $20
                            else if(rec.Gift_Gift_given_to_government_official__c == true && rec.Gift_Value_of_gift__c > 20) {
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                //rec.Gift_Needs_Approval__c = true;
                               // rec.ME_Needs_Approval__c = true; 
                                system.debug('Gift_given_to_government_official__c == true && rec.Gift_Value_of_gift__c > 20');
                            }
                            // if value of Gift is more than $150
                            else if(rec.Gift_Value_of_gift__c > 150) { 
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('Gift_Value_of_gift__c > 150');
                            }
                            
                            else if(CheckForPending == false){
                                system.debug('>>>>>> Inside Gift Qualifier' + rec.status__c);
                                rec.status__c = 'Approved';
                            }
                            CheckForPending=false;
                        }
                        
                        if(rec.Meals_Entertainment__c == true){ // If Meal/Entertainment is Checked
                            if(currentUserDetails.SBU_User__c == 'D&S' && currentUserDetails.SBG__c == 'Aero'){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                //system.debug('Is the value of this gift within your SEA guidelines?');
                                
                            }
                            // Is the value of this Meal within your SEA guidelines?
                            else if(rec.ME_Line_Manager_Informed__c != true){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('Is the value of this Meal within your SEA guidelines?');
                            }
                            // if 12 months Meal/Entertainment Aggregate value is more than $600
                            else if(rec.ME_Twelve_Months_Aggregate_Value__c > double.valueOf(Label.GH_MealValueLimit)){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('if 12 months Meal/Entertainment Aggregate value is more than $600');
                            }
                            //if SBU equal D&S AND SBG equals Aero
                            else if(rec.GH_Request__r.SBU__c == Label.GH_D_S && rec.GH_Request__r.SBG__c == Label.GH_Aero){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('D&S and Aero');
                            }
                            // if Meal is offered to Spouse/Lie Partner/Relative/Guest
                            else if(rec.ME_Travel_offered_to_spouse__c == true) {
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('ME_Travel_offered_to_spouse__c == true');
                                //rec.ME_Needs_Approval__c = true;  
                            }
                            // If meal given to govt. official and value is more than $20
                            else if(rec.ME_Travel_provided_to_government_officia__c == true && rec.ME_Value_of_Meals_Entertainment__c > 20){
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                //rec.Gift_Needs_Approval__c = true;
                               // rec.ME_Needs_Approval__c = true; 
                                system.debug('ME_given_to_government_official__c == true && rec.ME_Value_of_Meals_Entertainment__c > 20');
                            }
                            // if value of Meal is more than $150
                            else if(rec.ME_Value_of_Meals_Entertainment__c > 150) {
                                rec.Status__c = 'Pending';
                                CheckForPending = true;
                                system.debug('ME_Value_of_Meals_Entertainment__c > 150');
                            }
                            
                            else if(CheckForPending == false){
                                system.debug('>>>>>> Inside Meal Qualifier' + rec.status__c);
                                rec.status__c = 'Approved';
                            }
                            CheckForPending=false;
                        }                   
                    }
                    /***********End*********Reciever Qualifier*******************************************************/
                    /*********************************Start****Provider Qualifier*********************************************/
                    if(rec.Gifts__c == true && rec.Gift_Recipient__c == true){
                        if(rec.Pro_Gift_Solicited_By_You__c == true){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_Gift_Solicited_By_You__c == true');
                        }
                        else if(rec.Pro_Gift_Embarrassing_If_Public__c == true){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_Gift_Embarrassing_If_Public__c == true');    
                        }
                        else if(rec.Pro_Gift_Offered_To_Spouse__c == true){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_Gift_Offered_To_Spouse__c == true');    
                        }
                        else if(rec.Pro_Gift_Value_of_Gift__c > 150){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_Gift_Value_of_Gift__c > 150');                             
                        }
                        else if(rec.Pro_Gift_Manager_Approved_Gift__c != true && rec.Pro_Gift_Value_of_Gift__c > 150){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_Gift_Manager_Approved_Gift__c != true && rec.Pro_Gift_Value_of_Gift__c > 150');    
                        }
                        else if(CheckForPending == false){
                            rec.status__c = 'Approved';
                        }
                        CheckForPending=false;
                    }
                    if(rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == true){
                        if(rec.Pro_ME_Solicited_By_You__c == true){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_ME_Solicited_By_You__c == true');
                        }
                        else if(rec.Pro_ME_Embarrassing_If_Public__c == true){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_ME_Embarrassing_If_Public__c == true');    
                        }
                        else if(rec.Pro_ME_Offered_To_Spouse__c == true){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_ME_Offered_To_Spouse__c == true');    
                        }
                        else if(rec.Pro_ME_Value_of_Meal_Entertainment__c > 150){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_ME_Value_of_Meal_Entertainment__c > 150');                             
                        }
                        else if(rec.Pro_ME_Manager_Approved__c != true && rec.Pro_Gift_Value_of_Gift__c > 150){
                            rec.status__c= 'Pending';
                            CheckForPending = true;
                            system.debug('Pro_ME_Manager_Approved__c != true && rec.Pro_Gift_Value_of_Gift__c > 150');    
                        } 

                        else if(CheckForPending == false){
                            rec.status__c = 'Approved';
                        }
                        CheckForPending=false;
                    }
                    /**********End****Provider Qualifier******************/
                    
                } 
            }

            
            
        }   
    }
}