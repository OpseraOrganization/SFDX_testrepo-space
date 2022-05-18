/******************************************************************************************************
Name : SalesRoleHelper
Created Date: 7 JULY 2018
Created by: Accenture
Description : To create Sales Role History record on Sales Role insertion
*********************************************************************************************************/
public class SalesRoleTriggerHelper
{
  /********************
*Method Name: createSalesHistoryRecord
*Parameter: salesRoleNewList
*Description: For creating Sales Role History record'
*******************/
  
  public static void createSalesHisoryRecord(Map<Id,Sales_Role__c> salesRoleOldMap,Map<Id,Sales_Role__c> salesRoleNewMap)
  {
	try
	{
	  List <Sales_Role_History__c> salesRoleHistoryInsertion = new List <Sales_Role_History__c>();
	  Set<String> hierarchyLabel   = new Set<String>();
	  Map<String,String> hierarchyLabelToHierarchyId	= new Map<String,String>();
	  Map<Id,User> userIdToNewusername	 = new Map<Id,User>();
	  Set<Id> useridNew  = new Set<Id>();
	  
	  for(Sales_Role__c saleshistory :salesRoleNewMap.values())
	  {
  hierarchyLabel.add(saleshistory.Organisation__c);
  useridNew.add(saleshistory.User__c);
	  }
	  for(Territory2 territoryVar : [select Id,Name,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Name In: hierarchyLabel
	   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
	  {
  hierarchyLabelToHierarchyId.put(territoryVar.Name,territoryVar.Hierarchy_ID__c);
	  }
	  for(User u: [SELECT CreatedDate,FirstName,LastName,Nokia_ID__c FROM User where Id In :useridNew] )
	  {
  userIdToNewusername.put(u.id,u);
	  }
	  for(Sales_Role__c saleshistory :salesRoleNewMap.values())
	  {
  Sales_Role_History__c salesRoleHistory = new Sales_Role_History__c();
  salesRoleHistory.Approval_Type__c   = saleshistory.Approval_Type__c;
  salesRoleHistory.BG_Attribute__c   = saleshistory.BG__c;
  salesRoleHistory.Comments__c	= saleshistory.Business_Comments__c;
  salesRoleHistory.email__c  = saleshistory.User_Email__c;
  salesRoleHistory.External_ID__c   = saleshistory.External_ID__c;
  salesRoleHistory.New_User__c	= saleshistory.User__c;
  salesRoleHistory.Organisation__c  = saleshistory.Organisation__c;
  salesRoleHistory.Role_Code__c   = saleshistory.Role_Code__c;
  salesRoleHistory.New_Role_Name__c  = saleshistory.Role_Name__c;
  salesRoleHistory.Sales_Role__c  = saleshistory.Id;
  salesRoleHistory.Operation_Type__c   = 'Created';
  salesRoleHistory.Hierarchy_Id__c  = hierarchyLabelToHierarchyId.get(saleshistory.Organisation__c);
  salesRoleHistoryInsertion.add(salesRoleHistory);
	  }
	  System.debug('DML : '+Database.insert(salesRoleHistoryInsertion, false));
	}
	catch(Exception ex)
	{
	  ExceptionHandler.addException(ex, SalesRoleHelper.class.getName(), 'createSalesHisoryRecord');
	}
  }
  public static void modifySalesHisoryRecord(Map<Id,Sales_Role__c> salesRoleOldMap,Map<Id,Sales_Role__c> salesRoleNewMap)
  {
	try{
	  List<Sales_Role__c> validChangeList = new list<Sales_Role__c>();
	  for(Sales_Role__c sr : salesRoleNewMap.values())
	  {
  if(sr.Process_SRT_Audit__c == true && (salesRoleOldMap.get(sr.Id).Process_SRT_Audit__c == false || salesRoleOldMap.get(sr.Id).Process_SRT_Audit__c == true))
  {
	if(sr.user__c != salesRoleOldMap.get(sr.Id).user__c)
	{
	  if(sr.user__c != null)
		validChangeList.add(sr);
	}
  }
	  }
	  List <Sales_Role_History__c> salesRoleHistoryInsertion = new List <Sales_Role_History__c>();
	  Set<String> hierarchyLabel   = new Set<String>();
	  Map<String,String> hierarchyLabelToHierarchyId	= new Map<String,String>();
	  Map<Id,Boolean> mapOfIdToProcessSRTAuditNew	= new Map<Id,Boolean>();
	  //Map<Id,Boolean> mapOfIdToProcessSRTAuditOld	= new Map<Id,Boolean>(); Not Being Used
	  Set<Id> userId   = new Set<Id>();
	  Map<String,Sales_Role__c> autoNumberToUserId	= new Map<String,Sales_Role__c>();
	  
	  for(Sales_Role__c saleshistory :validChangeList)
	  {
  hierarchyLabel.add(saleshistory.Organisation__c);
  mapOfIdToProcessSRTAuditNew.put(saleshistory.Id,saleshistory.Process_SRT_Audit__c);
	  }
	  for(Sales_Role__c saleshistory :salesRoleOldMap.values())
	  {
  autoNumberToUserId.put(saleshistory.Name,saleshistory);
  userId.add(saleshistory.User__c);
	  }
	  for(Territory2 territoryVar : [select Id,Name,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Name In: hierarchyLabel
	   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
	  {
  hierarchyLabelToHierarchyId.put(territoryVar.Name,territoryVar.Hierarchy_ID__c);
	  }
	  for(Sales_Role__c saleshistory :validChangeList)
	  {
  Sales_Role_History__c salesRoleHistory = new Sales_Role_History__c();
  salesRoleHistory.Approval_Type__c   = saleshistory.Approval_Type__c;
  salesRoleHistory.BG_Attribute__c   = saleshistory.BG__c;
  salesRoleHistory.Comments__c	= saleshistory.Business_Comments__c;
  salesRoleHistory.email__c  = saleshistory.User_Email__c;
  salesRoleHistory.External_ID__c   = saleshistory.External_ID__c;
  salesRoleHistory.New_User__c	= saleshistory.User__c;
  salesRoleHistory.Organisation__c  = saleshistory.Organisation__c;
  salesRoleHistory.Role_Code__c   = saleshistory.Role_Code__c;
  salesRoleHistory.New_Role_Name__c  = saleshistory.Role_Name__c;
  salesRoleHistory.Sales_Role__c  = saleshistory.Id;
  salesRoleHistory.Hierarchy_Id__c  = hierarchyLabelToHierarchyId.get(saleshistory.Organisation__c);
  salesRoleHistory.Operation_Type__c   = 'Modified';
  salesRoleHistory.Old_User__c   = autoNumberToUserId.get(saleshistory.Name).User__c;
  salesRoleHistoryInsertion.add(salesRoleHistory);
	  }
	  if(!salesRoleHistoryInsertion.isEmpty())
	  {
  System.debug('DML : '+Database.insert(salesRoleHistoryInsertion, false));
	  }
	}
	catch(Exception ex)
	{
	  ExceptionHandler.addException(ex, SalesRoleHelper.class.getName(), 'modifySalesHisoryRecord');
	}
  }
  public static void deleteSalesHisoryRecord(List<Sales_Role__c> salesRoleOldList)
  {
	try
	{
	  List <Sales_Role_History__c> salesRoleHistoryInsertion = new List <Sales_Role_History__c>();
	  Set<String> hierarchyLabel   = new Set<String>();
	  Map<String,String> hierarchyLabelToHierarchyId	= new Map<String,String>();
	  Set<Id> userId   = new Set<Id>();
	  string valid_DeleteRole   = Label.NF_Salesrole_Delete_Validation;
	  string[] valid_DeleteRoles  = valid_DeleteRole.split(';');
	  for(Sales_Role__c saleshistory :salesRoleOldList)
	  {
  hierarchyLabel.add(saleshistory.Organisation__c);
	  }
	  for(Territory2 territoryVar : [select Id,Name,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Name In: hierarchyLabel
	   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
	  {
  hierarchyLabelToHierarchyId.put(territoryVar.Name,territoryVar.Hierarchy_ID__c);
	  }
	  for(Sales_Role__c saleshistory :salesRoleOldList)
	  {
  if(!valid_DeleteRoles.contains(saleshistory.Role_Code__c) || GlobalConstants.Sales_Role_Bypass == true)
  {
	Sales_Role_History__c salesRoleHistory = new Sales_Role_History__c();
	salesRoleHistory.Approval_Type__c  = saleshistory.Approval_Type__c;
	salesRoleHistory.BG_Attribute__c  = saleshistory.BG__c;
	salesRoleHistory.Comments__c   = saleshistory.Business_Comments__c;
	salesRoleHistory.email__c	= saleshistory.User_Email__c;
	salesRoleHistory.External_ID__c   = saleshistory.External_ID__c;
	salesRoleHistory.Organisation__c  = saleshistory.Organisation__c;
	salesRoleHistory.Role_Code__c   = saleshistory.Role_Code__c;
	salesRoleHistory.New_Role_Name__c  = saleshistory.Role_Name__c;
	salesRoleHistory.Sales_Role__c   = saleshistory.Id;
	salesRoleHistory.Hierarchy_Id__c  = hierarchyLabelToHierarchyId.get(saleshistory.Organisation__c);
	salesRoleHistory.Operation_Type__c  = 'Deleted';
	salesRoleHistory.Old_User__c   = saleshistory.User__c;
	salesRoleHistoryInsertion.add(salesRoleHistory);
  }
  else
  {
	saleshistory.addError('Deletion of CO CT Head role is not possible');
  }
	  }
	  System.debug('DML : '+Database.insert(salesRoleHistoryInsertion, false));
	}
	catch(Exception ex)
	{
	  ExceptionHandler.addException(ex, SalesRoleHelper.class.getName(), 'deleteSalesHisoryRecord');
	}
  }
  
  public static void onBeforeInsert_Update_salesroledata(List<Sales_Role__c> newsalesroleList,List<Sales_Role__c> oldsalesroleList)
  { 
	Map<String,Boolean> RoleASMap = new Map<string,Boolean>();
	Map<id,User> usernameidMap = new Map<id,User>();
	Set<Id> userIdset = new Set<Id>();
	//Map<string,NF_RoleCode__c> roleNamecodeMap = new Map<string,NF_RoleCode__c>(); Not Being Used
	set<string> roleNameSet = new Set<string>();
	set<string> RCodeSet = new Set<string>();
	Map<String,string> RCNameMap = new Map<string,string>();
	Map<string, set<String>> ORgMap = new Map<String, set<String>>();
	Map<String, List<Sales_Role__c>> srMap = new Map<String, List<Sales_Role__c>>();
	Map<String, List<Sales_Role__c>> SR_orgmap = new Map<String, List<Sales_Role__c>>();
	
	try
	{
	  List<Territory2> T2List = [Select Id,Name,Hierarchy_Level__c, ParentTerritory2.Name, ParentTerritory2.ParentTerritory2.Name, ParentTerritory2.ParentTerritory2.ParentTerritory2.Name, 
	  ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name, ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name from Territory2 where Hierarchy_Level__c = 'L7'];
	  for(Sales_Role__c srRecord : newsalesroleList)
	  {
  
  String Rolename_trim = srRecord.Role_Name__c.substringAfter('-').trim();
  roleNameSet.add(Rolename_trim);
  userIdset.add(srRecord.User__c);
  
  If(!SR_orgmap.containskey(srRecord.Role_Name__c+srRecord.BG__c+srRecord.Organisation__c))
	SR_orgmap.put(srRecord.Role_Name__c+srRecord.BG__c+srRecord.Organisation__c, new List<Sales_Role__c>{srRecord});
  else
	SR_orgmap.get(srRecord.Role_Name__c+srRecord.BG__c+srRecord.Organisation__c).add(srRecord);
  
  
  If(!srMap.containskey(Rolename_trim+srRecord.BG__c))
	srMap.put(Rolename_trim+srRecord.BG__c, new List<Sales_Role__c>{srRecord});
  else
	srMap.get(Rolename_trim+srRecord.BG__c).add(srRecord);
  
  If(!Orgmap.containskey(srRecord.Organisation__c))
  {
	set<string> Orgset = new set<string>();
	
	for(Territory2 T2Obj : T2List)
	{
	  if(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name == srRecord.Organisation__c || 
	 T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name == srRecord.Organisation__c)
	  {
		orgSet.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
		orgSet.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
	  }
	  else if(T2Obj.Name == srRecord.Organisation__c || T2Obj.ParentTerritory2.Name == srRecord.Organisation__c ||
	T2Obj.ParentTerritory2.ParentTerritory2.Name == srRecord.Organisation__c || 
	T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name == srRecord.Organisation__c)
	  {
		orgSet.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
		orgSet.add(T2Obj.ParentTerritory2.ParentTerritory2.Name);
		orgSet.add(T2Obj.ParentTerritory2.Name);
		orgSet.add(T2Obj.Name);
	  }
	}
	If(!orgset.isempty())
	{	
	  orgmap.put(srRecord.Organisation__c,orgset);  
	}
  }
	  }   
	  
	  for(user userrecord : [Select Id ,FirstName,Name,LastName,IsActive from User Where id IN: userIdset])
	  {
  usernameidMap.put(userrecord.Id, userrecord);
	  }
	  for(NF_RoleCode__c RCObject : [Select Id, Role_Name__c, Name, Hierarchy_Level__c, A_S__c from NF_RoleCode__c where Role_Name__c IN :roleNameSet])
	  {
  RCodeSet.add(RCObject.Name);
  RCNameMap.put(RCObject.Hierarchy_Level__c.substringafter('L')+RCObject.Role_Name__c,RCObject.Name);
  if(!RoleASMap.containskey(RCObject.Role_Name__c))
	RoleASMap.put(RCObject.Role_Name__c,RCObject.A_S__c);
	  }
	  
	  List<Sales_Role__c> SRList = [Select Id ,Role_Name__c,Role_Code__c, Organisation__c,BG__c,User__c from Sales_Role__c where Role_code__c IN: RCodeSet];	
	  
	  for(Sales_Role__c SR_Object : newsalesroleList)
	  {
  
  integer count = 0;
  integer new_count = 0;
  integer New_VAlcount = 0;
  integer New_listcount = 0;
  string level = null;
  Set<String> OrgsSet = new Set<String>();
  List<String> org_Available = new List<String>();
  List<String> Deleteable_ID = new List<String>();
  String BGAttr = null;  
  String Rname = null;
  String message = null;
  Boolean is_iwa = false; 
  //String Organisation = null; Not Being Used
  
  
  Level = SR_Object.Role_Name__c.substringBefore('-').trim();
  Rname = SR_Object.Role_Name__c.substringAfter('-').trim();
  orgsSet = orgmap.get(SR_object.Organisation__c);   
  BGAttr = SR_Object.BG__c;
  
  if(RoleASMap.containskey(Rname))
	is_iwa = RoleASMap.get(Rname);
  
  
  //Check for duplicates in new List
  if(is_iwa == true){
	List<Sales_Role__c> srListinMap = srMap.get(Rname+BGAttr);
	If(srListinMap.size() > 1)
	{   List<Sales_Role__c> SRlist_Map = SR_orgmap.get(SR_Object.Role_Name__c+SR_Object.BG__c+SR_Object.Organisation__c);
	 for(Sales_Role__c srobj:srListinMap)
	 {
	   set<String> orgset = orgmap.get(srobj.organisation__c);
	   orgset.remove(srobj.organisation__c);
	   If(orgset.contains(SR_Object.organisation__c) || SRlist_Map.size()>1 ) // && SR_Object.user__c != srobj.user__c)
	   {
	new_count =new_count+ 1;
	org_available.add(srobj.organisation__c);
	   }  
	 }
	}
	//system.debug('oldsalesroleList++>'+oldsalesroleList);
	//check for duplicates in DB
	if(oldsalesroleList!=null){
	  for(Sales_Role__c oldsalerolerecord:oldsalesroleList)
	  {
		if(oldsalerolerecord.id == SR_Object.id&&((oldsalerolerecord.Role_Name__c!=SR_Object.Role_Name__c) ||(oldsalerolerecord.BG__c!=SR_Object.BG__c ) ||(oldsalerolerecord.Organisation__c!=SR_Object.Organisation__c )))
		{
	for(Sales_Role__c SRAllObj:SRList)
	{  
	  
	  if(is_iwa == true)
	  {
		if(SRAllObj.Role_Name__c.contains(Rname) && OrgsSet.contains(SRAllObj.Organisation__C) && SRAllObj.BG__c == BGAttr)
		{
		  System.debug('SRAllObj.Role_Name__c '+SRAllObj.Role_Name__c);
		  System.debug('Rname '+Rname);
		  System.debug('SRAllObj.Organisation__C '+SRAllObj.Organisation__C);
		  System.debug('OrgsSet '+OrgsSet);
		  System.debug('SRAllObj.BG__c '+SRAllObj.BG__c);
		  System.debug('BGAttr '+BGAttr);
		  System.debug('SRAllObj Id '+SRAllObj.Id);
		  count = count + 1;
		  if(!org_Available.contains(SRAllObj.Organisation__c))
	  org_Available.add(SRAllObj.Organisation__c);
		}
	  }
	  
	}
		}
	  }
	}
  }
  if(oldsalesroleList==null){
	for(Sales_Role__c SRAllObj:SRList)
	{
	  if(is_iwa == true)
	  {  
		
		if(SRAllObj.Role_Name__c.contains(Rname) && OrgsSet.contains(SRAllObj.Organisation__C) && SRAllObj.BG__c == BGAttr)
		{  
	System.debug('SRAllObj.Role_Name__c '+SRAllObj.Role_Name__c);
	System.debug('Rname '+Rname);
	System.debug('SRAllObj.Organisation__C '+SRAllObj.Organisation__C);
	System.debug('OrgsSet '+OrgsSet);
	System.debug('SRAllObj.BG__c '+SRAllObj.BG__c);
	System.debug('BGAttr '+BGAttr);
	System.debug('SRAllObj Id '+SRAllObj.Id);
	count = count + 1;
	if(!org_Available.contains(SRAllObj.Organisation__c))
	  org_Available.add(SRAllObj.Organisation__c);
		}
	  }
	}
  }
  if(is_iwa == false)
  {	  
	List<Sales_Role__c> SRlist_Map = SR_orgmap.get(SR_Object.Role_Name__c+SR_Object.BG__c+SR_Object.Organisation__c);
	if(!SRlist_Map.isEmpty())
	{
	  for(Sales_Role__c SRObj:SRlist_Map)
	  {
		if(SR_Object.User__c==SRObj.User__c)
		{  
	New_listcount=New_listcount+1;
	Deleteable_ID.add(SR_Object.Organisation__C);
		}
	  }
	}
	if(oldsalesroleList==null){
	  for(Sales_Role__c SRAllObj:SRList)
	  {
		if((SRAllObj.User__c==SR_Object.User__c) && (SRAllObj.Role_Name__c==SR_Object.Role_Name__c )&& (SRAllObj.Organisation__C==SR_Object.Organisation__C) && (SRAllObj.BG__c == BGAttr))
		{
	New_VAlcount=New_VAlcount+1;
	Deleteable_ID.add(SRAllObj.Organisation__C);
		}
	  }
	}
	if(oldsalesroleList!=null){
	  for(Sales_Role__c oldsalerolerecord:oldsalesroleList)
	  {
		if(oldsalerolerecord.id == SR_Object.id&&((oldsalerolerecord.User__c!=SR_Object.User__c)|| (oldsalerolerecord.Role_Name__c!=SR_Object.Role_Name__c) ||(oldsalerolerecord.BG__c!=SR_Object.BG__c ) ||(oldsalerolerecord.Organisation__c!=SR_Object.Organisation__c )))
		{
	for(Sales_Role__c SRAllObj:SRList)
	{
	  if((SRAllObj.User__c==SR_Object.User__c) && (SRAllObj.Role_Name__c==SR_Object.Role_Name__c )&& (SRAllObj.Organisation__C==SR_Object.Organisation__C) && (SRAllObj.BG__c == BGAttr))
	  {
		New_VAlcount=New_VAlcount+1;
		Deleteable_ID.add(SRAllObj.Organisation__C);
	  }
	}
		}
	  }
	}
  }
  If(new_count == 0 && count == 0 &&org_Available.isempty())
  {
	if(oldsalesroleList!=null)
	{
	  for(Sales_Role__c oldsalerolerecord:oldsalesroleList)
	  {
		if(oldsalerolerecord.id == SR_Object.id )
		{ 
	if(oldsalerolerecord.Role_Name__c!=SR_Object.Role_Name__c)SR_Object.Role_Code__c  = RCNameMap.get(level+RName);
	if(is_iwa == true&&SR_Object.Approval_Type__c==null)SR_Object.Approval_Type__c =GlobalConstants.AS_value;
	if(is_iwa == false&&SR_Object.Approval_Type__c!=null)SR_Object.Approval_Type__c =null;
		}
	  }  
	}
	
	else{
	  if( SR_Object.Role_Code__c==null) SR_Object.Role_Code__c  = RCNameMap.get(level+RName);
	  if(is_iwa == true) SR_Object.Approval_Type__c =GlobalConstants.AS_value;
	}
  }
  if(New_VAlcount!=0 || New_listcount>1)
  {
	if(!test.isRunningTest())SR_Object.addError('A record with this combination exists already in Sales Roles. Please check.');
  }
  else if(count != 0 && new_count !=0 )
  {
	if(!test.isRunningTest()) SR_Object.addError('Duplicate entries are available in the list as well as in Sales Role object for the Organisation in same/Multiple level');
  }
  else if(new_count != 0)
  {
	if(!test.isRunningTest())SR_Object.addError('Duplicate entries are available in the list for the Organisation in Same/Mutiple level');
  }
  else if(count != 0)
  {
	message = 'Sales Role entry is already available for the Organisation - '+Org_Available+', Role - '+Rname;
	If(BGAttr != null)
	  message = message + ' and BG - '+BGAttr;
	if(!test.isRunningTest())SR_Object.addError(message);
  }
  
	  }
	}
	catch(Exception ex)
	{
	  System.debug('Exception before createRecord'+ex.getMessage());
	}
  }
  
  public static void managePSROCostsVisibilities(Map<Id,Sales_Role__c> oldMap,Map<Id,Sales_Role__c> newMap, ID psId, List<PSRO_Costs_Visibilities_Manager__mdt> allowedRoles)
  {
	Map<String,Map<Id,PermissionSetAssignment>> psaCandidates = solveSalesRolesEntries(oldMap,newMap,psId,allowedRoles);
	Map<Id,PermissionSetAssignment>  psaCandidatesToBeAdded = psaCandidates.get('Add');
	Map<Id,PermissionSetAssignment>  psaCandidatesToBeRemoved = psaCandidates.get('Remove');
	
	Map<Id,List<Sales_role__c>> mappingSalesRolesIntoUserIds =  new Map<Id,List<Sales_role__c>>();
	List<Sales_Role__c> UserSalesRoleList = new List<Sales_Role__c>();
	if( newMap == null )//Deleting record
	{
	  UserSalesRoleList = [SELECT ID,User__c,User__r.isActive,User__r.Restriction_Level__c,Role_code__c,Role_Name__c,BG__c
	 FROM Sales_Role__c
	 WHERE User__c in:psaCandidatesToBeRemoved.keySet()
	 AND User__r.isActive=true
	 AND User__r.Restriction_Level__c != :GlobalConstants.CONFIDENTIAL_VALUE
	 AND Id NOT IN :oldMap.keySet()];
	  
	}
	else//Updating or inserting
	{
	  /*(System.debug('psaCandidatesToBeRemoved ' + psaCandidatesToBeRemoved);
	  System.debug([SELECT ID,User__c,User__r.isActive,User__r.Restriction_Level__c,Role_code__c,Role_Name__c,BG__c
	 FROM Sales_Role__c]);*/ //SF Ticket# 02368804
	  UserSalesRoleList = [SELECT ID,User__c,User__r.isActive,User__r.Restriction_Level__c,Role_code__c,Role_Name__c,BG__c
	 FROM Sales_Role__c
	 WHERE User__c in:psaCandidatesToBeRemoved.keySet()
	 AND User__r.isActive=true
	 AND User__r.Restriction_Level__c != :GlobalConstants.CONFIDENTIAL_VALUE];
	  
	}  
	for(Sales_Role__c currentSalesRole:  UserSalesRoleList){
	  for(PSRO_Costs_Visibilities_Manager__mdt allowRole: allowedRoles)
	  {
  if(String.isBlank(allowRole.BG__c) || (String.isNotBlank(allowRole.BG__c) && String.isNotBlank(currentSalesRole.BG__c) && (currentSalesRole.BG__c).contains(allowRole.BG__c)))
  {
	if(String.isNotBlank(currentSalesRole.Role_Name__c) && (currentSalesRole.Role_Name__c).contains(allowRole.Role_Name__c))
	{
	  if(String.isNotBlank(currentSalesRole.User__c))
	  {
		if(mappingSalesRolesIntoUserIds.get(currentSalesRole.User__c) == null)
		{
	mappingSalesRolesIntoUserIds.put(currentSalesRole.User__c,new List<Sales_Role__c>{currentSalesRole});
		}
		else
		{
	List<Sales_Role__c> srListToBeAdded = mappingSalesRolesIntoUserIds.get(currentSalesRole.User__c);
	srListToBeAdded.add(currentSalesRole);
	mappingSalesRolesIntoUserIds.put(currentSalesRole.User__c,srListToBeAdded);
		}
	  }
	}
  }
	  }
	}
	System.debug('mappingSalesRolesIntoUserIds: ' + mappingSalesRolesIntoUserIds);
	for(ID currentUserId : mappingSalesRolesIntoUserIds.keySet())
	{
	  if(mappingSalesRolesIntoUserIds.get(currentUserId).size() >= 1)
	  {
  psaCandidatesToBeRemoved.remove(currentUserId);
	  }
	}
	if(system.isBatch())
	{
	  treatCostsPermissionSetAssignment(psaCandidatesToBeAdded.keySet(),psaCandidatesToBeRemoved.keySet(),psId);
	}
	else
	{
	  treatCostsPermissionSetAssignmentFuture(psaCandidatesToBeAdded.keySet(),psaCandidatesToBeRemoved.keySet(),psId);
	}
  }
  
  @future
  public static void treatCostsPermissionSetAssignmentFuture(Set<ID> permissionSetAssignmentToAdd,Set<ID> permissionSetAssignmentToRemove, Id psId)
  {
	treatCostsPermissionSetAssignment(permissionSetAssignmentToAdd,permissionSetAssignmentToRemove,psId);
  }
  
  public static void treatCostsPermissionSetAssignment(Set<ID> permissionSetAssignmentToAdd,Set<ID> permissionSetAssignmentToRemove, Id psId)
  {
	List<PermissionSetAssignment> psaToBeAdded = new List<PermissionSetAssignment>();
	for(ID currentPsa :permissionSetAssignmentToAdd)
	  psaToBeAdded.add(new PermissionSetAssignment(AssigneeId=currentPsa,PermissionSetId=psId));
	try
	{
	  if(!permissionSetAssignmentToRemove.isEmpty())
	  {
  PermissionSetAssignment pmsaToDelete = [SELECT ID,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId in:permissionSetAssignmentToRemove AND PermissionSetId=:psId AND Assignee.Restriction_level__c != :GlobalConstants.CONFIDENTIAL_VALUE];
  Database.delete(pmsaToDelete,false);
	  }
	}
	catch(Exception e)
	{
	  System.debug('Error on delete record: '+e.getMessage());
	}
	
	try
	{  
	  Database.SaveResult[] psInsList = Database.insert(psaToBeAdded,false);
	  System.debug(psInsList);
	}
	catch(Exception e)
	{
	  System.debug('Error on inserting records: '+e.getMessage());
	}
  }
  
  public static Map<String,Map<Id,PermissionSetAssignment>> solveSalesRolesEntries(Map<Id,Sales_Role__c> oldMap,Map<Id,Sales_Role__c> newMap, ID psId, List<PSRO_Costs_Visibilities_Manager__mdt> allowedRoles)
  {
	Map<Id,PermissionSetAssignment> psaListToAdd  = new Map<Id,PermissionSetAssignment>();
	Map<Id,PermissionSetAssignment> psaListToRemove   = new Map<Id,PermissionSetAssignment>();
	PermissionSetAssignment	 costsPSA   = new PermissionSetAssignment(PermissionSetId = psId);
	
	//insert mode
	if(oldMap ==null)
	{
	  for(Sales_Role__c currentSrEntry : newMap.values())
	  {
  for(PSRO_Costs_Visibilities_Manager__mdt allowRole: allowedRoles)
  {
	if(String.isBlank(allowRole.BG__c) || (String.isNotBlank(allowRole.BG__c) && String.isNotBlank(currentSrEntry.BG__c) && (currentSrEntry.BG__c).contains(allowRole.BG__c)))
	{
	  if(String.isNotBlank(currentSrEntry.Role_Name__c) && (currentSrEntry.Role_Name__c).contains(allowRole.Role_Name__c))
	  {
		if(String.isNotBlank(currentSrEntry.User__c))
		{
	costsPSA.AssigneeId = currentSrEntry.User__c;
	psaListToAdd.put(costsPSA.AssigneeId,costsPSA);
		}
	  }
	}
  }
	  }
	}
	else
	{
	  //update mode
	  if(oldMap!=null && newMap!=null)
	  {
  for(Sales_Role__c currentSrEntry : newMap.values())
  {
	for(PSRO_Costs_Visibilities_Manager__mdt allowRole: allowedRoles)
	{
	  Sales_Role__c oldSalesRoleEntry = oldMap.get(currentSrEntry.id) != null ? oldMap.get(currentSrEntry.id) : null;
	  if(String.isBlank(allowRole.BG__c) || (String.isNotBlank(allowRole.BG__c) && String.isNotBlank(currentSrEntry.BG__c) &&  (currentSrEntry.BG__c).contains(allowRole.BG__c)) || (String.isNotBlank(allowRole.BG__c) && String.isNotBlank(oldSalesRoleEntry.BG__c) &&  (oldSalesRoleEntry.BG__c).contains(allowRole.BG__c))) 
	  {
		if(oldSalesRoleEntry != null && (currentSrEntry.Role_Name__c != oldSalesRoleEntry.Role_Name__c || currentSrEntry.User__c != oldSalesRoleEntry.User__c || currentSrEntry.BG__c != oldSalesRoleEntry.BG__c))
		{
	if(String.isNotBlank(currentSrEntry.Role_Name__c) && (currentSrEntry.Role_Name__c).contains(allowRole.Role_Name__c) && (String.isBlank(allowRole.BG__c) || (String.isNotBlank(allowRole.BG__c) && String.isNotBlank(currentSrEntry.BG__c)) && (currentSrEntry.BG__c).contains(allowRole.BG__c)) )//New sales role is in PSRO metadata
	{
	  if(String.isNotBlank(currentSrEntry.User__c))
	  {
		costsPSA.AssigneeId = currentSrEntry.User__c;
		psaListToAdd.put(costsPSA.AssigneeId,costsPSA);
	  }
	}
	if(String.isNotBlank(oldSalesRoleEntry.Role_Name__c) && (oldSalesRoleEntry.Role_Name__c).contains(allowRole.Role_Name__c) && (String.isBlank(allowRole.BG__c) || (oldSalesRoleEntry.BG__c).contains(allowRole.BG__c)))
	{
	  if(String.isNotBlank(oldSalesRoleEntry.User__c))
	  {
		costsPSA.AssigneeId = oldSalesRoleEntry.User__c;
		psaListToRemove.put(costsPSA.AssigneeId,costsPSA);
	  }
	}
		}
	  }
	}
  }
	  }
	  else
	  {
  //delete mode
  if(newMap==null)
  {
	for(Sales_Role__c currentSrEntry : oldMap.values())
	{
	  for(PSRO_Costs_Visibilities_Manager__mdt allowRole: allowedRoles)
	  {
		if(String.isBlank(allowRole.BG__c) || (String.isNotBlank(allowRole.BG__c) && String.isNotBlank(currentSrEntry.BG__c) && (currentSrEntry.BG__c).contains(allowRole.BG__c)))
		{
				if(String.isNotBlank(currentSrEntry.Role_Name__c) && (currentSrEntry.Role_Name__c).contains(allowRole.Role_Name__c))
	{
	  if(String.isNotBlank(currentSrEntry.User__c))
	  {
		costsPSA.AssigneeId = currentSrEntry.User__c;
		psaListToRemove.put(costsPSA.AssigneeId,costsPSA);
	  }
	}
		}
	  }
	}
  }
	  }
	}
	Map<String,Map<Id,PermissionSetAssignment>> result = new Map<String,Map<Id,PermissionSetAssignment>>();
	result.put('Add',psaListToAdd);
	result.put('Remove',psaListToRemove);
	return result;
  }
}