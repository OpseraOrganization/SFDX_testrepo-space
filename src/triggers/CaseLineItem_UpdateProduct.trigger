/** * File Name: CaseLineItem_UpdateProduct
* Description :Trigger to update the product of Line Items
* according to the part Number send from Web
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
trigger CaseLineItem_UpdateProduct on Case_Line_Item__c (before insert) {
List<String> partId=new List<String>();
List<Case> cases= new List<Case>();
integer flag=0,productSize=0;
List<Product2> products= new List<Product2>();
    for(Case_Line_Item__c  caseLineItems:Trigger.New){
    //getting the Case Records
    if(caseLineItems.Part_Number__c !=null){
    partId.add(caseLineItems.Part_Number__c);
    }
    }// end of for
    if(partId.size()>0){
    //getting products
    try{
    products=[Select Id,product_number__c,name from Product2 where product_number__c in:partId];
    }//end of try    
    catch(Exception e){}     
           for(Case_Line_Item__c  caseLineItem:Trigger.New){
               flag=0;
            //getting the Case Records
                if(caseLineItem.Part_Number__c !=null){
                productSize=products.size();
                  for(integer i=0;i< productSize;i++){
                  // if matching product is found                  
                   if(products[i].Product_Number__c==caseLineItem.Part_Number__c){
                      caseLineItem.Product_Number__c=products[i].Id;
                       caseLineItem.Product_Matched__c='Yes';
                       flag=1;
                   }// end of if
                  }// end of for
                 //No Matching products
                  if(flag ==0)
                  caseLineItem.Product_Matched__c='No';
                }
            }// end of for      
    }// end of if (partId.size()>0)  
}// end of trigger