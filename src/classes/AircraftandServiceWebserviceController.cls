/** * File Name: AircraftandServiceWebserviceController
* Description Rest Webservice class to fetch Fleet Asset Aircraft and Service Program details
* Copyright : ITC INFOTECH Limited Copyright (c) 2017
* * @author : ITC INFOTECH
Ver Date Author 1.0 09/03/2017
* */ 
@RestResource(urlMapping='/AerospaceAircraftandProgramServices/*')
global without sharing class AircraftandServiceWebserviceController{
    @HttpGet
    global static void getRecord() 
    {
        String honeywellNo = RestContext.request.params.get('honeywellid');
        //String accountname = RestContext.request.params.get('accountname');
        String requestType = RestContext.request.params.get('requestType');
        RestContext.response.addHeader('Content-Type', 'application/json');
        if(requestType!='' && requestType !=null)
        {
            if(requestType.equalsIgnoreCase('aircraft'))
            {
                if(honeywellNo !=null && honeywellNo !='')
                {
                    List<Contact> lstContact =  [SELECT Id,AccountId,Contact_Status__c  FROM Contact WHERE Honeywell_ID__c =: honeywellNo limit 1];
                    if(!lstContact.isEmpty())
                    {
                        if(lstContact[0].AccountId !=null)
                        {
                            if(lstContact[0].Contact_Status__c == 'Active')
                            {
                                List<Fleet_Asset_Detail__c> lstAircrafts = [Select Make__c,Model__c,Tail_Number__c,Serial_Number__c,Id,Name from Fleet_Asset_Detail__c where Account__c =: lstContact[0].AccountId limit 500];
                                list<AircraftRecord> aircraftResponseList = new list<AircraftRecord>();
                                for(Fleet_Asset_Detail__c airrec: lstAircrafts)
                                {
                                    AircraftRecord aircraftresponse = new AircraftRecord(airrec.Id,airrec.Make__c,airrec.Model__c,airrec.Tail_Number__c,airrec.Serial_Number__c);
                                    aircraftResponseList.add(aircraftresponse);
                                }
                                if(!aircraftResponseList.isEmpty())
                                {
                                    AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Success',null,aircraftResponseList.size(),aircraftResponseList);
                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
                                }
                                else
                                {
                                    AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','There are no Fleet Asset Aircrafts associated with the Account.',aircraftResponseList.size(),aircraftResponseList);
                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
                                }
                            }
                            else
                            {
                                 list<AircraftRecord> aircraftResponseList = new list<AircraftRecord>();
                                 AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Contact is inactive',0,aircraftResponseList);
                                 RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
                            }
                        }
                        else
                         {
                             list<AircraftRecord> aircraftResponseList = new list<AircraftRecord>();
                             AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','No Account associated with given contact',0,aircraftResponseList);
                             RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
                         
                         }
                     }
                     else
                     {
                         list<AircraftRecord> aircraftResponseList = new list<AircraftRecord>();
                         AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','There are no contacts for given ID. Please provide valid ID.',0,aircraftResponseList);
                         RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
                         
                     }
                 }
                 else
                 {
                     list<AircraftRecord> aircraftResponseList = new list<AircraftRecord>();
                     AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Honeywell Id cannot be blank. Please provide a valid ID.',0,aircraftResponseList);
                     RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
                 }
             }
             else if(requestType.equalsIgnoreCase('serviceprogram'))
             {
                 List<Master_Service_Program__c> lstServiceProgram = [Select Id,Name from Master_Service_Program__c limit 100];
                 List<ServiceProgramRecord> serviceresponseList = new  List<ServiceProgramRecord>();  
                 for(Master_Service_Program__c msp : lstServiceProgram)
                 {
                     ServiceProgramRecord   serviceresponse = new ServiceProgramRecord(msp.Name,msp.Id);
                     serviceresponseList.add(serviceresponse);
                 }
                 if(!serviceresponseList.isEmpty())
                 {
                     ServiceProgramRecordResponse serviceProgramRecordResponse = new ServiceProgramRecordResponse('Success', null, serviceresponseList.size(), serviceresponseList);
                     RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(serviceProgramRecordResponse));
                 }
                 else
                 {
                     ServiceProgramRecordResponse serviceProgramRecordResponse = new ServiceProgramRecordResponse('Failure', 'There are no Service programs.', 0, serviceresponseList);
                     RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(serviceProgramRecordResponse));
                 }    
             }
             else
             {
                 list<AircraftRecord> aircraftResponseList = new list<AircraftRecord>();
                 AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Request Type can be either aircraft or service program',0,aircraftResponseList);
                 RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
             }
           
             
         }
         else
         {
             list<AircraftRecord> aircraftResponseList = new list<AircraftRecord>();
             AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Request Type cannot be blank. Please provide a valid request type.',0,aircraftResponseList);
             RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
         }
         
    }
    
    //wrapper class to send response of Fleet Asset Aircraft List
    public class AircraftRecord   
    {
        //public String fleetAircraftName;
        public String fleetAircraftID;
        public String aircraftMake;
        public String aircraftModel;
        public string tailNumber;
        public String serialNumber;            
        
        public AircraftRecord(String ffleetAircraftID,String faircraftMake,String faircraftModel,string ftailNumber,String fserialNumber)
        {
            //fleetAircraftName = ffleetAircraftName;
            fleetAircraftID = ffleetAircraftID;
            aircraftMake = faircraftMake;
            aircraftModel = faircraftModel;
            tailNumber = ftailNumber;
            serialNumber = fserialNumber;
        }
    }
    
    //wrapper class to send response of Service Program List
    public class ServiceProgramRecord   
    {
        public String serviceProgramName;
        public String serviceProgramID;                    
        
        public ServiceProgramRecord(String sserviceProgramName,String sserviceProgramId)
        {
            serviceProgramName = sserviceProgramName;
            serviceProgramId = sserviceProgramId;
            
        }
    }
    
    public class AircraftRecordResponse
    {
        public String status;
        public String errorMessage;
        public Integer count;
        public List<AircraftRecord> recordList;
        
        public AircraftRecordResponse(String sstatus, String serrorMessage, Integer scount, List<AircraftRecord> saircraftRecords)
        {
            status = sstatus;
            errorMessage = serrorMessage;
            count = scount;
            recordList = saircraftRecords;
        }
        
    }
    public class ServiceProgramRecordResponse
    {
        public String status;
        public String errorMessage;
        public Integer count;
        public List<ServiceProgramRecord> recordList;
        
        public ServiceProgramRecordResponse(String sstatus, String serrorMessage, Integer scount, List<ServiceProgramRecord> sServiceProgramRecord)
        {
            status = sstatus;
            errorMessage = serrorMessage;
            count = scount;
            recordList = sServiceProgramRecord;
        }
        
    }
}