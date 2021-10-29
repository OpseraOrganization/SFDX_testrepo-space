/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestAddTemplateTools {

    static testMethod void addTemplateTools() {
        Test.startTest();
        Portal_Tools_Master__c newTool=new Portal_Tools_Master__c();
        newTool.name='Test Tool for code coverage';
        newTool.Tool_Description__c='Tool Description for code coverage';
        newTool.Tool_Authorization_Master__c='HON approval';
        newTool.Auto_approve__c='Not Allowed';
        newTool.Tool_Active__c=true;
        insert newTool;
        
        newTool=new Portal_Tools_Master__c();
        newTool.name='Test Tool for code coverage1';
        newTool.Tool_Description__c='Tool Description for code coverage1';
        newTool.Tool_Authorization_Master__c='HON approval';
        newTool.Auto_approve__c='Not Allowed';
        newTool.Tool_Active__c=true;
        insert newTool;
        
        newTool=new Portal_Tools_Master__c();
        newTool.name='Test Tool for code coverage2';
        newTool.Tool_Description__c='Tool Description for code coverage2';
        newTool.Tool_Authorization_Master__c='Auto-approve';
        newTool.Auto_approve__c='Allowed';
        newTool.Tool_Active__c=true;
        insert newTool;
        
        Portal_Access_Template__c newTemplate=new Portal_Access_Template__c();
        newTemplate.Name='Test Template for code coverage';
        newTemplate.Template_Description__c='Test Description Template for code coverage';
        insert newTemplate;   
        
        List<Portal_Tools_Master__c> toolMaster=[select id,Tool_Authorization_Master__c from Portal_Tools_Master__c where name='Test Tool for code coverage'];
        Template_Tools__c newTempToolObj=new Template_Tools__c();
        newTempToolObj.name='Test TempTool for code coverage';
        newTempToolObj.Portal_Tools_Master__c=toolMaster.get(0).id;
        newTempToolObj.Portal_Access_Templates__c=newTemplate.id;
        newTempToolObj.Authorization_Method__c=toolMaster.get(0).Tool_Authorization_Master__c;
        insert newTempToolObj;
        
        Apexpages.Standardcontroller sc=new Apexpages.Standardcontroller(newTempToolObj);
        AddTemplateTools attObj=new AddTemplateTools(sc);
        attObj.getToolList();
        
        attObj.toolName='Test Tool for code coverage1';
        attObj.getAuthorizationList();
        attObj.toolName='Test Tool for code coverage1';
        attObj.portalAccessTemplateName=newTempToolObj.Portal_Access_Templates__c;
        attObj.authorizationMethod='HON approval';
        attObj.save();
        Test.stopTest();
    }
    static testMethod void editTemplateTools() {
        Test.startTest();
        Portal_Tools_Master__c newTool=new Portal_Tools_Master__c();
        newTool.name='Test Tool for code coverage';
        newTool.Tool_Description__c='Tool Description for code coverage';
        newTool.Tool_Authorization_Master__c='HON approval';
        newTool.Auto_approve__c='Not Allowed';
        newTool.Tool_Active__c=true;
        insert newTool;
        
        newTool=new Portal_Tools_Master__c();
        newTool.name='Test Tool for code coverage1';
        newTool.Tool_Description__c='Tool Description for code coverage1';
        newTool.Tool_Authorization_Master__c='HON approval';
        newTool.Auto_approve__c='Not Allowed';
        newTool.Tool_Active__c=true;
        insert newTool;
        
        newTool=new Portal_Tools_Master__c();
        newTool.name='Test Tool for code coverage2';
        newTool.Tool_Description__c='Tool Description for code coverage2';
        newTool.Tool_Authorization_Master__c='Auto-approve';
        newTool.Auto_approve__c='Allowed';
        newTool.Tool_Active__c=true;
        insert newTool;
        
        Portal_Access_Template__c newTemplate=new Portal_Access_Template__c();
        newTemplate.Name='Test Template for code coverage';
        newTemplate.Template_Description__c='Test Description Template for code coverage';
        insert newTemplate;   
        
        List<Portal_Tools_Master__c> toolMaster=[select id,Tool_Authorization_Master__c from Portal_Tools_Master__c where name='Test Tool for code coverage'];
        Template_Tools__c newTempToolObj=new Template_Tools__c();
        newTempToolObj.name='Test Tool for code coverage';
        newTempToolObj.Portal_Tools_Master__c=toolMaster.get(0).id;
        newTempToolObj.Portal_Access_Templates__c=newTemplate.id;
        newTempToolObj.Authorization_Method__c=toolMaster.get(0).Tool_Authorization_Master__c;
        insert newTempToolObj;
        
        Apexpages.Standardcontroller sc=new Apexpages.Standardcontroller(newTempToolObj);
        Apexpages.currentPage().getParameters().put('id',newTempToolObj.Id);
        EditTemplateTools attObj=new EditTemplateTools(sc);
        attObj.getToolList();
        
        attObj.toolName='Test Tool for code coverage';
        attObj.getAuthorizationList();
        attObj.toolName='Test Tool for code coverage';
        attObj.portalAccessTemplateName=newTempToolObj.Portal_Access_Templates__c;
        attObj.authorizationMethod='HON approval';
        attObj.save();
        Test.stopTest();
    }
   
   
}