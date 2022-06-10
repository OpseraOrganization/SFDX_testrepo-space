/**
About
-----
Description: This Class is used to represent Banner News custom meta data in community Home Page.

Created for: Nokia Customer Portal
Created date: 02 13 2018

Update History
--------------
Created: 02 13 2018 – aboukrim@salesforce.com
Updated: 02 14 2018 – dominic.butler@salesforce.com


--------------
**/

public with sharing class NCP_BannerNews_COM {

	@AuraEnabled
	public static List<NCP_Banner_News__mdt> getBannerNews() {
		String pageBannerNews = 'Page Banner News';
		String topBannerNews = 'Top Banner News';
		
		List<NCP_Banner_News__mdt> news = new List<NCP_Banner_News__mdt>();
		Boolean pageBannerAdded = false;
		Boolean topBannerAdded = false;		
		DateTime currentTime = System.now();
		
		for (NCP_Banner_News__mdt b : [Select NCP_Subject__c,NCP_Body__c,NCP_URL__c,NCP_Urgency_Level__c,NCP_Type__c,NCP_End_Time__c from NCP_Banner_News__mdt where NCP_End_Time__c > :currentTime]) {
			if (b.NCP_Type__c == pageBannerNews && !pageBannerAdded) {
				news.add(b);
				pageBannerAdded = true;
			}
			if (b.NCP_Type__c == topBannerNews && !topBannerAdded) {
				news.add(b);
				topBannerAdded = true;
			}			
		}
		
		return news;
	}

}