/**
 * Created by Nikolay Kolev on 3/18/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class ErrorLogBuilder_Test {
    static final String TEST_DESCRIPTION = 'Test description';
    static final String OBJECT_ID = '12345678';
    static final String CRM_SALES = 'CRM Sales';

    @IsTest
    static void buildErrorLogWithName() {

        System.Test.startTest();
        Error_Log__c errLog = new ErrorLogBuilder(CRM_SALES)
                .setObjectInfo(OBJECT_ID)
                .setDescription(TEST_DESCRIPTION)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, errLog.Id);
        System.assertEquals(CRM_SALES, errLog.Team_Name__c);
        System.assertEquals(true, errLog.Description__c.contains(TEST_DESCRIPTION));
        System.assertEquals(OBJECT_ID, errLog.Object__c);
    }

    @IsTest
    static void buildErrorLogWithoutName() {

        System.Test.startTest();
        Error_Log__c errLog = new ErrorLogBuilder()
                .setObjectInfo(OBJECT_ID)
                .setDescription(TEST_DESCRIPTION)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, errLog.Team_Name__c);
        System.assertEquals(true, errLog.Description__c.contains(TEST_DESCRIPTION));
        System.assertEquals(OBJECT_ID, errLog.Object__c);
    }

    @IsTest
    static void generateErrorLogSettingField() {

        System.Test.startTest();
        Error_Log__c errLog = new ErrorLogBuilder()
                .setObjectInfo(OBJECT_ID)
                .setDescription(TEST_DESCRIPTION)
                .setFieldValue('Team_Name__c', CRM_SALES)
                .generate();
        System.Test.stopTest();

        Error_Log__c insertedErrorLog = [
                SELECT
                        Id,
                        Team_Name__c,
                        Description__c,
                        Object__c
                FROM Error_Log__c
                WHERE Team_Name__c = :CRM_SALES
                AND Id = :errLog.Id
        ];

        System.assertEquals(errLog.Team_Name__c, insertedErrorLog.Team_Name__c);
        System.assertEquals(true, insertedErrorLog.Description__c.contains(TEST_DESCRIPTION));
        System.assertEquals(errLog.Object__c, insertedErrorLog.Object__c);
    }

    @IsTest
    static void generateErrorLogWithException() {
        Exception myException;
        try {
            List<Account> acc;

            acc.get(0);
        } catch(Exception ex) {
            myException = ex;
        }

        System.Test.startTest();
        Error_Log__c errLog = new ErrorLogBuilder()
                .setObjectInfo(OBJECT_ID)
                .setDescription(TEST_DESCRIPTION)
                .setException(myException)
                .setFieldValue('Team_Name__c', CRM_SALES)
                .generate();
        System.Test.stopTest();

        Error_Log__c insertedErrorLog = [
                SELECT
                        Id,
                        Team_Name__c,
                        Description__c,
                        Object__c
                FROM Error_Log__c
                WHERE Team_Name__c = :CRM_SALES
                AND Id = :errLog.Id
        ];

        System.assertEquals(errLog.Team_Name__c, insertedErrorLog.Team_Name__c);
        System.assertEquals(true, insertedErrorLog.Description__c.contains(TEST_DESCRIPTION));
        System.assertEquals(true, insertedErrorLog.Description__c.contains('Attempt to de-reference a null object'));
        System.assertEquals(errLog.Object__c, insertedErrorLog.Object__c);
    }
}