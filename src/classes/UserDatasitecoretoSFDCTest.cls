@isTest(seealldata=true)
global class UserDatasitecoretoSFDCTest{ 
    testMethod static void UserDatasitecoretoSFDCTest1()
    {
        Test.startTest();
        UserDatasitecoretoSFDC.UserData con = new UserDatasitecoretoSFDC.UserData();
        con.Useremail = 'H187749';               
        UserDatasitecoretoSFDC.UserDataSFDCtoSitecore contacttositecore = UserDatasitecoretoSFDC.Userdetails(con);
        
        UserDatasitecoretoSFDC.UserData con1 = new UserDatasitecoretoSFDC.UserData();
        con1.Useremail = 'H000001';               
        UserDatasitecoretoSFDC.UserDataSFDCtoSitecore contacttositecore1 = UserDatasitecoretoSFDC.Userdetails(con1);
        Test.stopTest();
    }
     testMethod static void UserDatasitecoretoSFDCTest2()
    {
        Test.startTest();
        UserDatasitecoretoSFDC.UserData con = new UserDatasitecoretoSFDC.UserData();
        con.Useremail = 'H187749';
        Contact conlst = [select Id,name, EMAIL, AccountID,FirstName, LastName, Portal_Company_Name__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Phone_1__c,Job_Title__c,RecordType.name,Account.Portal_Permissioned_Content__c,Account.Sbl_Account_Row_Id__c,(select id,Sbl_Account_Row_ID__c,Contact__c from Contact.Account_Contacts1__r) from contact where Honeywell_ID__c =: con.Useremail limit 1];
        List<UserDatasitecoretoSFDC.UserListDetails> userdatalist= new List<UserDatasitecoretoSFDC.UserListDetails>();       
        UserDatasitecoretoSFDC.UserListDetails conlist = new UserDatasitecoretoSFDC.UserListDetails();           
        conlist.SblRoles = conlst.Account.Sbl_Account_Row_Id__c;      
        userdatalist.add(conlist);
        //con.Userdetailslst = userdatalist;         
        UserDatasitecoretoSFDC.UserDataSFDCtoSitecore contacttositecore = UserDatasitecoretoSFDC.Userdetails(con);
        Test.stopTest();
    }   
}