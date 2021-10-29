/** * File Name: FieldEvent_Autopopulate
* Description :Trigger to autopopulate account,contact details from case
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
* @author : Wipro
* Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
trigger FieldEvent_Autopopulate on Field_Event__c (before insert,before update) {
    //variable declarations
    List<Id> caseId =new List<Id>();
    List<Case> cases= new List<Case> ();
    List<Id> contactId =new List<Id>();
    List<Contact> contacts= new List<Contact> ();
    Integer contactSize=0,caseSize=0;
    Map<Id,case> caseMap = new Map<Id,Case>();
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
    for( Field_Event__c  fieldEvents:Trigger.new){
        fieldEvents.OwnerId__c=fieldEvents.OwnerId;
        // getting the Case Numbers  
        if(fieldEvents.Case_Number__c !=null )
            caseId.add(fieldEvents.Case_Number__c);
        // getting the Contacts 
        if(fieldEvents.Case_Number__c == null && fieldEvents.Contact__c!=null)
            contactId.add(fieldEvents.Contact__c);  
    }// end of for  
    // For Auto Population from Cases
    if(caseId.size()>0){
        //getting the data from Cases
        cases=[Select Id ,accountId,contactId,SBU_w2c__c,RecordTypeId,Supported_Products__r.id,Supported_Products__r.name,
        Owner.name,Region__c,Product_Type__c,Catalog_Product_Groups__c,Aircraft_Type__r.id,Aircraft_Tail_Number__c,
        Aircraft_Serial_Number__c,Description,Product_Part__c,Supported_Products__c,
        Case_Ref_ID__c,Owner.Email,Account.name,CaseNumber,Engine_Model__c from Case where Id in:caseId]; 
        for(case c : cases){
            caseMap.put(c.Id,c);
        }
        for(Field_Event__c  FE:Trigger.new){
            //auto populating account,cases
            if(FE.Case_Number__c !=null ){
                caseSize=cases.size();
                for(integer i=0;i<cases.size();i++){
                    if(cases[i].Id==FE.Case_Number__c){
                        FE.Account_Name__c=cases[i].AccountId;
                        FE.Contact__c=cases[i].ContactId;
                        if(FE.created_in_salesforce1__c ==true ){
                        FE.SBU_Impacted__c = cases[i].SBU_w2c__c;
                        FE.Supported_Products__c = cases[i].Supported_Products__r.id;
                        FE.Product_Type__c = cases[i].Product_Type__c;
                        FE.Catalog_Product_Group__c = cases[i].Catalog_Product_Groups__c;
                        FE.Aircraft_Type__c = cases[i].Aircraft_Type__r.id;
                        FE.Aircraft_Tail_Number__c = cases[i].Aircraft_Tail_Number__c;
                        FE.Aircraft_Serial_Number__c = cases[i].Aircraft_Serial_Number__c;
                        FE.Description_from_Case__c = cases[i].Description;
                        FE.Part_Number__c = cases[i].Product_Part__c;
                        if(cases[i].Engine_Model__c !=null){
                        FE.Engine_Model__c = cases[i].Engine_Model__c;
                        }else{
                        FE.Engine_Model__c = cases[i].Supported_Products__c;
                        }
                        }
                    }// end of if
                }//end of for  
                
                //********************GTO Usability Starts*****************************************
               /*if(Trigger.isInsert && FE.Field_event_Report__c==true && caseMap.get(FE.Case_Number__c).RecordTypeId==Label.TechnicalIssue_RecordTypeID){
                    String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                    String casUrl = strbaseURL+'/'+FE.Case_Number__c;
                    List<String> toAddressList = new List<String>();
                    toAddressList.add('DL-AEROC&PSTechOps-FieldEventReport@mail.Honeywell.com ');
                    toAddressList.add(caseMap.get(FE.Case_Number__c).Owner.Email);
                    Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();
                    message1.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    message1.setSaveAsActivity(false);
                    String sub='Field Event Report 1 '+caseMap.get(FE.Case_Number__c).Supported_Products__r.name+' '+caseMap.get(FE.Case_Number__c).Case_Ref_ID__c;
                    String body='Account Name : '+
                        caseMap.get(FE.Case_Number__c).Account.name+'<br></br>Case Number :<a href="'+casUrl+'"> '+
                        caseMap.get(FE.Case_Number__c).CaseNumber+'</a><br></br>Date of event :'+
                        FE.Event_Date__c +'<br></br>Engine Model : '+
                        caseMap.get(FE.Case_Number__c).Engine_Model__c+'<br></br>Engine/APU Reported SN : '+
                        FE.Engine_APU_Reported_S_N__c +'<br></br>Operational Symptom :  '+
                        FE.Operational_Symptom__c +'<br></br>Case Owner :  '+
                        caseMap.get(FE.Case_Number__c).Owner.name+'<br></br>Region :  '+
                        caseMap.get(FE.Case_Number__c).Region__c;
                    body=body+'</table></body></html>';       
                    message1.setSubject(sub);
                    message1.setHtmlBody(body); 
                    message1.setToAddresses(toAddressList);
                    system.debug('To Address'+toAddressList);
                    bulkEmails.add(message1);
                }  */
            }// end of if
        }// end of for       
    }// end of if
    // end of autopopulation from Cases
   
    if(bulkEmails.size()>0){
        Messaging.sendEmail(bulkEmails);
    }  
    
    // For Auto Population from Contacts
    if(contactId.size()>0){
        //getting the data from Contacts
        contacts=[Select Id ,accountId from Contact where Id in:contactId]; 
        for(Field_Event__c  FEs:Trigger.new){
            if( FEs.Case_Number__c==null && FEs.Contact__c!=null){
                //auto populating account
                contactSize=contacts.size();
                for(integer i=0;i<contactSize;i++){
                    if(contacts[i].Id==FEs.Contact__c){
                        FEs.Account_Name__c=contacts[i].AccountId;
                    }// end of if
                }//end of for  
            }// end of if
        }// end of for       
    }// end of if
    // end of autopopulation from Contacts
    
    //Added for Certido 334510 on June 2012
    for(Field_Event__c  fieldevent : Trigger.new){
        if(fieldevent.Report_Type__c == 'Wheels and Brakes (W&B)'){
            fieldevent.Product_Models__c = label.Product_Model;
        }
    }
    
}// end of trigger