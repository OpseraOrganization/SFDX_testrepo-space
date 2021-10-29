public class PegaEmailRequestWrapper {
	public String CaseID;
	public List<CustomerEmail> CustomerEmail;
    
	public class CustomerEmail {
		public String pyToString;
		public String pxSentDateTime;
		public String pyFromUserID;
		public String pyCCString;
		public String pySubject;
		public String pyBody;
		public String pyBCCString;
		public List<AttachmentList> AttachmentList;
	}

	public class AttachmentList {
		public String pyAttachStream;
		public String pxAttachName;
	}

	
		
	}