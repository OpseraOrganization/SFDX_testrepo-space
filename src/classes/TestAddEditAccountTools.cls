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
private class TestAddEditAccountTools
{
    static testMethod void AddAccountTools(){
        Test.StartTest();
        Portal_tools_master__c newTool = new portal_tools_master__c();
        newTool.name = 'Test tool for code coverage';
        
        Map<String,Portal_Tools_Master__c> toolMap=new Map<String,Portal_Tools_Master__c>();
        Map<String,Portal_Tools_Master__c> upperCasetoolMap=new Map<String,Portal_Tools_Master__c>();
        for(Portal_Tools_Master__c tool:[select name from Portal_Tools_Master__c where name in : toolMap.keyset()])
        {
            system.debug('tool.name========' + tool.name);
            Portal_Tools_Master__c newTooltemp=upperCasetoolMap.get(tool.name.toUpperCase());
            system.debug('newtooltem========' + newTooltemp);
            if(newTooltemp!=null && newTooltemp.name!=null)
            {
                newTooltemp.name.addError('Tool is already exist with this name \''+tool.name+'\'');
            }
        }
        
        newTool.Tool_Description__c = 'Tool description for code coverage';
        newTool.Tool_Authorization_Master__c = 'HON approval';
        newTool.Auto_approve__c = 'Not Allowed';
        newTool.Tool_Active__c = true;
        insert newtool;
        
        newTool = new portal_tools_master__c();
        newTool.name = 'Test tool for code coverage1';
        newTool.Tool_Description__c = 'Tool description for code coverage1';
        newTool.Tool_Authorization_Master__c = 'HON approval';
        newTool.Auto_approve__c = 'Not Allowed';
        newTool.Tool_Active__c = true;
        insert newtool;
        
        newTool = new portal_tools_master__c();
        newTool.name = 'Test tool for code coverage2';
        newTool.Tool_Description__c = 'Tool description for code coverage2';
        newTool.Tool_Authorization_Master__c = 'HON approval';
        newTool.Auto_approve__c = 'Not Allowed';
        newTool.Tool_Active__c = true;
        insert newtool;
        
        newTool = new portal_tools_master__c();
        newTool.name = 'Test tool for code coverage2';
        newTool.Tool_Description__c = 'Tool description for code coverage2';
        newTool.Tool_Authorization_Master__c = 'HON approval';
        newTool.Auto_approve__c = 'Not Allowed';
        newTool.Tool_Active__c = true;
        try{
            insert newtool;
            }catch(exception e){
                System.debug(e.getMessage());
            }
        
        account newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='ATR';
        insert newAcct;
        
        
        List<Portal_Tools_Master__c> toolMaster=[select id,Tool_Authorization_Master__c from Portal_Tools_Master__c where name='Test Tool for code coverage'];
        account_tools__c newAcctToolObj = new account_tools__c();
        newAcctToolObj.name = 'Test Tool for code coverage';
        newAcctToolObj.Portal_Tool_Master_Name__c = toolMaster.get(0).id;
        newAcctToolObj.Account_name__c = newAcct.id;
        newAcctToolObj.Authorization_Method__c = toolMaster.get(0).Tool_Authorization_Master__c;
        insert newAcctToolObj;
        
        apexpages.standardcontroller sc = new Apexpages.Standardcontroller(newAcctToolObj);
        AddAccountTools aAcctToolsObj = new AddAccountTools(sc);
        aAcctToolsObj.getToolList();
        
        aAcctToolsObj.toolname = 'Test Tool for code coverage1';
        aAcctToolsObj.getAuthorizationList();                  
                    
        aAcctToolsObj.portalAccessAccountName=newAcctToolObj.Account_Name__c;
        aAcctToolsObj.authorizationMethod = 'HON Approval';
        aAcctToolsObj.save();
        Test.stoptest();
    }                             
    static testmethod void editAccountTemplate(){        
        Test.startTest();                
                            
        portal_tools_master__c newtool = new portal_tools_master__c();     
        newtool.name = 'Test Tool for code coverage';    
        newtool.tool_Description__c = 'Tool description';                
        newtool.tool_authorization_master__c = 'HON approval';                              
        newtool.auto_approve__c = 'Not Allowed';         
        newtool.tool_active__c = true;           
        insert newtool; 
        
        portal_tools_master__c newtool1 = new portal_tools_master__c();     
        newtool1.name = 'Test Tool for code coverage';    
        newtool1.tool_Description__c = 'Tool description';                
        newtool1.tool_authorization_master__c = 'HON approval';                              
        newtool1.auto_approve__c = 'Not Allowed';         
        newtool1.tool_active__c = true;
        try{           
            insert newtool;                          
            }catch(Exception e){
                System.debug(e.getMessage());
            }
      
        account newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='ATR';
        insert newAcct;
        
        
        newAcct.Strategic_Business_Unit__c='Intercompany';
        update newAcct;          
    
        List<Portal_Tools_Master__c> toolMaster=[select id,Tool_Authorization_Master__c from Portal_Tools_Master__c where name='Test Tool for code coverage'];
        Account_Tools__c newAcctToolObj=new Account_Tools__c();
        newAcctToolObj.name='Test Tool for code coverage';
        newAcctToolObj.Portal_Tool_Master_name__c=toolMaster.get(0).id;
        newAcctToolObj.Account_Name__c=newacct.id;
        newAcctToolObj.Authorization_Method__c=toolMaster.get(0).Tool_Authorization_Master__c;
        insert newAcctToolObj;                   
                
  
        Apexpages.Standardcontroller sc=new Apexpages.Standardcontroller(newAcctToolObj);
        Apexpages.currentPage().getParameters().put('id',newAcctToolObj.Id);
        EditAccountTools eatObj=new EditAccountTools(sc);
        
        eatObj.getToolList();
        eatObj.toolName='Test Tool for code coverage';
        
        eatObj.getAuthorizationList();
        eatObj.authorizationMethod='HON approval';
        eatObj.AccountName=newAcctToolObj.Account_Name__c;
        
        eatObj.save();
        
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
delete tool;
Test.stopTest();

}

static testMethod void ToolNameUpdateInAssociateObjs(){
Test.startTest();
Portal_Tools_Master__c tool=new Portal_Tools_Master__c();
tool.name='Test Tool';
tool.Tool_Description__c='Test Tool desc';
insert tool;
tool.name='Test Tool1';
update tool;
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
/*static testMethod void updateContactToolAccess(){
Test.startTest();
        portal_tools_master__c newtool = new portal_tools_master__c();     
        newtool.name = 'Test Tool1';    
        newtool.tool_Description__c = 'Tool description';                
        newtool.tool_authorization_master__c = 'HON approval';                              
        newtool.auto_approve__c = 'Not Allowed';         
        newtool.tool_active__c = true;           
        insert newtool; 
        
        account newAcct = new account();
        newAcct.name = 'test account code coverage2';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='ATR';
        insert newAcct;
        Contact cont=new Contact();
        cont.LastName='Test Contatct Name';
        cont.accountid=newAcct.id;
        cont.Primary_Email_Address__c='test@test.com';
        cont.Email='test@test.com';
        insert cont;
        Contact_Tool_Access__c conToolAccess=new Contact_Tool_Access__c();
        conToolAccess.CRM_Contact_ID__c=cont.id;
        conToolAccess.Portal_Tool_Master__c=newtool.id;
        conToolAccess.name=newtool.name;
        conToolAccess.Request_Status__c='Pending';
        insert conToolAccess;
        
        Id rcrdtypeid=[select id from recordtype where name='General' and SobjectType='Case' limit 1].Id;
        system.debug('Record Type Id is:'+rcrdtypeid);
        
        Case newCase=new Case();
        newCase.Origin='Web';
        newCase.status='Open';
        newCase.Type='Web Portal Registration';
        newCase.contactid=cont.id;
        newCase.accountid=newAcct.id;
        newCase.Tool_Name__c='Test Tool1';
        newCase.Tool_Comments__c='Test Comments';
        newCase.Tool_Authorization_Method__c='HON approval';
        newCase.Product_Type__c='Services';
        newCase.Catalog_Product_Group__c='Cabin(SV)';
        newCase.Supported_Product__c='OneLink';
        newCase.recordtypeid=rcrdtypeid;
        insert newCase;
        newCase.Product_Type__c='Services';
        newCase.Catalog_Product_Group__c='Cabin(SV)';
        newCase.Supported_Product__c='OneLink';
        newCase.Export_Compliance_Content_ITAR_EAR__c='No';
        newCase.Government_Compliance_SM_M_Content__c='No';
        newCase.status='Denied';
        newCase.Resolution__c='testRes';
        newCase.recordtypeid=rcrdtypeid;
        update newCase;
        
        
Test.stopTest();
}*/

static testMethod void exportContToolAccess(){
Test.startTest();
ContactToolAccessExportController ctaec=new ContactToolAccessExportController();

Test.stoptest();
}

}