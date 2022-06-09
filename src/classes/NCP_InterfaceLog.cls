public class NCP_InterfaceLog {
	@future
	public static void insertInterfaceLog(String interfaceType, String messageType, String operationType, String name, String status, String message, String data) {
		System.debug('### -- createInterfaceLog -- ');
		Interface_Log__c log = New Interface_Log__c();
		log.name = name;
		log.Comment__c = message;
		log.Interface_Type__c = interfaceType;
		log.Message_Type__c = messageType;
		log.Operation_Type__c = operationType;
		log.Status__c = status;
		log.Interface_Request_Sent__c = data;
		insert log;
	}

	public static Interface_Log__c createInterfaceLog(String interfaceType, String messageType, String operationType, String name, String status, String message, String data) {
		System.debug('### -- createInterfaceLog -- ');
		Interface_Log__c log = New Interface_Log__c();
		log.name = name;
		log.Comment__c = message;
		log.Interface_Type__c = interfaceType;
		log.Message_Type__c = messageType;
		log.Operation_Type__c = operationType;
		log.Status__c = status;
		log.Interface_Request_Sent__c = data;
		return log;
	}
}