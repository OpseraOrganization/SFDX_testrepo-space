trigger APTS_resricttoDeleteApprovedAttachment on APTS_PDF_Attachment_Status__c (before delete,after delete,after insert,after update) {
    
   
    if(trigger.isdelete && trigger.isbefore)
    {
        set<id> cmId= new set<id>();
        set<id> invId= new set<id>();
        for(APTS_PDF_Attachment_Status__c objPAS: trigger.old)
        {
            if(objPAS.APTS_Invoice__c!=null)
                invId.add(objPAS.APTS_Invoice__c);
            else if(objPAS.APTS_Credit_Memo__c!=null)
                cmId.add(objPAS.APTS_Credit_Memo__c);
        }
        
        if(invId!=null && !invId.isempty())
        {
            Map<id,Apttus_Billing__Invoice__c> mapIdtoInv=new map<id,Apttus_Billing__Invoice__c>([select id,Apttus_Billing__Status__c from Apttus_Billing__Invoice__c where id in:invId]);
            if(mapIdtoInv!=null && !mapIdtoInv.isEmpty())
            {
                for(APTS_PDF_Attachment_Status__c objPAS: trigger.old)
                {
                        if(mapIdtoInv.get(objPAS.APTS_Invoice__c)!=null && mapIdtoInv.get(objPAS.APTS_Invoice__c).Apttus_Billing__Status__c =='Approved' && objPAS.APTS_Delete_Draft_Attachments__c==false)
                        objPAS.addError('You can not delete Approved document.');
                }
            }
        }
        
        if(cmId!=null && !cmId.isempty())
        {
            Map<id,Apttus_Billing__CreditMemo__c> mapIdtoCM= new map<id,Apttus_Billing__CreditMemo__c>([select id,Apttus_Billing__Status__c from Apttus_Billing__CreditMemo__c where id in:cmId]);
            if(mapIdtoCM!=null && !mapIdtoCM.isEmpty())
            {
                for(APTS_PDF_Attachment_Status__c objPAS: trigger.old)
                {
                    if(mapIdtoCM.get(objPAS.APTS_Credit_Memo__c)!=null && mapIdtoCM.get(objPAS.APTS_Credit_Memo__c).Apttus_Billing__Status__c =='Approved' && objPAS.APTS_Delete_Draft_Attachments__c==false)
                        objPAS.addError('You can not delete Approved document.');
                }
            }
        }
    } 
    
    if(trigger.isinsert && trigger.isafter)
    {
        set<id> cmId= new set<id>();
        set<id> invId= new set<id>();
        
        for(APTS_PDF_Attachment_Status__c objPAS: trigger.new)
        {
            if(objPAS.APTS_Invoice__c!=null && objPAS.APTS_Delete_Draft_Attachments__c==false)
                invId.add(objPAS.APTS_Invoice__c);
            else if(objPAS.APTS_Credit_Memo__c!=null && objPAS.APTS_Delete_Draft_Attachments__c==false)
                cmId.add(objPAS.APTS_Credit_Memo__c);
        }
        
        if(cmId!=null && !cmId.isempty())
        {
            //delete related draft attachments and integration status records
            List<APTS_PDF_Attachment_Status__c> lstCMtodelete=[select id,APTS_Credit_Memo__c,APTS_Credit_Memo__r.APTS_CMR_Number__c,APTS_Attachment_Id__c,APTS_Delete_Draft_Attachments__c from APTS_PDF_Attachment_Status__c where APTS_Credit_Memo__c in:cmId];
            List<APTS_PDF_Attachment_Status__c> lstCMtodelete1= new List<APTS_PDF_Attachment_Status__c>();
            set<id> attachTodelete = new set<id>();
            for(APTS_PDF_Attachment_Status__c obj:lstCMtodelete)
            {
                if(obj.APTS_Delete_Draft_Attachments__c==true && obj.APTS_Credit_Memo__r.APTS_CMR_Number__c!=null && obj.APTS_Credit_Memo__r.APTS_CMR_Number__c!='')
                {
                    lstCMtodelete1.add(obj);
                    attachTodelete.add(obj.APTS_Attachment_Id__c);
                }                
            }
            
            if(lstCMtodelete1!=null && !lstCMtodelete1.isEmpty())
                delete lstCMtodelete1;
            if(attachTodelete!=null && !attachTodelete.isEmpty())
            {
                list<attachment> lstatt=[select id from Attachment where id in:attachTodelete];
                if(lstatt!=null && !lstatt.isEmpty())
                    delete lstatt;
            }
        }
        
        if(invId!=null && !invId.isempty())
        {
            //delete related draft attachments and integration status records
            List<APTS_PDF_Attachment_Status__c> lstCMtodelete=[select id,APTS_Invoice__c,APTS_Invoice__r.APTS_Billing_Document_Number__c,APTS_Attachment_Id__c,APTS_Delete_Draft_Attachments__c from APTS_PDF_Attachment_Status__c where APTS_Invoice__c in:invId];
            List<APTS_PDF_Attachment_Status__c> lstCMtodelete1= new List<APTS_PDF_Attachment_Status__c>();
            set<id> attachTodelete = new set<id>();
            for(APTS_PDF_Attachment_Status__c obj:lstCMtodelete)
            {
                if(obj.APTS_Delete_Draft_Attachments__c==true && obj.APTS_Invoice__r.APTS_Billing_Document_Number__c!=null && obj.APTS_Invoice__r.APTS_Billing_Document_Number__c!='')
                {
                    lstCMtodelete1.add(obj);
                    attachTodelete.add(obj.APTS_Attachment_Id__c);
                }                
            }
            
            if(lstCMtodelete1!=null && !lstCMtodelete1.isEmpty())
                delete lstCMtodelete1;
            if(attachTodelete!=null && !attachTodelete.isEmpty())
            {
                list<attachment> lstatt=[select id from Attachment where id in:attachTodelete];
                if(lstatt!=null && !lstatt.isEmpty())
                    delete lstatt;
            }
        }
        
    }
    
     if((trigger.isinsert && trigger.isafter)){
        system.debug('trigger call sendinvoiceapproveemail');
                
        APTS_PDF_Attachment_Status_Helper.sendInvoiceemail(trigger.newmap,trigger.oldmap);
       
        system.debug('trigger end sendinvoiceapproveemail');
    }
}