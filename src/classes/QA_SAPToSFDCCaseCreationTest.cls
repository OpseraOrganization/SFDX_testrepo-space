/*******
 ****
 **** @@ DESC : Test class for QA_SAPToSFDCCaseCreation Service class,
 ***            QA_EmailNotification Trigger & QA_EmailNotificationHandler class.
*******/
@isTest(SeeAllData=false)
public class QA_SAPToSFDCCaseCreationTest {
    @testSetup static void setupMain() {
        test.startTest();
        	Account acc 				= new Account(); 
            acc.Name    				= 'CHROMALLOY POWER SERVICES CORP';
            acc.GCE_Customer_Segment__c = 'Airline';
            acc.GCE_CSS__c 				= 'Phoenix/America';
            acc.GCE_CSS_Type__c 		= 'Dedicated';
            insert acc;
            Contact con     = new Contact();
            con.LastName    = 'Martin';
            con.AccountId   = acc.Id;
            con.Email 		= 'Martin.Luther@mail.com';
            insert con;
        test.stopTest();
    }
    public static testMethod void mainTest(){
        test.startTest();
        	User runasuser = [SELECT Id,Name,isActive from User where ProfileId =:Label.API_Data_load_profile_Id and isActive =true order by name ASC LIMIT 1];
        	System.runAs(runasuser){
                QA_SAPToSFDCCaseCreation.QuoteLineItemDetails line_item1 = new QA_SAPToSFDCCaseCreation.QuoteLineItemDetails();
                line_item1.Line_Item 	= '10';
                line_item1.Part_Number 	= '3504897-2';
                line_item1.Quantity		= 2;
                line_item1.NBid_Indicator = 'Yes';
                line_item1.Hold_Type	= 'MTO Hold';
                line_item1.Description  = 'RMOSTAT PNEUMATIC COMPRESSOR DISCHARG';
                line_item1.Currency_Type = 'USD';
                line_item1.Units		 = 'EA';
                QA_SAPToSFDCCaseCreation.QuoteLineItemDetails line_item2 = new QA_SAPToSFDCCaseCreation.QuoteLineItemDetails();
                line_item2.Line_Item 	= '20';
                line_item2.Part_Number 	= '3502087-2';
                line_item2.Quantity		= 5;
                line_item2.NBid_Indicator = 'No';
                line_item2.Hold_Type	= 'Pricing Hold';
                line_item2.Description  = 'RMOSTAT PNEUMATIC COMPRESSOR DISCHARG';
                line_item2.Currency_Type = 'USD';
                line_item2.Units		 = 'EA';
                QA_SAPToSFDCCaseCreation.CaseCreationRequestDetails reqdetails = new QA_SAPToSFDCCaseCreation.CaseCreationRequestDetails();
                reqdetails.Case_Status = 'Done';
                reqdetails.CRMID = 'A-648944';
                reqdetails.Contact_EMail = 'Martin.Luther@mail.com';
                reqdetails.Customer_PO_RO_WO_Num = '467334';
                reqdetails.Customer_Request_Dt = '09/02/2020';
                reqdetails.Quote_Entered_Dt = '09/02/2020';
                reqdetails.Quote_Number = '0237858976';
                reqdetails.Sub_Status = 'MTO Hold';
                reqdetails.Sub_Class = 'Mechanical';
                reqdetails.Product_Num = '45679';
                reqdetails.Product_Serial_Num = '465677';
                reqdetails.Line_Items = new List<QA_SAPToSFDCCaseCreation.QuoteLineItemDetails>{line_item1,line_item2};
                String myJson        = JSON.serialize(reqdetails); 
                RestRequest  req     = new RestRequest();
                RestResponse res     = new RestResponse();
                req.httpMethod       = 'POST';
                req.requestURI       = '/services/apexrest/QuoteAutomation/QA_SAPToSFDCCaseCreation';
                req.requestBody      = Blob.valueOf(myJson);
                RestContext.request  = req;
                RestContext.response = res;
                QA_SAPToSFDCCaseCreation.doPost();
                String myJson1       = JSON.serialize(reqdetails); 
                req.requestBody      = Blob.valueOf(myJson1);
                RestContext.request  = req;
                RestContext.response = res;
                QA_SAPToSFDCCaseCreation.doPost();
                reqdetails.Quote_Number = '0237858945';
                reqdetails.Military_Quote = 'Y';
                reqdetails.Contact_EMail = 'test.user@mail.com';
                reqdetails.CRMID = [SELECT Id,Sbl_Account_Row_Id__c FROM Account LIMIT 1].Sbl_Account_Row_Id__c;
                String myJson2       = JSON.serialize(reqdetails); 
                req.requestBody      = Blob.valueOf(myJson2);
                RestContext.request  = req;
                RestContext.response = res;
                QA_SAPToSFDCCaseCreation.doPost();
                reqdetails.Case_Number = [SELECT Id,CaseNumber FROM Case LIMIT 1 ].CaseNumber;
                reqdetails.Case_Status = 'ON Hold';
                reqdetails.Sub_Status = 'Pricing Hold';
                line_item2.Hold_Type	= 'Completed';
                reqdetails.Line_Items = new List<QA_SAPToSFDCCaseCreation.QuoteLineItemDetails>{line_item1,line_item2};
                String myJson3       = JSON.serialize(reqdetails); 
                req.requestBody      = Blob.valueOf(myJson3);
                RestContext.request  = req;
                RestContext.response = res;
                QA_SAPToSFDCCaseCreation.doPost();
            }
        test.stopTest();
    }
}