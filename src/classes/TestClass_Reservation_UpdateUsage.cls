@isTest(SeeAllData=true)
public class TestClass_Reservation_UpdateUsage 
{
 
static testMethod void Method_Delete()
{
  
    Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
    test.starttest();
    insert acc;
    test.stoptest();
    
    Contact cont = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E125687',
        Honeywell_ID__c = '01499xxx40331',            
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont; 

    Product2 objprod = new Product2(
        name='Test Product',
        SBU__c = 'ATR'
    );
    insert objprod;

    Location__c objloc = new Location__c(
        name='Test Location',
        region__c='Asia',
        City__c='Test city',
        Country__c='Test Country',
        Postal_Code__c='12223',
        State__c='Test state'
    );
    insert objloc;

    Class__c objclass = new Class__c(
        class_name__c='Test Class',
        Course_Name__c=objprod.id,
        Location__c=objloc.id,
        ATR_Flag__c = true,
        Start_Date__c = system.today() //just added
    );
    insert objclass;
    
    Id TrainingContractsRTId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Training Contracts').getRecordTypeId();
    Contract objcontract1 = new Contract(
        name='Test Contract',Account__c = acc.id, 
        accountid = acc.id,
        Recordtypeid = TrainingContractsRTId
    );
    insert objcontract1;

    Entitlement__c objent = new Entitlement__c(
        Contract_Number__c = objcontract1.id,
        Entitlement_Start_Date__c=System.today(),
        End_Date__c=System.today(),
        Status__c='Active',
        Course__c = objprod.id,
        Number_Of_Seats__c=0.0,
        Usage_Cap__c =1.0, 
        Usage_Count__c =0.0, 
        Usage_Percent__c=0.0,
        IsMultiple__c = false // added
    );
    insert objent ;

    Reservation__c objReserv  = new Reservation__c(
        Class_Name__c = objclass.id,
        Reservation_Status__c = 'Confirmed',
        Attended__c = 'No Show',
        Student__c = cont.id
    );
    insert objReserv;

    //objReserv.Reservation_Status__c ='Cancel';
    // update objReserv;
    TriggerCheck.firstRun = true;
    TriggerCheck.firstAtrRun = true;

    delete objReserv;
     
  }
    
     static testMethod void Method_Delete1()
  {
      
      Location__c loc = new Location__c();
     loc.name='Ramapuram';
     loc.City__c='che';
     loc.State__c='TN';
     loc.Postal_Code__c='600089';
     loc.Country__c='India';
     loc.Region__c='Asia';
     loc.CurrencyIsoCode='EUR';
     insert loc;
      
      Product2 pd = new Product2 ();
     pd.name = 'Test';
      pd.SBU__c = 'ATR';
     insert pd;
      pd.SBU__c = 'ATR';
      update pd; 
      
       Account acc =new Account();
     acc.name='Test';
     insert acc;
      
       Contact con = new Contact();
     con.lastname='test';
     con.AccountId = acc.id;
    // con.Customer_Portal_UserId__c= uid;
    // con.Honeywell_ID__c = 'sbc2008';
     insert con;
      
         Class__c cls = new Class__c();
     cls.Class_Name__c= 'test';//pd.id;
      //cls.SBU__c = 'ATR';
     //cls.Contact__c = con.id;
     cls.Course_Name__c=pd.id;
     cls.ATR_Flag__c =True;
     cls.Description__c='test';
     cls.CurrencyIsoCode = 'EUR';
	 cls.End_Date__c=system.today();
     cls.Start_Date__c=system.today();
     //cls.Product_Per_Student_Price__c='515';
     //cls.Course__c= 'Eng';
     cls.Location__c= loc.id;
     //cls.Duration__c='10'
     //cls.Seats_Remaining__c=10;
     //clslist.add(cls);
     insert cls;
      
      cls.ATR_Flag__c =false;
      update cls;
      
     /* Class__c cls = new Class__c();
      cls.Name = '';
      cls.Start_Date__c = ;
      cls.Total_Number_of_Seats__c = 20;
      cls.CurrencyIsoCode = 'EUR';
      cls.Course_Name__c = pd.id;
      cls.*/
      /* RecordType rtp = new RecordType();
      rtp.Name= 'Training Contracts';
      rtp.DeveloperName = 'Training_Contracts';
      rtp.IsActive = True;
      rtp.SobjectType = 'Contract';
      insert rtp;*/
      
      Id stExam = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Training Contracts').getRecordTypeId();
      contract contr = new contract();
      contr.name = 'Contract Test';
      contr.Type__c = 'APM';
      contr.Contract_Number_I_Many__c = 'Test number';
      contr.Asset_Program__c = 'Yes';
      contr.Status = 'Draft';
      contr.StartDate = system.today();
      contr.Revision__c = 'test';
      contr.Currency__c = 'ARS';
      contr.CurrencyIsoCode = 'EUR';
      contr.AccountId= acc.id;
      contr.RecordTypeId =stExam;
      insert contr;
      
       Entitlement__c objent = new Entitlement__c(
        Contract_Number__c = contr.id,
        Entitlement_Start_Date__c= null,
        End_Date__c=System.today(),
        Status__c='Active',
        Course__c = pd.id,
        Number_Of_Seats__c=1.0,
        Usage_Cap__c =1.0, 
        Usage_Count__c =1.0, 
        Usage_Percent__c=0.0,
        IsMultiple__c = false // added
    );
    insert objent ;
      
           test.startTest();
     // List<Reservation__c> reslist = new List<Reservation__c>();
      
      Reservation__c res = new Reservation__c();
     //res.name='Test';Student
     res.Attended__c ='Attended/Update';
     res.CurrencyIsoCode = 'EUR';
     res.Reservation_Type__c = 'Student';
     res.Reservation_Status__c = 'Ignored' ;
     res.Student__c = con.id;
     res.Class_Name__c = cls.id;
    // res.Student_Name__c = 'SURYA';
     //res.Class__c = cls.id;
    // reslist.add(res);
     insert res;
      res.Attended__c = 'No Show/Confirmed';
      //res.Reservation_Status__c = 'Confirmed';
      res.Reservation_Status__c = 'Confirmed';
     // res.Reservation_Status__c = 'Registered';
         
      update res;
      //delete res;
       test.stopTest();

  }
    
    
    
