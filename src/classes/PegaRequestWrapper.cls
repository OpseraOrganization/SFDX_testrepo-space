public class PegaRequestWrapper{    
        public String CaseNumber;
        public String CaseOwner;
        public String Casetype;
        public String Status;
        public String CustContactName;
        public String CustomerHoneywellID;
        public String CustPrimaryEmail;
        public String CustPrimaryWorkNo;
        public String CustomerPOROWONumber;
        public String CustomerSONumber;
        public String CustomerName;
        public String AccountSubType;
        public String WorkStream;
        public String SubQueryType;
        public String CaseRefID;
        public String SFDCCaseID;
        public String SFDCTransferID;
        public String CaseClosureID;
        public string CreatedBy;
        public String AdditionalWebFormInfo; // Added for INC0000157777
        public List<CustomerEmail> CustomerEmail;
        
    
    public class CustomerEmail {
        public String pyToString;
        public String pyCCString;
        public String pySubject;
        public String pyFromUserID;
        public String pyBody;
        public String pxSentDateTime;
        public List<AttachmentList> AttachmentList;
        }
    
    public class AttachmentList {
        public String pxAttachName;
        public String pyAttachStream;
    }
    
     
    }