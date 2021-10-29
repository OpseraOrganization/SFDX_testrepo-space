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
private class TestDeleteTools
{
    static testMethod void deleteTools(){
        Test.startTest();
        portal_tools_master__c newTool = new portal_tools_master__c();
        newTool.name = 'Test tool for delete tool code coverage';
        newTool.Tool_Description__c = 'Test tool for delete tool code coverage';
        newTool.Tool_Authorization_Master__c = 'HON approval';
        newTool.Auto_approve__c = 'Not Allowed';
        newTool.Tool_Active__c = true;
        insert newtool;
        
        Portal_Access_Template__c newTemplate=new Portal_Access_Template__c();
        newTemplate.Name='Test Template for code coverage';
        newTemplate.Template_Description__c='Test Description Template for code coverage';
        insert newTemplate;
                
        List<Portal_Tools_Master__c> toolMaster=[select id,Tool_Authorization_Master__c from Portal_Tools_Master__c where name='Test tool for delete tool code coverage'];
        Template_Tools__c newTempToolObj=new Template_Tools__c();
        newTempToolObj.name='Test TempTool for code coverage';
        newTempToolObj.Portal_Tools_Master__c=toolMaster.get(0).id;
        newTempToolObj.Portal_Access_Templates__c=newTemplate.id;
        newTempToolObj.Authorization_Method__c=toolMaster.get(0).Tool_Authorization_Master__c;
        insert newTempToolObj; 
        
        List<Portal_Access_Template__c> lsttemplates=[select id from Portal_Access_Template__c where name='Test Template for code coverage'];
        account newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.ATR_Portal_Access_Template__c=lsttemplates.get(0).id;
        insert newAcct;
        
        newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.ATR_Portal_Access_Template__c=lsttemplates.get(0).id;
        insert newAcct;
        
        portal_tools_master__c newTool1 = new portal_tools_master__c();
        newTool1.name = 'Test tool for delete tool code coverage1';
        newTool1.Tool_Description__c = 'Test tool for delete tool code coverage1';
        newTool1.Tool_Authorization_Master__c = 'HON approval';
        newTool1.Auto_approve__c = 'Not Allowed';
        newTool1.Tool_Active__c = true;
        insert newtool1;
        
        List<Portal_Tools_Master__c> toolMaster1=[select id,Tool_Authorization_Master__c from Portal_Tools_Master__c where name='Test tool for delete tool code coverage1'];
        Template_Tools__c newTempToolObj1=new Template_Tools__c();
        newTempToolObj1.name='Test tool for delete tool code coverage1';
        newTempToolObj1.Portal_Tools_Master__c=toolMaster1.get(0).id;
        newTempToolObj1.Portal_Access_Templates__c=newTemplate.id;
        newTempToolObj1.Authorization_Method__c=toolMaster1.get(0).Tool_Authorization_Master__c;
        insert newTempToolObj1; 
        
        String query='select id from account where ATR_Portal_Access_Template__c=\'Test Template for code coverage\' limit 200';
        BatchUpdateAccountToolFromTemplates buatft=new BatchUpdateAccountToolFromTemplates(query,'Test tool for delete tool code coverage1','HON approval',toolMaster1.get(0).id); 
        
        id batchinstanceid = database.executeBatch(new BatchUpdateAccountToolFromTemplates(query,'Test tool for delete tool code coverage1','HON approval',toolMaster1.get(0).id),200);
        
        Delete newtool;
        
        Test.stopTest();
        
    
    }
    
