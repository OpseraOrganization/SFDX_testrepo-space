@isTest
public class sendEmailForMCOREReqApproveRejectTest{

static testMethod void myUniTest(){

Account acc = new Account();
acc.Name = 'Honeywell Test';
acc.OwnerId = [Select Id from User where Name = 'API User SFDC Cust Master'].Id;
acc.Customer_Status__c = 'Active';
acc.Strategic_Business_Unit__c = 'ATR';
acc.CBT__c = 'Airlines';
acc.CBT_Team__c = 'Americas';
acc.Region_Name__c = 'Americas';
acc.Sub_Region_Name__c = 'Canada';
acc.Service_Level__c = 'Standard';
acc.Type = 'OEM';
acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
try {
insert acc;
}catch(Exception ex){}

AccountTeamMember atm1 = new AccountTeamMember();
atm1.AccountId = acc.Id;
atm1.TeamMemberRole='Customer Business Director';
atm1.userId=[Select Id from User limit 1].Id;

try {
insert atm1;
}catch(Exception ex){}

//atm1.TeamMemberRole='Customer Business Director';
//update atm1;

Contact con = new Contact();
con.Phone_1__c='231231231';
con.Honeywell_ID__c='E522624';
con.Address_Line_1__c='Testtsstts';
con.Address_Line_2__c='Testtsstts';
con.Address_Line_3__c='Testtsstts';
con.City_Name__c='Testtsstts';
con.State_Code__c='Testtsstts';
con.Country_Name__c='Testtsstts';
con.FirstName = 'MASSASAS';
con.LastName = 'Singh';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere10@gmail.com';
con.Email='kapil.now@gmail.com';
try {
insert con;
}catch(Exception ex){}

if(con.FirstName == NULL){con.FirstName = 'KapilM1';try {update con;}Catch(Exception ex){}}

Portal_Tools_Master__c ptmc = new Portal_Tools_Master__c();
ptmc.Name='MCORE (Maintenance Cost Reduction)';
ptmc.Tool_Description__c='View Reliability Data|Compare Data with Fleet Averages|Component Trend Monitoring';
ptmc.Tool_Sort_Order__c = '21';
ptmc.Tool_Authorization_Method__c = 'Honeywell Approval';
try {
insert ptmc;
}catch(Exception ex){}

//ptmc.Name='MCORE (Maintenance Cost Reduction)';
//update ptmc;

Contact_Tool_Access__c cta = new Contact_Tool_Access__c();
cta.Name = 'MCORE (Maintenance Cost Reduction)';
cta.MCORE_IS_Super_Admin__c = true;
cta.CRM_Contact_ID__c = con.Id;
cta.Portal_Tool_Master__c=ptmc.Id;
cta.Request_Status__c='Pending';
cta.Portal_Honeywell_ID__c = 'E812402';
try {
insert cta;
}catch(Exception ex){}

Contact_Tool_Access__c ctaup = [Select Id from Contact_Tool_Access__c where Id =:cta.id ];
ctaup.Name = 'MCORE';
ctaup.Request_Status__c='Approved';
update ctaup;

Case cs = new Case();
cs.Origin = 'Phone';
cs.Status = 'Open';
cs.RecordTypeId = [select Id from RecordType where SObjectType='Case' and Name = 'WEB Portal Registration'].Id;
if(con.Id != NULL || con.Id != ''){
cs.ContactId = con.Id;
}
else {
cs.ContactId = [Select Id from Contact limit 1].Id;
}
cs.Tool_Name__c = 'MCORE';
cs.Classification__c = 'GTO Field Service';
cs.HON_Commit_Date__c = System.now() + 1;
cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
cs.Government_Compliance_SM_M_Content__c = 'NO';
//cs.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923
try {
insert cs;
}catch(Exception ex){}


List<Portal_Tools_Master__c> toolList=[select Name from Portal_Tools_Master__c where id=:cta.Portal_Tool_Master__c];

if(cta!=null && cta.Portal_Tool_Master__c!=null && toolList!=null && toolList.size()>0 && (toolList.get(0).Name=='MCORE' || toolList.get(0).Name=='MCORE (Maintenance Cost Reduction)') && (cta.Request_Status__c=='Approved' || cta.Request_Status__c=='Denied')){
List<String> requester=new List<String>();
List<String> accOwners=new List<String>();
List<String> ccAddresses=new List<String>();

List<Contact> contList=[select Account.Name,AccountId,Honeywell_ID__c,Phone_1__c,Email,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Name,Country_Name__c from contact where id=:con.Id];
if(contList.get(0).Email!=null){
    requester.add(contList.get(0).Email);
}

List<Account> accounts=[select owner.Email, owner.Name, CBT__c, CBT_Team__c,Strategic_Business_Unit__c from Account where id =: acc.Id];

if(accounts.get(0).owner.Name == 'Salesforce Customer Master' && accounts.get(0).Strategic_Business_Unit__c == 'ATR' && accounts.get(0).CBT__c == 'Airlines'){
    if(accounts.get(0).CBT_Team__c == 'Americas'){
        accOwners.add('kapilmuni.singh@honeywell.com');
    }else if(accounts.get(0).CBT_Team__c == 'EMEAI ATR'){
        accOwners.add('dan.wisniewski@honeywell.com');
    }else if(accounts.get(0).CBT_Team__c == 'Asia Pacific ATR') {
        accOwners.add('joel.miranda@honeywell.com');
    }
     
}
else {
    accOwners.add(accounts.get(0).owner.Email);
}

System.debug('accounts.get(0).owner.Email ==> '+accounts.get(0).owner.Email);
List<AccountTeamMember> accTeam=[Select user.Email from AccountTeamMember where (TeamMemberRole='Customer Business Manager (CBM)' or TeamMemberRole='Customer Business Director') and Accountid =: acc.Id];
List<Contact_Tool_Access__c> test=[select CRM_Contact_ID__c from Contact_Tool_Access__c where MCORE_IS_Super_Admin__c=true and (Portal_Tool_Master__r.Name='MCORE' or Portal_Tool_Master__r.Name='MCORE (Maintenance Cost Reduction)')];
List<Contact> superAdmins=[select email from Contact where id in (select CRM_Contact_ID__c from Contact_Tool_Access__c where MCORE_IS_Super_Admin__c=true and (Portal_Tool_Master__r.Name='MCORE' or Portal_Tool_Master__r.Name='MCORE (Maintenance Cost Reduction)'))];
List<Case> caseList=[select CaseNumber from Case where contactId=:con.Id and (Tool_Name__c='MCORE' or Tool_Name__c='MCORE (Maintenance Cost Reduction)')];

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                if(contList.get(0).Email!=null && contList.get(0).Email.toUpperCase().contains('HONEYWELL.COM')){                
                    mail.setToAddresses(requester);    
                }else{
                    for(AccountTeamMember atm: accTeam){
                        ccAddresses.add(atm.user.Email);    
                    }
                    for(Contact sAdmin: superAdmins){
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
                if(cta.Request_Status__c=='Approved'){
                    subj='MCORE tool access request has been approved';
                    bdy='The following SFDC Registration Case has been approved by administrator:';
                }else if(cta.Request_Status__c=='Denied'){
                    subj='MCORE tool access request has been rejected';
                    bdy='The following SFDC Registration Case has been rejected by administrator:';    
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
                    String body='<html><body><table>'+
                    '<tr><td colspan="2"> Dear'+ contList.get(0).Name+',   </td></tr>'+
                    '<tr><td colspan="2">'+bdy+'</td></tr>'+
                    '<tr><td colspan="2">'+CaseNum+'</td></tr>'+ 
                    '<tr><td colspan="2"><U>Below are the details of the request:</U></td></tr>'+
                    '<tr><td><b>Tool Name :</b></td><td>'+toolList.get(0).Name+'</td></tr>'+ 
                    '<tr><td><b>Honeywell ID :</b></td><td>'+contList.get(0).Honeywell_ID__c+'</td></tr>'+ 
                    '<tr><td><b>Contact Name :</b></td><td>'+contList.get(0).Name+'</td></tr>'+ 
                    '<tr><td><b>Email Address :</b></td><td>'+contList.get(0).Email+'</td></tr>'+ 
                    '<tr><td><b>Company Name :</b></td><td>'+contList.get(0).Account.Name+'</td></tr>'+ 
                    '<tr><td><b>Contact Phone Number :</b></td><td>'+contList.get(0).Phone_1__c+'</td></tr>'+
                    '<tr><td valign="top"><b>Contact Address :</b></td><td>'+addr+'</td></tr>'+ 
                    
                    '<tr><td colspan="2">Thank You,</td></tr>'+ 
                    '<tr><td colspan="2">Administrator</td></tr>';        
                    body=body+'</table></body></html>';       
                    mail.setSubject(subject);
                    mail.setHtmlBody(body); 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                    }
}
}