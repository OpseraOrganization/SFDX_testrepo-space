/** * File Name: ServiceRequest_Autopopulate
* Description :Trigger to autopopulate account,contact details from case
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
trigger ServiceRequest_Autopopulate on Service_Request__c (before insert,before update) {
//variable declarations
List<Id> caseId =new List<Id>();
List<Case> cases= new List<Case> ();
List<Id> contactId =new List<Id>();
List<Contact> contacts= new List<Contact> ();
Integer contactSize=0,caseSize=0;

    for( Service_Request__c  serviceRequests:Trigger.new){
    String strProfileId = string.valueof(Userinfo.getProfileId()).substring(0,15);
    if(serviceRequests.Clone_Button_clicked__c ==false && serviceRequests.recordtypeid=='01230000000ZewM' && strProfileId !='00e30000001WnJr' && strProfileId != '00e30000001WnJq')
    {
        /* if(serviceRequests.HON_Commit_Date__c==null)
        {
            serviceRequests.HON_Commit_Date__c.addError('You must enter a value');                   
        }*/ 
        if(serviceRequests.Customer_Due_Date__c==null)
        {
            serviceRequests.Customer_Due_Date__c.addError('You must enter a value');                   
        }
    }
    if(serviceRequests.Status_Resolution__c==null)
        serviceRequests.Is_Resolution_Blank__c=true;
    else
     serviceRequests.Is_Resolution_Blank__c=false;
     string srowner = serviceRequests.OwnerId;
     if(srowner.SubString(0,3) == '005'){
    serviceRequests.OwnerId__C= serviceRequests.OwnerId;
    }
      // getting the Case Numbers
      if(serviceRequests.Case_Number__c !=null   ){
      caseId.add(serviceRequests.Case_Number__c);
      }
      // getting the Contacts 
      if( serviceRequests.Contact_Name__c!=null) {
      contactId.add(serviceRequests.Contact_Name__c);
      }
    // Code start for INC000005904686 and INC000005904714
    if(Trigger.isinsert ||( Trigger.isupdate && Trigger.OldMap.get(serviceRequests.id).Ownerid != serviceRequests.Ownerid ))
    {
      If ((serviceRequests.Ownerid ==Label.EPS_ATR_Queue)||(serviceRequests.Ownerid ==Label.EPS_BGA_Queue)||(serviceRequests.Ownerid ==Label.EPS_D_S_Queue))
      {
      serviceRequests.EPS_Start_Time__c = System.Now();
      serviceRequests.EPS_End_Time__c = Null;
      }
      
      If (Trigger.isupdate  &&  ((Trigger.OldMap.get(serviceRequests.id).Ownerid ==Label.EPS_ATR_Queue && serviceRequests.Ownerid != Label.EPS_ATR_Queue)
      ||(Trigger.OldMap.get(serviceRequests.id).Ownerid ==Label.EPS_BGA_Queue && serviceRequests.Ownerid != Label.EPS_BGA_Queue)
      ||(Trigger.OldMap.get(serviceRequests.id).Ownerid ==Label.EPS_D_S_Queue && serviceRequests.Ownerid != Label.EPS_D_S_Queue))){
      serviceRequests.EPS_End_Time__c = System.Now();
      }
    }
    //Added for SR INC000006554098 
    if(serviceRequests.Status__c=='Open' && (serviceRequests.Ownerid==label.EPS_ATR_Queue || serviceRequests.Ownerid==label.EPS_BGA_Queue || serviceRequests.Ownerid==label.EPS_D_S_Queue))
    {    
    serviceRequests.SR_Phase__c = 'EPS Queue';
    }
else if (serviceRequests.Status__c != 'Closed' && (serviceRequests.Gate_1_Completion_Date__c == null ) && (serviceRequests.Gate_2_Completed__c == null))
{  
    serviceRequests.SR_Phase__c = 'Investigation';
    }
else if (serviceRequests.Status__c != 'Closed' && (serviceRequests.Gate_1_Completion_Date__c != null) && (serviceRequests.Gate_2_Completed__c == null) && (serviceRequests.CSB_Gate__c != 'Gate 3'))
{    
    serviceRequests.SR_Phase__c = 'Root Cause';
    }
