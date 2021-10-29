/**
 * Quote Automation Project - Email Notification to Customers once Quote Pdf is Generated.
 * */
trigger QA_EmailNotification on Attachment (after insert) {
    if(trigger.isInsert && trigger.isAfter){
        QA_EmailNotificationHandler.snedEmailNotification(trigger.new);
    }
}