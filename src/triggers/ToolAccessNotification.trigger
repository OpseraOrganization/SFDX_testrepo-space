/** * File Name: ToolAccessNotification
* Description Trigger - To send notification to Contact for changes in Tool Contact and send notification to Admin for any 
                        change in profile change 
* Copyright : TCS
* * @author : TCS
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
*                  1.0            TCS                 Initial Version created
* 
*************************************************************************************************************************************************
**/ 

trigger ToolAccessNotification on Contact (before update,after update) {
    string trimmedaddress;
    string [] trimaddress;
    string profileId = userinfo.getProfileId();
    boolean intcheck;
    string customLabel = Label.Data_Loading_Profile;
        //if(profileId.substring(0,profileId.length()-3) != customLabel){
    if(!customLabel.contains(profileId.substring(0,profileId.length()-3))){
        Contact newCon=Trigger.new[0];
        if (Trigger.isUpdate ){
            if(Trigger.isUpdate && Trigger.isAfter){
         
                if(newCon!=null && newCon.TOOLNAME1__c!=null && newCon.ToolStatus__c!=null && newCon.ToolId__c!=null && newCon.Tool_Image__c!=null &&
                 (Trigger.newMap.get(newCon.Id).ToolStatus__c!=Trigger.oldMap.get(newCon.Id).ToolStatus__c  || Trigger.newMap.get(newCon.Id).ToolId__c!=Trigger.oldMap.get(newCon.Id).ToolId__c )){
                             List<Contact_Tool_Access__c> toolList=[select Name,Portal_Tool_Master__r.name, Request_Status__c from Contact_Tool_Access__c where id=:newCon.ToolId__c];
                             //System.debug('toolList'+(toolList.get(0).Request_Status__c));
                             String emailid = newCon.Email;
                             String[] toAddresses = new String[] {emailid}; 
                    if (toolList.size()>0 ){
                             Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage(); 
                        if ((toolList.get(0).Request_Status__c)== 'Approved'){
                            System.debug('toolListappved'+(toolList.get(0).Request_Status__c));
                            if(newCon.TOOLNAME1__c == 'CONTRACTS/REPORTING (HAPP, MPP, MSP)'){
                            mail1.setTemplateId(label.ApprovedTool_Email_CONTRACTS_REPORTING_HAPP_MPP_MSP);
                            }
                            else if(newCon.TOOLNAME1__c == 'Warranty and Programs Claims/Credit Memo Access'){
                            mail1.setTemplateId(label.ApprovedTool_Email_Warranty_and_Programs_Claims_Credit_Memo_Access);
                            }
                            else
                            mail1.setTemplateId(label.ApprovedTool_Email_Templates); 
                        }
                        else
                            if ((toolList.get(0).Request_Status__c)== 'Denied'){
                            System.debug('toolListdenied'+(toolList.get(0).Request_Status__c));
                            if(newCon.TOOLNAME1__c == 'CONTRACTS/REPORTING (HAPP, MPP, MSP)'){
                            mail1.setTemplateId(label.DeniedTool_Email_CONTRACTS_REPORTING_HAPP_MPP_MSP);
                            }
                            else if(newCon.TOOLNAME1__c == 'Warranty and Programs Claims/Credit Memo Access'){
                            mail1.setTemplateId(label.DeniedTool_Email_Warranty_and_Programs_Claims_Credit_Memo_Access);
                            }
                            else
                                mail1.setTemplateId(label.DeniedToolEmailTemplate); 
                            }
                            else 
                            if ((toolList.get(0).Request_Status__c)== 'Pending'){
                            if(newCon.TOOLNAME1__c == 'CONTRACTS/REPORTING (HAPP, MPP, MSP)'){
                            mail1.setTemplateId(label.PendingTool_Email_CONTRACTS_REPORTING_HAPP_MPP_MSP);
                            }
                            else if(newCon.TOOLNAME1__c == 'Warranty and Programs Claims/Credit Memo Access'){
                            mail1.setTemplateId(label.PendingTool_Email_Warranty_and_Programs_Claims_Credit_Memo_Access);
                            }
                            else
                                    mail1.setTemplateId(label.PendingToolAccess);
                                }
                                
                                mail1.setSaveAsActivity(false);
                                 mail1.settargetObjectId(newCon.ID);
                                 mail1.setToAddresses(toAddresses);
                                 mail1.setOrgWideEmailAddressId(label.RegistrationAddress);                               
                                 //mail1.setTemplateId(label.ApprovedTool_Email_Templates);                          
                                 Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail1});
                    }
                }
            }
            
            Map<ID,Schema.RecordTypeInfo> rt= contact.sObjectType.getDescribe().getRecordTypeInfosById();
            string recordtypename;
           
            if(newcon.RecordTypeId!= Null){ //added for INC0001431963
                recordtypename = rt.get(newcon.RecordTypeId).getName();
            }   
             
             system.debug('Account id is '+newcon.Accountid);
             //Account_Email_Domains__c objemd=new Account_Email_Domains__c();
             string paddress=newcon.Primary_Email_Address__c;
                 //string taddress=newcon.TrimPriemail__c;
            if(paddress!=null)
            {
                trimaddress=paddress.split('@');
                trimmedaddress=trimaddress[1];
            }
             system.debug('trim address is '+trimmedaddress);
             
             //objemd=[select Internal_Email_Domain__c from Account_Email_Domains__c where Account__c=:newcon.Accountid and Account_Email_Domain__c=:taddress limit 1  ];
             list<Account_Email_Domains__c > objemd=[select Internal_Email_Domain__c from Account_Email_Domains__c where Account_Email_Domain__c=:trimmedaddress limit 1  ];
            if(objemd.size()>0)
            {
                intcheck=objemd[0].Internal_Email_Domain__c;
            }
            system.debug('listis '+objemd);
             //system.debug('object is '+objemd);
             //system.debug('Internal email domain is '+objemd.Internal_Email_Domain__c );
           system.debug('before update entry');
           system.debug('before update entry contact id is '+newCon.id);
            list<Portal_Honeywell_ID__c> pHid=new list<Portal_Honeywell_ID__c>();
            
            pHid=[select name from Portal_Honeywell_ID__c where Contact__c=:newCon.id];
            system.debug('portal HID is'+pHid);
                
            if(Trigger.isUpdate && Trigger.isBefore)
            {
                system.debug('entered before update');
    
                if (newcon.Honeywell_ID__c!= null && newCon.Address_Line_1__c != null && newCon.Primary_Email_Address__c!= null && newCon.Counter_on_update__c==0 
                       &&( (Trigger.newMap.get(newCon.Id).Address_Line_1__c!=Trigger.oldMap.get(newCon.Id).Address_Line_1__c ) ||
                           (Trigger.newMap.get(newCon.Id).Address_Line_3__c!=Trigger.oldMap.get(newCon.Id).Address_Line_3__c ) ||
                           (Trigger.newMap.get(newCon.Id).Primary_Email_Address__c!=Trigger.oldMap.get(newCon.Id).Primary_Email_Address__c) ||
                           (Trigger.newMap.get(newCon.Id).Address_Line_2__c!=Trigger.oldMap.get(newCon.Id).Address_Line_2__c) ||
                           (Trigger.newMap.get(newCon.Id).Name!=Trigger.oldMap.get(newCon.Id).Name) ||
                           (Trigger.newMap.get(newCon.Id).LastName!=Trigger.oldMap.get(newCon.Id).LastName) ||
                           (Trigger.newMap.get(newCon.Id).FirstName!=Trigger.oldMap.get(newCon.Id).FirstName) ||
                           (Trigger.newMap.get(newCon.Id).Phone_1__c!=Trigger.oldMap.get(newCon.Id).Phone_1__c) ||
                           (Trigger.newMap.get(newCon.Id).Phone_5__c!=Trigger.oldMap.get(newCon.Id).Phone_5__c) ||
                           (Trigger.newMap.get(newCon.Id).Postal_Code__c!=Trigger.oldMap.get(newCon.Id).Postal_Code__c) ||
                           (Trigger.newMap.get(newCon.Id).Country_Name__c!=Trigger.oldMap.get(newCon.Id).Country_Name__c) ||
                           (Trigger.newMap.get(newCon.Id).City_Name__c!=Trigger.oldMap.get(newCon.Id).City_Name__c) ||
                           (Trigger.newMap.get(newCon.Id).Contact_Function__c!=Trigger.oldMap.get(newCon.Id).Contact_Function__c) ||
                           (Trigger.newMap.get(newCon.Id).Organizational_Level__c!=Trigger.oldMap.get(newCon.Id).Organizational_Level__c) ||
                           (Trigger.newMap.get(newCon.Id).Country_Code__c!=Trigger.oldMap.get(newCon.Id).Country_Code__c) ||
                           (Trigger.newMap.get(newCon.Id).Account_Name__c!=Trigger.oldMap.get(newCon.Id).Account_Name__c)
                       ) &&  (pHid.size() > 0 || Test.isRunningTest()) && ((newcon.Contact_Is_Employee__c==false || recordtypename!='Honeywell Employee' || intcheck==false  ) || Test.isRunningTest()  )  )
                {
                    system.debug('entered before update condition');
                                 
                    if (newCon.Primary_Email_Address__c!= null)
                    {
                       Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
                        system.debug('insidenewcon'+newCon.Primary_Email_Address__c);
                       
                        String emailid1 = newCon.Primary_Email_Address__c;
                        String[]toAddresses1 = new String[] {emailid1};
                        system.debug('insidenewcon1'+toAddresses1);
                        mail2.settargetObjectId(newCon.ID);
                        mail2.setToAddresses(toAddresses1);
                        mail2.setOrgWideEmailAddressId(label.RegistrationAddress);                               
                        mail2.setTemplateId(label.PortalProfileNotificationTemplate);                          
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail2}); 
                        newCon.Counter_on_update__c=1;
                        
                        system.debug('the counter value is'+newCon.Counter_on_update__c);
                   
                    //    Datetime executeTime = (System.now()).addSeconds(3);
                    //    String cronExpression =scheduledCron1.GetCRONExpression(executeTime);
                      scheduledCron1 sc=new scheduledCron1(newCon);
                      
                     // System.schedule('ToolNotificationScheduledJob' + executeTime.getTime(),cronExpression,sc);
                     
                     
                      System.scheduleBatch(sc,'One time batch',1);
                    
                    }
                }
            }
        }
    }
}