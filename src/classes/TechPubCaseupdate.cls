@RestResource(urlMapping='/TechPubCaseupdate/*')
global with sharing class TechPubCaseupdate {
    @HttpPost
    global static  List<case> TechPubCaseupdate(string CaseNumber,string Contract,string accountname,string invoiceamount,string paymentamount,string paymentdate,string techpubno) {
        system.debug('venkat11111--->'+CaseNumber);       
        string resolut='';
        string resolutionvalue='';      
        List<case> cas=[select id,Resolution__c,OwnerId__r.email,casenumber from case where casenumber=:CaseNumber limit 1];
        system.debug('casesize----'+cas);
        cas[0].status='Re-Open';
        system.debug('venkat33333--->'+cas[0].Resolution__c);    
        if(cas[0].Resolution__c!='' && cas[0].Resolution__c!= null)  {                
            resolut = cas[0].Resolution__c;                                   
        }        
        if(Contract !=null && Contract != '' )
        {
            if(resolut != null && resolut.contains(Contract))
            {
            //resolutionvalue+='Contract: '+Contract+'\n';
            }
            else{
                resolutionvalue+='Contract: '+Contract+'\n';
            }           
        }
        else
        {
            resolutionvalue+='Contract: \n';
        }
        if(accountname !=null && accountname != '')
        {
            if(resolut != null && resolut.contains(accountname))
            {
            //resolutionvalue+='Account Name: '+accountname+'\n'; 
            }
            else
            {
                resolutionvalue+='Account Name: '+accountname+'\n'; 
            }                              
        }
        else
        {
            resolutionvalue+='Account Name: \n'; 
        }
        if(String.isNotBlank(invoiceamount) )
        {
            if(resolut != null && resolut.contains(invoiceamount))
            {
                //resolutionvalue+='Invoice Amount: '+invoiceamount+'\n';
            }
            else
            {
                resolutionvalue+='Invoice Amount: '+invoiceamount+'\n';
            }       
        }
        else
        {
            resolutionvalue+='Invoice Amount: \n'; 
        }       
        if(paymentamount !=null && paymentamount != '')
        {
            if(resolut != null && resolut.contains(paymentamount))
            {
                //resolutionvalue+='Payment Amount: '+paymentamount+'\n';
            }
            else
            {
               resolutionvalue+='Payment Amount: '+paymentamount+'\n';
            }           
        }
        else
        {
            resolutionvalue+='Payment Amount: \n';
        }       
        if(paymentdate !=null && paymentdate != '')
        {
            if(resolut != null && resolut.contains(paymentdate))
            {
                //resolutionvalue+='Payment Date: '+paymentdate+'\n'; 
            }
            else
            {
               resolutionvalue+='Payment Date: '+paymentdate+'\n'; 
            }                              
        }
        else
        {
            resolutionvalue+='Payment Date: \n'; 
        }
        if(techpubno !=null && techpubno != '')
        {
            if(resolut != null && resolut.contains(paymentdate))
            {
                //resolutionvalue+='Tech Publication Number: '+techpubno;   
            }
            else
            {
               resolutionvalue+='Tech Publication Number: '+techpubno;   
            }                            
        }
        else
        {
            resolutionvalue+='Tech Publication Number: \n'; 
        }       
        system.debug('venkatest222--->'+resolut);       
        if(resolutionvalue != null && resolutionvalue != ''){
            cas[0].Resolution__c =resolut+resolutionvalue;
            if(Contract != null)
            {
                if(cas[0].Contract_Number__c != null && cas[0].Contract_Number__c.contains(Contract))
                {}
                else
                {
                   cas[0].Contract_Number__c =Contract; 
                } 
            }
            string htmlBody=''; 
            htmlBody ='The following HIPI Contract:&nbsp;'+Contract+'&nbsp;for Customer:&nbsp;'+accountname+'&nbsp;has been reopened for issuance of Technical Publication, refer to Case Number:&nbsp;'+CaseNumber;            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {cas[0].OwnerId__r.email};                      
            mail.setToAddresses(toAddresses);
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setSubject('Technical Publication has been processed by Corporate HIPI');
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });  
            update cas;             
        }           
        return cas; 
    }  
}