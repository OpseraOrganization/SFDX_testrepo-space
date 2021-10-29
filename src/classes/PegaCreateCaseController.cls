global class PegaCreateCaseController {
    Webservice static string CreatePegaCase(Id pegaCaseId){
        system.debug('###Case '+pegaCaseId);
        String pegaId=null;
        PegaRequestWrapper pegaCreateCaseRequest=new PegaRequestWrapper();
        List<Case> caseList=new List<Case>();
        Case pega= new Case();
        Map<Id,User> groupMap=new Map<Id,User>([Select Id from user where Name='Pega']);
        pega=[SELECT Classification__c,RecordtypeId,CaseNumber,Additional_Web_Form_Info__c,Pega_Case_Id__c,Case_Ref_ID__c,Account_Name__c,Customer_Name__c,Customer_PO_RO_WONumber__c,Contact_Name__c,contact.Email,Customer_Request_Date__c,Honeywell_ID__c,Id,LastModifiedbyId,Owner.name,OwnerId,ParentId,Pega_Reason_for_Hold__c,Primary_Cell_Number__c,Primary_Email__c,Primary_Work_Number__c,Sales_Order_Number__c,SBU__c,Status,Part_Number__c,(SELECT FromAddress,Id,ParentId,Incoming,Status,Subject,TextBody,CCAddress,ToAddress,HtmlBody,hasAttachment,createdDate FROM EmailMessages where Incoming=true order by createdDate desc limit 1) FROM Case where id=:pegaCaseId];
        User toPega=[SELECT Id,name from User where Id=:pega.LastModifiedbyId];
        system.debug('Pega Case: '+pega);
        try{ 
            List<Id> EmailIds=new List<Id>();
            if(groupMap.containsKey(pega.ownerId) && pega.status!='Done'){
                for(EmailMessage email:pega.EmailMessages){
                    if(email.HasAttachment){
                        EmailIds.add(email.id); 
                    }
                }
                List<Attachment> allAttachments=new List<Attachment>();
                if(!emailIds.isEmpty()){
                    allAttachments=[Select id,Body,ContentType,Name,ParentId,BodyLength
                    from Attachment where ParentId=:EmailIds or ParentId=:pegaCaseId];
                }
                system.debug('allAttachmentssize'+allAttachments.size());
                system.debug('allAttachments'+allAttachments);
                Map<Id,List<Attachment>> attachMap=new Map<Id,List<Attachment>>();
                if(!allAttachments.isEmpty()){
                    for (Attachment a : allAttachments) {
                        if(a.BodyLength<=3200000){
                            if (attachMap.containsKey(a.parentId)) {
                                attachMap.get(a.parentId).add(a);
                            } else {
                                List<Attachment> mailList = new List<Attachment>();
                                mailList.add(a);
                                attachMap.put(a.parentId, mailList);
                            }
                        }
                    } 
                }
                System.debug('AttachMAP:'+attachMAP);
                //system.debug('Mail Content: '+pegaEmail);
                List<PegaRequestWrapper.CustomerEmail> customerEmailList=new List<PegaRequestWrapper.CustomerEmail>();
                pegaCreateCaseRequest.CaseNumber=pega.CaseNumber.subString(5);
                pegaCreateCaseRequest.CaseOwner=pega.Owner.Name;
                for(EmailMessage em:pega.EmailMessages){
                    PegaRequestWrapper.CustomerEmail customerEmail = new PegaRequestWrapper.CustomerEmail();
                    customerEmail.pyToString = em.ToAddress;
                    customerEmail.pyCCString= em.CcAddress;
                    customerEmail.pySubject=em.Subject;
                    customerEmail.pyFromUserID=em.FromAddress;
                    customerEmail.pyBody=em.HtmlBody; 
                    datetime strDT= em.CreatedDate;
                    string s = strDT.format('MMM dd, yyyy hh:mm:ss a');
                    customerEmail.pxSentDateTime=s;
                    List<PegaRequestWrapper.AttachmentList> ceAttach=new List<PegaRequestWrapper.AttachmentList>();
                    if(attachMap.get(em.id)!=null){      
                        List<Attachment> atList=attachMap.get(em.Parentid);// Modified for INC0000362303
                        for(Attachment a:atList){
                            PegaRequestWrapper.AttachmentList emAttach=new PegaRequestWrapper.AttachmentList();
                            emAttach.pxAttachName=a.Name;
                            emAttach.pyAttachStream=EncodingUtil.base64Encode(a.Body);
                            ceAttach.add(emAttach);
                        }
                    }
                    customerEmail.AttachmentList=ceAttach;
                    customerEmailList.add(customerEmail);
                }
                pegaCreateCaseRequest.customerEmail = customerEmailList;
                system.debug('PEga '+pegaCreateCaseRequest.caseowner);
                if(pega.Pega_Reason_for_Hold__c!=null){
                    pegaCreateCaseRequest.Casetype=pega.Pega_Reason_for_Hold__c;
                }
                else{
                    return Label.Pega_Reason_For_Hold_Message;
                }
                pegaCreateCaseRequest.CreatedBy=toPega.name;
                pegaCreateCaseRequest.CustContactName=pega.Contact_Name__c;
                pegaCreateCaseRequest.CustomerHoneywellID=pega.Part_Number__c;
                pegaCreateCaseRequest.Status=pega.Status;
                pegaCreateCaseRequest.CustomerPOROWONumber=pega.Customer_PO_RO_WONumber__c;
                if(pega.Contact.Email!=null){
                    pegaCreateCaseRequest.CustPrimaryEmail=pega.Contact.Email;      
                }
                else{
                    return Label.Pega_Customer_Email;
                }
                pegaCreateCaseRequest.CustPrimaryWorkNo=pega.Primary_Work_Number__c;
                if(pega.Sales_Order_Number__c!=null){
                    pegaCreateCaseRequest.CustomerSONumber=pega.Sales_Order_Number__c;
                }
                else{
                    return Label.Pega_Sales_Order_Number;
                }
                pegaCreateCaseRequest.WorkStream=pega.Classification__c;
                pegaCreateCaseRequest.AdditionalWebFormInfo=pega.Additional_Web_Form_Info__c; //  Added for INC0000157777
                pegaCreateCaseRequest.AccountSubType=pega.SBU__c;
                pegaCreateCaseRequest.CustomerName=pega.Account_Name__c;
                pegaCreateCaseRequest.SFDCCaseID=pega.Id;
                pegaCreateCaseRequest.CaseRefID=pega.Case_Ref_ID__c;
                pegaCreateCaseRequest.SFDCTransferID=Label.Pega_Transfer_Id;
                pegaCreateCaseRequest.CaseClosureID=Label.Pega_Closure_Id;
                String pegaRequestbody=JSON.serialize(pegaCreateCaseRequest);
                system.debug('Body: '+pegaRequestbody);

                HttpRequest req=new HttpRequest();
                req.setEndpoint(PegaService__c.getInstance('Endpoints').Create_Case__c);
                Blob headerValue = Blob.valueOf(PegaCredentials__c.getInstance('ServiceCredentials').Username__c + ':' + PegaCredentials__c.getInstance('ServiceCredentials').Password__c);
                String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type','application/json');
                req.setMethod('POST');
                req.setBody(pegaRequestbody);
                Http h=new Http();
                HttpResponse res=h.send(req);
                System.debug(res.getBody());
                JSONParser parser = JSON.createParser(res.getBody());
                If(res.getStatusCode()==200){
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Pega ID')) {
                            parser.nextToken();
                            pegaId = parser.getText();
                        }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'ErrorMessage')) {
                            parser.nextToken();
                            System.debug('Err: '+parser.getText());
                            String pegaErrMessage=parser.getText();
                            System.debug('@@Already'+pegaErrMessage);
                            if(pegaErrMessage.containsIgnoreCase('Already')){
                                pegaId=null;
                                System.debug('&&Enter already');
                                return Label.Pega_Case_Open_Already;
                            }
                        }
                        else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'ErrorMessage')) {
                            parser.nextToken();
                            pegaId=null;
                            String pegaErrMessage=parser.getText();
                            if(!pegaErrMessage.containsIgnoreCase('Already') && pegaErrMessage!='NA'){
                                System.debug('&&OtherException');
                                return Label.Pega_Exception_Message;
                            }
                        }
                    }
                    if(pegaId!=null){
                        if(pega.Pega_Case_ID__c==null){
                            pega.Pega_Case_Id__c=pegaId;
                        }
                        else{
                            pega.Pega_Case_Id__c=pega.Pega_Case_Id__c+','+pegaId;
                        }
                        caseList.add(pega);
                    }
                    else{
                        return Label.Pega_Exception_Message;   
                    }
                    if(!caseList.isEmpty()){
                        update caseList;
                    }
                }
                else if(res.getStatusCode()!=200){
                    return Label.Pega_Exception_Message;
                }
                return Label.Pega_Success_Case_Creation;
            }
            else{
                return Label.Pega_Case_Owner_Message;
            }
        }
        catch(Exception e){
            return Label.Pega_Exception_Message; 
        }
    }
}