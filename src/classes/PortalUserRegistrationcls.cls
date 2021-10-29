public without sharing class PortalUserRegistrationcls 
{
    public Decimal contactCreatedCount{get;set;}
    public Decimal userRegCount{get;set;}
    public Decimal ContactCreatedPercentage{get;set;}   
    public Decimal dropOutCount{get;set;}
    public Decimal dropOutCountPercent{get;set;}   
    public Decimal firstTryCount{get;set;}
    public Decimal firstTryCountPercent{get;set;}
    public Decimal uniqueUserCount{get;set;}      
    //public String listSel{get;set;}
    //public Date dat {get;set;}
    //public Date dat1 {get;set;}  
    public PortalUserRegistrationcls () {       
    }    
    //public ApexPages.StandardSetController caseList {get;set;}            
    public void getCases() {
        system.debug('inside getcases');
        String start_date = Apexpages.currentPage().getParameters().get('event_start_date_alternate');
        String end_date = Apexpages.currentPage().getParameters().get('event_end_date_alternate'); 
        System.debug('Shiyam:'+start_date+'Sundar'+end_date);      
        Datetime tempStartdate;
        Datetime tempEnddate;         
        date tempStartdate1=date.valueof(Label.PortalUserReg_StartDate);
        date tempEnddate1=date.valueof(Label.PortalUserReg_EndDate);
        if(start_date != null)
        tempStartdate1=date.valueof(start_date);               
        if(end_date != null)
        tempEnddate1=date.valueof(end_date);            
        set<string> hid=new set<string>();
        set<string> hwidPUR=new set<string>();
        
        List<Portal_User_Registration__c > newList = [SELECT id,Name,Honeywell_ID__c,Contact_Creation_in_SFDC__c,CreatedDate__c,CreatedDate,Lastmodifieddate FROM Portal_User_Registration__c where CreatedDate__c >=: tempStartdate1 and CreatedDate__c <=: tempEnddate1 and Is_Employee__c = false limit 50000];
        
        //shiyam adds here
        Set<String> successCount=new Set<String>();
        Set<String> failureCount=new Set<String>();
        
        Set<String> userCount=new Set<String>();
        Integer successCountNum=0;
        Integer failureCountNum=0;
        Integer firstSuccessCountNum=0;
        Integer totalUserCount=0;
                
        for(Portal_User_Registration__c pr1 : newList){                                                                           
            if(pr1.Contact_Creation_in_SFDC__c == null)
            {    
                failureCount.add(pr1.Honeywell_ID__c);
                userCount.add(pr1.Honeywell_ID__c);
                            
            }
            if(pr1.Contact_Creation_in_SFDC__c =='Y')
            {
                successCount.add(pr1.Honeywell_ID__c);
                userCount.add(pr1.Honeywell_ID__c);
                System.debug('successCount:'+successCount.size());       
            }
            
         }      
         Set<String> firstSuccessCount=new Set<String>(successCount);
         Set<String> actualfailureCount=new Set<String>(failureCount);
         Set<String> excludeFailureSet=new Set<String>();
         actualfailureCount.removeAll(successCount);
         
         List<Portal_Honeywell_ID__c> honeywellIDList=[SELECT id,Name from Portal_Honeywell_ID__c where Name=:actualfailureCount and CreatedBy.Name!='API User MyAerospace Portal' limit 50000];
        for(Portal_Honeywell_ID__c HWID:honeywellIDList)
        {
        excludeFailureSet.add(HWID.Name);
        }   
         firstSuccessCount.removeAll(failureCount);
         firstSuccessCount.removeAll(excludeFailureSet);
         actualfailureCount.removeAll(excludeFailureSet);
         userCount.removeAll(excludeFailureSet);
         successCountNum=successCount.size();
         failureCountNum=actualfailureCount.size();
         firstSuccessCountNum=firstSuccessCount.size();
         totalUserCount=userCount.size();
         
         contactCreatedCount=decimal.valueof(successCountNum);
         dropOutCount=decimal.valueof(failureCountNum);//Failure Count
         userRegCount=decimal.valueof(totalUserCount);// total User Count
         uniqueUserCount=decimal.valueof(totalUserCount); 
         firstTryCount=decimal.valueof(firstSuccessCountNum);// First Try Count of Users
         if(contactCreatedCount!=0)
         {
             ContactCreatedPercentage=((contactCreatedCount*100)/userRegCount).round();//success percentage
         }
         else
         {
         ContactCreatedPercentage=0;
         }
         if(dropOutCount!=0)
         {
             dropOutCountPercent=((dropOutCount*100)/userRegCount).round();//failure percentage
         }
         else
         {
             dropOutCountPercent=0;
         }
         if(firstTryCount!=0)
         {
             firstTryCountPercent=((firstTryCount*100)/userRegCount).round();//First Try Percentage
         }
         else
         {
             firstTryCountPercent=0;
         }
         
         System.debug('successCount:'+successCountNum);
         System.debug('failureCount:'+failureCountNum);          
         System.debug('firsttry count:'+firstSuccessCountNum);
         System.debug('Total Number of users:'+totalUserCount);
         }
        
}