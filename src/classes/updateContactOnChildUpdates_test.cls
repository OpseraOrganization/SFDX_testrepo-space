@isTest

public class updateContactOnChildUpdates_test{
    static testMethod void insertUAA() {
    Test.startTest();
    //Insert Platform //
    Platform__c p = new Platform__c(Name='Dassault Aviation Falcon 900 B',Platform_Type__c= 'Airplane',Managing_SBU__c='BGA');
    insert p; 
    
    //Insert Fleet_Asset_Aircraft //
    Fleet_Asset_Detail__c FAA= new Fleet_Asset_Detail__c();
    FAA.Name='TEST-Boeing 737-100 S=1234';
    FAA.Serial_Number__c ='12345';
    FAA.Platform_Name__c=p.Id;
    insert FAA;
    
    //Insert Contact //
    Contact con = new Contact();
    Con.FirstName='Test' ;
    Con.LastName = 'Contact';
    insert con ;
     
    //Insert User_Aircraft_Association__c //
    User_Aircraft_Association__c UAA = new User_Aircraft_Association__c ();
    UAA.Fleet_Asset_Aircraft_Name__c=  FAA.Id;
    UAA.User__c= con.Id;
    insert UAA;
    Test.stopTest();
    
    }
    
    static testMethod void insertRSP()
    {
    Test.startTest();
     //Insert Master Service Program//
    Master_Service_Program__c MSP = new Master_Service_Program__c();
    MSP.Name ='Flight Services Test Record';
    insert MSP;
    
    //Insert Contact //
    Contact cont = new Contact();
    cont .FirstName='Test1' ;
    cont .LastName = 'Contact1';
    insert cont ;
    
    //Insert Restricetd Service
    Restricted_Service_Program__c RSP = new Restricted_Service_Program__c ();
    RSP.Master_Service_Program_Name__c= MSP.Id;
    RSP.User__c= cont.Id;
    insert RSP;
    Test.stopTest();
    }
    
    static testMethod void deleteRSP()
    {
        Test.startTest();
    Master_Service_Program__c MSP = new Master_Service_Program__c();
    MSP.Name ='Flight Services Test Record';
    insert MSP;
    
   
    Contact cont = new Contact();
    cont .FirstName='Test1' ;
    cont .LastName = 'Contact1';
    insert cont ;
    
    //Delete Restricetd Service
    Restricted_Service_Program__c RSP = new Restricted_Service_Program__c ();
    RSP.Master_Service_Program_Name__c= MSP.Id;
    RSP.User__c= cont.Id;
    insert RSP;
    delete  RSP;
     Test.stopTest();
    }
    static testMethod void deleteUAA()
    
    {
    Test.startTest();
    //Delete Platform record//
    Platform__c p = new Platform__c(Name='Dassault Aviation Falcon 900 B',Platform_Type__c= 'Airplane',Managing_SBU__c='BGA');
    insert p; 
    
    
    Fleet_Asset_Detail__c FAA= new Fleet_Asset_Detail__c();
    FAA.Name='TEST-Boeing 737-100 S=1234';
    FAA.Serial_Number__c ='12345';
    FAA.Platform_Name__c=p.Id;
    insert FAA;
    
    
    Contact con = new Contact();
    Con.FirstName='Test' ;
    Con.LastName = 'Contact';
    insert con ;
     
    //Delete User_Aircraft_Association__c //
    User_Aircraft_Association__c UAA = new User_Aircraft_Association__c ();
    UAA.Fleet_Asset_Aircraft_Name__c=  FAA.Id;
    UAA.User__c= con.Id;
    insert UAA;
    delete UAA;
    Test.stopTest();
    
    }
    static testMethod void updateContact() {
    Test.startTest();
    //Insert Platform //
    Platform__c p = new Platform__c(Name='Dassault Aviation Falcon 900 B',Platform_Type__c= 'Airplane',Managing_SBU__c='BGA');
    insert p; 
    
    //Insert Fleet_Asset_Aircraft //
    List<Fleet_Asset_Detail__c> FAAList= new List<Fleet_Asset_Detail__c>();
    Fleet_Asset_Detail__c FAA= new Fleet_Asset_Detail__c();
    FAA.Name='TEST-Boeing 737-100 S=1234';
    FAA.Serial_Number__c ='12345';
    FAA.Platform_Name__c=p.Id;
        FAAList.add(FAA);
        Fleet_Asset_Detail__c FAA1= new Fleet_Asset_Detail__c();
    FAA1.Name='TEST-Boeing 737-100 S=12341';
    FAA1.Serial_Number__c ='12345';
    FAA1.Platform_Name__c=p.Id;
        FAAList.add(FAA1);
    insert FAAList;
    
    //Insert Contact //
    Contact con = new Contact();
    Con.FirstName='Test' ;
    Con.LastName = 'Contact';
    insert con ;
        con.Access__c = 'Full Access';
        update con;
     
    //Insert User_Aircraft_Association__c //
    List<User_Aircraft_Association__c> UAAList = new List<User_Aircraft_Association__c>();
    User_Aircraft_Association__c UAA = new User_Aircraft_Association__c ();
    UAA.Fleet_Asset_Aircraft_Name__c=  FAA.Id;
    UAA.User__c= con.Id;
        UAAList.add(UAA);
    User_Aircraft_Association__c UAA1 = new User_Aircraft_Association__c ();
    UAA1.Fleet_Asset_Aircraft_Name__c=  FAA1.Id;
    UAA1.User__c= con.Id;
        UAAList.add(UAA1);
    insert UAAList;
    con.Access__c = 'No Access';
        update con;    
    Test.stopTest();
    
    }
    }