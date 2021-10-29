@isTest(SeeAllData=false)
private class TestClass_ContractEndNotification
{
    static testMethod void TestClass_ContractEndNotification() 
    { 
       Date today1 = date.valueof(system.today()+ 90);        
       Account A1 = new Account(Name = 'Test Account');
        insert A1;
       contract contr=new contract();
       contr.Contract_Number_I_Many__c='Test contr';
       contr.Type__c='APU Selection Agreement';
       contr.Asset_Program__c='NO';
       contr.Status='New';
       contr.StartDate=today1;
       contr.End_date_Required__c ='NO';
       contr.EndDate=today1;
      //contr.Revision__c=2;
       contr.Currency__c='ARS';
       contr.AccountID =A1.id;
       insert contr;
       
       Test.StartTest(); 
       ContractEndNotification  cont= new ContractEndNotification ();
       database.executeBatch(cont,20);
       Test.StopTest(); 
    }
}