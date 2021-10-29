/** * File Name: CloneOpportunityProduct
* Description This class is to clone the Opportunity Product with Schedules 
* @author : ITSS
* */
public class CloneOpportunityProduct {
     
    //variable declaration
    private final OpportunityLineItem olItem;
    public String msg{get;set;}
    public Boolean showInput{get;set;}
    public Boolean showOutput{get;set;}
    String profileId = System.Userinfo.getprofileId();
    //profileid = profileId.substring(0,15);
    String pName = [SELECT Name FROM Profile where Id  =: profileid].Name;
    public CloneOpportunityProduct (ApexPages.StandardController stdController) 
    {
        this.olItem = (OpportunityLineItem)stdController.getRecord();
    }
    
    public CloneOpportunityProduct () 
    {
        
    }
    public pagereference cloneOpportunityLineItemEdit(){
    msg='Please click on save to clone the product';
    List<OpportunityLineItemSchedule> scheduleList=[select id,type from OpportunityLineItemSchedule where OpportunityLineItemId=:this.olItem.id];
    if(scheduleList!=null && scheduleList.size()>0){
       showInput=false;
       showOutput=true;
    }else{
        showInput=true;
        showOutput=false;
    }
    String SOQL = 'Select ';
       // SOQL += 'pricebookentryid, hasrevenueschedule, createdbyid, lastmodifieddate, id, external_id__c, unitprice, description, plant__c, isdeleted, quantity, testend__c, extended_price__c, opportunityid, systemmodstamp, servicedate, listprice, hasschedule, price__c, createddate, subtotal, active__c, type__c, discount, sortorder, amount_net__c, description__c, probability__c, hasquantityschedule, lastmodifiedbyid';
       // Added for the Certido # - 337576 - Start
       SOQL += 'pricebookentryid, hasrevenueschedule, createdbyid, lastmodifieddate, id, external_id__c, unitprice, description, plant__c, isdeleted, quantity, testend__c, extended_price__c, opportunityid, systemmodstamp, servicedate, listprice, hasschedule, price__c, createddate, subtotal, active__c, type__c, discount, sortorder, amount_net__c, description__c, probability__c, hasquantityschedule,Revenue_Type__c,M_PM_Product__c, lastmodifiedbyid';
       // Added for the Certido # - 337576 - End
       
        //Remove the last , unnecessary comma 
        SOQL += ' From OpportunityLineItem o where id=\''+this.olItem.id+'\' LIMIT 1' ; 
        //Execute SOQL & Cast the sObject type into an OpportunityLineItem
        sObject S = Database.query(SOQL);  
        OpportunityLineItem newItem= (OpportunityLineItem)S; 
        newItem.Active__c=this.olItem.Active__c;
        newItem.ServiceDate=this.olItem.ServiceDate;
        newItem.UnitPrice=this.olItem.UnitPrice;
        if(this.olItem.Type__c == 'Booked' && pName == 'D&S Sales'){
            newItem.Type__c='Forecast';
        }else{
            newItem.Type__c=this.olItem.Type__c;
        }
        
        newItem.Quantity=this.olItem.Quantity;
        return null;
    }
    public PageReference save(){
        
        PageReference pageRef =cloneOpportunityLineItem();
        System.debug('pageRef in Save method === '+pageRef);
        if(pageRef!=null){
            pageRef.setRedirect(true); 
            return pageRef;
        }else{
        return null;
        }
    }
    public pagereference cloneOpportunityLineItem (){
        Savepoint sp = Database.setSavepoint();
        String oliID = ApexPages.currentPage().getParameters().get('id'); 
        if (oliID == null) { 
        //Display the Visualforce page's content if no Id is passed over
            return null;
        } 
        // Get the sObject describe result for the OpportunityLineItem object  
        Schema.DescribeSObjectResult r = OpportunityLineItem.sObjectType.getDescribe(); 
        Map<String, Schema.SObjectField> M = r.fields.getMap(); 
        //Generate a Map of the fields 
        //Now loop through the list of Field Names and concatenate the SOQL query string 
        String SOQL = 'Select ';
     // SOQL += 'pricebookentryid, hasrevenueschedule, createdbyid, lastmodifieddate, id, external_id__c, unitprice, description, plant__c, isdeleted, quantity, testend__c, extended_price__c, opportunityid, systemmodstamp, servicedate, listprice, hasschedule, price__c, createddate, subtotal, active__c, type__c, discount, sortorder, amount_net__c, description__c, probability__c,hasquantityschedule, lastmodifiedbyid';
         // Added for the Certido # - 337576 - Start
        SOQL += 'pricebookentryid, hasrevenueschedule, createdbyid, lastmodifieddate, id, external_id__c, unitprice, description, plant__c, isdeleted, quantity, testend__c, extended_price__c, opportunityid, systemmodstamp, servicedate, listprice, hasschedule, price__c, createddate, subtotal, active__c, type__c, discount, sortorder, amount_net__c, description__c, probability__c,Revenue_Type__c,M_PM_Product__c, hasquantityschedule, lastmodifiedbyid';
        // Added for the Certido # - 337576 - End
  
        //Remove the last , unnecessary comma 
        SOQL += ' From OpportunityLineItem o where id=\''+oliID+'\' LIMIT 1' ; 
        //Execute SOQL & Cast the sObject type into an OpportunityLineItem
        sObject S = Database.query(SOQL);  
        OpportunityLineItem oppLineItem = (OpportunityLineItem)S; 
        //Clone the OpportunityLineItem - 2 parameters (PreserveId or not, IsDeepClone or not )   
        OpportunityLineItem newOLI = oppLineItem.clone(false,true);
        //newOLI.PricebookEntryId = oppLineItem.PricebookEntryId + ' Cloned';
        //Code added by madhu for updating edited value by user
        newOLI.Active__c=this.olItem.Active__c;
        newOLI.ServiceDate=this.olItem.ServiceDate;
        newOLI.UnitPrice=this.olItem.UnitPrice;
        //newOLI.Type__c=this.olItem.Type__c;
        
        if(this.olItem.Type__c == 'Booked' && pName == 'D&S Sales' ){
            newOLI.Type__c='Forecast';
        }else{
            newOLI.Type__c=this.olItem.Type__c;
        }
        
        newOLI.Quantity=this.olItem.Quantity;
        newOLI.Probability__c=this.olItem.Probability__c;
        newOLI.Description=this.olItem.Description;
        newOLI.Revenue_Start_Date__c=this.olItem.Revenue_Start_Date__c;
        newOLI.Plant__c=this.olItem.Plant__c;
        newOLI.Revenue_End_Date__c=this.olItem.Revenue_End_Date__c;
        newOLI.Functional_Help_Required__c=this.olItem.Functional_Help_Required__c;
        newOLI.E_SIOP_Demand_Category__c=this.olItem.E_SIOP_Demand_Category__c;
        newOLI.Demand_Decision_Date__c=this.olItem.Demand_Decision_Date__c;
        newOLI.Closure_Actions__c=this.olItem.Closure_Actions__c;
        newOLI.Include_Net_Rev_in_SRO_Estimate__c=this.olItem.Include_Net_Rev_in_SRO_Estimate__c;
        newOLI.Include_in_CYO_Tracking__c=this.olItem.Include_in_CYO_Tracking__c;
        // Added for the Certido # - 337576 - Start
        newOLI.Revenue_Type__c=this.olItem.Revenue_Type__c;
        newOLI.M_PM_Product__c=this.olItem.M_PM_Product__c;
         // Added for the Certido # - 337576 - End
        try
        { 
            insert newOLI;   
        }
        catch(Exception e)
        {   
                  
            Database.rollback(sp);
            this.olItem.addError(e.getMessage());
            System.debug('in Catch block after rolledback sp newOLI ');
            return null;
        }
      
        // Get the sObject describe result for the Opportunity object  
        Schema.DescribeSObjectResult r1 = OpportunityLineItemSchedule.sObjectType.getDescribe(); 
        Map<String, Schema.SObjectField> M1 = r1.fields.getMap(); 
        //Generate a Map of the fields 
        //Now loop through the list of Field Names and concatenate the SOQL query string 
        String SOQL1 = 'Select ';  
        for (String fieldName : M1.keySet()){    
            System.debug('fieldName: ' + fieldName); 
            SOQL1 += fieldName + ',';  
        }  
        SOQL1 = SOQL1.substring(0,SOQL1.length()-1); 
        //Remove the last , unnecessary comma 
        SOQL1 += ' From OpportunityLineItemSchedule o where OpportunityLineItemId=\''+oliID+'\' ' ; 
        //Execute SOQL & Cast the sObject type into an OpportunityLineItemSchedule
        List<OpportunityLineItemSchedule> patt1= Database.query(SOQL1);  

        //Clone the OpportunityLineItem - 2 parameters (PreserveId or not, IsDeepClone or not )   
        List<OpportunityLineItemSchedule> newOLI1 = new List<OpportunityLineItemSchedule>();
        
        for(integer i=0;i<patt1.size();i++)
        {
            newOLI1.add(patt1[i].clone(false,true));
        }
        for(integer i=0;i<newOLI1.size();i++)
        {
            newOLI1[i].OpportunityLineItemId = newOLI.Id ; 
        }
        try
        {
            insert newOLI1;
        }
        catch (Exception e){
            //roll everything back in case of errors
            Database.rollback(sp);
            this.olItem.addError(e.getMessage());
            System.debug('in Catch block after rolledback sp newOLI1');
            return null;
        }
        //Redirect to the new OpportunityLineItem
        PageReference pageRef = new PageReference('/' + newOLI.Id);
        pageRef.setRedirect(true); 
        return pageRef;
    }
}