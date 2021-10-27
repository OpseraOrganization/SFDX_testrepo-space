/******************************************************************************************************
Name : CustomerDocumentControllerTest
Created Date: 7 July 2019
Created by: Accenture
Description : This class is test class for change status lightning button on salesforce
*********************************************************************************************************/
@isTest
public class CustomerDocumentControllerTest{
	
	/***********************************************
Name : CustomerDocTestAsCDR
Descritpion: This method is used fortestingMandatory fields on customer document as OM(CSM,CSC)
based on Status from Custom Setting 
Parameter :
*************************************************/
	static testmethod void CustomerDocTestAsCDR()
	{   
		test.startTest();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		try{
			System.RunAs(userCreation){
				PermissionSet permission1 = [SELECT Name, Id, Description, Type 
											 FROM PermissionSet 
											 where name = :CSWXGlobalConstant.CustomerDocumentRegistration];
				insert new PermissionSetAssignment(AssigneeId = userCreation.id, PermissionSetId = permission1.Id);
				
				Account[] acc = TestDataFactory.createAccount(1);
				database.insert(acc);
				
				//Adding mandatory fields in customerDocument
				List<Mandatory_fields_for_Customer_Document__c> lman=new List<Mandatory_fields_for_Customer_Document__c>();
				Mandatory_fields_for_Customer_Document__c man=new Mandatory_fields_for_Customer_Document__c();
				man.Name='ClosedConsumed_Mandatory_Fields_Umbr';
				man.Object__c='Customer_Document__c';
				man.Sub_Classification__c='Umbrella (Offer Based)';
				man.Status__c='Closed-consumed';
				man.Classification__c='Standard PO';
				man.Mandatory_Fields__c='Classification__c,Sub_Classification__c,Customer__c,Nokia_Legal_entity__c,Customer_Document_ID__c,Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,Total_Value__c';
				lman.add(man);
				Mandatory_fields_for_Customer_Document__c man1=new Mandatory_fields_for_Customer_Document__c();
				man1.Name='ClosedRejected_Mandatory_Fields_Quote';
				man1.Object__c='Customer_Document__c';
				man1.Sub_Classification__c='Quote-based';
				man1.Classification__c='Standard PO';
				man1.Status__c='Closed-rejected';
				man1.Mandatory_Fields__c='Classification__c,Sub_Classification__c,Customer__c,Nokia_Legal_entity__c,Customer_Document_ID__c,Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,Total_Value__c,INCO_Terms__c,Payment_terms__c';
				lman.add(man1);
				Mandatory_fields_for_Customer_Document__c man2=new Mandatory_fields_for_Customer_Document__c();
				man2.Name='Draft_Mandatory_Fields';
				man2.Object__c='Customer_Document__c';
				man2.Status__c='Draft';
				man2.Mandatory_Fields__c='Customer__c,Customer_Document_ID__c';
				lman.add(man2);
				Mandatory_fields_for_Customer_Document__c man3=new Mandatory_fields_for_Customer_Document__c();
				man3.Name='ClosedRejected__Fields_LI_Quote';
				man3.Object__c='Customer_Document_Line_Items__c';
				man3.Status__c='Closed-rejected';
				man3.Mandatory_Fields__c='Quantity__c,Net_Value__c,Total_Value__c';
				man3.Classification__c='Standard PO';
				man3.Sub_Classification__c='Quote-based';			
				lman.add(man3);
				
				database.insert(lman,false);
				
				
				
				List<Customer_Document__c> customdoc=new List<Customer_Document__c>();
				Customer_Document__c cus_doc1= new Customer_Document__c(); 
				cus_doc1.Status__c = 'Draft';
				cus_doc1.Customer__c=acc[0].id;
				cus_doc1.Customer_Document_ID__c='1233';
				cus_doc1.Classification__c ='Standard PO';
				cus_doc1.Sub_Classification__c='Quote-based';
				customdoc.add(cus_doc1);
				
				database.insert(customdoc,false);
				//cus_doc1.Status__c='Closed-consumed';
				
				List<Customer_Document_Line_Items__c> cdliList = new List<Customer_Document_Line_Items__c>();
				Customer_Document_Line_Items__c cdli=new Customer_Document_Line_Items__c();
				cdli.Quantity__c='1';
				cdli.Net_Value__c=35;
				cdli.Customer_Document__c=customdoc[0].id;
				cdliList.add(cdli);
				
				Database.insert(cdliList,false);
				customdoc[0].status__c = 'Closed-rejected';
				CustomerDocumentController.checkValidation(customdoc[0].id,customdoc[0].status__c);
				
				// CustomerDocumentContoller.checkValidation(customdoc[1].id,customdoc[1].status__c); 
				Schema.SObjectType objType = Schema.getGlobalDescribe().get('Customer_Document__c');
				sObject sObj=objType.newSObject();
				CustomerDocumentController.getselectOptions(sObj ,'Status__c');
			}
		}
		catch(Exception ex)
		{
			Boolean expectedExceptionThrown =  ex.getMessage().contains('required fields') ? true : false;
			//System.assertEquals(expectedExceptionThrown, true);
			system.debug('Exception-->'+ex);
		}
		
	}
	
