@isTest
public class FERPopUp_Test {
static testmethod void FERPopupTest(){
    Contact c1=new Contact(lastname='TestFER',email='test@123g.com');
        insert c1;
    Case c=new Case(subject='test',ContactId=c1.id,Status='Open',Origin='In Person',HON_Commit_Date__c=system.today(),Classification__c='EMS',Export_Compliance_Content_ITAR_EAR__c='No',Government_Compliance_SM_M_Content__c='No',FER__c=true);
    insert c;
    
    PageReference pageRef = Page.FERPage;
        pageRef.getParameters().put('id',c.id);
        Test.setCurrentPage(pageRef); 
    
    Case cas= new Case();         
        ApexPages.StandardController con = new ApexPages.StandardController(cas);
    
    FERPopUp pop = new FERPopUp(con);
    pop.getc();
    pop.showPopup();
    pop.redirect();
}
}