global class SingleEmailMsg implements Database.Batchable<sObject>
{
    //String query = 'SELECT Id,Email,Email_Count__c FROM Contact';
    global final String query;
    public SingleEmailMsg(String pQuery){
        query=pQuery;
    } 
    global database.querylocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        for(Contact c : scope) 
        {
            if(c.email!=null && c.email!='')
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(c.Id);
                mail.setTemplateId('00XQ0000000I6wS');
                /*if (c.Email_Count__c < 5 || c.Email_Count__c == null )
                {
                    if(c.Email_Count__c == null)
                    {
                        c.Email_Count__c = 0;
                    }
                    c.Email_Count__c = c.Email_Count__c + 1;
                }*/
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                 
            }
            
        }
    }
    global void finish(Database.BatchableContext BC)
    {
    }
}