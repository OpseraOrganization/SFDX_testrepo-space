public class EditTemplateTools{
public String toolName{get;set;}
public String authorizationMethod{get;set;}
public Template_Tools__c TemplateTools;
public String portalAccessTemplateName{get;set;}
public String templateId{get;set;}
private Template_Tools__c tempToolsObj;
public String templateToolId{get;set;}
public EditTemplateTools(Apexpages.StandardController sc){

 templateToolId=Apexpages.currentpage().getparameters().get('id');
 System.debug('templateToolId========= '+templateToolId);
 if(templateToolId!=null && templateToolId!=''){
     Template_Tools__c editTempToolObj=[select Id,Portal_Tools_Master__c,Authorization_Method__c,Name from Template_Tools__c where id=:templateToolId];     
     toolName=editTempToolObj.Name.trim();
     authorizationMethod=editTempToolObj.Authorization_Method__c.trim();
 }
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
    if(templateToolId!=null && templateToolId!='' && portalAccessTemplateName!=null && portalAccessTemplateName!=''){    
        List<Template_Tools__c> updateTempToolObj=[select Portal_Access_Templates__c,Id,Portal_Tools_Master__c,Authorization_Method__c,Name from Template_Tools__c where Portal_Tools_Master__c=:toolMaster.get(0).id and Portal_Access_Templates__c=:portalAccessTemplateName];
        if(updateTempToolObj!=null && updateTempToolObj.size()>0){
            updateTempToolObj.get(0).name=toolName;
            updateTempToolObj.get(0).Portal_Tools_Master__c=toolMaster.get(0).id;
            updateTempToolObj.get(0).Portal_Access_Templates__c=portalAccessTemplateName;
            updateTempToolObj.get(0).Authorization_Method__c=authorizationMethod;
            update updateTempToolObj;
            String query='select id from account where ATR_Portal_Access_Template__c=\''+portalAccessTemplateName+'\' and Customer_Status__c=\'Active\'';
            id batchinstanceid = database.executeBatch(new BatchUpdateAccntTlFrmTemToolEdit(query,toolName,authorizationMethod,toolMaster.get(0).id)); 
            viewPage = new ApexPages.StandardController(updateTempToolObj.get(0)).view();
         }
    }    
    viewPage.setRedirect(true);
    return viewPage;
}

public List<SelectOption> getToolList(){
 List<SelectOption> tempToolList=new List<SelectOption>();
 List<Template_Tools__c> allTools=[select name from Template_Tools__c where Portal_Access_Templates__c=:portalAccessTemplateName];
 tempToolList.add(new SelectOption('-None-','-None-'));
 for(Template_Tools__c currTool:allTools){
     tempToolList.add(new SelectOption(currTool.name,currTool.name));
 }
 return tempToolList;
}
public List<SelectOption> getAuthorizationList(){
 List<SelectOption> tempToolAuthMethodList=new List<SelectOption>();
 system.debug('toolName---------'+toolName);
 if(toolName!= null && toolName!= '-None-'){

     //List<Portal_Tools_Master__c> tool=[select name,Tool_Authorization_Master__c  from Portal_Tools_Master__c where name=:toolName];
     List<Portal_Tools_Master__c> tool=[select name,Auto_approve__c  from Portal_Tools_Master__c where name=:toolName];

     
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
     List<Template_Tools__c> ToolAuth=[select Portal_Access_Templates__c,Id,Portal_Tools_Master__c,Authorization_Method__c,Name from Template_Tools__c where Portal_access_templates__c =: portalAccessTemplateName and Name =: toolName];
     authorizationMethod = ToolAuth.get(0).Authorization_Method__c;
  }
 return tempToolAuthMethodList;
}
}