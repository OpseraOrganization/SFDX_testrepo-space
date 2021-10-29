@isTest(SeeAllData=true)
private class Update_Discretionary_Plan_SpendTest {
    static testMethod void UpdateCarryOverDisPlanTest(){
        
        List<String> Fyear = new List<String>();
        Set<String> Yearset = new Set<String>();
        List<Id> OpptyId= new List<Id> ();
        List<Discretionary_Plan__c> DPrec = new List<Discretionary_Plan__c>();
        List<Id> lstId = new List<Id>();
        List<String> lstYear = new List<String>();
        
        /*
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        
        insert acc;
        */
        /* date testdate = date.parse('03/27/2011');
        Id oppId = [Select Id from Opportunity limit 1].id; */
        /*
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Focus'].Id;
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'D&S PrePriced' limit 1].Id;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S PrePriced';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.CloseDate = testdate;
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Active__c = FALSE;
        
        insert opp;
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        */
      /*   String prfId=[Select id from Profile where name=:'System Administrator'].id;
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
        usr1.IsActive = true ; 
        insert usr1;
        
        System.runas(usr1){
        Discretionary__c dr = new Discretionary__c();
        dr.Fiscal_Year__c = '2012';
        dr.Opportunity__c = oppId;
        dr.M_PM_Funded_VOC_Project__c = 'NO';
        dr.Estimated_Completion_Date__c = testdate;
        dr.SBU__c = 'D&S';
        dr.CBT__c = 'DAA';
        dr.CBT_Team__c = 'CBMS';
        dr.Type__c = 'Demo';
        dr.Approver_EmailId__c= usr1.email;
        dr.Current_Approver__c =usr1.Name;        
        insert dr;
        System.debug('123456'+dr.Current_Approver__c);
        System.debug('654321'+dr.Approver_EmailId__c );

        String strmail = [select id, email,Name,ContactId from User where Name=:dr.Current_Approver__c and Email =: dr.Approver_EmailId__c and ContactId = null and IsActive = true limit 1].Email;
        
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
        dli.Approval_Status__c = 'Open';
        dli.Discretionary_Request__c = dr.Id;
        dli.Plant_Code_Master__c = PlntcodeMstr.ID;
        dli.Plant_Code__c = pntcoderec.id;
        insert dli;
        
        Discretionary_Spend__c ds = new Discretionary_Spend__c();
        ds.Discretionary_Line_Item__c = dli.Id;
        ds.Week_Ending_Dt__c = testdate;
        ds.Weekly_Actuals__c = 300;
        
        insert ds;
        
        Discretionary_Spend__c dss1 = new Discretionary_Spend__c();
        dss1.Discretionary_Line_Item__c = dli.Id;
        dss1.Week_Ending_Dt__c = testdate;
        dss1.Weekly_Actuals__c = 200;
        
        insert dss1; */
        /**
        Discretionary_Plan__c dp3 = new Discretionary_Plan__c();
        dp3.Year__c = '2012';
        dp3.Opportunity__c = oppId;
        dp3.DLI_Spent__c = 200.50;
        dp3.DR_Funded__c = 1200;
        dp3.DR_Requested__c = 1400;
        
        insert dp3;
        
        Discretionary_Plan__c dp4 = new Discretionary_Plan__c();
        dp4.Year__c = '2013';
        dp4.Opportunity__c = oppId;
        dp4.DLI_Spent__c = 200.50;
        dp4.DR_Funded__c = 1200;
        dp4.DR_Requested__c = 1400;
        
        insert dp4;
        **/
       /* List<Discretionary_Spend__c> dspend = new List<Discretionary_Spend__c>();
        dspend.add(ds);
        dspend.add(dss1);
        for(Discretionary_Spend__c DS1 : dspend){ 
            OpptyId.add(DS1.OppId__c);
            Fyear.add(DS1.Year__c);
            lstId.addAll(OpptyId);
            lstYear.addAll(Fyear);
         }
         
         try{    
            DPrec = [Select ID, Year__c,opportunity__c from Discretionary_Plan__c where Year__c in : Fyear and opportunity__c in :OpptyId ];
         } 
           catch(Exception e){}
            if(DPrec.size()>0){
                try{
                    Update DPrec;
                }catch(Exception ex){}
            } else { 
                List<Discretionary_Plan__c> DPrec1 = new List<Discretionary_Plan__c>();
                for(Integer k=0;k<lstId.size();k++){
                    Discretionary_Plan__c dpc = new Discretionary_Plan__c();
                    dpc.opportunity__c = lstId[k];
                    dpc.Year__c = lstYear[k];
                    DPrec1.add(dpc);
                }
                if(DPrec1.size()>0){
                    try {
                    insert DPrec1;
                    }catch(Exception ex){}
                }
          }
          }//run as user */
    }
}