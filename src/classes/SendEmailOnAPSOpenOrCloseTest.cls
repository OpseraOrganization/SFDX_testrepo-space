@isTest
private class SendEmailOnAPSOpenOrCloseTest{
    static testmethod void SendEmailOnAPSOpenOrCloseTest(){
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
        account newAcct = new account();
            newAcct.name = 'test account code coverage2';
            newAcct.type='Distributor';
            newAcct.Strategic_Business_Unit__c='ATR';
            newAcct.Market_Name__c = 'Military';
        insert newAcct;
        System.debug('#####Account#### '+newAcct);
        
        Contact cont=new Contact();
            cont.FirstName='Test Frst Name';
            cont.LastName='Test Contatct Name';
            cont.accountid=newAcct.id;
            cont.Primary_Email_Address__c='test@test.com';
            cont.Email='test@test.com';
            cont.Contact_Is_Employee__c= True;
            cont.Employee_Contact_Role__c='Analyst';
            cont.Employee_Number__c='E128976';
        insert cont;
        System.debug('#####Contact#### '+cont);
       
        Plant_Code_Master__c pcm=new Plant_Code_Master__c();
            pcm.name='Unit Test PCM';
        insert pcm;
        System.debug('#####PlantcodeMaster#### '+pcm);
        
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
            System.debug('#####Campaign#### '+cam);

        Plant_Code_del__c pc=new Plant_Code_del__c();
            pc.name='Unit Test PC';
            pc.Plant_Code_Master__c=pcm.Id;
            Pc.Backup_Account_Opener__c = usr1.id;
            Pc.Primary_Account_Opener__c = usr1.id;
        insert pc;
           System.debug('#####PlantCodeDel#### '+pc);
     
         Opportunity op = [select id from Opportunity limit 1];   
           System.debug('#####Opportunity#### '+op);
     
        Test.startTest();   
        Discretionary__c dr=new Discretionary__c();
            dr.Program__c='Unit Testing Program';
            dr.SBU__c='D&S';
            dr.CBT__c='Advanced Technology';
            dr.CBT_Team__c='ASM: Advanced Sensors & Microsystems';
            dr.CBT_Directorate__c='Advanced Sensing Technology';
            dr.Type__c='Demo';
            dr.GBE__c = 'Safety Systems';
            dr.Estimated_Completion_Date__c = system.today();
            dr.Opportunity__c=op.id;           
        insert dr;
       
        Discretionary_Line_Item__c dli=new Discretionary_Line_Item__c();
            dli.Plant_Code__c=pc.Id;
            dli.Discretionary_Request__c=dr.Id;
            dli.Funding_Amount__c=99.00;
            dli.Approval_Status__c = 'New';
        insert dli;
        
        DR_CC_List_Junction_Object__c cclist = new DR_CC_List_Junction_Object__c();
            cclist.Contact__c = cont.id;
            cclist.Discretionary_Request__c = dr.id;
        insert cclist;
        
        DLI_Site_CC_List__c sitelist = new DLI_Site_CC_List__c();
            sitelist.Contact__c = cont.id;
            sitelist.Discretionary_Line_Item__c = dli.id;
        insert sitelist;
        
        dli.Discretionary_Account__c='Test'+dr.Id;
        try{
        update dli;
        }catch(DMLException e){}
        
        dli.Site_Comments__c='Test Comments Close';
        dli.Approval_Status__c= 'Open';
        try{
        update dli;
        }catch(DMLException ee){}       
        Test.stopTest();
    }   
   static testmethod void SendEmailOnAPSOpenOrCloseTestnew(){ 
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
        account newAcct = new account();
            newAcct.name = 'test account code coverage2';
            newAcct.type='Distributor';
            newAcct.Strategic_Business_Unit__c='ATR';
            newAcct.Market_Name__c = 'Military';
        insert newAcct;
        System.debug('#####Account#### '+newAcct);
        
        Contact cont=new Contact();
            cont.FirstName='Test Frst Name';
            cont.LastName='Test Contatct Name';
            cont.accountid=newAcct.id;
            cont.Primary_Email_Address__c='test@test.com';
            cont.Email='test@test.com';
            cont.Contact_Is_Employee__c= True;
            cont.Employee_Contact_Role__c='Analyst';
            cont.Employee_Number__c='E128976';
        insert cont;
        System.debug('#####Contact#### '+cont);
       
        Plant_Code_Master__c pcm=new Plant_Code_Master__c();
            pcm.name='Unit Test PCM';
        insert pcm;
        System.debug('#####PlantcodeMaster#### '+pcm);
        
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
            System.debug('#####Campaign#### '+cam);

        Plant_Code_del__c pc=new Plant_Code_del__c();
            pc.name='Unit Test PC';
            pc.Plant_Code_Master__c=pcm.Id;
            Pc.Backup_Account_Opener__c = usr1.id;
            Pc.Primary_Account_Opener__c = usr1.id;
        insert pc;
           System.debug('#####PlantCodeDel#### '+pc);
     
         Opportunity op = [select id from Opportunity limit 1];   
           System.debug('#####Opportunity#### '+op);
        Test.startTest();   
        Discretionary__c drnew=new Discretionary__c();
            drnew.Program__c='Unit Testing Program';
            drnew.SBU__c='D&S';
            drnew.CBT__c='Advanced Technology';
            drnew.CBT_Team__c='ASM: Advanced Sensors & Microsystems';
            drnew.CBT_Directorate__c='Advanced Sensing Technology';
            drnew.Type__c='Demo';
            drnew.GBE__c = 'Safety Systems';
            drnew.Estimated_Completion_Date__c = system.today();
            drnew.Opportunity__c=op.id;           
        insert drnew;
       
        Discretionary_Line_Item__c dlinew=new Discretionary_Line_Item__c();
            dlinew.Plant_Code__c=pc.Id;
            dlinew.Discretionary_Request__c=drnew.Id;
            dlinew.Funding_Amount__c=99.00;
            dlinew.Approval_Status__c = 'New';
        insert dlinew;
        
       
        
        DLI_Site_CC_List__c sitelistnew = new DLI_Site_CC_List__c();
            sitelistnew.Contact__c = cont.id;
            sitelistnew.Discretionary_Line_Item__c = dlinew.id;
        insert sitelistnew;
        
        dlinew.Discretionary_Account__c='Test'+drnew.Id;
        try{
        update dlinew;
        }catch(DMLException e){}
        
        dlinew.Site_Comments__c='Test Comments Close';
        dlinew.Approval_Status__c= 'Close';
        try{
        update dlinew;
        }catch(DMLException ee){}       
        Test.stopTest();
    
    }
}