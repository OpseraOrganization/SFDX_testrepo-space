/****************************************
* Created By : Rahul Kumar (rahul.6.kumar@nokia.com)
* Description : An apex class that acts as an inbound email handler for the user requests coming via sharepoint forms.
* The aim of the following code is to parse the different paramenters sent in the email and map it with the case field.
* Insert the case along with any attachements which has come over email.
*****************************************/

global without sharing class emailServiceReciver_UserRequest implements Messaging.InboundEmailHandler{
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		//Create an InboundEmailResult object for returning the result of the email service. 
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		Case c;
		parseEmailWrapper parsedEmail = new parseEmailWrapper();
		
		try{
			//Create a new case
			c = new Case();
			
			//Parse the body of the email to recieve case specific information
			if(email.plainTextBody != null && email.plainTextBody != '')
				parsedEmail = parseEmailBody(email.plainTextBody);
			else
				c.description = 'Formated description is not provided in the automated email.';
			
			//Assign email subject to case subject
			if(email.subject != null && email.subject != '')
				c.subject = email.subject; 
			else
				c.Subject = 'No Subject is Provided';
			
			//Set other case fields value from the parsed information if available
			c.RecordTypeId = parsedEmail.support_Ticket_Record_Type; //Hardcoded Values needs to be recived in the email. 
			c.Priority = parsedEmail.assessed_Priority;
			c.description = parsedEmail.description;
			c.Type = parsedEmail.type;
			c.Origin = parsedEmail.support_Ticket_Origin;
			c.Line_Manager_Email__c = parsedEmail.line_Manager_Email;
			c.Multimarket_CrossMarket__c = parsedEmail.multimarket_CrossMarket;
			//c.Additional_Capabilities__c = parsedEmail.additional_Capabilities;
			c.Additional_Capabilities__c = parsedEmail.tableau_CRM_Access;
			c.Nokia_ID__c = parsedEmail.nokia_ID;
			c.Type_of_Request__c = parsedEmail.type_of_Request;
			c.Email__c = parsedEmail.applicant_Email;
			c.Territory__c = parsedEmail.Territory;
			c.Subscribe_Status_Notifications_on_Email__c = parsedEmail.subscribe_to_Emails;
			c.Select_Your_Market__c = parsedEmail.Select_your_market;
			//c.SuppliedEmail = email.fromAddress;
			c.SuppliedEmail = parsedEmail.request_Submitted_By;
			c.Category__c = parsedEmail.Category;
			c.Has_Attachments__c = parsedEmail.has_Attachments;
			c.Country__c = parsedEmail.Country;
			
			Insert c;
			
			//Call the method to save the attachments if any
			saveAttachments(email,c);
			
			//set the sucess value of result to "true" and return result 
			result.success = true; 
			Return result;
			
		}
		Catch(exception e){
			//set the sucess value of result to "false" along with message and return the result. 
			result.success = false;
			result.message = 'Opps the emailprocessing failed with exception: '+e;
			System.debug('Exception: '+e);
			Return result;
			
		}
		
	}
	
	public void saveAttachments(Messaging.InboundEmail email, Case c){
		List<attachment> attachmentLsit = new List<attachment>();

		// Save any Text attachments
		if(email.textAttachments != null){
		   for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
				Attachment attachment = new Attachment();
	
				attachment.Name = tAttachment.fileName;
				attachment.Body = Blob.valueOf(tAttachment.body);
				attachment.ParentId = c.Id;
	
				attachmentLsit.add(attachment);
			}
		}

		//Save any Binary Attachment
		if(email.binaryAttachments != null){
			for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
				Attachment attachment = new Attachment();
				
				attachment.Name = bAttachment.fileName;
				attachment.Body = bAttachment.body;
				attachment.ParentId = c.Id;
	
				attachmentLsit.add(attachment);
			}
		}

		if(attachmentLsit != null)
			insert attachmentLsit;
		
	}
	
	Public parseEmailWrapper parseEmailBody(String body){
		parseEmailWrapper p = new parseEmailWrapper();
		
		//p.subject = body.substringBetween('Subject:', ';');
		p.assessed_Priority = body.substringBetween('Assessed Priority:',';');
		p.description = body.substringBetween('Description:',';');
		p.type = body.substringBetween('Type:', ';');
		p.line_Manager_Email = body.substringBetween('Line Manager Email:', ';');
		p.multimarket_CrossMarket = body.substringBetween('Multimarket/CrossMarket:',';');
		//p.additional_Capabilities = body.substringBetween('Additional Capabilities:', ';');
		p.tableau_CRM_Access = body.substringBetween('Tableau CRM Access:', ';');
		p.nokia_ID = body.substringBetween('Nokia ID:',';');
		p.type_of_Request = body.substringBetween('Type of Request:', ';');
		p.support_Ticket_Origin = body.substringBetween('Origin:',';');
		p.support_Ticket_Record_Type = body.substringBetween('Record Type:', ';');
		p.applicant_Email = body.substringBetween('Applicant Email:',';');
		p.Territory = body.substringBetween('Territory:', ';');
		p.subscribe_to_Emails = body.substringBetween('Subscribe to Emails for Ticket Status:',';');
		p.Select_your_market = body.substringBetween('Select Your Market:',';');
		p.Category = body.substringBetween('Category:',';');
		p.request_Submitted_By = body.substringBetween('Request Submitted By:',';');
		p.has_Attachments =  Boolean.valueOf(body.substringBetween('Has Attachments:',';'));
		p.Country = body.substringBetween('Country:',';');
		
		return p;
	}
	
	public class parseEmailWrapper{
		//public String subject;
		public String assessed_Priority;
		public String description;
		public String type;
		public String line_Manager_Email;
		public String multimarket_CrossMarket;
		//public String additional_Capabilities;
		public String tableau_CRM_Access;
		public String nokia_ID;
		public String type_of_Request;
		public String support_Ticket_Origin;
		public String support_Ticket_Record_Type;
		public String applicant_Email;
		public String Territory;
		public String subscribe_to_Emails;
		public String Select_your_market;
		public String Category;
		public string request_Submitted_By;
		public Boolean has_Attachments;
		public String Country;
	}
	
}