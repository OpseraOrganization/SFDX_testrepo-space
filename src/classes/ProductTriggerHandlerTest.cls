@istest
public class ProductTriggerHandlerTest {
  
	static testmethod void testmethod1(){
		
		test.startTest();
		
		List<Product_Hierarchy__c> PH_List=new List<Product_Hierarchy__c>();
		Product_Hierarchy__c prodhier1 = new Product_Hierarchy__c();
		Product_Hierarchy__c prodhier2 = new Product_Hierarchy__c();
		
		prodhier1.Business_Group_Code__c = 'FN';
		prodhier1.Business_Unit_Code__c = 'BUAASER';
		prodhier1.Portfolio_Package_Code__c = 'L00147';
		prodhier1.Business_Line_Code__c = 'L082002';
		PH_List.add(prodhier1);
		
		prodhier2.Business_Group_Code__c = 'MN';
		prodhier2.Business_Unit_Code__c = 'BUAASER';
		prodhier2.Portfolio_Package_Code__c = 'L00147';
		prodhier2.Business_Line_Code__c = 'L082002';
		PH_List.add(prodhier2);
		
		database.insert(PH_List);
		
		//Product Creation
		Product2 proinstance = new Product2();
		proinstance.Name = 'Test';
		proinstance.Business_Group__c='FN';
		proinstance.Family='BUAASER';
		proinstance.NokiaCPQ_Portfolio_Package_Code__c='L00147';
		proinstance.Business_Line_Code__c='L082002';
		proinstance.Product_Hierarchy__c = prodhier1.Id;
		database.insert(proinstance);
		
		//Prodhierarchy Update in Product
		proinstance.Product_Hierarchy__c=prodhier2.Id;
		database.update(proinstance);
		test.stopTest();
	}
}