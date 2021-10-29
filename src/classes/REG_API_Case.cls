@RestResource(urlMapping = '/portal-case/*')
global with sharing class REG_API_Case {   
//URI: /portal-case/
//URI: /portal-case/picklist/{fieldname} 
    @httpPost
    global static void doPost(){
        REG_Result result=new REG_Result();
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=req.requestbody.toString();
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='POST';
        REG_Result.transactionId=req.headers.get('transactionId');
        String strURI=req.requestURI;
        String fieldname= '';
        CaseData jsonBody; 
        List<String> uriParts = strURI.split('/');
        Integer arrCount = uriParts.size();
        String body=req.requestbody.toString();
        try{
            REG_Result.api='Create Case';
            REG_Result.logTransaction();
            jsonBody = (CaseData) JSON.deserialize(body, CaseData.class);
            //system.debug(logginglevel.info,'jsonBody****' +jsonBody );
            //system.debug(logginglevel.info,'arrcount****' +arrcount );
            //system.debug(logginglevel.info,'uriParts[1] ****' +uriParts[1] );
            if(arrcount == 2 && uriParts[1] == 'portal-case'){
               result = REG_Case_Service.fncCreateCase(jsonBody);
              //  result = backup_reg_case_service.fncCreateCase(jsonBody);
                if(result.StatusCode == 200){
                    if(json.serialize(result.Data) != '[]'){
                        res.responseBody = Blob.valueOf(json.serialize(result.Data));
                    }else{res.statusCode = result.StatusCode; 
                        res.responseBody = Blob.valueOf(json.serialize(result.error));
                    }
                }
                else{res.statusCode = result.StatusCode;
                    res.responseBody = Blob.valueOf(json.serialize(result.error));
                }   
            } 
            else{result.handleError(400, 'Incorrect URI', 'URI should be /portal-case/'); 
           } 
        }
        catch(System.JSONException e){
            result.handleException(400, e.getMessage(), e);
            res.statusCode = result.StatusCode;
            res.responseBody =  Blob.valueOf(JSON.serialize(result.error));
        }catch(Exception e){
            result.handleException(500, e.getMessage(), e);
            res.statusCode = result.StatusCode;
            res.responseBody =  Blob.valueOf(JSON.serialize(result.error));
        }       
    }
    
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        REG_Result result = new REG_Result();
        res.addHeader('Content-Type', 'application/json');
        REG_Result.requestURI=req.requestURI;
        REG_Result.requestInputs=JSON.serialize(req.params);
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='GET';
        String fieldname= '';
        REG_Result.transactionId=req.headers.get('transactionId');
        try{
            REG_Result.api='Get Case Field Picklist Values';
            String strURI=req.requestURI;
            List<String> uriParts = strURI.split('/');
            Integer arrCount = uriParts.size();
            if(arrcount == 4 && uriParts[2] == 'picklist'){
                fieldname= strURI.substring(strURI.lastIndexOf('/')+1);
                result = REG_Case_Service.getCasePickListVlaues(fieldname);
                res.statusCode = result.StatusCode;
                res.responseBody =  Blob.valueOf(JSON.serialize(result.StatusCode==200?result.Data:result.error));
            }else{
                result.handleError(400, 'Incorrect URI', '<domain>/services/apexrest/portal-case/picklist/{fieldname}');
                res.statusCode = result.StatusCode;
                res.responseBody =  Blob.valueOf(JSON.serialize(result.error));
            }
        }
        catch(Exception e)
        { result.handleException(500, e.getMessage(), e); 
         res.statusCode = result.StatusCode; 
         res.responseBody =  Blob.valueOf(JSON.serialize(result.error));            
        }       
    }//doGet()
         
    global class CaseData{
        public string FormName;
        public string CaseNumber;
        public string EmailAddress;
        public string CaseSubject;
        public string SubClass;
        public string DetailClass;
        public string AdditionalWebFormInfo;
        public string Origin;
        public string OrderType;
        public string OrderStatusInfoRequested;
        public string ContactId;
        public string AccountId;
        public string PortalContactEmail;
        public string HoneywellID;
        public string Priority; 
        public string TYPE;  
        public String Classification;
        public string CUSTOMER_PO_RO_WO_NUM;
        public string Customer_PO_Number;
        public string SALES_ORDER_NUM;
        public string ExportCompliance;
        public string GovernmentCompliance;
        public string Status;     
        public string DESCRIPTION;    
        public string SUBJECT; 
        public string InvoiceNumber;
        public string Aircrafttype;
        public string AircraftSerialNumber;  
        public string ProductType;
        public string IntendedUse;
        public string EndUseforthisPartAssembly;
        public string EndUserAddress;
        public string HoneywellOrderNumber;    
        public string ChangeType;
        public string AdditionalAircraftInfo;
        public string PartNumber;
        public string AircraftTailNumber;
        public string TopLevelAssemblyPartNumber;
        public string TopLevelAssemblySerialNumber;
        public string DateofFailure;
        public string ReasonForRemoval;
        public string HoneywellInvoiceNumber;
        public string ExternalRef;
        public string ServiceBulletinNumber;
        public string AmountofFreightClaim;
        public string LaborTime; 
        public string LaborRate;
        public string LaborCharges;
        public string AmountofMaterialClaim;
        public string AmountofTotalClaim;
        public string AttachmentType;
        public string FileAttachment;
        public string AircraftMake;
        public string AircraftModel;    
        public string PHASE_OF_FLIGHT;
        public string Fault_Code;        
        public string ccEmailAddress;
        
        public string Engine_SN;
        public string Engine_Model;
        public date Engine_Received_Date;
        public date Engine_Out_Date;
        public string Customer_PO_RO_WO;
        public date Honeywell_Commit_Date;
        public boolean AOG;
        
        public date DueDate;
        public string ATAChapter;
        
        public string PartNumberDescription;
        public decimal Quantity;
        public decimal QuantityNeeded;
        public string SN_Part_Being_Installed;
        public string Proposed_Supplied;
        public string Price;
        public string ContractNumber;
        public string CustomerType;
        public string PartStatus;
        public string IsTheAircraftSupportedWithARental;
        public string CopyOf8130Tag_ifAvailable;
        public string CopyOf8130TagIssuedBy;
        public string ILSChecked;
        public string OtherServiceCentersChecked;
        //For Outside Purchase Requet Form
        public string LastPartToClearTheEngine;
        public string SalesOrderNumber;
        
        public List<LINEITEMDETAILS> LINEITEMS;
        public List<PARTPRODUCTDETAILS> PARTPRODUCT;
        public List<ITEMIZEDPARTS> LINEITEMPARTS; 
        public List<Attachmentlist> Attachments;    
    }    
     
    global class Attachmentlist{
        public string AttBody;
        public String AttFileName;
        public String AttContentType;
    }
    
    global class PARTPRODUCTDETAILS{
        public string PartNumber;
        public String SerialNumberShipped;
        public String AdditionalLineInfo;
        public String CageCode;
        public String DateNeeded;
        public String Quantity;
        public String NetPrice;
        public String CaselineitemNumber;
        public String ProductName;
        public String ProductNumber;
        public String CaseNumber;     
        public String Discount;
    }
    global class ITEMIZEDPARTS{
        string PartNumber;
        String SerialNumberShipped;
        String AdditionalLineInfo;
        String Quantity;
        String NetPrice;
        String CaselineitemNumber;
        String ProductName;
        String ProductNumber;
        String CaseNumber;
        String DeliveryDate;
        String LeadTime;
        String Discount;
    }
     global class LINEITEMDETAILS{
        string PartNumber;
        String SerialNumberShipped;
        String AdditionalLineInfo;
        String Quantity;
        String NetPrice;
        String CaselineitemNumber;
        String ProductName;
        String ProductNumber;
        String CaseNumber;
        String DeliveryDate;
        String LeadTime;
        String Discount;
    }   
}