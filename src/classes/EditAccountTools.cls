public class EditAccountTools{
public String toolName{get;set;}
public String authorizationMethod{get;set;}
public Account_Tools__c AccountTools;
public String AccountName{get;set;}
public String accountId{get;set;}
private Account_Tools__c tempToolsObj;
public String accountToolId{get;set;}
public EditAccountTools(Apexpages.StandardController sc){

 accountToolId=Apexpages.currentpage().getparameters().get('id');
 System.debug('accountToolId=========1 '+accountToolId);
 if(accountToolId!=null && accountToolId!=''){
     Account_Tools__c editTempToolObj=[select Id,Portal_Tool_Master_Name__c,Authorization_Method__c,Name from Account_Tools__c where id=:accountToolId];     
     toolName=editTempToolObj.Name.trim();
     authorizationMethod=editTempToolObj.Authorization_Method__c.trim();
 }
 tempToolsObj=(Account_Tools__c)sc.getRecord();
 AccountName=tempToolsObj.Account_Name__c;
 accountId=tempToolsObj.Id;
 
}

public PageReference save(){
    PageReference viewPage;
    System.debug('toolName========= '+toolName);
    System.debug('AccountName========= '+AccountName);
    System.debug('authorizationMethod========= '+authorizationMethod);
    System.debug('accountToolId=========2 '+accountToolId);
    List<Portal_Tools_Master__c> toolMaster=[select id from Portal_Tools_Master__c where name=:toolName];
    System.debug('toolMaster.get(0).id========= '+toolMaster.get(0).id);
    if(accountToolId!=null && accountToolId!='' && AccountName!=null && AccountName!=''){    
        List<Account_Tools__c> updateTempToolObj=[select Account_Name__c,Id,Portal_Tool_Master_Name__c,Authorization_Method__c,Name from Account_Tools__c where Portal_Tool_Master_Name__c=:toolMaster.get(0).id and Account_Name__c=:AccountName];
        if(updateTempToolObj!=null && updateTempToolObj.size()>0){
            updateTempToolObj.get(0).name=toolName;
            updateTempToolObj.get(0).Portal_Tool_Master_Name__c=toolMaster.get(0).id;
            updateTempToolObj.get(0).Account_Name__c=AccountName;
            updateTempToolObj.get(0).Authorization_Method__c=authorizationMethod;
            update updateTempToolObj;
            viewPage = new ApexPages.StandardController(updateTempToolObj.get(0)).view();
         }
    }    
    viewPage.setRedirect(true);
    return viewPage;
}

public List<SelectOption> getToolList(){
 List<SelectOption> tempToolList=new List<SelectOption>();
 List<Account_Tools__c> allTools=[select name from Account_Tools__c where Account_Name__c=:AccountName];
 tempToolList.add(new SelectOption('-None-','-None-'));
 for(Account_Tools__c currTool:allTools){
     tempToolList.add(new SelectOption(currTool.name,currTool.name));
 }
 return tempToolList;
}
public List<SelectOption> getAuthorizationList(){
 List<SelectOption> tempToolAuthMethodList=new List<SelectOption>();
 system.debug('toolName---------'+toolName);
 if(toolName!= NULL && toolName!= '-None-'){

     List<Portal_Tools_Master__c> tool=[select name,Tool_Authorization_Master__c,Auto_approve__c  from Portal_Tools_Master__c where name=:toolName];
     
          
     List<Tool_Authorization_Methods_Master__c> allAuthMethods=[select name from Tool_Authorization_Methods_Master__c];
     tempToolAuthMethodList.add(new SelectOption('-None-','-None-'));
     for(Tool_Authorization_Methods_Master__c currMethod:allAuthMethods){
           tempToolAuthMethodList.add(new SelectOption(currMethod.name,currMethod.name));
      }
     
     if(tool!=null && tool.size()>0 && tool.get(0)!=null && tool.get(0).Auto_approve__c!=null && !(tool.get(0).Auto_approve__c=='Allowed')){

         tempToolAuthMethodList=new List<SelectOption>();
         tempToolAuthMethodList.add(new SelectOption('-None-','-None-'));
         tempToolAuthMethodList.add(new SelectOption('Honeywell Approval','Honeywell Approval'));
         tempToolAuthMethodList.add(new SelectOption('Company Admin Approval','Company Admin Approval'));
         tempToolAuthMethodList.add(new SelectOption('Company Admin and Honeywell Approval','Company Admin and Honeywell Approval'));
     }
     
     system.debug('Tool Name---------33----'+toolName);
     List<Account_Tools__c> ToolAuthorization = [select Id,Portal_Tool_Master_Name__c,Authorization_Method__c,Name from Account_Tools__c where Name=:toolName and Account_Name__c=:AccountName];
     authorizationMethod=ToolAuthorization.get(0).Authorization_Method__c;
     system.debug('authorization method-------------'+authorizationMethod);
  }
 return tempToolAuthMethodList;
}
}