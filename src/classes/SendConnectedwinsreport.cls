/***********************************************************************************************
Name:                   SendConnectedwinsreport 
Author:                 Satya Mohanty
Created Date:           12/8/2018
Use Case:               This class query Top 20 and last days wins/loss records from Opportunity object
                         Report is send every day to  Connected Honeywell leaders .
                        
                        OWNED BY THE CRM SALES TEAM.
************************************************************************************************/
global class SendConnectedwinsreport implements System.Schedulable {
    global void execute(SchedulableContext sc) {
        DoExportOppotunity();
    }
    @future(callout=true)
    public static void DoExportOppotunity(){
         List<Opportunity> opptyList =  new List<Opportunity>();
         List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
         opptyList = [SELECT StageName,Pipeline_Amount__c,Opportunity_Type__c ,Parent_Campaign__c,CBT_Tier_2__c ,closedate, Name, Account.Name ,id, Sales_Channel__c FROM Opportunity where closedate >= 2019-01-01 and closedate <= 2019-12-31 and (stageName = 'closed won' or stageName = 'closed lost') and (NOT Opportunity_Type__c   like '%Run Rate%') and CBT_Tier_2__c <> 'HTSI'   and (NOT Name like '%Blanket%') order by Pipeline_Amount__c Desc limit 20 ];         
         ApexPages.PageReference pdf = new ApexPages.PageReference('/apex/ConnectedWinsvfpage');
         Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
         attachment.setFileName('ConnectedWins.xls');
         Blob b;
         try{
             if(!Test.isRunningTest()){
                 b = pdf.getContent();
                 
             }
         }catch(Exception ex){
            System.debug('ex'+ex);            
         }
         attachment.setBody(b);
         //attachment.setBody(report.getContent());
         
         OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:'sfdcreportexporter@honeywell.com'];
         if ( owea.size() > 0 ) {
             message.setOrgWideEmailAddressId(owea[0].Id);
         }
         if(!Test.isRunningTest()){
         message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
         }
         //String[] toAddresses = new String[] {'satyaranjan.mohanty@honeywell.com'};
        message.setBccSender(true);
         //String[] ccAddresses = new String[] {'satyamohantysfdc@gmail.com'};
         //message.setToAddresses(toAddresses);
         message.setBccAddresses(System.Label.ConnecteWinsBcc.Split(','));
         message.setToAddresses(System.Label.ConnectedWins.Split(','));
         //message.setccAddresses(ccAddresses);
         // message.setBccSender(System.Label.WinsReportBCC.Split(','));
         
         //message.setccAddresses(System.Label.WinsReportBCC.Split(','));
         EmailTemplate et=[Select id from EmailTemplate where Name='Connected WinsTemp']; 
         message.setTemplateId(et.id);         
         message.setTargetObjectId(System.Label.Winscontact);
         message.setSaveAsActivity(false);
         mails.add(message);
         Messaging.sendEmail(mails);
    }
}