public class DCP_StaticPage_Controller {
	@AuraEnabled
	public static List<knowledge__kav> getStaticPage(String articleTitle) {
		List<knowledge__kav> staticPageList = new List<knowledge__kav>();
		//Fetch Articles
		System.debug('articleTitle ' + articleTitle);
		staticPageList = [select title,id from knowledge__kav
							  where title = :articleTitle AND publishStatus='online' and language='en_US'
							  Order By LastModifiedDate desc
							  LIMIT 1];
		return staticPageList;
	}

}