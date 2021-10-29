public without sharing class EmailExceptionToAdmin {
 
    /*
        02/27/12 - This class will be used to email the primary contact 
        whenever an unhandled exception is encountered.
         
        Please note that this class is WITHOUT SHARING because the public site user
        is often the one that calls this class and that set of users does not have
        access to the user table.  So if this class were with sharing, it would fail.
    */
 
    public EmailExceptionToAdmin(string SourceLocation, Exception e, string ExtraInformation) {
         List<String> ToEmailAddress = new List<String>(); 
        String[] emailAddressArr = (label.EmailAddressCaseWF).split(',');        
        if(emailAddressArr.size() > 0){            
            for(String i : emailAddressArr){
                ToEmailAddress.add(i);
            }
        }     
         
        if (ToEmailAddress != null) {
             
                // Make sure this transaction won't fail due to lack of daily capacity
                Messaging.reserveSingleEmailCapacity(1);
                 
                // generate our new object
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                 
                // build the Array string required to set the to address
               // String[] toAddresses = new String[] {ToEmailAddress};
                //system.debug('ToEmailAddress = ' + ToEmailAddress);
                 
                // Set our to address
                email.setToAddresses(ToEmailAddress);
 
                // hide the salesforce name in the display
                email.setSenderDisplayName('SalesForce.com');
                 
                // set the subject on the email
                email.setSubject('Unhandled Exception Information');
 
                 
                // set the body of the email
                email.setHTMLBody('An unhandled Exception has been encountered from: ' + SourceLocation + '' +
                                  'Exception Type Name: ' + e.getTypeName() + '' +
                                  'Exception Message: ' + e.getMessage() + '' +
                                  'Exception Cause: ' + e.getCause() + '' +
                                  'Exception LineNumber: ' + e.getLineNumber() + '' +
                                  'Extra Information: ' + ExtraInformation
                );
                 
                // send our email by creating an array of emails and calling the send email method.
                Messaging.SingleEmailMessage[] EmailsToSend = new Messaging.SingleEmailMessage[] { email };
                 
                Messaging.sendEmail(EmailsToSend);            
             
        } // check for null address
         
    } // constructor Method
     
} // end class