/** * File Name: REG_PortalToolAccess_Service

* Description  Get the status of tools for honeywell Id

* * @author : TCS 

Date 01/18/2019 

* */

public with sharing class REG_PortalToolAccess_Service{
    
    public static string chkToolStatus(string honId, string toolId ){
        Id conId;
        object toolObj;
        REG_ToolWrapper toolStatus = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
        
        toolObj= REG_PortalContact_Service.getSpecificToolStatus(honId, toolId).data;
        
        toolStatus= (REG_ToolWrapper) toolObj;
        
        //system.debug('****toolStatus' +toolStatus.status);
        return toolStatus.status ; 
        
    }
    
    public static REG_Result checkToolAccess(string honId, string toolId, Contact_Tool_Access__c conToolA,Contact_Aircraft__c conAir,List<REG_API_PortalContactTools.soldTosWrappper> sapConList, contact con, string McorePlatformOfMostInterest,string typeOfDB){
        string caseAdditionalInfo;
        REG_Result Result = new REG_Result();
        REG_Result conToolData = new REG_Result();
        Contact_Tool_Access__c contactToolAccess = new Contact_Tool_Access__c();
        Id conId;
        object toolObj;
        object toolObj1;
        object toolObj2;
        boolean isInternal = false;
        List<SAP_Contact_Sold_To__c> soldToIdList = new List<SAP_Contact_Sold_To__c>();
        List<SAP_Contact_Sold_To__c> soldToIdListWrntyClm = new List<SAP_Contact_Sold_To__c>();
        List<SAP_Contact_Sold_To__c> soldToIdListNew = new List<SAP_Contact_Sold_To__c>();
        List<Account_Contact__c > accountIdListInsert = new List<Account_Contact__c >();
        List<Map<string,Contact_Tool_Access__c>> conToolMapList = new List<Map<string,Contact_Tool_Access__c>>();
        List<Map<string,Case>> casemapList = new List<Map<string,Case>>();
        Map<string,Case> caseMap = new Map<string,Case>();
        Map<Id,Account_Contact__c> accIdMap = new Map<Id, Account_Contact__c>();
        Map<string,Contact_Tool_Access__c> conTListMap = new Map<string,Contact_Tool_Access__c>();        
        List<string> toolIds = new List<string>();
        Map<string,string> requestStatConMap = new Map<string,string>();
        Map<string,string> requestStatCasMap = new Map<string,string>();
        Map<string,string> casCommMap = new Map<string,string>();
        
        Savepoint sp= Database.setSavepoint();
        try{ 
            //get contact id from honid
            conId = REG_PortalContact_Service.getContact(honId);
            if(string.isBlank(conId)){
                result.handleError(404, 'Contact details not found for the given honeywell id', 'Please provide a valid honeywell id.');
                return result;
            }
            //check if user is internal
            List<Contact> contList=new List<Contact>([SELECT Id,Primary_Email_Address__c from Contact WHERE Id =:conId]);
            system.debug('con list'+contList);
            String domain = contList[0].Primary_Email_Address__c.substring(contList[0].Primary_Email_Address__c.lastIndexOf('@')+1);
            system.debug('*****domain*' +domain);
            list<Account_Email_Domains__c> results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name FROM Account_Email_Domains__c where Account_Email_Domain__c = :Domain];
            if(!results.isEmpty()){
                isInternal = results[0].Internal_Email_Domain__c;
            }
            
            REG_ToolWrapper toolStatus = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
            
            toolObj= REG_PortalContact_Service.getSpecificToolStatus(honId, toolId).data;
            
            toolStatus= (REG_ToolWrapper) toolObj;       
            if(toolStatus == null){
                result.handleError(404, 'Invalid Tool Id OR Tool is not active', 'Please provide a valid tool Id.');
                return result;                
            }
            system.debug('***toolStatus.status : '+toolStatus.status);
            if(toolStatus.status != 'Not Requested' && toolStatus.status != 'Denied'){
                // response creation
                List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                if(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c.contains(toolId)){
                     toolObj1= REG_PortalContact_Service.getSpecificToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c).data;
                     toolObj2= REG_PortalContact_Service.getSpecificToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c).data;
                     REG_ToolWrapper toolStatus1 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
                     REG_ToolWrapper toolStatus2 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
                     toolStatus1= (REG_ToolWrapper) toolObj1;  
                     toolStatus2= (REG_ToolWrapper) toolObj2; 
                     resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c, toolStatus1.status));
                     resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c, toolStatus2.status)); 
                }
                if(REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c.contains(toolId)){
                     toolObj1= REG_PortalContact_Service.getSpecificToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c).data;
                     toolObj2= REG_PortalContact_Service.getSpecificToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c).data;
                     REG_ToolWrapper toolStatus1 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
                     REG_ToolWrapper toolStatus2 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
                     toolStatus1= (REG_ToolWrapper) toolObj1;  
                     toolStatus2= (REG_ToolWrapper) toolObj2; 
                     resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c, toolStatus1.status));
                     resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c, toolStatus2.status)); 
                
                }
                if(REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c.contains(toolId)){
                     toolObj1= REG_PortalContact_Service.getSpecificToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c).data;
                     toolObj2= REG_PortalContact_Service.getSpecificToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c).data;
                     REG_ToolWrapper toolStatus1 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
                     REG_ToolWrapper toolStatus2 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
                     toolStatus1= (REG_ToolWrapper) toolObj1;  
                     toolStatus2= (REG_ToolWrapper) toolObj2; 
                     resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c, toolStatus1.status));
                     resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c, toolStatus2.status));                 
                }
                if((REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c.contains(toolId))
                    || (REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c.contains(toolId))){
                     toolObj1= REG_PortalContact_Service.getSpecificToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c).data;               
                     REG_ToolWrapper toolStatus1 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
                     toolStatus1= (REG_ToolWrapper) toolObj1;
                     resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, toolStatus1.status));  
               }                
                conId = REG_PortalContact_Service.getContact(honId);
                
                resDataList.add(new REG_PortalContact_Service.toolsWrap(toolId, toolStatus.status));
                REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                result.resource= finalData;           
                
                return result;  
            }
            
            system.debug('***test toolId****');
            //get accountId for contact
            String accountId=REG_PortalContact_Service.GetAccountId(conId);
            
            system.debug('***test toolId'+toolId);
            system.debug('***test accountId****'+accountId);
            
            //1st set of tools
            if((REG_Master_Tool_Name__c.getValues('Reg Bendix/King Dealer Access').tool_id__c.contains(toolId)) || 
               (REG_Master_Tool_Name__c.getValues('REG Core Returns Management System').tool_id__c.contains(toolId)) || 
               (REG_Master_Tool_Name__c.getValues('REG MyGDC - Global Data Center').tool_id__c.contains(toolId)) ||
               (REG_Master_Tool_Name__c.getValues('REG Warranty and Programs').tool_id__c.contains(toolId))) {
                   system.debug('***reg Warranty1');
                   if(REG_Master_Tool_Name__c.getValues('Reg Bendix/King Dealer Access').tool_id__c.contains(toolId)){
                       toolIds.add(REG_Master_Tool_Name__c.getValues('Reg Bendix/King Dealer Access').tool_id__c);
                       requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('Reg Bendix/King Dealer Access').tool_name__c, 'Pending');
                   }
                   if(REG_Master_Tool_Name__c.getValues('REG Core Returns Management System').tool_id__c.contains(toolId)){
                       toolIds.add(REG_Master_Tool_Name__c.getValues('REG Core Returns Management System').tool_id__c);
                       requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Core Returns Management System').tool_name__c, 'Pending');
                   }
                   if(REG_Master_Tool_Name__c.getValues('REG MyGDC - Global Data Center').tool_id__c.contains(toolId)){
                       toolIds.add(REG_Master_Tool_Name__c.getValues('REG MyGDC - Global Data Center').tool_id__c);
                       requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG MyGDC - Global Data Center').tool_name__c, 'Pending');
                   }
                   if(REG_Master_Tool_Name__c.getValues('REG Warranty and Programs').tool_id__c.contains(toolId)){
                       //though we are taking input we are not mapping it anywhere at present. But in future it will be mapped with SoldtoToolAccess__c as warranty Claims
                       toolIds.add(REG_Master_Tool_Name__c.getValues('REG Warranty and Programs').tool_id__c);
                       requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Warranty and Programs').tool_name__c, 'Pending');
                       system.debug('***reg Warranty2');
                       if(!isInternal){
                       if(sapConList == null){
                           //throw new stringException('Params /SAPcontactSoldTos/ missing from request body ');
                           result.handleError(400, 'Params /SAPcontactSoldTos/ missing from request body', 'Please provide the required inputs');
                           return result;                    
                       }
                       for(REG_API_PortalContactTools.soldTosWrappper scs :sapConList){
                           SAP_Contact_Sold_To__c sapConSoldTo = new SAP_Contact_Sold_To__c();
                            if(string.isBlank(scs.soldToId)){
                               result.handleError(400, 'Please provide Sold to Id', 'Param : soldToId is not provided.');
                               return result;                        
                            }
                           if(string.isBlank(scs.soldToToolAccess)){
                               result.handleError(400, 'Please provide soldToToolAccess', 'Request Body : soldToToolAccess is not provided.');
                               return result;                        
                            }
                           
                        }
                   }
                       
                       
                   }
                   requestStatConMap.put(toolId, 'Pending');
                   
                   contactToolAccess= new contact_tool_access__c();
                   map<string,string> caseComments = new map<string,string>(); 
                   //system.debug('inside benedix');
                   REG_PortalContact_Service.createTool(honId,toolIds,conId, contactToolAccess, requestStatConMap) ;   
                   //system.debug('****requestStatCasMap '+requestStatCasMap );
                   //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,null,requestStatCasMap );
                    REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,null,requestStatCasMap);
                    // enqueue the job for processing
                    ID jobID = System.enqueueJob(updateJob);
                   
                   // response creation
                   List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                   resDataList.add(new REG_PortalContact_Service.toolsWrap(toolId, 'Pending'));
                   REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                   result.resource= finalData;
                   
               } 
            
 
            
            //2nd set of tools
            if((REG_Master_Tool_Name__c.getValues('REG eFindings / Historical Findings').tool_id__c.contains(toolId)) || 
               (REG_Master_Tool_Name__c.getValues('REG Honeywell Training').tool_id__c.contains(toolId)) || 
               (REG_Master_Tool_Name__c.getValues('REG Technical Knowledge Center').tool_id__c.contains(toolId)) ) {  
                   
                   if(REG_Master_Tool_Name__c.getValues('REG eFindings / Historical Findings').tool_id__c.contains(toolId)){
                       toolIds.add(REG_Master_Tool_Name__c.getValues('REG eFindings / Historical Findings').tool_id__c);
                       requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG eFindings / Historical Findings').tool_name__c, 'Approved');
                   }
                   if(REG_Master_Tool_Name__c.getValues('REG Honeywell Training').tool_id__c.contains(toolId)){
                       toolIds.add(REG_Master_Tool_Name__c.getValues('REG Honeywell Training').tool_id__c);
                       requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Honeywell Training').tool_name__c, 'Approved');
                   }
                   if(REG_Master_Tool_Name__c.getValues('REG Technical Knowledge Center').tool_id__c.contains(toolId)){
                       toolIds.add(REG_Master_Tool_Name__c.getValues('REG Technical Knowledge Center').tool_id__c);
                       requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Technical Knowledge Center').tool_name__c, 'Approved');
                   }
                   requestStatConMap.put(toolId, 'Approved');
                   
                   contactToolAccess= new contact_tool_access__c();
                   map<string,string> caseComments = new map<string,string>();
                   REG_PortalContact_Service.createTool(honId,toolIds,conId,contactToolAccess,requestStatConMap) ;   
                   //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,null,requestStatCasMap);
                    REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,null,requestStatCasMap);
                    // enqueue the job for processing
                    ID jobID = System.enqueueJob(updateJob);                   
                   // response creation
                   List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                   resDataList.add(new REG_PortalContact_Service.toolsWrap(toolIds[0], 'Approved'));
                   REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                   result.resource= finalData;
               }    
            
            //3rd set of tool
            if(REG_Master_Tool_Name__c.getValues('REG Contracts/Reporting').tool_id__c.contains(toolId)){
                toolIds.add(REG_Master_Tool_Name__c.getValues('REG Contracts/Reporting').tool_id__c);
                requestStatConMap.put(toolId, 'Pending');
                requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Contracts/Reporting').tool_name__c, 'Pending');             
                contactToolAccess= new contact_tool_access__c();
                map<string,string> caseComments = new map<string,string>();
                if(conAir != null){
                    caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+(!string.isBlank(conAir.Aircraft_Make__c)?conAir.Aircraft_Make__c:'')+'\n'+'Model:'+(!string.isBlank(conAir.Aircraft_Model__c)?conAir.Aircraft_Model__c:'')+'\n'+'Serial Number:'+(!string.isBlank(conAir.Aircraft_Serial_Number__c)?conAir.Aircraft_Serial_Number__c:'')+
                        '\n'+'Tail Number:'+(!string.isBlank(conAir.Aircraft_Tail_Number__c)?conAir.Aircraft_Tail_Number__c:'')+'\n'+'Engine APU Serial Number:'+(!string.isBlank(conAir.Aircraft_Engine_Serial__c)?conAir.Aircraft_Engine_Serial__c:'')+'\n'+'Contract Type:'+(!string.isBlank(conAir.Aircraft_FMS__c)?conAir.Aircraft_FMS__c:'')+
                        '\n'+'Contract Number:'+(!string.isBlank(conAir.Aircraft_Contract_Num__c)?conAir.Aircraft_Contract_Num__c:'');
                }else{
                    caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+''+'\n'+'Model:'+''+'\n'+'Serial Number:'+''+'\n'+'Tail Number:'+''+'\n'+'Engine APU Serial Number:'+''+'\n'+'Contract Type:'+''+'\n'+'Contract Number:'+'';
                }           
                REG_PortalContact_Service.createTool(honId,toolIds, conId, contactToolAccess,requestStatConMap) ;
                //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,caseAdditionalInfo,requestStatCasMap);
                REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,caseAdditionalInfo,requestStatCasMap);
                // enqueue the job for processing
                ID jobID = System.enqueueJob(updateJob);                
                // response creation
                List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                resDataList.add(new REG_PortalContact_Service.toolsWrap(toolId, 'Pending'));
                REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                result.resource= finalData;
            }
            
            //4th set of tool
            if(REG_Master_Tool_Name__c.getValues('REG MCORE').tool_id__c.contains(toolId)){
                toolIds.add(REG_Master_Tool_Name__c.getValues('REG MCORE').tool_id__c);
                requestStatConMap.put(toolId, 'Pending');
                requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG MCORE').tool_name__c, 'Pending');            
                map<string,string> caseComments = new map<string,string>();
                system.debug(logginglevel.info,'mcoreInterest'+McorePlatformOfMostInterest);
                List<string> mcoreBreak = McorePlatformOfMostInterest.split(',');
                if(mcoreBreak.size() == 3){
                    conToolA.MCORE_Platform_of_most_interest1__c = mcoreBreak[0];
                    conToolA.MCORE_Platform_of_most_interest2__c = mcoreBreak[1];
                    conToolA.MCORE_Platform_of_most_interest3__c = mcoreBreak[2];      
                }
                if(mcoreBreak.size() == 2){
                    conToolA.MCORE_Platform_of_most_interest1__c = mcoreBreak[0];
                    conToolA.MCORE_Platform_of_most_interest2__c = mcoreBreak[1];
                }
                if(mcoreBreak.size() == 1){
                    conToolA.MCORE_Platform_of_most_interest1__c = mcoreBreak[0];
                    
                }                                
                REG_PortalContact_Service.createTool(honId,toolIds, conId,conToolA,requestStatConMap) ;
                //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,null,requestStatCasMap);
                REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,null,requestStatCasMap);
                // enqueue the job for processing
                ID jobID = System.enqueueJob(updateJob);                
                // response creation
                List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                resDataList.add(new REG_PortalContact_Service.toolsWrap(toolId, 'Pending'));
                REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                result.resource= finalData;
                
            } 
            
            //5th set of tool
            if(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c.contains(toolId) || 
               REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c.contains(toolId) || 
               REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c.contains(toolId)){
                   
                   SET<Id> accidUnique = new SET<Id>();
                   toolIds.add(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c);
                   toolIds.add(REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c);
                   toolIds.add(REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c);
                   requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c, 'Approved');
                   requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_name__c, 'Approved'); 
                   requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c, 'Approved');
                   requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_name__c, 'Approved'); 
                   requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c, 'Approved');
                   requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Order Status').tool_name__c, 'Approved');  
                  /*
                   soldToIdList = [SELECT Id FROM SAP_Contact_Sold_To__c where Contact__c =: conId and SoldtoToolAccess__c =: 'OrdersReturns'];
                   //system.debug('****soldToIdList'+soldToIdList);    
                   if(!soldToIdList.isEmpty() ){
                       Delete soldToIdList;
                       
                   }
                   if(sapConList == null){
                       //throw new stringException('Params /SAPcontactSoldTos/ missing from request body ');
                       result.handleError(400, 'Params /SAPcontactSoldTos/ missing from request body', 'Please provide the required inputs');
                       return result;                    
                   }
                   
                   //system.debug('****sapConList'+sapConList);
                   for(REG_API_PortalContactTools.soldTosWrappper scs :sapConList){
                       //system.debug('****sCS'+scs);
                       SAP_Contact_Sold_To__c sapConSoldTo = new SAP_Contact_Sold_To__c();
                       if(string.isBlank(scs.soldToId) ){
                           //throw new stringException('Required Param is missing (SAP_Account_Sold_To__c)');
                           result.handleError(400, 'Required Param is missing (SAP_Account_Sold_To__c)', 'Please provide the required inputs');
                           return result;                        
                       }
                       sapConSoldTo.SAP_Account_Sold_To__c = scs.soldToId;
                       sapConSoldTo.SoldtoToolAccess__c = 'OrdersReturns';
                       sapConSoldTo.Contact__c = conId;
                       sapConSoldTo.Name =  scs.accountName;
                       //system.debug('****sapConSoldTo'+sapConSoldTo);
                       soldToIdListNew.add(sapConSoldTo);
                       accidUnique.add(scs.accountId); 
                       //system.debug('****soldToIdList'+soldToIdList);
                   }
                   //system.debug('****soldToIdList'+soldToIdList);
                   if(!soldToIdListNew.isEmpty()){
                       insert soldToIdListNew;    
                   }
                   */
                    if(!isInternal){  
                            if(sapConList == null){
                               result.handleError(400, 'Params /SAPcontactSoldTos/ missing from request body', 'Please provide the required inputs');
                               return result;                    
                            }
                           
                           list<String> soldToToolAccOR =  new list<String>();
                           // SET<Id> accidUnique1 = new SET<Id>();
                            for(REG_API_PortalContactTools.soldTosWrappper soldtoAcc :sapConList){
                                soldToToolAccOR.add(soldtoAcc.soldToToolAccess);                
                            }
                            if(!soldToToolAccOR.isEmpty()){               
                                soldToIdList=[SELECT Id FROM SAP_Contact_Sold_To__c where Contact__c =:conId and SoldtoToolAccess__c IN :soldToToolAccOR];
                            }
    
                            if(!soldToIdList.isEmpty()){
                                Delete soldToIdList;
                                soldToIdList= new List<SAP_Contact_Sold_To__c >();
                            }
                           
                            for(REG_API_PortalContactTools.soldTosWrappper scs :sapConList){
                               SAP_Contact_Sold_To__c sapConSoldTo = new SAP_Contact_Sold_To__c();
                                if(string.isBlank(scs.soldToId)){
                                   result.handleError(400, 'Please provide Sold to Id', 'Param : soldToId is not provided.');
                                   return result;                        
                                }
                               if(string.isBlank(scs.soldToToolAccess)){
                                   result.handleError(400, 'Please provide soldToToolAccess', 'Request Body : soldToToolAccess is not provided.');
                                   return result;                        
                                }
                               sapConSoldTo.SAP_Account_Sold_To__c = scs.soldToId;
                               sapConSoldTo.SoldtoToolAccess__c = scs.soldToToolAccess;
                               sapConSoldTo.Contact__c = conId;
                               sapConSoldTo.Name =  scs.accountName;
                               soldToIdListNew.add(sapConSoldTo);
                               accidUnique.add(scs.accountId); 
                            }
                            if(!soldToIdListNew.isEmpty()){
                                insert soldToIdListNew;
                            }
                       
                       
                       
                       List<Account_Contact__c> recList = new List<Account_Contact__c>();
                       Set<Id> existingAccountLink = new Set<Id>();
                       if(!accidUnique.isEmpty()){  
                           for(Account_Contact__c accContLink :[select Id,Account_Name__c,Contact__c from Account_Contact__c where Account_Name__c in:accidUnique and Contact__c =:conId]){
                               existingAccountLink.add(accContLink.Account_Name__c);
                           }
                           
                           for(Id accId : accidUnique) {
                               if(!existingAccountLink.contains(accId )){
                                   Account_Contact__c acconlist = new Account_Contact__c();                
                                   acconlist.Account_Name__c = accId;
                                   acconlist.Contact__c = conId;
                                   recList.add(acconlist);
                               }
                               
                           }  
                       }     
                       if(!recList.isEmpty())   {
                           insert recList;
                       }            
                   }
                   contactToolAccess = new contact_tool_access__c();
                   map<string,string> caseComments = new map<string,string>();
                   REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                   //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,null,requestStatCasMap ); 
                   REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,null,requestStatCasMap);
                   // enqueue the job for processing
                   ID jobID = System.enqueueJob(updateJob);
                   
                   // response creation
                   List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                   resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Online Ordering').tool_id__c, 'Approved'));
                   resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Product Returns and Repairs').tool_id__c, 'Approved'));
                   resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Order Status').tool_id__c, 'Approved'));
                   REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                   result.resource= finalData;
                   
                   
                   
               } 
            if(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_id__c.contains(toolId)){
                List<contact> conList = new List<contact>();
                List<country__c> countryList = new List<country__c>();
                List<string> countryCodes = new List<string>();
                string conAddCountryCode = '';
                string conAccCountryCode = '';
                string citizenshipConCode = '';
                boolean isEmbarConAdd = false;
                boolean isSancConAdd = false;
                boolean isSancAcc = false ;
                boolean isEmbarAcc = false ;
                boolean isSancCitizn =false;
                boolean isEmbarCitizn = false;
                string country = '' ;
                boolean isGeneric = false;
                Map<string, country__c> contMap = new Map<string, country__c>();
                List<country__c> cList = new List<country__c>();
                // Map<string, string> conMap = new Map<string,string>();
                contact conRec = new contact();
                List<string> countrList = new List<string>();
                toolIds.add(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_id__c);
                
                conList = [select Name, Email, phone,phone_1__c, mobilePhone, account.name,Address_Line_1__c, Address_Line_2__c,Address_Line_3__c,City_Name__c, State_Name__c, Country_Code__c,State_Code__c,Postal_Code__c, Country_Name__c,Job_Title__c, account.country__c,Account.ATR_Portal_Access_Template__c,(select Report_Country_Codes__c,Reporting_Address_Postal_Code__c,Reporting_Address_State_Code__c, Reporting_City_Name__c from Contact_Addresses__r where Contact__c =:conId and Is_Primary_Address__c = true) from contact where Id = : conId];
                //system.debug('conList' +conList);
                if(!conList.isEmpty()){
                    country = conList[0].account.country__c;
                    if(conList[0].Contact_Addresses__r.size()>0){
                    conAddCountryCode = conList[0].Contact_Addresses__r[0].Report_Country_Codes__c;
                    system.debug('conAddCountryCode***'+conAddCountryCode);
                    }else{
                         result.handleError(422, 'Bad data', 'Contact Address is empty for honeywell Id: ' +honId + ' and access request cannot be completed for toolId: ' +toolId);
                    return result;
                    }
                    countryCodes.add(conAddCountryCode);
                    if(conList[0].Account.ATR_Portal_Access_Template__c == system.label.REG_IS_HOLDING_ACCOUNTID){
                        
                        
                        isGeneric =true;
                    }    
                    
                }
                system.debug('isGeneric'+isGeneric);
                // system.debug('conAddCountryCode ' + conAddCountryCode );
                if(con != null && !string.isBlank(con.Citizenship_Country__c)){
                    cList = [select ISO_Country_Code__c,name,id from country__c where Name = :con.Citizenship_Country__c];
                }
                //system.debug('cList' +cList);
                if(!cList.isEmpty()){
                    citizenshipConCode = cList[0].ISO_Country_Code__c;
                    cList = new List<country__c>();
                }
                //system.debug('citizenshipConCode ' + citizenshipConCode );
                cList = [select ISO_Country_Code__c,name,id from country__c where Id = :country];
                if(!cList.isEmpty()){
                    conAccCountryCode  = cList[0].ISO_Country_Code__c;
                    
                }
                //system.debug('conAccCountryCode  ' + conAccCountryCode  );
                
                countryCodes.add(conAccCountryCode);
                countryCodes.add(citizenshipConCode);
                //system.debug('countryCodes' +countryCodes);
                countryList = [select ISO_Country_Code__c,isSanctioned__c,isEmbargoed__c from country__c where ISO_Country_Code__c in :countryCodes];
                //system.debug('countryList ' +countryList );
                if(!countryList.isEmpty()){
                    for(country__c cont : countryList){
                        contMap.put(cont.ISO_Country_Code__c, cont);
                    }
                }
                if(!contMap.isEmpty()){
                    if(!string.isBlank(conAddCountryCode)){
                        isSancConAdd = contMap.get(conAddCountryCode).isSanctioned__c;
                        isEmbarConAdd = contMap.get(conAddCountryCode).isEmbargoed__c;
                    }    
                    if(!string.isBlank(citizenshipConCode)){
                        isSancCitizn = contMap.get(citizenshipConCode).isSanctioned__c;
                        isEmbarCitizn = contMap.get(citizenshipConCode).isEmbargoed__c;
                    }
                    if(!string.isBlank(conAccCountryCode )){
                        isSancAcc = contMap.get(conAccCountryCode ).isSanctioned__c;
                        isEmbarAcc = contMap.get(conAccCountryCode ).isEmbargoed__c;
                    }
                    
                }
                
                //updating the contact
                
                conRec.Id = conId;
                if(con != null){      
                    if(!string.isBlank(con.Contact_Birth_Country__c))
                    {conrec.Contact_Birth_Country__c = con.Contact_Birth_Country__c;
                    }else{
                        con.Contact_Birth_Country__c = '';
                    }
                    if(!string.isBlank(con.Birth_City__c))
                    {conrec.Birth_City__c =con.Birth_City__c;
                    }else{
                        con.Birth_City__c = '';
                    }
                    if(con.Is_US_Citizen__c != null)
                    {conrec.Is_US_Citizen__c =con.Is_US_Citizen__c;}
                    if(con.Permanent_USA_Resident__c != null)
                    {conrec.Permanent_USA_Resident__c =con.Permanent_USA_Resident__c;}
                    if(!string.isBlank(con.Citizenship_Country__c))
                    {conrec.Citizenship_Country__c = con.Citizenship_Country__c;
                    }else{
                        con.Citizenship_Country__c = '';
                    }
                    if(con.Permanent_Resident_Expiration_Date__c != null )
                    {conrec.Permanent_Resident_Expiration_Date__c = con.Permanent_Resident_Expiration_Date__c;
                    }
                }  
                if(conRec != null){
                    update conRec;
                }
                Boolean isSantionedCitzCount = false;
                Boolean isEmbergoedCitzCount = false;
                Boolean isSantionedCitzCount2 = false;
                Boolean isEmbergoedCitzCount2 = false;
                list<country__c> countryList1 = [select ISO_Country_Code__c,isSanctioned__c,isEmbargoed__c from country__c where ISO_Country_Code__c = :conRec.Contact_Birth_Country__c];
                if(!countryList1.isEmpty()){
                 isSantionedCitzCount =  countryList1[0].isSanctioned__c;
                 isEmbergoedCitzCount  =  countryList1[0].isEmbargoed__c;
                system.debug('isSantionedCitzCount ' +isSantionedCitzCount+''+isEmbergoedCitzCount);
                }
                
                list<country__c> countryList2 = [select ISO_Country_Code__c,isSanctioned__c,isEmbargoed__c from country__c where ISO_Country_Code__c = :conRec.Citizenship_Country__c];
                if(!countryList2.isEmpty()){
                 isSantionedCitzCount2 =  countryList2[0].isSanctioned__c;
                 isEmbergoedCitzCount2  =  countryList2[0].isEmbargoed__c;
                system.debug('isSantionedCitzCount ' +isSantionedCitzCount2+''+isEmbergoedCitzCount2);
                }
                
                //account address update
                
                if(accountId!=null){
                    
                    //2.1 Create Account Addresss name
                    
                    String accountAddressName=conList[0].Address_Line_1__c+' '+conList[0].City_Name__c+' '+(conList[0].Country_Code__c=='US'?conList[0].State_Code__c:'')+' '+(conList[0].Country_Code__c=='US'?'USA':conList[0].Country_Name__c);
                    System.debug(accountAddressName);
                    //2.2 Fetch Accpunt Address record
                    List<Account_Address__c> accoutAddressList =REG_PortalContact_Service.getAccountAddreessByAddressName(accountAddressName,accountId);
                    Account_Address__c accountAddressRecord =new Account_Address__c(Account_Name__c=accountId);
                    System.debug(accoutAddressList);
                    System.debug(accountAddressRecord);
                    if(accoutAddressList.isEmpty()){
                        system.debug('accountAddressRecord1' + accountAddressRecord);
                        accountAddressRecord= REG_PortalContact_Service.mapAccoutAddressFieldsWithContact(accountAddressRecord,conList[0]);  
                        system.debug('accountAddressRecord1' + accountAddressRecord);
                        insert accountAddressRecord;
                    }
                    
                    
                }   
                //get details for account_crossref__c object
                /*List<Account_Cross_Ref__c> accRefList= [SELECT Account_Cross_Reference__c,Account_Name__c,Account_Status__c,Account_Type__c,External_Account_Address_ID__c,
                                                        External_Account_ID__c,External_Account_Name__c,External_Address_Line_1__c,External_Address_Line_2__c,External_Address_Line_3__c,
                                                        External_City_Name__c,External_Country_Code__c,External_Country_Name__c,External_Main_Fax__c,External_Main_Phone__c,
                                                        External_Postal_Code__c,External_State_Code__c,Site_Code__c,Site_Name__c FROM Account_Cross_Ref__c WHERE Site_Name__c = 'BMS' and 
                                                        Account_Name__c =: accountId and External_City_Name__c =: conList[0].Contact_Addresses__r[0].Reporting_City_Name__c and 
                                                        External_Postal_Code__c =: conList[0].Contact_Addresses__r[0].Reporting_Address_Postal_Code__c and external_country_code__c =: conList[0].Contact_Addresses__r[0].Report_Country_Codes__c
                                                        and external_state_code__c =: conList[0].Contact_Addresses__r[0].Reporting_Address_State_Code__c];  */                                               
                //IF ( !generic && Contact Country AND Account Cuntry AND I/P Citizenship Country (Both isEmbargoed__c AND isSanctioned__c Flags)  != true  )
                system.debug(logginglevel.info,'isGeneric' +isGeneric );
                system.debug(logginglevel.info,'isSancConAdd ' +isSancConAdd );
                system.debug(logginglevel.info,'isEmbarConAdd ' +isEmbarConAdd );
                system.debug(logginglevel.info,'isSancAcc ' +isSancAcc );
                system.debug(logginglevel.info,'isEmbarAcc ' +isEmbarAcc );
                system.debug(logginglevel.info,'isSancCitizn ' +isSancCitizn );
                system.debug(logginglevel.info,'isEmbarCitizn' +isEmbarCitizn);
                system.debug(logginglevel.info,'isInternal' +isInternal);
                //system.debug(logginglevel.info,'accRefList' +accRefList);
                
                if((!isGeneric && isSancConAdd != true && isEmbarConAdd != true && isSancAcc != true &&
                    isEmbarAcc != true && isSancCitizn != true && isEmbarCitizn != true && isSantionedCitzCount != true && isEmbergoedCitzCount != true && isSantionedCitzCount2 != true && isEmbergoedCitzCount2 != true) || isInternal){
                        //system.debug('line 403 tool access service class');
                        
                        requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_id__c, 'Approved');
                        requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_name__c, 'Approved'); 
                        
                        //system.debug('requestStatCasMap'+requestStatCasMap);
                        if(con != null){     
                            caseAdditionalInfo = 'Birth City : '+con.Birth_City__c+'\n'+'Birth Country : '+con.Contact_Birth_Country__c+'\n'+'Is US Citizen : '+con.Is_US_Citizen__c+'\n'+'Citizenship Country : '+con.Citizenship_Country__c+'\n'+'Is Permanent USA Resident : '+con.Permanent_USA_Resident__c+'\n'+'Permanent Resident Expiration Date : '+con.Permanent_Resident_Expiration_Date__c;    
                        }else{
                            caseAdditionalInfo = 'Birth City : '+''+'\n'+'Birth Country : '+''+'\n'+'Is US Citizen : '+''+'\n'+'Citizenship Country : '+''+'\n'+'Is Permanent USA Resident : '+''+'\n'+'Permanent Resident Expiration Date : '+'';    
                        }
                        //system.debug('****caseAdditionalInfo '+caseAdditionalInfo );
                        contactToolAccess = new contact_tool_access__c();
                        map<string,string> caseComments = new map<string,string>();
                        REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                        //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,caseAdditionalInfo ,requestStatCasMap );                
                        REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,caseAdditionalInfo ,requestStatCasMap);
                        // enqueue the job for processing
                        ID jobID = System.enqueueJob(updateJob);
                    
                    }else
                        if(isEmbarConAdd == true || isEmbarAcc == true || isEmbarCitizn == true || isEmbergoedCitzCount == true || isEmbergoedCitzCount2 == true){
                            //( Contact Country OR Account Cuntry OR I/P Citizenship Country (isEmbargoed__c) Flag == true)
                            
                            requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_id__c, 'Denied');
                            requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_name__c, 'Denied'); 
                            if(con != null){   
                                caseAdditionalInfo = 'Birth City : '+con.Birth_City__c+
                                    '\n'+'Birth Country : '+con.Contact_Birth_Country__c+
                                    '\n'+'Is US Citizen : '+con.Is_US_Citizen__c+
                                    '\n'+'Citizenship Country : '+con.Citizenship_Country__c+
                                    '\n'+'Is Permanent USA Resident : '+con.Permanent_USA_Resident__c+
                                    '\n'+'Permanent Resident Expiration Date : '+con.Permanent_Resident_Expiration_Date__c;    
                            }else{
                                caseAdditionalInfo = 'Birth City : '+''+
                                    '\n'+'Birth Country : '+''+
                                    '\n'+'Is US Citizen : '+''+
                                    '\n'+'Citizenship Country : '+''+
                                    '\n'+'Is Permanent USA Resident : '+''+
                                    '\n'+'Permanent Resident Expiration Date : '+'';                         
                            }
                            //system.debug('****caseAdditionalInfo '+caseAdditionalInfo );
                            contactToolAccess = new contact_tool_access__c();
                            map<string,string> caseComments = new map<string,string>();
                            REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                            //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,caseAdditionalInfo ,requestStatCasMap );                
                            REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,caseAdditionalInfo ,requestStatCasMap);
                            // enqueue the job for processing
                            ID jobID = System.enqueueJob(updateJob);
                            
                        }else
                            if((isGeneric || isSancConAdd == true || isSancAcc == true || isSancCitizn == true)){
                                //(generic OR Contact Country OR Account Cuntry OR I/P Citizenship Country (isSanctioned__c) Flag == true)
                                requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_id__c, 'Pending');
                                requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_name__c, 'Pending'); 
                                caseAdditionalInfo = 'This is to inform you that a new user has requested access to Technical Publications and the request is Pending. User details are as follows:'+
                                    '\n'+'Honeywell Id : '+honId+
                                    '\n'+'Name : '+(!string.isBlank(conList[0].Name)?conList[0].Name:'')+
                                    '\n'+'Email : '+(!string.isBlank(conList[0].Email)?conList[0].Email:'')+
                                    '\n'+'Phone No. : '+(!string.isBlank(conList[0].Phone_1__c)?conList[0].Phone_1__c:'')+
                                    '\n'+'Mobile No. : '+(!string.isBlank(conList[0].MobilePhone)?conList[0].MobilePhone:'')+
                                    '\n'+'Company : '+(!string.isBlank(conList[0].Account.Name)?conList[0].Account.Name:'')+
                                    '\n'+'Address1 : '+(!string.isBlank(conList[0].Address_Line_1__c)?conList[0].Address_Line_1__c:'')+
                                    '\n'+'Address2 : '+(!string.isBlank(conList[0].Address_Line_2__c)?conList[0].Address_Line_2__c:'')+
                                    '\n'+'City : '+(!string.isBlank(conList[0].city_name__c)?conList[0].city_name__c:'')+
                                    '\n'+'State : '+(!string.isBlank(conList[0].state_name__c)?conList[0].state_name__c:'')+
                                    '\n'+'Zip : '+(!string.isBlank(conList[0].postal_code__c)?conList[0].postal_code__c:'')+
                                    '\n'+'Country : '+(!string.isBlank(conList[0].Country_Name__c)?conList[0].Country_Name__c:'')+
                                    '\n'+'Job Title : '+(!string.isBlank(conList[0].job_title__c)?conList[0].job_title__c:'')+
                                    '\n'+'Birth City : '+(con != null && !string.isBlank(con.Birth_City__c)?con.Birth_City__c:'')+
                                    '\n'+'Birth Country : '+(con != null && !string.isBlank(con.Contact_Birth_Country__c)?con.Contact_Birth_Country__c:'')+
                                    '\n'+'Is US Citizen : '+(con != null ?con.Is_US_Citizen__c:false) +
                                    '\n'+'Citizenship Country : '+(con != null && !string.isBlank(con.Citizenship_Country__c)?con.Citizenship_Country__c:'')+
                                    '\n'+'Is Permanent USA Resident : '+ (con != null ?con.Permanent_USA_Resident__c:false)+
                                    '\n'+'Permanent Resident Expiration Date : '+ (con != null ?con.Permanent_Resident_Expiration_Date__c:null);
                                
                                
                                contactToolAccess = new contact_tool_access__c();
                                map<string,string> caseComments = new map<string,string>();
                                REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                                //REG_Case_Service.caseForContactTool(honId,toolIds, conId, caseComments,caseAdditionalInfo ,requestStatCasMap );                
                                REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,caseComments,caseAdditionalInfo ,requestStatCasMap);
                                // enqueue the job for processing
                                ID jobID = System.enqueueJob(updateJob);
                                
                            }
                // response creation
                List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_id__c, requestStatConMap.get(REG_Master_Tool_Name__c.getValues('REG Technical Publications').tool_id__c)));
                REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                result.resource= finalData;
                
                
            }  
            if((REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c.contains(toolId))
               || (REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c.contains(toolId))
               || (REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c.contains(toolId))){
                   system.debug('ASDS******');
                   //System.debug(Logginglevel.ERROR , 'ASDS******');    
                   boolean isGeneric = false;
                   string country = '';
                   string conAddCountryCode  = '';
                   string conAccCountryCode   = '';
                   boolean isEmbarConAdd = false;
                   boolean isSancConAdd = false ;
                   boolean isSancAcc = false;
                   boolean isEmbarAcc = false;            
                   List<string> countryCodes = new List<string>();
                   List<contact> conList = new List<contact>();
                   List<country__c> countryList = new List<country__c>();
                   Map<string, country__c> contMap = new Map<string, country__c>();            
                   conList = [select Name, Email, phone,phone_1__c, mobilePhone, account.name,Address_Line_1__c, Address_Line_2__c,Address_Line_3__c,City_Name__c, 
                              state_code__c,State_Name__c, Country_Code__c,Postal_Code__c, Contact_Is_Employee__c,Country_Name__c,Job_Title__c, account.country__c,Account.ATR_Portal_Access_Template__c,
                              (select Report_Country_Codes__c,Reporting_Address_Postal_Code__c,Reporting_Address_State_Code__c, Reporting_City_Name__c 
                               from Contact_Addresses__r where Contact__c =:conId and Is_Primary_Address__c = true) from contact where Id = : conId];
                   system.debug('conList' +conList);
                   if(!conList.isEmpty()){
                       country = conList[0].account.country__c;
                     if(conList[0].Contact_Addresses__r.size()>0){
                       conAddCountryCode = conList[0].Contact_Addresses__r[0].Report_Country_Codes__c;
                     }else{
                        result.handleError(422, 'Bad data', 'Contact Address is empty for honeywell Id: ' +honId + ' and access request cannot be completed for toolId: ' +toolId);
                    return result;
                     }
                       //contact address country code
                       countryCodes.add(conAddCountryCode);
                       
                       // generic check
                       if( (!string.isBlank(conList[0].Account.ATR_Portal_Access_Template__c)) && (REG_Is_Generic__c.getValues('Is Generic').Id__c.contains(conList[0].Account.ATR_Portal_Access_Template__c))){ 
                           isGeneric =true;
                       }            
                   }
                   List<country__c> cList = [select ISO_Country_Code__c,name,id from country__c where Id = :country];
                   system.debug('cList' +cList);
                   //contact account country code
                   if(!cList.isEmpty()){
                       conAccCountryCode  = cList[0].ISO_Country_Code__c;
                       
                   }
                   system.debug('conAccCountryCode  ' + conAccCountryCode  );
                   countryCodes.add(conAccCountryCode);            
                   system.debug('isGeneric'+isGeneric);
                   system.debug('conAddCountryCode ' + conAddCountryCode );
                   countryList = [select ISO_Country_Code__c,isSanctioned__c,isEmbargoed__c from country__c where ISO_Country_Code__c in :countryCodes];
                   system.debug('countryList ' +countryList );
                   if(!countryList.isEmpty()){
                       for(country__c cont : countryList){
                           contMap.put(cont.ISO_Country_Code__c, cont);
                       }
                   }
                   if(!contMap.isEmpty()){
                       if(!string.isBlank(conAddCountryCode)){
                           isSancConAdd = contMap.get(conAddCountryCode).isSanctioned__c;
                           isEmbarConAdd = contMap.get(conAddCountryCode).isEmbargoed__c;
                       }    
                       if(!string.isBlank(conAccCountryCode )){
                           isSancAcc = contMap.get(conAccCountryCode ).isSanctioned__c;
                           isEmbarAcc = contMap.get(conAccCountryCode ).isEmbargoed__c;
                       }
                   } 
                   //Account Address check
                   
                   if(accountId!=null){
                       
                       //2.1 Create Account Addresss name
                       
                       String accountAddressName=conList[0].Address_Line_1__c+' '+conList[0].City_Name__c+' '+(conList[0].Country_Code__c=='US'?conList[0].State_Code__c:'')+' '+(conList[0].Country_Code__c=='US'?'USA':conList[0].Country_Name__c);
                       System.debug(accountAddressName);
                       //2.2 Fetch Accpunt Address record
                       List<Account_Address__c> accoutAddressList =REG_PortalContact_Service.getAccountAddreessByAddressName(accountAddressName,accountId);
                       Account_Address__c accountAddressRecord =new Account_Address__c(Account_Name__c=accountId);
                       System.debug(accoutAddressList);
                       System.debug(accountAddressRecord);
                       if(accoutAddressList.isEmpty()){
                           system.debug('accountAddressRecord1' + accountAddressRecord);
                           accountAddressRecord= REG_PortalContact_Service.mapAccoutAddressFieldsWithContact(accountAddressRecord,conList[0]);  
                           system.debug('accountAddressRecord1' + accountAddressRecord);
                           insert accountAddressRecord;
                       }
                       
                       
                   } 
                   //get details for account_crossref__c object
                   List<Account_Cross_Ref__c> accRefList= [SELECT Account_Cross_Reference__c,Account_Name__c,Account_Status__c,Account_Type__c,External_Account_Address_ID__c,
                                                           External_Account_ID__c,External_Account_Name__c,External_Address_Line_1__c,External_Address_Line_2__c,External_Address_Line_3__c,
                                                           External_City_Name__c,External_Country_Code__c,External_Country_Name__c,External_Main_Fax__c,External_Main_Phone__c,
                                                           External_Postal_Code__c,External_State_Code__c,Site_Code__c,Site_Name__c FROM Account_Cross_Ref__c WHERE Site_Name__c = 'BMS' and 
                                                           Account_Name__c =: accountId and External_City_Name__c =: conList[0].Contact_Addresses__r[0].Reporting_City_Name__c and 
                                                           External_Postal_Code__c =: conList[0].Contact_Addresses__r[0].Reporting_Address_Postal_Code__c and external_country_code__c =: conList[0].Contact_Addresses__r[0].Report_Country_Codes__c
                                                           and external_state_code__c =: conList[0].Contact_Addresses__r[0].Reporting_Address_State_Code__c];                  
                   
                   system.debug('accRefList'+ accRefList);
                   If(((!string.isBlank(accountId) || accRefList[0] != null || conList[0].Contact_Is_Employee__c == True)) 
                      && !((isSancConAdd == True) || (isEmbarConAdd == True) || (isEmbarAcc == True) || (isSancAcc == True)) && !isGeneric){
                          // if tool is ASDS
                          system.debug('above asds');
                          if(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c.contains(toolId)){
                              system.debug('testing' +(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c.contains(toolId)));
                              contactToolAccess = new contact_tool_access__c();
                              toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                              requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Approved');
                              requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Approved'); 
                              casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,'Denied party screening and ASDS role set up are already done');
                              REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                              //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,null,requestStatCasMap );                
                              REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,null,requestStatCasMap);
                              // enqueue the job for processing
                              ID jobID = System.enqueueJob(updateJob);
                              
                          }//if tool is ASDS
                          
                          //if tool is NavDB
                          if(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c.contains(toolId)){
                              system.debug('****NavDB');
                              string toolStat = chkToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c) ;       
                              if(toolStat == 'Not Requested' || toolStatus.status == 'Denied'){
                                  
                                  contactToolAccess = new contact_tool_access__c();
                                  toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                  requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Approved');
                                  requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Approved'); 
                                  casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,'Denied party screening and ASDS role set up are already done');
                              }else{requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, toolStat );}
                              toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c);
                              requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c, 'Pending');
                              requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_name__c, 'Pending'); 
                              casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_name__c,'Denied Party screening is done and NavDB Role has not been provided to the user in ASDS');
                              if(conAir != null){
                                  caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+(!string.isBlank(conAir.Aircraft_Make__c)?conAir.Aircraft_Make__c:'')+'\n'+'Model:'+(!string.isBlank(conAir.Aircraft_Model__c)?conAir.Aircraft_Model__c:'')+'\n'+'Serial Number:'+(!string.isBlank(conAir.Aircraft_Serial_Number__c)?conAir.Aircraft_Serial_Number__c:'')+
                                      '\n'+'Tail Number:'+(!string.isBlank(conAir.Aircraft_Tail_Number__c)?conAir.Aircraft_Tail_Number__c:'') + '\n'+'Type Of Database :'+(!string.isBlank(typeOfDB)?typeOfDB:'');
                              }else{
                                  caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+''+'\n'+'Model:'+''+'\n'+'Serial Number:'+''+'\n'+'Tail Number:'+''+'\n'+'Type Of Database :'+'';
                              }                            
                              
                              REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                              //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,caseAdditionalInfo,requestStatCasMap );                   
                              REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,caseAdditionalInfo,requestStatCasMap);
                              // enqueue the job for processing
                              ID jobID = System.enqueueJob(updateJob);
                          
                          }//if tool is NavDB
                          //if tool is (EGPWS)
                          if(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c.contains(toolId)){
                              string toolStat = chkToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c) ;       
                              if(toolStat == 'Not Requested' || toolStatus.status == 'Denied'){
                                  
                                  contactToolAccess = new contact_tool_access__c();
                                  toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                  requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Approved');
                                  requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Approved'); 
                                  casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,'Denied party screening and ASDS role set up are already done');
                              }else{requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, toolStat );}
                              toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c);
                              requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c, 'Approved');
                              requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_name__c, 'Approved'); 
                              casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_name__c,'Denied Party screening is done and EGPWS Role has been provided to the user in ASDS');
                              REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                              //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,null,requestStatCasMap );                   
                              REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,null,requestStatCasMap);
                              // enqueue the job for processing
                              ID jobID = System.enqueueJob(updateJob);
                          
                          }  //end of epgws
                      }else
                          if((isEmbarConAdd == True) || (isEmbarAcc == True)){
                              // if tool is ASDS
                              
                              if((REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c.contains(toolId))){
                                  contactToolAccess = new contact_tool_access__c();
                                  toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                  requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Denied');
                                  requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Denied'); 
                                  string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Customer belongs to Embargo nation. ADS role set up not done';
                                  casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,comm);
                                  REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                                  //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,null,requestStatCasMap );                
                                  REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,null,requestStatCasMap);
                                  // enqueue the job for processing
                                  ID jobID = System.enqueueJob(updateJob);                                   
                              }//if tool is ASDS
                              
                              //if tool is navDB
                              if(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c.contains(toolId)){
                                  string toolStat = chkToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c) ;       
                                  if(toolStat == 'Not Requested' || toolStatus.status == 'Denied'){
                                      
                                      contactToolAccess = new contact_tool_access__c();
                                      toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                      requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Denied');
                                      requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Denied'); 
                                      string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Customer belongs to Embargo nation. ADS role set up not done';
                                      casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,comm);
                                  }else{requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, toolStat );}
                                  toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c);
                                  requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c, 'Denied');
                                  requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_name__c, 'Denied'); 
                                  string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Customer belongs to Embargo nation. ADS role set up not done';
                                  casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_name__c,comm);
                                  if(conAir != null){
                                      caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+(!string.isBlank(conAir.Aircraft_Make__c)?conAir.Aircraft_Make__c:'')+'\n'+'Model:'+(!string.isBlank(conAir.Aircraft_Model__c)?conAir.Aircraft_Model__c:'')+'\n'+'Serial Number:'+(!string.isBlank(conAir.Aircraft_Serial_Number__c)?conAir.Aircraft_Serial_Number__c:'')+
                                          '\n'+'Tail Number:'+(!string.isBlank(conAir.Aircraft_Tail_Number__c)?conAir.Aircraft_Tail_Number__c:'') + '\n'+'Type Of Database :'+(!string.isBlank(typeOfDB)?typeOfDB:'');
                                  }else{
                                      caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+''+'\n'+'Model:'+''+'\n'+'Serial Number:'+''+'\n'+'Tail Number:'+''+'\n'+'Type Of Database :'+'';
                                  }                          
                                  REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                                  //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,caseAdditionalInfo,requestStatCasMap );                
                                 REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,caseAdditionalInfo,requestStatCasMap);
                                 // enqueue the job for processing
                                 ID jobID = System.enqueueJob(updateJob);                               
                              }//if tool in NavDB
                              //if tool is (EGPWS)
                              if(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c.contains(toolId)){
                                  string toolStat = chkToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c) ;       
                                  if(toolStat == 'Not Requested' || toolStatus.status == 'Denied'){
                                      
                                      contactToolAccess = new contact_tool_access__c();
                                      toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                      requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Denied');
                                      requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Denied'); 
                                      string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Customer belongs to Embargo nation. ADS role set up not done';
                                      casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,comm);
                                  }else{requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, toolStat );}
                                  toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c);
                                  requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c, 'Denied');
                                  requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_name__c, 'Denied'); 
                                  string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Customer belongs to Embargo nation. ADS role set up not done';
                                  casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_name__c,comm);
                                  
                                  REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                                  //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,null,requestStatCasMap );                
                                  REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,null,requestStatCasMap);
                                  // enqueue the job for processing
                                  ID jobID = System.enqueueJob(updateJob);                               
                              
                              }
                              
                          }else
                              if ((isGeneric) || (isSancConAdd == True)||(isSancAcc == True)){
                                  // if tool is ASDS
                                  
                                  if((REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c.contains(toolId))){
                                      contactToolAccess = new contact_tool_access__c();
                                      toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                      requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Pending');
                                      requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Pending'); 
                                      string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Denied Party Screening is not done for this user and ASDS role has not been provided in ASDS.';
                                      casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,comm);
                                      REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                                      //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,null,requestStatCasMap );                
                                      REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,null,requestStatCasMap);
                                      // enqueue the job for processing
                                      ID jobID = System.enqueueJob(updateJob);                               
                                      
                                  }//if tool is Asds
                                  //if tool is NavDB
                                  if(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c.contains(toolId)){
                                      string toolStat = chkToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c) ;       
                                      if(toolStat == 'Not Requested'  || toolStatus.status == 'Denied'){
                                          
                                          contactToolAccess = new contact_tool_access__c();
                                          toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                          requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Pending');
                                          requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Pending'); 
                                          string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Denied Party Screening is not done for this user and ASDS role has not been provided in ASDS.';
                                          casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,comm);
                                      }else{requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, toolStat );}
                                      toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c);
                                      requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c, 'Pending');
                                      requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_name__c, 'Pending'); 
                                      casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_name__c,'Denied Party screening is done and NavDB Role has not been provided to the user in ASDS');
                                      if(conAir != null){
                                          caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+(!string.isBlank(conAir.Aircraft_Make__c)?conAir.Aircraft_Make__c:'')+'\n'+'Model:'+(!string.isBlank(conAir.Aircraft_Model__c)?conAir.Aircraft_Model__c:'')+'\n'+'Serial Number:'+(!string.isBlank(conAir.Aircraft_Serial_Number__c)?conAir.Aircraft_Serial_Number__c:'')+
                                              '\n'+'Tail Number:'+(!string.isBlank(conAir.Aircraft_Tail_Number__c)?conAir.Aircraft_Tail_Number__c:'') + '\n'+'Type Of Database :'+(!string.isBlank(typeOfDB)?typeOfDB:'');
                                      }else{
                                          caseAdditionalInfo = 'Aircraft Details:'+'\n'+'Make:'+''+'\n'+'Model:'+''+'\n'+'Serial Number:'+''+'\n'+'Tail Number:'+''+'\n'+'Type Of Database :'+'';
                                      }                          
                                      REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                                      //REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,caseAdditionalInfo,requestStatCasMap );                   
                                      REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,caseAdditionalInfo,requestStatCasMap);
                                      // enqueue the job for processing
                                      ID jobID = System.enqueueJob(updateJob);                               
 
                                  }//end of navdb
                                  //if tool is (EGPWS)
                                  if(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c.contains(toolId)){
                                      string toolStat = chkToolStatus(honId, REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c) ;       
                                      if(toolStat == 'Not Requested' || toolStatus.status == 'Denied'){
                                          
                                          contactToolAccess = new contact_tool_access__c();
                                          toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c);
                                          requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, 'Pending');
                                          requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c, 'Pending'); 
                                          string comm = (isSancConAdd == True)?'Export Compliance – Additional compliance checks needed':'Denied Party Screening is not done for this user and ASDS role has not been provided in ASDS.';
                                          casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_name__c,comm);
                                      }else{requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, toolStat );}
                                      toolIds.add(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c);
                                      requestStatConMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c, 'Pending');
                                      requestStatCasMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_name__c, 'Pending'); 
                                      casCommMap.put(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_name__c,'"Denied Party screening is not done and EGPWS Role has not been provided to the user in ASDS');
                                      system.debug('****toolIds'+toolIds);
                                      system.debug('****requestStatCasMap'+requestStatCasMap);
                                      system.debug('****requestStatConMap'+requestStatConMap);
                                      system.debug('****casCommMap'+casCommMap);
                                      REG_PortalContact_Service.createTool(honId,toolIds, conId,contactToolAccess,requestStatConMap) ;
                                     // REG_Case_Service.caseForContactTool(honId,toolIds, conId, casCommMap,null,requestStatCasMap );                   
                                      REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,conId,casCommMap,null,requestStatCasMap);
                                      // enqueue the job for processing
                                      ID jobID = System.enqueueJob(updateJob);                               
                                      
                                  }
                                  
                              }//enf of all ifs
                   // response creation
                   List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                   if(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c.contains(toolId)){
                       resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, requestStatConMap.get(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c)));
                   }
                   
                   if(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c.contains(toolId)){
                       resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c, requestStatConMap.get(REG_Master_Tool_Name__c.getValues('REG Aerospace (NavDB)').tool_id__c)));
                       resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, requestStatConMap.get(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c)));
                   }
                   if(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c.contains(toolId)){
                       resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c, requestStatConMap.get(REG_Master_Tool_Name__c.getValues('REG Aerospace (ASDS)').tool_id__c)));
                       resDataList.add(new REG_PortalContact_Service.toolsWrap(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c, requestStatConMap.get(REG_Master_Tool_Name__c.getValues('REG Aerospace (EGPWS)').tool_id__c)));
                   }
                   REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(honId, conId, resDataList,isInternal);
                   result.resource = finalData;
                   
                   
               }
        }catch(exception e){
            Database.rollback(sp);
            result.handleException(500, e.getMessage(), e);
        }    
        system.debug('****result'+result);
        
        return result;   
    }
    
    public static REG_Result updateToolstatuss(string honId,string toolId,Id contactId,string toolStatus){
        REG_Result Result = new REG_Result();
        REG_Result conToolData = new REG_Result();
        REG_Result chckToolStatus = new REG_Result();
        object toolObj;
        object errObj;
        List<string> toolIds = new List<string>();
        Map<string,string> requestStatConMap = new Map<string,string>();          
        Map<string,string> requestStatCasMap = new Map<string,string>();
        Map<string,string> caseComments = new Map<string,string>();  
        Id conId;
        Savepoint sp= Database.setSavepoint();
        try{ 
            REG_ToolWrapper toolStatus1 = new REG_ToolWrapper(null, null, null, null, null, null,null, null, null,null, null, null, null);
            chckToolStatus = REG_PortalContact_Service.getSpecificToolStatus(honId, toolId);
            if(chckToolStatus.statusCode != 200){
                errObj = chckToolStatus.Error;
                
                system.debug(logginglevel.info,'errObj' +errObj);
                Map<string,object> RegErrMap = new Map<string,object>();
                RegErrMap = (Map<string,object>) errObj;
                Object RegErrObj = RegErrMap.get('error');
                REG_Error RegErr = (REG_Error) RegErrObj;
                system.debug(logginglevel.info,'RegErr' +RegErrMap);
                system.debug(logginglevel.info,'RegErr1' +RegErrMap.get('error'));
                result.handleError(RegErr.errorCode, RegErr.errorMessage, RegErr.errorDescription);
                return result;                
            }
            system.debug(logginglevel.info,'chckToolStatus' +chckToolStatus);
            toolObj= chckToolStatus.data;
            toolStatus1= (REG_ToolWrapper) toolObj;       
            if(toolStatus1 == null){
                result.handleError(400, 'Invalid Tool Id OR Tool is not active', 'Please provide valid Tool Id');
                return result;                
            }
            if(toolStatus1.status == 'Not Permitted'){
                result.handleError(400, 'Account does not have access', 'Please provide Access to tool');
                return result;  
            }
            
            requestStatConMap.put(toolId, toolStatus);              
            //get contact id from honid
            List<Portal_Honeywell_ID__c > contactPortalList = new List<Portal_Honeywell_ID__c >();
            contactPortalList = [SELECT Contact__c,Contact__r.AccountId  FROM Portal_Honeywell_ID__c WHERE Name =: honId AND Portal_Status__c != 'Inactive' AND Portal_Status__c != 'Deleted' AND contact__c=: contactId];
            If(!contactPortalList.isEmpty() ){            
                 conId =contactPortalList[0].Contact__c ;
            }            
            if(string.isBlank(conId)){
                result.handleError(404, 'Contact details not found for the given honeywell id', 'Please provide a valid honeywell id.');
                return result;
            }
            
            if(conId == contactId){
                //check data for Portal Honeywell Id Object
                Portal_Tools_Master__c pRecord = [select name from Portal_Tools_Master__c where id=: toolId limit 1];
                if(pRecord.name==''){
                    throw new stringException('No data found for given Tool Id');
                }       
                string toolNm = pRecord.name + ' Created';
                requestStatCasMap.put(pRecord.name, toolStatus);  
                toolIds.add(toolId);            
                REG_PortalContact_Service.createTool(honId,toolIds,contactId,null,requestStatConMap) ;   
                //REG_Case_Service.caseForContactTool(honId,toolIds,contactId,caseComments,null,requestStatCasMap);
                REG_CreateInsertCaseForTool updateJob = new REG_CreateInsertCaseForTool(honId,toolIds,contactId,caseComments,null,requestStatCasMap);
                // enqueue the job for processing
                ID jobID = System.enqueueJob(updateJob);
                // response creation
                List <REG_PortalContact_Service.toolsWrap> resDataList = new List <REG_PortalContact_Service.toolsWrap>();
                resDataList.add(new REG_PortalContact_Service.toolsWrap(toolId, toolStatus));
                REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(toolId,toolNm,toolStatus);
                result.data= finalData;
            }else{
                result.handleError(404, 'Provided Honeywell Id and Contact Id are not associated to each other', 'Please provide a valid honeywell id.');
                return result;
            }
            
        }
        catch(exception e){
            Database.rollback(sp);
            result.handleException(500, e.getMessage(), e);
        }           
        return result;  
    }
    
}