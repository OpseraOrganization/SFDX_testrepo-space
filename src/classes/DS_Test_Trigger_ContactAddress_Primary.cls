/** * File Name: DS_Test_Trigger_ContactAddress_Primary
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
Public class DS_Test_Trigger_ContactAddress_Primary{
    static testMethod void ContactAddress_PrimaryAddress_Test(){
        List <Id>accId=new List <Id>();   
        List<Contact> accAdd=new List <Contact> (); 
        Contact_Address__c add=new Contact_address__c();
        Contact_Address__c add1=new Contact_address__c();
        Contact_Address__c add2=new Contact_address__c();
        Contact_Address__c add3=new Contact_address__c();
        Contact_Address__c add4=new Contact_address__c();        
        list<Contact_Address__c> Addr = new List<Contact_Address__c>();
        Map<String,Contact_Address__c>addressDetails=new Map<String,Contact_Address__c>();
        Map <Id,Id>accAddrssmpId=new Map <Id,Id>();
        List <Id>delAccId=new List <Id>();
        
        Contact acc=new Contact();
        acc.Lastname='Sample Contact';
        acc.firstname='Sample';
        acc.Address_Line_1__c = '';
        acc.Address_Line_2__c = '';
        acc.Address_Line_3__c = '';
        acc.City_Name__c = '';
        acc.Postal_Code__c = '';
        acc.State_Code__c = '';
        acc.Country_Name__c = '';
        acc.phone_3__c='89099';
        insert acc;
        
        Contact acc1=new Contact();
        acc1.Lastname='Sample Contact1';
        acc1.firstname='Sample';
        acc1.Address_Line_1__c = '';
        acc1.Address_Line_2__c = '';
        acc1.Address_Line_3__c = '';
        acc1.City_Name__c = '';
        acc1.Postal_Code__c = '';
        acc1.State_Code__c = '';
        acc1.Country_Name__c = '';
        acc1.phone_3__c='89097';
        insert acc1;
         
        add.Is_Primary_Address__c=false;
        add.Contact__c=acc.id;
        add.Report_Country_codes__c='AN';
        add.Reporting_City_Name__c='AN';
        add.Reporting_Street_Address_Line_1__c='test';
     //   add.Report_Address_Names__c='Sample Report Country Name';
        insert add;
        delAccId.add(add.id);
        add1.Is_Primary_Address__c=false;
        add1.Contact__c=acc.id;
        add1.Report_Country_codes__c='AN';
        add1.Reporting_City_Name__c='AN';
        add1.Reporting_Street_Address_Line_1__c='test';

    //    add1.Report_Address_Names__c='Sample Report Country Name4';
        insert add1;
        delAccId.add(add1.id);
        
        add2.Is_Primary_Address__c=true;
        add2.Contact__c=acc.id;
        add2.Report_Country_codes__c='AN';
        add2.Reporting_City_Name__c='AN';
        add2.Reporting_Street_Address_Line_1__c='test';

      //  add2.Report_Address_Names__c='Sample Report Country Name1';
        insert add2;
        system.assertequals(true,add2.Is_Primary_Address__c);
        
        accId.add(add2.Contact__c );
        addressDetails.put(add2.Contact__c, add2);
        accAddrssmpId.put(add2.Id,add2.Id);
        
        add4.Is_Primary_Address__c=true;
        add4.Contact__c=acc1.id;
        add4.Report_Country_codes__c='AN';
        add4.Reporting_City_Name__c='AN';
        add4.Reporting_Street_Address_Line_1__c='test';

    //    add4.Report_Address_Names__c='Sample Report Country Name2';
        insert add4;
        system.assertequals(true,add4.Is_Primary_Address__c);
        accId.add(add4.Contact__c );
        addressDetails.put(add4.Contact__c, add4);
        accAddrssmpId.put(add4.Id,add4.Id);

        add2.Is_Primary_Address__c=false;
        update add2;
        delAccId.add(add2.id);
        
        add3.Contact__c=acc.id;
        add3.Report_Country_codes__c='AN';
        add3.Reporting_City_Name__c='AN';
        add3.Reporting_Street_Address_Line_1__c='test';

      //  add3.Report_Address_Names__c='Sample Report Country Name3';
        insert add3;
        accId.add(add3.Contact__c );
        addressDetails.put(add3.Contact__c, add3);
        accAddrssmpId.put(add3.Id,add3.Id);
        
        System.Debug('ADDR'+addr);
        System.Debug('ACCID'+accId);
        System.Debug('Accid[0]'+accid[0]);
        add4.Contact__c=accid[0];
        update add4;
        System.Debug('ADDR1'+addr);
    }
}