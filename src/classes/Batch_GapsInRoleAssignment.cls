/****************************************
* Name : Batch_GapsInRoleAssignment
* Author : Accenture
* Description : Sales Process Req# 3675: Batch Job to detect gaps in IWA role assignments 
****************************************/
global without sharing class Batch_GapsInRoleAssignment implements Database.Batchable<sObject>,Database.Stateful,Schedulable 
{  
	Private  static String Co_AMERICA = system.Label.NF_Co_America;
	
	Private  static String Markt_North_America = system.Label.NF_Co_America_North_America;
	Private  static String Markt_Latin_America = system.Label.NF_Co_America_Latin_America;
	Private  static String Markt_Asia_Pacf_Jap = system.Label.NF_Market_Asia_Pacific_Japan;
	Private  static String Markt_Europe = system.Label.NF_Market_Europe;
	Private  static String Markt_Greater_China = system.Label.NF_Market_Greater_China;
	Private  static String Markt_India = system.Label.NF_Market_India;
	Private  static String Markt_Middle_East_Africa = system.Label.NF_Market_Middle_East_and_Africa;
	Private  static String Markt_NFS = system.Label.NF_Market_NFS;
	
	
	Private  static String CO_EME_APAC   = system.Label.NF_CO_EMEA_APAC;
	Private  static String NOKIA_ENT   = system.Label.NF_Nokia_Enterprise;
	Public static String Const_Market = 'Market';
	Public static String Const_GCHN   = ' Greater China';
	Public static String Const_NAM  = ' North America';

	Public  static String SPACE_NSA   = ' NSA';
	Public  static String RC_NSB   = 'NSB';
	Public  static String GLOBAL_ORG   = 'Global';
	Public  static String ALL_ORG   = 'All';
	Public  static String CUSTOM_SET_IWA   = 'IWA Rolecodes';
	Private  static String ALL_CSV   = 'All Csv';
	Private  static String CSET_FILENAME   = 'Missing Rolecodes in Custom Setting' ;
	
	Private  static String STAKEHOLDER   = 'Stakeholder' ;
	Private  static String TIMEFORMAT   = 'yyyy-MMM-dd-hh-mm-ss' ;
	Private  static string NoGap_Countries =' ';
	Private String Csv_Csettingheader = 'Missing Rolecodes';
	
	//Changed Below during AP2021
	//Private String Csv_header = 'Rule Assignee ID,Rule Assignee,Role Code,Role Description,BG Attribute,Organisation Level 3,Organisation Level 4,Organisation Level 5,Organisation level 6,Organisation Level 7,Assignee Value,Assignee Type';
	Private String Csv_header = 'Rule Assignee ID,Rule Assignee,Role Code,Role Description,BG Attribute,Organisation Level 4,Organisation Level 5,Organisation level 6,Organisation Level 7,Assignee Value,Assignee Type';
	
	Public  Integer countofquery   = 0;
	Public  Integer Totalforloop   = 0;
	
	Private static List<Messaging.Emailfileattachment> fileAttachments  = new   List<Messaging.Emailfileattachment>();
	public String Csv_C_Setting = Csv_Csettingheader;
	public String Csv_Global_APPROVERS = csv_header+',NSA_Territory';
	Public String Csv_Co_AMERICA_APPROVERS  = csv_header;
	
	Public String Csv_MARKT_NORTH_AMERICA_APPROVERS  = csv_header;
	Public String Csv_MARKT_LATIN_AMERICA_APPROVERS  = csv_header;
	Public String Csv_MARKT_ASIA_PACF_JAP_APPROVERS  = csv_header;
	Public String Csv_MARKT_EUROPE_APPROVERS  = csv_header;
	Public String Csv_MARKT_GREATER_CHINA_APPROVERS  = csv_header;
	Public String Csv_MARKT_INDIA_APPROVERS  = csv_header;
	Public String Csv_MARKT_MIDDLE_EAST_AFRICA_APPROVERS  = csv_header;
	Public String Csv_MARKT_NFS_APPROVERS  = csv_header;
	
	
	Public String Csv_CO_EME_APAC_APPROVERS = csv_header;
	Public String Csv_NOKIA_ENT_APPROVERS   = csv_header+',NSA_Territory';
	public String Csv_Global_OTRS='';
	Public String Csv_Co_AMERICA_OTRS='' ;
	
	Public String Csv_MARKT_NORTH_AMERICA_OTRS='' ;
	Public String Csv_MARKT_LATIN_AMERICA_OTRS='' ;
	Public String Csv_MARKT_ASIA_PACF_JAP_OTRS='' ;
	Public String Csv_MARKT_EUROPE_OTRS='' ;
	Public String Csv_MARKT_GREATER_CHINA_OTRS='' ;
	Public String Csv_MARKT_INDIA_OTRS='' ;
	Public String Csv_MARKT_MIDDLE_EAST_AFRICA_OTRS='' ;
	Public String Csv_MARKT_NFS_OTRS='' ;
			 
	Public String Csv_CO_EME_APAC_OTRS='';
	Public String Csv_NOKIA_ENT_OTRS='';
  
	
	public  Map<string, string> RC_Namemap=new Map<string, string>();
	public  Map<string, string> RC_BGmap=new Map<string, string>();
	public  Map<string, list<string>> RC_Levelmap=new Map<string, list<string>>();
	public  Map<string, list<string>> RC_Codemap=new Map<string, list<string>>();
	
	public  map<Id,string> Ar_Assignee_val_map=new map<Id,string>();   
	public  map<Id,string> AssigneeID_Bgmap=new map<Id,string>();
	public  set<Id> AR_AssigneeIDset=new set<Id>();
	public  set<String> L3set = new set<string>();
	public static  Map<String,list<string>> ORGCSV_L3map = new  Map<String,list<string>>();
	public static  Map<String,string> ORGCSV_map_NSA = new Map<String,string>();

	/********************
*Method Name:sendEmail 
*Parameter:sendEmail
*******************/
	public void send_mail(string file_csv,string country,string usermail)
	{   
		Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();  
		Messaging.EmailFileAttachment csv_Attach = new Messaging.EmailFileAttachment();
		string csvname='';
		string[] userID= usermail.split(',');
		
		If(!country.Contains(CUSTOM_SET_IWA))
			csvname= Label.Environment + '_' + country + '_' + Label.NF_Filename_Backup_Admin + '_'+ System.now().format(TIMEFORMAT)+'.csv';
		else
			csvname= Label.Environment + '_' + country + '_' +CSET_FILENAME+ '_'+ System.now().format(TIMEFORMAT)+'.csv';
		
		if((file_csv == csv_header||file_csv==csv_header+',NSA_Territory')&&!country.Contains(CUSTOM_SET_IWA)&&!country.Contains(ALL_ORG))
		{	
			email.setPlainTextBody(Label.NF_Batch_No_Gaps);
			NoGap_Countries=NoGap_Countries+country+'/';
		}
		if((file_csv == csv_header || file_csv==csv_header+',NSA_Territory')&&country.Contains(CUSTOM_SET_IWA))
			email.setPlainTextBody(Label.NF_Batch_No_Gaps); 
		
		if(file_csv != csv_header&&file_csv!=csv_header+',NSA_Territory'&&!country.Contains(ALL_ORG)){
			blob csvBlob = Blob.valueOf(file_csv);
			csv_Attach.setFileName(csvname);
			csv_Attach.setBody(csvBlob);
			if(csv_Attach!=null){
	fileAttachments.add(csv_Attach);
	email.setFileAttachments(new Messaging.EmailFileAttachment[]{csv_Attach});
	email.setPlainTextBody(Label.NF_Filename_Backup_Admin);
			}
		}
		
		if(country.Contains(ALL_ORG))
		{
			string body ='';
			If(NoGap_Countries!= ' ')
	body += Label.NF_Batch_No_Gaps+ ' in '+NoGap_Countries.removeEnd('/')+' level.';
			else
	body = Label.NF_Filename_Backup_Admin;
			email.setHtmlBody(body);
			email.setFileAttachments(fileAttachments);
		}
		If(!country.Contains(CUSTOM_SET_IWA)){
		email.setSubject(csvname);
		email.setToAddresses(userID);
		if(!Test.isRunningTest())
			Messaging.SendEmailResult[] result= Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
		}
	}
	/******************************
*Method Name: Query_OnetimeData
*Description: Query the Onetime Data for batch class
********************************/ 
	public  void Query_OnetimeData(){
		map<string,Apttus_Approval__ApprovalRuleAssignee__c> Ar_Assigneemap=new map<string,Apttus_Approval__ApprovalRuleAssignee__c>();   
		set<Apttus_Approval__ApprovalRuleAssignee__c> Ar_Assignees=new set<Apttus_Approval__ApprovalRuleAssignee__c>();
		set<string> incodeset=new set<string>();
		set<string> Added_codeset=new set<string>();
		set<String> Avalue = new set<String>();
		map<Id,boolean> AllorNull=new map<Id,boolean>(); 
		
		//Commented during AP2021
		/*L3set.add(Co_AMERICA);
		L3set.add(CO_EME_APAC);  
		L3set.add(NOKIA_ENT);
		L3set.add(NOKIA_ENT+SPACE_NSA);*/
		
		//Added during AP2021
		L3set.add(Markt_North_America);
		L3set.add(Markt_Latin_America);
		L3set.add(Markt_Asia_Pacf_Jap);
		L3set.add(Markt_Europe);
		L3set.add(Markt_Greater_China);
		L3set.add(Markt_India);
		L3set.add(Markt_Middle_East_Africa);
		L3set.add(Markt_NFS);
		
		for(NF_Rolecode__c RCode:NF_Rolecode__c.getall().values())
		{
			if(RCode.A_S__c)
			{	
	string code = RCode.Name.subString(4,RCode.Name.length()); 
	
	If(!RC_Levelmap.containskey(code))
		RC_Levelmap.put(code, new list<string>{RCode.Hierarchy_Level__c});
	else
		RC_Levelmap.get(code).add(RCode.Hierarchy_Level__c);
	
	If(!RC_Codemap.containskey(code))
		RC_Codemap.put(code, new list<string>{RCode.Name});
	else
		RC_Codemap.get(code).add(RCode.Name);
	
	if(!RC_BGmap.containsKey(code))
		RC_BGmap.put(code,RCode.BG_Attribute__c);
	
	if(!RC_Namemap.containskey(code))
		RC_Namemap.put(code,RCode.Role_name__c);
			}
		}
		
		//get Approval rule assignees
		for(Apttus_Approval__ApprovalRuleAssignee__c AR_Assignee :[Select Id,Name,Apttus_Approval__AssigneeType__c,Apttus_Approval__AssigneeValue__c,Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where Apttus_Approval__AssigneeType__c = 'Custom User' and
				   Apttus_Approval__RuleEntryId__r.Apttus_Approval__ApprovalRuleId__r.Apttus_Approval__Active__c = true AND Apttus_Approval__AssigneeValue__c != null 
				   Order by Apttus_Approval__AssigneeDescription__c])
		{
			List<String> codList = new List<String>();
			List<String> BG_List = new List<String>(); 
			string BGVal=' ';
			string code=' ';
			
			if(AR_Assignee.Apttus_Approval__AssigneeValue__c.contains('AND')){
	codList = AR_Assignee.Apttus_Approval__AssigneeValue__c.split('AND');
	If(codlist.size()==4)
		if(codList[3].contains('OR'))
		BG_list=codList[3].split('OR');
			}
			
			if(!codList.isEmpty())
	code = codList[0].subString(codList[0].lastIndexOf('%')+2, codList[0].length()-2).remove(' ');
			
			incodeset.add(code);
			Ar_Assignee_val_map.put(AR_Assignee.Id,code);
			
			if(!BG_List.isEmpty()){ 
	AllorNull.put(AR_Assignee.Id,true);
	if(RC_BGmap.containskey(code))
		AssigneeID_Bgmap.put(AR_Assignee.Id,RC_BGmap.get(code));
			}
			else if(codList.size() == 4){
	AssigneeID_Bgmap.put(AR_Assignee.Id, codList[3].subString(codList[3].lastIndexOf('=')+2,codList[3].IndexOf(')')-1));
			}
			else{
	AllorNull.put(AR_Assignee.Id,true);
	AssigneeID_Bgmap.put(AR_Assignee.Id,'');
	
			}
			
			
			if(AR_Assignee.Apttus_Approval__AssigneeDescription__c.Contains(GlobalConstants.APPROVER) )
	Ar_Assigneemap.put(AR_Assignee.Apttus_Approval__AssigneeValue__c,AR_Assignee);
			
			if(!AR_Assignee.Apttus_Approval__AssigneeDescription__c.Contains(GlobalConstants.APPROVER) )
	if(!Ar_Assigneemap.containsKey(AR_Assignee.Apttus_Approval__AssigneeValue__c))
	Ar_Assigneemap.put(AR_Assignee.Apttus_Approval__AssigneeValue__c,AR_Assignee);
		}
		
		
		for(Apttus_Approval__ApprovalRuleAssignee__c AR_Assigneeval :Ar_Assigneemap.Values())
		{
			string code=Ar_Assignee_val_map.get(AR_Assigneeval.Id);
			if(!Added_codeset.contains(code)&&AllorNull.containsKey(AR_Assigneeval.Id)&&AllorNull.get(AR_Assigneeval.Id)) { 
	AR_AssigneeIDset.Add(AR_Assigneeval.Id);
	Added_codeset.add(code);
			}
		}
		
		for(Apttus_Approval__ApprovalRuleAssignee__c AR_Assigneeval :Ar_Assigneemap.Values())
		{
			string code=Ar_Assignee_val_map.get(AR_Assigneeval.Id);
			if(!Added_codeset.contains(code)&&incodeset.contains(code)&&!Avalue.contains(AR_Assigneeval.Apttus_Approval__AssigneeValue__c)) { 
	AR_AssigneeIDset.Add(AR_Assigneeval.Id);
	Avalue.add(AR_Assigneeval.Apttus_Approval__AssigneeValue__c);
			}
		}
		
		
		Ar_Assigneemap.clear();
		Avalue.clear();
		Ar_Assignees.clear();
		incodeset.clear();
		Added_codeset.clear();
		
	}
	
	/******************************
*Method Name: Createorgcsv
*Description: Createcsv for batch class
********************************/ 
	public  map<string,string> Createorgcsv(set<territory2> Orgset,string BG)
	{
		Map<String,string> ORGCSV_BGmap = new Map<String,string>();
		for(Territory2 Orgter:Orgset){
	
			string orG_Csv='';
			
	//Commented during AP2021  
			/*string L3='';
	if(Orgter.Hierarchy_Level__c==GlobalConstants.L7_level){
	orG_Csv =Orgter.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA);
	L3=Orgter.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
			}  
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L6_level) {
	orG_Csv =Orgter.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+' ';
	L3=Orgter.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
			}
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L5_level) {
	orG_Csv =Orgter.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+' '+','+'  ';
	L3=Orgter.ParentTerritory2.ParentTerritory2.Name;
	
			}
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L4_level){
	orG_Csv =Orgter.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+'  '+','+'  '+','+'  ';
	L3=Orgter.ParentTerritory2.Name;
			}
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L3_level){
	orG_Csv =Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+'  '+','+'  '+','+'  '+','+'  ';
	L3=Orgter.Name;
			}
			
	
			
			If(!ORGCSV_L3map.containskey(L3))
	ORGCSV_L3map.put(L3, new list<string>{orG_Csv});
			else
	ORGCSV_L3map.get(L3).add(orG_Csv);*/
			
			//Added during AP2021
			
			string L4='';
	 
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L7_level) {
	orG_Csv =Orgter.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA);
	L4=Orgter.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
			}
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L6_level) {
	orG_Csv =Orgter.ParentTerritory2.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+' ';
	L4=Orgter.ParentTerritory2.ParentTerritory2.Name;
	
			}
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L5_level){
	orG_Csv =Orgter.ParentTerritory2.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+'  '+','+'  ';
	L4=Orgter.ParentTerritory2.Name;
			}
			if(Orgter.Hierarchy_Level__c==GlobalConstants.L4_level){
	orG_Csv =Orgter.Name.replaceall(',',' ').Remove(SPACE_NSA)+','+'  '+','+'  '+','+'  ';
	L4=Orgter.Name;
			}
			
	
			
			If(!ORGCSV_L3map.containskey(L4))
	ORGCSV_L3map.put(L4, new list<string>{orG_Csv});
			else
	ORGCSV_L3map.get(L4).add(orG_Csv);
	
			if(!Orgter.NSA_Territory__c){ 
			ORGCSV_BGmap.put(orG_Csv,BG);
	}
			if(Orgter.NSA_Territory__c){
	If(ORGCSV_map_NSA.containskey(orG_Csv)){
		  string S_BG=ORGCSV_map_NSA.get(orG_Csv);
		S_BG =S_BG+'/'+BG;
		ORGCSV_map_NSA.put(orG_Csv, S_BG);
	}
	else
	   ORGCSV_map_NSA.put(orG_Csv, BG);
			}
		}

		return ORGCSV_BGmap;
		
	}
	/********************
*Method Name:check_gaps 
*Description:It is used to find Gaps
*******************/
	public  Set<Territory2> check_gaps(list<Sales_Role__c> SR_List,set<territory2> CurrentOrgSet,string BG,string Leastlevel,list<string> Levellist)
	{
		Set<Territory2> F_Gapsset =new Set<Territory2>();
		Set<Territory2> S_Gapsset =new Set<Territory2>();
		Set<Territory2> T_Gapsset =new Set<Territory2>();
		set<string> levelset=new  set<string>();
		Set<string> CurrentsalesOrgSet =new Set<string>();
		Set<string> CurrentsalesOrgSet_NSA =new Set<string>();
		
		try{
			for(Sales_Role__c SalesRole:SR_List) 
			{   
	Totalforloop=Totalforloop+1;
	if((BG!=''&&SalesRole.BG__c==BG)||(BG==''&&SalesRole.BG__c==null)){
		CurrentsalesOrgSet.add(SalesRole.Organisation__c);  
		If(SalesRole.NSA__c)
		CurrentsalesOrgSet_NSA.add(SalesRole.Organisation__c);  
	}
			}
			for(Territory2 T2Obj:CurrentOrgSet){
	Totalforloop=Totalforloop+1;
	  
	if((!T2Obj.NSA_Territory__c&&!(CurrentsalesOrgSet.contains(T2Obj.Name)||CurrentsalesOrgSet.contains(T2Obj.ParentTerritory2.Name)||CurrentsalesOrgSet.contains(T2Obj.ParentTerritory2.ParentTerritory2.Name)||CurrentsalesOrgSet.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name)||CurrentsalesOrgSet.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name)))||
	   (((T2Obj.NSA_Territory__c)&&!(CurrentsalesOrgSet_NSA.contains(T2Obj.Name.Remove(SPACE_NSA))||CurrentsalesOrgSet_NSA.contains(T2Obj.ParentTerritory2.Name.Remove(SPACE_NSA))||CurrentsalesOrgSet_NSA.contains(T2Obj.ParentTerritory2.ParentTerritory2.Name.Remove(SPACE_NSA))||CurrentsalesOrgSet_NSA.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name.Remove(SPACE_NSA))||CurrentsalesOrgSet_NSA.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name.Remove(SPACE_NSA))))))
	{
		if(Levellist.contains(T2Obj.Hierarchy_Level__c))F_Gapsset.add(T2Obj);
		if(Levellist.contains(T2Obj.ParentTerritory2.Hierarchy_Level__c)) F_Gapsset.add(T2Obj.ParentTerritory2);
		if(Levellist.contains(T2Obj.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)) F_Gapsset.add(T2Obj.ParentTerritory2.ParentTerritory2);
		if(Levellist.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)) F_Gapsset.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2);
		if(Levellist.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)) F_Gapsset.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2);
	}
	else{
		if(Levellist.contains(T2Obj.Hierarchy_Level__c))S_Gapsset.add(T2Obj);
		if(Levellist.contains(T2Obj.ParentTerritory2.Hierarchy_Level__c)) S_Gapsset.add(T2Obj.ParentTerritory2);
		if(Levellist.contains(T2Obj.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)) S_Gapsset.add(T2Obj.ParentTerritory2.ParentTerritory2);
		if(Levellist.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)) S_Gapsset.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2);
		if(Levellist.contains(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c)) S_Gapsset.add(T2Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2);
	}
	  
			} 
			CurrentsalesOrgSet.clear();  
			
			for(Territory2 org:F_Gapsset){
	Totalforloop=Totalforloop+1;
	if(!S_Gapsset.contains(org)){
		T_Gapsset.add(org);
		if(org.Hierarchy_Level__c!=Leastlevel)levelset.add(org.Name);
	}  
			}
			F_Gapsset.clear();
			S_Gapsset.clear();
		 
			for(TErritory2 terr:T_Gapsset){
	Totalforloop=Totalforloop+1;
	if(terr.Hierarchy_Level__c==Leastlevel)
	{
		if((Leastlevel==GlobalConstants.L7_level)&&levelset.contains(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.name))F_Gapsset.add(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2);
		else if((Leastlevel==GlobalConstants.L7_level || Leastlevel==GlobalConstants.L6_level )&&levelset.contains(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.name))F_Gapsset.add(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2);
		else if((Leastlevel==GlobalConstants.L7_level || Leastlevel==GlobalConstants.L6_level || Leastlevel==GlobalConstants.L5_level)&&levelset.contains(terr.ParentTerritory2.ParentTerritory2.name))F_Gapsset.add(terr.ParentTerritory2.ParentTerritory2);
		else if((Leastlevel==GlobalConstants.L7_level || Leastlevel==GlobalConstants.L6_level || Leastlevel==GlobalConstants.L5_level || Leastlevel==GlobalConstants.L4_level)&&levelset.contains(terr.ParentTerritory2.name))F_Gapsset.add(terr.ParentTerritory2);
		else
			F_Gapsset.add(terr);  
	}
			}
		}
		
		catch(Exception Ex){
			system.debug('###Exception in checkgaps-->'+Ex.getMessage());
		}
		
		return F_Gapsset;
	}
	/********************
*Method Name:execute 
*Parameter:SchedulableContext SC
*Description:Execute the bacth 
*******************/
	
	global void execute(SchedulableContext SC)
	{
		Batch_GapsInRoleAssignment  batch= new Batch_GapsInRoleAssignment();
		Database.executebatch(batch,1);		
	} 
	/****************************************
* Name : start
* Author : Accenture
* Description : this method will contain the SOQL query for the batch 
*****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{  
		if(countofquery==0)Query_OnetimeData();
		
		return Database.getQueryLocator([Select Id,Name,Apttus_Approval__AssigneeType__c,Apttus_Approval__AssigneeValue__c,Apttus_Approval__AssigneeDescription__c from Apttus_Approval__ApprovalRuleAssignee__c where ID IN :AR_AssigneeIDset AND Apttus_Approval__AssigneeType__c = 'Custom User' and
				 Apttus_Approval__RuleEntryId__r.Apttus_Approval__ApprovalRuleId__r.Apttus_Approval__Active__c = true  AND Apttus_Approval__AssigneeValue__c != null 
				 Order by Apttus_Approval__AssigneeDescription__c  ]);
		
		
	} 
	/****************************************
* Name : execute
* Author : Accenture
* Description : Execution of the batch
*****************************************/
	global void execute(Database.BatchableContext BC, List<Apttus_Approval__ApprovalRuleAssignee__c> Ar_Assignee)
	{ 
		
		countofquery=countofquery+1;
		
		if(Ar_Assignee<>null&&Ar_Assignee.size()==1){
			
			String code='';
			String BG_Val ='';
			string  assignee_desc=' ';
			String MissingBG ='';
			String MissingBG_NSA ='';
			integer Final_Dec=0;
			integer count = 0;
			list<string> Level_list = new list<string>();
			list<string> L2Name_List = new list<string>();
			list<string> CSRl_Codes =new  list<string>();
			Set<Territory2> CurrentOrgSet =new Set<Territory2>();
			list<string> SplitBG =new  list<string>();
			
			
			Apttus_Approval__ApprovalRuleAssignee__c Cur_AR_Assignee=Ar_Assignee[0];
			
			if(Cur_AR_Assignee.Apttus_Approval__AssigneeDescription__c != null) 
			{
	Cur_AR_Assignee.Apttus_Approval__AssigneeDescription__c = Cur_AR_Assignee.Apttus_Approval__AssigneeDescription__c.replaceall('\n','');
	assignee_desc = Cur_AR_Assignee.Apttus_Approval__AssigneeDescription__c.subString(Cur_AR_Assignee.Apttus_Approval__AssigneeDescription__c.lastIndexOf(',')+1, Cur_AR_Assignee.Apttus_Approval__AssigneeDescription__c.length());
	if(assignee_desc.contains(GlobalConstants.VALIDATOR) || assignee_desc.contains(STAKEHOLDER))
		assignee_desc = GlobalConstants.VALIDATOR+'/'+STAKEHOLDER;
			}
			
			if(assignee_desc == null) assignee_desc = '';
			
			
			if(Ar_Assignee_val_map.containsKey(Cur_AR_Assignee.Id)){
	code=Ar_Assignee_val_map.get(Cur_AR_Assignee.Id);
	if(code!=''&&RC_BGmap.containsKey(code)){
		BG_Val = AssigneeID_Bgmap.get(Cur_AR_Assignee.Id);
		If(BG_Val==null)BG_Val='';

		if(code!=''&&RC_Codemap.containsKey(code))CSRl_Codes= RC_Codemap.get(code);
	   
		Level_list=RC_Levelmap.get(code);
		Level_list.sort();
		
		List<Sales_Role__C> List_SR = [Select Id,Organisation__c,Role_Code__c,Role_Name__c,BG__c,User__C,NSA__c from Sales_Role__C
			   where Active__c = true AND Role_Code__c IN :CSRl_Codes];
		
		if(!Level_list.contains(GlobalConstants.L2_level) ||Level_list.contains(GlobalConstants.L2_level)){ 
			
			String Least_level = Level_list[Level_list.size()-1];
			if(BG_Val !='')SplitBG=BG_Val.split(';');
			
			for(Territory2 T2_Obj : [Select Id, Name, Hierarchy_Level__c,
			 NSA_Territory__c,
			 ParentTerritory2.Name,
			 ParentTerritory2.NSA_Territory__c,
			 ParentTerritory2.Hierarchy_Level__c,
			 ParentTerritory2.ParentTerritory2.Name,
			 ParentTerritory2.ParentTerritory2.NSA_Territory__c,
			 ParentTerritory2.ParentTerritory2.Hierarchy_Level__c,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.NSA_Territory__c,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.NSA_Territory__c,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name ,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.NSA_Territory__c ,
			 ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Hierarchy_Level__c from Territory2  ])
			{
				if((GlobalConstants.L2_level==Least_level&&T2_Obj.ParentTerritory2.Hierarchy_Level__c == Least_level&&L3set.contains(T2_Obj.Name)) || (T2_Obj.Hierarchy_Level__c == Least_level&&(L3set.contains(T2_Obj.Name)|| L3set.contains(T2_Obj.ParentTerritory2.Name) || L3set.contains(T2_Obj.ParentTerritory2.ParentTerritory2.Name) || L3set.contains(T2_Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name)
													 || L3set.contains(T2_Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name)
													 ||L3set.contains(T2_Obj.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name)  )))
				{   
		Totalforloop=Totalforloop+1;
		if(Level_list.contains(GlobalConstants.L2_level))L2Name_List.add(T2_Obj.ParentTerritory2.Name.Remove(SPACE_NSA));
		if(!Level_list.contains(GlobalConstants.L2_level))CurrentOrgSet.add(T2_Obj);
				}
			}  
			
			if(!Level_list.contains(GlobalConstants.L2_level)){
				Map<String,string> ORGCSV_BGmap = new Map<String,string>();
				
				if(BG_Val==''){
		set <territory2>  Gapsset=check_gaps(List_SR,CurrentOrgSet,BG_Val,Least_level,Level_list);
		ORGCSV_BGmap= Createorgcsv(Gapsset,BG_Val);
				}
				if(BG_Val!='')
				{
		for(String BG:SplitBG)
		{
			set <territory2> Gapsset=check_gaps(List_SR,CurrentOrgSet,BG,Least_level,Level_list);
			map<string,string> CSV_BGmap= Createorgcsv(Gapsset,BG);
			for(string ORGCSV:CSV_BGmap.keyset())
			{ Totalforloop=Totalforloop+1;
				if(ORGCSV_BGmap.containskey(ORGCSV)) 
				{
					string S_BG=ORGCSV_BGmap.get(ORGCSV);
					S_BG =S_BG+'/'+BG;
					ORGCSV_BGmap.put(ORGCSV,S_BG);
				}
				else
					ORGCSV_BGmap.put(ORGCSV,CSV_BGmap.get(ORGCSV));   
			}
		}
				}
		 
				for(string L3:ORGCSV_L3map.keySet()){
		list <string> ORGCSV_listval=new list <string>();
		Boolean IS_NSA=false;
		list <string> ORGCSV_list=ORGCSV_L3map.get(L3); 
		if(L3!=null&&L3.contains(SPACE_NSA))IS_NSA=true;
		
		for(string orG_Csv:ORGCSV_list)
		{   
			Totalforloop=Totalforloop+1;
			string F_BG='';
			boolean NONnsaBG=false;
			 
			if(!IS_NSA ||(IS_NSA&&ORGCSV_BGmap.Containskey(orG_Csv))){
				if(!IS_NSA)
					F_BG=ORGCSV_BGmap.get(orG_Csv);
				
				if((IS_NSA&&ORGCSV_BGmap.Containskey(orG_Csv))){
				string F1_BG=ORGCSV_BGmap.get(orG_Csv);
					string NSABG='';
			if(ORGCSV_map_NSA.containsKey(orG_Csv))NSABG=ORGCSV_map_NSA.get(orG_Csv);
			 list<string> split_BGNSA=NSABG.split('/');
			 list<string> split_BG=F1_BG.split('/');
					for(string BGNSA:split_BGNSA)
					{
			 if(!split_BG.contains(BGNSA))
			  F_BG +=BGNSA+'/';
					}
					NONnsaBG=true;
			 F_BG=F_BG.removeEnd('/');
			}
					}
			 if(IS_NSA&&!NONnsaBG)F_BG=ORGCSV_map_NSA.get(orG_Csv);
			
			if((F_BG==''&&BG_val=='')||(F_BG!=''&&BG_val!='')){
			string Csv_record=Cur_AR_Assignee.Id+','+Cur_AR_Assignee.Name+','+code.replaceall('_','')+','+RC_Namemap.get(code)+','+F_BG+','+orG_Csv+','+Cur_AR_Assignee.Apttus_Approval__AssigneeValue__c+','+Assignee_desc ;
		   ORGCSV_listval.add(Csv_record);
			}
		}
		
		if( L3!='')L3=L3.Remove(SPACE_NSA);
		
		for(string Csv_record:ORGCSV_listval){
			 boolean Add=true;
			 /*********Exception Cases******/
		  // Support ticket 00010738  the role "NSB IB CBT Head" does not apply to Greater China ,Support ticket 00010225 the role "NSB IB CBT Head" does not apply to North America
			if(code.contains(RC_NSB)&&(Csv_record.contains(Const_Market+Const_GCHN)||Csv_record.contains(Const_Market+Const_NAM)))Add=false;
			
			/*********Exception Cases******/
		  
			if(Add){
		 if(Assignee_desc!= ''&&Assignee_desc.contains(GlobalConstants.APPROVER)){
			if(Co_AMERICA.equalsIgnoreCase(L3)&&!Csv_Co_AMERICA_APPROVERS.contains(Csv_record))Csv_Co_AMERICA_APPROVERS  =Csv_Co_AMERICA_APPROVERS+'\n'+Csv_record;
			
			if(Markt_North_America.equalsIgnoreCase(L3)&&!Csv_MARKT_NORTH_AMERICA_APPROVERS.contains(Csv_record))Csv_MARKT_NORTH_AMERICA_APPROVERS  =Csv_MARKT_NORTH_AMERICA_APPROVERS+'\n'+Csv_record;
			if(Markt_Latin_America.equalsIgnoreCase(L3)&&!Csv_MARKT_LATIN_AMERICA_APPROVERS.contains(Csv_record))Csv_MARKT_LATIN_AMERICA_APPROVERS  =Csv_MARKT_LATIN_AMERICA_APPROVERS+'\n'+Csv_record;
			if(Markt_Asia_Pacf_Jap.equalsIgnoreCase(L3)&&!Csv_MARKT_ASIA_PACF_JAP_APPROVERS.contains(Csv_record))Csv_MARKT_ASIA_PACF_JAP_APPROVERS  =Csv_MARKT_ASIA_PACF_JAP_APPROVERS+'\n'+Csv_record;
			if(Markt_Europe.equalsIgnoreCase(L3)&&!Csv_MARKT_EUROPE_APPROVERS.contains(Csv_record))Csv_MARKT_EUROPE_APPROVERS  =Csv_MARKT_EUROPE_APPROVERS+'\n'+Csv_record;
			if(Markt_Greater_China.equalsIgnoreCase(L3)&&!Csv_MARKT_GREATER_CHINA_APPROVERS.contains(Csv_record))Csv_MARKT_GREATER_CHINA_APPROVERS  =Csv_MARKT_GREATER_CHINA_APPROVERS+'\n'+Csv_record;
			if(Markt_India.equalsIgnoreCase(L3)&&!Csv_MARKT_INDIA_APPROVERS.contains(Csv_record))Csv_MARKT_INDIA_APPROVERS  =Csv_MARKT_INDIA_APPROVERS+'\n'+Csv_record;
			if(Markt_Middle_East_Africa.equalsIgnoreCase(L3)&&!Csv_MARKT_MIDDLE_EAST_AFRICA_APPROVERS.contains(Csv_record))Csv_MARKT_MIDDLE_EAST_AFRICA_APPROVERS  =Csv_MARKT_MIDDLE_EAST_AFRICA_APPROVERS+'\n'+Csv_record;
			if(Markt_NFS.equalsIgnoreCase(L3)&&!Csv_MARKT_NFS_APPROVERS.contains(Csv_record))Csv_MARKT_NFS_APPROVERS  =Csv_MARKT_NFS_APPROVERS+'\n'+Csv_record;
			
			if(CO_EME_APAC.equalsIgnoreCase(L3)&&!Csv_CO_EME_APAC_APPROVERS.contains(Csv_record))Csv_CO_EME_APAC_APPROVERS  =Csv_CO_EME_APAC_APPROVERS+'\n'+Csv_record;
			if(NOKIA_ENT.equalsIgnoreCase(L3)&&!Csv_NOKIA_ENT_APPROVERS.contains(Csv_record))Csv_NOKIA_ENT_APPROVERS  =Csv_NOKIA_ENT_APPROVERS+'\n'+Csv_record+','+IS_NSA;
		 }
		 
		if((Assignee_desc!= ''&&!Assignee_desc.contains(GlobalConstants.APPROVER))|| Assignee_desc==''){
			if(Co_AMERICA.equalsIgnoreCase(L3)&&(Csv_Co_AMERICA_OTRS==null|| (Csv_Co_AMERICA_OTRS!=null&&!Csv_Co_AMERICA_OTRS.contains(Csv_record))))Csv_Co_AMERICA_OTRS  =Csv_Co_AMERICA_OTRS+'\n'+Csv_record;
		 
			if(Markt_North_America.equalsIgnoreCase(L3)&&(Csv_MARKT_NORTH_AMERICA_OTRS==null|| (Csv_MARKT_NORTH_AMERICA_OTRS!=null&&!Csv_MARKT_NORTH_AMERICA_OTRS.contains(Csv_record))))Csv_MARKT_NORTH_AMERICA_OTRS  =Csv_MARKT_NORTH_AMERICA_OTRS+'\n'+Csv_record;
			if(Markt_Latin_America.equalsIgnoreCase(L3)&&(Csv_MARKT_LATIN_AMERICA_OTRS==null|| (Csv_MARKT_LATIN_AMERICA_OTRS!=null&&!Csv_MARKT_LATIN_AMERICA_OTRS.contains(Csv_record))))Csv_MARKT_LATIN_AMERICA_OTRS  =Csv_MARKT_LATIN_AMERICA_OTRS+'\n'+Csv_record;
			if(Markt_Asia_Pacf_Jap.equalsIgnoreCase(L3)&&(Csv_MARKT_ASIA_PACF_JAP_OTRS==null|| (Csv_MARKT_ASIA_PACF_JAP_OTRS!=null&&!Csv_MARKT_ASIA_PACF_JAP_OTRS.contains(Csv_record))))Csv_MARKT_ASIA_PACF_JAP_OTRS  =Csv_MARKT_ASIA_PACF_JAP_OTRS+'\n'+Csv_record;
			if(Markt_Europe.equalsIgnoreCase(L3)&&(Csv_MARKT_EUROPE_OTRS==null|| (Csv_MARKT_EUROPE_OTRS!=null&&!Csv_MARKT_EUROPE_OTRS.contains(Csv_record))))Csv_MARKT_EUROPE_OTRS  =Csv_MARKT_EUROPE_OTRS+'\n'+Csv_record;
			if(Markt_Greater_China.equalsIgnoreCase(L3)&&(Csv_MARKT_GREATER_CHINA_OTRS==null|| (Csv_MARKT_GREATER_CHINA_OTRS!=null&&!Csv_MARKT_GREATER_CHINA_OTRS.contains(Csv_record))))Csv_MARKT_GREATER_CHINA_OTRS  =Csv_MARKT_GREATER_CHINA_OTRS+'\n'+Csv_record;
			if(Markt_India.equalsIgnoreCase(L3)&&(Csv_MARKT_INDIA_OTRS==null|| (Csv_MARKT_INDIA_OTRS!=null&&!Csv_MARKT_INDIA_OTRS.contains(Csv_record))))Csv_MARKT_INDIA_OTRS  =Csv_MARKT_INDIA_OTRS+'\n'+Csv_record;
			if(Markt_Middle_East_Africa.equalsIgnoreCase(L3)&&(Csv_MARKT_MIDDLE_EAST_AFRICA_OTRS==null|| (Csv_MARKT_MIDDLE_EAST_AFRICA_OTRS!=null&&!Csv_MARKT_MIDDLE_EAST_AFRICA_OTRS.contains(Csv_record))))Csv_MARKT_MIDDLE_EAST_AFRICA_OTRS  =Csv_MARKT_MIDDLE_EAST_AFRICA_OTRS+'\n'+Csv_record;
			if(Markt_NFS.equalsIgnoreCase(L3)&&(Csv_MARKT_NFS_OTRS==null|| (Csv_MARKT_NFS_OTRS!=null&&!Csv_MARKT_NFS_OTRS.contains(Csv_record))))Csv_MARKT_NFS_OTRS  =Csv_MARKT_NFS_OTRS+'\n'+Csv_record;
					
			if(CO_EME_APAC.equalsIgnoreCase(L3)&&(Csv_CO_EME_APAC_OTRS==null||(Csv_CO_EME_APAC_OTRS!=null&&!Csv_CO_EME_APAC_OTRS.contains(Csv_record))))Csv_CO_EME_APAC_OTRS  =Csv_CO_EME_APAC_OTRS+'\n'+Csv_record;
			if(NOKIA_ENT.equalsIgnoreCase(L3)&&(Csv_NOKIA_ENT_OTRS==null||(Csv_NOKIA_ENT_OTRS!=null&&!Csv_NOKIA_ENT_OTRS.contains(Csv_record))))Csv_NOKIA_ENT_OTRS  =Csv_NOKIA_ENT_OTRS+'\n'+Csv_record+','+IS_NSA;
		}
		 }
		}
		}
				
				
				ORGCSV_L3map.clear();
				ORGCSV_BGmap.clear();
			}
			if(Level_list.contains(GlobalConstants.L2_level)){
				
				set<string> SplitBGSet =new  set<string>();
				set<string> SplitBGSet_NSA =new  set<string>();
				set<Sales_Role__c> SAlesroleset =new  set<Sales_Role__c>();
				Boolean NOTAvailableNSA=false;
				if(!SplitBG.isempty()&&SplitBG.size()>1)SplitBGSet.addAll(SplitBG);SplitBGSet_NSA.addAll(SplitBG);
				
				for(Sales_Role__c SRObj:List_SR)
				{   
		Totalforloop=Totalforloop+1;
		if((CSRl_Codes.Contains(SRObj.Role_Code__c)&&L2Name_List.Contains(SRObj.Organisation__c)&&((BG_Val != '' && SRObj.BG__c != null&&!SplitBG.isempty()&&SplitBG.contains(SRObj.BG__c))||(BG_Val == '' && SRObj.BG__c == null))))
		{   
			if((BG_Val != ''&&!SplitBG.isempty()&&SplitBG.size()>1 &&SplitBG.contains(SRObj.BG__c))){
				 if(!SRObj.NSA__c)SplitBGSet.Remove(SRObj.BG__c);
				if(SRObj.NSA__c)SplitBGSet_NSA.Remove(SRObj.BG__c);
			}
			
			if((BG_Val =='' && SRObj.BG__C == null) || SplitBG.size()==1)
			{
				if(SRObj.NSA__c)count = count + 1;
				if(!SRObj.NSA__c)NOTAvailableNSA=true;
			}
		}
				}
				if(!SplitBGSet_NSA.isEmpty() ||((BG_Val ==''||SplitBG.size()==1)&&(count==0 || NOTAvailableNSA )))
				{
		Final_Dec=Final_Dec+1;
		if((BG_Val ==''||SplitBG.size()==1))MissingBG=BG_Val;
		if(!SplitBGSet_NSA.isEmpty())
		{
			for(string BG:SplitBGSet_NSA){
				if(!SplitBGSet.isEmpty()&&SplitBGSet.contains(BG)) 
				MissingBG +=BG+'/';
				else
			MissingBG_NSA +=BG+'/';   
			}
			 }
			MissingBG=MissingBG.removeEnd('/');
			MissingBG_NSA=MissingBG_NSA.removeEnd('/');
		  
		
				} 
				if(Final_Dec!=0){
		string Csv_record_NSA;
		 string Csv_record;
		if((BG_val==''&&MissingBG=='') ||(BG_val!=''&&MissingBG!=''))
		 Csv_record=Cur_AR_Assignee.Id+','+Cur_AR_Assignee.Name+','+code.removeStart('_')+','+RC_Namemap.get(code)+','+MissingBG+','+' '+','+' '+','+' '+','+' '+','+' '+','+Cur_AR_Assignee.Apttus_Approval__AssigneeValue__c+','+Assignee_desc+','+NOTAvailableNSA;
		if(MissingBG_NSA!=''){		
		   if((BG_val==''&&MissingBG_NSA=='') ||(BG_val!=''&&MissingBG_NSA!=''))
		   Csv_record_NSA=Cur_AR_Assignee.Id+','+Cur_AR_Assignee.Name+','+code.removeStart('_')+','+RC_Namemap.get(code)+','+MissingBG_NSA+','+' '+','+' '+','+' '+','+' '+','+' '+','+Cur_AR_Assignee.Apttus_Approval__AssigneeValue__c+','+Assignee_desc+','+true;
		}		 
		if(Assignee_desc!= ''&&Assignee_desc.contains(GlobalConstants.APPROVER)){
		   if(Csv_record!=null&&!Csv_Global_APPROVERS.contains(Csv_record))Csv_Global_APPROVERS=Csv_Global_APPROVERS+'\n'+Csv_record;  
		  if(Csv_record_NSA!=null&&!Csv_Global_APPROVERS.contains(Csv_record_NSA))Csv_Global_APPROVERS=Csv_Global_APPROVERS+'\n'+Csv_record_NSA;  

		}
		if((Assignee_desc!= ''&&!Assignee_desc.contains(GlobalConstants.APPROVER))|| Assignee_desc==''){
		   if((Csv_Global_OTRS==null||(Csv_Global_OTRS!=null&&Csv_record!=null&&!Csv_Global_OTRS.contains(Csv_record))))Csv_Global_OTRS=Csv_Global_OTRS+'\n'+Csv_record;  
			 if((Csv_Global_OTRS==null||(Csv_Global_OTRS!=null&&Csv_record_NSA!=null&&!Csv_Global_OTRS.contains(Csv_record_NSA))))Csv_Global_OTRS=Csv_Global_OTRS+'\n'+Csv_record_NSA;  

		}
		
				}		
				
			}
		}
	}
	
	if(code!=''&&!RC_Levelmap.containsKey(code)) 
	{
		if(!Csv_C_Setting.Contains(code.removeStart('_')))
			Csv_C_Setting=Csv_C_Setting+'\n'+code.removeStart('_');
	}
			}
		}
	}
	global void finish(Database.BatchableContext BC)
	{
		
	  //send_mail(Csv_Co_AMERICA_APPROVERS+Csv_Co_AMERICA_OTRS,Co_AMERICA, System.label.NF_Email_Gaps_Batch_Co_America); 
	  
	  //SF Ticket #01931380 - Swapping Custom Labels NF_Email_Gaps_Batch_North_America and NF_Email_Gaps_Batch_Latin_America below
	  send_mail(Csv_MARKT_NORTH_AMERICA_APPROVERS+Csv_MARKT_NORTH_AMERICA_OTRS,Markt_North_America, System.label.NF_Email_Gaps_Batch_North_America); 
	  send_mail(Csv_MARKT_LATIN_AMERICA_APPROVERS+Csv_MARKT_LATIN_AMERICA_OTRS,Markt_Latin_America, System.label.NF_Email_Gaps_Batch_Latin_America); 
	  
	  //SF Ticket #01931380- Replace sapna.suryavanshi@nokia.com with rahul.1.seth@nokia.com in below Custom Label
	  send_mail(Csv_MARKT_ASIA_PACF_JAP_APPROVERS+Csv_MARKT_ASIA_PACF_JAP_OTRS,Markt_Asia_Pacf_Jap, System.label.NF_Email_Gaps_Batch_Market_Asia_Pacific_Japan);
	  
	  send_mail(Csv_MARKT_EUROPE_APPROVERS+Csv_MARKT_EUROPE_OTRS,Markt_Europe, System.label.NF_Email_Gaps_Batch_Market_Europe); 
	  send_mail(Csv_MARKT_GREATER_CHINA_APPROVERS+Csv_MARKT_GREATER_CHINA_OTRS,Markt_Greater_China, System.label.NF_Email_Gaps_Batch_Market_Greater_China); 
	  send_mail(Csv_MARKT_INDIA_APPROVERS+Csv_MARKT_INDIA_OTRS,Markt_India, System.label.NF_Email_Gaps_Batch_Market_India); 
	  send_mail(Csv_MARKT_MIDDLE_EAST_AFRICA_APPROVERS+Csv_MARKT_MIDDLE_EAST_AFRICA_OTRS,Markt_Middle_East_Africa, System.label.NF_Email_Gaps_Batch_Market_Middle_East_and_Africa); 
	  send_mail(Csv_MARKT_NFS_APPROVERS+Csv_MARKT_NFS_OTRS,Markt_NFS, System.label.NF_Email_Gaps_Batch_Market_NFS); 
	  
	  /*send_mail(Csv_CO_EME_APAC_APPROVERS+Csv_CO_EME_APAC_OTRS,CO_EME_APAC, System.label.NF_Email_Gaps_Batch_CO_EMEA_APAC); 
	  send_mail(Csv_NOKIA_ENT_APPROVERS+Csv_NOKIA_ENT_OTRS,NOKIA_ENT, System.label.NF_Email_Gaps_Batch_Nokia_Enterprise);*/
	  
	  
	  send_mail(Csv_Global_APPROVERS+Csv_Global_OTRS,GLOBAL_ORG, System.label.NF_Email_Gaps_Batch_Global);
	  if(Csv_C_Setting !=Csv_Csettingheader)send_mail(Csv_C_Setting,CUSTOM_SET_IWA, System.label.NF_Email_Gaps_Batch_All);
	  send_mail(ALL_CSV,ALL_ORG, System.label.NF_Email_Gaps_Batch_All);
	
	 //system.debug('Totalforloop-->'+Totalforloop);

	}
}