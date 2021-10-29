/**
 * Created by Nikolay Kolev on 4/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TechSalesHashBuilder_Test {
    private static String NAME = 'Test Name';
    private static String SBU = 'Test SBU';
    private static String REGION = 'Test Region';
    private static String COUNTRY = 'My Test Country';

    @IsTest
    static void passAllValuesAllCriteria() {
        System.Test.startTest();
        TechSalesHashBuilder hasher = new TechSalesHashBuilder()
                .setName(NAME)
                .setSbu(SBU)
                .setRegion(REGION)
                .setCountry(COUNTRY);
        System.Test.stopTest();

        System.assertEquals(
                (NAME+SBU+REGION+COUNTRY).hashCode(),
                hasher.getHash(TechSalesHashBuilder.Criteria.ALL)
        );
    }
    @IsTest
    static void passAllValuesNoCountryCriteria() {
        System.Test.startTest();
        TechSalesHashBuilder hasher = new TechSalesHashBuilder()
                .setName(NAME)
                .setSbu(SBU)
                .setRegion(REGION)
                .setCountry(COUNTRY);
        System.Test.stopTest();

        System.assertEquals(
                (NAME + SBU + REGION).hashCode(),
                hasher.getHash(TechSalesHashBuilder.Criteria.NO_COUNTRY)
        );
    }
    @IsTest
    static void passNoValuesAllCriteria() {
        System.Test.startTest();
        TechSalesHashBuilder hasher = new TechSalesHashBuilder()
                .setName(null)
                .setSbu(null)
                .setRegion(null)
                .setCountry(null);
        System.Test.stopTest();

        System.assertEquals(
                ('' + '' + '' + '').hashCode(),
                hasher.getHash(TechSalesHashBuilder.Criteria.ALL)
        );
    }
    @IsTest
    static void passNoValuesNoCountryCriteria() {
        System.Test.startTest();
        TechSalesHashBuilder hasher = new TechSalesHashBuilder()
                .setName(null)
                .setSbu(null)
                .setRegion(null);
        System.Test.stopTest();

        System.assertEquals(
                ('' + '' + '').hashCode(),
                hasher.getHash(TechSalesHashBuilder.Criteria.NO_COUNTRY)
        );
    }
    @IsTest
    static void passAnEmptyValueAllCriteria() {
        System.Test.startTest();
        TechSalesHashBuilder hasher = new TechSalesHashBuilder()
                .setName(null)
                .setSbu('    ')
                .setRegion(null)
                .setCountry(null);
        System.Test.stopTest();

        System.assertEquals(
                ('' + '    '.trim() + '' + '').hashCode(),
                hasher.getHash(TechSalesHashBuilder.Criteria.ALL)
        );
    }
    @IsTest
    static void passPartialValuesAllCriteria() {
        System.Test.startTest();
        TechSalesHashBuilder hasher = new TechSalesHashBuilder()
                .setName(NAME)
                .setSbu(SBU)
                .setRegion(REGION);
        System.Test.stopTest();

        System.assertEquals(
                (NAME + SBU + REGION).hashCode(),
                hasher.getHash(TechSalesHashBuilder.Criteria.ALL)
        );
    }
    @IsTest
    static void passPartialValuesNoCountryCriteria() {
        System.Test.startTest();
        TechSalesHashBuilder hasher = new TechSalesHashBuilder()
                .setName(NAME)
                .setSbu(SBU)
                .setRegion(REGION);
        System.Test.stopTest();

        System.assertEquals(
                (NAME + SBU + REGION).hashCode(),
                hasher.getHash(TechSalesHashBuilder.Criteria.NO_COUNTRY)
        );
    }
}