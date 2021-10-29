@isTest
public class KaizenApproval_test {

    public static testMethod void KaizenApprovaltest(){
        
        Kaizen_Users__c ku = new Kaizen_Users__c(Department__c='HOS',Email__c='abc@abc.com',Employee_ID__c='123',User_Role__c='Submitter');
        insert ku;
        Kaizen_Users__c ku1 = new Kaizen_Users__c(Department__c='HOS',Email__c='abc1@abc.com',Employee_ID__c='124',User_Role__c='Leader');
        insert ku1;
        Kaizen_Users__c ku2= new Kaizen_Users__c(Department__c='HOS',Email__c='abc2@abc.com',Employee_ID__c='125',User_Role__c='Supervisor');
        insert ku2;
        Aero_China_Kaizen__c k = new Aero_China_Kaizen__c(Action_Owner__c=ku.id,requester__c=ku1.id,Action_Plan__c='test',After__c='sdv',dept__c='MO');
        insert k;
    	PageReference pageref = page.KaizenApproval;
        Test.setCurrentPage(Pageref);
        ApexPages.currentPage().getParameters().put('id', k.id);
        ApexPages.currentPage().getParameters().put('Action', 'Submit');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(k);
        KaizanApproval ka=new KaizanApproval(controller);
        ka.PageLoad();
        
        k.Dept__c = 'HOS';
        update k;
      	controller = new ApexPages.StandardController(k);
        ka=new KaizanApproval(controller);
        ka.PageLoad();
        
        ApexPages.currentPage().getParameters().put('Action', 'Approve');
        
        controller = new ApexPages.StandardController(k);
        ka=new KaizanApproval(controller);
        ka.PageLoad();
        
        ApexPages.currentPage().getParameters().put('Action', 'Reject');
        ApexPages.currentPage().getParameters().put('Host', 'Reject');
        
        controller = new ApexPages.StandardController(k);
        ka=new KaizanApproval(controller);
        ka.PageLoad();
    }
    
}