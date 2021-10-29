trigger sendEmailForMCOREToolRequest on Case (after insert) {
/*commenting inactive trigger code to improve code coverage-----
    //Case newCase=Trigger.new[0];
    List<Case> newCase=Trigger.new;
         for(Integer m=0;m<newCase.size();m++){
         System.debug('newCase.RecordTypeId ==> '+newCase[m].RecordTypeId);
         
         String rtName='';
         List<RecordType> rt=[select developerName from RecordType where SObjectType='Case' and id=:newCase[m].RecordTypeId];
         if(rt!=null && rt.size()>0){
             rtName=rt.get(0).developerName;    
         }
         System.debug('rtName ==> '+rtName);
        if(Trigger.isInsert){
      
         if(newCase!=null && rtName=='WEB_Portal_Registration' && newCase[m].Tool_Name__c!=null && newCase[m].Tool_Name__c!='' && (newCase[m].Tool_Name__c=='MCORE' || newCase[m].Tool_Name__c=='MCORE (Maintenance Cost Reduction)') && newCase[m].status=='Open' ){
                List<String> accOwners=new List<String>();
                List<String> ccAddresses=new List<String>();
                List<Account> accounts=[select owner.Email, owner.Name, CBT__c, CBT_Team__c,Strategic_Business_Unit__c from Account where id=:newCase[m].AccountId];
                //List<Account> accounts=[select owner.Email from Account where id=:newCase.AccountId];
                //Added by Kapil for Account Owner Code Change
                if(accounts.get(0).owner.Name == 'Salesforce Customer Master' && accounts.get(0).Strategic_Business_Unit__c == 'ATR' && accounts.get(0).CBT__c == 'Airlines'){
                    if(accounts.get(0).CBT_Team__c == 'Americas'){
                        accOwners.add('rocky.advani@honeywell.com');
                    }else if(accounts.get(0).CBT_Team__c == 'EMEAI ATR'){
                        accOwners.add('dan.wisniewski@honeywell.com');
                    }else if(accounts.get(0).CBT_Team__c == 'Asia Pacific ATR') {
                        accOwners.add('joel.miranda@honeywell.com');
                    }
                     System.debug('Kapil ==> '+accOwners);
                }
                else {
                    accOwners.add(accounts.get(0).owner.Email);
                }
                //Added by Kapil for Account Owner Code Change
                
                //accOwners.add(accounts.get(0).owner.Email);
                System.debug('accounts.get(0).owner.Email ==> '+accounts.get(0).owner.Email);
                List<AccountTeamMember> accTeam=[Select user.Email from AccountTeamMember where (TeamMemberRole='Customer Business Manager (CBM)' or TeamMemberRole='Customer Business Director') and Accountid =:newCase[m].AccountId];
                List<Contact> superAdmins=[select email from Contact where id in (select CRM_Contact_ID__c from Contact_Tool_Access__c where (Name='MCORE' or Name = 'MCORE (Maintenance Cost Reduction)') and MCORE_IS_Super_Admin__c=true)];
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                System.debug('accTeam ==> '+accTeam);
                System.debug('superAdmins ==> '+superAdmins);
                System.debug('newCase.contact.Email '+newCase[m].contactId);
                List<Contact> contList=[select Account.Name,Phone_1__c,Honeywell_ID__c,Email,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Name,Country_Name__c from contact where id=:newCase[m].contactId];
                System.debug('contList '+contList);                            
                if(contList.get(0).Email!=null && contList.get(0).Email.toUpperCase().contains('HONEYWELL.COM')){
                    accOwners.clear();
                    for(Contact sAdmin: superAdmins){
                        accOwners.add(sAdmin.email);    
                    }
                    mail.setToAddresses(accOwners);   
                }else{
                    for(AccountTeamMember atm: accTeam){
                        ccAddresses.add(atm.user.Email);    
                    }
                    for(Contact sAdmin: superAdmins){
                        ccAddresses.add(sAdmin.email);    
                    }
                    mail.setToAddresses(accOwners);
                    mail.setCcAddresses(ccAddresses);   
                }
                System.debug('accOwners ==> '+accOwners);
                System.debug('ccAddresses ==> '+ccAddresses);
                if(accOwners!=null && accOwners.size()>0){
                    String addr='';
                    if(contList.get(0).Address_Line_1__c!=null){
                        addr=addr+contList.get(0).Address_Line_1__c+'<BR/>';
                    }
                    if(contList.get(0).Address_Line_2__c!=null){
                        addr=addr+contList.get(0).Address_Line_2__c+'<BR/>';
                    }
                    if(contList.get(0).Address_Line_3__c!=null){
                        addr=addr+contList.get(0).Address_Line_3__c+'<BR/>';
                    }
                    if(contList.get(0).City_Name__c!=null){
                        addr=addr+contList.get(0).City_Name__c+'<BR/>';
                    }
                    if(contList.get(0).State_Code__c!=null){
                        addr=addr+contList.get(0).State_Code__c+'<BR/>';
                    }
                    if(contList.get(0).Country_Name__c!=null){
                        addr=addr+contList.get(0).Country_Name__c+'<BR/>';
                    }
                    String serverURL = URL.getSalesforceBaseUrl().toExternalForm();                        
                    String subject='Request for MCORE Tool Access';
                    String body='<html><body><table>'+
                    '<tr><td colspan="2"> Dear Administrator,   </td></tr>'+
                    '<tr><td colspan="2"> The following SFDC Registration Case has been assigned to you:   </td></tr>'+
                    '<tr><td colspan="2">'+newCase[m].CaseNumber+'</td></tr>'+ 
                    '<tr><td colspan="2"><U>Below are the details of the request:</U></td></tr>'+
                    '<tr><td><b>Tool Name :</b></td><td>'+newCase[m].Tool_Name__c+'</td></tr>'+ 
                    '<tr><td><b>Honeywell ID :</b></td><td>'+contList.get(0).Honeywell_ID__c+'</td></tr>'+ 
                    '<tr><td><b>Contact Name :</b></td><td>'+contList.get(0).Name+'</td></tr>'+ 
                    '<tr><td><b>Email Address :</b></td><td>'+contList.get(0).Email+'</td></tr>'+ 
                    '<tr><td><b>Company Name :</b></td><td>'+contList.get(0).Account.Name+'</td></tr>'+ 
                    '<tr><td><b>Contact Phone Number :</b></td><td>'+contList.get(0).Phone_1__c+'</td></tr>'+                    
                    '<tr><td valign="top"><b>Contact Address :</b></td><td>'+addr+'</td></tr>'+                    
                    '<tr><td colspan="2">Click on the link to access the case:</td></tr>'+
                    '<tr><td colspan="2">'+serverURL+'/'+newCase[m].Id+'</td></tr>'+ 
                    '<tr><td colspan="2">Thank You,</td></tr>'+ 
                    '<tr><td colspan="2">Self service registration team</td></tr>';        
                    body=body+'</table></body></html>';       
                    mail.setSubject(subject);
                    mail.setHtmlBody(body); 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
         }  
    }
    } */
}