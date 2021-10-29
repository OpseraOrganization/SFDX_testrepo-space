@isTest(SeeAllData=true)
private class test_FunctionalContributorrecipientcls{
    static testMethod void FunctionalContributorrecipientcls()
    {
         
        user u=[SELECT Email,ProfileId FROM User WHERE name = 'SFDC Admin' limit 1];
        contact con=[SELECT Id FROM Contact limit 1];
        Opportunity Opp = [select id from Opportunity where SBU__c = 'D&S' and RecordType.name like '%D&S PrePriced' limit 1];
        system.runAs(u)
        {
               
        Plant_Code_Master__c pc=new Plant_Code_Master__c();
        pc.Name='test';
        pc.Plant_Name__c='test plant code';
        pc.Public_Plant_Name__c='test plant';
        pc.City__c='test';
        pc.Country_Code__c='IN';
        pc.SAP_Plant_Code__c='KA';
        insert pc;
        
        Opportunity_Proposal__c opppro=new Opportunity_Proposal__c();
        opppro.Opportunity__c = opp.id;
        opppro.Request_Type__c='UCA';
        opppro.Description__c='test desc';
        opppro.Pricing_Analyst__c=u.id;
        opppro.Pricing_Manager__c=u.id;
        opppro.P_DR__c='test';
        opppro.Site__c=pc.id;
        opppro.Negotiation_Complete_Date__c=system.today()+3;
        opppro.Proposal_Years__c='Single';
        opppro.Proposal_Status__c='Cost Update';
        insert opppro;
        
        Functional_Contributor_Update__c fc=new Functional_Contributor_Update__c();
        fc.Opportunity_Proposal__c=opppro.id;
        fc.Non_SFDC_Recipient__c='venkatesh.athanti@nttdata.com';
        fc.Comments__c='test';
        fc.Email_Update_Status__c='In progress';
        fc.Request_Date__c=system.today()+3;
        insert fc;
        
        Functional_Contributor_Update__c fc1=new Functional_Contributor_Update__c();
        fc1.Opportunity_Proposal__c=opppro.id;
        fc1.Non_SFDC_Recipient__c='venkatesh.athanti@nttdata.com';
        fc1.Comments__c='test';
        fc1.Email_Update_Status__c='In progress';
        fc1.Reminder_Email_Date__c = null;
        fc1.X3_Days_Reminder__c=false;
        fc1.Request_Date__c=system.today()-3;
        insert fc1;
        
        Functional_Contributor_Update__c fc2=new Functional_Contributor_Update__c();
        fc2.Opportunity_Proposal__c=opppro.id;
        fc2.Non_SFDC_Recipient__c='venkatesh.athanti@nttdata.com';
        fc2.Comments__c='test';
        fc2.Email_Update_Status__c='In progress';
        fc2.Reminder_Email_Date__c = system.today()+1;
        fc2.X3_Days_Reminder__c=true;
        fc2.Request_Date__c=system.today()-5;
        insert fc2; 
           
        test.startTest();
        
        Functional_Contributor_Update__c fc3=new Functional_Contributor_Update__c();
        fc3.Opportunity_Proposal__c=opppro.id;
        //fc3.Non_SFDC_Recipient__c='venkatesh.athanti@nttdata.com';
        fc3.SFDC_Recipients__c=con.id;
        fc3.Comments__c='test';
        /*fc3.Email_Update_Status__c='In progress';*/
        fc3.Type_of_Recipients__c='Engineering';
        insert fc3;
                
        ApexPages.StandardController sc = new ApexPages.standardController(fc);
                
        Functional_Contributor_comment_Update fcn=new Functional_Contributor_comment_Update(sc);
        fcn.save1();
        
        functionalcontributorlnotification fcn1=new functionalcontributorlnotification(sc);
        fcn1.thankyou();
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(fc3);
         
        functionalcontributorlnotification fcn3=new functionalcontributorlnotification(sc1);
        fcn3.thankyou();
        
        Functional_Contributor_comment_Update fcn4=new Functional_Contributor_comment_Update(sc1);
        fcn4.save1();
        
                         
        test.setCurrentPageReference(new PageReference('Page.FunctionalContributorrecipients')); 
        System.currentPageReference().getParameters().put('id', opppro.id);
        
        FunctionalContributorrecipientcls fcc=new FunctionalContributorrecipientcls(); 
                                        
        fcc.AddRow();
        fcc.AddRow1();
        fcc.saveMemb();              
        fcc.cancelpage();
      
        apexpages.currentpage().getparameters().put('index','1');
        fcc.delRow();
        fcc.delRow1();        
               
        test.stopTest(); 
        
        }       
    }
}