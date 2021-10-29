/**********************************************************************************************
Name         : AgreementAttachmentOnContralistContrDS 
Created By   : Shanthi Akula
Company Name : NTT Data
Project      : Aero RDF
Created Date : 23-07-2019
Usages       : Trigger for creating a Case on creation and updation of a Docusign on contract
***********************************************************************************************/
trigger AgreementAttachmentOnContralistContrDS on dsfs__DocuSign_Status__c (after insert,after update) {
 
    List<Case> listCase = new List<Case>();   
    list<case> listCaseUpdte = new list<case>();
     list<case> lstCaseUpdate = new list<case>();
     List<Contract> listContract = new List<Contract>(); 
     set<id> setContractId = new set<id>();
     map<id,string> mapConCStatus = new map<id,string>();
      map<id,dsfs__DocuSign_Status__c> mapConDocuStatus = new map<id,dsfs__DocuSign_Status__c >();
      map<id,string> mapConCStatus1 = new map<id,string>();
     map<id,case> mapContractCases = new map<id,case>();
   Id caseRT = Schema.SObjectType.CASE.getRecordTypeInfosByDeveloperName().get('Serv_MSP_Contract_Case_Type').getRecordTypeId();
   String OwnerId = [SELECT Id FROM Group where Type='Queue' and DeveloperName = 'MSPContracts'].Id;
  Id AccountId ;
    
 if(trigger.isAfter){
      if(trigger.isinsert){
           set<Id> contractId = new set<ID>();
           list<Contract> lstContract = new list<Contract>();
            for(dsfs__DocuSign_Status__c objDS : trigger.new){  
                 contractId.add(objDS.dsfs__Contract__c);
             }
         
     
         if(contractId != null && contractId.size()>0){
             for(case objCase :   [select id,Sub_Status__c,Serv_Contract__c,AccountID from case where Serv_Contract__c = :contractId and recordtypeid =:caseRT]){
               
                 mapContractCases.put(objCase.Serv_Contract__c,objCase);
               
             
             }
             }
             
         for(dsfs__DocuSign_Status__c objDS : trigger.new){
            if( !mapContractCases.containsKey(objDS.dsfs__Contract__c)){
                 if(objDS.MSP_DocuSign_Status__c != ''){
                     system.debug('Before Insert Started :::::::::::');
         listContract = [Select id,Name,EndDate, Account__c, Contact__c, contact__r.name, Renewal_Order_Receipt_Name__c, MSP_PRODUCT_SERIAL_NUM__c from Contract where id =: objDS.dsfs__Contract__c];            
                        Case objCase = new case();
                     
                        objCase.REcordTypeId=caseRT;
                        objCase.type='MSP Renewal';
                        objCase.ownerid=OwnerId;
                        objCase.Status='Open';
                        objCase.Classification__c='MSP_Int';
                        objCase.origin='Web';
                        objCase.Serv_Contract__c = objDS.dsfs__Contract__c;
                        //updated subject, contract end date, account information for SCTASK2934993
                        objCase.Subject = 'MSP Renewal'+' '+listContract.get(0).Name+' '+listContract.get(0).MSP_PRODUCT_SERIAL_NUM__c;
                        objCase.Contract_End_Date__c = listContract.get(0).EndDate;
                        objCase.ContactId = listContract.get(0).Renewal_Order_Receipt_Name__c;
                        objCase.AccountId = listContract.get(0).Account__c;
                        System.debug('Account name: '+ AccountId);
                        //objCase.ContactId = listContract.get(0).Contact__c;
                       if(objDS.MSP_DocuSign_Status__c == 'Profile sent'){
                           
                       objCase.Sub_Status__c = 'Customer Profile Sent';
                     }
                     else if(objDS.MSP_DocuSign_Status__c == 'Profile Returned'){
                     objCase.Sub_Status__c='Customer Profile Returned - HON';
        }
        else if(objDS.MSP_DocuSign_Status__c == 'Contract Sent'){
            objCase.Sub_Status__c='Package sent to customer';
        }
         else if(objDS.MSP_DocuSign_Status__c == 'Contract Returned HON'){
            objCase.Sub_Status__c='Contract Returned HON';
        }
        else if(objDS.MSP_DocuSign_Status__c == 'Contract Returned'){
            objCase.Sub_Status__c='Renewal Complete';
        }
        listCase.add(objCase);
                   
            }
                        
            }
        
        else {
         
         for(dsfs__DocuSign_Status__c objDSExs : trigger.new){
              system.debug('After Insert Started :::::::::::'+mapContractCases.get(objDSExs.dsfs__Contract__c).AccountId);
                      //updated subject, contract end date, account information for SCTASK2934993
                      listContract = [Select id,Name,EndDate, Account__c, Contact__c, contact__r.name, Renewal_Order_Receipt_Name__c, MSP_PRODUCT_SERIAL_NUM__c from Contract where id =: objDSExs.dsfs__Contract__c];
                      mapContractCases.get(objDSExs.dsfs__Contract__c).Subject = 'MSP Renewal'+' '+listContract.get(0).Name+' '+listContract.get(0).MSP_PRODUCT_SERIAL_NUM__c;
                      mapContractCases.get(objDSExs.dsfs__Contract__c).Contract_End_Date__c = listContract.get(0).EndDate;
                      mapContractCases.get(objDSExs.dsfs__Contract__c).ContactId = listContract.get(0).Renewal_Order_Receipt_Name__c;
                      mapContractCases.get(objDSExs.dsfs__Contract__c).AccountId = listContract.get(0).Account__c;
                                      
                      if(objDSExs.MSP_DocuSign_Status__c == 'Profile sent'){
                        mapContractCases.get(objDSExs.dsfs__Contract__c).Sub_Status__c = 'Customer Profile Sent';
                     }
                     
                     else if(objDSExs.MSP_DocuSign_Status__c == 'Profile Returned'){
                       mapContractCases.get(objDSExs.dsfs__Contract__c).Sub_Status__c = 'Customer Profile Returned - HON';
                    
        }
        else if(objDS.MSP_DocuSign_Status__c == 'Contract Sent'){
           mapContractCases.get(objDS.dsfs__Contract__c).Sub_Status__c = 'Package sent to customer';
            
        }
        else if(objDS.MSP_DocuSign_Status__c  == 'Contract Returned HON'){
             mapContractCases.get(objDS.dsfs__Contract__c).Sub_Status__c ='Contract Returned HON';
        }
        else if(objDSExs.MSP_DocuSign_Status__c == 'Contract Returned'){
         mapContractCases.get(objDSExs.dsfs__Contract__c).Sub_Status__c = 'Renewal Complete';
            
        }
          lstCaseUpdate.add(mapContractCases.values());
              //  system.debug('After Insert Ended :::::::::::' +mapContractCases.get(objDSExs.dsfs__Contract__c).AccountId);
          }
        }
        }
        if(listCase != null && listCase.size() > 0){
               system.debug('Before Insert Ended :::::::::::'+listCase);
            insert listCase;
            system.debug('After Insert Ended :::::::::::' +listCase);
        }
        if(lstCaseUpdate != null && lstCaseUpdate.size() > 0){
            update lstCaseUpdate;
            
        }
          system.debug('After Insert Ended after :::::::::::' +listCase);
     }
     
     if(trigger.isupdate){
             for(dsfs__DocuSign_Status__c objDS : trigger.new){
                if((objDS.MSP_DocuSign_Status__c  != null && objDS.MSP_DocuSign_Status__c != trigger.oldmap.get(objDS.id).MSP_DocuSign_Status__c)){
                   setContractId.add(objDS.dsfs__Contract__c);
                   mapConCStatus.put(objDS.dsfs__Contract__c,objDS.MSP_DocuSign_Status__c);
                   mapConDocuStatus.put(objDS.dsfs__Contract__c,objDS);
                 //  mapConCStatus1.put(objDS.dsfs__Contract__c,objDS.dsfs__Subject__c);
             }
             }
             for(Case objCase1 : [select Id,subject,Sub_Status__c,Serv_Contract__c from case where Serv_Contract__c in :setContractId]){
             
            if(mapConDocuStatus.containsKey(objCase1.Serv_Contract__c)){
                 
                     if(mapConDocuStatus.get(objCase1.Serv_Contract__c).MSP_DocuSign_Status__c == 'Profile sent'){
                         
                       objCase1.Sub_Status__c = 'Customer Profile Sent';
                     }
                     else if(mapConDocuStatus.get(objCase1.Serv_Contract__c).MSP_DocuSign_Status__c == 'Profile Returned'){
                     objCase1.Sub_Status__c='Customer Profile Returned - HON';
        }
        else if(mapConDocuStatus.get(objCase1.Serv_Contract__c).MSP_DocuSign_Status__c == 'Contract Sent'){
            objCase1.Sub_Status__c='Package sent to customer';
        }
        else if(mapConDocuStatus.get(objCase1.Serv_Contract__c).MSP_DocuSign_Status__c == 'Contract Returned HON'){
            objCase1.Sub_Status__c='Contract Returned HON';
        }
        else if(mapConDocuStatus.get(objCase1.Serv_Contract__c).MSP_DocuSign_Status__c == 'Contract Returned'){
            objCase1.Sub_Status__c='Renewal Complete';
        }
            //updated subject, contract end date, account information for SCTASK2934993
            listContract = [Select id,Name,EndDate, Account__c, Contact__c, contact__r.name, Renewal_Order_Receipt_Name__c, MSP_PRODUCT_SERIAL_NUM__c from Contract where id =: mapConDocuStatus.get(objCase1.Serv_Contract__c).dsfs__Contract__c]; 
            objCase1.Subject = 'MSP Renewal'+' '+listContract.get(0).Name+' '+listContract.get(0).MSP_PRODUCT_SERIAL_NUM__c;
            objCase1.Contract_End_Date__c = listContract.get(0).EndDate;
            objCase1.ContactId = listContract.get(0).Renewal_Order_Receipt_Name__c;
            objCase1.AccountId = listContract.get(0).Account__c;
            }
            
            
                   listCaseUpdte.add(objCase1);
             }
            if(listCaseUpdte != null && listCaseUpdte.size() > 0){
            update listCaseUpdte;
        }
     }
     }
    }