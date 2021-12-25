/****************************************
* Class Name : CH_EmailMessageTriggerHelper
* Created Date: 22 Nov 2018
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 
* Description : 
* Test Class:
*****************************************/
public class CH_EmailMessageTriggerHelper {
  
	
	public static void scramblingLogic(List < EmailMessage > newmailList){
		List < String > fieldNameList = new List < String > ();
		
		fieldNameList.add(Label.EmailMessageScrambledSubject);
		fieldNameList.add(Label.EmailMessageScrambledHTML);
		fieldNameList.add(Label.EmailMessageFieldsText);
	
		for(EmailMessage mailObj: newmailList) {
			scramblingFields(mailObj, fieldNameList);
		}
 
	}
	
	public static void scramblingFields(EmailMessage cref,List < String > fieldsList){
	String Objtype = 'EmailMessage';
		Map < String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType caseSchema = schemaMap.get(Objtype);
		Map < String, Schema.SObjectField> fieldMap = caseSchema.getDescribe().fields.getMap();
		
		for (String fieldName: fieldsList) {
			if(fieldMap.containskey(fieldName)){
	Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
	if(fielddataType == Schema.DisplayType.TextArea || fielddataType == Schema.DisplayType.String){
		String fieldvalue = String.valueof(cref.get(fieldName));
		
		if(fieldvalue != '' && fieldvalue != null){
			cref.put(fieldName, CH_SecurityUtils.scrambleText(fieldValue));
		}	
	}
			}
		}
	}
		
	public static void cpaCustomerDeliveryUpdate(List<EmailMessage> emailMessageList) { 
		system.debug('cpaCustomerDeliveryUpdate Method Starts ends-->'+emailMessageList);
		set<String> cpaId = new set<String>();
		for(EmailMessage objEMailMsg : emailMessageList){

			if(objEMailMsg.RelatedToId !=null){
				String relatedToId = String.valueof(objEMailMsg.RelatedToId);
			   // if(relatedToId.startsWith('aD5')){
					cpaId.add(relatedToId);
				//}
			}			
		}
	
		List <CH_Corrective_Preventive_Action__c> cpaList = new List<CH_Corrective_Preventive_Action__c>();
		for( CH_Corrective_Preventive_Action__c objCPA : [ select id , CH_Customer_Delivery__c, CH_Customer_Delivery_Date__c
														  from CH_Corrective_Preventive_Action__c where id in : cpaId] ){
			objCPA.CH_Customer_Delivery__c = true;
			objCPA.CH_Customer_Delivery_Date__c = system.now();
			cpaList.add(objCPA);
		}
		if(!cpaList.isempty()){
			update cpaList;
		}
		system.debug('cpaCustomerDeliveryUpdate Method Ends ends-->');
	}
}