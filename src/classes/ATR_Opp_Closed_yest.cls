global class ATR_Opp_Closed_yest implements Schedulable {
    global void execute(SchedulableContext SC){
        List<Opportunity> Opp_closed_yest = new List<Opportunity>();
        List<ID> lids = new List<ID>();
        EmailTemplate emailTemplate; 
        Date yest=System.today()-1;
List<Opportunity> Opps=[Select Id,SBU__c,StageName,CloseDate,Name,Description,Opportunity_Number__c, owner.name
from Opportunity where SBU__c=:'ATR' and ATR_Actual_Close_Date__c=:yest and ATR_Proposal_Type__c =:'AGMT' and StageName=:'Closed Won'];
          for(integer i=0;i<Opps.size();i++)
        {
        lids.add(Opps[i].Id);
        }
       
        List<attachment> objPDF = [Select body, name,parentid from attachment where parentID in :lids order by createdDate desc];
        //get the values from 'User__c' field in custom settings
        List<User__c> recipients=User__c.getall().values(); 
        System.Debug('RecipientsEmail'+recipients[0].Email__c);        
        List<attachment> lstobjPDF;
        Messaging.SingleEmailMessage mail ;
        String[] toAddresses = new String[]{};
        for(Integer i=0;i<recipients.size();i++)
            toAddresses.add(recipients[i].email__c);
        System.debug('ToAddresses'+toaddresses);
       // User usrId=[Select id,email from User where email=:recipients[0].email__c];
        string conid = '0033000000jWPCo';
       // System.debug('UsrId'+usrId.id);
                
         if(Opps.size()==0)
        {
           emailTemplate = [Select Id,Body,Name,Subject from EmailTemplate where name='ATR Opp closed yesterday_null'];
            mail =  new Messaging.SingleEmailMessage();
           
            mail.setTemplateId(emailTemplate.id);
            mail.setTargetObjectId(conid);
            mail.setSaveAsActivity(false);
            mail.setToAddresses(toAddresses);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
       // System.debug('!!!'+emailTemplate.body);
 
              integer flag = 0;
              for(integer i=0;i<Opps.size();i++)
              {
              mail =  new Messaging.SingleEmailMessage();
              lstobjPDF = new List<attachment>();
mail.setHTMLBody('<div style="font-family:Arial;font-size:14;"><p><b>This opportunity has been recorded as a Honeywell WIN!</b><br/><br/><b>Opportunity Number : <a href=https://' + System.URL.getSalesforceBaseUrl().getHost() + '/'+opps[i].Id+'>'+ opps[i].Opportunity_Number__c + '</a> </b><br/><b>Opportunity Name :' + opps[i].Name + '</b></br><br/><b>The attached Agreement is provided to you for performing site flow down.</b></br>Should you have any questions or require additional information please contact <b>Opportunity Owner '+ opps[i].Owner.name + '</b>.</p><br/>Thank you!<br/>ATR Sales<br/><br/><br/></div><footer><div style="font-family:Arial;font-size:12;"><center> HONEYWELL CONFIDENTIAL</center><center>This document and all information and expression contained herein are the property of Honeywell International Inc.,</br></center> <center>are provided in confidence, and may not, in whole or in part, be used, duplicated, or disclosed for any purpose</br></center> <center>without prior written permission of Honeywell International Inc. All rights reserved.</center></div></footer>');   
             mail.setTargetObjectId(conid);
             mail.setwhatid(opps[i].id);
            mail.setSaveAsActivity(true);
            mail.setToAddresses(toAddresses);
            mail.setsubject('Opportunity WIN Agreement Flowdown : Salesforce Workflow Email');
            System.debug('hiiiiiiiii'); 
            flag = 1;
               for(integer k=0;k<objPDF.size();k++)
                  {
                   if(Opps[i].Id == objPDF[k].parentID && flag == 1)
                   {
                   lstobjPDF.add(objPDF[k]);
                   flag=0;
                   }
                  }
                  if(lstobjPDF.size()>0)
                  {
            Messaging.EmailFileAttachment[] objEmailAttachments = new Messaging.EmailFileAttachment[1];
            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
            objPDFAttachment.setBody(lstobjPDF[0].Body);
            objPDFAttachment.setFileName(lstobjPDF[0].name);
            objEmailAttachments[0] = objPDFAttachment;
            mail.setFileAttachments(objEmailAttachments);
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                  }
           }  
      

    }