    //-=================================================================================================================== 2nd Method started from here.
     static testMethod void Method_1()
  {
      
      Location__c loc = new Location__c();
     loc.name='Ramapuram';
     loc.City__c='che';
     loc.State__c='TN';
     loc.Postal_Code__c='600089';
     loc.Country__c='India';
     loc.Region__c='Asia';
     loc.CurrencyIsoCode='EUR';
     insert loc;
      
      Product2 pd = new Product2 ();
     pd.name = 'Test';
      pd.SBU__c = 'ATR';
     insert pd;
      
       Account acc =new Account();
     acc.name='Test';
     insert acc;
      
       Contact con = new Contact();
     con.lastname='test';
     con.AccountId = acc.id;
    // con.Customer_Portal_UserId__c= uid;
    // con.Honeywell_ID__c = 'sbc2008';
     insert con;
      
         Class__c cls = new Class__c();
     cls.Class_Name__c= 'test';//pd.id;
      //cls.SBU__c = 'ATR';
     //cls.Contact__c = con.id;
     cls.Course_Name__c=pd.id;
     cls.ATR_Flag__c =True;
     cls.Description__c='test';
     cls.CurrencyIsoCode = 'EUR';
	 cls.End_Date__c=system.today();
     cls.Start_Date__c=system.today();
     //cls.Product_Per_Student_Price__c='515';
     //cls.Course__c= 'Eng';
     cls.Location__c= loc.id;
     //cls.Duration__c='10'
     //cls.Seats_Remaining__c=10;
     //clslist.add(cls);
     insert cls;
      
      cls.ATR_Flag__c =false;
      update cls;
      
     /* Class__c cls = new Class__c();
      cls.Name = '';
      cls.Start_Date__c = ;
      cls.Total_Number_of_Seats__c = 20;
      cls.CurrencyIsoCode = 'EUR';
      cls.Course_Name__c = pd.id;
      cls.*/
      
       Id stExam = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Training Contracts').getRecordTypeId();
      List<contract> contrlst = new List<contract>();
      contract contr = new contract();
      contr.name = 'Contract Test';
      contr.Type__c = 'APM';
      contr.Contract_Number_I_Many__c = 'Test number';
      contr.Asset_Program__c = 'Yes';
      contr.Status = 'Draft';
      contr.StartDate = system.today();
      contr.Revision__c = 'test';
      contr.Currency__c = 'ARS';
      contr.CurrencyIsoCode = 'EUR';
      contr.AccountId= acc.id;
      contr.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr);
      
