/** * File Name: DS_Test_Trigger_Discretionary_Workflow
* Description Test Method
* * @author : NTT Data
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest(SeeAllData=true)
Public class DS_Test_Trigger_Discretionary_Workflow{
    static testMethod void Discretionary_Workflow_Test(){
        
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
        
        User usr=new User();
        usr.ProfileID=PrfId;
        usr.Discretionary_Workflow_Approver_Amount__c=1000;
        usr.LastName='Test1';
        usr.FirstName='FrsTest1';
        usr.alias='ttt-46';
        usr.email='ttt@test.com';
        usr.UserName='ttt-46@test.com';
        usr.CommunityNickName='qwerty1';
        usr.TimeZoneSidKey=sysUser.TimeZoneSidKey;
        usr.LocaleSidKey=sysUser.LocaleSidKey;
        usr.EmailEncodingKey=sysUser.EmailEncodingKey;
        usr.LanguageLocaleKey=sysUser.LanguageLocaleKey; 
        usr.ManagerId=usr1.Id;
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
            Account acc=new Account();
            acc.name='Sample';
            insert acc;
            
            Opportunity opp=new Opportunity();
            opp.Name='Sample Opp';
            opp.Account=acc;
            opp.stageName='Prospecting';
            opp.closeDate=System.today();
            opp.Tech_Sales_Product_Area__c='Integrated Avionics';
            opp.SBU__c='D&S';
            opp.CBT_Tier_2__c='Boeing BDS';
            opp.Proposal_Submitted_Date__c = System.today();
            opp.RFP_Expected_Date__c = System.today();
            opp.Proposal_Complexity_Description__c = 'test';
            opp.Ship_Set_Parts__c = 'test';
            opp.Ship_Set_Quantity__c = 11;
            opp.Certification_Requirements__c = 'FAR 15 TINA';
            opp.Ship_Set_Delivery_Period__c = 'test';
            opp.Proposal_Due_Date__c = System.today();
            opp.Proposal_Kickoff_Date__c = System.today();

            insert opp;
            
            Campaign cmp=new Campaign();
            cmp.name='Sample Campaign';
            insert cmp;
        test.starttest();            
            Discretionary__c DR=new Discretionary__c();
            DR.Type__c='Direct Sell';
            DR.Opportunity__c=NULL;
            DR.Campaign__c=cam.id;
            DR.Estimated_Completion_Date__c = System.today();
            insert DR;
            
            Discretionary__c DR1=new Discretionary__c();
            DR1.Type__c='Direct Sell';
            DR1.Opportunity__c=opp.id;
            DR1.Estimated_Completion_Date__c = System.today();
            insert DR1;
            
            Discretionary__c DR2=new Discretionary__c();
            DR2.Type__c='Direct Sell';
            DR2.Campaign__c=cmp.id;
            DR2.Estimated_Completion_Date__c = System.today();
            insert DR2;
            
            Discretionary__c DR3=new Discretionary__c();
            DR3.Type__c='Direct Sell';
            DR3.SBU__c=NULL;
            DR3.Campaign__c=cam.id;
            DR3.Backup_EmailId__c='test_mail@test.com.r1';
            DR3.Approver_EmailId__c='hgf@qwerty.com';
            DR3.Estimated_Completion_Date__c = System.today();
            insert DR3;
            
            Discretionary__c DR4=new Discretionary__c();
            DR4.Type__c='Direct Sell';
           // DR4.CBT__c=NULL;
            DR4.Backup_EmailId__c='ttt@test.com.r1';
            DR4.Campaign__c=cam.id;
            DR4.Estimated_Completion_Date__c = System.today();
            insert DR4;
            System.Debug('DR4'+DR4);
            
            Discretionary_Approval_history__c DAH=new Discretionary_Approval_history__c();
            DAH.Discretionary__c=DR4.id;
            DAH.SendApproval_Level1__c=FALSE;
            DAH.Approval_Status__c='Pending Approval';
            DAH.SendApproval_Level2__c=FALSE;
            //DAH.DiscretionaryBakupApproverEmailFormulae__c=Dr4.Backup_EmailId__c;
            insert DAH;
             DAH.SendApproval_Level1__c=TRUE;
             update DAH;
            System.Debug('DAH'+DAH);
            
            Discretionary_Approval_history__c DAH1=new Discretionary_Approval_history__c();
            DAH1.Approval_Status__c='Pending Approval';
            DAH1.SendApproval_Level2__c=FALSE;
            DAH1.Discretionary__c=DR3.id;
            insert DAH1;
            DAH1.SendApproval_Level2__c=true;
            DAH1.SendApproval_Level3__c = TRUE;
            update DAH1;
            System.Debug('DAH1'+DAH1.DiscretionaryApproverEmailFormulae__c);          
            
            Discretionary_Approval_history__c DAH2=new Discretionary_Approval_history__c();
            DAH2.Approval_Status__c='Rejected';
            DAH2.Discretionary__c=DR.id;
            insert DAH2;
            DAH2.Approval_Status__c='Approved';
            DAH2.Is_Discretionary_Closed__c = True;
            update DAH2;           
            
            Discretionary_Approval_history__c DAH3=new Discretionary_Approval_history__c();
            DAH3.SendApproval_Level1__c=true;
            DAH3.Approval_Status__c='Approved';
            DAH3.Discretionary__c=DR1.id;
            insert DAH3;
            DAH3.Approval_Status__c='Rejected';
            update DAH3;
            
            List<Discretionary_Approval_history__c> ApproveobjRec=new List<Discretionary_Approval_history__c>();
            List <String> discReject=new List <String>();
           
            
            ApproveObjRec.add(DAH);
            ApproveObjRec.add(DAH1);
            discreject.add(DAH3.Discretionary__c);
            
            Discretionary_Line_item__c DLI=new Discretionary_Line_item__c();
            DLI.Funding_Amount__c=4000;
            DLI.Discretionary_Request__c = DR.id;
            dli.Plant_Code_Master__c = PlntcodeMstr.ID;
            dli.Plant_Code__c = pntcoderec.id;
            insert DLI;
            
            Discretionary_Line_Item_Approval_History__c DLIAH=new Discretionary_Line_Item_Approval_History__c();
            DLIAH.Discretionary_Line_Item__c=DLI.id;
            insert DLIAH;
            DLIAH.Approval_Status__c='Pending Close';
            DLIAH.Level1__c=TRUE;
            update DLIAH;
            System.assertEquals('Pending Close',DLIAH.Approval_Status__c);
            
            
           DR1.Approval_Status__c = 'Open';
           update DR1;
           Discretionary_Line_item__c DLNew=new Discretionary_Line_item__c();
           DLNew.Funding_Amount__c=4000;
           DLNew.Discretionary_Request__c = DR1.id;
           dlnew.Plant_Code_Master__c = PlntcodeMstr.ID;
            dlnew.Plant_Code__c = pntcoderec.id;
            insert DLNew;
            
        /*   Discretionary_Line_item__c DLNew1=new Discretionary_Line_item__c();
           DLNew1.Funding_Amount__c=4000;
           DLNew.Approval_Status__c = 'New';
           DLNew1.Discretionary_Request__c = DR1.id;
            insert DLNew1;*/
            
     test.stoptest();       
           // opp.RFP_Request_Date__c=System.Today();
         //   update opp;
            
            
        }
    }
    static testMethod void Discretionary_Workflow_Test1(){
        
        String prfId=[Select id from Profile where name=:'System Administrator'].id;
        User sysUser=[Select id,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,LanguageLocaleKey from User where ProfileId=:prfid limit 1];
        User usr1=new User();
        usr1.ProfileID=PrfId;
        usr1.Discretionary_Workflow_Approver_Amount__c=null;
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
        
        User usr=new User();
        usr.ProfileID=PrfId;
        usr.Discretionary_Workflow_Approver_Amount__c=1000;
        usr.LastName='Test1';
        usr.FirstName='FrsTest1';
        usr.alias='ttt-46';
        usr.email='ttt@test.com';
        usr.UserName='ttt-46@test.com';
        usr.CommunityNickName='qwerty1';
        usr.TimeZoneSidKey=sysUser.TimeZoneSidKey;
        usr.LocaleSidKey=sysUser.LocaleSidKey;
        usr.EmailEncodingKey=sysUser.EmailEncodingKey;
        usr.LanguageLocaleKey=sysUser.LanguageLocaleKey; 
        usr.ManagerId=usr1.Id;
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
            Account acc=new Account();
            acc.name='Sample';
            insert acc;
            
            Opportunity opp=new Opportunity();
            opp.Name='Sample Opp';
            opp.Account=acc;
            opp.stageName='Prospecting';
            opp.closeDate=System.today();
            opp.Tech_Sales_Product_Area__c='Integrated Avionics';
            opp.SBU__c='D&S';
            opp.CBT_Tier_2__c='Boeing BDS';
            opp.Proposal_Submitted_Date__c = System.today();
            opp.RFP_Expected_Date__c = System.today();
            opp.Proposal_Complexity_Description__c = 'test';
            opp.Ship_Set_Parts__c = 'test';
            opp.Ship_Set_Quantity__c = 11;
            opp.Certification_Requirements__c = 'FAR 15 TINA';
            opp.Ship_Set_Delivery_Period__c = 'test';
            opp.Proposal_Due_Date__c = System.today();
            opp.Proposal_Kickoff_Date__c = System.today();
            insert opp;
            
            Campaign cmp=new Campaign();
            cmp.name='Sample Campaign';
            insert cmp;
    test.starttest();                
            Discretionary__c DR=new Discretionary__c();
            DR.Type__c='Direct Sell';
            DR.Opportunity__c=NULL;
            DR.Campaign__c=cam.id;
            DR.Estimated_Completion_Date__c = System.today();
            insert DR;
            
            Discretionary__c DR1=new Discretionary__c();
            DR1.Type__c='Direct Sell';
            DR1.Opportunity__c=opp.id;
            DR1.Estimated_Completion_Date__c = System.today();
            insert DR1;
            
            Discretionary__c DR2=new Discretionary__c();
            DR2.Type__c='Direct Sell';
            DR2.Campaign__c=cmp.id;
            DR2.Estimated_Completion_Date__c = System.today();
            insert DR2;
            
            Discretionary__c DR3=new Discretionary__c();
            DR3.Type__c='Direct Sell';
            DR3.SBU__c=NULL;
            DR3.Campaign__c=cmp.id;
            DR3.Backup_EmailId__c='test_mail@test.com.r1';
            DR3.Approver_EmailId__c='hgf@qwerty.com';
            DR3.Estimated_Completion_Date__c = System.today();
            insert DR3;
            
            Discretionary__c DR4=new Discretionary__c();
            DR4.Type__c='Direct Sell';
            DR4.Campaign__c=cmp.id;
           // DR4.CBT__c=NULL;
            DR4.Backup_EmailId__c='ttt@test.com.r1';
            DR4.Estimated_Completion_Date__c = System.today();
            insert DR4;
            System.Debug('DR4'+DR4);
            
            Discretionary_Approval_history__c DAH=new Discretionary_Approval_history__c();
            DAH.Discretionary__c=DR4.id;
            DAH.SendApproval_Level1__c=FALSE;
            DAH.Approval_Status__c='Pending Approval';
            DAH.SendApproval_Level2__c=FALSE;
            //DAH.DiscretionaryBakupApproverEmailFormulae__c=Dr4.Backup_EmailId__c;
            insert DAH;
             DAH.SendApproval_Level1__c=TRUE;
             update DAH;
            System.Debug('DAH'+DAH);
            
            Discretionary_Approval_history__c DAH1=new Discretionary_Approval_history__c();
            DAH1.Approval_Status__c='Pending Approval';
            DAH1.SendApproval_Level2__c=FALSE;
            DAH1.Discretionary__c=DR3.id;
            insert DAH1;
            DAH1.SendApproval_Level2__c=true;
            DAH1.SendApproval_Level3__c = TRUE;
            update DAH1;
            System.Debug('DAH1'+DAH1.DiscretionaryApproverEmailFormulae__c);          
            
            Discretionary_Approval_history__c DAH2=new Discretionary_Approval_history__c();
            DAH2.Approval_Status__c='Rejected';
            DAH2.Discretionary__c=DR.id;
            insert DAH2;
            DAH2.Approval_Status__c='Approved';
            DAH2.Is_Discretionary_Closed__c = True;
            update DAH2;           
            
            Discretionary_Approval_history__c DAH3=new Discretionary_Approval_history__c();
            DAH3.SendApproval_Level1__c=true;
            DAH3.Approval_Status__c='Approved';
            DAH3.Discretionary__c=DR1.id;
            insert DAH3;
            DAH3.Approval_Status__c='Rejected';
            update DAH3;
            
            List<Discretionary_Approval_history__c> ApproveobjRec=new List<Discretionary_Approval_history__c>();
            List <String> discReject=new List <String>();
           
            
            ApproveObjRec.add(DAH);
            ApproveObjRec.add(DAH1);
            discreject.add(DAH3.Discretionary__c);
            
            Discretionary_Line_item__c DLI=new Discretionary_Line_item__c();
            DLI.Funding_Amount__c=4000;
            DLI.Discretionary_Request__c = DR.id;
            dli.Plant_Code_Master__c = PlntcodeMstr.ID;
            dli.Plant_Code__c = pntcoderec.id;
            insert DLI;
            
            Discretionary_Line_Item_Approval_History__c DLIAH=new Discretionary_Line_Item_Approval_History__c();
            DLIAH.Discretionary_Line_Item__c=DLI.id;
            insert DLIAH;
            DLIAH.Approval_Status__c='Pending Close';
            DLIAH.Level1__c=TRUE;
            update DLIAH;
            System.assertEquals('Pending Close',DLIAH.Approval_Status__c);
            
           DR1.Approval_Status__c = 'Open';
           update DR1; 
           Discretionary_Line_item__c DLNew=new Discretionary_Line_item__c();
           DLNew.Funding_Amount__c=4000;
           DLNew.Discretionary_Request__c = DR1.id;
           dlnew.Plant_Code_Master__c = PlntcodeMstr.ID;
            dlnew.Plant_Code__c = pntcoderec.id;
            insert DLNew;
            
       /*    Discretionary_Line_item__c DLNew1=new Discretionary_Line_item__c();
           DLNew1.Funding_Amount__c=4000;
           DLNew1.Discretionary_Request__c = DR1.id;
            insert DLNew1;*/
            
        test.stoptest();    
           // opp.RFP_Request_Date__c=System.Today();
         //   update opp;
            
            
        }
    }
}