/************************************************************************************************************ 
Name : NF_EditAssignments
Created Date: 7 JULY 2018
Created by: Accenture
Description :Pack-4 CMD implementation - Controller class of NF_edit Assignment AurA bundle  
*********************************************************************************************************/
public with sharing class NF_EditAssignments 
{
	
	/*****************************************************
	*Method Name: returnL1Territories
	*Parameter: Territory
	*Description: returns current user Assigned territories
	*****************************************************/
	@AuraEnabled
	public static List<Territory2>  returnL1Territories()
	{
		try
		{	 
			Id userId = UserInfo.getUserId();
			set<String> orgsset = new set<string>();
			set<String> orgset_val = new set<String>();
			Map<String,string> L3map = new Map<String, string>();
			Map<String,string> L2map = new Map<String, string>();
			List <string> Hide_territories=new   List<string>();
			string Hidden_Territory=Label.Nf_HideTerritory;
			string[] Hid_territories=Hidden_Territory.split(';');
			
			for(string Territory:Hid_territories)
			{
	Hide_territories.add(Territory);
	Hide_territories.add(Territory+GlobalConstants.NSA_Val);
	Hide_territories.add(Territory+' '+GlobalConstants.NSA_Val);
			}
			
			List<UserTerritory2Association> UtaList = [SELECT RoleInTerritory2,Territory2id,Territory2.Hierarchy_Level__c,
				Territory2.Name, 
				Territory2.Id,
				Territory2.ParentTerritory2.Name,
				Territory2.ParentTerritory2.ParentTerritory2.Name,
				Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
				UserId FROM UserTerritory2Association WHERE UserId =:userId and IsActive =: true];
			
	//  system.debug('UtaList:'+UtaList);
			
			for(UserTerritory2Association UTARecord: UtaList)
			{
	orgsset.add(UTARecord.Territory2.Name);
	orgset_val.add(UTARecord.Territory2.Name);
			}
	 
	for(string UTA_val: orgsset)
	{
	if(!UTA_val.contains(GlobalConstants.NSA_Val)) 
	{
	orgsset.add(UTA_val+GlobalConstants.NSA_Val);
	orgsset.add(UTA_val+' '+GlobalConstants.NSA_Val);
	orgset_val.add(UTA_val+' '+GlobalConstants.NSA_Val);
	orgset_val.add(UTA_val+GlobalConstants.NSA_Val);
	} 
	 
	}
	 
			
			List<Territory2> territory_L2ToL7List = new List<Territory2>();
			territory_L2ToL7List = [SELECT Id,Name,Hierarchy_ID__c,Hierarchy_Level__c,
			ParentTerritory2Id,
			Territory2.ParentTerritory2.Name,
			Territory2.ParentTerritory2.ParentTerritory2.Name,
			Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
			Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
			ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
			Territory2TypeId FROM Territory2 WHERE Territory2Model.state = 'Active' AND Name NOT IN :Hide_territories AND Name IN :orgsset ];
			for(Territory2  L2ToL7List:territory_L2ToL7List)
			{
	L3map.put(L2ToL7List.Name,L2ToL7List.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
	L2map.put(L2ToL7List.Name,L2ToL7List.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name); 
			}
			
			for(Territory2 UTARecord: territory_L2ToL7List) 
			{
	If(Orgsset.contains(UTARecord.ParentTerritory2.Name) || Orgsset.contains(UTARecord.ParentTerritory2.ParentTerritory2.Name) || Orgsset.contains(UTARecord.ParentTerritory2.parentTerritory2.parentTerritory2.Name)
	   ||Orgsset.contains(L2map.get(UTARecord.Name))  || Orgsset.contains(L3map.get(UTARecord.Name))  )
		orgset_val.remove(UTARecord.Name);
			}
			
			List<Territory2> territoryL1List = new List<Territory2>();
			territoryL1List = [SELECT id,Name,Hierarchy_ID__c,Hierarchy_Level__c,ParentTerritory2Id,Territory2TypeId FROM Territory2 WHERE Name IN: orgset_val AND Territory2Model.state = 'Active' AND Name NOT IN :Hide_territories  ];
			//System.debug('territoryL1List::>'+territoryL1List);
			
			return territoryL1List;
			
			
		}
		catch(Exception ex)
		{
			System.debug('returnL1Territories Exception');
			return null;
		}
	}
	
	/***************************************
	*Method Name: returnL2toL7Territories
	*Parameter: Territory2
	*Description: returns All territories
	****************************************/
	@AuraEnabled
	public static List<Territory2>  returnL2toL7Territories()
	{
		try
		{	
			string Hidden_Territory=Label.Nf_HideTerritory;
			List<Territory2> territoryL2ToL7List = new List<Territory2>();
			List <string> Hide_territories=new   List<string>();
			
			string[] Hid_territories=Hidden_Territory.split(';');
			for(string Territory:Hid_territories)
			{
	Hide_territories.add(Territory);
	Hide_territories.add(Territory+GlobalConstants.NSA_Val);
	Hide_territories.add(Territory+' '+GlobalConstants.NSA_Val);
			}
			territoryL2ToL7List = [SELECT Id,Name,Hierarchy_ID__c,Hierarchy_Level__c,ParentTerritory2Id,Territory2TypeId FROM Territory2 WHERE Territory2Model.state = 'Active' AND Name NOT IN :Hide_territories  ];
			return territoryL2ToL7List;
			
		}
		Catch(Exception Ex)
		{
			System.debug('returnL2toL7Territories Exception');
			return null;
		}
	}
	
	@AuraEnabled
	public static boolean checkAccessToRunPSROBatch()
	{
		Boolean accessGranted = false;
		List<User> pmsaList = [SELECT Id FROM User WHERE Id = :userInfo.getUserId() 
							   AND ProfileId IN (SELECT Id FROM Profile WHERE Name IN (:GlobalConstants.NOKIA_ADMIN_PROFILE,:GlobalConstants.SYSTEM_AdMINISTRATOR,:GlobalConstants.GLOBAL_PROCESS_ADMIN_PROFILE))];
		if(pmsaList.size() > 0)
		{
			accessGranted = true;
		}
		return accessGranted;
	}
	
	/************************************************
	*Method Name: savesales_roleUser
	*Parameter: savesales_role
	*Description: to insert data into Salesrole table
	***************************************************/
	@AuraEnabled 
	public static void  savesales_roleUser(Sales_Role__c savesales_role)
	{ 
		if(savesales_role.BG__c=='')savesales_role.BG__c=null;
		string RoleNamewith_level;
		List<Territory2> Hierarchy_LevelSelect= [Select Id,Name,ParentTerritory2Id ,Hierarchy_Level__c from Territory2 where Name=:savesales_role.Organisation__c];
		for(Territory2 Level:Hierarchy_LevelSelect){
			integer currentlevel=Integer.valueOf(Level.Hierarchy_Level__c.subString(1,Level.Hierarchy_Level__c.length())); 
			RoleNamewith_level=currentlevel+' '+'-'+' '+savesales_role.Role_Name__c;
			// system.debug('RoleNamewith_level++>'+RoleNamewith_level);
		}
		savesales_role.Role_Name__c=RoleNamewith_level;
	savesales_role.Process_SRT_Audit__c =true;
		
		 //system.debug('savesales_role.Process_SRT_Audit__c++>'+savesales_role.Process_SRT_Audit__c);
		if(savesales_role.Organisation__c.contains(GlobalConstants.NSA_Val))savesales_role.Organisation__c= savesales_role.Organisation__c.substringBefore(GlobalConstants.NSA_Val).trim();
		
		// system.debug('savesales_role++>'+savesales_role);
		
	 if(!test.isRunningTest())
		insert savesales_role;
		
	}
	
	@AuraEnabled
	/*  Method for Popup window for Change History
	Req#4618
	Author:Pradnya */
	public static List <Sales_Role_History__c> getDetails() {
		return [SELECT Id, Operation_Type__c, Role_Code__c, Old_Role_Name__c, New_Role_Name__c,Comments__c, BG_Attribute__c,LastModifiedBy.Name,LastModifiedDate FROM Sales_Role_History__c];
	}
	
	/*  Method for redirecting to history list view
	Req #4877
	Author:Pradnya */
	@AuraEnabled
	public static List<ListView> getObjViews() {
		List<ListView> listviews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Sales_Role_History__c'];
		
		return listviews;
	}
	
	 @AuraEnabled
	 public static  Map<String, boolean> FrozenUSerCheck() {
	Map<String, boolean> isFrozenuser = new Map<String,boolean>();

   for(UserLogin USerLogincheck : [SELECT IsFrozen,IsPasswordLocked,UserId FROM UserLogin where isfrozen=true  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	isFrozenuser.put(USerLogincheck.UserId, USerLogincheck.IsFrozen);
			}  
			return isFrozenuser;
	}
	/************************************************************************
	*Method Name: saveListsalesroleUser
	*Parameter: ListsalesroleUser
	*Description: to create Salesrolelist used for DML Operation in SalesRole
	*************************************************************************/
	@AuraEnabled
	public static void saveListsalesroleUser(string ListsalesroleUser){
	//system.debug('listsrinsert++>'+ListsalesroleUser); 
		List<SalesRoleWrapper> stageList = (List<SalesRoleWrapper>)JSON.deserialize(ListsalesroleUser,List<SalesRoleWrapper>.class);
		List<Sales_Role__c> toBeInsertedList = new List<Sales_Role__c>();
		List<Sales_Role__c> toBeupdatedList = new List<Sales_Role__c>();
		List<string> toBedeletedList = new List<string>();
		
		for(SalesRoleWrapper salesRecord : stageList)
		{
			if(salesRecord.usercheck!=null &&salesRecord.SalesRoleObj==null )
			{	
	if(salesRecord.Organisation.contains(GlobalConstants.NSA_Val))salesRecord.Organisation = salesRecord.Organisation.substringBefore(GlobalConstants.NSA_Val).trim();
	Sales_Role__c salesRec = new Sales_Role__c();
	
	salesRec.Organisation__c = salesRecord.Organisation;
	salesRec.Role_Name__c   = salesRecord.Rolename;
	salesRec.User__c	= salesRecord.usercheck.Id;
	salesRec.BG__c	 = salesRecord.BG;
	   salesRec.Process_SRT_Audit__c =true;
	 
	toBeInsertedList.add(salesRec);
			}
			
			if(salesRecord.usercheck!=null &&salesRecord.SalesRoleObj!=null )
			{
	
	if(salesRecord.SalesRoleObj.User__c!=salesRecord.usercheck.Id)
	{ //system.debug('salesRecord.Organisation++>'+salesRecord.Organisation); 
		salesRecord.SalesRoleObj.User__c=salesRecord.usercheck.Id;
			salesRecord.SalesRoleObj.Process_SRT_Audit__c =true;
	
		if(salesRecord.SalesRoleObj.Organisation__c.contains(GlobalConstants.NSA_Val))salesRecord.SalesRoleObj.Organisation__c = salesRecord.SalesRoleObj.Organisation__c.substringBefore(GlobalConstants.NSA_Val).trim();
		toBeupdatedList.add(salesRecord.SalesRoleObj);
	}
			}
			
			if(salesRecord.usercheck==null &&salesRecord.SalesRoleObj!=null)
			{   
	  if(salesRecord.SalesRoleObj.Process_SRT_Audit__c==false)
	{
	 if(salesRecord.SalesRoleObj.Organisation__c.contains(GlobalConstants.NSA_Val))
	  salesRecord.SalesRoleObj.Organisation__c = salesRecord.SalesRoleObj.Organisation__c.substringBefore(GlobalConstants.NSA_Val).trim();
		
		salesRecord.SalesRoleObj.Process_SRT_Audit__c =true;
		toBeupdatedList.add(salesRecord.SalesRoleObj);
	 }
	
	toBedeletedList.add(salesRecord.SalesRoleObj.id);
			}
			
		}
	 if(!toBeupdatedList.isEmpty() )
		{
			//system.debug('toBeupdatedList++>'+toBeupdatedList);
	 if(!test.isRunningTest()) database.update(toBeupdatedList);
		}
		if(!toBedeletedList.isEmpty() )
		{
			//system.debug('toBedeletedList++>'+toBedeletedList);
			if(!test.isRunningTest())database.delete(toBedeletedList);
		}
		if(!toBeInsertedList.isEmpty() )
		{
			//system.debug('toBeInsertedList++>'+toBeInsertedList);
			if(!test.isRunningTest())database.Insert(toBeInsertedList);
		}
	  
		
	}
	
/*********************************************************************
	*Method Name: returnsaleroleuser_Info
	*Parameter: salesrolePagerWrapper
	*Description:To retrieve data from Sales Role Table - Edit Assignments
	**********************************************************************/
	@AuraEnabled
	public static salesrolePagerWrapper returnsaleroleuser_Info(Decimal pageNumber ,Integer recordToDisply,String org,string BG,string Rolename,Boolean level,boolean assigned,String userName,String ASValue)
	{			
		try
		{
			List<Sales_Role__c> SRList = new List<Sales_Role__c>();
			List<NF_RoleCode__c> NFList = new List<NF_RoleCode__c>();
			Map<String, SalesRoleWrapper> salesRoleWrapperMap = new Map<String,SalesRoleWrapper>();
			Map<String, Territory2> territoryMap = new Map<String, Territory2>();
			List<salesRoleWrapper> wrapperList = new List<salesRoleWrapper>();
			salesRoleWrapper ReturnWrap_list =new salesRoleWrapper();
			set<String> totalset = new set<string>();
			set<String> totalset_NSA = new set<string>();
			List<Territory2> T2List =  new List<Territory2>();
			set<string> Hierarchylevelset=new set<string>();
			set<string> USer_IDset=new set<string>();
			Map<String, User> usernameidMap = new Map<String,User>();
			Map<String, NF_RoleCode__c> rolecodemap = new Map<String,NF_RoleCode__c>();
			List <string> Hide_territories=new   List<string>();
			salesrolePagerWrapper pagewrapper =  new salesrolePagerWrapper();
	List<salesRoleWrapper> T2Listval =  new List<salesRoleWrapper>();
			
			string Hidden_Territory=Label.Nf_HideTerritory;
			string[] Hid_territories=Hidden_Territory.split(';');
			for(string Territory:Hid_territories)
			{
	Hide_territories.add(Territory);
	Hide_territories.add(Territory+GlobalConstants.NSA_Val);
	Hide_territories.add(Territory+' '+GlobalConstants.NSA_Val);
			}
			Integer pageSize = recordToDisply;
			Integer offset = ((Integer)pageNumber - 1) * pageSize;
	integer i;
			integer value=offset+recordToDisply;
			
			String role_Name = null;
			String queryNF = 'Select Id, Role_Name__c, Name, Hierarchy_Level__c, A_S__c from NF_RoleCode__c';
			if(RoleName != null)
			{	
	  // role_Name  = '%' + RoleName;
	queryNF += ' where Role_Name__c LIKE: RoleName';
			}
			NFList = database.query(queryNF);
			// system.debug('queryNF++>'+queryNF);
	 // system.debug(' NFList++>'+ NFList);
			for(NF_RoleCode__c RCObject : NFList)
			{
	rolecodemap.put(RCObject.Role_Name__c+RCObject.Hierarchy_Level__c,RCObject);
	if(level == false){
	if(Rolename!=null)
	{
		if(!Hierarchylevelset.contains(RCObject.Hierarchy_Level__c)) Hierarchylevelset.add(RCObject.Hierarchy_Level__c);
	}
	else{
		Set<String> Levelset= new Set<String>{GlobalConstants.L2_level, GlobalConstants.L3_level,GlobalConstants.L4_level,GlobalConstants.L5_level,GlobalConstants.L6_level,GlobalConstants.L7_level};
			Hierarchylevelset.addAll(Levelset) ;
	}
	}
			}
	//system.debug('Hierarchylevelset++>'+Hierarchylevelset);
			if(level == true)
			{
	totalset.add(org);	 
	T2List =  [Select Id, Name, Hierarchy_Level__c, ParentTerritory2.Name, ParentTerritory2.ParentTerritory2.Name, ParentTerritory2.ParentTerritory2.ParentTerritory2.Name, 
		 ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name, ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name from Territory2 where Name =: org ];
	Territory2 T2obj = T2List[0];
	Hierarchylevelset.add(T2obj.Hierarchy_Level__c);
	territoryMap.put(T2obj.Name, T2obj);
			}
			if(level == false)
			{
	for(Territory2 T2Obj : [Select Id, Name, Hierarchy_Level__c,
				ParentTerritory2.Name,
				ParentTerritory2.Hierarchy_Level__c,
				ParentTerritory2.ParentTerritory2.Name,
				ParentTerritory2.ParentTerritory2.Hierarchy_Level__c,
				ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
				ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c,
				ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
				ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c,
				ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name ,
				ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c from Territory2  ])
	{
		territoryMap.put(T2obj.Name, T2obj);
		if(T2Obj.Hierarchy_Level__c == GlobalConstants.L7_level&& !Hide_territories.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name))
		{
			if(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name == org ||
		 T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name == org ||T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name == org ||
		 T2Obj.ParentTerritory2.ParentTerritory2.Name == org || T2Obj.ParentTerritory2.Name == org || T2Obj.Name == org)
			{
				if(Hierarchylevelset.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c) )totalset.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
				if(Hierarchylevelset.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)  )totalset.add(T2obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
				if(Hierarchylevelset.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)  )totalset.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
				if(Hierarchylevelset.contains(T2Obj.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c) )totalset.add(T2Obj.ParentTerritory2.ParentTerritory2.Name);
				if(Hierarchylevelset.contains(T2Obj.ParentTerritory2.Hierarchy_Level__c) )totalset.add(T2Obj.ParentTerritory2.Name);
				if(Hierarchylevelset.contains(T2Obj.Hierarchy_Level__c) )totalset.add(T2Obj.Name);
			}
		}
	}   
			}
	//system.debug('totalset++>'+totalset.size());
			if(org.contains(GlobalConstants.NSA_Val))
			{
	for(String NSA_org:totalset)
	{
		NSA_org = NSA_org.substringBefore(GlobalConstants.NSA_Val).trim();
		totalset_NSA.add(NSA_org);
	}
			}
			//system.debug('totalset_NSA++>'+totalset_NSA);
			String Least_level = null;
			String RName = null;
			boolean NSAvalue=true;
			
			String querycount = 'SELECT count() FROM Sales_Role__c';
			String SRquery = 'SELECT Id,Name,BG__c,Organisation__c,Process_SRT_Audit__c,Approval_Type__c,Role_Code__c,Role_Name__c,Active__c,User__c,NSA__c,User__r.id,User__r.Name,User__r.Profile.Name,User__r.IsActive FROM Sales_Role__c';
			String query = '';
			if(!org.contains(GlobalConstants.NSA_Val) )
			query += ' where Organisation__c IN :totalset';
			if(org.contains(GlobalConstants.NSA_Val))
			{
			query += ' where Organisation__c IN :totalset_NSA';
			if(assigned==true )
	query += ' AND NSA__c=:NSAvalue';	  
			}
			
			if(BG != '')
			query += ' AND BG__c =: BG';
			if(RoleName != null)
			{	
	RName  = '% - ' +RoleName;
	query += ' AND Role_Name__c LIKE: RName';
			}
			string AsVAl=GlobalConstants.AS_value;
			string As_val=null;
			
			if(userName != null) 
			query += ' AND User__r.Name =: userName';
			if(assigned==true){
	if(ASValue != null&&ASValue ==GlobalConstants.IWA_Check) 
	query += ' AND Approval_Type__c Like : AsVAl ';
	if(ASValue != null&&ASValue ==GlobalConstants.Non_IWA_Check) 
		query += ' AND Approval_Type__c =:As_val ';
			}
	 query += ' AND User__c != null ';
			
			querycount += query;
			SRquery += query;
			if( assigned==true) SRquery += ' LIMIT :recordToDisply ';
			if( assigned==true) SRquery += ' OFFSET :offset';
			SRList = database.query(SRquery);
			//system.debug('SRList++>'+SRList);
	 
	if(!SRList.isempty())
	{
	  for(Sales_Role__c salesRoleval : SRList){
	USer_IDset.add(salesRoleval.User__c); 
	}
	}
			for(user userrecord : [Select Id,Name,Email,NSA_Compliant__c,IsActive,Profile.Name from User where id IN:USer_IDset])
			{
	usernameidMap.put(userrecord.Id, userrecord);
			}
			if(assigned==true){
	for(Sales_Role__c salesRole : SRList){
		salesRoleWrapper srw= new salesRoleWrapper();
		srw.SalesRoleObj = salesRole;
		srw.Organisation = salesRole.Organisation__c;
		srw.usercheck=usernameidMap.get(salesRole.User__c);
		 srw.usersearch=null;
		if(org.contains(GlobalConstants.NSA_Val))
		{
			salesRole.Organisation__c=salesRole.Organisation__c+GlobalConstants.NSA_Val;
			srw.Organisation = salesRole.Organisation__c;
		}
		Territory2 territory = territoryMap.get(salesRole.Organisation__c);
		if(org.contains(GlobalConstants.NSA_Val)&&territory==null)
		{
			salesRole.Organisation__c=salesRole.Organisation__c.substringBefore(GlobalConstants.NSA_Val).trim()+' '+GlobalConstants.NSA_Val;
			territory = territoryMap.get(salesRole.Organisation__c);
			srw.Organisation = salesRole.Organisation__c;

		}
		//system.debug(' srw.Organisation++>'+ srw.Organisation);
		if(territoryMap.containskey(salesRole.Organisation__c))
		{   
			if(salesRole.Organisation__c.contains(GlobalConstants.NSA_Val))salesRole.Organisation__c =salesRole.Organisation__c.substringBefore(GlobalConstants.NSA_Val).trim();
			
			ReturnWrap_list=return_LevelwrapperList(territory);
			srw.l7 = ReturnWrap_list.l7;
			srw.l6 = ReturnWrap_list.l6;
			srw.l5 = ReturnWrap_list.l5;
			srw.l4 = ReturnWrap_list.l4; 
			srw.l3 = ReturnWrap_list.l3; 
			srw.l2 = ReturnWrap_list.l2; 
		}
		wrapperList.add(srw);
	}
	
			}
	 if(assigned==false)
			{
	List<Sales_Role__c> salesrole_List = new List<Sales_Role__c>();
	Map<String, List<Sales_Role__c>> srMap = new Map<String, List<Sales_Role__c>>();
	List<String> HLevelList = new List<String>();
	
	for(Sales_Role__c salesRole :SRList)
	{ 
		if(BG!=''){
	 If(!srMap.containskey(salesRole.Organisation__c+salesRole.Role_Name__c+salesRole.BG__c) )
	  srMap.put(salesRole.Organisation__c+salesRole.Role_Name__c+salesRole.BG__c, new List<Sales_Role__c>{salesRole});
	else
		srMap.get(salesRole.Organisation__c+salesRole.Role_Name__c+salesRole.BG__c).add(salesRole);
		}
		if(BG==''){
	If( !srMap.containskey(salesRole.Organisation__c+salesRole.Role_Name__c))
	 srMap.put(salesRole.Organisation__c+salesRole.Role_Name__c, new List<Sales_Role__c>{salesRole});
	else
	  srMap.get(salesRole.Organisation__c+salesRole.Role_Name__c).add(salesRole);
		}
	}
	HLevelList.addAll(Hierarchylevelset);
	HLevelList.sort();
	Least_level = HLevellist[HLevelList.size()-1];
	
	for(string salesRole_orgval : totalset){ 
		salesrole_List.clear();
		if(territoryMap.containsKey(salesRole_orgval)){
	 Territory2 territoryval = territoryMap.get(salesRole_orgval);
	 Integer currentLevelval = Integer.valueOf(territoryval.Hierarchy_Level__c.subString(1,territoryval.Hierarchy_Level__c.length())); 
	 String Role_NAme_val=currentLevelval+' - '+Rolename; 
	   string salesRole_orgvalue=salesRole_orgval;	 
	  if(salesRole_orgval.contains(GlobalConstants.NSA_Val))
		salesRole_orgvalue = salesRole_orgval.substringBefore(GlobalConstants.NSA_Val).trim();
			
			if(BG!='')
			{
				if(srMap.containskey(salesRole_orgvalue+Role_NAme_val+BG))
		salesrole_List =srMap.get(salesRole_orgvalue+Role_NAme_val+BG);
			}
			if(BG=='')
			{  
				if(srMap.containskey(salesRole_orgvalue+Role_NAme_val))
		  salesrole_List =srMap.get(salesRole_orgvalue+Role_NAme_val);
			}
			
	if(salesrole_List.isEmpty())
	{
		Sales_Role__c SalesRec=new Sales_Role__c();
		SalesRec.Organisation__c =salesRole_orgval;
		SalesRec.Role_Name__c =Role_NAme_val;
		SalesRec.BG__c =BG;
		SalesRec.User__c=null;
	salesrole_List.add(SalesRec); 
	}
		 //  system.debug('salesrole_List++>'+salesrole_List);
			for(Sales_Role__c salesRole_org : salesrole_List){
				if(rolecodemap.containskey(Rolename+territoryval.Hierarchy_Level__c)){
				Territory2 territory = territoryMap.get(salesRole_orgval);
				salesRoleWrapper srw = new salesRoleWrapper();
				srw.IWAFlag=rolecodemap.get(Rolename+territory.Hierarchy_Level__c);
				srw.Organisation = salesRole_orgval; 
				srw.BG = salesRole_org.BG__c;
				srw.usercheck=null;
				srw.usersearch=null;
				if(salesRole_org.User__c!=null)srw.SalesRoleObj=salesRole_org;
				srw.Rolename =salesRole_org.Role_Name__c;		 
		//  system.debug('salesRole_org.User__c++>'+salesRole_org.User__c);
		
				if(salesRole_org.User__c!=null) srw.usercheck=usernameidMap.get(salesRole_org.User__c);
				
				ReturnWrap_list = return_LevelwrapperList(territory);
				srw.l7 = ReturnWrap_list.l7;
				srw.l6 = ReturnWrap_list.l6;
				srw.l5 = ReturnWrap_list.l5;
				srw.l4 = ReturnWrap_list.l4; 
				srw.l3 = ReturnWrap_list.l3; 
				srw.l2 = ReturnWrap_list.l2; 
				
				//system.debug('salesRole_org++>'+salesRole_org);
				wrapperList.add(srw);
				}
			}
		}
	}	
			}
			if(!wrapperList.isEmpty())wrapperList.sort();
			
	
	if(assigned==false){
	  for(i=offset; i<value;i++)
	{	  // system.debug('i+++>'+i);
		if(i==wrapperList.size())
		break;
		  else
		T2Listval.add(wrapperList[i]);
	}
			}
			pagewrapper.l2=false;
			pagewrapper.l3=false;
			pagewrapper.l4=false;
			pagewrapper.l5=false;
			pagewrapper.l6=false;
			pagewrapper.l7=false;
			pagewrapper.pageSize = pageSize;
			pagewrapper.page = (Integer) pageNumber;
			pagewrapper.LeastLevel = Least_level;
			pagewrapper.Salesrolemap =territoryMap;
			if(Hierarchylevelset.contains(GlobalConstants.L7_level))pagewrapper.l7=true;
	 if(Hierarchylevelset.contains(GlobalConstants.L6_level))pagewrapper.l6=true;
	 if(Hierarchylevelset.contains(GlobalConstants.L5_level))pagewrapper.l5=true;
	 if(Hierarchylevelset.contains(GlobalConstants.L4_level))pagewrapper.l4=true;
	 if(Hierarchylevelset.contains(GlobalConstants.L3_level))pagewrapper.l3=true;
	 if(Hierarchylevelset.contains(GlobalConstants.L2_level))pagewrapper.l2=true;
	if(assigned==true )
	{
	  pagewrapper.SalesRolewrapperlist=wrapperList;
	  pagewrapper.total = database.countquery(querycount);
	}
			if(assigned==false ){
	 pagewrapper.SalesRolewrapperlist=T2Listval;
	 pagewrapper.total = wrapperList.size()+1;
	pagewrapper.wrapper_list=wrapperList;
			}
   //system.debug('pagewrapper.total+++>'+pagewrapper.total);
	// system.debug('T2Listval.size+++>'+T2Listval.size());
	 // system.debug('wrapperList.size+++>'+wrapperList.size());
			
			return pagewrapper;
		}
		Catch(Exception Ex)
		{
			System.debug('returnL2toL7Territories Exception'+ex);
			return null;
		}
	}
	
	/*********************************************************************************
	*Method Name: return_LevelwrapperList
	*Parameter: SalesRoleWrapper
	*Description: To get parent territories of territories and returns a wrapper list 
	*********************************************************************************/
	public static SalesRoleWrapper return_LevelwrapperList(Territory2 territory)
	{
		salesRoleWrapper srw = new salesRoleWrapper();
		if(territory.Hierarchy_Level__c == GlobalConstants.L7_level){
			srw.l7 = territory.Name;
			srw.l6 = territory.ParentTerritory2.Name;
			srw.l5 = territory.ParentTerritory2.ParentTerritory2.Name;
			srw.l4 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
			srw.l3 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
			srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
		}else if(territory.Hierarchy_Level__c == GlobalConstants.L6_level){			 
			srw.l6 = territory.Name;
			srw.l5 = territory.ParentTerritory2.Name;
			srw.l4 = territory.ParentTerritory2.ParentTerritory2.Name;
			srw.l3 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
			srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
		}else if(territory.Hierarchy_Level__c == GlobalConstants.L5_level){
			srw.l5 = territory.Name;
			srw.l4 = territory.ParentTerritory2.Name;
			srw.l3 = territory.ParentTerritory2.ParentTerritory2.Name;
			srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
		}else if(territory.Hierarchy_Level__c == GlobalConstants.L4_level){
			srw.l4 = territory.Name;
			srw.l3 = territory.ParentTerritory2.Name;
			srw.l2 = territory.ParentTerritory2.ParentTerritory2.Name;
		}
		else if(territory.Hierarchy_Level__c == GlobalConstants.L3_level){
			srw.l3 = territory.Name;
			srw.l2 = territory.ParentTerritory2.Name;
		}
		else if(territory.Hierarchy_Level__c == GlobalConstants.L2_level)
			srw.l2 = territory.Name;
		
		return srw;
	}  
	
	/*****************************************************************
	*Method Name: SalesRoleWrapper
	*Parameter: SalesRoleWrapper
	*Description: To merge two lists and return data for output table
	*******************************************************************/
	public class SalesRoleWrapper implements Comparable{
		@AuraEnabled public string Organisation {get;set;}
		@AuraEnabled public String BG {get;set;}
		@AuraEnabled public String Rolename {get;set;}
		@AuraEnabled public string usersearch {get;set;}
		@AuraEnabled public User usercheck {get;set;}
		@AuraEnabled public Sales_Role__c SalesRoleObj {get;set;}
		@AuraEnabled public NF_RoleCode__c IWAFlag {get;set;}

		
		@AuraEnabled public String l2 {get;set;}
		@AuraEnabled public String l3 {get;set;}
		@AuraEnabled public String l4 {get;set;}
		@AuraEnabled public String l5 {get;set;}
		@AuraEnabled public String l6 {get;set;}
		@AuraEnabled public String l7 {get;set;}
		
		public SalesRoleWrapper(Sales_Role__c sr){
			this.SalesRoleObj = sr;
			
			this.l2 = '';
			this.l3 = '';
		}
		public SalesRoleWrapper(SalesRoleWrapper sr){
			this.SalesRoleObj = sr.SalesRoleObj;
			
			this.l2 = sr.l2;
			this.l3 = sr.l3;
			this.l4 = sr.l4;
			this.l5 = sr.l5;
			this.l6 = sr.l6;
			this.l7 = sr.l7;			
		}
		public SalesRoleWrapper(){
			
			this.l2 = '';
			this.l3 = '';
			this.l4 = '';
			this.l5 = '';
			this.l6 = '';
			this.l7 = '';
		}
		public Integer compareTo(Object obj)
		{
			SalesRoleWrapper wrapper = (SalesRoleWrapper)obj;
	 // system.debug('obj'+wrapper);
			if(!string.isEmpty(wrapper.L2) || !string.isEmpty(this.l2))
			{
	Integer l2res = l2.compareTo(wrapper.l2);
	if(l2res == 0 && (!string.isEmpty(wrapper.L3) || !string.isEmpty(this.l3)))
	{
		Integer l3res = l3.compareTo(wrapper.l3);
		if(l3res == 0 && (!string.isEmpty(wrapper.L4) || !string.isEmpty(this.l4)))
		{
			Integer l4res = l4.compareTo(wrapper.l4);
			if(l4res == 0 && (!string.isEmpty(wrapper.L5) || !string.isEmpty(this.l5)))
			{
				Integer l5res = l5.compareTo(wrapper.l5);
				if(l5res == 0 && (!string.isEmpty(wrapper.L6) || !string.isEmpty(this.l6)))
				{
		Integer l6res = l6.compareTo(wrapper.l6);
		if(l6res == 0 && (!string.isEmpty(wrapper.L7) || !string.isEmpty(this.l7)))
			return l7.compareTo(wrapper.l7);
		else return l6res;
				}
				else return l5res;
			}
			else return l4res;
		}
		else return l3res;
	}
	else return l2res;
			}
			else return null; 
		}
	}
	
	/**********************************************************************************
	*Method Name: getPermissionset
	*Parameter: PermissionSetAssignment
	*Description: To check whether SRT edit permission set is assigned to user or not
	***********************************************************************************/
	@AuraEnabled
	public static Boolean getPermissionset(){
		String userId = UserInfo.getUserId();
		Map<Id,PermissionSetAssignment> ps_map = new Map<Id,PermissionSetAssignment>();
		Boolean ps_Check = true;
		string NF_SRT_Management=Label.NF_SRT_Management;
		
		try{
			for(PermissionSetAssignment psa : [SELECT AssigneeId,Id,PermissionSetId,PermissionSet.Name,Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name =: NF_SRT_Management])
			{
	ps_map.put(psa.AssigneeId, psa);
			}
			
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Global_Process_Admin_Profile_Id) && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.System_Administrator_Profile_Id))
			{
	if(ps_map.containsKey(userId))
	{
		return ps_Check;
	}
	else
	{
		ps_Check = false;
		return ps_Check;
	}
			}
			else
	return ps_Check;
		}
		catch(Exception e)
		{   
			System.debug('Exception::> '+e);
			return ps_Check;
		}
	}
	
	@AuraEnabled
	public static void runBatchForAssignments()
	{
		PSRORecalculateAssignmentsBatch psroBatch = new PSRORecalculateAssignmentsBatch();
		Database.executeBatch(psroBatch,1000);
	}
	/**********************************************************************************
	*Method Name: salesrolePagerWrapper
	*Parameter: 
	*Description: 
	***********************************************************************************/
	public class salesrolePagerWrapper {
		@AuraEnabled public Integer pageSize {get;set;}
		@AuraEnabled public Integer page {get;set;}
		@AuraEnabled public string LeastLevel {get;set;}
		@AuraEnabled public   map<string,Territory2> Salesrolemap {get;set;}
		@AuraEnabled public Integer total {get;set;}
		@AuraEnabled public List<SalesRoleWrapper> SalesRolewrapperlist {get;set;}
		@AuraEnabled public List<SalesRoleWrapper> wrapper_list {get;set;}
		
		@AuraEnabled public boolean l2 {get;set;}
		@AuraEnabled public boolean l3 {get;set;}
		@AuraEnabled public boolean l4 {get;set;}
		@AuraEnabled public boolean l5 {get;set;}
		@AuraEnabled public boolean l6 {get;set;}
		@AuraEnabled public boolean l7 {get;set;}
	}
}