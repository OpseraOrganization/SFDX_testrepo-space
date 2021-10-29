@isTest (seealldata=true)
private class UpdateIsAttachmentFieldForFTPTest{
static testMethod void myUnitTest(){
List<ENZ__FTPAttachment__c> ftpInserList=new List<ENZ__FTPAttachment__c>();
date testdate = System.today();
/*
Account acc = new Account();
acc.Name = 'Honeywell Test';
acc.Customer_Status__c = 'Active';
acc.Strategic_Business_Unit__c = 'ATR';
acc.CBT__c = 'Airbus';
acc.Region_Name__c = 'Americas';
acc.Sub_Region_Name__c = 'Canada';
acc.Service_Level__c = 'Standard';
acc.Type = 'OEM';
acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';

insert acc;

Contact con = new Contact();
con.LastName = 'Singh';
con.FirstName = 'Kapil';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
con.Email='kapil.nowhere@gmail.com';
insert con;
*/
 Contact con=[select id,AccountId from contact where Contact_Status__c='Active' and Employee_Contact_Role__c='Analyst' limit 1];
Case cs = new Case();
cs.Origin = 'Phone';
cs.Status = 'Open';
cs.ContactId = con.Id;
cs.Classification__c = 'GTO Field Service';
cs.HON_Commit_Date__c = System.now() + 1;
cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
cs.Government_Compliance_SM_M_Content__c = 'NO';

try {
        insert cs;
          
        ENZ__FTPAttachment__c ftpa1=new ENZ__FTPAttachment__c();
        ftpa1.name='Test FTP attachment';
        ftpa1.ENZ__Case__c=cs.id;
        //insert ftpa1;
        ftpInserList.add(ftpa1);      
               
    }catch(Exception ex){
            
     }
Event__c evt = new Event__c();
evt.Name = 'Test Event';
insert evt;

//Test.startTest();

ENZ__FTPAttachment__c ftpa2=new ENZ__FTPAttachment__c();
ftpa2.name='Test FTP attachment';
ftpa2.Event__c=evt.id;
//insert ftpa2;
ftpInserList.add(ftpa2);  

Planned_Meeting__c pm = new Planned_Meeting__c();
pm.Assigned_To__c = [SELECT id FROM User limit 1].Id;
pm.Name = 'Test PM';
pm.Location__c = 'Bangalore';
pm.Start_Date__c = testdate;
pm.End_Date__c = testdate;
pm.Meeting_Purpose__c = 'Test meeting';
pm.SBU__c = 'ATR';
pm.CBT__c = 'Airbus';

insert pm;

ENZ__FTPAttachment__c ftpa3=new ENZ__FTPAttachment__c();
ftpa3.name='Test FTP attachment';
ftpa3.Planned_Meeting__c=pm.id;
//insert ftpa3;
ftpInserList.add(ftpa3);  
Field_Event__c fe = new Field_Event__c();
fe.Report_Type__c = 'APU';
fe.Contact__c = con.id;
fe.Report_Date__c = testdate;
fe.Event_Date__c = System.now(); //Date time
fe.Product_Type__c = 'Bendix-King';
fe.Catalog_Product_Group__c = 'Displays(BK)';
fe.Supported_Product__c = 'Displays';
fe.Product_Model__c = '131-9A';
fe.Engine_APU_Reported_S_N__c = '12345';
fe.Aircraft_Type__c = [SELECT Id FROM Platform__c where Active__c = true limit 1].Id;
fe.Operational_Symptom__c = 'A/C Delivery';
fe.Effect_on_Operation__c = 'Air Turnback';
fe.IFSD_ETOPS__c = 'YES';
fe.Shutdown_Details__c = 'Ground';
fe.Engine_Removal__c = 'YES';

insert fe;

ENZ__FTPAttachment__c ftpa4=new ENZ__FTPAttachment__c();
ftpa4.name='Test FTP attachment';
ftpa4.Field_Event__c=fe.id;
//insert ftpa4;
ftpInserList.add(ftpa4);  
Service_Request__c sr = new Service_Request__c();
sr.Subject__c = 'Test';
sr.SR_Type__c = 'VOC';
sr.Priority__c = 'AOG';
sr.Status__c = 'Open';
//sr.Problem_Description__c = 'Test';
sr.Deliverable__c = 'Test';
sr.Risk_Assessment__c = 'Red';
sr.Contact_Name__c = con.Id;
sr.Customer_Due_Date__c = System.now()+2;
//sr.HON_Commit_Date__c = System.now()+2;
sr.Attribute_Details__c = 'Value';
sr.Complexity_Level__c = '1-Part Price/Availability';

insert sr;

ENZ__FTPAttachment__c ftpa5=new ENZ__FTPAttachment__c();
ftpa5.name='Test FTP attachment';
ftpa5.Service_Request__c=sr.id;
//insert ftpa5;
ftpInserList.add(ftpa5);  
Solution sol = new Solution();
sol.FAQ__c = 'FAQ';
sol.Export_Controlled__c = 'NO';
sol.Categorization__c = 'Database';
sol.SolutionName = 'Test Solution';
sol.Product_Type__c = 'Bendix-King';
sol.Catalog_Product_Group__c = 'Displays(BK)';
sol.Supported_Product__c = 'Displays';
sol.Audit_Frequency__c = 'Biennal';
sol.Publish_Internal__c = true;
insert sol;

ENZ__FTPAttachment__c ftpa6=new ENZ__FTPAttachment__c();
ftpa6.name='Test FTP attachment';
ftpa6.ENZ__Solution__c=sol.id;
//insert ftpa6;
ftpInserList.add(ftpa6);  
Service_Recovery_Report__c srr = new Service_Recovery_Report__c();
srr.Report_Type__c = 'Field Training';
srr.Revenue__c = 100;
srr.Problem_Description__c = 'Test Problem';
//srr.HON_Commit_Date__c = testdate;
srr.Customer_Request_Date__c = testdate;
srr.Status__c = 'No Bid';

insert srr;

ENZ__FTPAttachment__c ftpa7=new ENZ__FTPAttachment__c();
ftpa7.name='Test FTP attachment';
ftpa7.Service_Recovery_Report__c=srr.id;
//insert ftpa7;
ftpInserList.add(ftpa7); 
insert  ftpInserList;
//List<ENZ__FTPAttachment__c> ftpAttList=new List<ENZ__FTPAttachment__c>();

//ftpAttList.add(ftpa2);
//ftpAttList.add(ftpa3);
//ftpAttList.add(ftpa4);
//ftpAttList.add(ftpa5);
//ftpAttList.add(ftpa6);
//ftpAttList.add(ftpa7);
delete ftpInserList;
//Test.stopTest();
}
}