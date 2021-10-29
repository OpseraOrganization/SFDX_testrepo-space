public class LeadInactivityNotificationBatch  implements Database.Batchable<sObject>,Schedulable {
    public List<String> completedStatuses=new List<String>{'Converted','Disqualified','Recycle','Converted – Channel Partner'};
        EmailTemplate emTemplate;
    
    public void execute(SchedulableContext ctx) {
        database.executeBatch(new LeadInactivityNotificationBatch(),500);
    }
    
    public LeadInactivityNotificationBatch(){
                emTemplate=[select id,htmlvalue,subject from emailtemplate where name='Lead 2 days since update reminder template'];
                system.debug(emtemplate.id);
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        string query='select id,lastmodifieddate,ownerId,Owner.Name,company,name,ATR_Product_Information__c,product_number__r.Description from lead where status NOT IN :completedStatuses  and Lead_owner_change__c=\'TRUE\'';
        if(!test.isrunningTest()){
            query  +=' and lastmodifieddate!=last_N_days:2 and CALENDAR_YEAR(CreatedDate)>2018';
        } 
        return database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<sobject> leads){
        List<Messaging.SingleEmailMessage> emessageList=new List<Messaging.SingleEmailMessage>();
        system.debug(emTemplate);
        for(sobject currentlead:leads){
            lead c1=(lead)currentlead;
            string htmlbody,subject;
            if(!string.isblank(c1.ATR_Product_Information__c) && (c1.ATR_Product_Information__c.contains('MSP') || c1.ATR_Product_Information__c.contains('MPP') ||c1.ATR_Product_Information__c.contains('HAPP'))){
                htmlbody=emTemplate.htmlvalue.replace('<![CDATA[','').replace(']]>','');
                system.debug('htmlbody-->'+htmlbody);
                if(!test.isRunningTest())
                {
                    htmlbody=htmlbody.replace('{!Lead.OwnerFullName}', c1.Owner.Name);
                
                }
                htmlbody=htmlbody.replace('{!Lead.Link}',url.getSalesforceBaseUrl().toExternalForm()  + '/' + c1.Id);
                htmlbody=htmlbody.replace('{!Lead.Company}', c1.company);
                htmlbody=htmlbody.replace('{!Lead.Name}', c1.Name);
                htmlbody=htmlbody.replace('{!Lead.ATR_Product_Information__c}', c1.ATR_Product_Information__c);
                Messaging.singleEmailMessage message=new Messaging.singleEmailMessage();
                message.setOrgWideEmailAddressId(Label.AERO_Customer_Replies);
                message.setToAddresses(new List<String>{c1.OwnerId});
                message.setSubject(emtemplate.subject);
                message.setHTMLBody(htmlbody);
                emessageList.add(message); 
                system.debug(message);
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emessageList);
        system.debug(results);
    }    
    
    public void finish(Database.BatchableContext bc){
        
    }    
}