@RestResource(urlMapping='/AerospaceContractServices/*')
global without sharing class ContractWebServiceController {

  @HttpPost
  global static void queryAircraftInformation()
  {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        RestContext.response.addHeader('Content-Type', 'application/json');
        
        list<AircraftHeaders> contractNumberList = (list<AircraftHeaders>)JSON.deserialize(req.requestBody.toString(),list<AircraftHeaders>.class);            
        list<String> renewalList = new list<String>();
        list<case> renewalCaseList = new list<case>();
        list<contract> contracquerytList = new List<contract>();  
        list<String> contractRenewalList = new list<String>();
        list<String> contractList = new list<String>();
        list<Case> contractCase = new list<Case>();
        list<String> lstaircraftMake = new list<String>();
        list<String> lstaircraftModel = new list<String>();
        list<String> lstaircraftSerialNumber = new list<String>();
        for(AircraftHeaders ach: contractNumberList)
        {
            System.debug('====info type - '+ach.informtationType);
           if(ach.informtationType == 'aircraft')
           {
               contractList.add(ach.contract_Number);   
           }
           else if(ach.informtationType == 'count')
           {
               renewalList.add(ach.contract_Number); 
           }
           else if(ach.informtationType == 'contractRenewal')
           {
               contractRenewalList.add(ach.contract_Number); 
           }
           
        lstaircraftMake.add(ach.aircraftMake);
        lstaircraftModel.add(ach.aircraftModel);
        lstaircraftSerialNumber.add(ach.aircraftSerialNumber);
       }
       
       System.debug('JSON Data Make:'+lstaircraftMake);
       System.debug('JSON Data Model:'+ lstaircraftModel);
       System.debug('JSON Data Serial:'+lstaircraftSerialNumber);
         
      
      // For returning the Aircraft header information
      if(contractList.size()>0){ 
           system.debug('=== get aircraft info -- '+contractList.size());
          contracquerytList = [select SAP_Contract_Number__c,Type__c,Account.name,Aircraft__r.Make__c,Aircraft__r.Model__c,Aircraft__r.Serial_Number__c,status,EndDate,StartDate from contract where SAP_Contract_Number__c IN: contractList];
          system.debug('=== contract info fetched -- '+contracquerytList.size());
          list<AircraftHeaders> aircraftdetailList = new list<AircraftHeaders>();
          list<aircraftInformationHeader> aircraftNewdetailList = new list<aircraftInformationHeader>();
          ContractAircraftResponse contAirResponse;
          List<ContractAircraftResponse> contAirResponseList = new List<ContractAircraftResponse>();         
          try{     
                 for(contract cc: contracquerytList)
                 {
                     system.debug('Contract No from list - '+ cc.SAP_Contract_Number__c);
                      aircraftNewdetailList = new list<aircraftInformationHeader>();                                           
                      list<Entitlement__c> lstEntitlement = new list<Entitlement__c>();                                                                  
                      lstEntitlement = [Select id,name,Fleet_Asset_Aircraft__c,Fleet_Asset_Aircraft__r.Serial_Number__c,Fleet_Asset_Aircraft__r.Make__c,Fleet_Asset_Aircraft__r.Model__c ,Contract_Number__r.SAP_Contract_Number__c,Contract_Number__r.Type__c,Contract_Number__r.Account.name,Contract_Number__r.status,Contract_Number__r.EndDate,Contract_Number__r.StartDate from Entitlement__c  where  Contract_Number__c =: cc.id and Fleet_Asset_Aircraft__c!=null and Fleet_Asset_Aircraft__r.Serial_Number__c!=null order by Fleet_Asset_Aircraft__r.Make__c,Fleet_Asset_Aircraft__r.Model__c,Fleet_Asset_Aircraft__r.Serial_Number__c asc];
                     system.debug('Entiltemnet fetched for contract - '+lstEntitlement.size()); 
                     system.debug(lstEntitlement.size() > 0);
                     Set<Fleet_Asset_Detail__c> fleetAirDetail = new Set<Fleet_Asset_Detail__c>();
                     Set<Fleet_Asset_Detail__c> newFleetAirDetail = new Set<Fleet_Asset_Detail__c>();
                     if(lstEntitlement.size() != 0)
                     {
                         system.debug('lstEntitlement not zero');
                          for (Entitlement__c ent : lstEntitlement )
                              {
                               System.debug('List of aircraft'+ent.Fleet_Asset_Aircraft__r);
                               system.debug('forming fleetAirDetail list');
                               fleetAirDetail = new Set<Fleet_Asset_Detail__c>();
                               fleetAirDetail.add(ent.Fleet_Asset_Aircraft__r);
                               newFleetAirDetail.addAll(fleetAirDetail);
                               System.debug('newFleetAirDetail::'+newFleetAirDetail);
                              }
                     }
                     System.debug('::fleetAirDetail::'+newFleetAirDetail);
                     if(newFleetAirDetail.size() != 0){  
                          for(Fleet_Asset_Detail__c fad : newFleetAirDetail)
                              {
                                  system.debug('forming aircraftNewdetailList list');
                               aircraftInformationHeader aircraftNewDetail = new  aircraftInformationHeader(fad.Make__c,fad.Model__c,fad.Serial_Number__c);
                               aircraftNewdetailList.add(aircraftNewDetail);
                              }   
                     }
                     system.debug('aircraftNewdetailList.size() - '+aircraftNewdetailList.size());
                          if( aircraftNewdetailList.size()!=0)
                              {
                               system.debug('forming contAirResponseList ');                              
                               contAirResponse = new ContractAircraftResponse(cc.SAP_Contract_Number__c,aircraftNewdetailList);                               
                               system.debug('formed contAirResponse - '+contAirResponse);
                               contAirResponseList.add(contAirResponse);
                               
                              } 
                   }
              system.debug('final resp size - '+contAirResponseList.size());
                   RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(contAirResponseList));
             }
          catch (Exception e) 
            {
                    res.responseBody = Blob.valueOf(e.getMessage());
            }
         }       
      // For returning Renewal contracts Count
      if(renewalList.size()>0)
      {
         list<RecordType> recVal = [select id from RecordType where (Name ='HAPP MPP Contracts' or Name ='HAPP Contracts' or Name ='MPP Contracts')AND SObjectType = 'case'];
         integer renewalCount = 0;// [select COUNT() FROM case where (RecordTypeid=:recVal[0].id AND status ='Open') AND (type ='HAPP Renewal' OR type='MPP Renewal' OR type='HAPP-MPP Renewal' or type='HAPP MPP Contracts') AND (Sub_Status__c='1st Follow-up' OR Sub_Status__c='2nd Follow-up' OR Sub_Status__c='Final Notice Sent' OR Sub_Status__c='Package Sent – Customer' OR Sub_Status__c='Waiting for Dealer Response' OR Sub_Status__c='Waiting for Customer response' OR Sub_Status__c='Contract Returned – Awaiting PO') AND Contract_Number__c IN: renewalList];
         
         
          renewalCaseList = [select Contract_Number__c FROM case where (RecordTypeid=:recVal[0].id AND status ='Open') AND (type ='HAPP Renewal' OR type='MPP Renewal' OR type='HAPP-MPP Renewal' or type='HAPP MPP Contracts') AND (Sub_Status__c='1st Follow-up' OR Sub_Status__c='2nd Follow-up' OR Sub_Status__c='Final Notice Sent' OR Sub_Status__c='Package Sent – Customer' OR Sub_Status__c='Waiting for Dealer Response' OR Sub_Status__c='Waiting for Customer response' OR Sub_Status__c='Contract Returned – Awaiting PO') AND Contract_Number__c IN: contractRenewalList];
          system.debug('renewalCaseList -- '+renewalCaseList);
       
          ContractRenewalCount renewCount = new ContractRenewalCount(String.valueof(renewalCount));
         
          contractRenewalResponseAttachments renewalResponseAttach;
          boolean checkAttachmentUnsigned = true;
         list<contractRenewalResponseAttachments> lstRenewalResponseAttach = new list<contractRenewalResponseAttachments>();
         list<Attachment> lstattachment = new list<Attachment>();
          
          if(renewalCaseList.size() > 0){
              for(Case c : renewalCaseList){
              
               string inVar='unsigned.pdf';
               string tempInput = '%' + inVar + '%';
               lstattachment = [SELECT Id ,Name  FROM Attachment  as a where a.ParentId in (select Id FROM case where (status ='Open') AND (type ='HAPP Renewal' OR type='MPP Renewal' OR type='HAPP-MPP Renewal' or type='HAPP MPP Contracts') and Contract_Number__c =: c.Contract_Number__c) and Name like '%unsigned.pdf' limit 1 ];
                  
                System.debug('listAttachment'+lstattachment);
                if(lstattachment.size() > 0)
                {
                    //checkAttachmentUnsigned = false;
                    renewalCount = renewalCount+1;
                }
              }                   
        }
          RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(renewCount));
      }
       // For returning Renewal contracts 
      if(contractRenewalList.size()>0)
      {
         list<RecordType> recVal = [select id from RecordType where (Name ='HAPP MPP Contracts' or Name ='HAPP Contracts' or Name ='MPP Contracts')AND SObjectType = 'case'];
         system.debug('=== recVal -- '+recVal);
         system.debug('=== recVal -- '+recVal[0].id);
          system.debug('=== contractRenewalList -- '+contractRenewalList);
          renewalCaseList = [select Contract_Number__c FROM case where (RecordTypeid=:recVal[0].id AND status ='Open') AND (type ='HAPP Renewal' OR type='MPP Renewal' OR type='HAPP-MPP Renewal' or type='HAPP MPP Contracts') AND (Sub_Status__c='1st Follow-up' OR Sub_Status__c='2nd Follow-up' OR Sub_Status__c='Final Notice Sent' OR Sub_Status__c='Package Sent – Customer' OR Sub_Status__c='Waiting for Dealer Response' OR Sub_Status__c='Waiting for Customer response' OR Sub_Status__c='Contract Returned – Awaiting PO') AND Contract_Number__c IN: contractRenewalList];
          system.debug('renewalCaseList -- '+renewalCaseList);
        //  list<contractRenewalResponse> renewalResponse = new list<contractRenewalResponse>();
           String renewalContracts = '';
          contractRenewalResponse renewalResponse = new contractRenewalResponse(renewalContracts);
         
        //  list<String> renewalContracts = new list<String>();
          contractRenewalResponseAttachments renewalResponseAttach;
          boolean checkAttachmentUnsigned = true;
         list<contractRenewalResponseAttachments> lstRenewalResponseAttach = new list<contractRenewalResponseAttachments>();
         list<Attachment> lstattachment = new list<Attachment>();
          
          if(renewalCaseList.size() > 0){
              for(Case c : renewalCaseList){
               // renewalContracts.add(c.Contract_Number__c);
               string inVar='unsigned.pdf';
               string tempInput = '%' + inVar + '%';
               lstattachment = [SELECT Id ,Name  FROM Attachment  as a where a.ParentId in (select Id FROM case where (status ='Open') AND (type ='HAPP Renewal' OR type='MPP Renewal' OR type='HAPP-MPP Renewal' or type='HAPP MPP Contracts') and Contract_Number__c =: c.Contract_Number__c) and Name like '%unsigned.pdf' limit 1 ];
                  
              // lstattachment = [SELECT Id,ParentId From Attachment WHERE ParentId IN (SELECT Id FROM Contract WHERE SAP_Contract_Number__c =: c.Contract_Number__c) AND Name Like '%signed.pdf'];
               System.debug('listAttachment'+lstattachment);
                if(lstattachment.size() > 0)
                {
                    //checkAttachmentUnsigned = false;
                    renewalContracts = renewalContracts +c.Contract_Number__c + ',';
                      system.debug('inside if renewalContracts - '+renewalContracts);
                }
              //  renewalResponseAttach = new contractRenewalResponseAttachments(c.Contract_Number__c,checkAttachmentUnsigned);
               // lstRenewalResponseAttach.add(renewalResponseAttach);
              }    
              system.debug('renewalContracts - '+renewalContracts);
              renewalResponse = new contractRenewalResponse(renewalContracts);
          }
         RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(renewalResponse));
         
        // RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(lstRenewalResponseAttach));
      }
      
      
      // For Querying contract header information
          System.debug('check Null'+contractNumberList[0].aircraftMake);
          if(contractNumberList[0].aircraftMake!=null)
          {
          list<ContractHeaders> contractInfoList = new list<ContractHeaders>();
          list<Entitlement__c> lstEntitlement = new list<Entitlement__c>();  
          list<Fleet_Asset_Detail__c> lstEntAircraft = new list<Fleet_Asset_Detail__c>();  
          Set<Contract> newListCon = new Set<Contract>();
          Set<Entitlement__c> SetEntitlement = new Set<Entitlement__c>(); 
          Set<Contract> SetContractInfoList = new Set<Contract>();         
          list<Contract> lstCont  = new list<Contract>();  
          
          try{
                
                 
                 
                  lstEntAircraft = [Select id from Fleet_Asset_Detail__c where  Make__c =:contractNumberList[0].aircraftMake and   Model__c =: contractNumberList[0].aircraftModel and Serial_Number__c =: contractNumberList[0].aircraftSerialNumber];
                  lstEntitlement =  [Select  id,Entitlement_Contract_Name__c,Fleet_Asset_Aircraft__c FROM Entitlement__c where Fleet_Asset_Aircraft__c!=null and Entitlement_Type__c = 'Aircraft' and Fleet_Asset_Aircraft__c in :lstEntAircraft ];
                  
                   setEntitlement.addAll(lstEntitlement); 
                   Map<Id ,List<Contract>> mapConValues = new Map<Id ,List<Contract>>();
                  
                   for(Entitlement__c entcc : setEntitlement)
                   {    
                        
                        System.debug('entCont:'+entcc.Entitlement_Contract_Name__c);
                        lstCont = [Select EndDate,StartDate,Status,Type__c,Account__r.Name,SAP_Contract_Number__c,Aircraft__c,Aircraft__r.Serial_Number__c,Aircraft__r.Make__c,Aircraft__r.Model__c from contract where SAP_Contract_Number__c=:entcc.Entitlement_Contract_Name__c];              
                        newListCon.add(lstCont[0]);
                  
                   }  
                  for(Contract ccent : newListCon)
                   {
                                       
                     
                     ContractHeaders conDetails = new ContractHeaders(contractNumberList[0].aircraftMake,contractNumberList[0].aircraftSerialNumber,contractNumberList[0].aircraftModel,ccent.SAP_Contract_Number__c,ccent.Type__c,ccent.Account__r.Name,ccent.status,ccent.EndDate,ccent.StartDate);
                     contractInfoList.add(conDetails);
                     
                   }  
                    
                       
                    
                
                
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(contractInfoList));
               }
           catch (Exception e) 
              {
                res.responseBody = Blob.valueOf(e.getMessage());
              }
               
               
          }
   
   }

  

   
 public class AircraftHeaders   
   {
       public String aircraftMake;
       public string aircraftSerialNumber;
       public string aircraftModel;
       public String contract_Number;
       public String informtationType;     
       
       
       public AircraftHeaders(String make,String serialnumber,String model,String contractNumber){
           aircraftMake = make;
           aircraftSerialNumber = serialnumber;
           aircraftModel = model;
           contract_Number = contractNumber;
           informtationType = 'Aircraft Header Info';
       }
       
   }
   
   public class ContractRenewalCount {
       public String renewalCount;
       
       public ContractRenewalCount(String countVal){
           renewalCount = countVal;
       }
   }
   
   public Class ContractHeaders{
       public String aircraft_Make;
       public string aircraft_SerialNumber;
       public string aircraft_Model;
       public String contract_Number;
       public String programtype;
       public String operatorname;
       public String status;
       public String enddate;
       public String startdate;
       public String informtationType;    
       
       
       public ContractHeaders(String make,String serialnumber,String model,String contractNumber,String typevalue,String operator,String statusvalue,date enddatevalue, date startdatevalue)
       {
           aircraft_Make = make;
           aircraft_SerialNumber = serialnumber;
           aircraft_Model = model;
           contract_Number = contractNumber;
           informtationType = 'Contract Header Info';
           status = statusvalue;
           enddate = String.valueOf(enddatevalue);
           operatorname = operator;
           programtype = typevalue;
           startdate =  String.valueOf(startdatevalue);
       }
   }
   
   public class aircraftInformationHeader
   {
             
       public string aircraftSerialNumber;
       public String aircraftMake;
       public string aircraftModel; 
       
   public aircraftInformationHeader(String make,String model,String serialnumber)
       {
               aircraftMake= make;               
               aircraftModel= model;
               aircraftSerialNumber= serialnumber;
       } 
   }
   
   public class ContractAircraftResponse
   {
       String contract_Number;
       String informtationType;
       List<aircraftInformationHeader> aircraft;
   public  ContractAircraftResponse(String Ciar_contract_Number,List<aircraftInformationHeader> Ciar_aircraft)
       {
       contract_Number = Ciar_contract_Number;
       informtationType = 'Aircraft Header Info';
        aircraft = Ciar_aircraft;
       }
   }
  
    public class contractRenewalResponse{
        public String contracts;
       
        public contractRenewalResponse(String renewalContracts){
            contracts = renewalContracts;
           
        }
    }
  public class contractRenewalResponseAttachments{
  public String contracts;
  public Boolean isAttachmentUnsigned;
  public contractRenewalResponseAttachments(String renewalContracts,boolean checkAttachmentUnsigned)
      {
       contracts = renewalContracts;
       isAttachmentUnsigned= checkAttachmentUnsigned;
      }
  }
}