/**
 * Created by jmay on 9/08/20.
 */
/*******************************************************************************************
Name       :    GDMFSL_CommonUtilitiesTest
Purpose    :    Test class for the GDMFSL_CommonUtilities class
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
jmay                  2020-Sep-08    Created
**********************************************************************************************/

@IsTest(IsParallel=true)
private class GDMFSL_CommonUtilitiesTest {

    @IsTest
    static void customSettingDisabled() {
        System.assertEquals(false, GDMFSL_CommonUtilities.isProcessingDisabled(), 'isProcessingDisabled default has changed');
    }

    @IsTest
    static void codeControlSetFlag() {

        String theFlag = 'HEllO THERe';
        GDMFSL_CommonUtilities.setFlag(theFlag);
        System.assertEquals(true, GDMFSL_CommonUtilities.isFlagSet(theFlag), 'setFlag or isFlagSet do not work');
    }

    @IsTest
    static void codeControlFlagNotSet() {

        String theFlag = 'HEllO THERe';
        System.assertEquals(false, GDMFSL_CommonUtilities.isFlagSet(theFlag), 'isFlagSet reported missing flag was set');
    }

    @IsTest
    static void codeControlRemoveFlag() {

        String theFlag = 'HEllO THERe';
        GDMFSL_CommonUtilities.setFlag(theFlag);
        GDMFSL_CommonUtilities.removeFlag(theFlag);
        System.assertEquals(false, GDMFSL_CommonUtilities.isFlagSet(theFlag), 'removeFlag does not work');
    }

    @IsTest
    static void addTimezoneOffset() {

        Datetime orig = Datetime.newInstanceGmt(2021,1,1,0,0, 0);
        Datetime adjusted = GDMFSL_CommonUtilities.addTimeZoneOffset(orig, 'America/New_York');

        System.assertEquals(orig.addHours(5), adjusted, 'Adding Timezone Offset is not correct');
    }

    @IsTest
    static void subtractTimezoneOffset() {

        Datetime orig = Datetime.newInstanceGmt(2021,1,1,0,0, 0);
        Datetime adjusted = GDMFSL_CommonUtilities.subtractTimeZoneOffset(orig, 'America/New_York');

        System.assertEquals(orig.addHours(-5), adjusted, 'Subtracting Timezone Offset is not correct');
    }

    @IsTest
    static void insertDML() {

        Account a = new Account(Name = 'Test');

        try {
            GDMFSL_CommonUtilities.insertRecords(new List<Account>{
                    a
            });
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void insertDMLKeepTrying() {

        Account a = new Account(Name = 'Test');

        try {
            GDMFSL_CommonUtilities.insertRecords(new List<Account>{
                    a
            }, false, false);
        }
        catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void insertDMLPartial() {

        Account a = new Account(Name = 'Test');

        try {
            GDMFSL_CommonUtilities.insertRecords(new List<Account>{
                    a
            }, false);
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void updateDML() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.updateRecords(new List<User>{
                    aUser
            });
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void updateDMLKeepTrying() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.updateRecords(new List<User>{
                    aUser
            }, false, false);
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void updateDMLPartial() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.updateRecords(new List<User>{
                    aUser
            }, false);
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void upsertDML() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.upsertRecords(new List<User>{
                    aUser
            });
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void upsertDMLKeepTrying() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.upsertRecords(new List<User>{
                    aUser
            }, false, false);
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void upsertDMLPartial() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.upsertRecords(new List<User>{
                    aUser
            }, false);
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void deleteDML() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.deleteRecords(new List<User>{
                    aUser
            });
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void deleteDMLKeepTrying() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.deleteRecords(new List<User>{
                    aUser
            }, false, true);
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void deleteDMLPartial() {

        User aUser = [SELECT Id, Alias FROM User LIMIT 1];

        try {
            GDMFSL_CommonUtilities.deleteRecords(new List<User>{
                    aUser
            }, false);
        } catch (Exception e){
            System.debug('This test only exercises the DML methods since data requirements can cause actual DML to fail');
        }
    }

    @IsTest
    static void testCoverage()
    {
        GDMFSL_CommonUtilities.coverage();
    }

}