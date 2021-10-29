public class AddTemplateTools{
public String toolName{get;set;}
public String authorizationMethod{get;set;}
public Template_Tools__c TemplateTools;
public String portalAccessTemplateName{get;set;}
public String templateId{get;set;}
private Template_Tools__c tempToolsObj;
public String templateToolId{get;set;}
public AddTemplateTools(Apexpages.StandardController sc){
 tempToolsObj=(Template_Tools__c)sc.getRecord();
 portalAccessTemplateName=tempToolsObj.Portal_Access_Templates__c;
 templateId=tempToolsObj.Id;
 
}

public PageReference save(){
    PageReference viewPage;
    System.debug('toolName========= '+toolName);
    System.debug('portalAccessTemplateName========= '+portalAccessTemplateName);
    System.debug('authorizationMethod========= '+authorizationMethod);
    System.debug('templateToolId========= '+templateToolId);
    List<Portal_Tools_Master__c> toolMaster=[select id from Portal_Tools_Master__c where name=:toolName];
    System.debug('toolMaster.get(0).id========= '+toolMaster.get(0).id);
    Template_Tools__c newTempToolObj=new Template_Tools__c();
    newTempToolObj.name=toolName;
    newTempToolObj.Portal_Tools_Master__c=toolMaster.get(0).id;
    newTempToolObj.Portal_Access_Templates__c=portalAccessTemplateName;
    newTempToolObj.Authorization_Method__c=authorizationMethod;
    insert newTempToolObj;
    String query='select id from account where ATR_Portal_Access_Template__c=\''+portalAccessTemplateName+'\' and Customer_Status__c=\'Active\'';
    id batchinstanceid = database.executeBatch(new BatchUpdateAccountToolFromTemplates(query,toolName,authorizationMethod,toolMaster.get(0).id)); 
    viewPage = new ApexPages.StandardController(newTempToolObj).view();
    viewPage.setRedirect(true);
    return viewPage;
}

public List<SelectOption> getToolList(){
 List<SelectOption> tempToolList=new List<SelectOption>();
 //List<Portal_Tools_Master__c> allTools=[select name from Portal_Tools_Master__c];
 List<Portal_Tools_Master__c> allTools=[select name from Portal_Tools_Master__c where id not in (select Portal_Tools_Master__c from Template_Tools__c where Portal_Access_Templates__c =: portalAccessTemplateName)];

 tempToolList.add(new SelectOption('-None-','-None-'));
 for(Portal_Tools_Master__c currTool:allTools){
     tempToolList.add(new SelectOption(currTool.name,currTool.name));
 }
 return tempToolList;
}
public List<SelectOption> getAuthorizationList(){
 List<SelectOption> tempToolAuthMethodList=new List<SelectOption>();
 system.debug('toolName---------'+toolName);
 if(toolName!= NULL && toolName!= '-None-'){

     //List<Portal_Tools_Master__c> tool=[select name,Tool_Authorization_Master__c  from Portal_Tools_Master__c where name=:toolName];
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
  authorizationMethod = tool.get(0).Tool_Authorization_Master__c;
  }
 return tempToolAuthMethodList;
}
}