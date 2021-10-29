public class AERO_CaseDetailsWrapper {
    
    Public String caseNumber;
    Public list<CaseComment> CaseComments;
    Public String createdBy;
    Public String subject;
    Public String PortalStatus;
    //Public String productPart;
    Public Boolean AOG;   
    Public String ATAChapter;   
    Public Decimal amountOfClaim;
    Public Decimal quantityOfClaim;
    Public String resolution;
    Public datetime requestDate;
    Public String requestType;
    Public list<contentDocumentLink> documentDetails;
    //Public String description;
    Public String requestDetails;
    Public String accountName;
    Public String AircraftType;
    Public String AircraftSerialNumber;
    Public String PartNumber;
    Public String faultCode;
    Public date requestedDueDate;
    Public String contactId;
    Public String salesOrder;
    Public String repairNotification;
    Public String purchaseOrder;
    Public datetime caseClosureDate;
    Public Decimal leadDays;
    Public String ProductPartNumber;
    Public String ProductNumber;
    Public String QuoteNumber;
    Public String CustomerReferenceNumber;
    
    Public AERO_CaseDetailsWrapper(case caseDetails,list<contentDocumentLink> docDetails,list<CaseComment> caseComments,String portalStatusVal,Decimal leadDay){
        
        this.subject = caseDetails.Subject;
        this.requestType = caseDetails.Portal_request_type__c;
        this.PortalStatus = caseDetails.Portal_Status__c;
        this.requestDate = caseDetails.createdDate;
        this.caseNumber = caseDetails.caseNumber;
        this.contactId = caseDetails.contactId;
		this.createdBy = caseDetails.contact.name;
        this.AOG = caseDetails.AOG__c;
        this.accountName = caseDetails.Account_Name__c;
        this.AircraftType = caseDetails.Aircraft_Type__r.name;
        this.AircraftSerialNumber = caseDetails.Aircraft_Serial_Number__c;
        //this.productPart = caseDetails.Product_Part__c;
		this.faultCode = caseDetails.Fault_Messages__c;
		this.ATAChapter = caseDetails.ATA_Chapter__c;
        this.requestedDueDate = caseDetails.Customer_Request_Date__c;
        this.amountOfClaim = caseDetails.Amount_of_Claim__c;
        this.quantityOfClaim = caseDetails.Quantity_of_Claims__c;
        this.salesOrder = caseDetails.Sales_Order_Number__c;
        this.repairNotification = caseDetails.Repair_Notification_Number__c;
        this.purchaseOrder = caseDetails.Customer_PO_RO_WONumber__c;
        this.PartNumber = caseDetails.Part_Number__c;
        if(String.isNotBlank(caseDetails.Additional_Web_Form_Info__c)){
            this.requestDetails = caseDetails.Additional_Web_Form_Info__c;
        }else{
           this.requestDetails = caseDetails.Description; 
            //system.debug('requestDetails***'+requestDetails);
        }
        this.resolution = caseDetails.Resolution__c;
        this.documentDetails = docDetails; //Attachments details
        this.CaseComments = caseComments;  //CaseComments details
        this.caseClosureDate = caseDetails.ClosedDate;
        this.leadDays = leadDay;
        //system.debug('caseClosureDate' +caseClosureDate);
        this.ProductPartNumber = caseDetails.Product_Part_Number__c;
        this.ProductNumber = caseDetails.Product_Number__r.name;
        this.QuoteNumber = caseDetails.Quote_Number__c;
        this.CustomerReferenceNumber = caseDetails.Customer_Reference_Number__c;
    }
    
}