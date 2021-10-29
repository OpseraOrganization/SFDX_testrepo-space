/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_Marcomcls
* Description           : Test Class to test the functionality of AssociatedVoc_Cls class.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 18-Dec-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_AssociatedVoc_Cls 
{  
    static testMethod void Test_AssociatedVoc_ClsMthd()
    {     
    Go_Green_Plan__c objGp = new Go_Green_Plan__c();
    Feedback__c objFB = new Feedback__c();
        Account acc= new Account(name='Test Account');
    insert acc;
 Contact c1=new Contact(lastname='TestGoGreen',email='test@g.com');
 insert c1;
 
 Feedback__c FB= new Feedback__c(Comments__c='test',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='APU');
      insert FB;
      
      Go_Green_Plan__c GP= new Go_Green_Plan__c(Go_Green_Status__c='TestP',account__c=acc.Id,Prod_LN_Prgm_Product_LIne__c='APU');
       insert GP;
       
       Associated_VOC_Card_Number__c AVC= new Associated_VOC_Card_Number__c(
       Go_Green_Plan__c=gp.Id,Feedback_Number__c=fb.Id);
       insert AVC;
       
       List<Go_Green_Plan__c> lstGP = [select name from Go_Green_Plan__c where id =: GP.ID];
       if(lstGP!=null && lstGP.size() > 0)
       {
           objGp = lstGP[0];
       }
       
       List<Feedback__c> lstFB = [select name from Feedback__c where id =: FB.ID];
       if(lstFB !=null && lstFB.size() > 0)
       {
           objFB = lstFB[0];
       }
      
       PageReference objPageRef  = Page.AssociatedVoccard;  
       objPageRef.getParameters().put('GGP',objGp.name);
       //System.debug('GP.name'+GP.name);
       Test.setCurrentPage(objPageRef);
        
        
        //AssociatedVoc_Cls objVOC = new AssociatedVoc_Cls(objVOCCard);     
        
        ApexPages.StandardController objController = new ApexPages.StandardController(AVC);
        AssociatedVoc_Cls objVOCCls  = new AssociatedVoc_Cls(objController);
        objVOCCls.ggpname = objGp.name;
        objVOCCls.ggpval = objGp.name;
        objVOCCls.fbname = objFB.name;
        
        objVOCCls.popupCallGgp();
        objVOCCls.popupCallFb();
        objVOCCls.setValue();
        objVOCCls.goBack();
        objVOCCls.doClose();
        objVOCCls.addInfo('Test');
        objVOCCls.doSave();
        objVOCCls.doSaveNew();
        objVOCCls.letsGo();
        objVOCCls.letsfbGo();
        objVOCCls.doCancel();
        
        
    }
}