else if (serviceRequests.Status__c != 'Closed' && (serviceRequests.CSB_Gate__c == 'Gate 3') && (serviceRequests.Key_Code__c == null))
{   
    serviceRequests.SR_Phase__c = 'SRD Queue';
    }
else if (serviceRequests.Status__c != 'Closed' && (serviceRequests.Key_Code__c != null) && (serviceRequests.CSB_Gate__c == 'Gate 3' || serviceRequests.CSB_Gate__c == 'Gate 4' || serviceRequests.CSB_Gate__c == 'Gate 5'))
{    
    serviceRequests.SR_Phase__c = 'SRD';
    }
else if (serviceRequests.Status__c == 'Closed' && (serviceRequests.Gate_2_Completed__c == null) && (serviceRequests.SR_Age__c < 91))
{    
    serviceRequests.SR_Phase__c = 'EPS Resolved';
    }
else if (serviceRequests.Status__c == 'Closed' && (serviceRequests.Gate_2_Completed__c != null) && (serviceRequests.SR_Age__c < 91))
{    
    serviceRequests.SR_Phase__c = 'SRD Closed Last 90';
    }
else if (serviceRequests.Status__c == 'Closed' && (serviceRequests.SR_Age__c > 90))
{    
    serviceRequests.SR_Phase__c =  'Closed';
    } 
    //End of SR INC000006554098 
    }
    // end of for INC000005904686 and INC000005904714
// For Auto Population from Cases
if(caseId.size()>0){
//getting the data from Cases
cases=[Select Id ,accountId,contactId from Case where Id in:caseId]; 
 for(Service_Request__c  SR:Trigger.new){
  if(SR.Case_Number__c !=null  ){
      //auto populating account,cases
       caseSize=cases.size();
    for(integer i=0;i<caseSize;i++){
      if(cases[i].Id==SR.Case_Number__c){
        SR.Account_Name__c=cases[i].AccountId;
        SR.Contact_Name__c=cases[i].ContactId;
      }// end of if
     }//end of for  
   }// end of if
 }// end of for       
}// end of if
// end of autopopulation from Cases

// For Auto Population from Contacts
if(contactId.size()>0){
//getting the data from Contacts
contacts=[Select Id ,accountId from Contact where Id in:contactId]; 
 for(Service_Request__c  SRs:Trigger.new){
  if(SRs.Contact_Name__c!=null){
  //auto populating account
  contactSize=contacts.size();
    // Added for INC000008843002 - Start
    if(!(SRs.VOC_Card_Numb__c!=null && SRs.Account_Name__c!=null)) {
    // Added for INC000008843002 - End
        for(integer i=0;i< contactSize;i++){
          if(contacts[i].Id==SRs.Contact_Name__c){
            SRs.Account_Name__c=contacts[i].AccountId;
          }// end of if      
        }//end of for  
     }//end of if  
   }// end of if
 }// end of for       
}// end of if
// end of autopopulation from Contacts
// Condition added for Rejected time
    system.debug('@@@outside');
    for( Service_Request__c  serviceRequests:Trigger.new){
        
        if(Trigger.Old != null) {
            if(serviceRequests.Status__c == 'Open' && Trigger.OldMap.get(serviceRequests.id).Status__c != 'Rejected'){
                serviceRequests.TimeOpen__c= system.now();
                system.debug('@@@TimeOpen'+serviceRequests.TimeOpen__c);
            }
        }
        else if(Trigger.Old == null) {
            serviceRequests.TimeOpen__c= system.now();
        }
        if(Trigger.isupdate  && Trigger.OldMap.get(serviceRequests.id).Status__c == 'Open' && serviceRequests.Status__c == 'Rejected') {
            serviceRequests.TimeReject__c= system.now();
            serviceRequests.TimeRejectToOpen__c = null;
            system.debug('@@@TimeReject'+serviceRequests.TimeReject__c);
        }
        if(Trigger.isupdate  && Trigger.OldMap.get(serviceRequests.id).Status__c == 'Rejected' && (serviceRequests.Status__c == 'Open' || serviceRequests.Status__c == 'closed')) {
            serviceRequests.TimeRejectToOpen__c = system.now();
            system.debug('@@@TimeReject'+serviceRequests.TimeRejectToOpen__c );            
        }        
     }    
}// end of trigger