       contract contr1 = new contract();
      contr1.name = 'Contract Test';
      contr1.Type__c = 'APM';
      contr1.Contract_Number_I_Many__c = 'Test number';
      contr1.Asset_Program__c = 'Yes';
      contr1.Status = 'Draft';
      contr1.StartDate = system.today()+1;
      contr1.Revision__c = 'test';
      contr1.Currency__c = 'ARS';
      contr1.CurrencyIsoCode = 'EUR';
      contr1.AccountId= acc.id;
      contr1.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr1);
      insert contrlst;
      
       Entitlement__c objent = new Entitlement__c(
        Contract_Number__c = contr.id,
        Entitlement_Start_Date__c= system.today(),
        End_Date__c=System.today(),
        Status__c='Active',
           Comments__c = 'test comments',
        Course__c = pd.id,
        Number_Of_Seats__c=1.0,
        Usage_Cap__c =1.0, 
        Usage_Count__c =0.0, 
        Usage_Percent__c=0.0,
        IsMultiple__c = false // added
    );
    insert objent ;
      test.startTest();
      Reservation__c res = new Reservation__c();
     //res.name='Test';Student
     res.Attended__c ='Yes';
     res.CurrencyIsoCode = 'EUR';
     res.Reservation_Type__c = 'Student';
     res.Reservation_Status__c = 'Wait List' ;
     res.Student__c = con.id;
     res.Class_Name__c = cls.id;
      res.Entitlement__c = objent.id;
    // res.Student_Name__c = 'SURYA';
     //res.Class__c = cls.id;
     insert res;
     // res.Attended__c ='No';
     // update res;
     
      TriggerCheck.firstAtrRun = true;
      TriggerCheck.firstRun = true;
     // TriggerCheck.firstAtrRun = true;
      delete res;
      test.stopTest();
      //delete res;
     
       
     /* RecordType rtp = new RecordType();
      rtp.Name= 'Training Contracts';
      rtp.DeveloperName = 'Training_Contracts';
      rtp.IsActive = True;
      rtp.SobjectType = 'Contract';
      insert rtp;*/
      
     
  }
    
    //=========================================================================================================================3rd method
        static testMethod void Method_2()
  {
      
      Location__c loc = new Location__c();
     loc.name='Ramapuram';
     loc.City__c='che';
     loc.State__c='TN';
     loc.Postal_Code__c='600089';
     loc.Country__c='India';
     loc.Region__c='Asia';
     loc.CurrencyIsoCode='EUR';
     insert loc;
      
      Product2 pd = new Product2 ();
     pd.name = 'Test';
      pd.SBU__c = 'ATR';
     insert pd;
      
       Account acc =new Account();
     acc.name='Test';
     insert acc;
      
       Contact con = new Contact();
     con.lastname='test';
     con.AccountId = acc.id;
    // con.Customer_Portal_UserId__c= uid;
    // con.Honeywell_ID__c = 'sbc2008';
     insert con;
      
         Class__c cls = new Class__c();
     cls.Class_Name__c= 'test';//pd.id;
      //cls.SBU__c = 'ATR';
     //cls.Contact__c = con.id;
     cls.Course_Name__c=pd.id;
     cls.ATR_Flag__c =True;
     cls.Description__c='test';
     cls.CurrencyIsoCode = 'EUR';
	 cls.End_Date__c=system.today();
     cls.Start_Date__c=system.today();
     //cls.Product_Per_Student_Price__c='515';
     //cls.Course__c= 'Eng';
     cls.Location__c= loc.id;
     //cls.Duration__c='10'
     //cls.Seats_Remaining__c=10;
     //clslist.add(cls);
     insert cls;
      
      cls.ATR_Flag__c =false;
      update cls;
      
     /* Class__c cls = new Class__c();
      cls.Name = '';
      cls.Start_Date__c = ;
      cls.Total_Number_of_Seats__c = 20;
      cls.CurrencyIsoCode = 'EUR';
      cls.Course_Name__c = pd.id;
      cls.*/
      
       Id stExam = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Training Contracts').getRecordTypeId();
      List<contract> contrlst = new List<contract>();
      contract contr = new contract();
      contr.name = 'Contract Test';
      contr.Type__c = 'APM';
      contr.Contract_Number_I_Many__c = 'Test number';
      contr.Asset_Program__c = 'Yes';
      contr.Status = 'Draft';
      contr.StartDate = system.today();
      contr.Revision__c = 'test';
      contr.Currency__c = 'ARS';
      contr.CurrencyIsoCode = 'EUR';
      contr.AccountId= acc.id;
      contr.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr);
      
       contract contr1 = new contract();
      contr1.name = 'Contract Test';
      contr1.Type__c = 'APM';
      contr1.Contract_Number_I_Many__c = 'Test number';
      contr1.Asset_Program__c = 'Yes';
      contr1.Status = 'Draft';
      contr1.StartDate = system.today()+1;
      contr1.Revision__c = 'test';
      contr1.Currency__c = 'ARS';
      contr1.CurrencyIsoCode = 'EUR';
      contr1.AccountId= acc.id;
      contr1.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr1);
      insert contrlst;
      
      List<Entitlement__c> entlist = new List<Entitlement__c>();
       Entitlement__c objent = new Entitlement__c(
        Contract_Number__c = contr.id,
        //Entitlement_Start_Date__c= system.today(),
        End_Date__c=System.today(),
        Status__c='Active',
           Comments__c = 'test comments',
        Course__c = pd.id,
        Number_Of_Seats__c=-1,
        Usage_Cap__c =1.0, 
        Usage_Count__c =1, 
        Usage_Percent__c=0.0,
        IsMultiple__c = false // added
    );
      entlist.add(objent);
    insert entlist ;
      
      //Integer intStatus = 0;
      TriggerCheck.firstRun = true;
      
      test.startTest();
      list<Reservation__c> reservationList=new list<Reservation__c>();
      Reservation__c res = new Reservation__c();
     //res.name='Test';Student
     res.Attended__c ='Attended/Update';
     res.CurrencyIsoCode = 'EUR';
     res.Reservation_Type__c = 'Student';
     res.Reservation_Status__c = 'Confirmed' ;
     res.Student__c = con.id;
     res.Class_Name__c = cls.id;
      res.Entitlement__c = objent.id;
      res.Unique_Field__c = '1';
    // res.Student_Name__c = 'SURYA';
     //res.Class__c = cls.id;
     reservationList.add(res);
      
     /* Reservation__c res1 = new Reservation__c();
     //res.name='Test';Student
     res1.Attended__c ='No Show/Confirmed';
     res1.CurrencyIsoCode = 'USD';
     res1.Reservation_Type__c = 'Student';
     res1.Reservation_Status__c = 'Wait List' ;
     res1.Student__c = con.id;
     res1.Class_Name__c = cls.id;
      res1.Entitlement__c = objent.id;
      res1.Unique_Field__c = '2';Wait List
    // res.Student_Name__c = 'SURYA';
     //res.Class__c = cls.id;
     reservationList.add(res1);*/
     insert reservationList;
      // res.Attended__c ='No Show/Confirmed';
      
      // res.Reservation_Status__c = 'Registered' ;
     // update res;
     
      //TriggerCheck.firstAtrRun = true;
     // TriggerCheck.firstRun = true;
     // TriggerCheck.firstAtrRun = true;
     // delete res;
      test.stopTest();
      //delete res;
     
       
     /* RecordType rtp = new RecordType();
      rtp.Name= 'Training Contracts';
      rtp.DeveloperName = 'Training_Contracts';
      rtp.IsActive = True;
      rtp.SobjectType = 'Contract';
      insert rtp;*/
      
     
  }
    //-----------------------------------------------------------------------------------------------------------------------Method-4
       static testMethod void Method_4()
  {
      
      Location__c loc = new Location__c();
     loc.name='Ramapuram';
     loc.City__c='che';
     loc.State__c='TN';
     loc.Postal_Code__c='600089';
     loc.Country__c='India';
     loc.Region__c='Asia';
     loc.CurrencyIsoCode='EUR';
     insert loc;
      
      Product2 pd = new Product2 ();
     pd.name = 'Test';
      pd.SBU__c = 'ATR';
     insert pd;
      
       Account acc =new Account();
     acc.name='Test';
     insert acc;
      
       Contact con = new Contact();
     con.lastname='test';
     con.AccountId = acc.id;
    // con.Customer_Portal_UserId__c= uid;
    // con.Honeywell_ID__c = 'sbc2008';
     insert con;
      
         Class__c cls = new Class__c();
     cls.Class_Name__c= 'test';//pd.id;
      //cls.SBU__c = 'ATR';
     //cls.Contact__c = con.id;
     cls.Course_Name__c=pd.id;
     cls.ATR_Flag__c =True;
     cls.Description__c='test';
     cls.CurrencyIsoCode = 'EUR';
	 cls.End_Date__c=system.today();
     cls.Start_Date__c=system.today();
     //cls.Product_Per_Student_Price__c='515';
     //cls.Course__c= 'Eng';
     cls.Location__c= loc.id;
     //cls.Duration__c='10'
     //cls.Seats_Remaining__c=10;
     //clslist.add(cls);
     insert cls;
      
      cls.ATR_Flag__c =false;
      update cls;
      
     /* Class__c cls = new Class__c();
      cls.Name = '';
      cls.Start_Date__c = ;
      cls.Total_Number_of_Seats__c = 20;
      cls.CurrencyIsoCode = 'EUR';
      cls.Course_Name__c = pd.id;
      cls.*/
      
       Id stExam = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Training Contracts').getRecordTypeId();
      List<contract> contrlst = new List<contract>();
      contract contr = new contract();
      contr.name = 'Contract Test';
      contr.Type__c = 'APM';
      contr.Contract_Number_I_Many__c = 'Test number';
      contr.Asset_Program__c = 'Yes';
      contr.Status = 'Draft';
      contr.StartDate = system.today();
      contr.Revision__c = 'test';
      contr.Currency__c = 'ARS';
      contr.CurrencyIsoCode = 'EUR';
      contr.AccountId= acc.id;
      contr.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr);
      
       contract contr1 = new contract();
      contr1.name = 'Contract Test';
      contr1.Type__c = 'APM';
      contr1.Contract_Number_I_Many__c = 'Test number';
      contr1.Asset_Program__c = 'Yes';
      contr1.Status = 'Draft';
      contr1.StartDate = system.today()+1;
      contr1.Revision__c = 'test';
      contr1.Currency__c = 'ARS';
      contr1.CurrencyIsoCode = 'EUR';
      contr1.AccountId= acc.id;
      contr1.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr1);
      insert contrlst;
      
      /* Entitlement__c objent = new Entitlement__c(
        Contract_Number__c = contr.id,
        Entitlement_Start_Date__c= system.today(),
        End_Date__c=System.today(),
        Status__c='Active',
           Comments__c = 'test comments',
        Course__c = pd.id,
        Number_Of_Seats__c=1.0,
        Usage_Cap__c =1.0, 
        Usage_Count__c =0.0, 
        Usage_Percent__c=0.0,
        IsMultiple__c = false // added
    );
    insert objent ;*/
      test.startTest();
      Reservation__c res = new Reservation__c();
     //res.name='Test';Student
     res.Attended__c ='Yes';
     res.CurrencyIsoCode = 'EUR';
     res.Reservation_Type__c = 'Student';
     res.Reservation_Status__c = 'Cancel' ;
     res.Student__c = con.id;
     res.Class_Name__c = cls.id;
     // res.Entitlement__c = objent.id;
    // res.Student_Name__c = 'SURYA';
     //res.Class__c = cls.id;
     insert res;
     // res.Attended__c ='No';
     // update res;
     
      TriggerCheck.firstAtrRun = true;
      TriggerCheck.firstRun = true;
     // TriggerCheck.firstAtrRun = true;
      delete res;
      test.stopTest();
      //delete res;
     
       
     /* RecordType rtp = new RecordType();
      rtp.Name= 'Training Contracts';
      rtp.DeveloperName = 'Training_Contracts';
      rtp.IsActive = True;
      rtp.SobjectType = 'Contract';
      insert rtp;*/
      
     
  }
   //--------------------------------------------------------------------------------------------------------------method 5 
     static testMethod void Method_5()
  {
      
      Location__c loc = new Location__c();
     loc.name='Ramapuram';
     loc.City__c='che';
     loc.State__c='TN';
     loc.Postal_Code__c='600089';
     loc.Country__c='India';
     loc.Region__c='Asia';
     loc.CurrencyIsoCode='EUR';
     insert loc;
      
      Product2 pd = new Product2 ();
     pd.name = 'Test';
      pd.SBU__c = 'ATR';
     insert pd;
      
       Account acc =new Account();
     acc.name='Test';
     insert acc;
      
       Contact con = new Contact();
     con.lastname='test';
     con.AccountId = acc.id;
    // con.Customer_Portal_UserId__c= uid;
    // con.Honeywell_ID__c = 'sbc2008';
     insert con;
      
         Class__c cls = new Class__c();
     cls.Class_Name__c= 'test';//pd.id;
      //cls.SBU__c = 'ATR';
     //cls.Contact__c = con.id;
     cls.Course_Name__c=pd.id;
     cls.ATR_Flag__c =True;
     cls.Description__c='test';
     cls.CurrencyIsoCode = 'EUR';
	 cls.End_Date__c=system.today();
     cls.Start_Date__c=system.today();
     //cls.Product_Per_Student_Price__c='515';
     //cls.Course__c= 'Eng';
     cls.Location__c= loc.id;
     //cls.Duration__c='10'
     //cls.Seats_Remaining__c=10;
     //clslist.add(cls);
     insert cls;
      
      cls.ATR_Flag__c =false;
      update cls;
      
     /* Class__c cls = new Class__c();
      cls.Name = '';
      cls.Start_Date__c = ;
      cls.Total_Number_of_Seats__c = 20;
      cls.CurrencyIsoCode = 'EUR';
      cls.Course_Name__c = pd.id;
      cls.*/
      
       Id stExam = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Training Contracts').getRecordTypeId();
      List<contract> contrlst = new List<contract>();
      contract contr = new contract();
      contr.name = 'Contract Test';
      contr.Type__c = 'APM';
      contr.Contract_Number_I_Many__c = 'Test number';
      contr.Asset_Program__c = 'Yes';
      contr.Status = 'Draft';
      contr.StartDate = system.today();
      contr.Revision__c = 'test';
      contr.Currency__c = 'ARS';
      contr.CurrencyIsoCode = 'EUR';
      contr.AccountId= acc.id;
      contr.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr);
      
       contract contr1 = new contract();
      contr1.name = 'Contract Test';
      contr1.Type__c = 'APM';
      contr1.Contract_Number_I_Many__c = 'Test number';
      contr1.Asset_Program__c = 'Yes';
      contr1.Status = 'Draft';
      contr1.StartDate = system.today()+1;
      contr1.Revision__c = 'test';
      contr1.Currency__c = 'ARS';
      contr1.CurrencyIsoCode = 'EUR';
      contr1.AccountId= acc.id;
      contr1.RecordTypeId =stExam;
      //insert contr;
      contrlst.add(contr1);
      insert contrlst;
      test.startTest();
        Entitlement__c objent = new Entitlement__c(
        Contract_Number__c = contr.id,
        Entitlement_Start_Date__c= system.today(),
        End_Date__c=System.today(),
        Status__c='Active',
           Comments__c = 'test comments',
        Course__c = null,
        Number_Of_Seats__c=1.0,
        Usage_Cap__c =1.0, 
        Usage_Count__c =0.0, 
        Usage_Percent__c=0.0,
        IsMultiple__c = True // added
    );
    insert objent ;
      objent.Course__c = pd.id; 
      objent.IsMultiple__c = false;
      update objent ;

      
      Reservation__c res = new Reservation__c();
     //res.name='Test';Student
     res.Attended__c ='TEST';
     res.CurrencyIsoCode = 'EUR';
     res.Reservation_Type__c = 'Student';
     res.Reservation_Status__c = 'TEST' ;
     res.Student__c = con.id;
     res.Class_Name__c = cls.id;
      res.Entitlement__c = objent.id;
    // res.Student_Name__c = 'SURYA';
     //res.Class__c = cls.id;
     insert res;
      res.Attended__c ='TEST12';
      res.Reservation_Status__c = 'Cancel123';
      update res;
     
      TriggerCheck.firstAtrRun = true;
      TriggerCheck.firstRun = true;
     // TriggerCheck.firstAtrRun = true;
     // delete res;
      test.stopTest();
      //delete res;
     
       
     /* RecordType rtp = new RecordType();
      rtp.Name= 'Training Contracts';
      rtp.DeveloperName = 'Training_Contracts';
      rtp.IsActive = True;
      rtp.SobjectType = 'Contract';
      insert rtp;*/
      
             //Entitlement__c objent = new Entitlement__c(
       // Contract_Number__c = contr.id,
        //Entitlement_Start_Date__c= system.today(),
        //End_Date__c=System.today(),
        //Status__c='Active',
        //   Comments__c = 'test comments',
      
      //  Number_Of_Seats__c=1.0,
      //  Usage_Cap__c =1.0, 
      //  Usage_Count__c =0.0, 
      //  Usage_Percent__c=0.0,
        // added
   // );
    
      
     
  }
    
