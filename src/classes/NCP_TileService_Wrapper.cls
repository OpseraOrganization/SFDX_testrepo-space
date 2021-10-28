/**
About
-----
Description: This wrapper class is used to represent Tile object in Service Page in the community product detail page

Created for: Nokia Customer Portal
Created date: 12 28 2017

Update History
--------------
Created: 12 18 2017 – aboukrim@salesforce.com

--------------
**/

public with sharing class NCP_TileService_Wrapper {

	@auraEnabled
	public String title{ get; set; }

	@auraEnabled
	public String description{ get; set; }

	@auraEnabled
	public String url{ get; set; }

	@auraEnabled
	public String entitlementAccessType{ get; set; }

	@auraEnabled
	public String iconName{ get; set; }

	@auraEnabled
	public String imageUrl{ get; set; }

	@auraEnabled
	public Decimal priority{ get; set; }

	@auraEnabled
	public Boolean isPublic{ get; set; }
}