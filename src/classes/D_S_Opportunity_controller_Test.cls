@isTest(seealldata=true) 
public class D_S_Opportunity_controller_Test{
static testmethod void D_S_Opportunity_controller_MethodTest1(){     
        test.startTest();           
            Platform__c site1 =[select id,Name from Platform__c limit 1];
            Plant_Code_Master__c site =[select id,Name from Plant_Code_Master__c limit 1];
            Opportunity opp = [select id,name,Contract_Type__c,Opportunity_Number__c,Description,prime_sub__c,account.name,Certification_Requirements__c,Platform__c,Site__c,Opportunity_Type__c,Customer_Issue_Date__c,Request_Type__c,Solicitation_No__c,RFP_Expected_Date__c,Received_Date_at_Clearing_House__c ,comments__c,HW_SW__c,Bid_Type_Name__c,revenue_type__c,Estimated_Proposal_Value__c,tech_sales__c,Tech_Sales_Product_area__c from Opportunity limit 1 ];
            opp.Estimated_Proposal_Value__c='10';
            opp.Tech_Sales__c='Test';
            opp.Tech_Sales_Product_Area__c='Test';
            opp.Received_Date_at_Clearing_House__c =system.today();
           // opp.Request_Type__c ='RFP / RFQ';
            opp.Contract_Type__c='BPA';
            opp.Certification_Requirements__c='Test';
            opp.Platform__c=site1.id;
            opp.Bid_Type_Name__c='Bridge';
            opp.Customer_Issue_Date__c=system.today();
            opp.Solicitation_No__c='Test';
            opp.RFP_Expected_Date__c =system.today();
            opp.Site__c =site.id;
            opp.Revenue_Type__c='ENG'; 
            OPP.RFP_Expected_Date__c = DATE.Today().adddays(2);
            opp.request_type__c='Unsolicited';
            opp.Customer_Issue_Date__c = DATE.Today().adddays(2);
            /* opp.HW_SW__c ='Test';
            opp.Comments__c ='Test';  */ 
            update opp;
            attachment att =[select id, parentid,body,name from attachment  limit 1];
            attachment att2 =[select id, parentid from attachment  limit 1];
            account acc =[select id,Name from account limit 1];
            acc.Opportunity_backend__c =opp.id;
            acc.E_mail_address__c ='venkatesh.athanti@honeywell.com';
            acc.Opportunity_backend__c =opp.id;
            update acc;
            String email = 'venkatesh.athanti@honeywell.com';
            //Contact conList =[Select id,Name,lastname,AccountId,Account.Name From Contact Where Primary_Email_Address__c =: email limit 1];
            
            ApexPages.currentPage().getParameters().put('id', opp.id);
            ApexPages.currentPage().getParameters().put('OPPID', opp.id);
            ApexPages.currentPage().getParameters().put('email',email);
            ApexPages.StandardController controller;
            D_S_Opportunity_controller DS1 = new D_S_Opportunity_controller(controller);
             DS1.OppName='test';
             DS1.flag=true;
             DS1.numb='123';
             DS1.FileCount='test';
             DS1.OppBtn11='test';
             DS1.descriptions='test';
             DS1.pricing='test';
             DS1.filename='test1';
             DS1.body='test body';
             DS1.fileContentType='test';
             DS1.platformName='test';
             DS1.tempSiteName='test';
             DS1.doCreateCase();
             DS1.searchsubmit();
             DS1.updateRecordType();
             DS1.tempAccountID=acc.id;
             DS1.platformid=site1.id;
             DS1.platform=site1;
             DS1.site=site;
             DS1.oppattchment=blob.valueof('test');
             DS1.oppNId =opp.id;
             DS1.tempPlatformID=site1.id;
             DS1.tempSiteID=site.id;
             DS1.att2=att2;
             DS1.getregions();
             DS1.getRecordTypes();
             DS1.loadOppType();
             DS1.loadOpp();
             DS1.createCase(opp);
             D_S_Opportunity_controller.tempOppID=opp.id;
             D_S_Opportunity_controller.getsitedetails(site.id); 
             D_S_Opportunity_controller.getplatformdetails(site1.id);
             D_S_Opportunity_controller handler = new D_S_Opportunity_controller();
           
        test.stopTest();
    }  
    
    static testmethod void D_S_Opportunity_controller_MethodTest2()
    {
       String email = 'venkatesh.athanti@honeywell.com';
            //Contact conList =[Select id,Name,lastname,AccountId,Account.Name From Contact Where Primary_Email_Address__c =: email limit 1];
             
        Opportunity opp = [select id,name,Contract_Type__c,Opportunity_Number__c,Description,prime_sub__c,account.name,Certification_Requirements__c,Platform__c,Site__c,Opportunity_Type__c,Customer_Issue_Date__c,Request_Type__c,Solicitation_No__c,RFP_Expected_Date__c,Received_Date_at_Clearing_House__c ,comments__c,HW_SW__c,Bid_Type_Name__c,revenue_type__c,Estimated_Proposal_Value__c,tech_sales__c,Tech_Sales_Product_area__c from Opportunity limit 1 ];
        
        opp.Customer_Issue_Date__c = date.today().adddays(-2);
        system.debug('----->'+opp.Customer_Issue_Date__c);
        update opp;
         test.startTest();    
        ApexPages.currentPage().getParameters().put('OPPID', opp.id);
        ApexPages.currentPage().getParameters().put('email', email);
         ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        D_S_Opportunity_controller DS2 = new D_S_Opportunity_controller(controller);
         //ds2.doCreateCase1();
          test.stopTest();
    }
   
    
}