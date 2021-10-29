/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_DeliverableRecSelection_cls
* Description           : Test Class to test the functionality of DeliverableRecSelection_cls class.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 18-Dec-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_DeliverableRecSelection_cls
{  
    static testMethod void Test_DeliverableRecSelection_clsMthd()
    {     
        Go_Green_Plan__c objGp = new Go_Green_Plan__c();
        Service_Request__c objSR = new Service_Request__c();
        
        Account acc= new Account(name='Test Account');
        insert acc;
        
        Contact c1=new Contact(lastname='TestGoGreen',email='test@g.com');
        insert c1;
        
        Service_Request__c SR=new  Service_Request__c (Status__c='New',Contact_Name__c = c1.id);  
        insert SR;
        
        Go_Green_Plan__c GP= new Go_Green_Plan__c(Go_Green_Status__c='TestP',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='APU');
        insert GP;
        
        Deliverable_Item__c DI= new Deliverable_Item__c(SR_Number__c=SR.Id,Go_Green_Plan__c=gp.Id);
        insert DI;
        
        List<Go_Green_Plan__c> lstGP = [select name from Go_Green_Plan__c where id =: GP.ID];
       if(lstGP!=null && lstGP.size() > 0)
       {
           objGp = lstGP[0];
       }
       
       List<Service_Request__c> lstSR = [select name from Service_Request__c where id =: SR.ID];
       if(lstSR !=null && lstSR.size() > 0)
       {
           objSR = lstSR[0];
       }
       
       PageReference objPageRef  = Page.DeliverableRecordType;  
       objPageRef.getParameters().put('GGP',objGp.name);
       Test.setCurrentPage(objPageRef);
        
        ApexPages.StandardController objController = new ApexPages.StandardController(DI);
        
        DeliverableRecSelection_cls objDeliverableRecSelection_cls = new DeliverableRecSelection_cls(objController);
        objDeliverableRecSelection_cls.selectval = 'SR Required';     
        objDeliverableRecSelection_cls.getRecType();
        objDeliverableRecSelection_cls.ggpname = objGp.name;
        objDeliverableRecSelection_cls.doContinue();
        objDeliverableRecSelection_cls.docancel();
        objDeliverableRecSelection_cls.getvalues();
        
        objDeliverableRecSelection_cls = new DeliverableRecSelection_cls(objController);
        objDeliverableRecSelection_cls.selectval = 'SR Not Required';     
        objDeliverableRecSelection_cls.doContinue();
        
        
    }
}