	/***********************************************
Name : CustomerDocTestAsOM
Descritpion: This method is used fortestingMandatory fields on customer document as OM(CSM,CSC)
based on Status from Custom Setting 
Parameter :
*************************************************/
	static testmethod void CustomerDocTestAsOM()
	{   
		test.startTest();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		try{
			System.RunAs(userCreation){
				PermissionSet permission2 =[Select Name, Id, Description, Type 
											FROM PermissionSet 
											where name = 'DS_GDC'];
				insert new PermissionSetAssignment(AssigneeId = userCreation.id, PermissionSetId = permission2.Id);
				Account[] acc = TestDataFactory.createAccount(1);
				database.insert(acc);
				
				List<Mandatory_fields_for_Customer_Document__c> lman=new List<Mandatory_fields_for_Customer_Document__c>();
				Mandatory_fields_for_Customer_Document__c man=new Mandatory_fields_for_Customer_Document__c();
				man.Name='ClosedConsumed_Mandatory_Fields_Umbr';
				man.Object__c='Customer_Document__c';
				man.Sub_Classification__c='Umbrella (Offer Based)';
				man.Status__c='Closed-consumed';
				man.Classification__c='Standard PO';
				man.Mandatory_Fields__c='Classification__c,Sub_Classification__c,Customer__c,Nokia_Legal_entity__c,Customer_Document_ID__c,Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,Total_Value__c';
				lman.add(man);
				Mandatory_fields_for_Customer_Document__c man1=new Mandatory_fields_for_Customer_Document__c();
				man1.Name='ClosedRejected_Mandatory_Fields_Quote';
				man1.Object__c='Customer_Document__c';
				man1.Sub_Classification__c='Quote-based';
				man1.Status__c='Closed-validated';
				man1.Mandatory_Fields__c='Classification__c,Sub_Classification__c,Customer__c,Nokia_Legal_entity__c,Customer_Document_ID__c,Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,Total_Value__c,INCO_Terms__c,Payment_terms__c';
				lman.add(man1);
				Mandatory_fields_for_Customer_Document__c man2=new Mandatory_fields_for_Customer_Document__c();
				man2.Name='Draft_Mandatory_Fields';
				man2.Object__c='Customer_Document__c';
				man2.Status__c='Draft';
				man2.Mandatory_Fields__c='Customer__c,Customer_Document_ID__c';
				lman.add(man2);
				
				Mandatory_fields_for_Customer_Document__c man3=new Mandatory_fields_for_Customer_Document__c();
				man3.Name='ClosedRejected__Fields_LI_Quote';
				man3.Object__c='Customer_Document_Line_Items__c';
				man3.Status__c='Closed-rejected';
				man3.Mandatory_Fields__c='Quantity__c,Net_Value__c,Total_Value__c';
				man3.Classification__c='Standard PO';
				man3.Sub_Classification__c='Quote-based';			
				lman.add(man3);
				database.insert(lman,false);
				
				
				List<Customer_Document__c> customdoc=new List<Customer_Document__c>();
				Customer_Document__c cus_doc1= new Customer_Document__c(); 
				cus_doc1.Status__c = 'Draft';
				cus_doc1.Customer__c=acc[0].id;
				cus_doc1.Customer_Document_ID__c='1233';
				cus_doc1.Classification__c ='Standard PO';
				cus_doc1.Sub_Classification__c='Quote-based';
				customdoc.add(cus_doc1);
				Set<Id> cusdocset=new Set<Id>();
				cusdocset.add(cus_doc1.id);
				
				database.insert(customdoc,false);
				cus_doc1.Status__c= CSWXGlobalConstant.Closedconsumed;
				cus_doc1.Nokia_Legal_entity__c = 'LE';
				cus_doc1.Customer_Document_Date__c = system.today();
				cus_doc1.Nokia_Document_Receipt_Date__c = system.today();
				cus_doc1.Total_Value__c = 1.00;
				
				List<Customer_Document_Line_Items__c> cdliList = new List<Customer_Document_Line_Items__c>();
				Customer_Document_Line_Items__c cdli=new Customer_Document_Line_Items__c();
				cdli.Quantity__c='1';
				cdli.Net_Value__c=35;
				cdli.Customer_Document__c=customdoc[0].id;
				cdliList.add(cdli);
				
				Customer_Document_Line_Items__c cdli1=new Customer_Document_Line_Items__c();
				cdli1.Quantity__c='1';
				//cdli1.Net_Value__c=35;
				cdli1.Customer_Document__c=customdoc[0].id;
				cdliList.add(cdli1);
				Database.insert(cdliList,false);

				CustomerDocumentController.checkValidation(customdoc[0].id,customdoc[0].status__c);
				
				customdoc[0].status__c = CSWXGlobalConstant.Closedvalidated;
				CustomerDocumentController.checkValidation(customdoc[0].id,customdoc[0].status__c);
				
				Schema.SObjectType objType = Schema.getGlobalDescribe().get('Customer_Document__c');
				sObject sObj=objType.newSObject();
				CustomerDocumentController.getselectOptions(sObj ,'Status__c');
			}
		}
		catch(Exception ex)
		{
			Boolean expectedExceptionThrown =  ex.getMessage().contains('required fields') ? true : false;
			//System.assertEquals(expectedExceptionThrown, true);
			system.debug('Exception-->'+ex);
		}
		
	}
	
}