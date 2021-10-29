/**
 * Quote Automation Project - Handler Class for ContentDocumentTrigger Trigger to Handle the Updated Notification.
 * */
public class QA_EmailNotificationHandler {
    //Depricated part of Attachment to file movement process. 
    public static void snedEmailNotification(List<Attachment> listatts){
    }
    public static void snedEmailNotification(Map<String,String> listdocs){
        List<Messaging.SingleEmailMessage> bulk_msgs = new List<Messaging.SingleEmailMessage>();
        for(ContentVersion each_att : [SELECT Id,ContentDocumentId,CreatedById,Title FROM ContentVersion WHERE ContentDocumentId IN : listdocs.keySet()]){
            if(each_att.Title.contains(System.Label.QA_FileString) && each_att.CreatedById == System.Label.QA_ApiUser){
                System.debug('::Inside IF::');
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(getContactId(listdocs.get(each_att.ContentDocumentId)));
                message.setWhatId(listdocs.get(each_att.ContentDocumentId));
                message.setTemplateId(label.QA_Quote_Status_Notification);
                message.setBccSender(false);
                message.setUseSignature(false);
                message.setOrgWideEmailAddressId(label.QA_DonotReplyOrgId);
                message.setSaveAsActivity(true); 
                bulk_msgs.add(message);
            }
        }
        try{
            System.debug('::Inside EMail Send::');
            Messaging.sendEmail(bulk_msgs);
           }
        catch (Exception ex) {
            System.debug('Exception '+ex.getMessage());
        }
    }
    public static String getContactId(String caseid){
        String contactid = '';
        if(caseid != '' && caseid != null){
            contactid = [SELECT Id,ContactId FROM Case WHERE Id =:caseid LIMIT 1].ContactId;
        }
        return contactid;
    }
}