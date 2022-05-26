/****************************************
* Name : DS_CustomCommercialEntitlementTest
* Author : Accenture

*****************************************/
@isTest  
public class DS_CustomCommercialEntitlementTest {
	
	public testmethod static void createTestSWXupsell(){
		
		
		
		
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
			Test.startTest();
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			
			User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
			database.insert(user1); 
			
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
			database.insert(ContactList); 
			
			User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );
			
			
			system.runAs(user1){						
				database.insert(userDS); 
				
				userDS.IsPortalEnabled =  True;
				
				database.update(userDS);
			}
			Test.stopTest();
			
			//Create a product record for the product feature junction link
			Product2 product = TestDataFactory.productCreation(1)[0];
			product.ProductCode = '151421';
			database.insert(product);
			
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
			
			
			Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
			commercialEntitlement.Parent_Account__c = accountCreationDP.Id;
			commercialEntitlement.Product_Name__c = product.id;
			database.insert(commercialEntitlement);
			
			
			//Create line items for the digital proposal 
			List<sObject> objList = new List<sObject>();
			SWx_Upsell_Items__c lineItem = TestDataFactory.createSWXLineItems(new set<Id> {UpsellProposal.Id},1)[0];
			lineItem.SWx_Product_Code__c = '151421';
			lineItem.Status_In_Network__c = false;
			lineItem.Sales_Item_Code__c=product.id;
			lineItem.SWx_Upsell_Proposal__c = UpsellProposal.id;
			lineItem.Commercial_Entitlement__c = commercialEntitlement.Id;
			objList.add(lineItem);
			//database.insert(lineItem);
			
			
			
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
			
			DS_CustomCommercialEntitlementController.relatedDigitalProposals(commercialEntitlement.Id);
			DS_CustomCommercialEntitlementController.activateproducts(new List<SWx_Upsell_Items__c>{lineItem});
			
		}
		
		
		
	}
	
}