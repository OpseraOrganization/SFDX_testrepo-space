public class CustomConvertController{
      public Lead leadRec{get;set;}
    private Lead leadRecPrivate{get;set;}
    public CustomConvertController(ApexPages.StandardController stdController){
        leadRec = (Lead)stdController.getRecord();
        
    leadRecPrivate = [select Contact__r.name,Account__r.Strategic_Business_Unit__c,account__r.Name,account__r.CBT__c,account__r.CBT_Team__c,Primary_Email_Address__c,Contact_Alternate_Email__c,Primary_Work_Number__c,Primary_Cell_Number__c,Lead_Number__c,LeadSource from Lead where id=:leadRec.id];
}
    public PageReference saveLead(){
    if(leadRec.RecordTypeId == Label.Lead_Create_Layout || leadRec.RecordType.name=='Create C&PS Lead' ){
        leadRec.RecordTypeId = system.Label.LeadConvertedLayout;
        leadRec.Status = 'Converted';
        }
        update leadRec;
        String urlString = '/006/e?opp3='+leadRec.New_Opportunity__c+'&'+system.Label.LeadFieldIDONOPP+'='+leadRec.id+'&CF00N30000004q5zZ='+leadRecPrivate.Account__r.Name+'&00N30000004q5zO='+leadRecPrivate.account__r.CBT_Team__c+'&00N30000004q60B='+leadRecPrivate.Account__r.Strategic_Business_Unit__c+'&00N30000004q5zP='+leadRecPrivate.Account__r.CBT__c+'&opp4='+ leadRecPrivate.Account__r.Name+'&CF00Na0000009SYk3='+leadRecPrivate.Contact__r.name+'&opp6='+leadRecPrivate.LeadSource+'&retURL=apex/LeadCustomConvert?id='+leadRec.id+'&opp11=Prospecting&RecordType=';
        if(leadRecPrivate.Account__r.Strategic_Business_Unit__c =='ATR'){
            urlString = urlString+System.Label.Lead_ATR_Complex;
        }
        if(leadRecPrivate.Account__r.Strategic_Business_Unit__c =='BGA'){
            urlString = urlString+System.Label.Lead_BGA_AM_Complex;
        }
        if(leadRecPrivate.Account__r.Strategic_Business_Unit__c =='D&S'){
            urlString = urlString+System.Label.Lead_D_S_Complex;
        }
        system.debug('urlString value:'+urlString);
        PageReference pageRef = new PageReference(urlString);
        return pageRef;
    }
    @AuraEnabled
    public static Account saveLead(Lead leadRec){
        //leadRec.RecordTypeId = system.Label.LeadConvertedLayout;
        //leadRec.Status = 'Converted';
        //update leadRec;
        
        Account acct = [select id,Name,CBT_Team__c,Strategic_Business_Unit__c,CBT__c from Account where id=:leadRec.Account__c];
        Contact contact = [select id,name from contact where id=:leadRec.Contact__c];
        //This is just a dummy update to make use of contact id in the Id.
        acct.Name = contact.id;
       
        return acct;
    }
    
    @AuraEnabled
    public static void updateLead(Lead leadRec){
       if(leadRec.RecordTypeId == Label.Lead_Create_Layout || leadRec.RecordType.name=='Convert C&PS Lead'){
        leadRec.RecordTypeId = system.Label.LeadConvertedLayout;
        leadRec.Status = 'Converted';
        }
        update leadRec;
    }
    public PageReference saveContact(){
    if(leadRec.RecordTypeId ==Label.LeadConvertLayout){
         leadRec.RecordTypeId = system.Label.LeadConvertLayout;
        leadRec.Status = 'Sales Qualified Lead (SQL)';
        }
       else{
        leadRec.RecordType.name = 'Convert C&PS Lead';
        leadRec.Status = 'Sales Qualified Lead (SQL)';
        }
        
        update leadRec;
        String urlString = '/003/e?00N30000004q5Qi='+leadRecPrivate.Account__r.Strategic_Business_Unit__c+'&00N30000004q5Ps='+leadRecPrivate.Account__r.CBT__c+'&00N30000004q5Pr='+leadRecPrivate.account__r.CBT_Team__c+'&con15='+leadRecPrivate.Primary_Email_Address__c+'&00N30000004q5Pq='+leadRecPrivate.Contact_Alternate_Email__c+'&00N30000004q5QT='+leadRecPrivate.Primary_Work_Number__c+'&00N30000004q5QY='+leadRecPrivate.Primary_Cell_Number__c+'&RecordType=';
        if(leadRecPrivate.Account__r.Strategic_Business_Unit__c =='ATR' ){
            urlString = urlString+System.Label.Lead_ATR_Contacts;
        }
        if(leadRecPrivate.Account__r.Strategic_Business_Unit__c =='BGA'){
            urlString = urlString+System.Label.Lead_BGA_Contacts;
        }
        if(leadRecPrivate.Account__r.Strategic_Business_Unit__c =='D&S'){
            urlString = urlString+System.Label.Lead_D_S_Contacts;
        }
        system.debug('urlString value:'+urlString);
        PageReference pageRef1 = new PageReference(urlString);
        return pageRef1;
         
    }
    
    public PageReference saveLeadWithOpportunity(){
       if(leadRec.RecordTypeId == Label.LeadConvertLayout || leadRec.RecordTypeId==Label.Converted_C_PS_Lead||leadRec.RecordTypeId==label.Lead_Converted_C_PS){
        leadRec.RecordTypeId = system.Label.LeadConvertedLayout;
        leadRec.Status = 'Converted';
        }
        update leadRec;
        Opportunity oppNew = [select id,Lead_ID__c,FSEintiator_name_Leadmapped__c,Lead_Number__c,Lead_Creation_Date__c,Lead_Description__c,Lead_Amount__c  from Opportunity where id =:leadRec.Opportunity_Name__c];
        oppNew.Lead_ID__c=leadrec.id;
        Lead leadInfo = [select id,Lead_Number__c,FSE_Initiator_Name__c,Lead_Creation_Date__c,ATR_Estimated_Value__c,Lead_Description__c from lead where id=:leadRec.id];
        oppNew.FSEintiator_name_Leadmapped__c = leadInfo.FSE_Initiator_Name__c;
        oppNew.Lead_Number__c = leadInfo.Lead_Number__c;
        oppNew.Lead_Creation_Date__c = leadInfo.Lead_Creation_Date__c;
        oppNew.Lead_Description__c = leadInfo.Lead_Description__c;
        oppNew.Lead_Amount__c = leadInfo.ATR_Estimated_Value__c;
        update oppNew;  
          
        PageReference pageRef = new PageReference('/'+leadRec.id);
        return pageRef;
    }
    @AuraEnabled
    public static String saveLeadWithOpportunity(Lead leadrec){
        if(leadRec.RecordTypeId == Label.LeadConvertLayout|| leadRec.RecordType.name=='Create C&PS Lead'|| leadRec.RecordType.name=='Convert C&PS Lead'){
        leadRec.RecordTypeId = system.Label.LeadConvertedLayout;
        leadRec.Status = 'Converted';
        }
        update leadRec;
        Opportunity oppNew = [select id,Lead_ID__c,FSEintiator_name_Leadmapped__c,Lead_Number__c,Lead_Creation_Date__c,Lead_Description__c,Lead_Amount__c  from Opportunity where id =:leadRec.Opportunity_Name__c];
        oppNew.Lead_ID__c=leadrec.id;
        Lead leadInfo = [select id,Lead_Number__c,FSE_Initiator_Name__c,Lead_Creation_Date__c,ATR_Estimated_Value__c,Lead_Description__c from lead where id=:leadRec.id];
        oppNew.FSEintiator_name_Leadmapped__c = leadInfo.FSE_Initiator_Name__c;
        oppNew.Lead_Number__c = leadInfo.Lead_Number__c;
        oppNew.Lead_Creation_Date__c = leadInfo.Lead_Creation_Date__c;
        oppNew.Lead_Description__c = leadInfo.Lead_Description__c;
        oppNew.Lead_Amount__c = leadInfo.ATR_Estimated_Value__c;
        update oppNew;  
          
        //PageReference pageRef = new PageReference('/'+leadRec.id);
        return null;
    }
}