/*  static testMethod void Method_UpdateNoShow()
  {
  
  Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
  test.starttest();
  insert acc;
  test.stoptest();
  Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125607',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        
        Product2 objprod = new Product2(name='Test Product');
        insert objprod;
        
       Location__c objloc =new Location__c(name='Test Location',region__c='Asia',
        City__c='Test city',Country__c='Test Country',Postal_Code__c='12223',State__c='Test state');
        insert objloc;
        
        Class__c objclass = new Class__c(class_name__c='Test Class',Course_Name__c=objprod.id,Location__c=objloc.id);
        insert objclass;
        
   // Reservation__c objReserv  = new Reservation__c(Class_Name__c ='a0B3000000AKKvHEAX',Reservation_Status__c='Confirmed',
  //Attended__c='No Show',Student__c='00330000019YJzeAAG');
  
   Reservation__c objReserv  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',
  Attended__c='No Show',Student__c=cont.id);
  insert objReserv; 
     objReserv.Attended__c = 'No Show/Confirmed';
     update objReserv ;
     
  }
  
    
  static testMethod void Method_UpdateMultiple()
  {
  
    
     Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
       test.starttest();
  insert acc;
    test.stoptest();
  Contract objcontract = new Contract(name='Test Contract',Account__c=acc.id,accountid=acc.id);
  insert objcontract;
  
  Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E156711',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        
        
        Product2 objprod = new Product2(name='Test Product');
        insert objprod;
        
        Location__c objloc =new Location__c(name='Test Location',region__c='Asia',
        City__c='Test city',Country__c='Test Country',Postal_Code__c='12223',State__c='Test state');
        insert objloc;
        
        Class__c objclass = new Class__c(class_name__c='Test Class',Course_Name__c=objprod.id,Location__c=objloc.id);
        insert objclass;
        
            Entitlement__c objent = new Entitlement__c(Contract_Number__c= objcontract.id,//Contract_Number__c='80030000000mpNhAAI',
     Entitlement_Start_Date__c=System.today(),
     End_Date__c=System.today(),Status__c='Active',
     ismultiple__c=true,Number_Of_Seats__c=3.0,
     comments__C='Testing anu',
     Usage_Cap__c =3.0, Usage_Count__c =0.0, Usage_Percent__c=0.0);
     insert objent ; 
     
 //  /*  Reservation__c objReserv  = new Reservation__c(Class_Name__c ='a0B3000000AKKvHEAX',Reservation_Status__c='Confirmed',
 // Attended__c='No Show',Student__c='0033000000lMuk2',entitlement__c=objent.id);
  
   
     Reservation__c objReserv  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',
  Attended__c='No Show',Student__c=cont.id);
  insert objReserv; 
     objReserv.Reservation_Status__c = 'Cancel';
     update objReserv;
    
      
  }
   
   static testMethod void Method_UpdateUsageCount()
  {
  
   Account acc= new Account(name = 'Test Account',Market_name__C = 'Military',Strategic_Business_Unit__c ='BGA');
    test.starttest();
  insert acc;
    test.stoptest();
  Contract objcontract = new Contract(name='Test Contract',Account__c=acc.id,accountid=acc.id);
  insert objcontract;
      
  Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        
        Product2 objprod = new Product2(name='Test Product',SBU__c='ATR');
        insert objprod;
        
        Location__c objloc =new Location__c(name='Test Location',region__c='Asia',
        City__c='Test city',Country__c='Test Country',Postal_Code__c='12223',State__c='Test state');
        insert objloc;
        
        Class__c objclass = new Class__c(class_name__c='Test Class',Course_Name__c=objprod.id,Location__c=objloc.id);
        insert objclass;
        
        
    
     Entitlement__c objent = new Entitlement__c(Contract_Number__c=objcontract.id,//'80030000000mpOQ',
     Entitlement_Start_Date__c=System.today(),
     End_Date__c=System.today(),Status__c='Active',
     Course__c=objprod.id,//'01t30000002RhspAAC',
     Number_Of_Seats__c=1.0,
     Usage_Cap__c =1.0, Usage_Count__c =0.0, Usage_Percent__c=0.0);
     insert objent ;
                
     
     
    Reservation__c objReserv1  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',
      Attended__c='No Show',Student__c=cont.id);
      insert objReserv1; 
           
      
       Contract objcontract1 = new Contract(name='Test Contract',Account__c=acc.id,accountid=acc.id);
  insert objcontract1;
  
  Entitlement__c objent1 = new Entitlement__c(Contract_Number__c=objcontract1.id,//'80030000000mpOQ',
     Entitlement_Start_Date__c=System.today(),
     End_Date__c=System.today(),Status__c='Active',
     Course__c=objprod.id,//'01t30000002RhspAAC',
     Number_Of_Seats__c=1.0,
     Usage_Cap__c =1.0, Usage_Count__c =0.0, Usage_Percent__c=0.0);
     insert objent1 ;
  
      Contact cont1 = new Contact(
            firstname = 'Testing',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125267',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont1;
      
      Reservation__c objReserv2  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',
      Attended__c='No Show',Student__c=cont1.id);
      insert objReserv2;   
      
      Contact cont2 = new Contact(
            firstname = 'Testing',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E121567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont2;
        
        objent.Usage_Count__c     = null;
      objent.Number_Of_Seats__c = null;
      objent.Usage_Cap__c =null;
      update objent;
      
      Reservation__c objResrv3  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',
  Attended__c='No Show',Student__c=cont2.id);
  insert objResrv3;   
   
  Contact cont3 = new Contact(
            firstname = 'Testing',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E114567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont3;
        
      
      Reservation__c objResrv4  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',
  Attended__c='No Show',Student__c=cont3.id);
  insert objResrv4;

 
  }
  
   static testMethod void Method_Delete1()
  {
  
    Account acc= new Account(name = 'Test Account',Market_name__C = 'Military', Strategic_Business_Unit__c ='ATR');
    test.starttest();
    insert acc;
    test.stoptest();
    Contact cont = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E125687',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont; 

    Product2 objprod = new Product2(name='Test Product',SBU__c = 'ATR');
    insert objprod;

    Location__c objloc =new Location__c(name='Test Location',region__c='Asia',
    City__c='Test city',Country__c='Test Country',Postal_Code__c='12223',State__c='Test state');
    insert objloc;

    Class__c objclass = new Class__c(class_name__c='Test Class',Course_Name__c=objprod.id,Location__c=objloc.id,ATR_Flag__c = true);
    insert objclass;

    Contract objcontract1 = new Contract(name='Test Contract',accountid=acc.id,RecordtypeId='01230000000azJd');
    insert objcontract1;

    Entitlement__c objent = new Entitlement__c(Contract_Number__c=objcontract1.id,//'80030000000mpOQ',
    Entitlement_Start_Date__c=System.today(),
    End_Date__c=System.today(),Status__c='Active',
    Course__c=objprod.id,//'01t30000002RhspAAC',
    Number_Of_Seats__c=1.0,
    Usage_Cap__c =1.0, Usage_Count__c =0.0, Usage_Percent__c=0.0);
    insert objent ;

    Reservation__c objReserv  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont.id);//Student__c='0033000000iRxe6'
    insert objReserv;

    objReserv.Reservation_Status__c ='Cancel';
    objReserv.Attended__c='Yes';
    TriggerCheck.firstRun = true;
    //TriggerCheck.firstAtrRun = false;
    update objReserv;
     
  }
   static testMethod void Method_Delete2()
  {
  
    Account acc= new Account(name = 'Test Account',Market_name__C = 'Military', Strategic_Business_Unit__c ='ATR');
    
    insert acc;
    
    Contact cont1 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256871',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont1; 
    
    Contact cont2 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256872',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont2; 
        Contact cont3 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256873',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont3; 
    Contact cont4 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256874',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont4; 
    Contact cont5 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256875',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont5;   
    Contact cont6 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256876',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont6;   

    Product2 objprod = new Product2(name='Test Product',SBU__c = 'ATR');
    insert objprod;

    Location__c objloc =new Location__c(name='Test Location',region__c='Asia',
    City__c='Test city',Country__c='Test Country',Postal_Code__c='12223',State__c='Test state');
    insert objloc;

    Class__c objclass = new Class__c(class_name__c='Test Class',Course_Name__c=objprod.id,Location__c=objloc.id, ATR_Flag__c = false);
    insert objclass;

    Contract objcontract1 = new Contract(name='Test Contract',accountid=acc.id,RecordtypeId='01230000000azJd');
    insert objcontract1;

    Entitlement__c objent = new Entitlement__c(Contract_Number__c=objcontract1.id,//'80030000000mpOQ',
    Entitlement_Start_Date__c=System.today(),
    End_Date__c=System.today(),Status__c='Active',
    Course__c=objprod.id,//'01t30000002RhspAAC',
    Number_Of_Seats__c=1.0,
    Usage_Cap__c =1.0, Usage_Count__c =0.0, Usage_Percent__c=0.0);
    insert objent ;

    List<Reservation__c> objReservList  = new List<Reservation__c>();
    
    Reservation__c objReserv1  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont1.id,Legacy_Id__c ='cont1.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv1); 
    
    Reservation__c objReserv2  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont2.id,Legacy_Id__c ='cont2.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv2);

    Reservation__c objReserv3  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont3.id,Legacy_Id__c ='cont3.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv3);

    Reservation__c objReserv4  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont4.id,Legacy_Id__c ='cont4.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv4);

    Reservation__c objReserv5  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont5.id,Legacy_Id__c ='cont5.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv5);
    
    test.starttest();
    Reservation__c objReserv6  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont6.id,Legacy_Id__c ='cont6.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv6); 
    
    Insert objReservList;

    objReservList[5].Reservation_Status__c ='Cancel';
    objReservList[5].Attended__c='No Show';
   // objReserv6.Legacy_Id__c = 'Testing111111222';
    TriggerCheck.firstRun = true;
    //TriggerCheck.firstAtrRun = false;
    
    update objReservList[5];
    test.stoptest();
 
  }  
  
   static testMethod void Method_Delete3()
  {
  system.debug ('&&&acc');
    Account acc= new Account(name = 'Test Account123',Market_name__C = 'Military', Strategic_Business_Unit__c ='ATR');
    
    insert acc;
    system.debug ('&&&acc'+acc);
    
    Contact cont1 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256871',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont1; 
    
    Contact cont2 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256872',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont2; 
        Contact cont3 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256873',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    );
    insert cont3; 
    Contact cont4 = new Contact(
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256874',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
   // );---------------------------------
    insert cont4; 
    //Contact cont5 = new Contact(-----------------------
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256875',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
    //);---------------------------
    insert cont5;   
    //Contact cont6 = new Contact(---------------------------
        firstname = 'Test',
        LastName = 'Contact',
        AccountId = acc.Id,
        Phone_3__c = '9986502495',
        Contact_Is_Employee__c = true,
        Contact_Status__c = 'Active',
        Employee_Contact_Role__c = 'Analyst',
        Employee_Number__c = 'E1256876',
        Honeywell_ID__c = '01499xxx40331',
        EMAIL = 'aldcv.sfwv@vfv.com'
   // );-----------------------------------------
    insert cont6;   

    //Product2 objprod = new Product2(name='Test Product',SBU__c = 'ATR');-----------------------------------------
    insert objprod;

    //Location__c objloc =new Location__c(name='Test Location',region__c='Asia',-------------------------------------
    //City__c='Test city',Country__c='Test Country',Postal_Code__c='12223',State__c='Test state');-----------------------------------
    insert objloc;

   // Class__c objclass = new Class__c(class_name__c='Test Class',Course_Name__c=objprod.id,Location__c=objloc.id, ATR_Flag__c = false);----------------------------
    insert objclass;

    //Contract objcontract1 = new Contract(name='Test Contract',accountid=acc.id,RecordtypeId='01230000000azJd');-----------------------------
    insert objcontract1;

    //Entitlement__c objent = new Entitlement__c(Contract_Number__c=objcontract1.id,//'80030000000mpOQ',-----------------------------------------
    //Entitlement_Start_Date__c=System.today(),----------------------------------------
    //End_Date__c=System.today(),Status__c='Active',------------------------------------
    Course__c=objprod.id,//'01t30000002RhspAAC',
    Number_Of_Seats__c=1.0,
   // Usage_Cap__c =1.0, Usage_Count__c =0.0, Usage_Percent__c=0.0);-------------------------------------
    insert objent ;

    List<Reservation__c> objReservList  = new List<Reservation__c>();
    
    Reservation__c objReserv1  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont1.id,Legacy_Id__c ='cont1.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv1); 
    
    Reservation__c objReserv2  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont2.id,Legacy_Id__c ='cont2.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv2);

    Reservation__c objReserv3  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont3.id,Legacy_Id__c ='cont3.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv3);

    Reservation__c objReserv4  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont4.id,Legacy_Id__c ='cont4.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv4);

    Reservation__c objReserv5  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont5.id,Legacy_Id__c ='cont5.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv5);
    
    test.starttest();
    Reservation__c objReserv6  = new Reservation__c(Class_Name__c =objclass.id,Reservation_Status__c='Confirmed',//Class_Name__c ='a0B3000000AKKvHEAX'
    Attended__c='No Show',Student__c=cont6.id,Legacy_Id__c ='cont6.id');//Student__c='0033000000iRxe6'
    //insert objReserv1;
    objReservList.add(objReserv6); 
    
    Insert objReservList;

    objReservList[5].Reservation_Status__c ='Registered';
    objReservList[5].Attended__c='No Show';
    
    system.debug('&&&objReservList[5]'+objReservList[5]);
   // objReserv6.Legacy_Id__c = 'Testing111111222';
    TriggerCheck.firstRun = true;
    //TriggerCheck.firstAtrRun = false;
    
    update objReservList[5];
    test.stoptest();
 
  } */ 
  
  
}