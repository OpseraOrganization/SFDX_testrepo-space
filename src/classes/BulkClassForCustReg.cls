public class BulkClassForCustReg{

    public void deleteToolFromTemplate(List<String> mapTools){
        String query='select id,Portal_Access_Templates__c,Portal_Tools_Master__c from Template_Tools__c where name in '+mapTools;
        id batchinstanceid = database.executeBatch(new BatchDeleteToolFromTemplates(query)); 
    }
    public void deleteToolFromAccount(List<String> mapTools){
        String query='select Account_Name__c, Id, Name, Portal_Tool_Master_Name__c  from Account_Tools__c where name in '+mapTools;
        id batchinstanceid = database.executeBatch(new BatchDeleteToolFromTemplates(query)); 
    }
    public void deleteToolFromContact(List<String> mapTools){
        String query='select id,CRM_Contact_ID__c, Name, Portal_Tool_Master__c  from Contact_Tool_Access__c where name in '+mapTools;
        id batchinstanceid = database.executeBatch(new BatchDeleteToolFromTemplates(query)); 
    }
    
    //below methods for updating tool name when user is editing the tool name in tool master
    
    public void updateToolNameInTempTools(String ToolId,String ToolName){
        String query='select id,name,Portal_Access_Templates__c,Portal_Tools_Master__c from Template_Tools__c where Portal_Tools_Master__c =\''+ToolId+'\'';
        id batchinstanceid = database.executeBatch(new BatchUpdToolNameInTmpTls(query,ToolName)); 
    }
    public void updateToolNameInAccTools(String ToolId,String ToolName){
        String query='select Account_Name__c, Id, Name, Portal_Tool_Master_Name__c  from Account_Tools__c where Portal_Tool_Master_Name__c =\''+ToolId+'\' AND Account_Name__r.Customer_Status__c=\'Active\'';
        id batchinstanceid = database.executeBatch(new BatchUpdToolNameInAccTls(query,ToolName)); 
    }
    public void updateToolNameInConTools(String ToolId,String ToolName){
        String query='select id,CRM_Contact_ID__c, Name, Portal_Tool_Master__c  from Contact_Tool_Access__c where Portal_Tool_Master__c =\''+ToolId+'\'';
        id batchinstanceid = database.executeBatch(new BatchUpdToolNameInConTls(query,ToolName)); 
    }
}