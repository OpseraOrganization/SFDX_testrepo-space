trigger Case_Prevent_Creation on Case ( before insert, before update) {
/*commenting inactive trigger code to improve code coverage-----
   //checking records having subject
   //Igloo Code-SR 427733
   
if(trigger.isupdate )
{
for(case cas:trigger.new){
//System.debug('Case_Prevent_Creation : '+cas.closed__c);
  if((cas.Emailbox_Origin__c=='Email-Orders')&&(cas.SBU__c=='BGA')&& UserInfo.getUserId() == label.aero_default_user_id 
            && cas.Region__c!='Asia/Pacific Rim' && (cas.PreventCloseonupdate__c <7 )
             && (cas.Account_Concierge__c=='False' && cas.Account_Type__c!='Owner/Operator'))
                {
                 cas.Resolution__c='None';
                 cas.status='Closed';
                 cas.Sub_Class__c='';
                 cas.Export_Compliance_Content_ITAR_EAR__c='No';
                 cas.Government_Compliance_SM_M_Content__c='No';
                cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c+1;
                
                 caseshare objA350CaseShare = new CaseShare();
                    objA350CaseShare.CaseAccessLevel = 'Edit';
                    objA350CaseShare.UserorGroupid = label.CSO_GRP_ID;
                    objA350CaseShare.caseid = cas.id;
                    insert objA350CaseShare;
}
 if((cas.Emailbox_Origin__c=='Email-Order Status')&&(cas.SBU__c=='BGA' || cas.SBU__c=='D&S') && 
 UserInfo.getUserId() == label.aero_default_user_id && cas.Region__c!='Asia/Pacific Rim' && (cas.PreventCloseonupdate__c <7 )
  )
                {
                 cas.Resolution__c='None';
                 cas.status='Closed';
                 cas.Sub_Class__c='';
                 cas.Export_Compliance_Content_ITAR_EAR__c='No';
                 cas.Government_Compliance_SM_M_Content__c='No';
                  cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c+1;
                  
                 caseshare objA350CaseShare = new CaseShare();
                    objA350CaseShare.CaseAccessLevel = 'Edit';
                    objA350CaseShare.UserorGroupid = label.CSO_GRP_ID;
                    objA350CaseShare.caseid = cas.id;
                    insert objA350CaseShare;
}
     if((cas.Emailbox_Origin__c=='Email-Quotes') && UserInfo.getUserId() == label.aero_default_user_id && cas.ContactId != null
           && cas.Account_Concierge__c != 'True' && (cas.SBU__c == 'D&S' || cas.SBU__c == 'ATR') && cas.SBU__c != 'BGA' && cas.Region__c!='Asia/Pacific Rim'&& (cas.PreventCloseonupdate__c <7 ) )
 {
      if (cas.Origin=='Email')    
                {
                system.debug('SUBJECT : '+cas.Subject);
                system.debug('Owner1: '+cas.OwnerID);
                cas.Resolution__c='None';
                cas.status='Closed';
                cas.Sub_Class__c='';
                cas.Export_Compliance_Content_ITAR_EAR__c='No';
                cas.Government_Compliance_SM_M_Content__c='No';
                 cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c+1;
                
                 caseshare objA350CaseShare = new CaseShare();
                    objA350CaseShare.CaseAccessLevel = 'Edit';
                    objA350CaseShare.UserorGroupid = label.CSO_GRP_ID;
                    objA350CaseShare.caseid = cas.id;
                    insert objA350CaseShare;
                }
    }
     if((cas.Emailbox_Origin__c=='Email-Quotes') && UserInfo.getUserId() == label.aero_default_user_id && cas.ContactId != null
           && cas.SBU__c == 'BGA' && cas.Account_Type__c != 'Owner/Operator' && cas.Account_Concierge__c != 'True'&& cas.Region__c!='Asia/Pacific Rim' && (cas.PreventCloseonupdate__c <7 ))
 {
      if (cas.Origin=='Email')    
                {
                system.debug('SUBJECT : '+cas.Subject);
                system.debug('Owner1: '+cas.OwnerID);
                cas.Resolution__c='None';
                cas.status='Closed';
                cas.Sub_Class__c='';
                cas.Export_Compliance_Content_ITAR_EAR__c='No';
                cas.Government_Compliance_SM_M_Content__c='No';
                 cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c+1;
                
                 caseshare objA350CaseShare = new CaseShare();
                    objA350CaseShare.CaseAccessLevel = 'Edit';
                    objA350CaseShare.UserorGroupid = label.CSO_GRP_ID;
                    objA350CaseShare.caseid = cas.id;
                    insert objA350CaseShare;
                }
    }
}
//Igloo Code SR 427733 ends
}              
else{      
 list<case_lookup__c> Lookuplist= new list<case_lookup__c>(); 
 Lookuplist=[select subject__c from case_lookup__c];
 String sub;
 try{
 for( Case e:Trigger.new){
 System.debug('Case_Prevent_Creation : '+e.ownerId); 
 System.debug('Case Origin : '+e.Origin);
 System.debug('Record Type ID : '+e.Recordtypeid);
 System.debug('Mail Box Name : '+e.Mail_Box_Name__c);
  for(integer i=0;i<Lookuplist.size();i++)
    {
    
    
     if(e.subject != null   && (e.origin=='Email-CPSQuotesCOE'   || e.origin=='Email-CPSQuotesCOEANNTMPTUC'||
      e.origin=='Email-CPSQuotesCOEDVCR'   ||  e.origin=='Email-CPSQuotesCOEPHX' )){
     if(e.subject.contains('has sent fax')){
      e.subject.addError('Email Message having success for Fax Creation not needed'); 
      
      }
  }
  if(e.subject != null&&((e.origin=='Email-GDC FS1')||(e.origin=='Email-GDC FS')||(e.origin=='Email-GDC GFO'))){
     if((e.subject.contains('Reservation Details'))||(e.subject.contains('Acquire Reservation'))||(e.subject.contains('Confirm Reservation'))||(e.subject.contains('Blackberry Summary'))||(e.subject.contains('FAA Command Center Message'))||(e.subject.contains('Global Data Center CDM'))||(e.subject.contains('Global Data Center FS Daily'))||(e.subject.contains('ITF Trip'))||(e.subject.contains('Flight Plan Summary'))||(e.subject.contains('Undelivered Mail Return to Sender'))||(e.subject.contains('Western Service Area Outlook'))||(e.subject.contains('[NBAA-GADesk]'))||(e.subject.contains('Email/Manual Fax'))||(e.subject.contains('Scan From a Xerox Workcentre'))||(e.subject.contains('FrontierMedex'))||(e.subject.contains('TRC Report'))||(e.subject.contains('Western Service Area Outlook'))||(e.subject.contains('FAA COMMAND CENTER MESSAGE'))||(e.subject.contains('Mail System Error'))){
      e.subject.addError('Spam Message should not create case'); 
      }
      if((e.origin=='Email-GDC FS')||(e.origin=='Email-GDC GFO')){
      if((e.subject.contains('ADNS MESSAGE TO KSNAXGXS'))||(e.subject.contains('FAA ICAO FPL ACK'))||(e.subject.contains('FAA ICAO FPL REJ'))||(e.subject.contains('Updated Manual Fax'))||(e.subject.contains('New Manual Fax'))||(e.subject.contains('Fax Status Alert'))||(e.subject.contains('Manual PKG:'))){ 
        e.subject.addError('Spam Message should not create case');   
      }
      }
      if(e.origin=='Email-GDC FS'){
      if((e.subject.contains('XOJET MSG'))||(e.subject.contains('FS MESSAGE'))){
       e.subject.addError('Spam Message should not create case'); 
      }
      }
      if(e.origin=='Email-GDC GFO'){
      if((e.subject.contains('NET JET MSG'))||(e.subject.contains('OTHER MSG'))||(e.subject.contains('Flight Plan Request'))||(e.subject.contains('Weather Request -'))||(e.subject.contains('Submission From'))){
       e.subject.addError('Spam Message should not create case'); 
      }
      }
      if(e.origin=='Email-GDC FS1'){
      if((e.subject.contains('New ITF trip for'))||(e.subject.contains('ITF trip changed'))){
       e.subject.addError('Spam Message should not create case'); 
      }
  }      
}
 if((e.subject != null)&&(e.origin=='Email-SFDC_CustomerMaster')&&(e.subject.contains('Contract Expiration Mail'))){
  e.subject.addError('Spam Message should not create case'); 
  }
  if((e.SuppliedEmail=='george.risinger@honeywell.com')||(e.SuppliedEmail=='APISConfirmNoReply@dhs.gov')||(e.SuppliedEmail=='news@aviationnews.us'))
  e.subject.addError('Spam Message should not create case');  
   
/************************** Added For Dual Criteria ************************  
  if((e.SuppliedEmail=='gfo@mygdc.com') || (e.SuppliedEmail=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
      if((e.subject.contains('Flight Plan Request'))||(e.subject.contains('Weather Request -'))||(e.subject.contains('Submission From'))){
          e.subject.addError('Spam Message should not create case');    
      }
  }  
/************************** Added For Dual Criteria ************************  

/************************** Added For gdc.accounts@honeywell.com ***********************
    if((e.SuppliedEmail=='CTSEFTCW@HONEYWELL.COM') || (e.SuppliedEmail=='wawfnoreply@csd.disa.mil')){
      if((e.origin == 'Email-GDC Accounts')){
          e.subject.addError('Spam Message should not create case');    
      }
    }
/************************** Added For gdc.accounts@honeywell.com ************************
    
    sub='';
        if(e.subject != NULL){
        
        sub=e.subject;
        sub =  sub.toUpperCase();
            if(Lookuplist[i].subject__C !=null){
            Lookuplist[i].subject__C =  Lookuplist[i].subject__C.toUpperCase();
                   if( sub.contains(   Lookuplist[i].subject__C))
                  {                      
                     e.subject.addError('Email Message with subject Out Of Office Cannot be created');                    
                  }  
             }
             //Added Code for Services
   
     if((sub.contains('USER') && sub.contains('HAS DOWNLOADED') && sub.contains('MORE THAN') && sub.contains('TIMES')) || (sub.contains('ACCOUNT TO INDS') && !(sub.contains('RE:'))  && !(sub.contains('FW:')) && !(sub.contains('FWD:'))) )
      {
       e.subject.addError('Email Message with Junk Subjects Cannot be created');                 
      }
    
    }
    

                
 }// end for  
                System.debug('Case Origin 2: '+e.Origin);
                System.debug('Record Type ID 2: '+e.Recordtypeid);
                System.debug('Mail Box Name 2: '+e.Mail_Box_Name__c); 
                //code for 427733 starts
                System.debug('Email Origin'+e.Emailbox_Origin__c);
                System.debug('Origin '+e.Origin);                

                //code ends 427733
 
 }
 }
catch(exception e)
{
System.debug('Exception occured '+e);
}
}*/
}