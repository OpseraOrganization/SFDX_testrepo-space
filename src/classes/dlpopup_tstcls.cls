@isTest
public class dlpopup_tstcls{ 
    static testmethod void dlpopuptest(){
        Plant_Code_Master__c pcm = new Plant_Code_Master__c(Plant_Name__c='Test Plant Code Master');
        insert pcm;
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr1 = new User(LastName = 'Test User',Username = 'honnew@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1honeygto' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',MobilePhone='123');
        insert usr1;
        Campaign cam = new Campaign();
        cam.Name='test campaign12';
        cam.CampaignPrimarySBU__c='ATR';
        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
        cam.CBT_Team__c = 'Airbus';
        cam.Status = 'Planned';
        cam.Type = 'Test';
        cam.RMU__c = 'No';
        cam.ExpectedRevenue = 645655;
        cam.Tech_Sales__c = 'Integrated Systems';
        cam.Tech_Sales_Product_Area__c = 'test';
        insert cam;
        Plant_Code_del__c pc = new Plant_Code_del__c(Plant_Code__c='Test Plant Code',Plant_Code_Master__c=pcm.id,Primary_Account_Opener__c=usr1.id,Backup_Account_Opener__c=usr1.id);
        insert pc;
        Account acc= new Account(name='Test Account');
        insert acc;
        Discretionary__c dr = new Discretionary__c(Account__c=acc.id,Estimated_Completion_Date__c=date.parse('12/12/2014'),Approval_Status__c='New',Campaign__c=cam.id); 
        insert dr;
        Discretionary_Line_Item__c dli=new Discretionary_Line_Item__c (Discretionary_Request__c=dr.id,Approval_Status__c='New',Plant_Code__c=pc.id,Plant_Code_Master__c=pcm.id);  
        insert dli;     
        
        PageReference pageRef = Page.HideButton;
        pageRef.getParameters().put('id',dli.id);
        Test.setCurrentPage(pageRef); 
        
        Discretionary_Line_Item__c dl= new Discretionary_Line_Item__c();         
        ApexPages.StandardController con = new ApexPages.StandardController(dl);
        
        dlpopup pop= new dlpopup(con);       
        pop.submit();   
        pop.acknowledge();
        pop.closeitem();
        dlpopup.iSShowbutton(dli.id);
        pop.submitLtgn();
    }
}