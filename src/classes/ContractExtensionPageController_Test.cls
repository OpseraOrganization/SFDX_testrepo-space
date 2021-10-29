@isTest(SeeAllData=true)
private class ContractExtensionPageController_Test {
    static testMethod void Testmethod1() {
       test.starttest();        
        contract obj = [select id,Contract_Extension_Number_History__c,ContractExtAdditional_Approvers__c,Desired_extension_duration__c,ContractExt_DurationHistory__c from contract order by createddate desc limit 1];
        obj.Contract_Extension_Number_History__c=1;
        obj.Desired_extension_duration__c='10';
        obj.ContractExt_DurationHistory__c=2;
        //obj.ContractExtAdditional_Approvers__c='Venkatesh,cindy';
        update obj;
        PageReference pageRef = Page.ContractExtensionProcessPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        ContractExtensionPageController conextcls = new ContractExtensionPageController(sc);
        conextcls.doedit();
        conextcls.dosave();
        conextcls.doUpdateDate();
        conextcls.doCancel();
        conextcls.addApprover();
        conextcls.removeApprover();
        conextcls.submitForApproval();
        test.stoptest();
    }
    static testMethod void Testmethod2() {
       test.starttest();        
        contract obj = [select id,Contract_Extension_Number_History__c,ContractExtAdditional_Approvers__c,Desired_extension_duration__c,ContractExt_DurationHistory__c from contract order by createddate desc limit 1];
        obj.Contract_Extension_Number_History__c=2;
        obj.Desired_extension_duration__c='10';
        obj.ContractExt_DurationHistory__c=2;
        id userid=userinfo.getuserid();
        obj.ContractExtAdditional_Approvers__c=userid;
        obj.Renewal_Start_date__c = system.today();
        update obj;
        PageReference pageRef = Page.ContractExtensionProcessPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        ContractExtensionPageController conextcls = new ContractExtensionPageController(sc);
        conextcls.doedit();
        conextcls.dosave();
        conextcls.doUpdateDate();
        conextcls.doCancel();
        conextcls.addApprover();
        conextcls.removeApprover();
        conextcls.submitForApproval();
        test.stoptest();
    }
    static testMethod void Testmethod3() {
       test.starttest();        
        set<id> accid=new set<id>();
        set<id> conid=new set<id>();
        List<Account> listAcc = [Select id,Name ,Business_Focal__c,Business_Focal__r.Primary_Email_Address__c From Account where Business_Focal__c !=Null limit 2];
        for(account accid1:listacc)
        {
            accid.add(accid1.id);
        }
        List<contract> listCont=[Select id,AccountId From contract where RecordType.Name='Contracts' limit 2];
        for(contract con:listcont)
        {
            conid.add(con.id);
        }
        ContractExtensionProcessHandler.updateBusinessFocalEmail(accid);
        ContractExtensionProcessHandler.updatemail(listCont,accid);
        test.stoptest();
    }
    static testMethod void Testmethod4() {
        test.starttest();        
        System.enqueueJob(new ContractExtension_InitialLoad());
        test.stoptest();
    }
    static testMethod void Testmethod5() {
       test.starttest();        
        contract obj = [select id,MSP_Engine_ModelPL__c,ContractExtAdditional_Approvers__c,Desired_extension_duration__c,ContractExt_DurationHistory__c from contract order by createddate desc limit 1];
        obj.MSP_Engine_ModelPL__c='Test';
        update obj;
        test.stoptest();
    }
    static testMethod void Testmethod6() {
       test.starttest();        
        List<Price_Book__c> pblist = new List<Price_Book__c>();
        pblist = [SELECT Aircraft__c,APU_Gold_NLS_Price__c,APU_Gold_Price__c,APU_Model__c,APU_Price__c,APU_Transfer_Fee_Price__c,Between_Price__c,
                  Engine__c,Id,Location_ID__c,Location__c,MSP_Gold__c,NRL_Gold__c,OEM__c,OverHrs__c,OverPrice__c,Product_Type__c,Transfer_Fee__c,
                  UnderHrs__c,Under_Price__c,Years__c,Renewal_Start_Date__c FROM Price_Book__c where Renewal_Start_date__c != null limit 1];
        List<contract> listCont=[Select id,AccountId From contract where Renewal_Start_date__c != null and MSP_Engine_ModelPL__c = null limit 1];
        if(listCont.size()>0)
        {
            listCont[0].Renewal_Start_date__c = pblist[0].Renewal_Start_date__c;
            update listCont;
        }
        test.stoptest();
    }    
 }