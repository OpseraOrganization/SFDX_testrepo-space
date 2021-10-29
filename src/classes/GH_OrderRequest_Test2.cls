@isTest(seealldata = true)
public class GH_OrderRequest_Test2{
    public static testMethod void GH_OrderRequest_TestEvent1(){
        
        test.startTest();
        
                
        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Complete';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.SBG__c=Label.GH_Aero;
        or1.SBU__c=Label.GH_D_S;
        or1.Status__c='draft';
        or1.RecordTypeId = Label.GH_App_Request;
        or1.Event_Total_cost_covered_in_currency__c = 120;
        or1.Event_Total_cost_covered_value__c = 234;
        or1.Event_Type__c = 'Other';
        or1.Event_Type_of_Currency__c = 'USD';
        or1.Is_Event_Request__c = true;
        or1.Number_of_people_for_event__c = 12;
        or1.Event_Date__c = Date.today();
        insert or1;
        /*Order_Request__c or2 = or1;
        or2.status__c = 'Pending';
        or2.Event_status__c = 'Pending';
        */
        GH_OrderRequest.createEventRequest(or1,null);
        
        GH_OrderRequest.getEventRequest(or1.Id);
        GH_OrderRequest.getEventDraftRecord(or1.Id);
        GH_OrderRequest.cancelEventRequest(or1.Id);
        
        
        GH_OrderRequest.searchContact('Shri');
        GH_OrderRequest.searchAccount('Hon');
        Account acc = new Account();
        acc.Name = 'Hon Test Account';
        insert acc;
        Contact con = GH_OrderRequest.CreateContact('ABC_FirstName','XYZ_LastName',acc.Id,'shri@honeywelltest.com','Developer','India','Bangalore');
        GH_OrderRequest.getContactDetails(con.Id);
        GH_OrderRequest.FetchCurrency();
        GH_OrderRequest.ConvertTOUSD('INR');
        
        GH_OrderRequest.updateUser('A&T','Aero');
        
        GH_OrderRequest.DeleteRequestForSingleRecipient(or1.Id);
        
        
       /************************Calling for GH_App_CustomReportClass***********************************/
       //GH_App_CustomReportClass.getAeroGHReportEvent();
        
        test.stopTest();
    }
    
    
}