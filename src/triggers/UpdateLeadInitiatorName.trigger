/** * File Name: UpdateLeadInitiatorName
* Description :Trigger to update lead creator
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro

Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
23-Jan-2015     1.1             NTTDATA         INC000008227994 ATR RMU TOOL owner assignment 
03-March-2015   1.2             TCS Run Team    INC000008402618 Issue in Lead Creation.    
*/ 
trigger UpdateLeadInitiatorName on Lead (before insert, After insert) {
    
    //Code added for ATR RMU TOOL Started
    string Owid = label.ATR_Lead_Recordtype;
    string rtid = label.ATR_Lead_Recordtype;
    set<id> cid =new set<id>();
    set<id> tid =new set<id>();
    set<string> sb =new set<string>();
    set<string> hid =new set<string>();
    map<id,lead> maplead = new map<id,lead>();
    map<id,lead> maphwlead = new map<id,lead>();
    map<id,id> mapleadcon = new map<id,id>();
    map<string,id> mapleadHoneywellID = new map<string,id>();
    map<id,contact> con = new map<id,contact>() ;
    map<id,contact> conmap = new map<id,contact>();
    list<Contact> cont = new List<Contact>();
    list<Contact> cont1 = new List<Contact>();
    list<Lead> lea = new List<Lead>();
    //Code added for SR# INC000008227994 ATR RMU TOOL Start
    map<id,id> mapAccId = new map<id,id>();
    //Code added for SR# INC000008227994 ATR RMU TOOL End
    //Code added for ATR RMU TOOL End
    if(Trigger.isInsert && Trigger.isBefore){
    for(lead led:trigger.new){
       if(Led.FSE_Initiator_Name__c==null){            
            Led.FSE_Initiator_Name__c=Userinfo.getUserId();
        } 
        //Code added for ATR RMU TOOL Started 
        if(led.Honeywell_ID__c!=null )   
        {              
            hid.add(led.Honeywell_ID__c);
            maphwlead.put(led.id,led);
            //Code added for SR# INC000008227994 ATR RMU TOOL Start
            if( Userinfo.getUserId()==label.ATR_API_User_id)
            {
            cont1 =new list<Contact>([select id,Honeywell_ID__c,account.name,account.IATA_Code__c from contact where Honeywell_ID__c  in:hid]);       
                for(contact conh :cont1)
                {            
                    cid.add(conh.id);            
                }
                sb.add(led.Service_Bulletins__c);
                Lea =new list<Lead>([select id,Service_Bulletins__c from lead where Contact__c  in:cid and Service_Bulletins__c in:sb and recordtypeid =: rtid]);
                 if (lea.size()>0  ){
                 Trigger.new[0].addError('Lead already exist for this Contact');
                    }
                Led.recordtypeid=label.ATR_Lead_Recordtype;   
                } 
            //Code added for SR# INC000008227994 ATR RMU TOOL End    
        }      
       if(led.Contact__c!=null)
        {            
            tid.add(led.Contact__c);
            sb.add(led.Service_Bulletins__c);
            maplead.put(led.id,led);       
            mapleadcon.put(led.id,led.Contact__c);
            //Code added for SR# INC000008227994 ATR RMU TOOL Start
            if( Userinfo.getUserId()==label.ATR_API_User_id){
             Lea =new list<Lead>([select id,Service_Bulletins__c from lead where Contact__c  in:tid and Service_Bulletins__c in:sb and recordtypeid =: rtid]);
            if (lea.size()>0  ){
             Trigger.new[0].addError('Lead already exist for this Contact');
                }
                Led.recordtypeid=label.ATR_Lead_Recordtype;
                }
            //Code added for SR# INC000008227994 ATR RMU TOOL End    
        }  
       //Code added for ATR RMU TOOL End           
    }
    //Code added for ATR RMU TOOL Started
    if(hid!=null && hid.size() > 0)
    {              
        cont =new list<Contact>([select id,Honeywell_ID__c,account.name,account.IATA_Code__c,Account.ownerid,accountid from contact where Honeywell_ID__c  in:hid]);
        conmap= new map<id,contact>();
        for(contact conhw :cont)
        {            
            mapleadHoneywellID.put(conhw.Honeywell_ID__c,conhw.id);
            conmap.put(conhw.id,conhw);            
        }
    } 
    if(maphwlead!= null && maphwlead.size()>0  && Userinfo.getUserId()==label.ATR_API_User_id)
    {                      
        for(lead led:maphwlead.values()){
            led.contact__c=conmap.get(mapleadHoneywellID.get(led.Honeywell_ID__c)).id;
            led.Account__c=conmap.get(mapleadHoneywellID.get(led.Honeywell_ID__c)).accountid;
            led.IATA_Code__c=conmap.get(mapleadHoneywellID.get(led.Honeywell_ID__c)).account.IATA_Code__c; 
            Owid = conmap.get(mapleadHoneywellID.get(led.Honeywell_ID__c)).account.ownerid;
             if(Userinfo.getUserId()==label.ATR_API_User_id){
             if(Owid.left(3) == '005')
             {                   
                led.ownerid=conmap.get(mapleadHoneywellID.get(led.Honeywell_ID__c)).account.ownerid;
                    } 
                    else
                    {
                led.ownerid=label.ATR_Default_Owner;
                    }
            }
            //Code added for SR# INC000008227994 ATR RMU TOOL Start
            //mapAccId.put(led.id,conmap.get(mapleadHoneywellID.get(led.Honeywell_ID__c)).accountid);
            //Code added for SR# INC000008227994 ATR RMU TOOL End
        }
    }      
    if(maplead!= null && maplead.size()>0  && Userinfo.getUserId()==label.ATR_API_User_id)
    {         
        con =new Map<ID, Contact>([select accountid,Account.ownerid,account.name,account.IATA_Code__c from contact where id  in:tid]);
        for(lead led:maplead.values()){
            led.Account__c=con.get(mapleadcon.get(led.id)).accountid;
            led.IATA_Code__c=con.get(mapleadcon.get(led.id)).account.IATA_Code__c;
            Owid = con.get(mapleadcon.get(led.id)).account.ownerid;
             if(Userinfo.getUserId()==label.ATR_API_User_id){
             if(Owid.left(3) == '005')
             {                   
                led.ownerid=con.get(mapleadcon.get(led.id)).account.ownerid;
                    } 
                    else
                    {
                led.ownerid=label.ATR_Default_Owner;
                    }
            }
            }
            //Code added for SR# INC000008227994 ATR RMU TOOL Start
            //mapAccId.put(led.id,con.get(mapleadcon.get(led.id)).accountid);
            //Code added for SR# INC000008227994 ATR RMU TOOL End
        }
    }
    
    if(Trigger.isInsert && Trigger.isAfter){
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    list<id> lids = new List<id>();
    list<lead> lea1 = new List<lead>();
    for(lead led:trigger.new){
        if(Userinfo.getUserId()==label.ATR_API_User_id){
        lids.add(led.id);
        }
    }
    if(lids.size()>0){
     lea1 = [select Id,owner.Name,owner.email,Lead_Number__c,Service_Bulletins__c from lead WHERE Id=:lids];
     }
    for(lead led1:lea1){
            Messaging.SingleEmailMessage mail = 
            new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(led1.owner.Email);
            mail.setToAddresses(sendTo);
            // Step 3: Set who the email is sent from
            mail.setOrgWideEmailAddressId('0D2300000008P9F');
            // Step 4. Set email contents - you can use variables!
            mail.setSubject('A Lead is assigned to you, Please review!');
            String body = 'Dear ' + led1.Owner.Name + ',<br><br>';
            body += 'An important customer has just visited the Performance Accelerator ';
            body += 'and expressed interest in Service Bulletin '+Led1.Service_Bulletins__c+'.';
            body += ' Please access the lead <a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+Led1.Id+'">'+Led1.Lead_Number__c+'</a> ';
            body += 'for additional details and contact the customer within 24 hours while their interest is high,';
            body += ' and the lead is still warm.<br><br>After your initial discussion, be sure to update the status';
            body += ' field on the Lead record and convert it to an Opportunity if appropriate.<br><br>';
            body += 'Thank you,<br>Honeywell Aerospace SFDC Admin.';
            mail.setHtmlBody(body);
            // Step 5. Add your email to the master list
            mails.add(mail);
            }
              // Step 6: Send all emails in the master list
              Messaging.sendEmail(mails);
              
              //Condition Added for RAPD -7760 Sales leads Process Optimization
              list<lead>LeadUpdate=new list<lead>();
              //Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Create C&PS Lead').getRecordTypeId();
              String profileName = [select Name from profile where id = :UserInfo.getProfileId()].Name;
             RecordType rt = [SELECT Id, Name FROM RecordType WHERE Name = 'Create C&PS Lead'];
              RecordType rt1 = [SELECT Id, Name FROM RecordType WHERE Name = 'Converted C&PS Lead'];
              RecordType rt2 = [SELECT Id, Name FROM RecordType WHERE Name = 'Convert C&PS Lead'];
              for(Lead ld:[select RecordTypeId,id,Account_Address_line_1__c,Account_City__c, Account_New_Market__c,Account_New_Type__c,Account_State__c,Account_Postal_Code__c,Account_Country__c,Account_Phone__c,SBU__c,CBT_Team__c,CBT__c,Account__r.Address_Line_1__c,Account__r.City_Name__c,Account_Market__c,Dealer_Type__c,Account_State_Code_existingAccount__c,Account__r.Postal_Code__c,Country_Name_ExistingAccount__c,Account__r.Phone,Account__r.CBT__c, Account__r.CBT_Team__c,Account__r.Strategic_Business_Unit__c,Title,Contact__r.Job_Title__c,Primary_Work_Number__c,Contact__r.Phone_1__c,  Primary_Fax_Number__c,Contact__r.Phone_3__c,MobilePhone,Contact__r.Phone_5__c,Website,Account__r.Website from Lead  where id in: trigger.newmap.keyset()]){
             //if(profileName=='GTO Business Admin (US)' || profileName=='GTO Business Admin (Non US)' || profileName=='GTO DS FSE (Non US)' || profileName=='GTO DS FSE (US)'|| profileName=='GTO FSE (Non US)'|| profileName=='GTO FSE (US)' || profileName=='GTO FSE/PSE/CSPM (Non US)'|| profileName=='GTO FSE/PSE/CSPM (US)'|| profileName=='GTO FSE/PSE/CSPM/FT/EIS(RE) (Non US)'|| profileName=='GTO FSE/PSE/CSPM/FT/EIS(RO) (Non US)'){
 if(ld.RecordTypeId==rt.id || ld.RecordTypeId==rt1.id || ld.RecordTypeId==rt2.id  ){    
    Lead LeadNew=new lead(id=ld.id);
    LeadNew.Account_Address_line_1__c=ld.Account_Address_line_1__c==null?ld.Account__r.Address_Line_1__c:ld.Account_Address_line_1__c;
    LeadNew.Account_City__c=ld.Account_City__c==null?ld.Account__r.City_Name__c:ld.Account_City__c;
    LeadNew.Account_New_Market__c=ld.Account_New_Market__c==null?ld.Account_Market__c:ld.Account_New_Market__c;
    LeadNew.Account_New_Type__c=ld.Account_New_Type__c==null?ld.Dealer_Type__c:ld.Account_New_Type__c;
    LeadNew.Account_State__c=ld.Account_State__c==null?ld.Account_State_Code_existingAccount__c:ld.Account_State__c;
    LeadNew.Account_Postal_Code__c=ld.Account_Postal_Code__c==null?ld.Account__r.Postal_Code__c:ld.Account_Postal_Code__c;
    LeadNew.Account_Country__c=ld.Account_Country__c==null?ld.Country_Name_ExistingAccount__c:ld.Account_Country__c;
    LeadNew.Account_Phone__c=ld.Account_Phone__c==null?ld.Account__r.Phone:ld.Account_Phone__c;
    LeadNew.SBU__c=ld.SBU__c==null?ld.Account__r.Strategic_Business_Unit__c:ld.SBU__c;
    LeadNew.CBT_Team__c=ld.CBT_Team__c==null?ld.Account__r.CBT_Team__c:ld.CBT_Team__c;
    LeadNew.CBT__c=ld.CBT__c==null?ld.Account__r.CBT__c:ld.CBT__c;
    LeadNew.Title=ld.Title==null?ld.Contact__r.Job_Title__c:ld.Title;
    LeadNew.Primary_Work_Number__c=ld.Primary_Work_Number__c==null?ld.Contact__r.Phone_1__c:ld.Primary_Work_Number__c;
    LeadNew.Primary_Fax_Number__c=ld.Primary_Fax_Number__c==null?ld.Contact__r.Phone_3__c:ld.Primary_Fax_Number__c;
    LeadNew.MobilePhone=ld.MobilePhone==null?ld.Contact__r.Phone_5__c:ld.MobilePhone;
    LeadNew.Website=ld.Website==null?ld.Account__r.Website:ld.Website;
    LeadUpdate.add(LeadNew);
    
    }
             }
              if(!LeadUpdate.IsEmpty()){
              Update LeadUpdate;
              }
              // End of Condition Added for RAPD -7760 Sales leads Process Optimization 
            }
    //Code added for SR# INC000008227994 ATR RMU TOOL Start
    //Condition Added For SR# INC000008402618 Issue in Lead Creation Start   
       /* if(mapAccId!= null && mapAccId.size()>0 && Userinfo.getUserId()==label.ATR_API_User_id)
        {        
        MaP<Id,Account> mapacctteam = new  MaP<Id,Account>([select id,(SELECT UserId FROM AccountTeamMembers where TeamMemberRole='Customer Business Manager (CBM)' ) from account where id in :mapAccId.values()]);
        List<AccountTeamMember> lstAccTM = new List<AccountTeamMember>();
        for(Lead led : trigger.new){
            lstAccTM = mapacctteam.get(mapAccId.get(led.id)).AccountTeamMembers; 
            if(lstAccTM.size()>0){                   
                led.ownerid=lstAccTM[0].userid;
            } 
            else
            {
                led.ownerid=label.ATR_Default_Owner;
            }
        }
        }  */
      //Condition Added For SR# INC000008402618 Issue in Lead Creation End
    //Code added for SR# INC000008227994 ATR RMU TOOL End
    //Code added for ATR RMU TOOL Ended
}