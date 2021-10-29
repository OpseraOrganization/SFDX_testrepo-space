/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : Update_OnBehalfendUserStatus 
* Description           : Trigger to update Initial values of the case
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
*                  1.0            Wipro                 Initial Version created
* 04-04-2013       1.1            NTT Data              Update for SR # 377532 - Pilot's Corner avionics
* 04-04-2013       1.2            NTT Data              Update for SR # 374448
* 04-23-2013       1.3            NTT Data              Update for SR # 380363   
* 04-23-2012       1.4            NTT Data              Update for SR # 389517 
* 05-07-2013       1.5            NTT Data              Update for SR # 370787 
* 05-22-2013       1.6            NTT Data              Update for SR # 373686
* 06-18-2013       1.7            NTT Data              Update for SR # 400669 
* 10-09-2013       1.8            NTT Data              Update for SR # 403268
* 10-10-2013       1.9            NTT Data              Update for SR # 405714
***********************************************************************************************************/
trigger Update_OnBehalfendUserStatus on Case (before insert,before update) 
{/*commenting inactive trigger code to improve code coverage-----
   if (!StopRecursivecall.hasUpdate_OnBehalfendUserStatus()) 
   {
     StopRecursivecall.setUpdate_OnBehalfendUserStatus();
      list<id> listcntid=new list<id>();           
    for(Case cases:Trigger.New){

       //Code Added for SR 380363 Starts
        if(Trigger.isinsert || (Trigger.isupdate && (Trigger.OldMap.get(cases.Id).Aircraft_Name__c != cases.Aircraft_Name__c))){
        List<Fleet_Asset_Detail__c> lstFleet = [Select Make__c,Model__c,Tail_Number__c,Serial_Number__c,Base_ICAO__c from Fleet_Asset_Detail__c where id = : cases.Aircraft_Name__c ];
        if(lstFleet!=null && lstFleet.size()>0)
        {
            Fleet_Asset_Detail__c objFleet = lstFleet.get(0);
            cases.Make__c = objFleet.Make__c;
            cases.Model__c = objFleet.Model__c;
            cases.Tail__c = objFleet.Tail_Number__c;
            cases.Serial_Number__c = objFleet.Serial_Number__c;
            cases.Aircraft_Base_ICAO__c = objFleet.Base_ICAO__c;
        }
        }
        if(Trigger.isinsert || (Trigger.isupdate && (System.Trigger.OldMap.get(cases.Id).Opportunity__c != System.Trigger.NewMap.get(cases.Id).Opportunity__c))){
        List<Account> lstAcct = [Select name from account where id in (select dealer_account__c from Opportunity where id = : cases.Opportunity__c)];
        if(lstAcct!=null && lstAcct.size()>0)
        {
            Account objAcct = lstAcct.get(0);
            cases.BGA_Dealer_Name__c = objAcct.name;
        }
        }
        //Code Added for SR 380363 Ends     
        // Code for SR#403268 Starts
        if (Trigger.isUpdate && cases.RecordTypeId==Label.NavDB_Prod_RecordId){
          if (Trigger.OldMap.get(cases.Id).Status =='Closed' && cases.Status == 'Re-open'){
                cases.Reopen_Status_Started__c = System.Now();
                cases.Reopen_Status_ended__c =  null;
          }      
          if (Trigger.OldMap.get(cases.Id).Status =='Re-open' && cases.Status == 'Closed')
               { 
                cases.Reopen_Status_ended__c =  System.Now();
               }
      }          
      // Code for SR#403268 Ends 
                
        // Code Added for SR#370787 Start
        if((Trigger.isinsert ||( Trigger.isupdate && Trigger.OldMap.get(cases.Id).Sub_Status__c != cases.Sub_Status__c)) && cases.Case_Record_Type__c=='Engine Rentals')
          {
           DateTime currDate = System.Now();
           if (cases.Status== 'On Hold')
           {
             if(cases.Sub_Status__c=='Shipment')
             {
               cases.Shipment_Sub_Status_Selected__c = currDate;
               cases.Shipment_Sub_Status_Ended__c = Null;
             }
             if(cases.Sub_Status__c=='Removal')
             {
               cases.Removal_Sub_Status_Selected__c = currDate;
               cases.Removal_Sub_Status_Ended__c = Null;
             }
             if( cases.Sub_Status__c=='Other')
             {
               cases.Others_Sub_Status_Selected__c = currDate;
               cases.Others_Sub_Status_Ended__c = Null;
             }
             if (cases.Sub_Status__c=='DSO')
             {
               cases.DSO_Sub_Status_Selected__c = currDate;
               cases.DSO_Sub_Status_Ended__c = Null;
             }
          }
        if(trigger.isupdate && cases.Case_Record_Type__c=='Engine Rentals')
         {
         if (cases.Shipment_Sub_Status_Selected__c !=Null)
          {
           if ((cases.Status=='On Hold'&& (cases.Sub_Status__c!='Shipment' && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Shipment'))|| 
            ((cases.Status!='On Hold' && System.Trigger.oldMap.get(cases.Id).Status =='On Hold') && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Shipment'))
             {
                cases.Shipment_Sub_Status_Ended__c = currDate;
             }
          }
         if (cases.Removal_Sub_Status_Selected__c !=Null)
          {
           if ((cases.Status=='On Hold'&& (cases.Sub_Status__c!='Removal' && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Removal'))|| 
            ((cases.Status!='On Hold' && System.Trigger.oldMap.get(cases.Id).Status =='On Hold') && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Removal'))
             {
                cases.Removal_Sub_Status_Ended__c = currDate;
             }
          } 
         if (cases.DSO_Sub_Status_Selected__c !=Null)
          {
           if ((cases.Status=='On Hold'&& (cases.Sub_Status__c!='DSO' && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='DSO'))|| 
            ((cases.Status!='On Hold' && System.Trigger.oldMap.get(cases.Id).Status =='On Hold') && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='DSO'))
             {
                cases.DSO_Sub_Status_Ended__c = currDate; 
             } 
          } 
        if (cases.Others_Sub_Status_Selected__c !=Null)
          {
           if ((cases.Status=='On Hold'&& (cases.Sub_Status__c!='Other' && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Other'))|| 
            ((cases.Status!='On Hold' && System.Trigger.oldMap.get(cases.Id).Status =='On Hold') && System.Trigger.oldMap.get(cases.Id).Sub_Status__c =='Other'))
             {
                cases.Others_Sub_Status_Ended__c = currDate; 
             } 
          }
         }  
       }
      // Code Added for SR#370787 End

 listcntid.add(cases.Requested_By_HON_Internal__c);
 
 if(Trigger.Isinsert)
 {
    // Code added for the ticket SR #389517 starts
    if(cases.origin == 'Email-deferredordersweb' || cases.Emailbox_Origin__c == 'Email-deferredordersweb')
    {
        if(cases.subject!=null && cases.subject.trim() != '' && (cases.Sales_Order_Number__c==null || cases.Sales_Order_Number__c=='') && (cases.Product_Part_Number__c==null || cases.Product_Part_Number__c =='') && (cases.Customer_PO_RO_WONumber__c==null || cases.Customer_PO_RO_WONumber__c== '') && (cases.Reason_for_hold__c==null || cases.Reason_for_hold__c==''))
        {
            String strEmailSubject ='';
            Integer intStartIndex;
            String strFieldValues;
            List<String> lstFieldValues;
            strEmailSubject = cases.subject;
            intStartIndex = strEmailSubject.lastIndexOfIgnoreCase('[');
            if(intStartIndex!=-1 && strEmailSubject.length() > intStartIndex)
            {
                strFieldValues = strEmailSubject.substring(intStartIndex+1,strEmailSubject.length()-1);
                lstFieldValues = strFieldValues.split('\\|');
                if(lstFieldValues.size() >= 4)
                {
                    cases.subject = strEmailSubject.substring(0,intStartIndex);
                    cases.Sales_Order_Number__c = lstFieldValues[0];
                    cases.Product_Part_Number__c = lstFieldValues[1];
                    cases.Customer_PO_RO_WONumber__c = lstFieldValues[2];
                    cases.Reason_for_hold__c = lstFieldValues[3];
                    if(lstFieldValues.size() == 5 && lstFieldValues[4]!= null && lstFieldValues[4].trim()!='')
                    {
                        if(lstFieldValues[4] == 'SPEX')
                        {
                            cases.SPEX_Exchange__c = True;
                        }
                    }
                }
            }
        }
     }
     // Code added for the ticket SR #389517 ends
 }
} 
list<Contact> ListCnts=[select id,Contact_Status__c from contact where id In : listcntid];
   for(Case cases: trigger.new )
  {
   for(integer i=0;i<ListCnts.size();i++){
     if(cases.Requested_By_HON_Internal__c==ListCnts[i].Id){
     cases.On_Behalf_of_End_User_Status__c=ListCnts[i].Contact_Status__c;

     }

}
       
    // Code added for SR # 377532 starts
            
    if(cases.RecordTypeId==label.Pilot_s_Corner_Avionics_RT_ID)
    {
        if(Trigger.Isinsert)
        {                 
            cases.type='Pilot\'s Corner Avionics';
            if(cases.Contactid !=null)
            {
                cases.Web_Portal_Avionics_Pilot_s_Corner__c=cases.Contactid;
                //cases.contact_func__c = cases.Contact_Function_Read__c;
            }
        }              
    
        if(Trigger.isUpdate && System.Trigger.OldMap.get(cases.Id).Contactid != cases.Contactid)
        {
            cases.Web_Portal_Avionics_Pilot_s_Corner__c=cases.Contactid;      
            if(cases.Contactid==null)              
            {
                cases.Contact_Func__c = null;
            }
            else
            {
                //cases.Contact_Func__c = cases.Contact_Function_Read__c;
            }
        }
    }
    if(Trigger.isUpdate && System.Trigger.OldMap.get(cases.Id).RecordTypeId != cases.RecordTypeId)
    {
        if(System.Trigger.OldMap.get(cases.Id).RecordTypeId == label.Pilot_s_Corner_Avionics_RT_ID)
        {                    
            cases.Web_Portal_Avionics_Pilot_s_Corner__c=null;
            cases.Contact_Func__c = null;
        }
        if(cases.RecordTypeId == label.Pilot_s_Corner_Avionics_RT_ID)
        {                    
            cases.Web_Portal_Avionics_Pilot_s_Corner__c=cases.Contactid;
            //cases.Contact_Func__c = cases.Contact_Function_Read__c;
        }
    }
    // Code added for SR # 377532 ends
    
    } 
    
    
    //code added for SR#374448 Start
      list<casehistory> casehis = new list<casehistory>();
      set<id> csow = new set<id>();
      for(case tt: system.trigger.new)
      {
          csow.add(tt.ownerid);
      }
    casehis = [select id, CreatedDate, oldvalue, newvalue, field, caseid from casehistory where caseid=:system.trigger.new and field=:'Status' order by createddate desc];  
      for(Case cs: system.Trigger.New)
      {
          if(cs.status=='On Hold')
          {
              
              if(casehis.size()>0 && casehis[0].newvalue=='On Hold')
              {
                  cs.Time_of_this_Hold__c = casehis[0].createddate;
              }
              else
              {
                  cs.Time_of_this_Hold__c = system.now();
              }
          }

          if((cs.type==null)||(cs.Time_of_first_Type_Change__c==null))
          {
              cs.Time_of_first_Type_Change__c = System.Now();
          }
                   
        else
          if(cs.id!=null)
           {
             if(trigger.oldmap.get(cs.Id).Time_of_first_Type_Change__c!=null && cs.Time_of_first_Type_Change__c!=trigger.oldmap.get(cs.Id).Time_of_first_Type_Change__c)
             {
              cs.Time_of_first_Type_Change__c = trigger.oldmap.get(cs.Id).Time_of_first_Type_Change__c;
             }
           }
           else
           if((cs.type==null)||(cs.Time_of_first_Type_Change__c==null))
           {
                cs.Time_of_first_Type_Change__c = System.Now();
           }
           
        } 
    }
    
    //SR#405714
    if(Trigger.isinsert){
        caseGDCTechIssueOps.updateDueDateonInsert(Trigger.New);
    }
    if(Trigger.isupdate){
        caseGDCTechIssueOps.updateDueDateAfterAssigned(Trigger.New, Trigger.OldMap);
    }
    //End SR#405714*/
}
//Code added for SR#374448 End