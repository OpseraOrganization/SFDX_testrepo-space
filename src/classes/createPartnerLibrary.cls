public with sharing class createPartnerLibrary implements Queueable{ 
   set<ID> parAcc;   
	public createPartnerLibrary(Set<ID> parAcc){
		this.parAcc = parAcc;
	}
	  
	public void execute(QueueableContext context) 
	{
	
		List<ContentWorkspace> lib = new List<ContentWorkspace>();
		List<ContentWorkspace> libParentFolder = new List<ContentWorkspace>();
		List<ContentFolderLink> libFolderLink = new List<ContentFolderLink>();
		set<ID> libPFolderVAR = new set<ID>();
		set<ID> libPFolderDist = new set<ID>();
		set<ID> libPFolderSProvider = new set<ID>();
		set<ID> libPFolderIResller = new set<ID>();
		set<ID> libPFolderIndPartner = new set<ID>();
		set<ID> libPFolderAlPartner = new set<ID>();
		set<ID> libId = new set<ID>();
		map<String, String> accLibPartnerType = new map<String, String>();
   //		List<String> partnerttypeList = new List<String>();
		Map<String, PRM_LibraryAutoCreation_Partner_Type__c> customMap = PRM_LibraryAutoCreation_Partner_Type__c.getAll();
	system.debug('customMap'+customMap);
		// D-6383 fix - Started
		map<String, String> LibRootfolder = new map<String, String>();
		map<String, String> LibrId = new map<String, String>();
		// D-6383 fix - End	 
		
		if(!(parAcc.isempty())){
			List<Account> pAcc =[select id, name, country__c, Partner_Type__c from Account where id in: parAcc];	 
			for(Account acc : pAcc ){   
	if(customMap.containskey(acc.Partner_Type__c)){
		String LibName = acc.name + '-' + acc.country__c;
		ContentWorkspace partnerLib = new ContentWorkspace(name=LibName);
		lib.add(partnerLib);
		accLibPartnerType.put(LibName, acc.Partner_Type__c );
		}
		system.debug('Lib*******'+Lib);
		database.insert(Lib);
			}
		
	
		}
		system.debug('Lib*******'+Lib);
		libParentFolder = [select id, name, RootContentFolderId from contentworkspace where id in: Lib Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		// D-6383 fix - Started
		libFolderLink = [select id, ContentFolderId, EnableFolderStatus, ParentEntityId from ContentFolderLink where ParentEntityId in: Lib Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		system.debug('libFolderLink : '+ libFolderLink);
		// D-6383 fix - End 
		system.debug('libParentFolder : '+ libParentFolder);
		system.debug('accLibPartnerType : '+accLibPartnerType);
	
	// D-6383 fix - Started
		for(ContentFolderLink librarylink : libFolderLink) {
			system.debug('Lib6383*******'+librarylink);
			LibRootfolder.put(librarylink.ParentEntityId, librarylink.ContentFolderId );
		}
		
		for(contentworkspace LibNameID : libParentFolder) {
			system.debug('Lib6383*******'+LibNameID);
			LibrId.put(LibNameID.name, LibNameID.id );
		}
		// D-6383 fix - End 
		
	for(contentworkspace libr : libParentFolder) {
	 system.debug('Partner type :'+libr.name+'======'+accLibPartnerType.get(libr.name));
	 // commented fo D-6383
	 //if(accLibPartnerType.get(libr.name) == 'Value Added Reseller'){  
			//libPFolderVAR.add(libr.RootContentFolderId);
			
			// D-6383 fix - Started
			
			if(accLibPartnerType.get(libr.name) == 'Value Added Reseller'){ 
			libPFolderVAR.add(LibRootfolder.get(LibrId.get(libr.name)));
	
			// D-6383 fix - End 
			
	 }
	 else if(accLibPartnerType.get(libr.name) == 'Distributor'){
			libPFolderDist.add(LibRootfolder.get(LibrId.get(libr.name)));
	 }
	 else if(accLibPartnerType.get(libr.name) == 'Service Provider'){
	  
			libPFolderSProvider.add(LibRootfolder.get(LibrId.get(libr.name)));
			system.debug('Lib6383*******libPFolderSProvider'+libPFolderSProvider);
	 }
	 else if(accLibPartnerType.get(libr.name) == 'Indirect Reseller'){
			libPFolderIResller.add(LibRootfolder.get(LibrId.get(libr.name)));
	 }
	 else if(accLibPartnerType.get(libr.name) == 'Industrial Partner / System Integrator'){
			libPFolderIndPartner.add(LibRootfolder.get(LibrId.get(libr.name)));
	 }
	 else if(accLibPartnerType.get(libr.name) == 'Alliance Partner'){
			libPFolderAlPartner.add(LibRootfolder.get(LibrId.get(libr.name)));
	 }
	 
	 
			
			
			libId.add(libr.id);
	}
	
	system.debug('libPFolderVAR :'+libPFolderVAR);
	system.debug('libPFolderDist :'+libPFolderDist);
	system.debug('accLibPartnerType :'+accLibPartnerType);
	
		if(!(libPFolderVAR.isempty())){
		createVarSubFolder(libPFolderVAR);  
		}
		if(!(libPFolderDist.isempty())){
		createDistSubFolder(libPFolderDist); 
		}
		if(!(libPFolderSProvider.isempty())){
		createSProviderSubFolder(libPFolderSProvider); 
		}
		if(!(libPFolderIResller.isempty())){
		createIResllerSubFolder(libPFolderIResller); 
		}
		if(!(libPFolderIndPartner.isempty())){
		createIndPartnerSubFolder(libPFolderIndPartner); 
		}
		if(!(libPFolderAlPartner.isempty())){
		createAllPartnerSubFolder(libPFolderAlPartner); 
		}
		addMembers(libId); 
	}
	
	
 @future 
	public static void createVarSubFolder(set<ID>  libParentFldr){
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  from Partner_Library_Folder__c where Partner_Type__c = 'Value Added Reseller'];
		craeteFolderAll(libParentFldr, allFolders);
	}
	
	@future 
	public static void createDistSubFolder(set<ID>  libParentFldr){
		
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  from Partner_Library_Folder__c where Partner_Type__c = 'Distributor'];
		craeteFolderAll(libParentFldr, allFolders);
	}
	 @future 
	public static void createSProviderSubFolder(set<ID>  libParentFldr){
		
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  from Partner_Library_Folder__c where Partner_Type__c = 'Service Provider'];
		craeteFolderAll(libParentFldr, allFolders);
	}
	 @future 
	public static void createIResllerSubFolder(set<ID>  libParentFldr){
		
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  from Partner_Library_Folder__c where Partner_Type__c = 'Indirect Reseller'];
		craeteFolderAll(libParentFldr, allFolders);
	}
	 @future 
	public static void createIndPartnerSubFolder(set<ID>  libParentFldr){
		
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  from Partner_Library_Folder__c where Partner_Type__c = 'Industrial Partner / System Integrator'];
		craeteFolderAll(libParentFldr, allFolders);
	}
	 @future 
	public static void createAllPartnerSubFolder(set<ID>  libParentFldr){
		
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  from Partner_Library_Folder__c where Partner_Type__c = 'Alliance Partner'];
		craeteFolderAll(libParentFldr, allFolders);
	}

	Public static void craeteFolderAll(set<ID>  libParentFld, List<Partner_Library_Folder__c> parFolders){
		List<ContentFolder> subFolder  = new List<ContentFolder> ();
		List<ContentFolder> ssubFolder  = new List<ContentFolder> ();
		List<Partner_Library_Folder__c> folderFirstLevel = new List<Partner_Library_Folder__c> ();
		List<Partner_Library_Folder__c> folderSecLevel = new List<Partner_Library_Folder__c> ();
		map<string, string> parentfolder = new map<string, string>();
	
		
		
		for(Partner_Library_Folder__c fldr : parFolders){
			
			if(fldr.Folder_Level__c == '1')
			{
	folderFirstLevel.add(fldr);
			}
			else if(fldr.Folder_Level__c == '2')
			{
	folderSecLevel.add(fldr);
			}	
		}
		system.debug('folderFirstLevel : '+folderFirstLevel);
		system.debug('folderSecLevel : '+folderSecLevel);
		
		if(!(libParentFld.isempty())){
		for (ID partLib : libParentFld){
		
		if(!(folderFirstLevel.isempty())){
			for(Partner_Library_Folder__c frstlevel :  folderFirstLevel){
			ContentFolder newFolder = new ContentFolder (name=frstlevel.name, ParentContentFolderId=partLib);
			subFolder.add(newFolder);
			}
		}
		database.insert(subFolder);
		system.debug('subFolder : '+subFolder);
		
		for(ContentFolder fldr : subFolder){
		parentfolder.put(fldr.name, fldr.id);
		}
		
		system.debug('parentfolder : '+parentfolder);
		}
		
		if(!(folderSecLevel.isempty())){
			for(Partner_Library_Folder__c seclevel :  folderSecLevel){
			
			system.debug('name: '+ seclevel.name+ 'Parent folder: '+parentfolder.get(seclevel.Parent_Folder__c));
			
			ContentFolder newFolder = new ContentFolder (name= seclevel.name, ParentContentFolderId=parentfolder.get(seclevel.Parent_Folder__c));
			ssubFolder.add(newFolder);
			}
		}
		//database.insert(ssubFolder);
		system.debug('ssubFolder : '+ssubFolder);
		
	}
	}
	
	@future 
   public static void addMembers(Set<ID>  librId){
		List<ContentWorkspaceMember> libMem  = new List<ContentWorkspaceMember> ();
		List<Partner_Library_Admins__c> Admin = Partner_Library_Admins__c.getAll().values(); 
		 system.debug('Admin : '+ Admin);
		 
		if(!(librId.isempty())){
		for (ID NewLib : librId){
		
		for(Partner_Library_Admins__c LibAdmin : Admin ){
		
		system.debug('LibAdmin : '+ LibAdmin.name); 
		ContentWorkspaceMember newMem = new ContentWorkspaceMember (ContentWorkspaceId=NewLib, ContentWorkspacePermissionId= LibAdmin.Library_Permission_ID__c, 
		MemberId= LibAdmin.Member_Id__c);
		libMem.add(newMem);
		}
		}
		system.debug('libMem : '+ libMem);
		database.insert(libMem);
		}
		
	
	}
	
		
	}