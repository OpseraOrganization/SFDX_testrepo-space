/* Commented the below line for SR INC000006702002 as the existing Contact Email alert change warning is to be removed*/
@isTest
public class ContactEmailFieldAlertcls_tstcls{ 
/*
    static testmethod void ContactEmailFieldAlertcls(){
      test.starttest();
        Contact c1=new Contact(lastname='TestGoGreen',email='test@g.com');
        insert c1;
        Portal_Honeywell_ID__c  sr=new  Portal_Honeywell_ID__c  (Name='NewTest',Contact__c = c1.id);  
        insert sr;     
        
        PageReference pageRef = Page.ContactAlertPage;
        pageRef.getParameters().put('id',c1.id);
        Test.setCurrentPage(pageRef); 
        
        Portal_Honeywell_ID__c phi= new Portal_Honeywell_ID__c();         
        ApexPages.StandardController con = new ApexPages.StandardController(phi);
        
        ContactEmailFieldAlertcls cfa= new ContactEmailFieldAlertcls(con); 
        ApexPages.StandardController con1 = new ApexPages.StandardController(c1);
        ContAlertcls ca = new ContAlertcls(con1);      
        ca.getcontact();
        ca.closePopup();
        ca.closePopup1();
        ca.showPopup();   
      test.stoptest();   
    }
    */
    static testmethod void CaseAlertcls(){
      test.starttest();
     
        Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
        try{
        insert c1; 
        }
        catch(Exception e){}    
        PageReference pageRef = Page.CaseAlertPage;
        pageRef.getParameters().put('id',c1.id);
        Test.setCurrentPage(pageRef);       
       
        ApexPages.StandardController con1 = new ApexPages.StandardController(c1);
        CaseAlertcls  ca = new CaseAlertcls (con1);      
        ca.getcase();
        //ca.closePopup();
        ca.showPopup();   
      test.stoptest();   
      
    }
    
    
    
    
}