        static testMethod void BatchUpdateAccntTlFrmTemToolEdit(){
Test.startTest();
      Portal_Tools_Master__c newTool=new Portal_Tools_Master__c();
      newTool.name='Test Tool for code coverage';
      newTool.Tool_Description__c='Tool Description for code coverage';
      newTool.Tool_Authorization_Master__c='HON approval';
      newTool.Auto_approve__c='Not Allowed';
      newTool.Tool_Active__c=true;
      insert newTool;
      String query='select id from account limit 10';
      ID batchprocessid = Database.executeBatch(new BatchUpdateAccntTlFrmTemToolEdit(query,newTool.name,'Auto-approve',newTool.id));

Test.stopTest();
}
static testMethod void BatchUpdateAccountToolFromTemplates(){
Test.startTest();
      Portal_Tools_Master__c newTool=new Portal_Tools_Master__c();
      newTool.name='Test Tool for code coverage';
      newTool.Tool_Description__c='Tool Description for code coverage';
      newTool.Tool_Authorization_Master__c='HON approval';
      newTool.Auto_approve__c='Not Allowed';
      newTool.Tool_Active__c=true;
      insert newTool;
      String query='select id from account limit 10';
      ID batchprocessid = Database.executeBatch(new BatchUpdateAccountToolFromTemplates(query,newTool.name,'Auto-approve',newTool.id));

Test.stopTest();
}
static testMethod void BatchUpdToolNameInTmpTls(){

      Portal_Tools_Master__c newTool=new Portal_Tools_Master__c();
      newTool.name='Test Tool for code coverage';
      newTool.Tool_Description__c='Tool Description for code coverage';
      newTool.Tool_Authorization_Master__c='HON approval';
      newTool.Auto_approve__c='Not Allowed';
      newTool.Tool_Active__c=true;
      insert newTool;
      
      Portal_Access_Template__c newTemplate=new Portal_Access_Template__c();
      newTemplate.Name='Test Template for code coverage';
      newTemplate.Template_Description__c='Test Description Template for code coverage';
      insert newTemplate;   
      
      
      Template_Tools__c newTempToolObj=new Template_Tools__c();
      newTempToolObj.name='Test Tool for code coverage';
      newTempToolObj.Portal_Tools_Master__c=newTool.id;
      newTempToolObj.Portal_Access_Templates__c=newTemplate.id;
      newTempToolObj.Authorization_Method__c=newTool.Tool_Authorization_Master__c;
      insert newTempToolObj;
Test.startTest();
      String query='select id,name,Portal_Access_Templates__c,Portal_Tools_Master__c from Template_Tools__c where Portal_Tools_Master__c =\''+newTool.id+'\'';
      id batchinstanceid = database.executeBatch(new BatchUpdToolNameInTmpTls(query,newTool.name)); 

Test.stopTest();
}
static testMethod void BatchUpdToolNameInAccTls(){

      Portal_Tools_Master__c newTool=new Portal_Tools_Master__c();
      newTool.name='Test Tool for code coverage';
      newTool.Tool_Description__c='Tool Description for code coverage';
      newTool.Tool_Authorization_Master__c='HON approval';
      newTool.Auto_approve__c='Not Allowed';
      newTool.Tool_Active__c=true;
      insert newTool;
      
      Portal_Access_Template__c newTemplate=new Portal_Access_Template__c();
      newTemplate.Name='Test Template for code coverage';
      newTemplate.Template_Description__c='Test Description Template for code coverage';
      insert newTemplate;   
        
        account newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='Intercompany';
        //newAcct.ATR_Portal_Access_Template__c=newTemplate.id;
        insert newAcct;
        
        account_tools__c newAcctToolObj = new account_tools__c();
        newAcctToolObj.name = 'Test Tool for code coverage';
        newAcctToolObj.Portal_Tool_Master_Name__c = newTool.id;
        newAcctToolObj.Account_name__c = newAcct.id;
        newAcctToolObj.Authorization_Method__c = newTool.Tool_Authorization_Master__c;
        insert newAcctToolObj;
        
Test.startTest();
      String query='select Account_Name__c, Id, Name, Portal_Tool_Master_Name__c  from Account_Tools__c where Portal_Tool_Master_Name__c =\''+newTool.id+'\'';
      id batchinstanceid = database.executeBatch(new BatchUpdToolNameInAccTls(query,newTool.name)); 

Test.stopTest();
}
static testMethod void BatchUpdToolNameInConTls(){

      Portal_Tools_Master__c newTool=new Portal_Tools_Master__c();
      newTool.name='Test Tool for code coverage';
      newTool.Tool_Description__c='Tool Description for code coverage';
      newTool.Tool_Authorization_Master__c='HON approval';
      newTool.Auto_approve__c='Not Allowed';
      newTool.Tool_Active__c=true;
      insert newTool;
      
      Portal_Access_Template__c newTemplate=new Portal_Access_Template__c();
      newTemplate.Name='Test Template for code coverage';
      newTemplate.Template_Description__c='Test Description Template for code coverage';
      insert newTemplate;   
      Contact con=new Contact();
      con.lastname='Test Contact';
      con.firstname='testing';
      con.Primary_Email_address__c='test@test.com';
      con.Email='test@test.com';
      insert con;
      
      Contact_Tool_Access__c newTempToolObj=new Contact_Tool_Access__c();
      newTempToolObj.name='Test Tool for code coverage';
      newTempToolObj.Portal_Tool_Master__c=newTool.id;
      newTempToolObj.Request_Status__c='Pending';
      newTempToolObj.CRM_Contact_ID__c=con.id;
      newTempToolObj.Portal_Honeywell_ID__c = 'E812402';
      newTempToolObj.Request_Date__c=Date.today();
      insert newTempToolObj;
Test.startTest();
      String query='select id,CRM_Contact_ID__c, Name, Portal_Tool_Master__c  from Contact_Tool_Access__c where Portal_Tool_Master__c =\''+newTool.id+'\'';
        id batchinstanceid = database.executeBatch(new BatchUpdToolNameInConTls(query,newTool.name)); 

Test.stopTest();
}

static testmethod void WebPortalCopyEmailDomains(){
Test.startTest();
        account newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='Intercompany';
        //newAcct.ATR_Portal_Access_Template__c=newTemplate.id;
        insert newAcct;
WebPortalCopyEmailDomains wpced=new WebPortalCopyEmailDomains();
Apexpages.currentpage().getParameters().put('accId',newAcct.id);
wpced.accNameToSearch='Boeing';
wpced.search();
wpced.addToAccount();
Test.stopTest();
}
static testMethod void ContactToolAccessExportController(){
ContactToolAccessExportController ctaec=new ContactToolAccessExportController();

}
static testMethod void deleteContactRelatedDetails()
    {
        test.startTest();
        
        Contact con=new Contact();
        con.lastname='Test Contact';
        con.firstname='testing';
        con.Primary_Email_address__c='test@test.com';
        con.Email='test@test.com';
        insert con;
        Portal_Honeywell_ID__c newHonId = new Portal_Honeywell_ID__c();
        newHonId.name = '33333';
        newHonId.Contact__c = con.id;
        newHonId.Primary_Honeywell_ID__c = true;
        insert newHonid;
        
        SAP_Contact_Sold_To__c SAPConSold = new SAP_Contact_Sold_To__c();
        SAPConSold.name = 'testSAPContactSoldTo';
        SAPConSold.SAP_Account_Sold_To__c = 'testSAPContactSoldTo';
        SAPConSold.Contact__c = con.id;
        insert SAPConSold;
        List<Portal_Tools_master__c> toolId = [select id, name from Portal_Tools_Master__c where name = 'Order Status'];  

        Contact_Tool_Access__c cta=new Contact_Tool_Access__c();
        cta.crm_contact_id__c=con.id;
        cta.Portal_Tool_Master__c =toolId.get(0).id;
        cta.name='Order Status';
        cta.Portal_Honeywell_ID__c = 'E812402';
        insert cta;
        newHonid.Delete_Hon_Id__c=true;
        newHonid.Delete_Contact_ID__c=con.id;
        update newHonId;
                        
                
        Test.stopTest(); 
    }
    
