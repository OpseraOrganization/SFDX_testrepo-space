@isTest
private class UpdateLineItemToClosed_TstCls{
static testmethod void UpdateLineItemToClosed_TstMthd(){

Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI',Market_Name__c='Space');
insert a1;

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
        usr1.TimeZoneSidKey=sysUser.TimeZoneSidKey;
        usr1.LocaleSidKey=sysUser.LocaleSidKey;
        usr1.EmailEncodingKey=sysUser.EmailEncodingKey;
        usr1.LanguageLocaleKey=sysUser.LanguageLocaleKey; 
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
    
Discretionary__c DisRequst = new Discretionary__c(Account__c=a1.id, Campaign__c=cam.id, Estimated_Completion_Date__c = System.today());
insert DisRequst;

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
    
Discretionary_Line_Item__c LineItem=new Discretionary_Line_Item__c(
Approval_Status__c='New',
Plant_Code_Master__c = PlntcodeMstr.ID,
Plant_Code__c = pntcoderec.id,
Discretionary_Request__c=DisRequst.id);
insert LineItem;

LineItem.Site_Comments__c='Close';
update LineItem;
}
}