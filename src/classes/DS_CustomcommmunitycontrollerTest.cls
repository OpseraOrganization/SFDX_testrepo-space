/****************************************
* Class Name : DS_CustomcommmunitycontrollerTest
* Created Date: 13 DEC 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description : test class for Custom community controller
* Controller class for DS_Prop_RelatedProducts component
*/
@isTest
private with sharing class DS_CustomcommmunitycontrollerTest {
	
	   
	/******************************
	*Method Name: getLineItemRecTest
	*Description: Test Method to cover getLineItemRec method
	********************************/
	

	Static testMethod void showProductsTest(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
			System.runAs(sysAdminUser){
				
				Account accountCreationDP = TestDataFactory.createAccount(1)[0];
				database.insert(accountCreationDP);
				
				Test.startTest();
				
				String orgId = UserInfo.getOrganizationId();
				String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
				Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
				String uniqueName =   dateString + randomInt;
				
				List<sObject> userContactList = new List<sObject>();
			   
				User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
									  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
				//database.insert(user1); 
				userContactList.add(user1);
				
				//Creating Custom Setting Data
				CH_AccountName__c accauth = new CH_AccountName__c();
				accauth.CH_InvalidName__c = 'Nokia';
				accauth.CH_ValidName__c = 'Nokia-OYJ';
				insert accauth;
				
				List<Contact> ContactList = new List<Contact>();
				Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
				Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
				ContactList.add(conDS);
				ContactList.add(conDS2);
				//database.insert(ContactList); 
				userContactList.addAll(ContactList);
				insert(userContactList);
			   
				User userDS = new User(alias = 'abc', email = uniqueName + '1@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
									   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '1@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );
				
				
				system.runAs(user1){						
					database.insert(userDS); 
					
					userDS.IsPortalEnabled =  True;
					
					database.update(userDS);
				}
				Test.stopTest();
				
			   system.runAs(userDS){   
					DS_Customcommmunitycontroller.getcurrentuserContactcard();
			   }
				
				//Create digital proposal record
				SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accountCreationDP)[0];
				upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
				upsellProposal.Analytics_Source__c=CSWXGlobalConstant.CXM_Type ;
				upsellProposal.Proposal_Status__c=CSWXGlobalConstant.ACTIVE; 
				upsellProposal.Upsell_Status__c=CSWXGlobalConstant.readyForReview ;
				
				upsellProposal.Proposal_Recommendation_Type__c='renewal';
				upsellProposal.P20_Id__c=215616;
				upsellProposal.CurrencyIsoCode='EUR';
				upsellProposal.Unweighted_Value__c=429052.07;
				upsellProposal.Account_ID__c=accountCreationDP.id;
				upsellProposal.Technology__c=CSWXGlobalConstant.Technology ;
				upsellProposal.Use_Case__c=CSWXGlobalConstant.Usecase ;
				upsellProposal.DS_Show_In_Portal__c=true;
				upsellProposal.Sold_To_Party__c = accountCreationDP.Id;
				database.insert(UpsellProposal);
				
				//Create line items for the digital proposal 
				List<sObject> objList = new List<sObject>();
				SWx_Upsell_Items__c lineItem = TestDataFactory.createSWXLineItems(new set<Id> {UpsellProposal.Id},1)[0];
				lineItem.SWx_Product_Code__c = '151421';
				lineItem.Status_In_Network__c = false;
				lineItem.SWx_Upsell_Proposal__c = UpsellProposal.id;
				objList.add(lineItem);
				//database.insert(lineItem);
				
				 
				//Create a product record for the product feature junction link
				Product2 product = TestDataFactory.productCreation(1)[0];
				product.ProductCode = '151421';
				objList.add(product);
				//database.insert(product);
				
				//Create a product feature record for the product feature junction link
				ProductFeature__c productFeature = new ProductFeature__c();
				productFeature.FeatureItemId__c = '1111';
				productFeature.NSNClassification__c = 'Feature Component';
				objList.add(productFeature);
				//database.insert(productFeature);
				
				database.insert(objList);
				
				//Create a product feature junction record
				Product_Feature_Junction__c prodFeatureJunction = new Product_Feature_Junction__c();
				prodFeatureJunction.Product__c = product.id;
				prodFeatureJunction.isPCI__c = false;
				prodFeatureJunction.Product_Feature__c = productFeature.id;
				database.insert(prodFeatureJunction);
				
				  Product_Feature_Junction__c prodFeatureJunction1 = new Product_Feature_Junction__c();
				prodFeatureJunction1.Product__c = product.id;
				prodFeatureJunction1.isPCI__c = false;
				prodFeatureJunction1.Product_Feature__c = productFeature.id;
				 database.insert(prodFeatureJunction1);
				
				SWx_Upsell_Items__c lineItem1 = new  SWx_Upsell_Items__c();
				lineItem1.SWx_Product_Code__c = '151421';
				lineItem1.SWx_Upsell_Proposal__c = UpsellProposal.id;
				
				List<SWx_Upsell_Items__c> lineItems=new List<SWx_Upsell_Items__c>();
				   lineItems.add(lineItem1);
				//call the methods from DS_CommunityController
				DS_Customcommmunitycontroller.Relatedproducts(UpsellProposal.Id);
				DS_Customcommmunitycontroller.Relatedproducts(prodFeatureJunction1.Id);
				  DS_Customcommmunitycontroller.Relatedproducts(null);
				DS_Customcommmunitycontroller.showProducts(UpsellProposal.Id);
				 DS_Customcommmunitycontroller.showProducts(prodFeatureJunction1.Id);
				 DS_Customcommmunitycontroller.showProducts(null);
				DS_Customcommmunitycontroller.activateproducts(new List<SWx_Upsell_Items__c>{lineItem});
				 DS_Customcommmunitycontroller.activateproducts(lineItems);
				DS_Customcommmunitycontroller.activateproducts(null);
				DS_Customcommmunitycontroller.getcurrentuser();
				DS_Customcommmunitycontroller.getcurrentuserContactcard();
			   
			
				
	}
		 }

}