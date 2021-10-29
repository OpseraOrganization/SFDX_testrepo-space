trigger sendEmailForMCOREReqApproveReject on Contact_Tool_Access__c (after update) {
    Contact_Tool_Access__c newCase=Trigger.new[0];
    if(Trigger.isUpdate){   
         System.debug('newCase.Portal_Tool_Master__r.Name==> '+newCase.Portal_Tool_Master__c);
         System.debug('Trigger.newMap.get(newCase.Id).Request_Status__c ==> '+Trigger.newMap.get(newCase.Id).Request_Status__c);
         System.debug('Trigger.oldMap.get(newCase.Id).Request_Status__c ==> '+Trigger.oldMap.get(newCase.Id).Request_Status__c);
         List<Portal_Tools_Master__c> toolList=[select Name from Portal_Tools_Master__c where id=:newCase.Portal_Tool_Master__c];
         System.debug('toolList ===> '+toolList);
         if(newCase!=null && newCase.Portal_Tool_Master__c!=null && toolList!=null && toolList.size()>0 && (toolList.get(0).Name=='MCORE' || toolList.get(0).Name=='MCORE (Maintenance Cost Reduction)') && (newCase.Request_Status__c=='Approved' || newCase.Request_Status__c=='Denied') && Trigger.newMap.get(newCase.Id).Request_Status__c!=Trigger.oldMap.get(newCase.Id).Request_Status__c){
                List<String> requester=new List<String>();
                List<String> ccAddresses=new List<String>();
                List<String> accOwners=new List<String>();
                //System.debug('newCase.contact.Email '+newCase.contactId);
                List<Contact> contList=[select Account.Name,AccountId,Honeywell_ID__c,Phone_1__c,Email,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Name,Country_Name__c from contact where id=:newCase.CRM_Contact_ID__c];
                System.debug('contList '+contList);
                if(contList.get(0).Email!=null){
                    requester.add(contList.get(0).Email);
                }
                System.debug('requester ==> '+requester);
                //List<Account> accounts=[select owner.Email from Account where id=:contList.get(0).AccountId];
                List<Account> accounts=[select owner.Email, owner.Name, CBT__c, CBT_Team__c,Strategic_Business_Unit__c from Account where id=:contList.get(0).AccountId];
                //Added by Kapil for Account Owner Code Change
                if(accounts.get(0).owner.Name == 'Salesforce Customer Master' && accounts.get(0).Strategic_Business_Unit__c == 'ATR' && accounts.get(0).CBT__c == 'Airlines'){
                    if(accounts.get(0).CBT_Team__c == 'Americas'){
                        accOwners.add('rocky.advani@honeywell.com');
                        //accOwners.add('kapilmuni.singh@honeywell.com');
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
                
                List<AccountTeamMember> accTeam=[Select user.Email from AccountTeamMember where (TeamMemberRole='Customer Business Manager (CBM)' or TeamMemberRole='Customer Business Director') and Accountid =:contList.get(0).AccountId];
                List<Contact_Tool_Access__c> test=[select CRM_Contact_ID__c from Contact_Tool_Access__c where MCORE_IS_Super_Admin__c=true and Portal_Tool_Master__r.Name='MCORE'];
                System.debug('test ===> '+test);
                set<Id> idList = New set<Id>();
                Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'MCORE Super Admins'];
                for (GroupMember gm : g.groupMembers) {
                     idList.add(gm.userOrGroupId);
                    } 
                    User[] superAdmins = [SELECT email FROM user WHERE id IN :idList]; 
                
              //  List<Contact> superAdmins=[select email from Contact where id in: conid];
                List<Case> caseList=[select CaseNumber from Case where contactId=:newCase.CRM_Contact_ID__c and (Tool_Name__c='MCORE' or Tool_Name__c='MCORE (Maintenance Cost Reduction)')];
                System.debug('accTeam ==> '+accTeam);
                System.debug('superAdmins ==> '+superAdmins);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                if(contList.get(0).Email!=null && contList.get(0).Email.toUpperCase().contains('HONEYWELL.COM')){                
                    mail.setToAddresses(requester); 
                    for(User sAdmin: superAdmins){
                        ccAddresses.add(sAdmin.email);    
                    }
                    mail.setCcAddresses(ccAddresses);   
                }else{
                    for(AccountTeamMember atm: accTeam){
                        ccAddresses.add(atm.user.Email);    
                    }
                    for(user sAdmin: superAdmins){
                        ccAddresses.add(sAdmin.email);    
                    }
                    //for(Account acc: accounts){
                    //    ccAddresses.add(acc.owner.Email);    
                    //}
                    for(Integer i=0;i<accOwners.size();i++){
                        ccAddresses.add(accOwners[i]);    
                    }
                    mail.setToAddresses(requester);
                    mail.setCcAddresses(ccAddresses);
                }
                System.debug('ccAddresses ==> '+ccAddresses);
                System.debug('requester ==> '+requester);
                String subj='';
                String bdy='';
                String body;
                if(newCase.Request_Status__c=='Approved'){
                    subj='Access to Honeywell MCORE tool has been approved';
                    body='<html><body><table>'+
                    '<tr><td colspan="2"> Dear Aerospace Colleague,</td></tr>'+
                    '<tr><td colspan="2"></td></tr>'+ 
                    '<tr><td colspan="2"> Welcome to the Honeywell Maintenance Cost Reduction (MCORE) tool!  Your MCORE access is approved.</td></tr>'+
                    '<tr><td colspan="2"></td></tr>'+ 
                    '<tr><td colspan="2">Your MCORE account has been set-up and is ready for you to use.  You can log-in to MCORE at:  https://mcore.honeywell.com.</td></tr>'+
                     '<tr><td colspan="2"></td></tr>'+ 
                    '<tr><td colspan="2">The online MCORE tutorial video, located on the MCORE site, will help you get started.  You’ll also find helpful links to frequently asked questions and the MCORE support team.  If you still have questions or need additional assistance, we’re here to help.  Just click on the support link when in MCORE or send an email to MCOREAdmin@honeywell.com.</td></tr>'+ 
                    '<tr><td colspan="2"></td></tr>'+              
                    '<tr><td colspan="2">We hope you find MCORE to be a user-friendly reliability data tool with a selection of simple-to-access and useful reports.  We are eager for you to explore the tool’s offerings and collaborate with you on solutions that will help optimize fleet performance and achieve maintenance efficiency.</td></tr>'+ 
                    '<tr><td colspan="2"></td></tr>'+ 
                    '<tr><td colspan="2">Thank You,</td></tr>'+ 
                    '<tr><td colspan="2">Honeywell MCORE Support Team</td></tr>'; 
                }else if(newCase.Request_Status__c=='Denied'){
                    subj='Access to Honeywell MCORE tool has been denied';
                     body='<html><body><table>'+
                    '<tr><td colspan="2"> Dear Aerospace Colleague,</td></tr>'+
                    '<tr><td colspan="2"></td></tr>'+ 
                    '<tr><td colspan="2">Thank you for your interest in Honeywell Maintenance Cost Reduction (MCORE) tool.  Unfortunately, we are unable to process your access request at this time.Information necessary to complete your request is either missing or may be insufficient to enable MCORE access.</td></tr>'+
                     '<tr><td colspan="2"></td></tr>'+ 
                    '<tr><td colspan="2">Please contact the MCORE site Administrator at MCOREAdmim@honeywell.com.  The MCORE support team will work with you to clarify omissions or discrepancies and resolve remaining issues necessary for MCORE account activation.</td></tr>'+ 
                    '<tr><td colspan="2"></td></tr>'+ 
                    '<tr><td colspan="2">Thank You,</td></tr>'+ 
                    '<tr><td colspan="2">Honeywell MCORE Support Team</td></tr>';    
                }
                if(requester!=null && requester.size()>0){
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
                    String CaseNum='';
                    if(caseList!=null && caseList.size()>0){
                        CaseNum=caseList.get(0).CaseNumber;
                    }                    
                    String subject=subj;       
                    body=body+'</table></body></html>';       
                    mail.setSubject(subject);
                    mail.setHtmlBody(body); 
                    mail.setOrgWideEmailAddressId('0D2a00000008QDT');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
         }
    } 
}