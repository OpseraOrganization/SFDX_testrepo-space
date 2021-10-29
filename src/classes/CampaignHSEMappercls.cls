public class CampaignHSEMappercls{

    //Public string selectedname{get;set;}
    public List<RMU_VALUE__c> acclst{get; set;}
    Public string recnamesearch{get;set;}
    
    Public CampaignHSEMappercls(){
        acclst=new List<RMU_VALUE__c>([SELECT Id, Name,Campaign__c,Bulletins__c,Brochures__c,Briefcase__c FROM RMU_VALUE__c WHERE NOT Name LIKE 'SIP%']);
    }
  }