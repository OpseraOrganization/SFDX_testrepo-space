/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class TestProductBuilder_Test {
    private final static String TEST_PRODUCT = 'Test Product';
    @IsTest
    static void testBuild() {
        System.Test.startTest();
        Product2 product  = new TestProductBuilder()
                .build();
        System.Test.stopTest();

        System.assertEquals(null, product.Id);
        System.assertEquals(TEST_PRODUCT, product.Name);
    }
    @IsTest
    static void testBuildWithName() {
        System.Test.startTest();
        Product2 product  = new TestProductBuilder('My Product')
                .build();
        System.Test.stopTest();

        System.assertEquals(null, product.Id);
        System.assertEquals('My Product', product.Name);
    }
    @IsTest
    static void testGenerateWithField() {
        System.Test.startTest();
        Product2 product  = new TestProductBuilder('My Product')
                .setIsActive(false)
                .addField('Description', 'Some Description')
                .generate();
        System.Test.stopTest();

        Product2 insertedProduct = [
                SELECT
                        Id,
                        Description
                FROM Product2
                WHERE Name = 'My Product'
                AND Description = 'Some Description'
                AND IsActive = FALSE
        ];

        System.assertEquals(insertedProduct.Id, product.Id);
        System.assertEquals('My Product', product.Name);
        System.assertEquals('Some Description', product.Description);
    }
}