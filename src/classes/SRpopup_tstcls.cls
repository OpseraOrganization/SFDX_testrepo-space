@isTest
public class SRpopup_tstcls{ 
    static testmethod void SRpopuptest(){
        Contact c1=new Contact(lastname='TestGoGreen',email='test@g.com');
        insert c1;
        Service_Request__c SR=new  Service_Request__c (Status__c='New',Contact_Name__c = c1.id);  
        insert SR;     
        
        PageReference pageRef = Page.SrAlertaPage;
        pageRef.getParameters().put('id',sr.id);
        Test.setCurrentPage(pageRef); 
        
        Service_Request__c srp= new Service_Request__c();         
        ApexPages.StandardController con = new ApexPages.StandardController(srp);
        
        SRpopup pop= new SRpopup(con);       
        pop.getSrm();
        pop.getSR();
        pop.closePopup();
        pop.showPopup();    
    }
}