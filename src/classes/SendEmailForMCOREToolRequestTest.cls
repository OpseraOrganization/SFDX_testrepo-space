@isTest
public class SendEmailForMCOREToolRequestTest{

static testMethod void myUniTest(){

Integer eCount = 0;
List<Case> cases=new List<Case>();
List<Task> task1=new List<Task>();
List<Case> casetoUpdate= new List<Case>();

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
atm1.TeamMemberRole='Customer Business Manager (CBM)';
atm1.userId=[Select Id from User limit 1].Id;

try {
insert atm1;
}catch(Exception ex){}

//atm.AccountId = acc.Id;
//atm.AccountAccessLevel='Edit';
//atm.TeamMemberRole='Customer Business Director';
//atm.userId=[Select Id from User limit 1].Id;

Contact con = new Contact();
con.Phone_1__c='231231231';
con.Honeywell_ID__c='E522624';
con.Address_Line_1__c='Testtsstts';
con.Address_Line_2__c='Testtsstts';
con.Address_Line_3__c='Testtsstts';
con.City_Name__c='Testtsstts';
con.State_Code__c='Testtsstts';
con.Country_Name__c='Testtsstts';
con.FirstName = 'KapilM';
con.LastName = 'Singh';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere13@gmail.com';
con.Email='kapil.nowhere12@gmail.com';
try {
insert con;
}catch(Exception ex){}

if(con.FirstName == NULL){con.FirstName = 'KapilM1';try {update con;}Catch(Exception ex){}}

Contact_Tool_Access__c cta = new Contact_Tool_Access__c();
cta.Name = 'MCORE';
cta.MCORE_IS_Super_Admin__c = true;
cta.CRM_Contact_ID__c = con.Id;
try {
insert cta;
}catch(Exception ex){}

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
//cs.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
try {
insert cs;
}catch(Exception ex){}

List<String> accOwners=new List<String>();
List<String> ccAddresses=new List<String>();
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

//accOwners.add(accounts.get(0).owner.Email);
System.debug('accounts.get(0).owner.Email ==> '+accounts.get(0).owner.Email);
List<AccountTeamMember> accTeam=[Select user.Email from AccountTeamMember where (TeamMemberRole='Customer Business Manager (CBM)' or TeamMemberRole='Customer Business Director') and Accountid =: acc.Id];
List<Contact> superAdmins=[select email from Contact where id in (select CRM_Contact_ID__c from Contact_Tool_Access__c where Name='MCORE' and MCORE_IS_Super_Admin__c=true)];

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 

List<Contact> contList=[select Account.Name,Phone_1__c,Honeywell_ID__c,Email,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Name,Country_Name__c from contact where id =: con.Id];
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
    '<tr><td colspan="2">'+cs.CaseNumber+'</td></tr>'+ 
    '<tr><td colspan="2"><U>Below are the details of the request:</U></td></tr>'+
    '<tr><td><b>Tool Name :</b></td><td>'+cs.Tool_Name__c+'</td></tr>'+ 
    '<tr><td><b>Honeywell ID :</b></td><td>'+contList.get(0).Honeywell_ID__c+'</td></tr>'+ 
    '<tr><td><b>Contact Name :</b></td><td>'+contList.get(0).Name+'</td></tr>'+ 
    '<tr><td><b>Email Address :</b></td><td>'+contList.get(0).Email+'</td></tr>'+ 
    '<tr><td><b>Company Name :</b></td><td>'+contList.get(0).Account.Name+'</td></tr>'+ 
    '<tr><td><b>Contact Phone Number :</b></td><td>'+contList.get(0).Phone_1__c+'</td></tr>'+                    
    '<tr><td valign="top"><b>Contact Address :</b></td><td>'+addr+'</td></tr>'+                    
    '<tr><td colspan="2">Click on the link to access the case:</td></tr>'+
    '<tr><td colspan="2">'+serverURL+'/'+cs.Id+'</td></tr>'+ 
    '<tr><td colspan="2">Thank You,</td></tr>'+ 
    '<tr><td colspan="2">Self service registration team</td></tr>';        
    body=body+'</table></body></html>';       
    mail.setSubject(subject);
    mail.setHtmlBody(body); 
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}


static testMethod void myUniTest1()
{

AfterInsertHelperClass c1 =new AfterInsertHelperClass();

//AfterInsertHelperClass(){}

CaseClassForPublicMethods ccfpm= new CaseClassForPublicMethods();
List<Case> listObjCaseNew =new List<Case>();
Map<ID,Case> oldMap=new Map<ID,Case>();
Test.startTest();
AfterInsertHelperClass.afterInsertMethod(listObjCaseNew,oldMap);
Test.stopTest();
}

}