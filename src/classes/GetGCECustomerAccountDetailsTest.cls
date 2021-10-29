/*******
 **** @@ Componenet Name : GetGCECustomerAccountDetailsTest
 **** @@ DESC : Test class for GetGCECustomerAccountDetails Service class.
*******/

@isTest
public class GetGCECustomerAccountDetailsTest {
    public static testMethod void doPostTest(){
        test.startTest();
        	Account acc = new Account();
        	acc.Name 	= 'Boeing';
        	acc.GCE_Customer_Segment__c = 'Airline';
        	acc.Customer_Status__c = 'Active';
        	insert acc;
        	Contact con 	= new Contact();
        	con.LastName 	= 'Martin';
        	con.AccountId 	= acc.Id;
        	insert con;
        	GetGCECustomerAccountDetails.GCESegmentDetail segdetails = new GetGCECustomerAccountDetails.GCESegmentDetail();
        	segdetails.HonOrgId 	= 'Aero';
        	segdetails.GCESegment 	= 'All';
        	String myJson 		 = JSON.serialize(segdetails); 
        	RestRequest  req     = new RestRequest();
         	RestResponse res     = new RestResponse();
        	req.httpMethod		 = 'POST';
        	req.requestURI		 = '/services/apexrest/GetGCECustomerAccountDetails';
        	req.requestBody		 = Blob.valueOf(myJson);
        	RestContext.request  = req;
        	RestContext.response = res;
        	GetGCECustomerAccountDetails.doPost();
        
        	GetGCECustomerAccountDetails.GCESegmentDetail segdetails1 = new GetGCECustomerAccountDetails.GCESegmentDetail();
        	segdetails1.HonOrgId 	= 'Aero';
        	segdetails1.GCESegment 	= 'Airline';
        	String myJson1 		    = JSON.serialize(segdetails1); 
        	RestRequest  req1       = new RestRequest();
         	RestResponse res1       = new RestResponse();
        	req1.httpMethod		    = 'POST';
        	req1.requestURI		    = '/services/apexrest/GetGCECustomerAccountDetails';
        	req1.requestBody		= Blob.valueOf(myJson1);
        	RestContext.request  	= req1;
        	RestContext.response 	= res1;
        	GetGCECustomerAccountDetails.doPost();
        
        	GetGCECustomerAccountDetails.GCECustomerDetails segdetails2 = new GetGCECustomerAccountDetails.GCECustomerDetails('Airline','Boeing','A-12345','Martin','America','Dedicated');
        	String myJson2 		    = JSON.serialize(segdetails2); 
        	RestRequest  req2       = new RestRequest();
         	RestResponse res2       = new RestResponse();
        	req2.httpMethod		    = 'POST';
        	req2.requestURI		    = '/services/apexrest/GetGCECustomerAccountDetails';
        	req2.requestBody		= Blob.valueOf(myJson2);
        	RestContext.request  	= req2;
        	RestContext.response 	= res2;
        	GetGCECustomerAccountDetails.doPost();
        test.stopTest();
    }
}