public class MainCaseTriggerUtility{
    
    public static void handleCaseException(Exception e,Case cases)
    {
         System.debug(e);       
        
        // Send an email to the TO list if exception occurs.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        List<String> mailToAddresses = new List<String>(); 
        String[] emailAddressArr = (label.EmailAddressCaseWF).split(',');        
        if(emailAddressArr.size() > 0){            
            for(String i : emailAddressArr){
                mailToAddresses .add(i);
            }
        }        
        mail.setToAddresses(mailToAddresses );
        mail.setSubject('Exception on Case Trigger Delegate.');
        String bodyText = 'Case Details : ' +'\n\tCase ID : '+cases.id +'\n\tCase Number : '+cases.casenumber;
        if(!Test.isRunningTest())
        {
            bodyText +='\n\n' +'Case Creation has failed with the following error message at the Line Number:\t' + e.getLineNumber()
                + '\n' + e.getMessage() 
                + '\n of Type ' + e.getTypeName() 
                + '\n of Type ' + e.getCause()
                + '\n\nStacktrace: ' + e.getStacktraceString();
        }
        mail.setPlainTextBody(bodyText);
        if(!(Test.isRunningTest()))
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
        }
        
    }
    public static void handleException(Exception e)
    {
         System.debug(e);       
        
        // Send an email to the TO list if exception occurs.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        List<String> mailToAddresses = new List<String>(); 
        String[] emailAddressArr = (label.EmailAddressCaseWF).split(',');        
        if(emailAddressArr.size() > 0){            
            for(String i : emailAddressArr){
                mailToAddresses .add(i);
            }
        }        
        mail.setToAddresses(mailToAddresses );
        mail.setSubject('Exception on Case Trigger Delegate.');
        String bodyText = 'Case Details : ';
        if(!Test.isRunningTest())
        {
            bodyText +='\n\n' +'Case Creation has failed with the following error message at the Line Number:\t' + e.getLineNumber()
                + '\n' + e.getMessage() 
                + '\n\n of Exception Type ' + e.getTypeName() 
                + '\n\nStacktrace: ' + e.getStacktraceString();
        }
        mail.setPlainTextBody(bodyText);
        if(!(Test.isRunningTest()))
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
        }
    }
    public static void handleOpportunityException(Exception e)
    {
         System.debug(e);       
        
        // Send an email to the TO list if exception occurs.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        List<String> mailToAddresses = new List<String>(); 
        String[] emailAddressArr = (label.EmailAddressCaseWF).split(',');        
        if(emailAddressArr.size() > 0){            
            for(String i : emailAddressArr){
                mailToAddresses .add(i);
            }
        }        
        mail.setToAddresses(mailToAddresses );
        mail.setSubject('Exception on Opportunity Trigger Delegate.');
        String bodyText = 'Opportuniy Details : ';
        if(!Test.isRunningTest())
        {
            bodyText +='\n\n' +'Opportuniy Creation/Updation has failed with the following error message at the Line Number:\t' + e.getLineNumber()
                + '\n' + e.getMessage() 
                + '\n\n of Exception Type ' + e.getTypeName() 
                + '\n\nStacktrace: ' + e.getStacktraceString();
        }
        mail.setPlainTextBody(bodyText);
        if(!(Test.isRunningTest()))
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
        }
    }
    public static void handleEmailMessageException(Exception e)
    {
        System.debug(e);       
        String UFRex = string.valueOf(e);
        if(!UFRex.contains('Future method cannot be called from a future or batch method: EmailAttachmentCopy.attachcase')){
            // Send an email to the TO list if exception occurs.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
            List<String> mailToAddresses = new List<String>(); 
            String[] emailAddressArr = (label.EmailAddressCaseWF).split(',');        
            if(emailAddressArr.size() > 0){            
                for(String i : emailAddressArr){
                    mailToAddresses .add(i);
                }
            }        
            mail.setToAddresses(mailToAddresses );
            mail.setSubject('Exception on Email Message Trigger Delegate.');
            String bodyText = 'Details : ';
            if(!Test.isRunningTest())
            {
                bodyText +='\n\n' +'Email Message failed with the following error message at the Line Number:\t' + e.getLineNumber()
                    + '\n' + e.getMessage() 
                    + '\n\n of Exception Type ' + e.getTypeName() 
                    + '\n\nStacktrace: ' + e.getStacktraceString();
            }
            mail.setPlainTextBody(bodyText);
            if(!(Test.isRunningTest()))
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
            }
        }
    }

}