@istest
public class HWS_SPSNotificationPDF_TEST {
	public static Id sPSCaseRType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);
	public static Id spsReadOnlyCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES_READ_ONLY);
	public static testmethod void sPSNotificationPDFMethods(){
		Id spsCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);
		Id spsCaseChild = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES_READ_ONLY);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id logisticAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer);
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');		
	
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();		
		prod.ProductCode = '1234';		
		insert prod;
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.Customer_Compliance__c ='US_Govern';
		insert acc;   
		
		Account acc2 = HWS_DataFactory_TEST.insertAccount(); 
		acc2.RecordTypeId =  customerAccountType;  
		insert acc2;
		
		
		Account acc1 = HWS_DataFactory_TEST.insertAccount(); 
		acc1.RecordTypeId =  legalEntityAccountType;
		acc1.ParentId = acc.Id;
		acc1.Email_Send_Check__c='Order Confirmation';
		insert acc1;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);	
		ast.RecordTypeId = assetRecordType;		
		ast.HWS_SourceSystem__c  = 'Puma1';		
		ast.AccountId=acc1.Id;		
		insert ast;
		
		Account ACC3 = new Account();
		ACC3.Name = 'Testing RMANUMBER FIELD';
		ACC3.ParentId = Acc.Id;
		ACC3.Logistic_Account_Type__c = 'Bill-To';
		ACC3.ngERP__c = '1';
		ACC3.BillingCountry = 'India';
		ACC3.BillingStreet = 'Gachibowli, Gachibowli';
		ACC3.BillingCity = 'Hyderabad';
		ACC3.BillingPostalCode = '500071';
		ACC3.BillingState = 'TELANGANA';
		ACC3.Market__c = 'Market India';
		ACC3.RecordTypeId = logisticAccountType;
		insert ACC3;
		
		Contact con = HWS_DataFactory_TEST.insertContact();
		con.AccountId = acc2.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='xyz@example.com';
		insert con;
		
		Case caserec = new Case();
		caserec.RecordTypeId =spsCase;
		caserec.Status='Open';
		caserec.Subject='testSubject';
		caserec.Description='testDescription';
		caserec.HWS_Faulty_Serial_Number__c= 'test1234';
		caserec.HWS_ShipTopartyId__c='1234566';
		caserec.Hws_Ship_to_Party_Address__c=ACC3.Id;
		caserec.AssetId=ast.Id;
		caserec.accountid=acc1.id;
		caserec.HWS_Sellable_Product__c = prod.Id;
		caserec.HWS_Communication_Contact__c = con.Id;
		insert caserec;
		
		
		List<Case> listCase = new List<Case>();
		List<Case> casparent=[select id,parentId from case  where HWS_ShipTopartyId__c='1234566' Limit 1];
		for(Case caseTestParent:casparent){
			Case caseRec1=new Case();
			caseRec1.RecordTypeId =spsCaseChild;
			caseRec1.Status='Ordered';
			caseRec1.Subject='testSubject1';
			caseRec1.Description='testDescription1';
			caseRec1.HWS_Faulty_Serial_Number__c= 'test11234';
			caseRec1.HWS_ShipTopartyId__c='11234566';
			caseRec1.ParentId=casparent[0].Id;
			caseRec1.ContactId=con.Id;
			caseRec1.accountid=acc1.id;		
			caseRec1.AssetId=ast.Id;
			caseRec1.HWS_Sellable_Product__c = prod.Id;
			listCase.add(caseRec1);
		}
		insert listCase;
		
		Map<Id, Case> oldCaseMap = new Map<Id, Case>();
		//listCase[0].Status='Ordered';
		for(case c : listCase){
			Case cs = new case(Id = c.Id);
			cs.Status='Draft';
			oldCaseMap.put(cs.id,cs);
		}
		update listCase;
		HWS_SPSNotificationPDF.spsChildCasesPDF( listCase,oldCaseMap);
	}
}