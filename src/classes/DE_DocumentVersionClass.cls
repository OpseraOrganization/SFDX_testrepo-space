public with sharing class DE_DocumentVersionClass {
	
	@AuraEnabled
	public static void createObject(string Name){
		try{
			System.debug('Enterned into the create method of the class');
			//get account ID 
			Apttus__APTS_Agreement__c	 agreement = [SELECT Id,Name FROM Apttus__APTS_Agreement__c LIMIT 1];
			System.debug(agreement);
			Apttus__DocumentVersion__c doc = new Apttus__DocumentVersion__c();
				doc.DE_Status__c='Waiting To Send';
				doc.Apttus__Title__c=Name;
				doc.Name=Name;
				doc.Apttus__AgreementId__c=agreement.id;
				System.debug(doc);
				insert doc;
		}catch(Exception e){
			System.debug(e);
		}
	}
}