    public static testMethod void ToolAuthPreventDup(){
Test.startTest();
    Tool_Authorization_Methods_Master__c toolAuth=new Tool_Authorization_Methods_Master__c();
    toolAuth.name='Test Auth';
    insert toolAuth;
    Tool_Authorization_Methods_Master__c toolAuth1=new Tool_Authorization_Methods_Master__c();
    toolAuth1.name='Test Auth';
    try{
       insert toolAuth1;
       }catch(Exception e){
       System.debug(e);
       }
Test.stopTest();
}
static testMethod void ToolPreventDup(){
Test.startTest();
Portal_Tools_Master__c tool=new Portal_Tools_Master__c();
tool.name='Test Tool';
tool.Tool_Description__c='Test Tool desc';
insert tool;
Portal_Tools_Master__c tool1=new Portal_Tools_Master__c();
tool1.name='Test Tool';
tool1.Tool_Description__c='Test Tool desc';
try{
    insert tool1;
    }catch(exception e){
        System.debug(e.getMessage());
    }
Test.stopTest();

}
static testMethod void TempPreventDup(){
Test.startTest();
Portal_Access_Template__c temp=new Portal_Access_Template__c();
temp.name='Test template';
insert temp;
Portal_Access_Template__c temp1=new Portal_Access_Template__c();
temp1.name='Test template';
try{
    insert temp1;
    }catch(Exception e){
        System.debug(e);
    }

Test.stopTest();
}
static testMethod void bulkClass(){
BulkClassForCustReg blk=new BulkClassForCustReg();
blk.updateToolNameInTempTools('test','xyz');
blk.updateToolNameInAccTools('test','xyz');
blk.updateToolNameInConTools('test','xyz');

}

    
}