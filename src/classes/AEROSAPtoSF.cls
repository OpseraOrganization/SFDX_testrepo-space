/***********************************************************************************************

Name      :    AEROSAPtoSF Class
Purpose   :    Apex soap webservice class, Processes Disputes coming from SAP
Last Modified By : Prachi Nakhate


History   :
------------------------------------------------------------------------------------------- 
VERSION         AUTHOR                          DATE             DETAIL 
1.0             TCS                         1/12/2019        

*******************************************************************************************/
global class AEROSAPtoSF {
    public static boolean triggerNotRunningFromAPI = true;
    
    webservice static CaseDataSFDCtoSap  CreateCase(CaseWrapper caseWrap) {
        System.debug(caseWrap);
        AEROSAPtoSF.triggerNotRunningFromAPI = false;
        Case SfdcCaseExists;
        List<InvoiceWrapper> NoSfdcCase = new List<InvoiceWrapper>();
        CaseDataSFDCtoSap result = new CaseDataSFDCtoSap();
        list<String> l_FSCM_ID = new list<String>();
        AeroCaseDataToSap sendDatatoSAP= new AeroCaseDataToSap();   
        
        If(caseWrap.invwrap.size()!= 0){
            List<InvoiceWrapper> invoicew = caseWrap.invwrap;
            List<String> sfdcIdList = new List<String>();
            Map<String,InvoiceWrapper> InvoiceMap = new Map<String,InvoiceWrapper>(); 
            for(InvoiceWrapper iw1: invoicew){
                if(string.isNotBlank(iw1.SFDCID)){
                    sfdcIdList.add(iw1.SFDCID);
                }
                else{
                    InvoiceMap.put(iw1.FSCM_Id,iw1);
                    
                }
                
            }
            
            if(sfdcIdList.size()!= 0){
                SfdcCaseExists = [SELECT  Id,status,Notes__c,CaseNumber,(select id from Invoices__r) From Case  where CaseNumber in :sfdcIdList];
            }
            if(InvoiceMap.size()!= 0){
                List<Invoices_for_fscmCase__c> existingInvoice = [Select Id,FSCM_ID__c,Parent_Case__c From Invoices_for_fscmCase__c Where FSCM_ID__c in :InvoiceMap.keySet()];
                if(existingInvoice.size()>0){
                    SfdcCaseExists = [Select Id, status,Notes__c,(select id from Invoices__r) from Case where Id=:existingInvoice[0].Parent_Case__c];
                    //SfdcCaseExists.add(SfCase);
                }
                else{
                    NoSfdcCase.addAll(InvoiceMap.values());
                }
            }
            
            
            
            
            /*for(InvoiceWrapper iw: invoicew){ 
//check if the sfdc id is available
if(string.isNotBlank(iw.SFDCID)){
Case SfCase = [Select Id, status from Case where Id=:iw.SFDCID];
SfdcCaseExists.add(SfCase);

}
else{
//check if the case existed for FSCm Id
List<Invoices_for_fscmCase__c> existingInvoice = [Select Id,FSCM_ID__c,Parent_Case__c From Invoices_for_fscmCase__c Where FSCM_ID__c =:iw.FSCM_Id LIMIT 1];
if(existingInvoice.size()>0){
Case SfCase = [Select Id, status from Case where Id=:existingInvoice[0].Parent_Case__c];
SfdcCaseExists.add(SfCase);
}
else{
NoSfdcCase.add(iw);
}
}
}*/
            
            try{
                if(SfdcCaseExists != Null){
                    
                    //check if SFDC Case is closed
                    if(SfdcCaseExists.status=='Closed'){
                        //check if info has reopen marker
                        try{
                            if(caseWrap.ReOpenCheck== True){
                                //reopen the existing Sfdc Case
                                SfdcCaseExists.status='Re-Open';
                                update SfdcCaseExists;
                                result.sfdcCaseId = Null;
                                result.message='Success';
                                
                            }
                        }
                        catch(exception e){
                            Error_log_fscm__c logErrorObject = new Error_log_fscm__c();
                            logErrorObject.Error_message__c=e.getMessage()+ ' ' + e.getStackTraceString();
                            System.debug(e.getMessage()+ ' ' + e.getStackTraceString());
                            insert logErrorObject;
                            result.sfdcCaseId = Null;
                            result.message='Fail';
                        }
                        
                    }
                    else{
                        //check the fscm case status in info
                        if(caseWrap.Status=='Closed' || caseWrap.Status=='Dispute Case Voided' || caseWrap.Status=='To Be Collected' ){
                            //check if multiple invoices are related to the sfdc case
                            
                            list<Invoices_for_fscmCase__c> FscInv = [select id, FSCM_Status__c,FSCM_ID__c,Parent_Case__c from Invoices_for_fscmCase__c where Parent_Case__c =:SfdcCaseExists.Id];
                            System.debug('FscInv'+FscInv);
                            if(FscInv.size()==1){
                                //close the case
                                FscInv[0].FSCM_Status__c = 'Closed';
                                SfdcCaseExists.Status = 'Closed';
                                update FscInv;
                                update SfdcCaseExists;
                                result.sfdcCaseId = Null;
                                result.message='Success';
                            }
                            else{
                                //check if all the fscm cases are closed
                                //update invToUpdate;
                                integer CaseClosed= 0;
                                integer CaseOpen=0;
                                for(Invoices_for_fscmCase__c inv :FscInv){
                                    if(inv.FSCM_ID__c==caseWrap.invwrap[0].FSCM_Id){
                                        inv.FSCM_Status__c= 'Closed';
                                        update inv;
                                    }
                                    if(inv.FSCM_Status__c == 'Closed'){
                                        CaseClosed++;
                                    }
                                    else{
                                        CaseOpen++;
                                    }
                                }
                                if(FscInv.size()==CaseClosed){
                                    //close the sfdc case
                                    SfdcCaseExists.Status = 'Closed';
                                    update SfdcCaseExists;
                                    
                                }
                                result.sfdcCaseId = Null;
                                result.message='Success';
                                
                            }
                            
                            
                        }
                        else{
                            //update notes on identified sfdc case
                            //string Nt = CsEx.Notes__c +'\n'+ caseWrap.Notes;
                            // CsEx.Notes__c = Nt;
                            
                            SfdcCaseExists.Notes__c += caseWrap.Notes;
                            update SfdcCaseExists;
                            result.sfdcCaseId = Null;
                            result.message='Success';
                        }
                    }
                }
                
                
                
            }
            catch (exception e){
                result.sfdcCaseId = Null;
                result.message='Fail';
                System.debug(e.getMessage()+ ' ' + e.getStackTraceString());
                Error_log_fscm__c logErrorObject = new Error_log_fscm__c();
                logErrorObject.Error_message__c=e.getMessage()+ ' ' + e.getStackTraceString();
                insert logErrorObject;
                
            }
            try{
                if(NoSfdcCase.size() != 0){  
                    //create new case as no case is available for FSCM Id
                    Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
                    Case Cs = New case();
                    cs.RecordTypeId= devRecordTypeId;
                    list<account> CRMacc = [select id,Name,Sbl_Account_Row_Id__c,Business_Focal__c,Business_Focal_EID__c from account where Sbl_Account_Row_Id__c=:caseWrap.CRM_ID limit 1];
                    If(CRMacc.size()!=0){
                        cs.Business_Focal__c = CRMacc[0].Business_Focal__c;
                        cs.Account_Name_web__c = CRMacc[0].Name;
                        //cs.CRM_Account__c = CRMacc[0].id;
                        //cs.ContactId = CRMacc[0].Business_Focal__c;
                        list<user> Bfocal = [select id,User_EID__c,IsActive from user where IsActive = true and User_EID__c=: CRMacc[0].Business_Focal_EID__c limit 1];
                        if(Bfocal.size()!=0){
                            cs.OwnerId = Bfocal[0].id;
                        }
                        else{
                            cs.OwnerId = Label.AERODEFAULTUSER;
                        }
                    }
                    else{
                        cs.OwnerId = Label.AERODEFAULTUSER;
                        //cs.ContactId = Label.FSCM_Contact;
                    }
                    
                    cs.Account_Number_web__c= caseWrap.CRM_ID;
                    cs.Status= 'New';
                    cs.Subject= casewrap.Subject;
                    cs.Customer_Sold_To__c= casewrap.SoldTo;
                    cs.Notes__c=caseWrap.Notes;
                    cs.Dollar_Amount__c=caseWrap.Dollar_Amounts;
                    cs.Origin = 'FSCM';
                    insert cs;
                    result.sfdcCaseId = cs.ID;
                    for(InvoiceWrapper iw: NoSfdcCase ){
                        l_FSCM_ID.add(iw.FSCM_Id);
                        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
                        inv.Parent_Case__c=cs.ID;
                        inv.FSCM_ID__c=iw.FSCM_Id;
                        inv.FSCM_Status__c= 'New';
                        inv.Disputed_Amount__c=iw.disputed_Amount;
                        inv.Invoice_Amount__c=iw.Invoice_Amount;
                        inv.Invoice_Number__c=iw.Invoice_Number;
                        inv.CurrencyIsoCode=iw.invoice_currency;
                        insert inv;
                        
                    }
                    case insertedSfdcCase = [select Id,CaseNumber from case where Id=: cs.ID];
                    result.message='Success';
                    string FscmId = string.Join(l_FSCM_ID,',');
                    sendDatatoSAP.FSCMId = FscmId;
                    sendDatatoSAP.CaseID = insertedSfdcCase.CaseNumber;
                    Map<String,Object> MapOfCaseWrap = new Map<String,Object>();
                    MapOfCaseWrap.put('CaseResult',sendDatatoSAP);
                    String json1 = JSON.serializePretty(MapOfCaseWrap);
                    AEROSfToSAPCallout.PostDataToSAP(json1);
                }
            }
            catch (exception e){
                //result.message='Fail';
                system.debug(e.getMessage());
                Error_log_fscm__c logErrorObject = new Error_log_fscm__c();
                logErrorObject.Error_message__c=e.getMessage();
                insert logErrorObject;
            }
            
        }
        
        
        else{
            Error_log_fscm__c logErrorObject = new Error_log_fscm__c();
            logErrorObject.Error_message__c='Case Wrapper is empty ';
            insert logErrorObject;
            result.sfdcCaseId = Null;
            result.message='No Case is found';
        }
        
        return result;
        
        
    }
    
    global class CaseDataSFDCtoSap{
        webservice string sfdcCaseId;
        webservice string message;
    }
    
    global class CaseWrapper{
        webservice String CRM_ID;
        webservice String Status;
        webservice String Subject;
        webservice String SoldTo;
        webservice String Notes;
        webservice Decimal Dollar_Amounts;
        webservice Boolean ReOpenCheck;
        webservice List<InvoiceWrapper> invwrap;
    }  
    global Class InvoiceWrapper{
        webservice String  FSCM_Id;
        webservice String Invoice_Number;
        webservice Decimal Invoice_Amount;
        webservice Decimal disputed_Amount;
        webservice String invoice_currency;
        webservice String SFDCID;
    }
}