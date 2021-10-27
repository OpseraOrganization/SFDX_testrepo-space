public class TerritoryModelPocController {
	
  @AuraEnabled
	public static List<Territory2>  returnL1Territories()
	{
		try
		{		   
			Id userId = UserInfo.getUserId();
			Integer highestLevel;
			Set<Id> allowedTerritoryId = new Set<Id>();			
			for(UserTerritory2Association utaRec : [SELECT RoleInTerritory2,Territory2id,Territory2.Hierarchy_Level__c,UserId FROM UserTerritory2Association WHERE UserId =: userId and IsActive =: true])
			{			   
				Integer currentLevel = Integer.valueOf(utaRec.Territory2.Hierarchy_Level__c.subString(1,utaRec.Territory2.Hierarchy_Level__c.length()));				
				System.debug('Trimmed String::>'+currentLevel);
				if(highestLevel != null)
				{
					if(currentLevel<highestLevel)
					{
						allowedTerritoryId.clear();
						allowedTerritoryId.add(utaRec.Territory2Id);
					}
					else if(currentLevel == highestLevel)
					{
						allowedTerritoryId.add(utaRec.Territory2Id);
					}
				}
				else
				{
					highestLevel = currentLevel;   
					allowedTerritoryId.add(utaRec.Territory2Id);
				}
				System.debug('highestLevel::>'+highestLevel);
			}							   
			List<Territory2> territoryL1List = new List<Territory2>();
			territoryL1List = [SELECT Id,Name,Hierarchy_ID__c,Hierarchy_Level__c,ParentTerritory2Id,Territory2TypeId FROM Territory2 WHERE Id IN: allowedTerritoryId AND Territory2Model.state = 'Active' AND Name != 'CO Deactivated Accounts' AND Name != 'CO Others'];
			System.debug('territoryL1List::>'+territoryL1List);
			return territoryL1List;
		}
		catch(Exception ex)
		{
			System.debug('returnL1Territories Exception');
			return null;
		}
	}
	@AuraEnabled
	public static List<Territory2>  returnL2toL7Territories()
	{
		try
		{
			List<Territory2> territoryL2ToL7List = new List<Territory2>();
			territoryL2ToL7List = [SELECT Id,Name,Hierarchy_ID__c,Hierarchy_Level__c,ParentTerritory2Id,Territory2TypeId FROM Territory2 WHERE Territory2Model.state = 'Active' AND Name != 'CO Deactivated Accounts' AND Name != 'CO Others'];
			return territoryL2ToL7List;
		}
		Catch(Exception Ex)
		{
			System.debug('returnL2toL7Territories Exception');
			return null;
		}
	}
	
  /*  @AuraEnabled
	public static List<NF_Territory2User__c>  returnRelatedNF_TerritoryUser_Info(String orgName)
	{
		try
		{
			List<NF_Territory2User__c> nfTerritoryUserList = new List<NF_Territory2User__c>();
			nfTerritoryUserList = [SELECT Id,User__r.Name,Email__c,First_Name__c,Hierarchy_Id__c,Last_Name__c,Role_Code__c,Role_Name__c FROM NF_Territory2User__c where Organisation__c  =: orgName];
			return nfTerritoryUserList;
		}
		Catch(Exception Ex)
		{
			System.debug('returnL2toL7Territories Exception');
			return null;
		}
	}
	
	@AuraEnabled
	public static void createRecords(String email){
		List<User> userList = new List<User>(); 
		userList = [SELECT Id, Name FROM User WHERE Email=:email];
	}
	*/
	
	@AuraEnabled
	public static List<Sales_Role__c>  returnsaleroleuser_Info1(String org,string BG,string Rolename,string MU,string CBT,String CT,string market)
	{			  system.debug('org ++> ' +org+ '  BG+++>'+BG +'Rolename'+rolename);
	 
	 
	 
	 try
	 {
		 List<Sales_Role__c> salesroleUserList = new List<Sales_Role__c>();
		 
		 set<string> Mset=new set<string>();
		 set<string> MUset=new set<string>();
		 set<string> CBTset=new set<string>();
		 set<string> CTset=new set<string>();
		 salesroleUserList.clear();
		 CTset.clear();
		 CBTset.clear();
		 MUset.clear();
		 Mset.clear();
		 
		 if(org!='')
		 {
			 List<Territory2> L4toL7List = [Select Id,Name,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.ParentTerritory2.Name
											from Territory2 where 
											ParentTerritory2.ParentTerritory2.ParentTerritory2.Name like : org];
			 
			 for(Territory2 L4toL7:L4toL7List)
			 {
				 if(MU!='')MUset.add(L4toL7.ParentTerritory2.ParentTerritory2.Name);
				 if(CBT!='')CBTset.add(L4toL7.ParentTerritory2.Name);
				 if(CT!='')CTset.add(L4toL7.Name);
				 if(market!='')Mset.add(L4toL7.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
				 
				 system.debug('MUset+++>'+MUset);
				 system.debug('CBTset+++>'+CBTset);
				 system.debug('CTset+++>'+CTset);
			 }
			 
			 if(BG=='')
			 { system.debug('0');
			  salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c,User__c,NSA__c,User__r.Name  FROM Sales_Role__c where  Role_Name__c LIKE : '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset  )];
			 }
			 else if(BG!='')
			 { system.debug('1');
			  salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c,User__c,NSA__c,User__r.Name  FROM Sales_Role__c where BG__c LIKE: BG AND Role_Name__c LIKE: '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset  )];
			 }
			 
		 }
		
		 else{
			 return null;				
		 }
		 System.debug('Result: '+salesroleUserList);
		 return salesroleUserList;
		 
	 }
	 Catch(Exception Ex)
	 {
		 System.debug('returnL2toL7Territories Exception');
		 return null;
	 }
	}
	
	
	
	
	@AuraEnabled
	public static List<territory2>  returnsaleroleuser_unassign(String org,string BG,string Rolename,string MU,string CBT,String CT,string market)
	{
		try
		{
			List<Sales_Role__c> salesroleUserList = new List<Sales_Role__c>();
			List<territory2> salesroleUserunassignList = new List<territory2>();
			
			
			set<string> Mset=new set<string>();
			set<string> MUset=new set<string>();
			set<string> CBTset=new set<string>();
			set<string> CTset=new set<string>();
			set<string> unassignset=new set<string>();
			
			salesroleUserList.clear();
			CTset.clear();
			CBTset.clear();
			MUset.clear();
			Mset.clear();
			
			if(org!='')
			{
				List<Territory2> L4toL7List = [Select Id,Name,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.ParentTerritory2.Name
											   from Territory2 where 
											   ParentTerritory2.ParentTerritory2.ParentTerritory2.Name like : org];
				
				for(Territory2 L4toL7:L4toL7List)
				{
					if(MU!='')MUset.add(L4toL7.ParentTerritory2.ParentTerritory2.Name);
					if(CBT!='')CBTset.add(L4toL7.ParentTerritory2.Name);
					if(CT!='')CTset.add(L4toL7.Name);
					if(market!='')Mset.add(L4toL7.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
				}
				if(BG=='')
				{ system.debug('0');
				 salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c FROM Sales_Role__c where  Role_Name__c LIKE : '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset  )];
				 for(Sales_Role__c s:salesroleUserList)
				 {
				   unassignset.add(s.Organisation__c) ;
				 }
				 List<Territory2> L4toL7unasssignlist = [Select Id,Name from territory2 where Name IN :MUset OR  Name IN :CBTset Or Name IN :CTset OR Name IN :Mset ];
				 
				 for(territory2 t:L4toL7unasssignlist)
				 {
					 if(!unassignset.contains(t.Name)) 
					 {
					   salesroleUserunassignList.add(t)  ; 
					 }
				 }
				}
				
				else if(BG!='')
				{ system.debug('1');
				 salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c FROM Sales_Role__c where BG__c LIKE: BG AND Role_Name__c LIKE: '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset  )];
				 
				 for(Sales_Role__c s:salesroleUserList)
				 {
					 unassignset.add(s.Organisation__c) ;
				 }
				 List<Territory2> L4toL7unasssignlist = [Select Id,Name from territory2 where Name IN :MUset OR  Name IN :CBTset Or Name IN :CTset OR Name IN :Mset ];
				 
				 for(territory2 t:L4toL7unasssignlist)
				 {
					 if(!unassignset.contains(t.Name)) 
					 {
						 salesroleUserunassignList.add(t)  ; 
					 }
				 }
				 
				}
				
			}
			
			
			else{
				return null;				
			}
			System.debug('Result: '+salesroleUserunassignList);
			return salesroleUserunassignList;
			
		}
		Catch(Exception Ex)
		{
			System.debug('returnL2toL7Territories Exception');
			return null;
		}
	}
	
  
	@AuraEnabled
	public static void saveListsalesroleUser(string ListsalesroleUser){
	  system.debug('listsrinsert++>'+ListsalesroleUser); 
		
		 List<SalesRoleWrappers> stageList = (List<SalesRoleWrappers>)JSON.deserialize(ListsalesroleUser,List<SalesRoleWrappers>.class);
		  List<Sales_Role__c> toBeInsertedList = new List<Sales_Role__c>();
	 
		 for(SalesRoleWrappers salesRecord : stageList)
		 {
			 system.debug('salesRecord.user++>'+salesRecord.user);
			
			 if(salesRecord.user!=null)
			 {system.debug('salesRecord.user++>'+salesRecord.user);
			  Sales_Role__c salesRec = new Sales_Role__c();
			 
			 salesRec.Organisation__c = salesRecord.salesrole;
			  salesRec.Role_Name__c   = salesRecord.Rolename;
				  salesRec.User__c	= salesRecord.user;
				  salesRec.BG__c	 = salesRecord.BG;
			 
			  toBeInsertedList.add(salesRec);
		 }
			 
		 }
		 if(!toBeInsertedList.isEmpty() )
		 {
			 system.debug('toBeInsertedList++>'+toBeInsertedList);
			database.Insert(toBeInsertedList);
		 }
	}
	
	@AuraEnabled
	public static List < Sales_Role__c > savesalesrole(List<Sales_Role__c> lstSalesRol) {
		update lstSalesRol;
		return lstSalesRol;
	}
	
	@AuraEnabled
	public static List<SalesRoleWrapper> returnsaleroleuser_Info(String org,string BG,string Rolename,string MU,string CBT,String CT,string market)
	{			  system.debug('org ++> ' +org+ '  BG+++>'+BG +'Rolename'+rolename);
	 system.debug('MU ++> ' +MU+ '  CBT+++>'+CBT +'CT'+CT);
	 
	 
	 
	 try
	 {
		 Map<String, SalesRoleWrapper> salesRoleWrapperMap = new Map<String,SalesRoleWrapper>();
		  List<salesRoleWrapper> wrapperList = new List<salesRoleWrapper>();
		 List<Sales_Role__c> salesroleUserList = new List<Sales_Role__c>();
		 
		 set<string> Mset=new set<string>();
		 set<string> MUset=new set<string>();
		 set<string> CBTset=new set<string>();
		 set<string> CTset=new set<string>();
		 salesroleUserList.clear();
		 CTset.clear();
		 CBTset.clear();
		 MUset.clear();
		 Mset.clear();
		 
		 if(org!='')
		 {
			 List<Territory2> L4toL7List = [Select Id,Name,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.Name,
											ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
											Hierarchy_Level__c
											from Territory2 where 
											ParentTerritory2.ParentTerritory2.ParentTerritory2.Name like : org];
			 
			 for(Territory2 L4toL7:L4toL7List)
			 {
				 if(MU!=null)MUset.add(L4toL7.ParentTerritory2.ParentTerritory2.Name);
				 if(CBT!=null)CBTset.add(L4toL7.ParentTerritory2.Name);
				 if(CT!=null)CTset.add(L4toL7.Name);
				 if(market!=null)Mset.add(L4toL7.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
			 }   
				 system.debug('MUset+++>'+MUset);
				 system.debug('CBTset+++>'+CBTset);
				 system.debug('CTset+++>'+CTset);
			 
			 
			 if(BG=='')
			 { system.debug('0');
			  salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c,User__c,NSA__c,User__r.Name  FROM Sales_Role__c where  Role_Name__c LIKE : '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset  )];
			 }
			 else if(BG!='')
			 { system.debug('1');
			  salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c,User__c,NSA__c,User__r.Name  FROM Sales_Role__c where BG__c LIKE: BG AND Role_Name__c LIKE: '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset ) ];
			 }
						  
			 /******/
			 List<Territory2> L4toL7List1 = [Select Id,Name,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.Name,
											ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
											ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
											ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
											Hierarchy_Level__c
											from Territory2];
			 Map<String, Territory2> territoryMap = new Map<String, Territory2>();
			 for(Territory2 territory : L4toL7List1){
				 territoryMap.put(territory.Name, territory);
			 }
			
			 for(Sales_Role__c salesRole : salesroleUserList){
				 salesRoleWrapper srw = new salesRoleWrapper();
				 srw.salesrole = salesRole; 
				 if(territoryMap.containsKey(salesRole.Organisation__c)){
					 Territory2 territory = territoryMap.get(salesRole.Organisation__c);
					 if(territory.Hierarchy_Level__c == 'L7'){
						srw.l7 = territory.Name;
						srw.l6 = territory.ParentTerritory2.Name;
						srw.l5 = territory.ParentTerritory2.ParentTerritory2.Name;
						srw.l4 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
						srw.l3 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
					 }else if(territory.Hierarchy_Level__c == 'L6'){						 
						srw.l6 = territory.Name;
						srw.l5 = territory.ParentTerritory2.Name;
						srw.l4 = territory.ParentTerritory2.ParentTerritory2.Name;
						srw.l3 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
					 }else if(territory.Hierarchy_Level__c == 'L5'){
						srw.l5 = territory.Name;
						srw.l4 = territory.ParentTerritory2.Name;
						srw.l3 = territory.ParentTerritory2.ParentTerritory2.Name;
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
					 }else if(territory.Hierarchy_Level__c == 'L4'){
						srw.l4 = territory.Name;
						srw.l3 = territory.ParentTerritory2.Name;
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.Name;
					 }
				 }	
				 wrapperList.add(srw);
			  
				 System.debug('sw-->'+srw);
				 
			 }
			if(!wrapperList.isEmpty())wrapperList.sort();
			 System.debug('List size of salesrole:'+salesroleUserList.size());
			 System.debug('List size of wrapper list:'+wrapperList.size());
			 /******+++++++++++++
			  for(Sales_Role__c salesRole : salesroleUserList){
				 if(!(salesRoleWrapperMap.containsKey(salesRole.Organisation__c)))
					 salesRoleWrapperMap.put(salesRole.Organisation__c,new salesRoleWrapper(salesRole));
			 }
			 for(Territory2 territory : L4toL7List){
				 if(salesRoleWrapperMap.containsKey(territory.Name)){
					 if(territory.Hierarchy_Level__c == 'L7'){
						salesRoleWrapperMap.get(territory.Name).l7 = territory.Name;
						salesRoleWrapperMap.get(territory.Name).l6 = territory.ParentTerritory2.Name;
						salesRoleWrapperMap.get(territory.Name).l5 = territory.ParentTerritory2.ParentTerritory2.Name;
						salesRoleWrapperMap.get(territory.Name).l4 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;						 
					 }else if(territory.Hierarchy_Level__c == 'L6'){
						salesRoleWrapperMap.get(territory.Name).l6 = territory.Name;
						salesRoleWrapperMap.get(territory.Name).l5 = territory.ParentTerritory2.Name;
						salesRoleWrapperMap.get(territory.Name).l4 = territory.ParentTerritory2.ParentTerritory2.Name;
					 }else if(territory.Hierarchy_Level__c == 'L5'){
						salesRoleWrapperMap.get(territory.Name).l5 = territory.Name;
						salesRoleWrapperMap.get(territory.Name).l4 = territory.ParentTerritory2.Name;
						salesRoleWrapperMap.get(territory.Name).l3 = territory.ParentTerritory2.ParentTerritory2.Name;
					 }else if(territory.Hierarchy_Level__c == 'L4'){
						salesRoleWrapperMap.get(territory.Name).l4 = territory.Name;
						salesRoleWrapperMap.get(territory.Name).l3 = territory.ParentTerritory2.Name;
						salesRoleWrapperMap.get(territory.Name).l2 = territory.ParentTerritory2.ParentTerritory2.Name;
					 }
				 }
			 }
			 System.debug('SalesRoleWrapperMap: '+salesRoleWrapperMap);
			 for(salesRoleWrapper sw : salesRoleWrapperMap.Values())
				System.debug('SW-->'+sw);
			 System.debug('Size of map: '+salesRoleWrapperMap.Values().size());
			 System.debug('Size of list: '+salesroleUserList.size());
			 if(salesRoleWrapperMap.Values().size() == salesroleUserList.size())
				 system.debug('Both list have same size');
			 ******/
		 }
		
		 else{
			 return null;				
		 }
		 System.debug('Result: '+salesroleUserList);
		 return wrapperList;
		 
	 }
	 Catch(Exception Ex)
	 {
		 System.debug('returnL2toL7Territories Exception'+ex);
		 return null;
	 }
	}
	
	 
	public class SalesRoleWrapper implements Comparable{
		@AuraEnabled public Sales_Role__c salesrole {get;set;}
		@AuraEnabled public String l1 {get;set;}
		@AuraEnabled public String l2 {get;set;}
		@AuraEnabled public String l3 {get;set;}
		@AuraEnabled public String l4 {get;set;}
		@AuraEnabled public String l5 {get;set;}
		@AuraEnabled public String l6 {get;set;}
		@AuraEnabled public String l7 {get;set;}
		
		public SalesRoleWrapper(Sales_Role__c sr){
			this.salesrole = sr;
			this.l1 = '';
			this.l2 = '';
			this.l3 = '';
		}
	   public SalesRoleWrapper(SalesRoleWrapper sr){
			this.salesrole = sr.salesrole;
			this.l1 = sr.l1;
			this.l2 = sr.l2;
			this.l3 = sr.l3;
			this.l4 = sr.l4;
			this.l5 = sr.l5;
			this.l6 = sr.l6;
			this.l7 = sr.l7;			
		}
		public SalesRoleWrapper(){
			this.l1 = '';
			this.l2 = '';
			this.l3 = '';
			this.l4 = '';
			this.l5 = '';
			this.l6 = '';
			this.l7 = '';
			
			
		}
		public Integer compareTo(Object obj){
			SalesRoleWrapper wrapper = (SalesRoleWrapper)obj;
		   System.debug('l4::>' +wrapper.l4 + 'l5::>' +wrapper.l5 + 'l6::>' +wrapper.l6 +'l7::>' +wrapper.l7);
			
			if(wrapper != null && !String.isEmpty(wrapper.l7)){
				system.debug('wrapper.l7++>'+wrapper.l7);
				Integer l5res = l5.compareTo(wrapper.l5);
				system.debug('l5.compareTo(wrapper.l5)++>'+l5.compareTo(wrapper.l5));
				
				if(l5res != 0){
				System.debug('1'+this.l5 +'-->'+wrapper.l5);
					if(this.l5 == null)
						this.l5 = '';
					 system.debug('l5.compareTo(wrapper.l5)++>'+l5.compareTo(wrapper.l5));
					return l5.compareTo(wrapper.l5);
					
				}
				else{
				System.debug('2' +this.l6 +' '+this.l5+'-->'+wrapper.l6 +wrapper.l5);
					if(this.l6 == null)
						this.l6 = '';
					system.debug('l6.compareTo(wrapper.l6)++>'+l6.compareTo(wrapper.l6));
					return l6.compareTo(wrapper.l6);
				}
			}
			else if(wrapper != null && String.isEmpty(wrapper.l7) && !String.isEmpty(wrapper.l6)){
				Integer l5res = l5.compareTo(wrapper.l5);
				if(l5res != 0){
				   System.debug('3'+this.l5 +'-->'+wrapper.l5);
					if(this.l5 == null)
						this.l5 = '';
					return l5.compareTo(wrapper.l5);}
				else{
					System.debug('4 '+this.l6 +' '+this.l5+'-->'+wrapper.l6 +wrapper.l5);
					if(this.l6 == null)
						this.l6 = '';
					return l6.compareTo(wrapper.l6);}
			}
			else if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && !String.isEmpty(wrapper.l5)){
				Integer l4res = l4.compareTo(wrapper.l4);
				if(l4res != 0){
					System.debug('5'+this.l4 +' '+this.l5+'-->'+wrapper.l4 +wrapper.l5+wrapper.l6);
					if(this.l4 == null)
						this.l4 = '';
					return l4.compareTo(wrapper.l4);}
				else{
					System.debug('6'+this.l5+'-->'+wrapper.l4 +wrapper.l5+wrapper.l6);
					if(this.l5 == null)
						this.l5 = '';
					return l5.compareTo(wrapper.l5);}
			}
			
			 else if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && String.isEmpty(wrapper.l5)&& !String.isEmpty(wrapper.l4)){
				Integer l3res = l3.compareTo(wrapper.l3);
				if(l3res != 0){
				   System.debug('7'+this.l3 +'-->'+wrapper.l3);
					if(this.l3 == null)
						this.l3 = '';
					return l3.compareTo(wrapper.l3);}
				else{
					System.debug('8'+this.l3 +' '+this.l4+'-->'+wrapper.l3 +wrapper.l4);
					if(this.l4 == null)
						this.l4 = '';
					return l4.compareTo(wrapper.l4);}
			}
			
			else if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && String.isEmpty(wrapper.l5)&& String.isEmpty(wrapper.l4)&& !String.isEmpty(wrapper.l3)){
				Integer l2res = l2.compareTo(wrapper.l2);
				if(l2res != 0){
				   System.debug('9'+this.l2 +'-->'+wrapper.l2);
					if(this.l2 == null)
						this.l2 = '';
					return l2.compareTo(wrapper.l2);}
				else{
					System.debug('10'+this.l2 +' '+this.l3+'-->'+wrapper.l2 +wrapper.l3);
					if(this.l3 == null)
						this.l3 = '';
					return l3.compareTo(wrapper.l3);}
			}
			
			
			
			else
			{
				System.debug('7');
				return null;
			}
		}
	}
	
	  @AuraEnabled
	public static List<SalesRoleWrappers>  returnsaleroleuser_unassign1(String org,string BG,string Rolename,string MU,string CBT,String CT,string market)
	{
	   system.debug('BG++>'+BG);
			Map<String, SalesRoleWrappers> salesRoleWrapperMap = new Map<String,SalesRoleWrappers>();
		   List<salesRoleWrappers> wrapperList = new List<salesRoleWrappers>();
			List<Sales_Role__c> salesroleUserList = new List<Sales_Role__c>();
			//List<string> salesroleUserunassignList = new List<string>();
			 List<string> salesroleUserunassignList = new List<string>();
		 List<string> TerritoryList = new List<string>();
		 Map<String, string> salesRoleusercheck = new Map<String,string>();
		  Map<String, User> usernameidMap = new Map<String,User>();
			
			set<string> Mset=new set<string>();
			set<string> MUset=new set<string>();
			set<string> CBTset=new set<string>();
			set<string> CTset=new set<string>();
			set<string> unassignset=new set<string>();
		 set<string> totalset=new set<string>();
			
			salesroleUserList.clear();
			CTset.clear();
			CBTset.clear();
			MUset.clear();
			Mset.clear();
			salesroleUserunassignList.clear();
			wrapperList.clear();
			salesRoleusercheck.clear();
			TerritoryList.clear();
		/*
			if(org!='')
			{
				List<Territory2> L4toL7List = [Select Id,Name,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.ParentTerritory2.Name
											   from Territory2 where 
											   ParentTerritory2.ParentTerritory2.ParentTerritory2.Name like : org];
				
				for(Territory2 L4toL7:L4toL7List)
				{
					if(MU!=null)MUset.add(L4toL7.ParentTerritory2.ParentTerritory2.Name);
					if(CBT!=null)CBTset.add(L4toL7.ParentTerritory2.Name);
					if(CT!=null)CTset.add(L4toL7.Name);
					if(market!=null)Mset.add(L4toL7.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
				}
				if(BG=='')
				{ system.debug('0');
				 salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c FROM Sales_Role__c where  Role_Name__c LIKE : '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset  )];
				 for(Sales_Role__c s:salesroleUserList)
				 {
				   unassignset.add(s.Organisation__c) ;
				 }
				 List<Territory2> L4toL7unasssignlist = [Select Id,Name from territory2 where Name IN :MUset OR  Name IN :CBTset Or Name IN :CTset OR Name IN :Mset ];
				 
				 for(territory2 t:L4toL7unasssignlist)
				 {
					 if(!unassignset.contains(t.Name)) 
					 {
					   salesroleUserunassignList.add(t.Name)  ; 
					 }
				 }
				}
				
				else if(BG!='')
				{ system.debug('1');
				 salesroleUserList = [SELECT Id,BG__c,Organisation__c,Role_Name__c,Active__c,User_Email__c FROM Sales_Role__c where BG__c LIKE: BG AND Role_Name__c LIKE: '%'+Rolename+'%'  AND (Organisation__c IN :Mset OR Organisation__c IN :MUset OR Organisation__c IN :CBTset OR Organisation__c IN :CTset  )];
				 
				 for(Sales_Role__c s:salesroleUserList)
				 {
					 unassignset.add(s.Organisation__c) ;
				 }
				 List<Territory2> L4toL7unasssignlist = [Select Id,Name from territory2 where Name IN :MUset OR  Name IN :CBTset Or Name IN :CTset OR Name IN :Mset ];
				 
				 for(territory2 t:L4toL7unasssignlist)
				 {
					 if(!unassignset.contains(t.Name)) 
					 {
						 salesroleUserunassignList.add(t.Name)  ; 
					 }
				 }
				 
				}
				
			}
		
		*/
		
		List<Territory2> L4toL7Levellist = [Select Id,Name,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.ParentTerritory2.Name
											   from Territory2 where 
											   ParentTerritory2.ParentTerritory2.ParentTerritory2.Name like : org ];
				
				for(Territory2 L4toL7:L4toL7Levellist)
				{ 
					CTset.add(L4toL7.Name);
					CBTset.add(L4toL7.ParentTerritory2.Name);
					MUset.add(L4toL7.ParentTerritory2.ParentTerritory2.Name);
					 Mset.add(L4toL7.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name);
					
					 //totalset.addAll(CTset);
					totalset.addAll(CBTset);
					totalset.addAll(MUset);
					totalset.addAll(Mset);
					
					
				}
		   for(user userrecord : [Select Id ,Name,IsActive from User ])
			{
				usernameidMap.put(userrecord.Id, userrecord);
			}   
		
		 for(Sales_Role__c salesRole : [Select Id ,Role_Name__c,Organisation__c,BG__c,User__c from Sales_Role__c where Role_Name__c LIKE : '%'+Rolename+'%' ])
			{ 
				if(BG!='')salesRoleusercheck.put(salesRole.Organisation__c+salesRole.Role_Name__c+salesRole.BG__c, salesRole.User__c );
				if(BG=='')salesRoleusercheck.put(salesRole.Organisation__c+salesRole.Role_Name__c, salesRole.User__c );
			}
	  
			 List<Territory2> L4toL7List1 = [Select Id,Name,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2.Name,
											ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
											ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
											ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,
											Hierarchy_Level__c
											from Territory2];
			 Map<String, Territory2> territoryMap = new Map<String, Territory2>();
			 for(Territory2 territory : L4toL7List1){
				   territoryMap.put(territory.Name, territory);
			 }
			system.debug('salesroleUserunassignList++>'+salesroleUserunassignList);
			
			
			  for(string salesRole : totalset){
				  system.debug('salesRole++>'+salesRole);
				 salesRoleWrappers srw = new salesRoleWrappers();
				 srw.salesrole = salesRole; 
				  srw.BG = BG;
				   srw.Rolename = Rolename;
					if(BG!='')srw.user =salesRoleusercheck.get(salesRole+Rolename+BG);
					if(BG=='')srw.user =salesRoleusercheck.get(salesRole+Rolename);
					if(BG=='')srw.usercheck=usernameidMap.get(salesRoleusercheck.get(salesRole+Rolename));
					if(BG!='')srw.usercheck=usernameidMap.get(salesRoleusercheck.get(salesRole+Rolename+BG));
				  
			   
				 if(territoryMap.containsKey(salesRole)){
					 Territory2 territory = territoryMap.get(salesRole);
					 if(territory.Hierarchy_Level__c == 'L7'){
						srw.l7 = territory.Name;
						srw.l6 = territory.ParentTerritory2.Name;
						srw.l5 = territory.ParentTerritory2.ParentTerritory2.Name;
						srw.l4 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
						srw.l3 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
					 }else if(territory.Hierarchy_Level__c == 'L6'){						 
						srw.l6 = territory.Name;
						srw.l5 = territory.ParentTerritory2.Name;
						srw.l4 = territory.ParentTerritory2.ParentTerritory2.Name;
						srw.l3 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name; 
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
					 }else if(territory.Hierarchy_Level__c == 'L5'){
						srw.l5 = territory.Name;
						srw.l4 = territory.ParentTerritory2.Name;
						srw.l3 = territory.ParentTerritory2.ParentTerritory2.Name;
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
					 }else if(territory.Hierarchy_Level__c == 'L4'){
						srw.l4 = territory.Name;
						srw.l3 = territory.ParentTerritory2.Name;
						srw.l2 = territory.ParentTerritory2.ParentTerritory2.Name;
					 }
				 }	
				 wrapperList.add(srw);
			  
				 System.debug('sw-->'+srw);
				 
			 }
		  if(!wrapperList.isEmpty())wrapperList.sort();
			 System.debug('List size of salesrole:'+salesroleUserunassignList.size());
			 System.debug('List size of wrapper list:'+wrapperList.size());
		   
		
		 System.debug('Result: '+salesroleUserunassignList);
		 return wrapperList;
		 
	}
	
	
   public class SalesRoleWrappers implements Comparable{
	   
		@AuraEnabled public string salesrole {get;set;}
		@AuraEnabled public String BG {get;set;}
		@AuraEnabled public String Rolename {get;set;}
	   @AuraEnabled public String user {get;set;}
	   @AuraEnabled public User usercheck {get;set;}
	   
		@AuraEnabled public String l1 {get;set;}
		@AuraEnabled public String l2 {get;set;}
		@AuraEnabled public String l3 {get;set;}
		@AuraEnabled public String l4 {get;set;}
		@AuraEnabled public String l5 {get;set;}
		@AuraEnabled public String l6 {get;set;}
		@AuraEnabled public String l7 {get;set;}
		
		public SalesRoleWrappers(string sr){
			this.salesrole = sr;
			this.l1 = '';
			this.l2 = '';
			this.l3 = '';
		}
	   public SalesRoleWrappers(SalesRoleWrappers sr){
			this.salesrole= sr.salesrole;
			this.l1 = sr.l1;
			this.l2 = sr.l2;
			this.l3 = sr.l3;
			this.l4 = sr.l4;
			this.l5 = sr.l5;
			this.l6 = sr.l6;
			this.l7 = sr.l7;			
		}
		public SalesRoleWrappers(){
			this.l1 = '';
			this.l2 = '';
			this.l3 = '';
			this.l4 = '';
			this.l5 = '';
			this.l6 = '';
			this.l7 = '';
			
			
		}
		public Integer compareTo(Object obj){
			SalesRoleWrappers wrapper = (SalesRoleWrappers)obj;
		   System.debug('l4::>' +wrapper.l4 + 'l5::>' +wrapper.l5 + 'l6::>' +wrapper.l6 +'l7::>' +wrapper.l7);
			
	   if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && String.isEmpty(wrapper.l5)&& !String.isEmpty(wrapper.l4)&&l4==wrapper.l4){
				
				  return 1;
			}
		else if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && !String.isEmpty(wrapper.l5)&&l4==wrapper.l4){
			   
					return 0;
			}  
			else if(wrapper != null && String.isEmpty(wrapper.l7) && !String.isEmpty(wrapper.l6)&&l4==wrapper.l4){
			   
					return -1;
					
		  }
			/*else if(wrapper != null && !String.isEmpty(wrapper.l7)){
								  return -2;
				}
						  
		   else if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && !String.isEmpty(wrapper.l5)){
				Integer l4res = l4.compareTo(wrapper.l4);
				if(l4res != 0){
					System.debug('5'+this.l4 +' '+this.l5+'-->'+wrapper.l4 +wrapper.l5+wrapper.l6);
					if(this.l4 == null)
						this.l4 = '';
					return l4.compareTo(wrapper.l4);}
				else{
					System.debug('6'+this.l5+'-->'+wrapper.l4 +wrapper.l5+wrapper.l6);
					if(this.l5 == null)
						this.l5 = '';
					return l5.compareTo(wrapper.l5);}
			}  
			
			 else if(wrapper != null && String.isEmpty(wrapper.l7) && !String.isEmpty(wrapper.l6)){
				Integer l5res = l5.compareTo(wrapper.l5);
				 Integer l4res = l4.compareTo(wrapper.l4);
				 Integer l6res = l6.compareTo(wrapper.l6);
				 
				if(l6res != 0){
					System.debug('4 '+this.l6 +' '+this.l5+'-->'+wrapper.l6 +wrapper.l5);
					if(this.l6 == null)
						this.l6 = '';
					return l6.compareTo(wrapper.l6);
					
				   
				}
				 //else if(l5res != 0)
				else {
				   System.debug('3'+this.l5 +'-->'+wrapper.l5);
					if(this.l5 == null)
						this.l5 = '';
					return l5.compareTo(wrapper.l5);}
				else{
					
					System.debug('3'+this.l4 +'-->'+wrapper.l4);
					if(this.l4 == null)
						this.l4 = '';
					return l4.compareTo(wrapper.l4);
				}
			}*/
			 /*
			else if(wrapper != null && !String.isEmpty(wrapper.l7)){
				system.debug('wrapper.l7++>'+wrapper.l7);
				Integer l4res = l4.compareTo(wrapper.l4);
			   Integer l5res= l5.compareTo(wrapper.l5);
				 Integer l6res= l6.compareTo(wrapper.l6);
				 Integer l7res= l7.compareTo(wrapper.l7);

				system.debug('l5.compareTo(wrapper.l5)++>'+l5.compareTo(wrapper.l5));
				
				 if(l7res!=0) {
				System.debug('2' +this.l7 +' '+this.l6+'-->'+wrapper.l7 +wrapper.l6);
					if(this.l7 == null)
						this.l7 = '';
					system.debug('l7.compareTo(wrapper.l6)++>'+l7.compareTo(wrapper.l7));
					return l7.compareTo(wrapper.l7);
				}
				//else if(l6res!=0)
				  else {
				System.debug('2' +this.l6 +' '+this.l5+'-->'+wrapper.l6 +wrapper.l5);
					if(this.l6 == null)
						this.l6 = '';
					system.debug('l6.compareTo(wrapper.l6)++>'+l6.compareTo(wrapper.l6));
					return l6.compareTo(wrapper.l6);
				}
				
			   else if(l5res != 0){
				System.debug('1'+this.l5 +'-->'+wrapper.l5);
					if(this.l5 == null)
						this.l5 = '';
					 system.debug('l5.compareTo(wrapper.l5)++>'+l5.compareTo(wrapper.l5));
					return l5.compareTo(wrapper.l5);
					
				}
				//else if(l4res != 0)
				else {
				System.debug('1'+this.l4 +'-->'+wrapper.l4);
					if(this.l4 == null)
						this.l4 = '';
					return l4.compareTo(wrapper.l4);
					
				}
				
			   
			}
			
		   
		  
			
		
			
			 /*else if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && String.isEmpty(wrapper.l5)&& !String.isEmpty(wrapper.l4)){
				Integer l3res = l3.compareTo(wrapper.l3);
				if(l3res != 0){
				   System.debug('7'+this.l3 +'-->'+wrapper.l3);
					if(this.l3 == null)
						this.l3 = '';
					return l3.compareTo(wrapper.l3);}
				else{
					System.debug('8'+this.l3 +' '+this.l4+'-->'+wrapper.l3 +wrapper.l4);
					if(this.l4 == null)
						this.l4 = '';
					return l4.compareTo(wrapper.l4);}
			}
			
			else if(wrapper != null && String.isEmpty(wrapper.l7) && String.isEmpty(wrapper.l6) && String.isEmpty(wrapper.l5)&& String.isEmpty(wrapper.l4)&& !String.isEmpty(wrapper.l3)){
				Integer l2res = l2.compareTo(wrapper.l2);
				if(l2res != 0){
				   System.debug('9'+this.l2 +'-->'+wrapper.l2);
					if(this.l2 == null)
						this.l2 = '';
					return l2.compareTo(wrapper.l2);}
				else{
					System.debug('10'+this.l2 +' '+this.l3+'-->'+wrapper.l2 +wrapper.l3);
					if(this.l3 == null)
						this.l3 = '';
					return l3.compareTo(wrapper.l3);}
			}*/
			
			
			
			else
			{
				System.debug('7');
				return null;
			}
		}
   }   
		
	
}