/*
* Should send emails for approved or pending invoices,
* should update attachment id on corresponding invoice/credit memo 
*/
trigger APTS_OnAttachmentCreate on Attachment (before insert,after insert) {

       System.debug('Trigger is called');
    
    //Added by shiva to update the attachment Name
    List<Attachment> attachlist = new List<Attachment>();
    List<Apttus_Billing__Invoice__c> invoiceListNew = new List<Apttus_Billing__Invoice__c>();
    List<Apttus_Billing__CreditMemo__c> creditmemoListNew = new List<Apttus_Billing__CreditMemo__c>();
    List<ID> invoiceList =new List<ID>();
    set<ID> creditmemoSet =new set<ID>();
    if(Trigger.isbefore && trigger.isinsert)
    {
        attachlist = Trigger.New;
        //Getting the Invoice IDs to a list
        for(Attachment attachment : Trigger.new)
        {
            if(attachment.ParentId!=null && attachment.ParentId.getSObjectType().getDescribe().getName()=='Apttus_Billing__Invoice__c')
                invoiceList.add(attachment.parentid);
            else if(attachment.ParentId!=null && attachment.ParentId.getSObjectType().getDescribe().getName()=='Apttus_Billing__CreditMemo__c')
                creditmemoSet.add(attachment.parentid);
        }
        
        if(invoiceList!=null && !invoiceList.isempty())
        {   
            /** Invoice Attachement name change to Ship To From Bill To Changed by Siva A
            invoiceListNew=[select id, name,APTS_SAP_Invoice_Number__c,Apttus_Billing__Status__c,Apttus_Billing__InvoiceDate__c,Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultInvoiceTemplate__c,Apttus_Billing__BillToAccountId__r.ICAO_Code__c from Apttus_Billing__Invoice__c where id in :invoiceList];*/
            invoiceListNew=[select id,APTS_Integration_Status__c,name,APTS_SAP_Invoice_Number__c,Apttus_Billing__Status__c,Price_List__c,Apttus_Billing__InvoiceDate__c,Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultInvoiceTemplate__c,Apttus_Billing__ShipToAccountId__r.ICAO_Code__c from Apttus_Billing__Invoice__c where id in :invoiceList];
        }
        
        if(creditmemoSet!=null && !creditmemoSet.isempty())
        {
            creditmemoListNew=[select id, name,APTS_Billing_Document_Number__c,Apttus_Billing__Status__c,Apttus_Billing__CreditMemoDate__c,Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c,Apttus_Billing__BillToAccountId__r.ICAO_Code__c from Apttus_Billing__CreditMemo__c where id in :creditmemoSet];
        }
        
        if(invoiceListNew!=null && !invoiceListNew.isEmpty())
        {
            for(Attachment objAtt:Trigger.New)
            {
                for(Apttus_Billing__Invoice__c objInv:invoiceListNew)
                {
                      IF((objInv.Price_List__c == 'Aspire PriceList' || objInv.Price_List__c == 'Aspire PriceList_SAPOrders'))
                    {
                        if(objAtt.parentid==objInv.id && objInv.Apttus_Billing__Status__c=='Approved' && objInv.APTS_Integration_Status__c =='Completed')
                         {
                        if(objInv.APTS_SAP_Invoice_Number__c !=null && objInv.APTS_SAP_Invoice_Number__c!='')
                            
                            objAtt.Name='INV-'+objInv.APTS_SAP_Invoice_Number__c+'_'+'ASDS Invoice'+'_'+string.valueOf(objInv.Apttus_Billing__InvoiceDate__c.date())+'.pdf';
                       
                         }
                    }
                    Else 
                    {
                    if(objAtt.parentid==objInv.id && objInv.Apttus_Billing__Status__c=='Approved')
                    {
                        if(objInv.APTS_SAP_Invoice_Number__c!=null && objInv.APTS_SAP_Invoice_Number__c!='')
                            //objAtt.Name='INV-'+objInv.APTS_SAP_Invoice_Number__c+'_'+'FE Invoice'+'_'+objInv.Apttus_Billing__BillToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__InvoiceDate__c.date())+'.pdf';
                            objAtt.Name='INV-'+objInv.APTS_SAP_Invoice_Number__c+'_'+'FE Invoice'+'_'+objInv.Apttus_Billing__ShipToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__InvoiceDate__c.date())+'.pdf';
                        else
                            //objAtt.Name='INV-'+'FE Invoice'+'_'+objInv.Apttus_Billing__BillToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__InvoiceDate__c.date())+'.pdf';
                            objAtt.Name='INV-'+'FE Invoice'+'_'+objInv.Apttus_Billing__ShipToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__InvoiceDate__c.date())+'.pdf';
                    }
                    else if(objAtt.parentid==objInv.id && (objInv.Apttus_Billing__Status__c=='Draft'|| objInv.Apttus_Billing__Status__c=='Submitted'))
                    {
                        //objAtt.Name='INV-'+'Draft'+'_'+'FE Invoice'+'_'+objInv.Apttus_Billing__BillToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__InvoiceDate__c.date())+'.pdf';
                        objAtt.Name='INV-'+'Draft'+'_'+'FE Invoice'+'_'+objInv.Apttus_Billing__ShipToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__InvoiceDate__c.date())+'.pdf';
                    }
                   }
                }
            }
        } 
        
        if(creditmemoListNew!=null && !creditmemoListNew.isEmpty())
        {
            for(Attachment objAtt:Trigger.New)
            {
                for(Apttus_Billing__CreditMemo__c objInv:creditmemoListNew)
                {
                    if(objAtt.parentid==objInv.id && objInv.Apttus_Billing__Status__c=='Approved')
                    {
                        if(objInv.APTS_Billing_Document_Number__c!=null && objInv.APTS_Billing_Document_Number__c!='')
                            objAtt.Name='CM-'+objInv.APTS_Billing_Document_Number__c+'_'+'FE Credit Memo'+'_'+objInv.Apttus_Billing__BillToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__CreditMemoDate__c)+'.pdf';
                        else
                            objAtt.Name='CM-'+'FE Credit Memo'+'_'+objInv.Apttus_Billing__BillToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__CreditMemoDate__c)+'.pdf';
                    }
                    else if(objAtt.parentid==objInv.id && (objInv.Apttus_Billing__Status__c=='Draft' || objInv.Apttus_Billing__Status__c=='Submitted'))
                    {
                        objAtt.Name='CM-'+'Draft'+'_'+'FE Credit Memo'+'_'+objInv.Apttus_Billing__BillToAccountId__r.ICAO_Code__c+'_'+string.valueOf(objInv.Apttus_Billing__CreditMemoDate__c)+'.pdf';
                    }
                }
            }
        } 
        
        
    }    
    //end code:shiva
    
    if(Trigger.isafter && trigger.isinsert)
    {
        List<Id> invoiceMailList = new List<Id>();
        List<Id> invoiceMailListApttus = new List<Id>();
        set<id> setInvoiceid= new set<id>();
        set<id> setCMid= new set<id>();
        for (Attachment attachment : Trigger.new) 
        {
            if(attachment.ParentId!=null && attachment.ParentId.getSObjectType().getDescribe().getName()=='Apttus_Billing__Invoice__c')
                setInvoiceid.add(attachment.ParentId);
            if(attachment.ParentId!=null && attachment.ParentId.getSObjectType().getDescribe().getName()=='Apttus_Billing__CreditMemo__c')
                setCMid.add(attachment.ParentId);
                //apttus test
             invoiceMailListApttus.add(attachment.ParentId);

        }
        
        //Apttus
        
        System.debug('parent size '+ invoiceMailListApttus);
        //database.executeBatch(new Apttus_Billing.InvoiceEmailDeliveryJob(invoiceMailListApttus), 10);

        //Apttus
        
        if(setInvoiceid!=null && !setInvoiceid.isEmpty())
        {
            list<Apttus_Billing__Invoice__c> lstInv=[Select Id,APTS_Billing_Document_Number__c, Apttus_Billing__Status__c,Price_List__c,Apttus_Billing__DeliveryStatus__c,APTS_Original_Printed__c,APTS_Draft_AttachmentId__c, Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c, APTS_LatestAttachmentId__c,APTS_Integration_Status__c from Apttus_Billing__Invoice__c WHERE Id In :setInvoiceid];
            List<APTS_PDF_Attachment_Status__c> lstNewRec= new list<APTS_PDF_Attachment_Status__c>();
            if(lstInv!=null && !lstInv.isEmpty())
            {
                for(Attachment attachment : Trigger.new)
                {
                    for(Apttus_Billing__Invoice__c objInv:lstInv)
                    {
                    //Apttus test start
                      invoiceMailListApttus.add(objInv.Id);
                      system.debug('List size without condition' + invoiceMailListApttus.Size());
                      
                      
                    //Apttus Test end  
                        if(attachment.ParentId==objInv.Id)
                        {   
                            APTS_PDF_Attachment_Status__c objAS = new APTS_PDF_Attachment_Status__c();
                            if((objInv.Apttus_Billing__Status__c == 'Draft' || objInv.Apttus_Billing__Status__c == 'Submitted')&&(objInv.Price_List__c != 'Aspire PriceList' || objInv.Price_List__c != 'Aspire PriceList_SAPOrders'))
                            {
                                //objInv.APTS_Draft_AttachmentId__c = attachment.Id;
                                objAS.APTS_Attachment_Id__c=attachment.Id;
                                objAS.APTS_Attachment_Title__c=attachment.Name;
                                objAS.Created_By__c=attachment.CreatedById;
                                objAS.Last_Modified__c=attachment.LastModifiedDate;    
                                objAS.APTS_Invoice__c=objInv.Id;
                                if(objInv.Apttus_Billing__Status__c == 'Draft')
                                    objAS.APTS_Invoice_Status__c='Draft';
                                if(objInv.Apttus_Billing__Status__c == 'Submitted')
                                    objAS.APTS_Invoice_Status__c='Submitted';
                                objAS.APTS_Delete_Draft_Attachments__c=true;
                                lstNewRec.add(objAS);
                            }
                            else if(objInv.Apttus_Billing__Status__c == 'Approved' && (objInv.Price_List__c == 'Aspire PriceList' || objInv.Price_List__c == 'Aspire PriceList_SAPOrders') && objInv.APTS_Integration_Status__c =='Completed')
                            {
                                objInv.APTS_LatestAttachmentId__c = attachment.Id;
                                objInv.APTS_Original_Printed__c = true;
                                //creating attachment sttaus record for tracking
                                objAS.APTS_Attachment_Id__c=attachment.Id;
                                objAs.Price_List_Name__c = objInv.Price_List__c;
                                objAS.APTS_Attachment_Title__c=attachment.Name;
                                objAS.Created_By__c=attachment.CreatedById;
                                objAS.Last_Modified__c=attachment.LastModifiedDate;    
                                objAS.APTS_Invoice__c=objInv.Id;
                                objAS.APTS_Status__c='To be Processed';
                                objAS.APTS_Integration_Requested__c=system.now();
                                objAS.APTS_Delete_Draft_Attachments__c=false;
                                objAS.APTS_Invoice_Status__c='Approved';
                                objAS.APTS_INV_Billing_Document_Number__c=objInv.APTS_Billing_Document_Number__c;
                                lstNewRec.add(objAS);
                            }
                            else if(objInv.Apttus_Billing__Status__c == 'Approved' && (objInv.Price_List__c != 'Aspire PriceList' || objInv.Price_List__c != 'Aspire PriceList_SAPOrders'))
                            {
                                objInv.APTS_LatestAttachmentId__c = attachment.Id;
                                objInv.APTS_Original_Printed__c = true;
                                //creating attachment sttaus record for tracking
                                objAS.APTS_Attachment_Id__c=attachment.Id;
                                objAS.APTS_Attachment_Title__c=attachment.Name;
                                objAS.Created_By__c=attachment.CreatedById;
                                objAS.Last_Modified__c=attachment.LastModifiedDate;    
                                objAS.APTS_Invoice__c=objInv.Id;
                                objAS.APTS_Status__c='To be Processed';
                                objAS.APTS_Integration_Requested__c=system.now();
                                objAS.APTS_Delete_Draft_Attachments__c=false;
                                objAS.APTS_Invoice_Status__c='Approved';
                                objAS.APTS_INV_Billing_Document_Number__c=objInv.APTS_Billing_Document_Number__c;
                                lstNewRec.add(objAS);
                            }
                            
                               System.debug(objInv.Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c);
                               System.debug('pricelist'+objInv.Price_List__c);
                               
                            if((objInv.Apttus_Billing__Status__c == 'Approved' && objInv.Apttus_Billing__DeliveryStatus__c == 'Pending') &&
                               objInv.Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c != null && (objInv.Price_List__c != 'Aspire PriceList' || objInv.Price_List__c != 'Aspire PriceList_SAPOrders')) 
                               {
                               System.debug(objInv.Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c);
                               System.debug('pricelist'+objInv.Price_List__c);
                                   invoiceMailList.add(objInv.Id);

                            }
                        }
                    }
                }
                
                
                if(lstNewRec!=null && !lstNewRec.isEmpty())
                    insert lstNewRec;
                if(lstInv!=null && !lstInv.isEmpty())
                    update lstInv;
                
            }
        }
        
        if(setCMid!=null && !setCMid.isEmpty())
        {
            list<Apttus_Billing__CreditMemo__c> lstCM=[Select Id,APTS_Billing_Document_Number__c,Apttus_Billing__Status__c, APTS_LatestAttachmentId__c from Apttus_Billing__CreditMemo__c WHERE Id In :setCMid];
            List<APTS_PDF_Attachment_Status__c> lstNewRec= new list<APTS_PDF_Attachment_Status__c>();
            if(lstCM!=null && !lstCM.isEmpty())
            {
                for(Attachment attachment : Trigger.new)
                {
                    for(Apttus_Billing__CreditMemo__c objCM:lstCM)
                    {
                        if(attachment.ParentId==objCM.Id)
                        {
                            APTS_PDF_Attachment_Status__c objAS = new APTS_PDF_Attachment_Status__c();
                            if(objCM.Apttus_Billing__Status__c == 'Draft'|| objCM.Apttus_Billing__Status__c == 'Submitted')
                            {
                                //objCM.APTS_Draft_AttachmentId__c = attachment.Id;
                                objAS.APTS_Attachment_Id__c=attachment.Id;
                                objAS.APTS_Attachment_Title__c=attachment.Name;
                                objAS.Created_By__c=attachment.CreatedById;
                                objAS.Last_Modified__c=attachment.LastModifiedDate;    
                                objAS.APTS_Credit_Memo__c=objCM.Id;
                                objAS.APTS_Delete_Draft_Attachments__c=true;
                                if(objCM.Apttus_Billing__Status__c == 'Draft')
                                    objAS.APTS_Credit_Memo_Status__c='Draft';
                                if(objCM.Apttus_Billing__Status__c == 'Submitted')
                                    objAS.APTS_Credit_Memo_Status__c='Submitted';
                                lstNewRec.add(objAS);
                            }
                            else if(objCM.Apttus_Billing__Status__c == 'Approved')
                            {
                                objCM.APTS_LatestAttachmentId__c = attachment.Id;
                                objCM.APTS_Original_Printed__c = true;
                                //creating attachment sttaus record for tracking
                                objAS.APTS_Attachment_Id__c=attachment.Id;
                                objAS.APTS_Attachment_Title__c=attachment.Name;
                                objAS.Created_By__c=attachment.CreatedById;
                                objAS.Last_Modified__c=attachment.LastModifiedDate;    
                                objAS.APTS_Credit_Memo__c=objCM.Id;
                                objAS.APTS_Status__c='To be Processed';
                                objAS.APTS_Integration_Requested__c=system.now();
                                objAS.APTS_CM_Billing_Document_Number__c=objCM.APTS_Billing_Document_Number__c;
                                objAS.APTS_Delete_Draft_Attachments__c=false;
                                objAS.APTS_Credit_Memo_Status__c='Approved';
                                lstNewRec.add(objAS);
                            }
                        }
                    }
                }
                if(lstNewRec!=null && !lstNewRec.isEmpty())
                    insert lstNewRec;
                if(lstCM!=null && !lstCM.isEmpty())
                    update lstCM;              
            }
        }
        if (invoiceMailList.size() > 0) {
            system.debug('List size hw test' + invoiceMailList.Size());

            //commented by shiva, to tpdate the attachment Name with SAP invoice number and send the same as an attchment with email-which is not possible in Apttus code
            database.executeBatch(new Apttus_Billing.InvoiceEmailDeliveryJob(invoiceMailList), 10);
            //batch class to send invoice email to customers
            //database.executeBatch(new APTS_sendInvoiceToCustomer(invoiceMailList), 10);
        }
    }
}