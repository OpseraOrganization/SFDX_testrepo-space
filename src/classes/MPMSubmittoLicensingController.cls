Public with sharing class MPMSubmittoLicensingController {
    ID OppId;
    Public boolean disabl{get;set;} 
   // Public boolean WrgMsg1{get;set;}
   // Public boolean WrgMsg2{get;set;}
   //Public boolean WrgMsg3{get;set;}
    Public MPMSubmittoLicensingController(ApexPages.StandardController controller) {
    OppId = apexpages.currentpage().getparameters().get('id') ;
    Opportunity Opp = [Select id,StageName,name,Submit_to_Licensing__c,Corp_HIPI_Opportunity_Number__c,SFDC_Entry_Initiated__c from Opportunity where id =:OppId];
    if(Opp.Corp_HIPI_Opportunity_Number__c != Null || Opp.Corp_HIPI_Opportunity_Number__c != ''){
    disabl= true;
    }
    if(Opp.Corp_HIPI_Opportunity_Number__c == Null || Opp.Corp_HIPI_Opportunity_Number__c == ''){
    disabl= false;
    }
   
    //WrgMsg3 = false;
    }
    Public PageReference oppUpdate(){
    Opportunity Opp = [Select id,StageName,name,Submit_to_Licensing__c,Corp_HIPI_Opportunity_Number__c,SFDC_Entry_Initiated__c from Opportunity where id =:OppId];
    if((Opp.Submit_to_Licensing__c== false) || (Opp.Corp_HIPI_Opportunity_Number__c == '')){
        if(Opp.StageName =='Phase 2: Detailed Negotiation'){
        Opp.Submit_to_Licensing__c= true;   
        Opp.SFDC_Entry_Initiated__c = system.today(); 
        try{
        update opp;
        }catch(DMLException e){
         ApexPages.addMessages(e);
        }
        }      
    }   
    
        return null;      
    }
 
}