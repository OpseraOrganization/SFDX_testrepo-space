@isTest
public class clearTechPubsRegistrationCaseBatchTest{

@isTest
public static void scheduleTest(){
    system.schedule('test schedule', '20 30 8 10 2 ?',new clearTechPubsRegistrationCaseBatch());
}

@isTest
public static void batchTest(){
    Case cs=new case();
    cs.subject='New User Registered for Technical Publications';
    cs.recordtypeId=schema.sobjectType.case.getRecordTypeInfosByName().get('Tech Pubs').getRecordTypeId();
    insert cs;
    test.startTest();
    database.executeBatch(new clearTechPubsRegistrationCaseBatch(),1);
    test.stopTest();
}
}