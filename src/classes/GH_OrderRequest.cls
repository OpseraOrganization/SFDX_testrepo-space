/*******************************************************************************

AERO

Name         : GH_OrderRequest
Created By   : Shrivaths Kulkarni
Company Name : NTT Data
Project      : Gift and Hospitality 
Created Date : 19-Nov-2014
Description  : This class is a controller for GH_Requests page.
   
*******************************************************************************/

Public with Sharing Class GH_OrderRequest{
    // Creating a new record
    /*@RemoteAction
    Public Static Order_Request__c CreateOrder(string Recipient, String Company, String DateCreated, String Type, String RecType, String Country) { 
        Order_Request__c ORR = new Order_Request__c();
        ORR.Name_of_Recipient__c = Recipient;
       // ORR.Company__c = Company;
       // ORR.Country__c = Country;
        if(DateCreated != null && DateCreated != '') {
            ORR.Date__c = Date.ValueOf(DateCreated);
        }
        ORR.Type_of_Meals_Entertainment__c = Type;
        ORR.Status__c = 'Pending';
        if(RecType == 'Gift') {
            ORR.recordTypeId = label.GH_Gift;
        }
        else {
            ORR.recordTypeId = Label.GH_Meals_Entertainment;
        }
        
        try {
            insert ORR;
        }
        catch(exception e) {
            system.debug('Error is in expression: '+e);
        }
        return ORR;
    }*/
    
    // Quering existing records
    @RemoteAction
    Public Static List<Order_Request__c> OrderList() {        
        List<Order_Request__c> MyOrderList = new List<Order_Request__c>();        
        List<Order_Request__c> OrdLst = [Select Name,Id,GH_Req_Number__c,CreatedBy.Name,CreatedDate,Additional_Comments__c,Business_Justification__c,Name_of_Recipient__c,Recipient_Name_List__c,Status__c,
                                            Is_Event_Request__c,Event_Date__c,Event_status__c,Event_Type__c,Number_of_people_for_event__c,(select id, Gift_Recipient__c from GH_Request_Recipients__r)
                                            from Order_Request__c where createdbyId =: userinfo.getuserId() and recordtypeid =: Label.GH_App_Request ORDER By CreatedDate DESC];
        if(OrdLst.size()>0) {
            for(Order_Request__c ORR: OrdLst) {
                MyOrderList.add(ORR);                
            }
        }
        return MyOrderList;
    }
    
    // Get Draft Record List
    @RemoteAction
    Public Static List<GH_Request_Recipient__c> DraftRecList(string DraftParentId) {
        if(DraftParentId != null && DraftParentId != '') {
            List<GH_Request_Recipient__c> RecipientList = [Select Id,Name,Company__c,City__c, Country__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,Gift_Business_Purpose_Other__c, ME_Business_Purpose_Other__c,
                                                           Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,Gift_Value_of_gift__c,Gift_Description__c, Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,
                                                           ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,ME_Value_of_Meals_Entertainment__c, ME_Description__c, ME_Business_Purpose__c, ME_Additional_Comments__c,
                                                           Name_of_Recipient__c,Name_of_Recipient_Lookup__c,Position__c,Score__c,Status__c,Type_of_Gift__c,Gift_Currency_Code__c, Gift_Value_Per_Currency__c, Meals_Currency_Code__c, Meals_Value_Per_Currency__c,Country_where_Gift_is_provided__c,Country_where_ME_is_provided__c,
                                                           Pro_Gift_Description__c, Pro_Gift_Embarrassing_If_Public__c, Pro_Gift_Manager_Approved_Gift__c, Pro_Gift_Occasion_Award_Placement__c, Pro_Gift_Occasion_Business_Meeting__c, Pro_Gift_Offered_To_Spouse__c, Pro_Gift_Solicited_By_You__c, Pro_Gift_Value_of_Gift__c, 
                                                           Pro_Meal_Description__c, Pro_ME_Embarrassing_If_Public__c, Pro_ME_Manager_Approved__c, Pro_ME_Occasion_Award_Placement__c, Pro_ME_Occasion_Business_Meeting__c, Pro_ME_Offered_To_Spouse__c, Pro_ME_Solicited_By_You__c, Pro_ME_Value_of_Meal_Entertainment__c, 
                                                           Pro_Gift_Currency_Code__c, Pro_Gift_Value_Per_Currency__c, Pro_Meals_Currency_Code__c, Pro_Meals_Value_Per_Currency__c, CreatedDate,Pro_Gift_Additional_Comments__c,Pro_ME_Additional_Comments__c, (select id, Name from Attachments)
                                                           from GH_Request_Recipient__c where GH_Request__c =: DraftParentId and recordtypeid =: Label.GH_App_Recipient_Provider_Rec_Type];
            return RecipientList;  
        }
        else {
            return null;
        }
    }
    
    // Get Draft Record Details
    @RemoteAction
    Public Static GH_Request_Recipient__c GetDraftDetails(string RecId) {
        if(RecId != null && RecId != '') {
            GH_Request_Recipient__c RecipientRec = [Select Id,Name,Company__c,Country__c,City__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,
                                                           Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,Gift_Value_of_gift__c,Gift_Description__c, Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,
                                                           ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,ME_Value_of_Meals_Entertainment__c, ME_Description__c, ME_Business_Purpose__c, ME_Additional_Comments__c,
                                                           Name_of_Recipient__c,Name_of_Recipient_Lookup__c,Position__c,Score__c,Status__c,Type_of_Gift__c,Gift_Currency_Code__c, Gift_Value_Per_Currency__c, Meals_Currency_Code__c, Meals_Value_Per_Currency__c,Country_where_Gift_is_provided__c,Country_where_ME_is_provided__c,
                                                           Pro_Gift_Description__c, Pro_Gift_Embarrassing_If_Public__c, Pro_Gift_Manager_Approved_Gift__c, Pro_Gift_Occasion_Award_Placement__c, Pro_Gift_Occasion_Business_Meeting__c, Pro_Gift_Offered_To_Spouse__c, Pro_Gift_Solicited_By_You__c, Pro_Gift_Value_of_Gift__c, 
                                                           Pro_Meal_Description__c, Pro_ME_Embarrassing_If_Public__c, Pro_ME_Manager_Approved__c, Pro_ME_Occasion_Award_Placement__c, Pro_ME_Occasion_Business_Meeting__c, Pro_ME_Offered_To_Spouse__c, Pro_ME_Solicited_By_You__c, Pro_ME_Value_of_Meal_Entertainment__c,
                                                           Pro_Gift_Currency_Code__c, Pro_Gift_Value_Per_Currency__c, Pro_Meals_Currency_Code__c, Pro_Meals_Value_Per_Currency__c, CreatedDate
                                                            from GH_Request_Recipient__c where id =: RecId and recordtypeid =: Label.GH_App_Recipient_Provider_Rec_Type];
            return RecipientRec;  
        }
        else {
            return null;
        }
    }
    
    // Get Draft Record Details
    @RemoteAction
    Public Static Order_Request__c GetRequestDetails(string RecId) {
        if(RecId != null && RecId != '') {
            Order_Request__c ghRequest = [select id, Name from Order_Request__c where id =: RecId];
            return ghRequest;  
        }
        else {
            return null;
        }
    }
    @RemoteAction
    public static List<SelectOption> GetTypeValues() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Order_Request__c.Type_of_Meals_Entertainment__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    @RemoteAction
    Public static Order_Request__c getOrderDetails(string RecId) {
        if(RecId != null && RecId != '') {
            Order_Request__c ODR = [Select Name,Id,CreatedBy.Name,RecordTypeId,RecordType.Name,CreatedDate,Additional_Comments__c,Business_Justification__c,Date__c,Name_of_Recipient__c,Recipient_Name_List__c,Status__c,Type_of_Meals_Entertainment__c from Order_Request__c where id =:RecId and recordtypeid =: Label.GH_App_Request Limit 1];
            return ODR;
        }
        else {
            return null;
        }
    }
    @RemoteAction
    public static string updateRequestStatus(Id reqId,Id newReqId, string statusReq, string reqNumber){
        Order_Request__c req = new Order_Request__c();
        
        req.Id = reqId;
        req.Status__c = statusReq;
        req.New_Version_GH_Request__c = newReqId;
        
        Order_Request__c newReq = new Order_Request__c();
        
        newReq.Id = newReqId;
        newReq.GH_Req_Number__c = reqNumber;
        
        try{
            update req;
            update newReq;
            return 'Success';
        }catch(Exception ex){
            return 'Failure --->' + ex.getMessage();
        }
        
    }
    @RemoteAction
    public static List<Contact> searchContact(String searchTerm) {
        
        List<contact> contacts = Database.query('Select Id, Name from Contact where name LIKE  \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC limit 1000');
        
        return contacts;
    }
    
    // Fetching Account list
    @RemoteAction
    public static List<Account> searchAccount(String searchTerm) {
        
        List<Account> Accounts = Database.query('Select Id, Name from Account where name LIKE  \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC limit 1000');
        
        return Accounts;
    }
    
    // Creating a new Contact
    @RemoteAction
    Public static Contact CreateContact(string ContactFirstName, string ContactLastName, string AccountId, string ContactEmail, string ContactPosition, string ContactCountry, string ContactCity) {
        Contact Con = new Contact();
        con.FirstName = ContactFirstName;
        con.LastName = ContactLastName;
        con.AccountId = AccountId;
        con.Email = ContactEmail;
        con.Title = ContactPosition;
        con.Country_Name__c = ContactCountry;
        con.City_Name__c = ContactCity;

        insert con;
        return con;
    }
    
    @RemoteAction
    public static List<Contact> getContactDetails(String searchId) {
        
        List<contact> contacts = Database.query('Select Id, Name, Account.Name,Country_Name__c,Title,City_Name__c from Contact where id = \'' + searchId + '\' ORDER BY Name ASC limit 1');
        
        return contacts;
    }
    
    @RemoteAction
    public static List<SelectOption> getCountryList() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Contact.Country_Name__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    // Currency Conversion via API
    
    /*@RemoteAction
    public static string ConvertTOUSDREST(string CurrencyCode){
        
        string ConvertURL = 'https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%3D%22'+CurrencyCode+'USD%22&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ConvertURL);
        req.setMethod('GET');
        Http requestHttp = new Http();
        HttpResponse res = requestHttp.send(req);         
        return res.getBody();
    }*/
    
    
    // Currency Conversion via Object
    @RemoteAction
    Public static List<GH_Currency_Convertor__c> FetchCurrency() {
        List<GH_Currency_Convertor__c> CurrencyList = [Select Id,Name,Currency_Code__c,Currency_Name__c,Daily_Equivalent_USD__c from GH_Currency_Convertor__c where RecordTypeId =: Label.GH_Currency_Rec_Type ORDER BY Currency_Name__c ASC Limit 1000];
        if(CurrencyList.size()>0) {
            return CurrencyList;
        }
        else {
            return null;
        }
    }
    
    @RemoteAction
    public static string ConvertTOUSD(string CurrencyCode) {
        if(CurrencyCode != '') {
            GH_Currency_Convertor__c Fetchrecord = [Select Id,Name,Currency_Code__c,Currency_Name__c,Daily_Equivalent_USD__c from GH_Currency_Convertor__c where RecordTypeId =: Label.GH_Currency_Rec_Type and Currency_Code__c =:CurrencyCode Limit 1000];
            return string.valueOf(Fetchrecord.Daily_Equivalent_USD__c);
        }
        else {
            return null;
        }
    }
    
    @RemoteAction
    public static string cancelRecipient(Id recipientId, string status){
        GH_Request_Recipient__c recipinet = new GH_Request_Recipient__c();
        recipinet.Id = recipientId;
        recipinet.status__c = status;
        try{
            update recipinet;    
            return 'Success';
        }catch(Exception ex){
            return 'Failure --->' + ex.getMessage();
        }
    }
    /*
    @RemoteAction
    Public Static void SendMailRequestor() {
        string [] RecipientList = Label.GH_Recipient_List.split(',');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setToAddresses(RecipientList);
        mail.setSubject('New GH Request has been submitted.');
        String  MailBody = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;">';
                MailBody +='<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                MailBody +='Hello Team,<br/><br/>';
                MailBody +='A GH request(002) has been submitted for approval. Request you to review. <br/><br/>';
                MailBody +='</div>';
                MailBody +='<div style=""><br/><br/>';
                MailBody +='<b>Following are the recipients for the request. </b><br/><br/>';
                MailBody +='</div>';
                MailBody +='<table style="border: 1px solid #ccc">';
                MailBody +='<tr><td>';
                MailBody +='<b>Rohit K.</b><br/>';
                MailBody +='<small>NTT Data, India</small>';
                MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">GIFTS</div>';
                MailBody +='</td>';
                MailBody +='<td style="padding-left: 20px;padding-right: 20px;background-color: #07BE07;color:#fff">';
                MailBody +='<b>22 Score</b>';
                MailBody +='</td>';
                MailBody +='</tr>';
                

                MailBody +='<tr style="background-color: #FAF6E4"><td>';
                MailBody +='<b>Andrew S.</b><br/>';
                MailBody +='<small>ABC, USA</small>';               
                MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">GIFTS</div>';
                MailBody +='</td><td style="padding-left: 20px;padding-right: 20px;background-color: #07BE07;color:#fff;text-align: center;">';
                MailBody +='<b>20 Score</b>';
                MailBody +='</td></tr>';
                
                MailBody +='<tr style="background-color: #FAF6E4;border-bottom: 1px solid #ccc"><td>';
                MailBody +='<b>Andrew S.</b><br/>';
                MailBody +='<small>ABC, USA</small>';                
                MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">MEALS/ENTERTAINMENT</div>';
                MailBody +='</td><td style="padding-left: 20px;padding-right: 20px;background-color: #07BE07;color:#fff">';
                MailBody +='<b>20 Score</b>';
                MailBody +='</td></tr>';
                

                MailBody +='<tr><td>';
                MailBody +='<b>Andrew S.</b><br/>';
                MailBody +='<small>ABC, USA</small>';
                MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">MEALS/ENTERTAINMENT</div>';
                MailBody +='</td><td style="padding-left: 20px;padding-right: 20px;background-color: red;color:#fff">';
                MailBody +='<b>33 Score</b>';
                MailBody +='</td><tr>';
                MailBody +='</table>';
                MailBody +='<div><br/><br/>';
                MailBody +='- GH App Communications';
                MailBody +='</div>';
        mail.setHtmlBody(MailBody);  
        mail.setOrgWideEmailAddressId('0D2300000008P9F');     
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
        // Sending acknowledgement to requestor
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        email.SetTargetobjectId(userinfo.getuserId());
        email.setSaveAsActivity(false);
        email.SetTemplateID('00Xc0000000MZ6S');
        email.setOrgWideEmailAddressId('0D2300000008P9F');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }*/

    /*
    @RemoteAction
    public Static void ApproveMail() {
        string [] RecipientList = Label.GH_Recipient_List.split(',');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setToAddresses(RecipientList);
        mail.setSubject('Approval Status for GH Request -002.');
         String MailBody = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;"> ';           
                MailBody += '<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                MailBody += 'Hello,<br/><br/>';
                MailBody += 'Below is the updated status of your request number <b>GH Request -002</b>.<br/><br/> ';      
                MailBody += '</div>';
                MailBody += '<div style=""><br/><br/>';
                MailBody += '<b>Following are the recipients and respective statuses. </b><br/><br/>';
                MailBody += '</div>';
                MailBody += '<table style="border: 1px solid #ccc">';
                MailBody += '<tr style="border-bottom: 1px solid #ccc"><td>';                
                MailBody += '<b>Rohit K.</b><br/>';
                MailBody += '<small>NTT Data, India</small>';
                MailBody += '<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">GIFTS</div>';
                MailBody += '</td>';
                MailBody += '<td style="padding-left: 20px;padding-right: 20px;background-color: #07BE07;color:#fff;text-align: center;">';
                MailBody += '<b>GO</b>';
                MailBody += '</td>';
                MailBody += '</tr>';
                

                MailBody += '<tr style="background-color: #FAF6E4;border-bottom: 1px solid #ccc"><td>';
                MailBody += '<b>Andrew S.</b><br/>';
                MailBody += '<small>ABC, USA</small>';
                MailBody += '<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">GIFTS</div>';
                MailBody += '</td><td style="padding-left: 20px;padding-right: 20px;background-color: #07BE07;color:#fff;text-align: center;">';
                MailBody += '<b>GO</b>';
                MailBody += '</td></tr>';
                MailBody += '<tr><td>';
                MailBody += '<tr style="background-color: #FAF6E4;border-bottom: 1px solid #ccc"><td>';
                MailBody += '<b>Andrew S.</b><br/>';
                MailBody += '<small>ABC, USA</small>';
                MailBody += '<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">MEALS/ENTERTAINMENT</div>';               
                MailBody += '</td><td style="padding-left: 20px;padding-right: 20px;background-color: #07BE07;color:#fff;text-align: center;">';
                MailBody += '<b>GO</b>';
                MailBody += '</td></tr>';
                

                MailBody += '<tr><td>';
                MailBody += '<b>Andrew S.</b><br/>';
                MailBody += '<small>ABC, USA</small>';
                MailBody += '<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">MEALS/ENTERTAINMENT</div>';
                MailBody += '</td><td style="padding-left: 20px;padding-right: 20px;background-color: red;color:#fff;text-align: center;">';
                MailBody += '<b>NO - GO</b>';
                MailBody += '</td><tr>';
                MailBody += '</table>';
                MailBody += '<div><br/><br/>';
                MailBody += '- GH App Communications'; 
                MailBody += '</div>';
                mail.setHtmlBody(MailBody);
                mail.setOrgWideEmailAddressId('0D2300000008P9F');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    */
    // To pull the Contact of logged in user
    @RemoteAction
    Public static Contact GetcontactId() {
        List<Contact> conList = [select id,accountid,email,name from contact where email =: UserInfo.getUserEmail() Limit 1];
        if(conList.size()> 0){
            return conList[0];
        }else{
            return null;
        }
    }
    
    //Create Recipient
    /*@RemoteAction
    Public Static GH_Request_Recipient__c createGHRecipient2(string RecipientName, string RecipientId, String Company, String DateCreated,  String Country, String Type, String additionalComments, string businessJustification ) {
        Order_Request__c ghRequest = GH_OrderRequest.createGHRequest(additionalComments, businessJustification); 
        if(ghRequest != null){
            
        
            GH_Request_Recipient__c ghRec = new GH_Request_Recipient__c();
            ghRec.Name_of_Recipient__c = RecipientName;
            ghRec.Company__c = Company;
            ghRec.Country__c = Country;
            if(DateCreated != null && DateCreated != '') {
                ghRec.Date__c = Date.ValueOf(DateCreated);
            }
            ghRec.Type_of_Gift__c = Type;
            ghRec.Status__c = 'Pending';
            ghRec.GH_Request__c = ghRequest.Id;
            
            try {
                upsert ghRec;
                return ghRec;
            }
            catch(exception e) {
                system.debug('Error is in expression: '+e);
            }
            return null;
        }
        return null;
    }*/
    
    /*@RemoteAction
    public static Order_Request__c createGHRequest(String additionalComments, string businessJustification){
        Order_Request__c ghRequest = new Order_Request__c();
        ghRequest.Additional_Comments__c = additionalComments;
        ghRequest.Business_Justification__c = businessJustification;
        
        try {
            upsert ghRequest;
            return ghRequest;
        }
        catch(exception e) {
            system.debug('Error is in expression: '+e);
        }
        return null;
    }*/
    
    
    @RemoteAction
    Public Static Order_Request__c createGHRecipient(List<GH_Request_Recipient__c> listOfRecipients, Order_Request__c ghRequest, List<GH_Request_Recipient__c> listOfRecipientsToDelete) {
        //Order_Request__c ghRequest = new Order_Request__c();
        system.debug('############################' + ghRequest.Status__c);
        system.debug('############################' + ghRequest.Id);
        
        upsert ghRequest;
        
        if(listOfRecipientsToDelete != null){
            if(listOfRecipientsToDelete.size() > 0){
                List<GH_Request_Recipient__c> listToDelete = new List<GH_Request_Recipient__c>();
                for(GH_Request_Recipient__c deleteRecipient : listOfRecipientsToDelete){
                    if(deleteRecipient.id != null){
                        listToDelete.add(deleteRecipient);
                    }
                }
                
                if(listToDelete.size() > 0){
                    delete listToDelete;
                }
            }
        }
        system.debug('############################');
        
        List<GH_Request_Recipient__c> listUpsertRecipient = new List<GH_Request_Recipient__c>();
        for(GH_Request_Recipient__c ghRecipient: listOfRecipients){
            system.debug('----->ID--->' + ghRecipient.Id);
            if(ghRecipient.GH_Request__c == null){
                ghRecipient.GH_Request__c = ghRequest.id;
            }
            listUpsertRecipient.add(ghRecipient);
        }
        
        if(listUpsertRecipient.size() > 0){
            upsert listUpsertRecipient;
        }

        system.debug('###########################venu' + ghRequest);
        return ghRequest;
                
       } 
    @RemoteAction
    Public Static RequestWithRecipients UpdatetotalAggregatevalues(Order_Request__c ghRequest) {

    
    List<GH_Request_Recipient__c> AggregateRecipientList = new List<GH_Request_Recipient__c>();
     Order_Request__c ghReqRecOrEvent = [Select Id,Name,Status__c,Is_Event_Request__c,Event_Date__c,Event_Type__c,Other_Event_Type__c  from Order_Request__c where id =: ghRequest.Id];
        system.debug('ghReqRecOrEvent.Is_Event_Request__c--------->' + ghReqRecOrEvent.Is_Event_Request__c);
        if(ghReqRecOrEvent.Is_Event_Request__c == false){
            List<GH_Request_Recipient__c> NewRecipientList = new List<GH_Request_Recipient__c>();
            //List<GH_Request_Recipient__c> AggregateRecipientList = new List<GH_Request_Recipient__c>();
            List<GH_Request_Recipient__c> RPList1 = [Select Id,Name,Company__c,Country__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,
                                                               Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,Gift_Value_of_gift__c,Gift_Description__c, Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,
                                                               ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,ME_Value_of_Meals_Entertainment__c, ME_Description__c, ME_Business_Purpose__c, ME_Additional_Comments__c,
                                                               Name_of_Recipient__c,Name_of_Recipient_Lookup__c,Gift_Twelve_Months_Aggregate_Value__c,ME_Twelve_Months_Aggregate_Value__c,Name_of_Recipient_Lookup__r.Email,Position__c,Score__c,Status__c,Type_of_Gift__c,Gift_Score__c,Meal_Score__c,Gift_Currency_Code__c, Gift_Value_Per_Currency__c, Meals_Currency_Code__c, Meals_Value_Per_Currency__c, CreatedDate from GH_Request_Recipient__c where GH_Request__c =:ghRequest.Id and recordtypeid =: Label.GH_App_Recipient_Provider_Rec_Type];
    
    system.debug('RPList1--->' + json.serializepretty(RPList1));
       if(RPList1.size() >0) {
                for(GH_Request_Recipient__c RL: RPList1) {
                    double totalGiftvalue = 0;
                    double totalMealvalue = 0;
                    if(RL.Name_of_Recipient_Lookup__r.Email != null && RL.Name_of_Recipient_Lookup__r.Email != ''){

                        String AeroResponse='';
                        if(Test.isRunningTest()){
                            AeroResponse = '{"totalSize": 1,"done": true,"records": [{"attributes": {"type": "Contact","url": "/services/data/v31.0/sobjects/Contact/0038000001UtlqIAAR"},"Id": "0038000001UtlqIAAR","GH_Request_Recipients__r": {"totalSize": 1,"done": true,"records": [{ "attributes": {"type": "GH_Request_Recipient__c","url": "/services/data/v31.0/sobjects/GH_Request_Recipient__c/a8Nn00000008PlJEAU"},"Id": "a8Nn00000008PlJEAU","Gift_Value_of_gift__c": 17.16,"ME_Value_of_Meals_Entertainment__c": null}]}}]}';    
                        }else
                            AeroResponse =  GHAppInterfaceRequestorFlow.getCurrentAggregatevalues(RL.Name_of_Recipient_Lookup__r.Email);





                        
                        if(AeroResponse!= null){
                            AeroResponse = AeroResponse.replaceall('Gift_Value_of_gift__c', 'Valueofgift');
                            AeroResponse = AeroResponse.replaceall('ME_Value_of_Meals_Entertainment__c', 'ValueofMeal');
                            AeroResponse = AeroResponse.replaceall('GH_Request_Recipients__r', 'GHRequestRecipients');
                            Aggregatedata FinalAeroresponse = new Aggregatedata();
                            JSONParser parser = JSON.createParser(AeroResponse);
                            while (parser.nextToken() != null) {
                                if (parser.getCurrentToken() == JSONToken.START_OBJECT){
                                    FinalAeroresponse = (Aggregatedata)parser.readValueAs(Aggregatedata.class);



                                    system.debug('FinalAeroresponse--->' + FinalAeroresponse);
                                        if(FinalAeroresponse.records != null){
                                        for(cont req:FinalAeroresponse.records){
                                            if(req.GHRequestRecipients != null){
                                                if(req.GHRequestRecipients.records != null && !req.GHRequestRecipients.records.isempty()){
                                                    for(Recipient rec:req.GHRequestRecipients.records){
                                                                
                                                   //system.debug('val' +val);


                                                        if(rec.Valueofgift!= null){
                                                              totalGiftvalue += double.valueOf(rec.Valueofgift);
                                                              system.debug('totalGiftvalue>>>>'+totalGiftvalue);


                                                        } 
                                                        if(rec.ValueofMeal!= null){
                                                              totalMealvalue += double.valueOf(rec.ValueofMeal);
                                                              system.debug('totalMealvalue>>>>'+totalMealvalue);







                                                       }
                                                   }


                                               }
                                          }
                                      }
                                    }

                                }
                            }
                        }

                       }
                        
                        
                    GHAppInstanceDetails__c ghPMTInstanceDetails = GHAppInstanceDetails__c.getValues('PMT');       
                    String PMTResponse = '';
                    if(test.isRunningTest()){
                        PMTResponse = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Contact","url":"/services/data/v31.0/sobjects/Contact/0038000001l1t9pAAA"},"Id":"0038000001l1t9pAAA","GH_Request_Recipients__r":{"totalSize":1,"done":true,"records":[{"attributes":{"type":"GH_Request_Recipient__c","url":"/services/data/v31.0/sobjects/GH_Request_Recipient__c/a8Nn00000008PPmEAM"},"Id":"a8Nn00000008PPmEAM","Gift_Value_of_gift__c":123.0}]}}]}';
                    }else PMTResponse = GHAppInterfaceRequestorFlow.getAggregatevalues(ghPMTInstanceDetails,RL.Name_of_Recipient_Lookup__r.Email);  

                        if(PMTResponse!= null){
                            PMTResponse = PMTResponse.replaceall('Gift_Value_of_gift__c', 'Valueofgift');
                            PMTResponse = PMTResponse.replaceall('ME_Value_of_Meals_Entertainment__c', 'ValueofMeal');
                            PMTResponse = PMTResponse.replaceall('GH_Request_Recipients__r', 'GHRequestRecipients');
                            Aggregatedata FinalPMTresponse = new Aggregatedata();
                            JSONParser parser1 = JSON.createParser(PMTResponse);
                            while (parser1.nextToken() != null) {
                                if (parser1.getCurrentToken() == JSONToken.START_OBJECT){
                                    FinalPMTresponse = (Aggregatedata)parser1.readValueAs(Aggregatedata.class);
                                    system.debug('FinalPMTresponse--->' + FinalPMTresponse);
                                    if(FinalPMTresponse.records != null){
                                    for(cont req:FinalPMTresponse.records){
                                        if(req.GHRequestRecipients!= null){
                                                if(req.GHRequestRecipients.records != null && !req.GHRequestRecipients.records.isempty()){
                                                   for(Recipient rec:req.GHRequestRecipients.records){
                                                    //system.debug('val' +val);
                                                    if(rec.Valueofgift!= null){
                                                        totalGiftvalue += double.valueOf(rec.Valueofgift);
                                                    } 

                                                        if(rec.ValueofMeal!= null){
                                                              totalMealvalue += double.valueOf(rec.ValueofMeal);

                                                        }
                                                        system.debug('rec' +rec.Valueofgift);





                                                   }
                                              }
                                          }
                                      }
                                }
                                }           
                            }
                        }
                        
                        GHAppInstanceDetails__c ghACSInstanceDetails = GHAppInstanceDetails__c.getValues('ACS');       
                        String ACSResponse = ''; 
                        if(test.isRunningTest()){
                            ACSResponse = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Contact","url":"/services/data/v31.0/sobjects/Contact/0038000001l1t9pAAA"},"Id":"0038000001l1t9pAAA","GH_Request_Recipients__r":{"totalSize":1,"done":true,"records":[{"attributes":{"type":"GH_Request_Recipient__c","url":"/services/data/v31.0/sobjects/GH_Request_Recipient__c/a8Nn00000008PPmEAM"},"Id":"a8Nn00000008PPmEAM","Gift_Value_of_gift__c":123.0}]}}]}';
                        }else ACSResponse= GHAppInterfaceRequestorFlow.getAggregatevalues(ghACSInstanceDetails,RL.Name_of_Recipient_Lookup__r.Email);  
                        if(ACSResponse!= null){
                            ACSResponse = ACSResponse.replaceall('Gift_Value_of_gift__c', 'Valueofgift');
                            ACSResponse = ACSResponse.replaceall('ME_Value_of_Meals_Entertainment__c', 'ValueofMeal');
                            ACSResponse = ACSResponse.replaceall('GH_Request_Recipients__r', 'GHRequestRecipients');
                            Aggregatedata FinalACSresponse = new Aggregatedata();
                            JSONParser parser2 = JSON.createParser(ACSResponse);
                            while (parser2.nextToken() != null) {
                                if (parser2.getCurrentToken() == JSONToken.START_OBJECT){
                                    FinalACSresponse = (Aggregatedata)parser2.readValueAs(Aggregatedata.class);
                                    system.debug('FinalACSresponse--->' + FinalACSresponse);
                                    if(FinalACSresponse.records != null){
                                    for(cont req:FinalACSresponse.records){
                                        if(req.GHRequestRecipients != null){
                                            if(req.GHRequestRecipients.records != null && !req.GHRequestRecipients.records.isempty()){
                                               for(Recipient rec:req.GHRequestRecipients.records){
                                                //system.debug('val' +val);
                                                    if(rec.Valueofgift!= null){
                                                        totalGiftvalue += double.valueOf(rec.Valueofgift);
                                                    } 
                                                    if(rec.ValueofMeal!= null){
                                                          totalMealvalue += double.valueOf(rec.ValueofMeal);
                                                    }
                                                    system.debug('rec' +rec.Valueofgift);

                                               }
                                            }
                                        }
                                    }
                                    }
                                }
                            }
                        }
                        
                        GHAppInstanceDetails__c ghTSInstanceDetails = GHAppInstanceDetails__c.getValues('TS');       
                        String TSResponse =  '';
                        if(test.isRunningTest()){
                            TSResponse = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Contact","url":"/services/data/v31.0/sobjects/Contact/0038000001l1t9pAAA"},"Id":"0038000001l1t9pAAA","GH_Request_Recipients__r":{"totalSize":1,"done":true,"records":[{"attributes":{"type":"GH_Request_Recipient__c","url":"/services/data/v31.0/sobjects/GH_Request_Recipient__c/a8Nn00000008PPmEAM"},"Id":"a8Nn00000008PPmEAM","Gift_Value_of_gift__c":123.0}]}}]}';
                        }else TSResponse = GHAppInterfaceRequestorFlow.getAggregatevalues(ghTSInstanceDetails,RL.Name_of_Recipient_Lookup__r.Email);

                       if(TSResponse!= null){
                            TSResponse = TSResponse.replaceall('Gift_Value_of_gift__c', 'Valueofgift');
                            TSResponse = TSResponse.replaceall('ME_Value_of_Meals_Entertainment__c', 'ValueofMeal');
                            TSResponse = TSResponse.replaceall('GH_Request_Recipients__r', 'GHRequestRecipients');
                            Aggregatedata FinalTSresponse = new Aggregatedata();
                            JSONParser parser3 = JSON.createParser(TSResponse);
                            while (parser3.nextToken() != null) {
                                if (parser3.getCurrentToken() == JSONToken.START_OBJECT){
                                    FinalTSresponse = (Aggregatedata)parser3.readValueAs(Aggregatedata.class);

                                    system.debug('FinalTSresponse--->' + FinalTSresponse);
                                    if(FinalTSresponse.records != null){
                                    for(cont req:FinalTSresponse.records){
                                        if(req.GHRequestRecipients != null){
                                            if(req.GHRequestRecipients.records != null && !req.GHRequestRecipients.records.isempty()){
                                                for(Recipient rec:req.GHRequestRecipients.records){
                                                    //system.debug('val' +val);
                                                    if(rec.Valueofgift!= null){
                                                        totalGiftvalue += double.valueOf(rec.Valueofgift);
                                                    } 
                                                    if(rec.ValueofMeal!= null){
                                                          totalMealvalue += double.valueOf(rec.ValueofMeal);
                                                    }
                                                    system.debug('rec' +rec.Valueofgift);

                                               }
                                            }
                                        }
                                    }
                                    }
                                }
                            }
                        } 
                        
                       GHAppInstanceDetails__c ghCorpInstanceDetails = GHAppInstanceDetails__c.getValues('Corp');       

                       String CorpResponse = '';
                         if(test.isRunningTest()){
                            CorpResponse = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Contact","url":"/services/data/v31.0/sobjects/Contact/0038000001l1t9pAAA"},"Id":"0038000001l1t9pAAA","GH_Request_Recipients__r":{"totalSize":1,"done":true,"records":[{"attributes":{"type":"GH_Request_Recipient__c","url":"/services/data/v31.0/sobjects/GH_Request_Recipient__c/a8Nn00000008PPmEAM"},"Id":"a8Nn00000008PPmEAM","Gift_Value_of_gift__c":123.0}]}}]}';
                        }else CorpResponse = GHAppInterfaceRequestorFlow.getAggregatevalues(ghCorpInstanceDetails,RL.Name_of_Recipient_Lookup__r.Email);    





                    if(CorpResponse!= null){
                            CorpResponse = CorpResponse.replaceall('Gift_Value_of_gift__c', 'Valueofgift');
                            CorpResponse = CorpResponse.replaceall('ME_Value_of_Meals_Entertainment__c', 'ValueofMeal');
                            CorpResponse = CorpResponse.replaceall('GH_Request_Recipients__r', 'GHRequestRecipients');
                            Aggregatedata FinalCorpresponse = new Aggregatedata();
                            JSONParser parser4 = JSON.createParser(CorpResponse);
                            while (parser4.nextToken() != null) {
                                if (parser4.getCurrentToken() == JSONToken.START_OBJECT){
                                    FinalCorpresponse = (Aggregatedata)parser4.readValueAs(Aggregatedata.class);

                                    system.debug('FinalCorpresponse--->' + FinalCorpresponse);
                                    if(FinalCorpresponse.records != null){
                                    for(cont req:FinalCorpresponse.records){
                                        if(req.GHRequestRecipients != null){
                                            if(req.GHRequestRecipients.records != null && !req.GHRequestRecipients.records.isempty()){
                                                for(Recipient rec:req.GHRequestRecipients.records){
                                                    //system.debug('val' +val);
                                                    if(rec.Valueofgift!= null){

                                                          totalGiftvalue += double.valueOf(rec.Valueofgift);
                                                    } 
                                                    if(rec.ValueofMeal!= null){
                                                          totalMealvalue += double.valueOf(rec.ValueofMeal);
                                                    }
                                                    system.debug('rec' +rec.Valueofgift);
                                                }
                                            }
                                        }
                                    }
                                    }
                                }
                            }

                        }                                      
                
                system.debug('totalGiftvalue--->' + totalGiftvalue);
                system.debug('totalMealvalue--->' + totalMealvalue);
                RL.Gift_Twelve_Months_Aggregate_Value__c = totalGiftvalue;
                RL.ME_Twelve_Months_Aggregate_Value__c = totalMealvalue;
                AggregateRecipientList.add(RL);
              } 
            }
            }
             if(AggregateRecipientList.size()>0){
                 update AggregateRecipientList;

              }
       

        RequestWithRecipients reqWithRecs = new RequestWithRecipients(); 
        reqWithRecs.ghRequest = ghRequest;
        //reqWithRecs.listOfRecipients = listOfRecipients;


        
        
        
        
        if(ghReqRecOrEvent.Is_Event_Request__c == false){
            List<GH_Request_Recipient__c> NewRecipientList = new List<GH_Request_Recipient__c>();
          

            List<GH_Request_Recipient__c> RPList = [Select Id,Name,Company__c,Country__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,
                                                               Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,Gift_Value_of_gift__c,Gift_Description__c, Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,
                                                               ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,ME_Value_of_Meals_Entertainment__c, ME_Description__c, ME_Business_Purpose__c, ME_Additional_Comments__c,
                                                               Name_of_Recipient__c,Name_of_Recipient_Lookup__c,Gift_Twelve_Months_Aggregate_Value__c,ME_Twelve_Months_Aggregate_Value__c,Name_of_Recipient_Lookup__r.Email,Position__c,Score__c,Status__c,Type_of_Gift__c,Gift_Score__c,Meal_Score__c,Gift_Currency_Code__c, Gift_Value_Per_Currency__c, Meals_Currency_Code__c, Meals_Value_Per_Currency__c, CreatedDate from GH_Request_Recipient__c where GH_Request__c =:ghRequest.Id and recordtypeid =: Label.GH_App_Recipient_Provider_Rec_Type];

            if(RPList.size() >0) {
                for(GH_Request_Recipient__c RL: RPList) {
                    NewRecipientList.add(RL);
                }
                reqWithRecs.listOfRecipients = NewRecipientList;
            }   
            string Requestnumber = '';
            Order_Request__c ThisRec = [Select Id,Name,Status__c,Is_Event_Request__c,Event_Date__c,Event_Type__c,Other_Event_Type__c  from Order_Request__c where id =:reqWithRecs.ghRequest.Id];
            if(ThisRec.Status__c != 'Draft'){
                if(ThisRec.Id != null) {
                    Requestnumber = ThisRec.Name;
                }
                
                system.debug('Is_Event_Request__c 1 >>>> Inside UpdatetotalAggregatevalues'+ ThisRec.Is_Event_Request__c);
                if(ThisRec.Is_Event_Request__c == false){

                    if(ThisRec.Status__c != 'Complete'){    
                        String  MailBody = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;">';
                                MailBody +='<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                                MailBody +='Hello,<br/><br/>';
                                MailBody +='Your request: ('+Requestnumber+') has been submitted. <br/><br/>';
                                MailBody +='</div>';
                                MailBody +='<div style=""><br/><br/>';
                                MailBody +='<b>Following are the recipients for the request. </b><br/><br/>';
                                MailBody +='</div>';
                                MailBody +='<table style="border: 1px solid #ccc">';
                        for(GH_Request_Recipient__c RL: RPList) {
                            string GiftMealVar = '';
                            String GiftMealStatus = '';

                            if(RL.Gifts__c == true && RL.Meals_Entertainment__c == false) {
                                GiftMealVar = 'GIFTS';
                                GiftMealStatus = string.valueOf(RL.Status__c);

                            }

                            if(RL.Gifts__c == false && RL.Meals_Entertainment__c == true) {
                                GiftMealVar = 'MEALS/ENTERTAINMENT';
                                GiftMealStatus = string.valueOf(RL.Status__c);
                            }

                            if(RL.Gifts__c == true && RL.Meals_Entertainment__c == true) {
                                GiftMealVar = 'GIFTS,MEALS/ENTERTAINMENT';
                                GiftMealStatus = string.valueOf(RL.Status__c);
                            }            
                            MailBody +='<tr style="border-bottom :1px solid #ccc !important;"><td>';
                            MailBody +='<b>'+RL.Name_of_Recipient__c+'</b><br/>';
                            MailBody +='<small>'+RL.Company__c+','+RL.Country__c+'</small>';
                            MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center;">'+GiftMealVar+'</div>';
                            MailBody +='</td>';
                            MailBody +='<td style="padding-left: 20px;padding-right: 20px;">';

                            MailBody +='<b>'+ GiftMealStatus +'</b>';
                            MailBody +='</td>';
                            MailBody +='</tr>';
                        }
                        MailBody +='</table>';
                        MailBody +='<div><br/><br/>';
                        MailBody +='- GH App Communications';
                        MailBody +='</div></div>';

                        String UserEmailAdd= ([Select Email From User where id = : userinfo.getuserId() limit 1]).Email;
                        string[] addressArray = new List<string>();
                        addressArray.add(UserEmailAdd);
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                        mail.setToAddresses(addressArray);
                        mail.setSubject('Approval Status for '+Requestnumber+'.');
                        mail.setHtmlBody(MailBody);  
                        mail.setOrgWideEmailAddressId(Label.GH_OrgWideEmailAddress); 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    }
                    system.debug('Order Status>>>' + ThisRec.Status__c);

                    String  MailBodyApprover = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;">';
                            MailBodyApprover +='<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                            MailBodyApprover +='Hello Team,<br/><br/>';
                            if(ThisRec.Status__c == 'Complete'){
                                MailBodyApprover +='A request: ('+Requestnumber+') has been <b>Auto Approved</b>. <br/><br/>';
                            }else{
                            MailBodyApprover +='A request: ('+Requestnumber+') has been submitted for approval. Request you to review. <br/><br/>';
                            }
                            MailBodyApprover +='</div>';
                            MailBodyApprover +='<div style=""><br/><br/>';
                            MailBodyApprover +='<b>Following are the recipients for the request. </b><br/><br/>';
                            MailBodyApprover +='</div>';
                            MailBodyApprover +='<table style="border: 1px solid #ccc">';
                    for(GH_Request_Recipient__c RL: RPList) {
                        string GiftMealVar = '';
                        string GiftMealStatus = '';

                        if(RL.Gifts__c == true && RL.Meals_Entertainment__c == false) {
                            GiftMealVar = 'GIFTS';
                            GiftMealStatus = string.valueOf(RL.Status__c);

                        }
                        if(RL.Gifts__c == false && RL.Meals_Entertainment__c == true) {
                            GiftMealVar = 'MEALS/ENTERTAINMENT';
                            GiftMealStatus = string.valueOf(RL.Status__c);

                        }
                        if(RL.Gifts__c == true && RL.Meals_Entertainment__c == true) {
                            GiftMealVar = 'GIFTS,MEALS/ENTERTAINMENT';
                            GiftMealStatus = string.valueOf(RL.Status__c);

                        }            
                        MailBodyApprover +='<tr  style="border-bottom :1px solid #ccc !important;"><td>';
                        MailBodyApprover +='<b>'+RL.Name_of_Recipient__c+'</b><br/>';
                        MailBodyApprover +='<small>'+RL.Company__c+','+RL.Country__c+'</small>';
                        MailBodyApprover +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center;">'+GiftMealVar+'</div>';
                        MailBodyApprover +='</td>';
                        MailBodyApprover +='<td style="padding-left: 20px;padding-right: 20px;">';
                        MailBodyApprover +='<b>'+ GiftMealStatus +'</b>';
                        MailBodyApprover +='</td>';
                        MailBodyApprover +='</tr>';
                    }
                    MailBodyApprover +='</table>';
                    MailBodyApprover +='<div><br/><br/>';
                    MailBodyApprover +='- GH App Communications';
                    MailBodyApprover +='</div></div>';
                    
                    
                    /*list<id> listToAddresses = new list<id>();
                    Group ghPolicyApprovers = [select (select userOrGroupId from groupMembers) from group where DeveloperName='GH_App_Approver' ];
                    for(GroupMember gm: ghPolicyApprovers.GroupMembers)
                        listToAddresses.add(gm.userOrGroupid);
                    
                    List<Messaging.SingleEMailMessage>  mails = new List<Messaging.SingleEMailMessage>(); 
                    if(listToAddresses.size() > 0){
                        for(Id uid : listToAddresses){
                            Messaging.SingleEMailMessage mailApprover = new Messaging.SingleEMailMessage();
                            mailApprover.setSubject('Approval Status for '+Requestnumber+'.');
                            mailApprover.setHtmlBody(MailBodyApprover);  
                            mailApprover.setTargetObjectId(uid);
                            mailApprover.setSaveAsActivity(false);
                            mailApprover.setOrgWideEmailAddressId(Label.GH_OrgWideEmailAddress);
                            mails.add(mailApprover);
                                    
                        }
                        try{
                            system.debug('sending mails---->');
                            Messaging.sendEmail(mails);
                            system.debug('mails sent---->');
                        }catch(Exception ex){
                            system.debug('Issue in sending Mails-->' + ex.getMessage());
                        }
                    }*/
                    String[] ApproverMailAddList = Label.GH_Recipient_List.split(',');
                    
                    Messaging.SingleEmailMessage mailApp = new Messaging.SingleEmailMessage(); 
                    mailApp.setToAddresses(ApproverMailAddList );
                    mailApp.setSubject('Approval Status for '+Requestnumber+'.');
                    mailApp.setHtmlBody(MailBodyApprover);  
                    mailApp.setOrgWideEmailAddressId(Label.GH_OrgWideEmailAddress); 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailApp});
                    
                }
            }
        }
        return reqWithRecs;
    }
    
    public class RequestWithRecipients{
        public Order_Request__c ghRequest;
        public List<GH_Request_Recipient__c> listOfRecipients;
    }
    
    // Approver page Logic Starts
    @RemoteAction
    Public Static List<Order_Request__c> ApproverRecList() {        
        List<Order_Request__c> MyOrderList = new List<Order_Request__c>();        
        List<Order_Request__c> OrdLst = [Select Name,Id,CreatedBy.Name,RecordTypeId,RecordType.Name,CreatedDate,Additional_Comments__c,Business_Justification__c,Date__c,Name_of_Recipient__c,Recipient_Name_List__c,Status__c,Type_of_Meals_Entertainment__c,(Select Id,Name,Company__c,Country__c,Date__c,Elected_Representative__c,GH_Request__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,
                                                           Gift_Line_Manager_Informed__c,Gift_Occasion_Business_Meeting__c,Gift_Recipient__c,Gifts__c,Gift_Value_of_gift__c,Gift_Description__c, Gift_Additional_Comments__c,Gift_Business_Purpose__c, Meals_Entertainment__c,ME_Frequency__c,
                                                           ME_Line_Manager_Informed__c,ME_Occasion_Award_Placement__c,ME_Occasion_Business_Meeting__c,ME_Travel_offered_to_spouse__c,ME_Travel_provided_to_government_officia__c,ME_Value_of_Meals_Entertainment__c, ME_Description__c, ME_Business_Purpose__c, ME_Additional_Comments__c,
                                                           Name_of_Recipient__c,Name_of_Recipient_Lookup__c,Position__c,Score__c,Status__c,Type_of_Gift__c,Gift_Currency_Code__c, Gift_Value_Per_Currency__c, Meals_Currency_Code__c, Meals_Value_Per_Currency__c, CreatedDate from GH_Request_Recipients__r) from Order_Request__c where OwnerId =: userinfo.getuserId() and recordtypeid =: Label.GH_App_Request ORDER By CreatedDate DESC];
        if(OrdLst.size()>0) {
            for(Order_Request__c ORR: OrdLst) {
                MyOrderList.add(ORR);                
            }
        }
        return MyOrderList;
    }
    
    
    @RemoteAction
    public static user searchUser() {   
       user u = [select id,SBU_User__c,SBG__c from user where id=:userinfo.getuserid()];

       return u;
    }
    
    @RemoteAction
    public static void updateUser(string sbu, string sbg) {   
       user u = [select id,SBU_User__c,SBG__c from user where id=:userinfo.getuserid()];
       if(u.SBU_User__c == null)
       u.SBU_User__c = sbu;
       if(u.SBG__c == null)
       u.SBG__c  = sbg;

       update u;
    }
    
    @RemoteAction
    public static Order_Request__c createEventRequest(Order_Request__c ghRequestEvent, Order_Request__c ghRequestEventModified) {
        
        if(ghRequestEvent != null){
            try{
                
                upsert ghRequestEvent;
            }catch(Exception ex){
                return null;
            }
        }   
        if(ghRequestEventModified != null){
            ghRequestEventModified.New_Version_GH_Request__c = ghRequestEvent.Id;
            try{
                update ghRequestEventModified;
                ghRequestEvent.GH_Req_Number__c = ghRequestEventModified.Name;
                system.debug('ghRequestEventModified.Name-->' + ghRequestEventModified.Name);
                update ghRequestEvent;
            }catch(Exception ex){
                return null;
            }
        }
        ghRequestEvent = [select id,Name, GH_Req_Number__c,Status__c, Is_Event_Request__c,Event_Date__c,Event_status__c,Event_Type__c,Number_of_people_for_event__c,Entertainment_Cost__c,
                                     Event_Additional_Comments__c, Event_Conducted_Country__c, Event_invited_to_government_official__c, Event_Total_cost_covered_in_currency__c, Event_Total_cost_covered_value__c, Event_Type_of_Currency__c,
                                     Flights_Cost__c, Gifts_Cost__c, Is_Event_within_SEA_guidelines__c, Local_Transportation_Cost__c, Meals_Cost__c, Other_Costs__c, Other_Cost_Type__c, Other_Event_Type__c, Accommodation_Cost__c,CreatedDate,
                                     Spouse_invited_to_Event__c, Visa_Cost__c from Order_Request__c where id =: ghRequestEvent.Id and recordtypeid =: Label.GH_App_Request limit 1];
        


        system.debug('Inside createEventRequest >>>>>ghRequestEvent.Is_Event_Request__c>>> '+ ghRequestEvent.Is_Event_Request__c);
        if(ghRequestEvent.Is_Event_Request__c == True){
            if(ghRequestEvent.event_status__c != 'Draft'){
                system.debug('Is_Event_Request__c 3 >>>>'+ ghRequestEvent.Is_Event_Request__c);
                String  MailBody = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;">';
                    MailBody +='<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                    MailBody +='Hello,<br/><br/>';
                    MailBody +='Your request: ('+ghRequestEvent.GH_Req_Number__c+') has been submitted. <br/><br/>';
                    MailBody +='</div>';
                    MailBody +='<div style=""><br/><br/>';
                    MailBody +='<b>Following is the Event for the request. </b><br/><br/>';
                    MailBody +='</div>';
                    MailBody +='<table style="border: 1px solid #ccc">';
                    string eventType = '';
                    if(ghRequestEvent.Event_Type__c == 'Other'){
                        eventType += ghRequestEvent.Event_Type__c + ' ('+ ghRequestEvent.Other_Event_Type__c +')';
                    }


                    else eventType=ghRequestEvent.Event_Type__c; 
                    MailBody +='<tr><td>';
                    MailBody +='<b>'+eventType+'</b><br/>';
                    MailBody +='<small>'+string.valueOf(ghRequestEvent.Event_Date__c ).replace('00:00:00','') +'</small>'; 
                    MailBody +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">Event</div>';
                    MailBody +='</td>';
                    MailBody +='</tr>';
                    MailBody +='</table>';
                    MailBody +='<div><br/><br/>';
                    MailBody +='- GH App Communications';
                    MailBody +='</div></div>';

                String UserEmailAdd= ([Select Email From User where id = : userinfo.getuserId() limit 1]).Email;
                string[] addressArray = new List<string>();
                addressArray.add(UserEmailAdd);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setToAddresses(addressArray);
                mail.setSubject('Approval Status for '+ghRequestEvent.GH_Req_Number__c+'.');
                mail.setHtmlBody(MailBody);  
                mail.setOrgWideEmailAddressId(Label.GH_OrgWideEmailAddress); 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                
                String  MailBodyApprover = '<div style="width: 900px; margin: auto; font-family: \'Calibri\', Helvetica, Arial, sans-serif;">';
                    MailBodyApprover +='<div style="padding: 20px 0px;border-bottom: 1px solid #ccc">';
                    MailBodyApprover +='Hello Team,<br/><br/>';
                    MailBodyApprover +='A request: ('+ghRequestEvent.GH_Req_Number__c+') has been submitted for approval. Request you to review. <br/><br/>';
                    MailBodyApprover +='</div>';
                    MailBodyApprover +='<div style=""><br/><br/>';
                    MailBodyApprover +='<b>Following is the Event for the request. </b><br/><br/>';
                    MailBodyApprover +='</div>';
                    MailBodyApprover +='<table style="border: 1px solid #ccc">';
                    string eventTypeApprover = '';
                    if(ghRequestEvent.Event_Type__c == 'Other'){
                        eventTypeApprover += ghRequestEvent.Event_Type__c + ' ('+ ghRequestEvent.Other_Event_Type__c +')';

                    }
                    else eventTypeApprover =ghRequestEvent.Event_Type__c; 
                    MailBodyApprover +='<tr><td>';
                    MailBodyApprover +='<b>'+ eventTypeApprover+'</b><br/>';
                    MailBodyApprover +='<small>'+string.valueOf(ghRequestEvent.Event_Date__c ).replace('00:00:00','') +'</small>';
                    MailBodyApprover +='<div style="background-color: #F7B235;color:#FFF;font-weight:bold;font-size:10px;text-align:center">Event</div>';
                    MailBodyApprover +='</td>';
                    MailBodyApprover +='</tr>';
                
                MailBodyApprover +='</table>';
                MailBodyApprover +='<div><br/><br/>';
                MailBodyApprover +='- GH App Communications';
                MailBodyApprover +='</div></div>';

                String[] ApproverMailAddList = Label.GH_Recipient_List.split(',');

                Messaging.SingleEmailMessage mailApp = new Messaging.SingleEmailMessage(); 
                mailApp.setToAddresses(ApproverMailAddList );
                mailApp.setSubject('Approval Status for '+ghRequestEvent.GH_Req_Number__c+'.');
                mailApp.setHtmlBody(MailBodyApprover);  
                mailApp.setOrgWideEmailAddressId(Label.GH_OrgWideEmailAddress); 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailApp});
            }
        }

        return ghRequestEvent;
    }
    
    @RemoteAction
    public static Order_Request__c getEventRequest(Id ghRequestEventId) {
        List<Order_Request__c> ghRequestEvent = new List<Order_Request__c>();
        if(ghRequestEventId != null){
            try{
                 ghRequestEvent = [select id,Name, GH_Req_Number__c,Is_Event_Request__c,Event_Date__c,Event_status__c,Event_Type__c,Number_of_people_for_event__c,Entertainment_Cost__c,
                                     Event_Additional_Comments__c, Event_Conducted_Country__c, Event_invited_to_government_official__c, Event_Total_cost_covered_in_currency__c, Event_Total_cost_covered_value__c, Event_Type_of_Currency__c,
                                     Flights_Cost__c, Gifts_Cost__c, Is_Event_within_SEA_guidelines__c, Local_Transportation_Cost__c, Meals_Cost__c, Other_Costs__c, Other_Cost_Type__c, Other_Event_Type__c, Accommodation_Cost__c,
                                     Spouse_invited_to_Event__c, Visa_Cost__c from Order_Request__c where id =: ghRequestEventId and recordtypeid =: Label.GH_App_Request];
            }catch(Exception ex){
                return null;
            }
        }   
        
        return ghRequestEvent[0];
    }
    
    @RemoteAction
    public static Order_Request__c getEventDraftRecord(Id ghRequestEventId) {
        List<Order_Request__c> ghRequestEvent = new List<Order_Request__c>();
        if(ghRequestEventId != null){
            try{
                 ghRequestEvent = [select id,Name,Is_Event_Request__c,Event_Date__c,Event_status__c,Event_Type__c,Number_of_people_for_event__c,Entertainment_Cost__c,
                                     Event_Additional_Comments__c, Event_Conducted_Country__c, Event_invited_to_government_official__c, Event_Total_cost_covered_in_currency__c, Event_Total_cost_covered_value__c, Event_Type_of_Currency__c,
                                     Flights_Cost__c, Gifts_Cost__c, Is_Event_within_SEA_guidelines__c, Local_Transportation_Cost__c, Meals_Cost__c, Other_Costs__c, Other_Cost_Type__c, Other_Event_Type__c, Accommodation_Cost__c,
                                     Spouse_invited_to_Event__c, Visa_Cost__c
                                  from Order_Request__c where id =: ghRequestEventId];
            }catch(Exception ex){
                return null;
            }
        }   
        
        return ghRequestEvent[0];
    }
    
    @RemoteAction
    public static string cancelEventRequest(Id eventId){
        if(eventId != null){
            Order_Request__c ghEventReq = new Order_Request__c();
            ghEventReq.Id = eventId;
            //ghEventReq.Status__c  = 'Cancel';
            ghEventReq.event_Status__c  = 'Cancel';
            try{
                update ghEventReq;
                return 'Success';
            }catch(Exception ex){
                system.debug('Error:' + ex.getMessage());
                return 'Failure -->' + ex.getMessage();
            }
        }
        return null;
    }
    
    @RemoteAction
    public static string DeleteRequestForSingleRecipient(id reqId){
        if(reqId != null){
            Order_Request__c reqToDelete = new Order_Request__c();
            reqToDelete.Id = reqId;
            
            try{
                delete reqToDelete;
                return 'Success';
            }catch(Exception ex){
                system.debug('Error-->' + ex.getMessage());
                return 'Failure';
            }
        }
        return 'Failure';
    }
    public class Aggregatedata{
            public string totalSize;               
            public string done;
            public List<cont> records;
    }
    public class cont{
            public attribute attributes;
            public string Id;
            public GHRequestRecipients GHRequestRecipients; 
    }
    public class GHRequestRecipients{
            public string totalSize;
            public string done;
            public List<Recipient> records;
    }
    
    public class Recipient{
            public attribute attributes;
            public string Id;
            public string Valueofgift; 
            public string ValueofMeal;
    }
    public class attribute{
        public string type;
        public string url;
    }
}