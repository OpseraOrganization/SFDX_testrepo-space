@isTest (seeAllData=true)
public class UpdatePlatformsAff_Test {
    static testMethod void UPAtestMethod1()
    {        
        test.startTest();
        
        Id srRecId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get('SR(General)').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@nttdata.com';
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
        
        Service_Request__c sr = new Service_Request__c();
        sr.Subject__c='Test Subject';
        sr.SR_Type__c='VOC';
        sr.SR_Site__c='Toronto';
        sr.Priority__c='AOG';
        sr.RecordTypeId =srRecId;
        sr.Status__c='open';
        sr.Risk_Assessment__c='Red';
        sr.Problem_Description__c='Test Problem';
        sr.Deliverable__c='Test Deliverable';
        //sr.VOC_Card_Numb__c='';
        sr.Contact_Name__c=con.Id;    
        //sr.HON_Commit_Date__c=system.today()+1;
        sr.Customer_Due_Date__c=datetime.now();
        sr.Complexity_Level__c='1-Part Price/Availability';
        //sr.Allow_Past_HON_commit_Date__c = TRUE;
        insert sr;
        
        Platform__c pt = new Platform__c();
        pt.Name='Test Platform1';
        pt.Platform_Type__c='Airplane';
        pt.Model__c='Test Model';
        pt.Make__c='Test Make';
        pt.Managing_SBU__c='ATR';
        pt.SRD_Supported__c =true;
        insert pt;
        
        Platform__c ptf = new Platform__c();
        ptf.Name='Test Platform';
        ptf.Platform_Type__c='Airplane';
        ptf.Model__c='Test Model';
        ptf.Make__c='Test Make';
        ptf.Managing_SBU__c='ATR';
        ptf.Parent_Platform__c=pt.id;
        ptf.SRD_Supported__c =true;
        insert ptf;
        
        Platform__c ptf1 = new Platform__c();
        ptf1.Name='Test Platform1';
        ptf1.Platform_Type__c='Airplane';
        ptf1.Model__c='Test Model';
        ptf1.Make__c='Test Make';
        ptf1.Managing_SBU__c='ATR';
        ptf1.SRD_Supported__c =true;
        insert ptf1;
        
        ptf.Parent_Platform__c=ptf1.id;
        update ptf;
        
        Aircraft_Platforms_Affected__c apa = new Aircraft_Platforms_Affected__c();
        apa.Aircraft_Platforms_Affected__c=ptf1.Id;
        apa.Service_Request__c=sr.Id;
        
        insert apa;
        
        apa.SRD_Supported__c =true;
        update apa;
        
    } 
    
}