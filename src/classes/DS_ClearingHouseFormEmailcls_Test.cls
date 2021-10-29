@isTest(seealldata=false)
public class DS_ClearingHouseFormEmailcls_Test{
    static testmethod void DS_ClearingHouseFormEmailcls_MethodTest(){     
        test.startTest();           
            //Platform__c site1 =[select id,Name from Platform__c limit 1];
            //Plant_Code_Master__c site =[select id,Name from Plant_Code_Master__c limit 1]; 
        
        Platform__c site1=new Platform__c();
        site1.name='testpf';
        insert site1;
        
        Plant_Code_Master__c site=new Plant_Code_Master__c();
        site.name='testpcm';
        insert site;
        
        
            Opportunity opp = new Opportunity();//[select id,name,Contract_Type__c,Opportunity_Number__c,Description,prime_sub__c,account.name,Certification_Requirements__c,Platform__c,Site__c,Opportunity_Type__c,Customer_Issue_Date__c,Request_Type__c,Solicitation_No__c,RFP_Expected_Date__c,Received_Date_at_Clearing_House__c ,comments__c,HW_SW__c,Bid_Type_Name__c,revenue_type__c,Estimated_Proposal_Value__c,tech_sales__c,Tech_Sales_Product_area__c  from Opportunity limit 1 ];
        opp.Name='testopp';
        opp.CloseDate=system.today();
        opp.Estimated_Proposal_Value__c='10';
            opp.Tech_Sales__c='Test';
            opp.Tech_Sales_Product_Area__c='Test';
            opp.Received_Date_at_Clearing_House__c =system.today();
            opp.Request_Type__c ='RFP / RFQ';
            opp.Contract_Type__c='BPA';
            opp.Certification_Requirements__c='Test';
            opp.Platform__c=site1.id;
            opp.Bid_Type_Name__c='Bridge';
            opp.Customer_Issue_Date__c=system.today();
            opp.Solicitation_No__c='Test';
            opp.RFP_Expected_Date__c =system.today();
            opp.Site__c =site.id;
            opp.Revenue_Type__c='ENG'; 
            /* opp.HW_SW__c ='Test';
            opp.Comments__c ='Test';  */ 
            insert opp;
            attachment att =new attachment();//[select id, parentid from attachment  limit 1];
            att.ParentId=opp.id;
        att.Name='testatt';
        att.Body=Blob.valueOf('test');
        insert att;
            List<attachment> attlist=new  List<attachment>();
            attlist.add(att);
            case c= new case() ;//[SELECT id,casenumber,subject,Case_Ref_ID__c,Description,SuppliedEmail,Opportunity__r.Opportunity_Number__c,
                       //Opportunity__r.Name,Opportunity__r.recordtype.name,Platform__c,Opportunity__r.account.name,Plant__c,Tech_Sales__c,Tech_Sales_Product_area__c,
                      // Received_Date__c,Request_Type_Opp__c,Type_of_pricing__c,Certification_Requirements__c,classification__c,proposal_content__c,estimated_proposal_value__c,Part_Number__c,comments__c  
               // FROM case limit 1]; 
            c.Opportunity__c=opp.id;
            c.Type_of_pricing__c='ROM';
            c.Certification_Requirements__c='Direct Commercial';
            c.Received_Date__c=system.today();
            c.Request_Type_Opp__c='UCA';
            c.Tech_Sales__c='Test';
            c.Tech_Sales_Product_area__c='Test';
            c.Platform__c=site1.id;
            c.classification__c='ACCOUNT';
            c.proposal_content__c='ENG';
            c.estimated_proposal_value__c='Test';
            c.Part_Number__c='11111';
            c.comments__c='Test';
            c.Status='Open';
            insert c;            
            ApexPages.currentPage().getParameters().put('casenumber ', c.casenumber);
            ApexPages.StandardController controller;
            DS_ClearingHouseFormEmailcls handler = new DS_ClearingHouseFormEmailcls(controller);
            handler.emailsending();        
            DS_ClearingHouseFormEmailcls.getplatformdetails(site1.id);
            DS_ClearingHouseFormEmailcls.getsitedetails(site.id);
        test.stopTest();
    }   
}