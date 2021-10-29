/**
 * Created by Satya Mohanty on 4/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class TestPlantBuilder_Test{

    @IsTest
    static void testDefaultBuild(){
    System.Test.startTest();
    Plant_Code_Master__c plant = new TestPlantBuilder()
            .build();
    System.Test.stopTest();

    System.assertEquals(null,plant.Id);
    System.assertEquals('Test Plant',plant.Name);
    }
  @IsTest
    static void testDefaultBuildWithAddField(){
    System.Test.startTest();
    Plant_Code_Master__c plant = new TestPlantBuilder()
        .addField('Country_Name__c','canada')
        .build();
    System.Test.stopTest();

    System.assertEquals(null,plant.Id);
    System.assertEquals('Test Plant',plant.Name);
   }
  @IsTest
    static void testGenerate() {
    System.Test.startTest();
    Plant_Code_Master__c plant = new TestPlantBuilder()
    .setName('Test Plant')
    .setCountryName('Canada')
    .generate();
    System.Test.stopTest();
      Plant_Code_Master__c insertPlantCodeMaster =[
              SELECT Id
              FROM Plant_Code_Master__c
              WHERE Name = 'Test Plant'
              AND Id = :plant.Id
              AND Country_Name__c = 'Canada'
       ];
    System.assertEquals(insertPlantCodeMaster.Id,plant.Id);
    System.assertEquals('Test Plant',plant.Name);
  }
 }