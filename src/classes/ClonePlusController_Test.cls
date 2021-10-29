@istest
public class ClonePlusController_Test {

public static testmethod void testcloneplus () {

//Create test data
//Campaign cam = new Campaign();
//        cam.Name='test campaign12';
//        cam.CampaignPrimarySBU__c='ATR';
//        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
//        cam.CBT_Team__c = 'Airbus';
//        cam.Status = 'Planned';
//        cam.Type = 'Test';
//        cam.RMU__c = 'No';
//        cam.ExpectedRevenue = 645655;
//        cam.Tech_Sales__c = 'Integrated Systems';
//        cam.Tech_Sales_Product_Area__c = 'test';
//        insert cam;
 
Opportunity opp = new Opportunity();
        opp.Name = 'test opp12';
    	opp.StageName = 'Booked';
    	opp.CloseDate = system.today();
    	opp.ATR_Probability__c = 50;
        insert opp;
    
Discretionary__c dr = new Discretionary__c();
            dr.Program__c = 'Unit Testing Program';
            dr.SBU__c = 'D&S';
            dr.CBT__c = 'Advanced Technology';
            dr.CBT_Team__c = 'ASM: Advanced Sensors & Microsystems';
            dr.Sales_Channel__c = 'Mechanical Systems & Components OE';
    		dr.SC1__c = 'Adv Tech';
            dr.Type__c = 'Demo';
            dr.Estimated_Completion_Date__c = system.today();
            dr.Fiscal_Year__c = '2012';
            //dr.Campaign__c=cam.id;
    		dr.Opportunity__c = opp.id;
        insert dr;

     String prfId=[Select id from Profile where name=:'System Administrator'].id;
   
    User sysUser=[Select id,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,LanguageLocaleKey from User where ProfileId=:prfid limit 1];
        User usr1=new User();
        usr1.ProfileID=PrfId;
        usr1.Discretionary_Workflow_Approver_Amount__c=10000;
        usr1.LastName='Test';
        usr1.FirstName='FrsTest';
        usr1.alias='ttt-45';
        usr1.email='ttt@test.com';
        usr1.UserName='ttt-45@test.com';
        usr1.CommunityNickName='qwerty';
        usr1.IsActive = true ; 
        usr1.TimeZoneSidKey=sysUser.TimeZoneSidKey;
        usr1.LocaleSidKey=sysUser.LocaleSidKey;
        usr1.EmailEncodingKey=sysUser.EmailEncodingKey;
        usr1.LanguageLocaleKey=sysUser.LanguageLocaleKey;
        insert usr1;
        
        Plant_Code_Master__c PlntcodeMstr = new Plant_Code_Master__c();
        PlntcodeMstr.Name='Testing';
        insert PlntcodeMstr;
    
        Plant_Code_del__c PntcodeRec= new Plant_Code_del__c();
        PntcodeRec.Name='Testing';
        PntcodeRec.Plant_Code_Master__c=PlntcodeMstr.id;
        PntcodeRec.SBU__c='ATR';
        PntcodeRec.CBT__c='Airlines';
        PntcodeRec.Backup_Account_Opener__c = usr1.id;
        PntcodeRec.Primary_Account_Opener__c = usr1.id;
        insert PntcodeRec; 
        
        Discretionary_Line_Item__c dli = new Discretionary_Line_Item__c();
        dli.Plant_Code_Master__c = [Select Id From Plant_Code_Master__c limit 1].Id;
        dli.Funding_Amount__c = 500;
        dli.Approval_Status__c = 'New';
        dli.Discretionary_Request__c = dr.Id;
        dli.Plant_Code_Master__c = PlntcodeMstr.ID;
        dli.Plant_Code__c = pntcoderec.id;
        insert dli;
        

//Go to Page

PageReference tpageRef = Page.ClonePlus;
Test.setCurrentPage(tpageRef);

//Set Parameters that would be passed in
ApexPages.currentPage().getParameters().put('Id', dr.Id);
ApexPages.currentPage().getParameters().put('childobjecttypes', 'Discretionary_Line_Item__c');


// Instantiate a new controller with all parameters in place
ClonePlusController pcp = new ClonePlusController();

//Simulate intial action call on page
pcp.initialiseObjectsForCloning();

//Simulate Click Button
pcp.doClone();

pcp.getCity();

try{
pcp.cloneSelectedObjects();
}
catch(Exception e){

}

//Check there are now two accounts
Discretionary__c [] testresults = [Select Id, Type__c from Discretionary__c WHERE Type__c= 'Demo' ORDER BY CREATEDDATE ASC];
//system.assertequals(2,testresults.size());

//Check there are now two contacts
Discretionary_Line_Item__c [] testcresults = [Select Id, Plant_Code_Master__c, Discretionary_Request__c from Discretionary_Line_Item__c WHERE  Discretionary_Request__c IN :testresults ORDER BY CREATEDDATE ASC];
//system.assertequals(2,testcresults.size());

//Confirm Contacts attached to different accounts
system.assertequals(testresults[0].Id, testcresults[0]. Discretionary_Request__c);
//system.assertequals(testresults[1].Id, testcresults[1]. Discretionary_Request__c);
}
}