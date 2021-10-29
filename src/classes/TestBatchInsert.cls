@isTest
private class TestBatchInsert{
    static testMethod void testBatchInsertMethod(){        
        //get standard pricebook
         //Create an account that is used for inserting opportunity.
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        List<Account> acctList = new List<Account>();
        acctList.add(objAccount);
        Database.executeBatch(new BatchInsert(acctList));
                
       }
}