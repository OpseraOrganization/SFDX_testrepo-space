@istest(seealldata=true)

private class BGAMob_Batch{


    BGAMob_Batch()
    {
    }
    
    static testMethod void myBatch() 
    {
    
    Account acc= new Account(name='Test Account');
        insert acc;
      Account_Address__c accadd=new Account_Address__c ();
           accadd.BGAMob_Country_Nm__c='India';
           accadd.BGAMob_State_Province__c='Chennai';
           accadd.account_name__c = acc.id;
           insert accadd;
           AccountAddressPlot objacc = new AccountAddressPlot();
             Account_Address__c  objaccnt= [Select Id,Report_Account_name__c,BGAMob_Geo_Code__Latitude__s,BGAMob_Geo_Code__Longitude__s ,BGAMob_Contact_Name__c,Avionics_Support_Level__c,Engine_Authorization__c,BGAMob_Contact_Email__c,Mechanical_Product_Lines__c,BGAMob_Customer_Phone__c,BGAMob_Address_1__c,BGAMob_Address_2__c,BGAMob_Address_3__c,BGAMob_City_Name__c,BGAMob_State_Province__c,BGAMob_Postal_Code__c,BGAMob_Country_Nm__c, Authorized_Avionics_Dealer__c,Authorized_Mechanical_Service_Center__c,Mobile_App_Visibility__c from Account_Address__c where  Mobile_App_Visibility__c=true limit 1];
           AccountAddressPlot.updatelocation(objaccnt.Id,-34.4938049,-58.6272715);
    }
    
    }