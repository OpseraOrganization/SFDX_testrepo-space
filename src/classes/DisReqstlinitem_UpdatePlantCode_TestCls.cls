@isTest(SeeAllData=true)
Public class DisReqstlinitem_UpdatePlantCode_TestCls{
    
    static testMethod void DisReqstlinitem_UpdatePlantCode_TstMthd(){
      user tstuser = [select id from user where name = 'sfdc admin'];
        test.starttest(); 
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
    Discretionary__c DiscNew=new Discretionary__c ();
    DiscNew.CBT__c='Airlines';
    DiscNew.SBU__c='ATR';
    DiscNew.Estimated_Completion_Date__c = System.today()+10;
    DiscNew.Campaign__c=cam.id;
    insert DiscNew;
    
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
  
    Discretionary_Line_Item__c DiscLineItem=new Discretionary_Line_Item__c();
    DiscLineItem.Discretionary_Request__c= DiscNew.Id;
    DiscLineItem.Plant_Code_Master__c=PlntcodeMstr.id;
    insert DiscLineItem;
     test.stoptest(); 
    }
    
    }