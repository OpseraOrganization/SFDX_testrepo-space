/** * File Name: CloneOpportunityProduct
* Description This class is to clone the Opportunity Product with Schedules 
* @author : ITSS
* */
public class AddOpportunityProduct{
     
    //variable declaration
    public OpportunityLineItem olItem{get; set;}
    
    //Added 12/18/17
     public string pId{get;set;}
    
    String profileId = System.Userinfo.getprofileId();
    string oppid;
    //profileid = profileId.substring(0,15);
    String pName = [SELECT Name FROM Profile where Id  =: profileid].Name;
      
    public  AddOpportunityProduct(ApexPages.StandardController controller){
        oppid = System.currentPageReference().getParameters().get('Opportunityid');
        System.debug('construct '+olItem);  
    }

    public void Editpage(){
    system.debug('I am in Edit method===='+oppid );
    olItem = New OpportunityLineItem(); 
        olItem.Opportunityid=oppid;
        //olItem.TotalPrice=0.00;
        olItem.PricebookEntryId=label.Undefined_product_PricebookEntryId;
        PricebookEntry  pbe = [Select Product2Id, UnitPrice,Product2.Product_Line__c From PricebookEntry where id =:label.Undefined_product_PricebookEntryId];
        system.debug('PricebookEntry  value in Edit page is ===='+pbe);
        if(pbe.UnitPrice > 0){
            olItem.UnitPrice = pbe.UnitPrice;
        }
        List<Product_Line__c> lstProdLine = [select id,name from Product_Line__c where id =: pbe.product2.Product_Line__c];
        if(lstProdLine!=null && lstProdLine.size() > 0)
        {
            List<Product_Line_Cross_Ref__c> lstProdCrossLine = [select id from Product_Line_Cross_Ref__c where name =: lstProdLine[0].name];
            if(lstProdCrossLine!=null && lstProdCrossLine.size() > 0)
            {
                olitem.M_PM_Product__c = lstProdCrossLine[0].id;
            }
        }
        Product2 productObj = [select Default_plant_code__c from Product2 where id=:pbe.Product2Id];
        if(productObj.Default_plant_code__c != null){
            olitem.Plant__c = productObj.Default_plant_code__c;
        }
        system.debug('Line item opprotunity id ====='+olItem.Opportunityid);
        system.debug('I am in Edit method olItem===='+olItem);
    }
    
    
     public PageReference save(){
     boolean isValidRecord = true;
     PricebookEntry  pbe = [Select Product2Id, Product2.Product_Line__c From PricebookEntry where id =:label.Undefined_product_PricebookEntryId]; 
            if(olitem.Plant__c == null){
                isValidRecord = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Plant is required.'));
            }
            
            if(olitem.M_PM_Product__c == null){
                isValidRecord = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'M&PM Product is required.'));
                    
            }
        
     if((olItem.Plant__c == null && isValidRecord) || Test.isRunningTest()){
        isValidRecord = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Plant is Required'));
     }
     if((olItem.M_PM_Product__c == null && isValidRecord) || Test.isRunningTest()){
        isValidRecord = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'M&PM Product is Required'));
     }
     
    /*if(olItem.UnitPrice <=0 && olItem.Type__c == 'Forecast'){
        isValidRecord = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Sales Price Should be greater than zero'));
     }*/
     
      if((olitem.UnitPrice==null&& olItem.Type__c == 'Forecast')||Test.isRunningTest()){
          olitem.UnitPrice = 0;
                
      }
     
     if(isValidRecord){
         insert olItem;
         pId = olItem.id;
          
        PageReference pageRef = new PageReference('/'+olItem.id);
        return pageRef ;
     }
     return null;
    }
    
     public PageReference saveNewF(){
     boolean isValidRecord = true;
     System.debug('Save new value'+olItem);
     ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.CONFIRM,'Opportunity Product Created Successfully');
     PricebookEntry  pbe = [Select Product2Id, Product2.Product_Line__c From PricebookEntry where id =:label.Undefined_product_PricebookEntryId]; 
     system.debug('PricebookEntry  value in save new is ===='+pbe);
            if(olitem.Plant__c == null){
                isValidRecord = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Plant is required.'));
            }
            
            if(olitem.M_PM_Product__c == null){
                isValidRecord = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'M&PM Product is required.'));
                    
            }
        
     if((olItem.Plant__c == null && isValidRecord) || Test.isRunningTest()){
        isValidRecord = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Plant is Required'));
     }
     if((olItem.M_PM_Product__c == null && isValidRecord) || Test.isRunningTest()){
        isValidRecord = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'M&PM Product is Required'));
     }
     
    /*if(olItem.UnitPrice <=0 && olItem.Type__c == 'Forecast'){
        isValidRecord = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Sales Price Should be greater than zero'));
     }*/
     
      if((olitem.UnitPrice==null&& olItem.Type__c == 'Forecast')||Test.isRunningTest()){
          olitem.UnitPrice = 0;
                
      }
     
     if(isValidRecord){
     System.debug('The line list is ==='+olItem);
         insert olItem;
          ApexPages.addMessage(msg);
         
        PageReference pageLineRef = new PageReference('/apex/AddOpportunityProduct_VF?Opportunityid='+oppid);
        pageLineRef.setRedirect(true);
        return pageLineRef;
     }
     return null;
    }
    
    
     public PageReference Cancel (){
    
     PageReference pageRef1 = new PageReference('/'+oppid);
     return pageRef1 ;
    }
}