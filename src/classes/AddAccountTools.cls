public class AddAccountTools{
public String toolName{get;set;}
public String authorizationMethod{get;set;}
public Account_Tools__c AccountTools;
public String portalAccessAccountName{get;set;}
public String AccountId{get;set;}
private Account_Tools__c tempToolsObj;
public AddAccountTools(Apexpages.StandardController sc){
 tempToolsObj=(Account_Tools__c)sc.getRecord();
 portalAccessAccountName=tempToolsObj.Account_Name__c;
 AccountId=tempToolsObj.Id;
}

public PageReference save(){
    System.debug('toolName========= '+toolName);
    System.debug('portalAccessAccountName========= '+portalAccessAccountName);
    System.debug('authorizationMethod========= '+authorizationMethod);
    List<Portal_Tools_Master__c> toolMaster=[select id from Portal_Tools_Master__c where name=:toolName];
    Account_Tools__c newTempToolObj=new Account_Tools__c();
    newTempToolObj.name=toolName;
    newTempToolObj.Portal_Tool_Master_name__c=toolMaster.get(0).id;
    newTempToolObj.Account_Name__c=portalAccessAccountName;
    newTempToolObj.Authorization_Method__c=authorizationMethod;
    try{
        insert newTempToolObj;
    }catch(Exception e){
        System.debug(e);
    }
    PageReference viewPage = new ApexPages.StandardController(newTempToolObj).view();
    viewPage.setRedirect(true);
    return viewPage;
}

public List<SelectOption> getToolList(){
 List<SelectOption> tempToolList=new List<SelectOption>();
 //List<Portal_Tools_Master__c> allTools=[select name from Portal_Tools_Master__c];
 List<Portal_Tools_Master__c> allTools=[select name from Portal_Tools_Master__c where id not in (select portal_tool_master_name__c from Account_Tools__c where account_name__c =: portalAccessAccountName)];
 tempToolList.add(new SelectOption('-None-','-None-'));
 for(Portal_Tools_Master__c currTool:allTools){
     tempToolList.add(new SelectOption(currTool.name,currTool.name));
 }
 return tempToolList;
}
public List<SelectOption> getAuthorizationList(){
 List<SelectOption> tempToolAuthMethodList=new List<SelectOption>();
 system.debug('toolName---------'+toolName);
 
 if(toolName!= NULL && toolName != '-None-'){

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
     authorizationMethod=tool.get(0).Tool_Authorization_Master__c;
  }
 return tempToolAuthMethodList;
}
}