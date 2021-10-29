@isTest (seealldata=true)
private class CustomConvertControllertestclass {
    
    static testMethod void leadCustomConvert(){
    ValidationRuleSettings__c ValdRlu= new ValidationRuleSettings__c();
     ValdRlu.Name = 'Test Setting1';
     ValdRlu.Estimation_Validation__c=True;
     ValdRlu.Lead_Status_converted__c=True;
     insert ValdRlu;
        
        Lead leadRec = [select id,RecordTypeId,Recordtype.name from Lead limit 1 ];
        system.debug('Lead record are is '+leadRec);
      
        ApexPages.StandardController sc = new ApexPages.StandardController(leadRec);
        CustomConvertController convertCon = new CustomConvertController(sc);
           Account acct = [select id,Name,CBT_Team__c,Strategic_Business_Unit__c,CBT__c from Account limit 1];
        Contact contact = [select id,name from contact limit 1];
         acct.Name = contact.id;
         Opportunity oppNew = [select id,Lead_ID__c,FSEintiator_name_Leadmapped__c,Lead_Number__c,Lead_Creation_Date__c,Lead_Description__c,Lead_Amount__c  from Opportunity limit 1 ];
        convertCon.saveContact();
        //convertCon.saveLeadWithOpportunity();
        convertCon.saveLead(); 
         
    } 
   static testMethod void  saveLead(){
   ValidationRuleSettings__c ValdRlu= new ValidationRuleSettings__c();
     ValdRlu.Name = 'Test Setting1';
     ValdRlu.Estimation_Validation__c=True;
     ValdRlu.Lead_Status_converted__c=True;
     insert ValdRlu;
        Lead leadRec = [select id,RecordTypeId,Recordtype.name from Lead limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(leadRec);
        CustomConvertController convertCon = new CustomConvertController(sc);
         Account acct = [select id,Name,CBT_Team__c,Strategic_Business_Unit__c,CBT__c from Account limit 1 ];
        Contact contact = [select id,name from contact limit 1];
         acct.Name = contact.id;
        Opportunity oppNew = [select id,Lead_ID__c,FSEintiator_name_Leadmapped__c,Lead_Number__c,Lead_Creation_Date__c,Lead_Description__c,Lead_Amount__c  from Opportunity limit 1 ];
        oppNew.Lead_ID__c=leadrec.id;
        convertCon.saveContact();
      // convertCon.saveLeadWithOpportunity();
        convertCon.saveLead(); 
    }
    static testMethod void saveLeadWithOpportunity(){
    ValidationRuleSettings__c ValdRlu= new ValidationRuleSettings__c();
     ValdRlu.Name = 'Test Setting1';
     ValdRlu.Estimation_Validation__c=True;
     ValdRlu.Lead_Status_converted__c=True;
     insert ValdRlu;
     
        Lead leadRec = [select id,RecordTypeId,Recordtype.name,Lead_Number__c,FSE_Initiator_Name__c,Lead_Creation_Date__c,ATR_Estimated_Value__c,Lead_Description__c from Lead  limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(leadRec);
        CustomConvertController convertCon1 = new CustomConvertController(sc);      
       Opportunity oppNew = [select id,Lead_ID__c,FSEintiator_name_Leadmapped__c,Lead_Number__c,Lead_Creation_Date__c,Lead_Description__c,Lead_Amount__c  from Opportunity limit 1 ];       
        oppNew.Lead_ID__c=leadrec.id;
          //Lead leadInfo = [select id,Lead_Number__c,FSE_Initiator_Name__c,Lead_Creation_Date__c,ATR_Estimated_Value__c,Lead_Description__c from lead limit 1 ]; 
        convertCon1.saveContact(); 
        //convertCon1.saveLeadWithOpportunity();
        convertCon1.saveLead(); 
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
       System.currentPageReference().getParameters().put('id','');
    }
    static testMethod void saveLeadWithOpportunity1(){
     ValidationRuleSettings__c ValdRlu= new ValidationRuleSettings__c();
     ValdRlu.Name = 'Test Setting1';
     ValdRlu.Estimation_Validation__c=True;
     ValdRlu.Lead_Status_converted__c=True;
     insert ValdRlu;
          Lead leadRec = [select id,RecordTypeId,Recordtype.name,Contact__c,New_Opportunity__c,Opportunity_Name__c,Account__c from Lead where Opportunity_Name__c<>null and Contact__c<>null and Account__c<>null limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(leadRec);
        CustomConvertController convertCon1 = new CustomConvertController(sc);      
        Opportunity oppNew = [select id from Opportunity where id=:leadRec.Opportunity_Name__c limit 1];
        oppNew.Lead_ID__c=leadrec.id;
        update oppNew;
        // Lead leadRec = [select id,Lead_Number__c,FSE_Initiator_Name__c,Lead_Creation_Date__c,ATR_Estimated_Value__c,Lead_Description__c from Lead limit 1];
          Lead leadInfo = [select id,RecordTypeId,Lead_Number__c,FSE_Initiator_Name__c,Lead_Creation_Date__c,ATR_Estimated_Value__c,Lead_Description__c from lead limit 1 ]; 
        convertCon1.saveContact(); 
        convertCon1.saveLeadWithOpportunity();
        convertCon1.saveLead(); 
        CustomConvertController.saveLead(leadrec);
        CustomConvertController.updateLead(leadrec);
        CustomConvertController.saveLeadWithOpportunity(leadrec);
       
    }
 }