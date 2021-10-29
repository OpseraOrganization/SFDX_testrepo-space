/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_DeliverableItem_cls
* Description           : Test Class to test the functionality of DeliverableItem_cls class.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 18-Dec-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_DeliverableItem_cls 
{  
    static testMethod void Test_DeliverableItem_clsMthd()
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
       
       PageReference objPageRef  = Page.AssociatedVoccard;  
       objPageRef.getParameters().put('GGP',objGp.name);
       //System.debug('GP.name'+GP.name);
       Test.setCurrentPage(objPageRef);
        
        ApexPages.StandardController objController = new ApexPages.StandardController(DI);
        
        DeliverableItem_cls objDeliverableItem_cls = new DeliverableItem_cls(objController);       
        //String strDate = objDeliverableItem_cls.currentDate;
        objDeliverableItem_cls.ggpname = objGp.name;
        objDeliverableItem_cls.getItems();
        objDeliverableItem_cls.popupCallGgp();
        objDeliverableItem_cls.popupCallsr();
        objDeliverableItem_cls.setValue();
        objDeliverableItem_cls.doClose();
        objDeliverableItem_cls.addInfo('test');
        objDeliverableItem_cls.doSaveNew();
        objDeliverableItem_cls.letsGo();
        objDeliverableItem_cls.gosr();
        /*objDeliverableItem_cls.doCancel();
        objDeliverableItem_cls.setSrValue();*/
        objDeliverableItem_cls.getFunItems();
        objDeliverableItem_cls.gethsItems();
        objDeliverableItem_cls.getstatusItems();
        objDeliverableItem_cls.getprocessItems();
       /* objDeliverableItem_cls.
        objDeliverableItem_cls.
        objDeliverableItem_cls.
        objDeliverableItem_cls.*/
        
         
        DeliverableItem_cls objDeliverableItem_cls1 = new DeliverableItem_cls(objController);       
        //strDate = objDeliverableItem_cls.currentDate;
        objDeliverableItem_cls1.ggpname = objGp.name;
        objDeliverableItem_cls1.srname = objSR.name;
        
        objDeliverableItem_cls1.actowner = 'Test Act Owner';
        objDeliverableItem_cls1.funpickvalue = 'CBM';
        objDeliverableItem_cls1.processpickvalue = 'Blue';
        objDeliverableItem_cls1.hsvalue = 'Australia';
        objDeliverableItem_cls1.doSaveNew();
        //objDeliverableItem_cls1.doSave();
        
        
    }
}