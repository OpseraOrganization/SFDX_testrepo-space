@isTest
public class HwTrng_TestClass4
{
    static testmethod void dotest()
    {
    TriggerInactive.testTrigger = false;
    Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
    insert a1;
    Contact c1 = new Contact(lastname='Sumitha',firstname='menon',accountId=a1.Id,
Contact_Is_Employee__c=false,Phone_3__c ='9986555678',email='test.user@honeytwell.com');
insert c1;

Case Caserec= New Case(First_Name__c='Test',Last_Name__c='User',Requestor_Email_Address__c='test.user@honeywell.com',Employee_EID_Trng__c='2333'//,No_FCR_Reason__c='Not Trained'For Ticket INC000009687923
                      );
    insert Caserec;
   ApexPages.StandardController controller= new ApexPages.StandardController(Caserec);
     /*    HwTrng_OnlneTrng_cls OnlnetrngTest=new HwTrng_OnlneTrng_cls(controller);
    case CaseNewrec=OnlnetrngTest.getCaseNewRec();
   CaseNewrec=Caserec;
     OnlnetrngTest.setCaseNewRec();
    OnlnetrngTest.Save();
    
    HwTrng_OnlneTrng_Non_HnyWell_emp_cls NOnhnywellemp= new HwTrng_OnlneTrng_Non_HnyWell_emp_cls(controller);
    NOnhnywellemp.getCaseNewRec();
    NOnhnywellemp.Save();*/
    
    HwTrng_SpclTrngForm_Cls SpclTrng = new HwTrng_SpclTrngForm_Cls(controller);
    SpclTrng.getCaseNewRec();
    SpclTrng.ClearForm();
    SpclTrng.Save();
    
    HWTrng_sendmail_cls Sendmail = new HWTrng_sendmail_cls();
    Sendmail.mailer();
    }
    
}