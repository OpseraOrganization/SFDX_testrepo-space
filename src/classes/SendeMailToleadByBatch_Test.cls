@isTest(SeeAllData = false)
private class SendeMailToleadByBatch_Test{   
 static testMethod void SendeMailToleadByBatch_Method_1(){   
     Test.startTest();
     
     Integer eCount = 0;
     List<Case> cases=new List<Case>();
     List<Task> task1=new List<Task>();
     List<Case> casetoUpdate= new List<Case>();

     Account acc = new Account();
     acc.Name = 'Honeywell Test';
     acc.Customer_Status__c = 'Active';
     acc.Strategic_Business_Unit__c = 'ATR';
     acc.CBT__c = 'Airbus';
     acc.Region_Name__c = 'Americas';
     acc.Sub_Region_Name__c = 'Canada';
     acc.Service_Level__c = 'Standard';
     acc.Type = 'OEM';
     acc.Address_Line_1__c='Test Add';
     acc.Phone='0123456789';
     acc.City_Name__c='KA';
     acc.Country_Name__c='IND';
     acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
     try{
        insert acc;
     }Catch(Exception ex){}

     Contact con = new Contact();
     con.FirstName = 'test';
     con.LastName = 'test';
     con.AccountId = acc.Id;
     con.City_Name__c='KA';
     con.Country_Name__c='IND';
     con.Address_Line_1__c='Test Add';
     con.Phone='0123456789';
     con.Primary_Email_Address__c = 'test@gmail.com';
     con.Email='test@gmail.com';
     //con.Honeywell_ID__c='E473516';
     //con.
     try {
         insert con;
     }Catch(Exception ex){}


     if(con.FirstName == NULL){
         con.FirstName = 'test';
         try {
             update con;
         }Catch(Exception ex){}
     }
     lead led =new lead();
     led.LastName='test';
     led.Company='test company';
     //led.Honeywell_ID__c='E473516';
     led.status='open';
     led.contact__c=con.id;
     led.Account_Address_line_1__c='Test';
     led.Account_Phone__c='9876543210';
     led.Account_Country__c='IND';
     led.Account_City__c='KA';
     led.Primary_Work_Number__c='9876543210';
     datetime myDateTime = datetime.now();
     led.isconverted = false;
     led.recordtypeid = label.BGA_Honeywell_Prospect;
     led.Comm__c = 'HF 1050';
     led.dateTime_test__c=myDateTime.addHours(-120);
     led.Email = 'test@test.com';
     led.Follow_Up_action_requested__c = 'Send a brochure';
     led.BGA_ASM__c = 'Ed Bannen';
     led.Displays__c = 'MFRD';
     led.Nav__c = 'DL-950';
     led.Safety__c = 'P-864';
     led.Mech__c = '36-150 [G]';
     led.Cabin__c = 'Jetmap';
     led.Services__c = 'HAPP';
     led.Air_Data__c = 'AZ-960 RVSM for Gulfstream II/IIB';
     led.Weather__c = 'LSZ-860';
     led.Lighting__c = 'Astreon Tail for GS';
     led.GA__c ='KSN 770';
     led.Send_Aircraft_Specific_Brochures__c ='GII/III';
     led.Thank_you_for_stopping_by_letter__c ='Send Letter - Use General Signature';
     led.thanksforstopbyemailSent__c = false;
     
     
     insert led;
     led.Thank_you_for_stopping_by_letter__c = 'Send Letter - Use ASM Signature';
     led.Follow_Up_action_requested__c = 'call me';
     led.BGA_ASM__c ='Frank Muscolino';
     update led;
     SendeMailToleadByBatch  uplic = new SendeMailToleadByBatch ();
     Database.executeBatch(uplic, 400);
     
    /* SendeMailToleadByBatch  rem = new SendeMailToleadByBatch  ();
        String sch = '0 24 17 19 08 ?';
        System.Schedule('SendeMailToleadByBatch ', sch, rem );  */
     Test.stopTest();
    }
}