global class EmailUtils {
    global static void sendMessage(AsyncApexJob job, Integer recordsProcessed){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'achee@saleforce.com','achee@salesforce.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Update Contact Address ' + job.Status);
        mail.setPlainTextBody('records processed ' + recordsProcessed);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
    }
}