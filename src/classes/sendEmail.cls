Global class sendEmail { 
       
    public sendEmail() 
    {    
    }
    public static boolean flag = true;
    public void sendMail(List<Id> contId, List<String> oldEmail,List<String> newEmail ){
        
        //Querying custom settings for the ids to which email has to be sent 
        EmailTemplate emailTemplate;    
        
        String[] recipients =  new String[]{}; 
        
        List<Contact> cont = [Select FirstName , LastName from Contact where Id in :contId];
        String fName = cont[0].FirstName;
        String lName = cont[0].LastName;
        String name = lName + ', ' + fName;
        String pString = 'Contact ' + lName + ', ' + fName +' Email has been modified.' + '\n' + 'Old Email address : '+oldEmail[0] + '\n' + 'New Email address : ' + newEmail[0] + '\n';
        //Uncomment for ITSS Sandbox
        recipients.add('websupportweb@l-2vvygw2c1nn57f8yso731r47i.tkl3bmaw.t.case.sandbox.salesforce.com') ;
        //Uncomment For Production
        //recipients.add('websupportweb@honeywell.com');
        String serverURL = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        String htmlbody = 'This is to inform you that '+pString+'\n'+'\n'+'Please review the Contact for Email changes.'+'\n'+'\n'+'Click on the below link to view details: '+'\n'+'\n'+ serverURL +contId[0] + '\n'+'\n'+'\n'+'Thank you, we appreciate your support! '+'\n'+'\n';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        String[] toAddresses = new String[]{}; 
        //Adding ids to the toaddresses list 
        System.debug('recipients.size() : '+recipients.size());
        for(Integer i=0;i<recipients.size();i++)   
        toAddresses.add(recipients[i]);  
      
        //emailTemplate = [Select Id from EmailTemplate where DeveloperName='Case_Auto_Acknowledgement_Template_1'];            
        //mail.setTemplateId(emailTemplate.Id);            
        //mail.setTargetObjectId(contId[0]);            
        //mail.setSaveAsActivity(false);            
        mail.setToAddresses(toAddresses);  
        //mail.setsubject('');
        mail.setsubject(pString);
        mail.setHtmlBody(htmlbody);
        //mail.setPlainTextBody(htmlbody);
                   
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        }

        /* BGA Code used in Lead  */
        public  static string preapreKeywords(string pstrInput, string chtString)
        {
            string vstr='';
         
            integer errLoc=0;
            try
            {   
            
            errLoc=10;
            
            //System.Debug('1. vstr = '+vstr);
            
            if(chtString == null)
            {
                //System.Debug('2. pstrInput = '+pstrInput);
                vstr = pstrInput;
                return vstr;
            }
            
            errLoc=20;
            if(pstrInput == null)
            {
                //System.Debug('3. pstrInput = '+pstrInput);
                return vstr;
            }
            
            string[] vStrArr = pstrInput.split(';');
            
            errLoc=30;
            for (integer k=0;k< vStrArr.size();k++)
            {
                if  (   
                        chtString.contains(';'+ vStrArr[k] + ';')== false
                        && vStrArr[k] != null
                        && vStrArr[k].length() > 0
                    )
                {
                    errLoc=40;
                    vstr = vstr + vStrArr[k] + ';';
                    //System.Debug('3. pstrInput = '+vstr);
                }
            }

            //System.Debug('3. pstrInput = '+vstr);                 
            return vstr;
            }
            catch(Exception e)
            {
                                    utilClass.createErrorLog
                                                             (
                                                             'sendEmail',
                                                             'preapreKeywords',
                                                              'ERRLOC : '+errLoc+' - '+pstrInput+'  - ' + chtString + ' - ' + e.getMessage()
                                                             );         
                                    vstr='';
                                    return vstr;
            }
        }
    
        
        
        WebService static void SendSimpleEmailNotification(  
                                                     string[] pEmail,
                                                     string pSubject,
                                                     string pEmailBody
                                                  ) 
                                                     {
                                                        
                                                            integer errLoc=0;
                                                            try
                                                            {
                                                                        
                                                                        //create a mail object to send a single email.
                                                                        errLoc = 10;
                                                                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                                        errLoc = 20;
                                                                        mail.setToAddresses(pEmail);
                                                                        errLoc = 60;
                                                                        mail.setUseSignature(false);
                                                                        errLoc = 70;
                                                                        mail.setSubject(pSubject);
                                                                        errLoc = 80;        
                                                                        mail.setHtmlBody(pEmailBody);
                                                                        
                                                                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
                                                                        
                                                            }
                                                            catch (Exception e) 
                                                            {
                                                            System.Debug(e.getMessage());
                                                            utilClass.createErrorLog
                                                                                     (
                                                                                     'sendEmail',
                                                                                     'SendSimpleEmailNotification',
                                                                                     'errLoc - ' + errLoc + ' - ' + pEmail[0] + ' - ' + e.getMessage()
                                                                                     );
                                                            }                                       
                                
                                                     }
                                                        
                                                        
 WebService static void SendEmailNotification(        string pEmail,
                                                     string[] pKeyword,
                                                     string pSubject,
                                                     string pEmailBody,
                                                     string pDisplayName,
                                                     string pReplyTo,
                                                     string pFolderId,
                                                     string pCategory,
                                                     string pUseCommonMailId
                                                     ) 
        {
            //string retStr  = '';
            integer errLoc=0;
            try
            {
                        
                        //create a mail object to send a single email.
                        errLoc = 10;
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                         //System.assert(pEmail !=null);
                    
                        //set the email properties
                        errLoc = 20;
                        mail.setToAddresses(new string[] {pEmail});
                        
                        if(pUseCommonMailId != null )
                        {
                            //System.Debug('1. pUseCommonMailId = '+pUseCommonMailId);
                            errLoc = 30;
                            mail.setOrgWideEmailAddressId(pUseCommonMailId);
                        }
                        else
                        {
                                if(pDisplayName != null)
                                {
                                    //System.Debug('2. pDisplayName = '+pDisplayName);
                                    errLoc = 40;                                    
                                    mail.setSenderDisplayName(pDisplayName);
        
                                }
                                
                                if(pReplyTo!= null )
                                {
                                    //System.Debug('3. pReplyTo = '+pReplyTo);
                                    errLoc = 50;                                    
                                    mail.setReplyTo(pReplyTo);
                                }
                        
                        }
                        
                        errLoc = 60;
                        mail.setUseSignature(false);
                        
                        //System.Debug('4. pSubject = '+pSubject);
                        
                        //System.assert(pSubject == null);
                        
                        errLoc = 70;
                        mail.setSubject(pSubject);
                        
                        //System.Debug('5. pEmailBody = '+pEmailBody);      
                         
                         //System.assert(pEmailBody == null);
                        
                        errLoc = 80;        
                        mail.setHtmlBody(pEmailBody);
            

                        /****************************************************************************
                        CHECK IF ANY ATTACHMENT
                        ****************************************************************************/
                        if(pKeyword != null )
                        {
                                            //System.Debug('5. pKeyword = '+pKeyword);      
                                            string[] catList;
                                            errLoc = 90;
                                            if(pCategory == null)
                                            {
                                                errLoc = 100;
                                                
                                                pCategory = '%';

                                                catList[0] = 'NO CAT LIST';
                                            }
                                            else
                                            {
                                                    errLoc = 110;
                                                    catList = pCategory.split(';');
                                            }
                                            
                                            errLoc = 120;
                                            List<Document> objPDF = [Select body, name ,Type,Keywords,BodyLength   from Document where Keywords  IN :pKeyword AND FolderId  = :pFolderId AND (Description LIKE :pCategory OR Description IN :catList) ORDER BY Description];
                                           
                                            //System.assert(objPDF == null);
                                            
                                            integer totalfilecnt =0;
                                            integer sDocSize =0;
                                            
                                            errLoc = 130;


                                            
                                            for(integer i=0; i< objPDF.size();i++)
                                            {
                                                errLoc = 140;
                                                if((sDocSize + objPDF[i].BodyLength) <= 10485760)
                                                {
                                                    totalfilecnt++;
                                                    sDocSize += objPDF[i].BodyLength;
                                                }
                                            }
                                           
                                            errLoc = 150;
                                            Messaging.EmailFileAttachment[] objEmailAttachments = new Messaging.EmailFileAttachment[totalfilecnt];
                                            
                                            //System.assert(objEmailAttachments == null); 
                                            
                                            //System.Debug('5. objPDF.size = '+objPDF.size());
                                            sDocSize =0;
                                            integer j=0;
                                            
                                            for(integer i=0; i< objPDF.size();i++)
                                            {
                                                
                                                if((sDocSize + objPDF[i].BodyLength) <= 10485760)
                                                {
                                                    errLoc = 160;
                                                    
                                                    Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
                                                
                                                    objPDFAttachment.setBody(objPDF[i].Body);
                                                
                                                    errLoc = 170;
                                                    
                                                    objPDFAttachment.setFileName(objPDF[i].name + '.' + objPDF[i].Type);
                                              
                                                    objEmailAttachments[j] = objPDFAttachment;
                                                    j++;
                                                    sDocSize += objPDF[i].BodyLength;
                                                }
                                                
                                                                                        
                                            }
                                            
                                           // mail.setHtmlBody(pEmailBody+'=============='+sDocSize);
                                            
                                            
                                            //System.assert(objEmailAttachments == null);
                                            errLoc = 180;
                                            mail.setFileAttachments(objEmailAttachments);
            
                                            /****************************************************************************
                                            SEND EMAIL NOW
                                            ****************************************************************************/
                                            
                                            if(objEmailAttachments!=null && objEmailAttachments.size()>0) 
                                            {
                                                errLoc = 190;
                                                //System.Debug('SENDING EMAIL NOW AT LOCATION ONE');
                                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
                                            }
                            
                        }
                        
            
                    if(pKeyword == null )
                    {
                    /****************************************************************************
                    SEND EMAIL NOW
                    ****************************************************************************/
                    errLoc = 200;
                        //System.Debug('SENDING EMAIL NOW AT LOCATION TWO');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
                    }
                    
                    
            }
            catch (Exception e) {
                                    System.Debug(e.getMessage());
                                    utilClass.createErrorLog
                                                             (
                                                             'sendEmail',
                                                             'SendEmailNotification',
                                                             'errLoc - ' + errLoc + ' - ' + pEmail + ' - ' + e.getMessage()
                                                             );                                     
                                
            }
            

        }                                                       

        
        
        }