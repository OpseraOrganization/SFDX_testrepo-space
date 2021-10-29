global class ConexiomCaseUpdate{ 
    webservice static Id conexServiceMethod(String caseNumberPI, String subClassPI, String conexiomPI, String escalatedToPI, String salesOrderNumberPI, String numberOfLinesProcessedPI, String internalCommentsPI) {
        system.debug('<<caseNumberPI>>'+ caseNumberPI);
        List<String> errorMsgList = new List<String>();
        List<User> ur = new List<User>();
        ur = [Select Id, Email from User Where Email = :escalatedToPI AND IsActive = True AND UserName != 'deniedpartyscreeningapiuser@honeywell.com.conexiom' limit 1]; // later change to correct Email Address..
        String esclatedToUserId = '';
        for(User u: ur)
        {
            esclatedToUserId = u.Id;
        }
        system.debug('<<esclatedToUserId>>'+esclatedToUserId);
        List<Case> cas = new List<Case>();
        cas = [Select Id, CaseNumber, Sales_Order_Number__c, Number_of_Lines_Processed__c, Comments, User_VN_Name__c, Sub_Class__c, Conexiom__c from Case Where CaseNumber = :caseNumberPI];
        if(cas.Size() == 0)
        {
            errorMsgList.add('No Case found with the Case Number:'+caseNumberPI+' in SFDC');
        }
        try
        {
            Case casUpd = new Case();
            for(Case cs: cas)
            {
                casUpd.Id = cs.Id;
                casUpd.Sub_Class__c = subClassPI;
                casUpd.Conexiom__c = conexiomPI;
                system.debug('<<cs.Sales_Order_Number__c>>'+cs.Sales_Order_Number__c+'<<salesOrderNumberPI>>'+salesOrderNumberPI);
                if(cs.Sales_Order_Number__c != '' && cs.Sales_Order_Number__c != null && salesOrderNumberPI != '' && salesOrderNumberPI != null)
                {   
                    system.debug('<<Sales_Order_Number__c if>>');
                    casUpd.Sales_Order_Number__c = cs.Sales_Order_Number__c+','+salesOrderNumberPI;
                }
                else if(salesOrderNumberPI != '' && salesOrderNumberPI != null)
                {
                    system.debug('<<Sales_Order_Number__c else>>');
                    casUpd.Sales_Order_Number__c = salesOrderNumberPI;
                }
                system.debug('<<casUpd.Sales_Order_Number__c>>'+casUpd.Sales_Order_Number__c);          
                if(cs.Number_of_Lines_Processed__c != '' && cs.Number_of_Lines_Processed__c != null && numberOfLinesProcessedPI != '' && numberOfLinesProcessedPI != null)
                {  
                    system.debug('<<Number_of_Lines_Processed__c Check if Integer>>'+ Integer.ValueOf (numberOfLinesProcessedPI.trim()) );
                    casUpd.Number_of_Lines_Processed__c = String.ValueOf( Integer.ValueOf(cs.Number_of_Lines_Processed__c) + Integer.ValueOf(numberOfLinesProcessedPI.trim()) );
                }
                else if(numberOfLinesProcessedPI != '' && numberOfLinesProcessedPI != null)
                {
                    system.debug('<<Number_of_Lines_Processed__c Check Else Integer>>'+ Integer.ValueOf (numberOfLinesProcessedPI.trim()) );
                    casUpd.Number_of_Lines_Processed__c = String.ValueOf( Integer.ValueOf (numberOfLinesProcessedPI.trim()) );
                }
                casUpd.Comments = internalCommentsPI;
                if(esclatedToUserId != '')
                {
                    casUpd.User_VN_Name__c = esclatedToUserId;
                }
                system.debug('<<casUpd Before Update>>'+casUpd);
                
                if(errorMsgList.size() == 0)
                {
                    Update casUpd;
                    system.debug('<<casUpd After Update>>'+casUpd);
                }
            }
        }
        catch(exception e)
        {
            String excError = String.valueOf(e);
            errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
        }
        system.debug('<<errorMsgList>>'+errorMsgList);
        if(errorMsgList.size() != 0)
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'ashwin.sagayaraj@nttdata.com', 'satyanarayan.nahak@honeywell.com'};
            message.subject = 'Error received in PI Case:'+caseNumberPI;
            String errorMessageString='';
            for(String st: errorMsgList)
            {
                errorMessageString += st+'******';
            }
            message.plainTextBody = errorMessageString;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } 
            else 
            {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
            }
            return null;
        }
        else
        {
            system.debug('<<Success PI>>'+cas[0].Id);
            return cas[0].Id;
        }
    }   
}