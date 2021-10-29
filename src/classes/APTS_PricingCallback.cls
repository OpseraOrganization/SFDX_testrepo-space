global with sharing class APTS_PricingCallback implements Apttus_Config2.CustomClass.IPricingCallback2 {
    
    private Apttus_Config2.CustomClass.PricingMode mode = null;
    private Apttus_Config2.ProductConfiguration cart = null;
    private Set<ID> lineItemIDs;
    private List<Apttus_Config2__LineItem__c> lineItemsToUpdate;
        
    //Constructor
    global APTS_PricingCallback(){
        this.lineItemIDs = new Set<ID>(); //Set Of Line Item Ids being processed
        this.lineItemsToUpdate = new List<Apttus_Config2__LineItem__c>(); // list of LineItems to be updated
       
    }
    /**
    * Callback at the beginning of the pricing call.
    * Use the start method to initialize state
    * @param cart the cart object
    */
    global void start(Apttus_Config2.ProductConfiguration cart) {
      this.cart = cart;
      
    }
    /**
    * Callback to indicate the pricing mode
    * @param mode the pricing mode
    */
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        this.mode = mode;
        //enum type field -> get current mode of callback -> this could be ADJUSTMENT, BASEPRICE(when
        //goto price) or ROLLOUT (if(Apttus_Config2.CustomClass.PricingMode.BASEPRICE == mode))
    }
    
    /**
    * Callback before pricing the line item collection
    * Use this method to do all required pre-processing to prepare the line items for pricing.
    * @param itemColl the line item collection to pre-process
    */
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
    }
    
    /**
    * Callback before pricing the given line item in the line item collection
    * Use this method to do all required pre-processing to prepare the line item for pricing.
    * @param itemColl the line item collectionholding the line item
    * @param lineItemMO the line item to pre-process
    */
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
    }
    
    /**
    * Callback after pricing the given line item in the line item collection
    * Use this method to do all required post-processing after the line item is priced
    * @param itemColl the line item collection holding the line item
    * @param lineItemMO the line item to post-process
    */
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
    }
    
    /**
    * Callback after pricing the line item collection
    * Use this method to do all required post-processing after line items are priced.
    * @param itemColl the line item collection to post-process
    */
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        //get all lineitems
        List<Apttus_Config2.LineItem> allLines = itemColl.getAllLineItems();
        Map<id,Apttus_Config2__LineItem__c> MapLines = New Map<id,Apttus_Config2__LineItem__c>();
       
        
        For(Apttus_Config2.LineItem lineItemMO : allLines)
        {
          Apttus_Config2__LineItem__c lineItemSO = lineItemMO.getLineItemSO();
          MapLines.Put(lineItemSO.id,lineItemSO);
         
        }
          
        List<Apttus_Config2__ProductAttributeValue__c> Attributelst = [Select id,Apttus_Config2__LineItemId__c,ATR_Price_Type__c,APTS_Additional_Aircraft_Types__c from Apttus_Config2__ProductAttributeValue__c where Apttus_Config2__LineItemId__c IN : MapLines.keyset()];
         Integer ATA = Integer.valueOf(Label.ConnectedMx_ATA);
         Integer NTT = Integer.valueOf(Label.ConnectedMx_NTT);
         Integer NTTGDFE = Integer.valueOf(Label.ConnectedMx_NTT_GDFE);
         
        for(Apttus_Config2__LineItem__c  ACL : MapLines.Values()) 
         {
           for(Apttus_Config2__ProductAttributeValue__c ACP :Attributelst )
           {
                System.debug(ACP.ATR_Price_Type__c);   
                System.debug(ACL.Apttus_Config2__BasePrice__c); 
              
               
                   if(ACP.ATR_Price_Type__c=='Paid' && ACP.Apttus_Config2__LineItemId__c == ACL.id && ACL.APTS_CallbackApply__c != null)
                   {
                       if(ACL.APTS_CallbackApply__c == 'ATA'){
                           ACL.Apttus_Config2__NetPrice__c = ACL.Apttus_Config2__NetPrice__c + (ACL.Apttus_Config2__SellingTerm__c * ATA ) + (ACL.Apttus_Config2__SellingTerm__c * ATA * ACP.APTS_Additional_Aircraft_Types__c);
                           //ACL.Apttus_Config2__BasePrice__c = ACL.Apttus_Config2__BasePrice__c + ATA  + ( ATA * ACP.APTS_Additional_Aircraft_Types__c);
                       }
                       else if(ACL.APTS_CallbackApply__c == 'NTT'){
                           ACL.Apttus_Config2__NetPrice__c = ACL.Apttus_Config2__NetPrice__c +  (ACL.Apttus_Config2__SellingTerm__c * NTT * ACP.APTS_Additional_Aircraft_Types__c);
                       }
                       else if(ACL.APTS_CallbackApply__c == 'NTT & GDFE'){
                           ACL.Apttus_Config2__NetPrice__c = ACL.Apttus_Config2__NetPrice__c +  (ACL.Apttus_Config2__SellingTerm__c * NTTGDFE * ACP.APTS_Additional_Aircraft_Types__c);
                       }
                   lineItemsToUpdate.Add(ACL); 
               } 
               
               
          }   
        } 
             
            
    }
    
    /**
    * Callback after all batches of line items are processed
    * Use the finish method to release state
    */
    global void finish() {
        // update included line items
        if (!this.lineItemsToUpdate.isEmpty()) {
            Database.update(this.lineItemsToUpdate);
            //Clear List
            this.lineItemsToUpdate.clear();
        }
    }
}