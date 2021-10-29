global  class BGAOpportunityFollowUp {

Opportunity opp {get;set;}
EmailTemplate emailContent = null;
final Id recId = null;
Map<String,String> configData = null;

public BGAOpportunityFollowUp()
{
    configData = convertJsonIntoMap(Label.Opportunity_request_follow_up);
}

webservice static void executeAllSteps(Id recId){
        BGAOpportunityFollowUp bpf = new BGAOpportunityFollowUp();
        bpf.initProcess(recId);
        bpf.createEmail();
        bpf.createTask();
    }

public void initProcess(Id rId){
    opp             = [Select Id,OwnerId,Name from Opportunity where Id = :rId][0];
    try{
            emailContent    = [select subject,body from EmailTemplate  where id = :configData.get('emailTemplateId') and IsActive = true][0];
    }catch(Exception e){}
}

public void createEmail(){
            if(opp != null){
                    User ownerDetls     = [ select  Id,Email,ManagerId,Manager.Email 
                                            from    User 
                                            where   Id = :opp.OwnerId 
                                            and Isactive = true ][0];
                    sendEmail(
                                (ownerDetls.email != null ? new List<String>{ownerDetls.email} : null),
                                (ownerDetls.Manager.Email != null ? new List<String>{ownerDetls.Manager.Email} : null),
                                getEmailSubject(),
                                getEmailBody()
                            );
        }
}

public void createTask(){
        if(opp != null){
            Task tskNew = new Task();
            tskNew.WhatId=opp.Id;
            tskNew.OwnerId=opp.ownerId;
            tskNew.Subject = getEmailSubject();
            tskNew.Description = getEmailBody();
            tskNew.ActivityDate = System.Today().addDays(Integer.valueOf(configData.get('taskDueDays')));
            tskNew.Type = configData.get('taskType');
            
            if(configData.get('createTask') == 'yes' ||configData.get('createTask').contains('yes'))
            insert tskNew;
        }
}

void sendEmail(List<String> toList,List<String> ccList, String subject,String body){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toList);
        mail.setCcAddresses(ccList);
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}


String getEmailSubject(){
    String str = '';
    if(emailContent != null){
        str = emailContent.Subject; 
    }
    
    if(str.length() == 0 || str == ''){
        str = 'Request follow up on opportunity - {!Opportunity.Name}';
    }
    
    str = str.replace('{!Opportunity.LastModifiedBy}', UserInfo.getName());
    str = str.replace('{!Opportunity.Id}', opp.Id);
    str = str.replace('{!Opportunity.Name}', opp.Name);
    return str;
}

String getEmailBody(){
    String str = '';
    if(emailContent != null){
        str = emailContent.Body;    
    }
    
    if(str.length() == 0 || str == ''){        
        str = str + 'Task has be assigned to you at the request of {!Opportunity.LastModifiedBy}.';
        str = str + 'Please follow up on the actions to be taken on opportunity "{!Opportunity.Name}".';
        str = str + '<br/><br/>';
        str = str + 'Opportunity Link:';        
        //str = str + '<a href="https://na13.salesforce.com/{!Opportunity.Id}">https://na13.salesforce.com/{!Opportunity.Id}</a>';
        String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        str = str + '<a href="' + strbaseURL + '/{!Opportunity.Id}">' + strbaseURL + '/{!Opportunity.Id}</a>' ;               
    }
    
    str = str.replace('{!Opportunity.LastModifiedBy}', UserInfo.getName());
    str = str.replace('{!Opportunity.Id}', opp.Id);
    str = str.replace('{!Opportunity.Name}', opp.Name);
    return str;
}

Map<String,String> convertJsonIntoMap(String jsonStr){
        Map<String,String> retMap = new Map<String,String>(); 
        JSONParser parser = JSON.createParser(jsonStr);
            while (parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){     
                        String fiedName = parser.getText();
                        parser.nextToken();
                        String fiedValue = parser.getText();
                        retMap.put(fiedName,fiedValue);
                    }
            }
        return retMap;  
    }


    @isTest(SeeAllData=true)
    public  static void testCoverage(){
        //BGAOpportunityFollowUp.executeAllSteps('006e0000002cwFY');
        //BGAOpportunityFollowUp.executeAllSteps('0063000000o1Tuj');
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        Platform__c pf = [select id,Name from Platform__c where Name Like '%Test%' limit 1];
        Opportunity opp = new Opportunity();
        opp.Name = 'OppNsmre';
        opp.AccountId = acc.id;
        opp.End_User__c = acc.id;
        opp.SBU__c = 'Intercompany';
        opp.CBT_Tier_2__c = 'IAI';
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today();
        opp.Prime_Sub__c = 'None';
        opp.Contract_Type__c = 'BPA';
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'Competetive';
        opp.International_Code__c = 'Domestic';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'Yes';
        insert opp;
        BGAOpportunityFollowUp.executeAllSteps(opp.id);
    }

}