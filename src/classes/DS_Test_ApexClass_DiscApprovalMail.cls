/** * File Name: DS_Test_ApexClass_DiscApprovalMail
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public with sharing class DS_Test_ApexClass_DiscApprovalMail {
static testmethod void DiscAppMail(){
    String prfId=[Select id from Profile where name=:'System Administrator'].id;
   
    User sysUser=[Select id,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,LanguageLocaleKey from User where ProfileId=:prfid limit 1];
    User usr=new User();
    usr.ProfileID=PrfId;
    usr.Discretionary_Workflow_Approver_Amount__c=60000;
    usr.LastName='Test';
    usr.FirstName='FTest';
    usr.alias='ttt-1';
    usr.email='ttt@test.com';
    usr.UserName='ttt-1@test.com';
    usr.CommunityNickName='qwerty';
    usr.TimeZoneSidKey=sysUser.TimeZoneSidKey;
    usr.LocaleSidKey=sysUser.LocaleSidKey;
    usr.EmailEncodingKey=sysUser.EmailEncodingKey;
    usr.LanguageLocaleKey=sysUser.LanguageLocaleKey;
    insert usr;
    
    Plant_Code_Master__c PlntcodeMstr = new Plant_Code_Master__c();
    PlntcodeMstr.Name='Testing';
    insert PlntcodeMstr;
    
    Plant_Code_del__c PntcodeRec= new Plant_Code_del__c();
    PntcodeRec.Name='Testing';
    PntcodeRec.Plant_Code_Master__c=PlntcodeMstr.id;
    PntcodeRec.SBU__c='ATR';
    PntcodeRec.CBT__c='Airlines';
    PntcodeRec.Backup_Account_Opener__c = usr.id;
    PntcodeRec.Primary_Account_Opener__c = usr.id;
    insert PntcodeRec; 
    
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
    
    System.runAs(usr){
    Campaign_Disc_Budget__c cdb = new Campaign_Disc_Budget__c();
    cdb.name='test';
    cdb.status__c = 'Open';
    insert cdb;
    Discretionary__c dc=new Discretionary__c();
    dc.Approval_Status__c='Approved';
    dc.type__c = 'Direct Sell';
    dc.Discretionary_100k_Budget__c = cdb.id;
    dc.Estimated_Completion_Date__c = System.today();
    dc.Campaign__c=cam.id;
    insert dc;
    dc.Current_Approver__c=usr.LastName;
    update dc;
    
    DC.Approval_Status__c='Pending';
    update DC;
    System.assertEquals('Pending',DC.Approval_Status__c);
    System.Debug('DC'+dc+'Total_Request_Amount_rollup__c'+dc.Total_Request_Amount_rollup__c);
        
    System.currentPagereference().getParameters().put('Id', dc.Id);
    ApexPages.StandardController cont=new ApexPages.StandardController(dc);
    DiscretionaryApprovalMail DiscAppmail=new DiscretionaryApprovalMail(cont);
    PageReference PR=DiscAppmail.sendMail();
    
    Discretionary__c dc1=new Discretionary__c();
    dc1.Approval_Status__c='Approved';
    dc1.type__c = 'Direct Sell';
    dc1.Campaign__c=cam.id;
    dc1.Estimated_Completion_Date__c = System.today();
    insert dc1;
    
    Discretionary_Line_Item__c DLI=new Discretionary_Line_Item__c();
    DLI.Discretionary_Request__c = dc1.Id;
    dli.Plant_Code_Master__c = PlntcodeMstr.ID;
    dli.Plant_Code__c = pntcoderec.id;
    insert DLI;
    
    Discretionary_Spend__c DS=new Discretionary_Spend__c();
    DS.Discretionary_Line_Item__c=DLI.Id;
    DS.Weekly_Actuals__c=130;
    insert DS;
    
    DLI.Funding_Amount__c=5000;
    update DLI;
    
    System.Debug('DLI'+DLI);
    dc1.Approval_Status__c='Pending';
    update dc1;
    
    System.currentPagereference().getParameters().put('Id', dc1.Id);
    System.Debug('DC1---'+dc1.id);
    dc1.Approval_Status__c='New';
    update dc1;
    dc1.Current_Approver__c='dfdg';
  //  update dc1;
    System.Debug('DC1->'+dc1+'$$$'+dc1.Total_Request_Amount_rollup__c+'###'+dc1.Discretionary_Workflow_Approver_Amount__c);
    System.Debug('DC1'+dc1+'Current_ManagerName_Formulae__c'+dc1.Current_ManagerName_Formulae__c);
    
    ApexPages.StandardController cont1=new ApexPages.StandardController(dc1);
    DiscretionaryApprovalMail DiscAppmail1=new DiscretionaryApprovalMail(cont1);
    PageReference PR1=DiscAppmail1.sendMail();
    
    Discretionary__c dc2=new Discretionary__c();
    dc2.Approval_Status__c='Approved';
    dc2.type__c = 'Direct Sell';
    dc2.Estimated_Completion_Date__c = System.today();
   // insert dc2;
    
    Discretionary_Line_Item__c DLI1=new Discretionary_Line_Item__c();
    DLI1.Discretionary_Request__c = dc2.Id;
   // insert DLI1;
    
    Discretionary_Spend__c DS1=new Discretionary_Spend__c();
    DS1.Discretionary_Line_Item__c=DLI1.Id;
    DS1.Weekly_Actuals__c=130;
   // insert DS1;
    
  //  DLI1.Funding_Amount__c=70000;
  //  update DLI1;
    
    System.Debug('DLI1'+DLI1);
    dc2.Approval_Status__c='Pending';
   // update dc2;
    
    System.currentPagereference().getParameters().put('Id', dc2.Id);
    System.Debug('DC2---'+dc2.id);
    dc2.Approval_Status__c='New';
   // update dc2;
    dc2.Current_Approver__c='dfdg';
    //update dc2;
    System.Debug('DC2->'+dc2+'$$$'+dc2.Total_Request_Amount_rollup__c+'###'+dc2.Discretionary_Workflow_Approver_Amount__c);
    
    ApexPages.StandardController cont2=new ApexPages.StandardController(dc2);
    DiscretionaryApprovalMail DiscAppmail2=new DiscretionaryApprovalMail(cont2);
    PageReference PR2=DiscAppmail2.sendMail();
    
    //BaseEmailTemplate Base=new BaseEmailTemplate();
    String str1='';
    String str2='Sample';
    String str3=DiscAppmail2.checknull(str1);
    String str4=DiscAppmail2.checknull(str2);
    
    PageReference PR3=DiscAppmail2.Back();

    }
  /*   User usr8=new User();
    usr8.ProfileID=PrfId;
    usr8.Discretionary_Workflow_Approver_Amount__c=1000;
    usr8.LastName='Test2';
    usr8.FirstName='FTest2';
    usr8.alias='ttt-1';
    usr8.email='ttt@test.com';
    usr8.UserName='ttt-11@test.com';
    usr8.CommunityNickName='qwertyu';
    usr8.TimeZoneSidKey=sysUser.TimeZoneSidKey;
    usr8.LocaleSidKey=sysUser.LocaleSidKey;
    usr8.EmailEncodingKey=sysUser.EmailEncodingKey;
    usr8.LanguageLocaleKey=sysUser.LanguageLocaleKey;
    usr8.managerid=usr.id;
    insert usr8;
    System.runAs(usr8){
        
   Discretionary__c dcr=new Discretionary__c();
    dcr.Approval_Status__c='Approved';
    dcr.type__c = 'Direct Sell';
    dcr.Estimated_Completion_Date__c = System.today();
    insert dcr;
     Discretionary_Line_Item__c DLIT=new Discretionary_Line_Item__c();
    DLIT.Discretionary_Request__c = dcr.Id;
    insert DLIT;
   DLIT.Funding_Amount__c=5000;
    update DLIT;
    Discretionary_Line_Item__c DLITM=new Discretionary_Line_Item__c();
     DLITM.Discretionary_Request__c = dcr.Id;
    insert DLITM;
    DLITM.Funding_Amount__c=5000;
    update DLITM;
    
}*/
}
}