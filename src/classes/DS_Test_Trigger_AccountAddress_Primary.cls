/** * File Name: DS_Test_Trigger_AccountAddress_Primary
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
Public class DS_Test_Trigger_AccountAddress_Primary{
    static testMethod void AccountAddress_PrimaryAddress_Test(){
        List <Id>accId=new List <Id>();   
        List<Account> accAdd=new List <Account> (); 
        Account_Address__c add=new Account_address__c();
        Account_Address__c add1=new Account_address__c();
        Account_Address__c add2=new Account_address__c();
        Account_Address__c add3=new Account_address__c();
        Account_Address__c add4=new Account_address__c();        
        list<Account_Address__c> Addr = new List<Account_Address__c>();
        Map<String,Account_Address__c>addressDetails=new Map<String,Account_Address__c>();
        Map <Id,Id>accAddrssmpId=new Map <Id,Id>();
        List <Id>delAccId=new List <Id>();
        
        Account acc=new Account();
        acc.name='Sample Acc';
        acc.Address_Line_1__c = '';
        acc.Address_Line_2__c = '';
        acc.Address_Line_3__c = '';
        acc.City_Name__c = '';
        acc.Postal_Code__c = '';
        acc.State_Code__c = '';
        acc.Country_Name__c = '';
        insert acc;
        
        Account acc1=new Account();
        acc1.name='Sample Acc1';
        acc1.Address_Line_1__c = '';
        acc1.Address_Line_2__c = '';
        acc1.Address_Line_3__c = '';
        acc1.City_Name__c = '';
        acc1.Postal_Code__c = '';
        acc1.State_Code__c = '';
        acc1.Country_Name__c = '';
        insert acc1;
         
        add.Is_Primary_Address__c=false;
        add.account_name__c=acc.id;
        add.Report_Country_Codes__c='AN';
        insert add;
        delAccId.add(add.id);
        add1.Is_Primary_Address__c=false;
        add1.account_name__c=acc.id;
        add1.Report_Country_Codes__c='AN';
        insert add1;
        delAccId.add(add1.id);
        
        add2.Is_Primary_Address__c=true;
        add2.account_name__c=acc.id;
        add2.Report_Country_Codes__c='AN';
        insert add2;
        accId.add(add2.Account_Name__c );
        addressDetails.put(add2.Account_Name__c, add2);
        accAddrssmpId.put(add2.Id,add2.Id);
         system.assertequals(true,add2.Is_Primary_Address__c);
         
        add4.Is_Primary_Address__c=true;
        add4.account_name__c=acc1.id;
        add4.Report_Country_Codes__c='AN';
        insert add4;
        accId.add(add4.Account_Name__c );
        addressDetails.put(add4.Account_Name__c, add4);
        accAddrssmpId.put(add4.Id,add4.Id);
        system.assertequals(true,add2.Is_Primary_Address__c);
        
        add2.Is_Primary_Address__c=false;
        update add2;
        delAccId.add(add2.id);
        
        add3.account_name__c=acc.id;
        add3.Report_Country_Codes__c='AN';
        insert add3;
        accId.add(add3.Account_Name__c );
        addressDetails.put(add3.Account_Name__c, add3);
        accAddrssmpId.put(add3.Id,add3.Id);
        
        System.Debug('ADDR'+addr);
        System.Debug('ACCID'+accId);
        System.Debug('Accid[0]'+accid[0]);
        add4.account_name__c=accid[0];
        update add4;
        System.Debug('ADDR1'+addr);
       
    }
}