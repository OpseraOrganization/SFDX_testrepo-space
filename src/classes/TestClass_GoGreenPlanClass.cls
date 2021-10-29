@isTest
private class TestClass_GoGreenPlanClass{
    
    static testMethod void GoGreenPlanClasstest(){
    
        Account acc= new Account(name='Test Account');
        insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
        insert cont;
        
        
        RecordType[] rec1 = [Select Id,Name from RecordType where name='VOC' limit 1];
        Feedback__c voc= new Feedback__c(
            RecordTypeId=rec1[0].Id,
            contact__C=cont.Id, 
            Delivery_Weight__c=100, 
            Delivery_Customer_Rating__c = 'Red - Very Dissatisfied',
            Development_Customer_Rating__c = 'Red - Very Dissatisfied',
            Quality_Customer_Rating__c = 'Red - Very Dissatisfied',
            Reliability_Customer_Rating__c = 'Red - Very Dissatisfied',
            Responsiveness_Customer_Rating__c = 'Red - Very Dissatisfied',
            Service_Support_Customer_Rating__c = 'Red - Very Dissatisfied',
            Delivery_Customer_Expectations__c = 'test',
            Delivery_Summary__c = 'test',
            Development_Customer_Expectations__c = 'test',
            Development_Summary__c = 'test',
            Quality_Customer_Expectations__c = 'test',
            Quality_Summary__c = 'test',
            Reliability_Customer_Expectations__c = 'test',
            Reliability_Summary__c = 'test',
            Responsiveness_Customer_Expectations__c = 'test',
            Responsiveness_Summary__c = 'test',
            Service_Support_Customer_Expectations__c = 'test',
            Service_Support_Summary__c = 'test'
        );
        
       
        insert voc;
        
      

        //insert voc;
        system.debug('KKKKKK'+voc);
        
        PageReference pageRef  = Page.GoGreenPlan;
        pageRef.getParameters().put('feedid', voc.id);
        Test.setCurrentPage(pageRef);
        

        ApexPages.StandardController std = new ApexPages.StandardController(voc);  

        GoGreenPlanClass testcontroller = new GoGreenPlanClass(std);
  
        
        testcontroller.Cancel();
        testcontroller.Save();
        Go_Green_Plan__c gp = testcontroller.getgogreen();
        testcontroller.setgogreen(gp);
        
         PageReference pageRef1  = Page.BlockGoGreen;
         
        Test.setCurrentPage(pageRef1);
        Go_Green_Plan__c tst = new Go_Green_Plan__c();
         ApexPages.StandardController std1 = new ApexPages.StandardController(tst);  
         BlockGoGreen_CLS testcontroller1 = new BlockGoGreen_CLS(std1);
  
        
        testcontroller1.go();
    }
}