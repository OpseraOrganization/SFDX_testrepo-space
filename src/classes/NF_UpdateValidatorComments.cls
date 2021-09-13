/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class NF_UpdateValidatorComments implements Messaging.InboundEmailHandler {

   global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
	Messaging.InboundEnvelope envelope) {
	String emaildata;

	Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
	 System.debug('====> Created Email'+email.fromaddress);
	
	String[] emailBody = email.plainTextBody.split('Approval Request ID', 0);
	
 
   String emailid=emailBody[1].replaceAll( '\\s+', '');
   String emailidnew= emailid.substring(0,18).replaceAll('_','');
   
  
   
System.debug('Loop 1'+emailBody);
System.debug('Loop 1'+emailBody[0].replaceall('End of Comments','').replaceAll('Please do NOT edit the email subject.','').replaceAll('Please Enter the Comments Below',''));
System.debug('Loop 1'+emailidnew);
emaildata=emailBody[0].replaceall('End of Comments','').replaceAll('Please do NOT edit the email subject.','').replaceAll('Please Enter the Comments Below','');
 
for(Apttus_Approval__Approval_Request__c ApprovalData:[select id,Apttus_Approval__Approver_Comments__c,Apttus_Approval__Approval_Status__c from Apttus_Approval__Approval_Request__c where (id=:emailid or id=:emailidnew) Limit 1 ])
 {
   
 ApprovalData.Apttus_Approval__Approver_Comments__c =emaildata;
 update ApprovalData;
 }
 
	return result;

  } 
  
  
  
}