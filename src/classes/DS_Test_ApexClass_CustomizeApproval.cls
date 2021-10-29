/** * File Name: DS_Test_ApexClass_CustomizeApproval
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest(SeeAllData=true)
Public class DS_Test_ApexClass_CustomizeApproval{
    static testMethod void ApexClass_CustomizeApproval(){
        user tstuser = [select id from user where name = 'sfdc admin' limit 1];
        Date d1 =Date.newInstance(2009,08,12);
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
        Account a1 = [SELECT id,Name,Strategic_Business_Unit__c,CBT__c from Account where Strategic_Business_Unit__c = 'D&S' and CBT__c = 'HTSI' and Customer_Status__c='Active' and (Not Name Like '%Various%') limit 1];
        //insert a1;
        Opportunity o1 = new Opportunity(Name='Complexopp',Type ='Complex',Accountid=a1.Id,StageName='Prospecting',CloseDate=d1 );
        insert o1;
        Opportunity_Gate__c og =new  Opportunity_Gate__c(Name = 'testopp',Opportunity__c = o1.Id);
        insert og;
        Opportunity_Gate_Approval_History__c oh = new Opportunity_Gate_Approval_History__c(Email__c = 'sumithamenon@gmail.com',
        Opportunity_Gate__c = og.Id,Approval_Status__c='Approved');
        insert oh;
        
        Planned_Meeting_Attendee__c plm=new Planned_Meeting_Attendee__c(
        Accepted__c=true,Declined__c =false,opportunity__C=o1.Id);
        insert plm;
     
        System.currentPagereference().getParameters().put('PMRecord', plm.Id);
        
        Discretionary__c DiscNew=new Discretionary__c (SBU__c='D&S', Type__c = 'Demo', cbt__C= 'HTSI',Campaign__c=cam.id,Estimated_Completion_Date__c = System.today());
        insert DiscNew;
        
        Discretionary_Approval_history__c disApp=new Discretionary_Approval_history__c(Approval_Status__c='Approved',
        Is_Discretionary_Closed__c = True,
        Discretionary__c=DiscNew.id);
        insert disApp;
        
        System.currentPagereference().getParameters().put('DiscretionaryRecord', disApp.Id);
        Plant_Code_Master__c PlntcodeMstr = new Plant_Code_Master__c();
        PlntcodeMstr.Name='Testing';
        insert PlntcodeMstr;
        Plant_Code_del__c PntcodeRec= new Plant_Code_del__c();
        PntcodeRec.Name='Testing';
        PntcodeRec.Plant_Code_Master__c=PlntcodeMstr.id;
        PntcodeRec.SBU__c='ATR';
        PntcodeRec.CBT__c='Airlines';
        PntcodeRec.Backup_Account_Opener__c = tstuser.id;
        PntcodeRec.Primary_Account_Opener__c = tstuser.id;
        insert PntcodeRec;     
    
        Discretionary_Line_Item__c DiscLineItem=new Discretionary_Line_Item__c(
        Discretionary_Request__c= DiscNew.Id,
        Plant_Code_Master__c = PlntcodeMstr.ID,
        Plant_Code__c = PntcodeRec.id
        );
        insert DiscLineItem;
        Discretionary_Line_Item_Approval_History__c DisLinApp=new Discretionary_Line_Item_Approval_History__c(Approval_Status__c='Approved',
        Discretionary_Line_Item__c=DiscLineItem.Id);
        insert DisLinApp;
    
        System.currentPagereference().getParameters().put('Approve','True');
        CustomizeApproval k= new CustomizeApproval();
        k.updateApprovalrecord();
        System.currentPagereference().getParameters().put('DiscretionaryLineItemApprovalHistoryRecord', DisLinApp.Id);
        System.currentPagereference().getParameters().put('Record', oh.Id);
        System.currentPagereference().getParameters().put('Approve','True');
        CustomizeApproval c = new CustomizeApproval();
        c.updateApprovalrecord();
        System.assertEquals('Approved',oh.Approval_Status__c);
        System.currentPagereference().getParameters().put('Approve','False');
        System.currentPagereference().getParameters().put('Close','True');
        c.updateApprovalrecord();
    
        System.currentPagereference().getParameters().put('Approve','False');
        System.currentPagereference().getParameters().put('Close','False');
        System.currentPagereference().getParameters().put('Reject','True');
        c.updateApprovalrecord();
        System.currentPagereference().getParameters().put('Decline','True');  
        c.updateApprovalrecord(); 
  
        Campaign c1 = new Campaign(Name='Complexcamp',Type ='Complex',Account_Name__c=a1.Id );
        insert c1;
        Campaign_Gate__c cg = new  Campaign_Gate__c(Name = 'camp gate' , campaign__c = c1.id);
        insert cg;
        Campaign_Gate_Approval_History__c ch1 = new Campaign_Gate_Approval_History__c(Email__c = 'sumithamenon@gmail.com',Campaign_Phase__c = cg.Id);
        insert ch1;
        System.currentPagereference().getParameters().put('CampaignRecord', ch1.Id);
        System.currentPagereference().getParameters().put('Approve','True'); 
        CustomizeApproval d = new CustomizeApproval();
        d.updateApprovalrecord();
        System.currentPagereference().getParameters().put('Approve','False');
        System.currentPagereference().getParameters().put('Close','True');
        d.updateApprovalrecord();
        System.currentPagereference().getParameters().put('Approve','False');
        System.currentPagereference().getParameters().put('Close','False');
        System.currentPagereference().getParameters().put('Reject','True');
        d.updateApprovalrecord();
        System.currentPagereference().getParameters().put('DiscretionaryRecord', null);
        System.currentPagereference().getParameters().put('Close','True');
        d.updateApprovalrecord();
    }
}