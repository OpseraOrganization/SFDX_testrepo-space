public with sharing class MetadataAPIUtility{
 public list<string> invalid = new list<string>();	
  public void createcustomlabel() { 
	  List<case> invalidcasenull =[SELECT id, Invalid_subject_Capture__c FROM case WHERE recordtype.name = 'EDU Ticketing' AND (Invalid_subject_Capture__c != NULL OR Invalid_subject_Capture__c != '')]; 
	  List<String> invalidSubjects = System.Label.EDUT_Invalid_Subjects.Split(',');
	  system.debug('%%%%%%customlabel'+invalidSubjects);
	  list<string> invalidsubj = new list<string>();
	  List<case> validcase = new list<case>();
	  id recordtypeid = [select id from recordtype where developername='EDU_Ticketing'].id;
		for(case c:invalidcasenull)
		  {
			invalidsubj.add(c.Invalid_subject_Capture__c);
		  }
		for(string s:invalidsubj)
		  {
			if(!invalidSubjects.contains(s))
			{
			  invalid.add(s);
			  system.debug('%%%%%%invalid'+invalid);
			}
		  }
	
	set<string> invalidset =new set<string>();
	for(string s: invalid)
	{
	 invalidset.add(s);
	 system.debug('&&&&invalidset'+invalidset);
	}
	
	list<string> invalidcase= new list<string>();
	for(string s: invalidset)
	{
	 invalidcase.add(s);
	 system.debug('&&&&invalidcase'+invalidcase);
	}
		labelcreate(invalidcase);
  }  
@future(callout=true) 
		public static void labelcreate(list<string> subject){  
		string store;	
		system.debug('$$$$$string'+subject);
		List<case> invalidcaseupdate =[SELECT id, Invalid_subject_Capture__c FROM case WHERE recordtype.name = 'EDU Ticketing' AND (Invalid_subject_Capture__c != NULL OR Invalid_subject_Capture__c != '')]; 
		List<MetadataService.Metadata> allMetadataList = new List<MetadataService.Metadata>();
		MetadataService.MetadataPort service = createService();
		MetadataService.CustomLabel csLabel = new MetadataService.CustomLabel();
		csLabel.fullName = 'EDUT_Invalid_Subjects';
		system.debug('####Customlabelname'+csLabel.fullName );
		csLabel.language = 'en_US';
		csLabel.protected_x  = false;
		csLabel.shortDescription  = 'description';
		for(string s: subject)
		{
			if(store==null || store=='')
				{
				 store=s;
				}
			 else
				 {
				  store=store+','+s;
				 }		  
		}	   
		system.debug('$$$$$beforstore'+store);   
		if(store!=null || store!='')  
		{
		system.debug('$$$$$afterstore'+store);  
		system.debug('%%%%%%customlabeldd'+System.Label.EDUT_Invalid_Subjects); 
	   // if(store.contains('null'))
		csLabel.value=System.Label.EDUT_Invalid_Subjects+ ',' +store.remove('null');
		//else
		//csLabel.value=System.Label.EDUT_Invalid_Subjects;
		}
		system.debug('!!!!!Customlabelvalue'+csLabel.value);
		allMetadataList.add(csLabel);
		system.debug('$$$$$addall'+allMetadataList);
		if(!Test.IsRunningTest())
		{
		List<MetadataService.SaveResult> results = service.updateMetadata(allMetadataList);
		for(MetadataService.SaveResult result: results){
			system.debug('@@@@results'+results);
			system.debug('@@@@update custom label results success='+result.success);
		 }
		}
		 
		 for(case updatestatus:invalidcaseupdate)
		  {
			if(invalidcaseupdate.size()>0)
			updatestatus.status='Invalid';
		  }
		 update invalidcaseupdate;
		}
			   
		private static MetadataService.MetadataPort createService(){ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;
		}	   
}