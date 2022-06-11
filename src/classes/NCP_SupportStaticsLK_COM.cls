public without sharing class NCP_SupportStaticsLK_COM {
	@AuraEnabled
	public static knowledge__kav getArticle(String articleTitle) {
		try {
			knowledge__kav targetArticle =
	[select title, id, Details__c FROM knowledge__kav WHERE publishStatus = 'online'
		AND language = 'en_US' AND title = :articleTitle Order By LastModifiedDate desc LIMIT 1];
			return targetArticle;
		} catch (Exception e) {
			AuraHandledException err = new AuraHandledException(e.getMessage());
			throw err;
		}
	}
}