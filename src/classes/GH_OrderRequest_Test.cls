@isTest(seealldata = true)
public class GH_OrderRequest_Test{
    public static testMethod void GH_OrderRequest_TestRecipient1(){
        
        test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User usr = new User();
        usr.LastName='Test';
        usr.Alias = 'Test';
        usr.Email='standarduser@test.com';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.EmailEncodingKey='UTF-8';
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='sumit13@ntt.com';
        usr.SBG__c=Label.GH_Aero; 
        usr.SBU_User__c=Label.GH_D_S;
        usr.ProfileId = p.Id;
        insert usr;
			
		Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Type = 'OEM';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'G';
        con.FirstName = 'S';
        con.AccountId = acc.Id;
        con.Email='S.G@nttdata.com';
        insert con;

        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Pending';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.SBG__c=Label.GH_Aero;
        or1.SBU__c=Label.GH_D_S;
        or1.Status__c='Pending';
        or1.RecordTypeId = Label.GH_App_Request;
		insert or1;
             
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        //reqRec1.Approver_Name1__c=usr.id;
        reqRec1.City__c='GTK';
        reqRec1.Company__c='NTT Data';
        reqRec1.Country__c='INDIA';
        reqRec1.Country_where_Gift_is_provided__c='INDIA';
        reqRec1.Country_where_ME_is_provided__c='INDIA';
		reqRec1.GH_Request__c=or1.Id;
        reqRec1.Name_of_Recipient_Lookup__c = con.Id;       
        
        reqRec1.Gift_Recipient__c=false;
        
        // Receiver GIFT
        reqRec1.Gifts__c=true;
        reqRec1.Gift_Currency_Code__c='USD';
        reqRec1.Gift_Gift_given_to_government_official__c=true;
        reqRec1.Gift_Gift_offered_to_spouse__c=true;
        reqRec1.Gift_Line_Manager_Informed__c=true;
        reqRec1.Gift_Occasion_Award_Placement__c=true;
        reqRec1.Gift_Occasion_Business_Meeting__c=false;
        reqRec1.Gift_Twelve_Months_Aggregate_Value__c=301;
        reqRec1.Gift_Value_of_gift__c=21;
        reqRec1.Gift_Needs_Approval__c=True;
        reqRec1.Gift_Frequency__c=true;

        // Receiver MEAL
        reqRec1.Meals_Entertainment__c=true;
        //reqRec1.Meal_Score__c=11;
        reqRec1.ME_Frequency__c=true;
        reqRec1.ME_Needs_Approval__c=true;
        reqRec1.ME_Occasion_Award_Placement__c=True;
        reqRec1.ME_Occasion_Business_Meeting__c=false;
        reqRec1.Meals_Currency_Code__c='USD';
        reqRec1.Meals_Value_Per_Currency__c=21;    
        reqRec1.ME_Line_Manager_Informed__c=false;
        reqRec1.ME_Travel_offered_to_spouse__c=true;
        reqRec1.ME_Travel_provided_to_government_officia__c=true;   
        reqRec1.ME_Twelve_Months_Aggregate_Value__c=601;
        reqRec1.Name_of_Recipient__c='Sumivaths Gundlapalli';
        reqRec1.Status__c='Pending';
        reqRec1.RecordTypeid = Label.GH_App_Recipient_Provider_Rec_Type;
		insert reqRec1;
        
        List<GH_Request_Recipient__c> listOfRecs = new List<GH_Request_Recipient__c>();
        
        List<GH_Request_Recipient__c> listOfRecipientsToDelete = null;
        listOfRecs.add(reqRec1);
        
        //GH_OrderRequest.RequestWithRecipients  reqAndrecs = GH_OrderRequest.createGHRecipient(listOfRecs,or1,listOfRecipientsToDelete);
		GH_OrderRequest.RequestWithRecipients  reqAndrecs = new GH_OrderRequest.RequestWithRecipients();
        //reqAndrecs.ghRequest rgr= new Order_Request__c();
        //reqAndrecs.listOfRecipients rlr = new List<GH_Request_Recipient__c>();
                
        GH_OrderRequest.OrderList();
        GH_OrderRequest.GetTypeValues();
        GH_OrderRequest.getCountryList();
        //GH_OrderRequest.GetcontactId();
        GH_OrderRequest.ApproverRecList();
        GH_OrderRequest.searchUser();
        
        GH_OrderRequest.DraftRecList(string.valueOf(or1.Id));
        GH_OrderRequest.GetDraftDetails(reqRec1.Id);
        GH_OrderRequest.GetRequestDetails(string.valueOf(or1.Id));
        GH_OrderRequest.getOrderDetails(string.valueOf(or1.Id));
        GH_OrderRequest.updateRequestStatus(or1.Id,or1.Id,'Pending','123');
        GH_OrderRequest.cancelRecipient(reqRec1.Id,'Complete');
        GH_OrderRequest.GetcontactId();
        
		List<GH_Request_Recipient__c> reqList1 = new List<GH_Request_Recipient__c>();
        reqList1.add(reqRec1);
        
        GH_Request_Recipient__c ReqRec2 = new GH_Request_Recipient__c();
            
        List<GH_Request_Recipient__c> reqList2 = new List<GH_Request_Recipient__c>();
        reqList2.add(reqRec2);
        
        GH_OrderRequest.createGHRecipient(reqList1, or1, reqList2);
        
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '{"id":"https://test.salesforce.com/id/00DS0000003KbiiMAC/005S0000004XclIIAS","issued_at":"1425995829962","token_type":"Bearer","instance_url":"https://cs1.salesforce.com","signature":"0q31xDmPhKd9yGsD08mzukrWSrWAVjeAnoMeUdEfgcc=","access_token":"00DS0000003Kbii!ARMAQOU226_uWf9JKRVXjxzUs_dHg8y.G6PIHFrktN5Ot30Lhjj.dMzOa1JQmEgw4dltjhSAdrnGAyEZjN.amMfgCj2_iNbI"}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        //GHAppInstanceDetails__c ghPMTInstanceDetails = GHAppInstanceDetails__c.getValues('PMT');
        
        GH_OrderRequest.attribute gat = new GH_OrderRequest.attribute();
        gat.type='test';
        gat.url='Test@Url.moc';
                
        GH_OrderRequest.Recipient gar = new GH_OrderRequest.Recipient();
        gar.attributes = gat;
		gar.Id='Test Id';
        gar.Valueofgift='Test Gift'; 
        gar.ValueofMeal='TEst Meal';        
        
        GH_OrderRequest.GHRequestRecipients gag = new GH_OrderRequest.GHRequestRecipients();
        gag.totalSize='1';
        gag.done='Test Done';
        List<GH_OrderRequest.Recipient> garList = new List<GH_OrderRequest.Recipient>();
        garList.add(gar);
        gag.records= garList;
        
        GH_OrderRequest.cont gac = new GH_OrderRequest.cont();
        gac.attributes=gat;
        gac.Id='Test Id';
        gac.GHRequestRecipients=gag;
        
        GH_OrderRequest.Aggregatedata gad = new GH_OrderRequest.Aggregatedata();
        gad.totalSize='1';               
        gad.done='Test Done';
        List<GH_OrderRequest.cont> gacList = new List<GH_OrderRequest.cont>();    
        gacList.add(gac);
        gad.records=gacList;
                
        GH_OrderRequest.UpdatetotalAggregatevalues(or1);
        
        
        
        GH_OrderRequest.createEventRequest(or1, or1);


        test.stopTest();
    }
    
    
}