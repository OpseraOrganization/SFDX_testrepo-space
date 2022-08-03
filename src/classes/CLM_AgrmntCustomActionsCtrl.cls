/*******************************************************************************************
* @Name		 CLM_AgrmntCustomActionsCtrl 
* @Author	   Rajeev Ketha <rajeev.ketha.ext@nokia.com>
* @Date		 04/21/2021
* @Group		CLM Services - E2ECLM- 3, 4,6, 9,10,11
* @Description  This class contains all custom actions related to agreement.
*******************************************************************************************/
/* MODIFICATION LOG
* Version		  Developer		  Date			   Description
*-------------------------------------------------------------------------------------------
*  1.0			  Rajeev	  04/21/2021		  Initial Creation													  
*******************************************************************************************/
public without sharing class CLM_AgrmntCustomActionsCtrl {
	
	/**************************************************************************************
* @Description  This method fetch the agreement data 
* @Param		string - AgreementId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getRecordData(String)
**************************************************************************************/
	
	@AuraEnabled
	public static Apttus__APTS_Agreement__c getRecordData(string recordId){
		try{
			Apttus__APTS_Agreement__c agrrmnt = [SELECT Id, Name, Apttus__Status_Category__c ,Apttus__Source__c ,Apttus__Status__c ,Lead_BG__c ,Apttus__Subtype__c ,
												 Nokia_Legal_Entity__c ,ownerId ,CLM_Supporting_BGs__c ,CLM_Lead_BU__c ,Apttus__Primary_Contact__c ,Apttus__Contract_End_Date__c ,
												 Apttus__Account__c ,Apttus__Account__r.Name ,RecordType.Name ,RecordType.Id ,Apttus__Requestor__c ,Apttus__Parent_Agreement__r.Apttus__Subtype__c,
												 CLM_Existing_Contract_Reference__c,Nokia_Legal_Entity_lookup__c,Nokia_Legal_Entity_lookup__r.Name ,Apttus__Parent_Agreement__c,
												 Apttus__VersionAware__c,Apttus__Related_Opportunity__c ,CLM_Contract_Category__c,CLM_Qualifies_for_Self_Service__c
												 FROM Apttus__APTS_Agreement__c 
												 WHERE Id=:recordId];
			return agrrmnt;
		}catch(Exception e){
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method copy opportunity data to Agreement 
* @Param		string - optyId, string - objectAPIName, string - objectAPIName
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.opptCopyToObj(string, string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static objInfoWrapper opptCopyToObj(string recordId, string fromObjAPI, string toObjAPI){
		try{
			objInfoWrapper objWrap = new objInfoWrapper();
			Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
			Schema.SObjectType toSchema = schemaMap.get(toObjAPI);
			Map<String, Schema.SObjectField> tofieldMap = toSchema.getDescribe().fields.getMap();
			
			
			List<CLM_OpportunityFieldsToCopy__c> cloneFieldDetails = [SELECT id, order__c ,AgreementFieldAPI__c, AgreementFieldLabel__c, OpportunityFieldAPI__c 
																	  FROM CLM_OpportunityFieldsToCopy__c order by Order__c];
			Map<string,string> csfieldMap = new Map<string,string>();
			for(CLM_OpportunityFieldsToCopy__c field:cloneFieldDetails){
				csfieldMap.put(field.OpportunityFieldAPI__c ,field.AgreementFieldAPI__c+';'+field.AgreementFieldLabel__c );
			}
			
			String soqlQuery = 'select Name,RecordType.Name, ';
			for(string s:csfieldMap.keySet()){
				soqlQuery +=s+',';
			}
			soqlQuery = soqlQuery.substring(0, soqlQuery.length() - 1);
			soqlQuery += ' FROM '+fromObjAPI+'  WHERE Id=:recordId';
			Sobject objRec = database.query(soqlQuery);
			objWrap.objRecd = objRec;
			List<wrapper> wrapLst = new List<wrapper>();
			List<string> fieldApiLst = new  List<string>();
			wrapper wrap = new wrapper();
			for(string s:csfieldMap.keySet()){
				fieldApiLst = (csfieldMap.get(s)).split(';');
				wrap = new wrapper();
				wrap.fieldId = (tofieldMap.get(fieldApiLst[0]).getDescribe().getLabel()).deleteWhitespace()+'Field';
				wrap.fieldValue = string.valueOf(objRec.get(s));
				wrap.disable = true;
				wrap.fieldAPI = fieldApiLst[0];
				wrap.fieldLabel =fieldApiLst[1];
				wrapLst.add(wrap);
			}
			objWrap.wrapRecdsList = wrapLst;
			return objWrap;
		}catch(Exception e){
			system.debug('>>>'+e.getLineNumber()+'>>>'+e.getMessage());
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method copy agreement data to Agreement 
* @Param		string - agreementId, string - objectAPIName
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getDataToClone(string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static List<wrapper> getDataToClone(string recordId,string objAPI){
		try{
			List<CLM_AgreemntFieldsToCopy__c> fieldsLst = [SELECT id,AgreementFieldAPI__c, AgreementFieldLabel__c, order__c,Name 
														   FROM CLM_AgreemntFieldsToCopy__c order by order__c ];
			
			List<string> fields = new List<string>(); 
			String soqlQuery = 'select Id,Name,RecordType.Name, ';
			for(CLM_AgreemntFieldsToCopy__c fld:fieldsLst){
				soqlQuery +=fld.AgreementFieldAPI__c+',';
			}
			soqlQuery = soqlQuery.substring(0, soqlQuery.length() - 1);
			soqlQuery += ' FROM '+objAPI+'  WHERE Id=:recordId';
			Sobject objRec = database.query(soqlQuery);
			
			Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
			Schema.SObjectType objSchema = schemaMap.get(objAPI);
			Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
			
			List<wrapper> wrapLst = new List<wrapper>();
			wrapper wrap = new wrapper();
			for(CLM_AgreemntFieldsToCopy__c fld:fieldsLst){
				wrap = new wrapper();
				if(fld.AgreementFieldAPI__c == 'Apttus__Status__c'){
					wrap.fieldValue = 'Submitted Request';  
				}else{
					wrap.fieldValue = string.valueOf(objRec.get(fld.AgreementFieldAPI__c));
				}
				
				wrap.fieldId = fld.AgreementFieldLabel__c+'Field';
				wrap.disable = string.isNotBlank(string.valueOf(objRec.get(fld.AgreementFieldAPI__c))) ? true : false;
				wrap.fieldAPI = fld.AgreementFieldAPI__c;
				wrap.fieldLabel = fld.AgreementFieldLabel__c;
				wrap.fieldType = string.ValueOf(fieldMap.get(fld.AgreementFieldAPI__c).getDescribe().getType());
				wrapLst.add(wrap);
			}
			return wrapLst;
		}catch(Exception e){
			//system.debug('>>>'+e.getLineNumber()+'>>>'+e.getMessage());
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method check user has permissions or not
* @Param		
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.checkCustomPermission(string, string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static permissionWrapper checkCustomPermission(){
		permissionWrapper wrap = new permissionWrapper();
		
		String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
		wrap.hasAMPermission = FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_AM_Permission);
		wrap.hasCCMPernission =FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_CM_Permission);
		wrap.isSysAdmin = (profileName == 'System Administrator') ? true : false;
		
		return wrap;
	}
	
	/**************************************************************************************
* @Description  This method copy Agreement team data to newely created Agreement 
* @Param		string - agreementId, string - parentAgreementId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.createAgrmntTeam(string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static void createAgrmntTeam(string agrmntId, string parentAgrmntId){
		try{
			List<CLM_Agreement_Team__c> agrmntTeamLst = [SELECT Id,CLM_Team_Member_Role__c,CLM_Agreement__c, CLM_Agreement_Access__c ,
														 CLM_Team_Member__c  
														 FROM CLM_Agreement_Team__c 
														 WHERE CLM_Agreement__c =:parentAgrmntId];
			List<CLM_Agreement_Team__c> agrmntTLst = new List<CLM_Agreement_Team__c>();
			CLM_Agreement_Team__c t = new CLM_Agreement_Team__c();
			for(CLM_Agreement_Team__c team:agrmntTeamLst){
				t = new CLM_Agreement_Team__c();
				t.CLM_Team_Member_Role__c = team.CLM_Team_Member_Role__c;
				t.CLM_Agreement_Access__c = team.CLM_Agreement_Access__c;
				t.CLM_Team_Member__c =  team.CLM_Team_Member__c;
				t.CLM_Agreement__c = agrmntId;
				agrmntTLst.add(t);
			}
			if(!agrmntTLst.isEmpty()){
				insert agrmntTLst;
			}
		}catch(Exception e){
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method will fetch the required fields for the object
* @Param		string - recordId, string - requestType, string - objectAPIName
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getRequiredFields(string, string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static List<wrapper> getRequiredFields(string recordId, string requestType, string objectAPI, string objDetails){
		try{
			Map<string,CLM_RequiredFields__c> reqFldMap = new Map<string,CLM_RequiredFields__c>();
			Set<string> requiredFields = new Set<string>();
			List<CLM_RequiredFields__c> reqFieldsCS = new List<CLM_RequiredFields__c>();
			Apttus__APTS_Agreement__c agrmntRec = new Apttus__APTS_Agreement__c();
			if(objectAPI == CLM_GlobalConstants.agrmntAPIName){
				agrmntRec = (Apttus__APTS_Agreement__c) JSON.deserialize(objDetails, Apttus__APTS_Agreement__c.class);
			}
			if(objectAPI == CLM_GlobalConstants.agrmntAPIName && requestType == 'SubmitRequest'){
				
				
				reqFieldsCS = [SELECT Id,FieldAPI__c, Action__c, FieldLabel__c, DependentField__c, 
							   DependentCondition__c, DependentValue__c, ObjectAPI__c, Name, DependentCombination__c 
							   FROM CLM_RequiredFields__c 
							   WHERE ObjectAPI__c= :objectAPI 
							   AND Action__c=:requestType  AND Active__c= true AND Type_of_Request__c =:agrmntRec.CLM_Contract_Category__c order by Name];
				
			}else{
				reqFieldsCS = [SELECT Id,FieldAPI__c, Action__c, FieldLabel__c, DependentField__c, 
							   DependentCondition__c, DependentValue__c, ObjectAPI__c, Name, DependentCombination__c 
							   FROM CLM_RequiredFields__c 
							   WHERE ObjectAPI__c= :objectAPI 
							   AND Action__c=:requestType  AND Active__c= true order by Name];
			}
			set<string> parentIds = new set<string>();
			if(string.isNotblank(agrmntRec.Apttus__Parent_Agreement__c) && agrmntRec.Apttus__Subtype__c == 'Amendment'){
				parentIds.add(agrmntRec.Apttus__Parent_Agreement__c);
			}
			Map<Id,Apttus__APTS_Agreement__c> parentAgrmntMap = new Map<Id,Apttus__APTS_Agreement__c>();
			if(!parentIds.isEmpty()){
				parentAgrmntMap = new Map<Id,Apttus__APTS_Agreement__c>([SELECT Id,Apttus__Subtype__c 
																		 FROM Apttus__APTS_Agreement__c
																		 WHERE Id IN:parentIds]);
			}
			for(CLM_RequiredFields__c reqFld:reqFieldsCS){
				reqFldMap.put(reqFld.FieldAPI__c,reqFld);
			}
			
			requiredFields = reqFldMap.keySet(); 
			String soqlQuery = 'select Id, RecordTypeId, ';
			if(objectAPI == CLM_GlobalConstants.agrmntAPIName){
				soqlQuery +='CLM_Ready_for_Activation__c, Apttus__Subtype__c,';
				if(requestType == 'ActivateRequest' || requestType == 'ActivateFrameRequest'){
					soqlQuery +='APTS_Ext_ID__c,Apttus__Perpetual__c,Apttus__Parent_Agreement__c,Apttus__Parent_Agreement__r.Apttus__Subtype__c,';
				}else{
					soqlQuery +='Apttus__Related_Opportunity__c,  CLM_Contract_Request_Type__c, CLM_Prospect_Account__c,Apttus__Perpetual__c,';
				}
			}
			
			for(string s:requiredFields){
				soqlQuery +=s+',';
			}
			soqlQuery = soqlQuery.substring(0, soqlQuery.length() - 1);
			soqlQuery += ' FROM '+objectAPI +' WHERE Id=:recordId';
			Sobject objRec = database.query(soqlQuery);
			List<wrapper> wrapLst = new List<wrapper>();
			wrapper wrap = new wrapper();
			CLM_RequiredFields__c csRec = new CLM_RequiredFields__c();
			List<string> valComp = new List<string>();
			
			Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
			Schema.SObjectType objSchema = schemaMap.get(objectAPI);
			Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
			
			for(string s:requiredFields){
				wrap = new wrapper();
				csRec = reqFldMap.containsKey(s) ? reqFldMap.get(s) : new CLM_RequiredFields__c();
				if(string.isNotBlank(string.valueOf(objRec.get(s))) && (requestType == 'ActivateRequest' || requestType == 'ActivateFrameRequest')
				   && objRec.get('CLM_Ready_for_Activation__c') == false){
					   if( string.IsBlank(csRec.DependentField__c)
		 || (string.IsNotBlank(csRec.DependentField__c) && string.isBlank(string.valueOf(objRec.get(csRec.DependentField__c)))) ){
						   wrap.fieldAPI = s;
						   wrap.fieldLabel = csRec.FieldLabel__c;
						   wrap.fieldValue = string.valueOf(objRec.get(s));
						   wrapLst.add(wrap);
					   }
					   
				   }else if(string.isBlank(string.valueOf(objRec.get(s))) ){
					   if(string.IsBlank(csRec.DependentField__c)){
						   wrap.fieldAPI = s;
						   wrap.fieldLabel = csRec.FieldLabel__c;
						   wrapLst.add(wrap); 
					   }else{
						   if(csRec.DependentCondition__c == CLM_GlobalConstants.Equal_To){
							   if((csRec.DependentValue__c).contains(';')){
								   valComp = csRec.DependentValue__c.split(';');
								   if(valComp.Contains(string.ValueOf(objRec.get(csRec.DependentField__c)))){
									   wrap.fieldAPI = s;
									   wrap.fieldLabel = csRec.FieldLabel__c;
									   wrapLst.add(wrap);
								   }
							   }else{
								   
								   if(csRec.DependentCombination__c == 'OR'){
									   wrap.fieldAPI = s;
									   wrap.fieldLabel = csRec.FieldLabel__c;
									   wrapLst.add(wrap);
									   if((csRec.DependentValue__c == 'Null' && string.isNotBlank(string.ValueOf(objRec.get(csRec.DependentField__c)))) 
										  || (csRec.DependentValue__c != 'Null' &&(string.ValueOf(objRec.get(csRec.DependentField__c)) != csRec.DependentValue__c))){
											  for ( Integer i = wrapLst.size() - 1; i >= 0; --i ){
												  wrapper wr=wrapLst[i];
												  if (wr.fieldAPI== csRec.FieldAPI__c){
													  wrapLst.remove(i);
												  }
											  }
										  }
								   }else if(csRec.DependentCombination__c == 'AND'
		   && ((csRec.DependentValue__c == 'Null' && string.isBlank(string.ValueOf(objRec.get(csRec.DependentField__c)))) 
										  || (csRec.DependentValue__c != 'Null' &&(string.ValueOf(objRec.get(csRec.DependentField__c)) == csRec.DependentValue__c)))){
									  
											  wrap.fieldAPI = s;
											  wrap.fieldLabel = csRec.FieldLabel__c;
											  wrapLst.add(wrap);
										
								   }
							   }
						   }
						   
						   if((csRec.DependentCondition__c == CLM_GlobalConstants.Not_EqualTo)
							  && ((csRec.DependentValue__c == 'Null' && string.isNotBlank(string.ValueOf(objRec.get(csRec.DependentField__c)))) || (csRec.DependentValue__c != 'Null' &&(string.ValueOf(objRec.get(csRec.DependentField__c)) != csRec.DependentValue__c)))){
								  wrap.fieldAPI = s;
								  wrap.fieldLabel = csRec.FieldLabel__c;
								  wrapLst.add(wrap);
							  }
					   }
				   }
				
			}
			
			if(objectAPI == CLM_GlobalConstants.agrmntAPIName){
				if (requestType == 'SubmitRequest' || requestType == 'NDASubmitRequest'){
					List<CLM_Agreement_Team__c> agrmntTeamLst = [SELECT Id,CLM_Team_Member_Role__c,CLM_Agreement__c 
																 FROM CLM_Agreement_Team__c 
																 WHERE CLM_Agreement__c =:recordId AND CLM_Team_Member_Role__c =:CLM_GlobalConstants.CMRole];
					if(agrmntTeamLst.isEmpty()){
						wrapper wrap1 = new wrapper();
						wrap1.fieldLabel = Label.CLM_AgrmtTeam_CMCntrctMangrMsg;
						wrapLst.add(wrap1);
					}
				}
				if(requestType == 'ActivateRequest' || requestType == 'ActivateFrameRequest'){
					for ( Integer i = wrapLst.size() - 1; i >= 0; --i ){
						wrapper wr=wrapLst[i];
						wr.fieldId = wr.fieldLabel+'Id';
						Schema.SObjectField field = fieldMap.get(wr.fieldAPI);
						wr.fieldType = string.valueOf(field.getDescribe().getType());
						
						if(wr.fieldAPI == 'Apttus__Related_Opportunity__c' || wr.fieldAPI == 'End_Customer__c'){ 
							if(wr.fieldAPI == 'Apttus__Related_Opportunity__c' 
							   &&(( Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(string.valueOf(objRec.get('RecordTypeId'))).getName() == 'Supply and Services Agreement' 
								   && objRec.get('Apttus__Subtype__c') == 'Amendment' 
								   && objRec.get('Apttus__Parent_Agreement__c') != null
								   && parentAgrmntMap.containsKey(Id.valueOf(string.valueOf(objRec.get('Apttus__Parent_Agreement__c')))) 
								   && (parentAgrmntMap.get(Id.valueOf(string.valueOf(objRec.get('Apttus__Parent_Agreement__c')))).Apttus__Subtype__c == 'Partner Agreement (GPP)'))
								  || objRec.get('Apttus__Subtype__c') == 'Partner Agreement (GPP)')){
									  wrapLst.remove(i);
								  }else if(objRec.get('Apttus__Subtype__c') == 'Partner Agreement (GPP)'){
									  wrapLst.remove(i);
								  }
						}
					}
				}
			}
			if(objectAPI == CLM_GlobalConstants.optyAPIName){
				List<OpportunityTeamMember> optyTeamMem = [SELECT Id,TeamMemberRole,OpportunityAccessLevel,UserId 
														   FROM OpportunityTeamMember
														   WHERE OpportunityId=:recordId AND TeamMemberRole=:CLM_GlobalConstants.CMRole];
				if(optyTeamMem.isEmpty()){
					wrapper wrap2 = new wrapper();
					wrap2.fieldLabel = Label.CLM_OptyTeam_CMCntrctMangrMsg;
					wrapLst.add(wrap2);
				}
			}
			
			return wrapLst;
		}catch(Exception e){
			system.debug('>>55555>'+e.getLineNumber()+'>>55555>'+e.getMessage());
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method will get the Non-Sales User Profile users list
* @Param		string - accountId, string - recordId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getCMUsersLst(string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static List<User> getCMUsersLst(string accId, string recId){
		try{
			
			List<ObjectTerritory2Association> objTerrRec = [SELECT Id,AssociationCause, SobjectType,Territory2Id,Territory2.Name, ObjectId  
															FROM ObjectTerritory2Association WHERE ObjectId =:accId limit 1];
			if(!objTerrRec.isEmpty()){
				Set<string> assocIds = new Set<string>();
				for(ObjectTerritory2Association terrAssoc:objTerrRec){
					assocIds.add(terrAssoc.Territory2Id);
				}
				List<UserTerritory2Association> userAssociLst = [SELECT Id,UserId, User.Name,Territory2Id,RoleInTerritory2  
																 FROM UserTerritory2Association 
																 WHERE Territory2Id IN:assocIds and IsActive =true ];
				List<string> userIds = new List<string>();
				for(UserTerritory2Association uAsco:userAssociLst){
					if(String.IsNotBlank(uAsco.RoleInTerritory2) && (uAsco.RoleInTerritory2).contains('L&C')){
						userIds.add(uAsco.UserId);
					}
				}
				List<User> userLst = new List<User>();
				if(!userIds.isEmpty()){
					
					userLst = [SELECT Id ,Name ,Market__c ,Title ,Country__c 
							   FROM User 
							   WHERE Profile.Name =:CLM_GlobalConstants.CMProfileName 
							   AND Id IN:userIds AND IsActive= true];
				}
				return userLst;
			}else{
				return new List<user>();
			}
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method will get the recordTypeId based on name
* @Param		string - recordTtypeName, string - objectAPIName
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getRecordTypeInfo(string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static string getRecordTypeInfo(string recrdTypeName, string objectApiName){
		return Schema.getGlobalDescribe().get(objectApiName).getDescribe().getRecordTypeInfosByDeveloperName().get(recrdTypeName).getRecordTypeId();
	}
	
	/**************************************************************************************
* @Description  This method will create agreement team records 
* @Param		string - userId, string - recordId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.createAgreementTeamRecd(string, string)
**************************************************************************************/ 
	
	@AuraEnabled
	public static userSearchWrapper createAgreementTeamRecd(string userId,string recordId){
		try{
			userSearchWrapper wrap = new userSearchWrapper();
			if(String.ValueOf((Id.ValueOf(recordId)).getsobjectType()) == CLM_GlobalConstants.optyAPIName){
				List<OpportunityTeamMember> optyTeamMem = [SELECT Id,TeamMemberRole,OpportunityAccessLevel,UserId 
														   FROM OpportunityTeamMember
														   WHERE OpportunityId=:recordId AND TeamMemberRole=:CLM_GlobalConstants.CMRole];
				if(!optyTeamMem.isEmpty() ){
					wrap.message = Label.CLM_OptyTeam_ExistingCMCntrctMangr;
				}else{
					OpportunityTeamMember opptyTeamMemberVar = new OpportunityTeamMember();
					opptyTeamMemberVar.OpportunityId = recordId;
					opptyTeamMemberVar.TeamMemberRole = CLM_GlobalConstants.CMRole;
					opptyTeamMemberVar.OpportunityAccessLevel = CLM_GlobalConstants.Access_Read;
					opptyTeamMemberVar.UserId = userId;
					insert opptyTeamMemberVar;
					wrap.message = 'SUCCESS';
					wrap.opportunityTeamRec = opptyTeamMemberVar;
				}
			}else{
				List<CLM_Agreement_Team__c> agrmntTeamLst = [SELECT Id,CLM_Team_Member_Role__c,CLM_Agreement__c FROM CLM_Agreement_Team__c 
															 WHERE CLM_Agreement__c =:recordId AND CLM_Team_Member_Role__c =:CLM_GlobalConstants.CMRole];
				if(!agrmntTeamLst.isEmpty() ){
					wrap.message = Label.CLM_AgrmtTeam_ExistingCMCntrctMangr;
				}else{
					CLM_Agreement_Team__c team = new CLM_Agreement_Team__c();
					team.CLM_Team_Member_Role__c = CLM_GlobalConstants.CMRole;
					team.CLM_Agreement__c = recordId;
					team.CLM_Team_Member__c = userId;
					team.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_ReadWrite;
					insert team;
					wrap.message = 'SUCCESS';
					wrap.agrmentTeamRec = team;
				}
			}
			return wrap;
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method will creat Agreement Team record
* @Param		string - optyId, string - agreementId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.createAgrmntTeamFromOpty(string, string)
**************************************************************************************/
	
	@AuraEnabled
	public static void createAgrmntTeamFromOpty(string optyId, string agrmntId){
		try{
			List<OpportunityTeamMember> optyTeamMem = [SELECT Id,TeamMemberRole,OpportunityAccessLevel,UserId 
													   FROM OpportunityTeamMember
													   WHERE OpportunityId=:optyId AND TeamMemberRole=:CLM_GlobalConstants.CMRole limit 1];
			
			if(!optyTeamMem.isEmpty()){
				CLM_Agreement_Team__c team = new CLM_Agreement_Team__c();
				team.CLM_Team_Member_Role__c = CLM_GlobalConstants.CMRole;
				team.CLM_Agreement__c = agrmntId;
				team.CLM_Team_Member__c = optyTeamMem[0].UserId;
				team.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_ReadWrite;
				insert team;
			}
		}catch(Exception e){
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	/**************************************************************************************
* @Description  This method will retrieve L2D Answer records
* @Param		string - clauseId, string - triggerId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getL2DAnswers(string, string)
**************************************************************************************/
	@AuraEnabled
	public static List<L2D_Trigger_Answer__c> getL2DAnswers(string clauseId, string triggerId){
		List<L2D_Trigger_Answer__c> answsLst = [SELECT Id,Answer__c, Help__c, L2D_Trigger__c, Level__c, L2D_Trigger__r.Name 
												FROM L2D_Trigger_Answer__c
												WHERE L2D_Trigger__c=:triggerId];
		return answsLst;
	}
	/**************************************************************************************
* @Description  This method will update clause Record with L2D Answer
* @Param		string - L2DanswerRec, string - clauseId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.saveTriggerAnswer(string, string)
**************************************************************************************/
	@AuraEnabled
	public static void saveTriggerAnswer(string answRec, string recordId){
		L2D_Trigger_Answer__c answRecd = (L2D_Trigger_Answer__c) JSON.deserialize(answRec, L2D_Trigger_Answer__c.class);
		if(String.ValueOf((Id.ValueOf(recordId)).getsobjectType()) == CLM_GlobalConstants.agrmntClauseAPIName){
			Apttus__Agreement_Clause__c clauseRec = new Apttus__Agreement_Clause__c();
			clauseRec.Id = recordId;
			clauseRec.CLM_L2D_Trigger_Answer__c = String.isNotBlank(answRecd.Answer__c) ? answRecd.Answer__c : '';
			clauseRec.CLM_Help__c = String.isNotBlank(answRecd.Help__c) ? answRecd.Help__c : '';
			clauseRec.CLM_Level__c = String.isNotBlank(answRecd.Level__c) ? answRecd.Level__c : '';
			update clauseRec; 
		}
	}
	/**************************************************************************************
* @Description  This method will update clause Record with Non L2d Answer
* @Param		string - answer, string - clauseId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.saveNonL2DTriggerAnswer(string, string)
**************************************************************************************/
	@AuraEnabled
	public static void saveNonL2DTriggerAnswer(string answer, string recordId){
		Apttus__Agreement_Clause__c clauseRec = new Apttus__Agreement_Clause__c();
		clauseRec.Id = recordId;
		clauseRec.CLM_L2D_Trigger_Answer__c = answer;
		update clauseRec; 
		
	}
	/**************************************************************************************
* @Description  This method will retrieve clause Record
* @Param		string - clauseId
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getNonL2DAnswer(string)
**************************************************************************************/ 
	@AuraEnabled
	public static Apttus__Agreement_Clause__c getNonL2DAnswer(string recordId){
		Apttus__Agreement_Clause__c clauseRec = [SELECT Id,CLM_L2D_Trigger_Answer__c ,Apttus__Clause__c,Apttus__Text__c
												 FROM Apttus__Agreement_Clause__c WHERE ID=:recordId]; 
		return clauseRec; 
	}
	/**************************************************************************************
* @Description  This method will update Existing contract Request with current record Id and its opportunity ID
* @Param		string - currentAgreementId, string - ExistingAgreementId, string- opportunity Id
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.updateExistingCtrct(string, string, string)
**************************************************************************************/
	@AuraEnabled
	public static void updateExistingCtrct(string curRecId, string existRecId, string optyId){
		Apttus__APTS_Agreement__c agrmnt = new Apttus__APTS_Agreement__c();
		agrmnt.Id = existRecId;
		agrmnt.CLM_Reference_Contract_Request__c = curRecId;
		update agrmnt;
	}
	/**************************************************************************************
* @Description  This method will share Agreement record with Territory User Group
* @Param		Map<Id, Apttus__APTS_Agreement__c> - agrmntMap, Map<Id,Id> - agrmntAcctMap
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.AgrmntTerritorySharing(Map<Id, Apttus__APTS_Agreement__c>, Map<Id,Id>)
*************************************************************************************/
	public static void AgrmntTerritorySharing(Map<Id, Apttus__APTS_Agreement__c> newAgrmntMap, Map<Id,Id> agrmntAcctMap){
		try{
			Map<Id,Id> Acct_tername_map = new Map<Id,Id>();
			Map<Id,Id> ter_grp_map = new Map<Id,Id>();
			Map<Id,Id> Acct_grp_map = new Map<Id,Id>();
			List<Apttus__APTS_Agreement__Share> agrmntShareLst = new List<Apttus__APTS_Agreement__Share>();
			if(!agrmntAcctMap.isEmpty()){
				for(objectTerritory2Association obta : [SELECT objectId, Territory2Id, Territory2.developername 
														FROM objectTerritory2Association 
														WHERE objectId in :agrmntAcctMap.values()]){
															Acct_tername_map.put(obta.objectId, obta.Territory2Id);
														}
				
			}
			if(!Acct_tername_map.isEmpty()){
				for(group grp: [SELECT DeveloperName,Id,RelatedId,Type 
								FROM Group 
								WHERE Type = 'territory' and RelatedId in : Acct_tername_map.values()]){
									ter_grp_map.put(grp.RelatedId, grp.Id);
								}
			}
			
			if(!Acct_tername_map.isEmpty()){
				for(Id acc : Acct_tername_map.keyset()){
					if(ter_grp_map.containsKey(Acct_tername_map.get(acc))){
						Acct_grp_map.put(acc, ter_grp_map.get(Acct_tername_map.get(acc)));
					}
				}
			}
			Apttus__APTS_Agreement__Share agrmntshare = new Apttus__APTS_Agreement__Share();
			for(Apttus__APTS_Agreement__c agrmnt : newAgrmntMap.values()){
				if(Acct_grp_map.containsKey(agrmnt.Apttus__Account__c)){
					agrmntshare = new Apttus__APTS_Agreement__Share();
					agrmntshare.ParentId = agrmnt.Id;
					agrmntshare.AccessLevel = 'Read';
					agrmntshare.UserOrGroupId = Acct_grp_map.get(agrmnt.Apttus__Account__c);
					agrmntshare.RowCause = Schema.Apttus__APTS_Agreement__Share.RowCause.CLM_Agrmnt_Team_Sharing__c;
					agrmntShareLst.add(agrmntshare);
				}
			}
			database.insert(agrmntShareLst,false);
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());
		}
	}
	
	/**************************************************************************************
* @Description  This method will share Agreement record with Agreement Team on Insert
* @Param		List<CLM_Agreement_Team__c> - AgreementTeamList
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.agrmntSharingWithTeamOnInsert(List<CLM_Agreement_Team__c>)
**************************************************************************************/
	public static void agrmntSharingWithTeamOnInsert(List<CLM_Agreement_Team__c> newTeamLst){
		try{
			List<Apttus__APTS_Agreement__Share> agrmntShareLst = new List<Apttus__APTS_Agreement__Share>();
			Apttus__APTS_Agreement__Share agrmntshare = new Apttus__APTS_Agreement__Share();
			for(CLM_Agreement_Team__c teamRec:newTeamLst){
				agrmntshare = new Apttus__APTS_Agreement__Share();
				agrmntshare.ParentId = teamRec.CLM_Agreement__c;
				agrmntshare.AccessLevel = (teamRec.CLM_Agreement_Access__c == 'Read/Write') ? 'Edit' : 'Read';
				agrmntshare.UserOrGroupId = teamRec.CLM_Team_Member__c;
				agrmntshare.RowCause = Schema.Apttus__APTS_Agreement__Share.RowCause.CLM_Agrmnt_Team_Sharing__c;
				agrmntShareLst.add(agrmntshare);
			}
			if(!agrmntShareLst.isEmpty()){
				Database.insert(agrmntShareLst);
			}
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());
		}
	}
	
	/**************************************************************************************
* @Description  This method will share Agreement record with Agreement Team on update
* @Param		Map<Id,CLM_Agreement_Team__c> - AgreementTeamMap, List<CLM_Agreement_Team__c> - AgreementTeamNewLst
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.agrmntSharingWithTeamOnUpdate(Map<Id,CLM_Agreement_Team__c>,List<CLM_Agreement_Team__c>)
**************************************************************************************/
	public static void agrmntSharingWithTeamOnUpdate(Map<Id,CLM_Agreement_Team__c> teamOldMap, List<CLM_Agreement_Team__c> teamNewLst){
		try{
			CLM_Agreement_Team__c oldTeam = new CLM_Agreement_Team__c();
			List<CLM_Agreement_Team__c> eligibleTeamRecds = new List<CLM_Agreement_Team__c>();
			for(CLM_Agreement_Team__c rec:teamNewLst){
				oldTeam = teamOldMap.get(rec.Id);
				if(oldTeam.CLM_Agreement_Access__c != rec.CLM_Agreement_Access__c) {
					eligibleTeamRecds.add(rec);
				}
			}
			if(!eligibleTeamRecds.isEmpty()){
				agrmntSharingWithTeamOnInsert(eligibleTeamRecds);
			}
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());
		}
	}
	
	/**************************************************************************************
* @Description  This method will remove Agreement sharing while record delete from Agreement Team
* @Param		List<CLM_Agreement_Team__c> - AgreementteamLst
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.removeAgrmntSharingWithTeamOnDelete(List<CLM_Agreement_Team__c>)
**************************************************************************************/
	public static void removeAgrmntSharingWithTeamOnDelete(List<CLM_Agreement_Team__c> teamLst){
		try{
			List<string> userIds = new List<string>();
			Map<string,List<string>> userAgrmntMap = new Map<string,List<string>>();
			for(CLM_Agreement_Team__c teamRec:teamLst){
				if(userAgrmntMap.containsKey(teamRec.CLM_Agreement__c)){
					userIds = userAgrmntMap.get(teamRec.CLM_Agreement__c);  
					userIds.add(teamRec.CLM_Team_Member__c);
					userAgrmntMap.put(teamRec.CLM_Agreement__c, userIds);
				}else{
					userAgrmntMap.put(teamRec.CLM_Agreement__c, new List<string>{teamRec.CLM_Team_Member__c});
				}
			}
			if(!userAgrmntMap.isEmpty()){
				removeUserAccess(userAgrmntMap);
			}
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());
		} 
	}
	
	/**************************************************************************************
* @Description  This method will remove Agreement sharing while record delete from Agreement Team
* @Param		Map<string,List<string>> - userAgrmntMap
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.removeUserAccess(Map<string,List<string>>)
**************************************************************************************/
	public static void removeUserAccess(Map<string,List<string>> userAgrmntMap){
		try{
			Map<string,List<string>> agrmntTeamUserMap = new Map<string,List<string>>();
			List<Apttus__APTS_Agreement__Share> shareRecdLst = [SELECT Id,ParentId,UserOrGroupId 
																FROM Apttus__APTS_Agreement__Share
																WHERE ParentId IN:userAgrmntMap.KeySet()];
			List<Apttus__APTS_Agreement__Share> shrRecIdsToRemove = new List<Apttus__APTS_Agreement__Share>();
			List<string> shrRecIdsUsers = new List<string>();
			for(Apttus__APTS_Agreement__Share shr:shareRecdLst){
				if(userAgrmntMap.containsKey(shr.ParentId)){
					shrRecIdsUsers = userAgrmntMap.get(shr.ParentId);
					if(shrRecIdsUsers.contains(shr.UserOrGroupId)){
						shrRecIdsToRemove.add(shr);
					}
				}
			}
			if(!shrRecIdsToRemove.isEmpty()){
				delete shrRecIdsToRemove;
			}
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());
		}
	}
	
	
	/**************************************************************************************
* @Description  This method will create Agreement Team member
* @Param		List<CLM_Agreement_Team__c> - AgreementteamLst
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.creatAgrmntTeamRoles(List<CLM_Agreement_Team__c>)
**************************************************************************************/
	
	public static void creatAgrmntTeamRoles(List<Apttus__APTS_Agreement__c> agrmntNewList){
		try{
			List<CLM_Agreement_Team__c> agrmntTeamsLst = new List<CLM_Agreement_Team__c>();
			Map<Id,Apttus__APTS_Agreement__c> agrmntMap = new Map<Id,Apttus__APTS_Agreement__c>();
			Map<Id,Apttus__APTS_Agreement__c> agrmntTerRecMap = new Map<Id,Apttus__APTS_Agreement__c>();
			List<string> validRecordTypes = CLM_GlobalConstants.agreementRecordTypeNames;
			Map<Id,Id> agrmntActMap = new Map<Id,Id>();
			for(Apttus__APTS_Agreement__c agrmnt:agrmntNewList){
				if((validRecordTypes).contains(Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(agrmnt.RecordTypeId).getName())){
					agrmntMap.put(agrmnt.Id,agrmnt);
					if((string.isBlank(agrmnt.CLM_Restricted_Access__c)) || agrmnt.CLM_Restricted_Access__c == 'No' ){
						agrmntTerRecMap.put(agrmnt.Id,agrmnt);
						agrmntActMap.put(agrmnt.Id,agrmnt.Apttus__Account__c);
					}
				}
			}
			if(agrmntMap.size()>0){
				CLM_AgrmntCustomActionsCtrl.AgrmntTerritorySharing(agrmntTerRecMap,agrmntActMap);
				CLM_Agreement_Team__c  team = new CLM_Agreement_Team__c();
				for(Apttus__APTS_Agreement__c agrmnt:agrmntMap.Values()){
					if(agrmnt.Apttus__Status_Category__c == 'Request' && string.IsBlank(agrmnt.Apttus__Status__c) 
					   && String.IsNotBlank(agrmnt.Apttus__Requestor__c)){
						   team = new CLM_Agreement_Team__c();
						   team.CLM_Agreement__c = agrmnt.Id;
						   team.CLM_Agreement_Access__c  = FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_AM_Permission) ? CLM_GlobalConstants.Access_Read : (FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_CM_Permission) ? CLM_GlobalConstants.Access_ReadWrite : '');
							   team.CLM_Team_Member_Role__c = FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_AM_Permission) ? CLM_GlobalConstants.AMRole : (FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_CM_Permission) ? CLM_GlobalConstants.CMRole : '') ;
								   team.CLM_Team_Member__c =  agrmnt.Apttus__Requestor__c;
						   agrmntTeamsLst.add(team);
					   }
					
				}
				if(!agrmntTeamsLst.isEmpty()){
					insert agrmntTeamsLst;
				}
			}
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());  
		}
	}
	
	/**************************************************************************************
* @Description  This method will share Agreement with Agreement Team
* @Param		Map<Id,Apttus__APTS_Agreement__c> - agrmntNewMap,Map<Id,Apttus__APTS_Agreement__c> - agrmntOldMap
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.shreWithTeamWhenOwnerChange(Map<Id,Apttus__APTS_Agreement__c>,Map<Id,Apttus__APTS_Agreement__c>)
**************************************************************************************/
	
	public static void shreWithTeamWhenOwnerChange(Map<Id,Apttus__APTS_Agreement__c> agrmntNewMap, Map<Id,Apttus__APTS_Agreement__c> agrmntOldMap){
		try{
			Map<Id,Apttus__APTS_Agreement__c> agrmntMap = new Map<Id,Apttus__APTS_Agreement__c>(); 
			Apttus__APTS_Agreement__c oldAgrmnt = new Apttus__APTS_Agreement__c();
			List<string> validRecordTypes = CLM_GlobalConstants.agreementRecordTypeNames;
			Map<Id,Id> agrmntActMap = new Map<Id,Id>();
			for(Apttus__APTS_Agreement__c agrmnt:agrmntNewMap.Values()){
				if((validRecordTypes).contains(Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(agrmnt.RecordTypeId).getName())){
					oldAgrmnt = agrmntOldMap.get(agrmnt.Id);
					if(oldAgrmnt.OwnerId != agrmnt.OwnerId ){
						agrmntMap.put(agrmnt.Id,agrmnt);
						agrmntActMap.put(agrmnt.Id,agrmnt.Apttus__Account__c);
					}
				}
			}
			
			if(agrmntMap.size()>0){
				Map<string, List<CLM_Agreement_Team__c>> agrmntTeamRoleMap = new Map<string, List<CLM_Agreement_Team__c>>();
				List<CLM_Agreement_Team__c> agrmnTeamLst = new List<CLM_Agreement_Team__c>();
				List<CLM_Agreement_Team__c> roleLst = new List<CLM_Agreement_Team__c>();
				for(CLM_Agreement_Team__c teamRec:[SELECT Id,CLM_Team_Member_Role__c,CLM_Agreement__c,CLM_Team_Member__c FROM CLM_Agreement_Team__c 
												   WHERE CLM_Agreement__c IN:agrmntMap.KeySet()]){
													   
													   if(agrmntTeamRoleMap.containsKey(teamRec.CLM_Agreement__c)){
														   roleLst = agrmntTeamRoleMap.get(teamRec.CLM_Agreement__c);
														   roleLst.add(teamRec);
														   agrmntTeamRoleMap.put(teamRec.CLM_Agreement__c, roleLst);
													   }else{
														   agrmntTeamRoleMap.put(teamRec.CLM_Agreement__c, new List<CLM_Agreement_Team__c>{teamRec}); 
													   }				
												   }
				Apttus__APTS_Agreement__c oldAgrmnt2 = new Apttus__APTS_Agreement__c();
				for(Apttus__APTS_Agreement__c agrmnt:agrmntMap.values()){
					oldAgrmnt2 = agrmntOldMap.get(agrmnt.Id);
					if((oldAgrmnt2.OwnerId != agrmnt.OwnerId) && agrmntTeamRoleMap.containsKey(agrmnt.Id)){
						for(CLM_Agreement_Team__c teamRec:agrmntTeamRoleMap.get(agrmnt.Id)){
							teamRec.CLM_Agreement_Owner__c  = String.ValueOf((Id.ValueOf(agrmnt.OwnerId)).getsobjectType()) == CLM_GlobalConstants.groupAPIName ? CLM_GlobalConstants.queu_Val : CLM_GlobalConstants.User_Val;
							agrmnTeamLst.add(teamRec);
						}
					}
				}
				
				if(!agrmnTeamLst.isEmpty()){
					update agrmnTeamLst;
				}
			}
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage()); 
		}
	} 
	/**************************************************************************************
* @Description  This method will share Agreement  to territory and  Agreement Team Members based on CLM_Restricted_Access__c
* @Param		Map<Id,Apttus__APTS_Agreement__c> - agrmntNewMap,Map<Id,Apttus__APTS_Agreement__c> - agrmntOldMap
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.updateSharingBasedOnRestrictAccess(Map<Id,Apttus__APTS_Agreement__c>,Map<Id,Apttus__APTS_Agreement__c>)
**************************************************************************************/
	
	public static void updateSharingBasedOnRestrictAccess(Map<Id,Apttus__APTS_Agreement__c> agrmntNewMap, Map<Id,Apttus__APTS_Agreement__c> agrmntOldMap){
		try{
			Map<Id,Apttus__APTS_Agreement__c> agrmntRestrictMap = new Map<Id,Apttus__APTS_Agreement__c>(); 
			Map<Id,Apttus__APTS_Agreement__c> agrmntNonRestrictMap = new Map<Id,Apttus__APTS_Agreement__c>(); 
			Apttus__APTS_Agreement__c oldAgrmnt = new Apttus__APTS_Agreement__c();
			List<string> validRecordTypes = CLM_GlobalConstants.agreementRecordTypeNames;
			Map<Id,Id> agrmntActMap = new Map<Id,Id>();
			Map<Id,Id> agrmntNonActMap = new Map<Id,Id>();
			
			for(Apttus__APTS_Agreement__c agrmnt:agrmntNewMap.Values()){
				
				if((validRecordTypes).contains(Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(agrmnt.RecordTypeId).getName())){
					oldAgrmnt = agrmntOldMap.get(agrmnt.Id);
					
					if(oldAgrmnt.CLM_Restricted_Access__c  != agrmnt.CLM_Restricted_Access__c  ){
						if( string.isBlank(agrmnt.CLM_Restricted_Access__c) || agrmnt.CLM_Restricted_Access__c == 'No'){
							agrmntNonRestrictMap.put(agrmnt.Id,agrmnt);
							agrmntNonActMap.put(agrmnt.Id,agrmnt.Apttus__Account__c);
						}else{
							agrmntRestrictMap.put(agrmnt.Id,agrmnt);
							agrmntActMap.put(agrmnt.Id,agrmnt.Apttus__Account__c);
						}
					}
				}
			}
			
			if(!agrmntNonRestrictMap.isEmpty()){
				CLM_AgrmntCustomActionsCtrl.AgrmntTerritorySharing(agrmntNonRestrictMap,agrmntNonActMap);
			}
			if(!agrmntRestrictMap.isEmpty()){
				Map<Id,Id> Acct_tername_map = new Map<Id,Id>();
				set<Id> grpIds = new set<Id>();
				List<Apttus__APTS_Agreement__Share> agrmntShareLst = new List<Apttus__APTS_Agreement__Share>();
				
				for(objectTerritory2Association obta : [SELECT objectId, Territory2Id, Territory2.developername 
														FROM objectTerritory2Association 
														WHERE objectId in :agrmntActMap.values()]){
															Acct_tername_map.put(obta.objectId, obta.Territory2Id);
														}
				
				
				if(!Acct_tername_map.isEmpty()){
					for(group grp: [SELECT DeveloperName,Id,RelatedId,Type 
									FROM Group 
									WHERE Type = 'territory' AND RelatedId in : Acct_tername_map.values()]){
										grpIds.add(grp.Id);
									}
					
					List<Apttus__APTS_Agreement__Share> shrRecLst = [SELECT Id,ParentId, UserOrGroupId,UserOrGroup.Name,RowCause, AccessLevel 
																	 FROM Apttus__APTS_Agreement__Share 
																	 WHERE UserOrGroupId IN:grpIds];
					if(!shrRecLst.isEmpty()){
						delete shrRecLst;
					}
				}
			}
			
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());  
		}
	}
	/**************************************************************************************
* @Description  This method will get session Id
* @Param		void
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getSessionAndBaseUrl()
**************************************************************************************/
	
	@AuraEnabled
	public static sessionWrapper getSessionAndBaseUrl(){
		String sessionId = '';
		PageReference sessionIdPage = Page.CLM_SessionForXAuthorPage;
		String vfContent = sessionIdPage.getContent().toString();
		Integer startPosition = vfContent.indexOf('Start') + 'Start'.length(), endPosition = vfContent.indexOf('End');
		sessionId = vfContent.substring(startPosition, endPosition);
		sessionWrapper wrap = new sessionWrapper();
		wrap.session = sessionId;
		wrap.baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
		return wrap;
	} 
	
	/**************************************************************************************
* @Description  This method will create Non Transactional Agreement
* @Param		string - AgreementId, string - objectAPIName
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.createNonTranAgrmnt(string,string)
**************************************************************************************/  
	@AuraEnabled
	public static string createNonTranAgrmnt(string recordId,string objAPI){
		try{
			List<wrapper> wrapLst = getDataToClone(recordId,objAPI);
			sObject sObj = Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).newSObject();
			string recTypeName = getRecordTypeInfo('Frame_Agreement',objAPI);
			sObj.put('RecordTypeId', recTypeName);
			sObj.put('CLM_Related_Contract_Request__c', recordId);
			for(wrapper w:wrapLst){
				if(string.isNotblank(w.fieldValue)){
					if(w.fieldType == 'DATE'){
						sObj.put(w.fieldAPI, Date.ValueOf(w.fieldValue));
					}else if(w.fieldType == 'CURRENCY'){
						sObj.put(w.fieldAPI, Decimal.ValueOf(w.fieldValue));
					}else{
						sObj.put(w.fieldAPI, w.fieldValue);
					}
				}
			}
			insert sObj;
			return sObj.Id;
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());  
			throw new AuraHandledException(e.getMessage()); 
		}
	}
	
	/**************************************************************************************
* @Description  This method will check Requstor has AM permissionset or not
* @Param		
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.checkReqstrPermisn()
**************************************************************************************/ 
	public static set<string> checkReqstrPermisn(Set<string> reqIds){
		Set<string> userIds = new Set<string>(); 
		List<PermissionSetAssignment> permisAsgnmntLst = [SELECT AssigneeId,Assignee.Username,  PermissionSet.Name 
														  FROM PermissionSetAssignment 
														  WHERE PermissionSet.Name = 'CLM_Account_Manager'
														  AND Assignee.IsActive = true
														  AND AssigneeId IN:reqIds];
		for(PermissionSetAssignment rec:permisAsgnmntLst){
			userIds.add(rec.AssigneeId);
		}
		
		return userIds;
	}
	
	/**************************************************************************************
* @Description  This method will get userDetails
* @Param		set<string> - userIds
* @Return	   
* @Example	 
* CLM_AgrmntCustomActionsCtrl.getUserDetails(set<string>)
**************************************************************************************/  
	public static  Map<Id,user> getUserDetails(set<string> userIds){
		return new Map<Id,User>([SELECT Name,Email from User Where Id IN:userIds]);
	}
	
	@AuraEnabled
	public static Apttus__DocumentVersionDetail__c generateNDADoc(string agrmntObj, string accLegalName, string nokiaLegalName){
		try{
			Apttus__APTS_Agreement__c agrmntRec = (Apttus__APTS_Agreement__c) JSON.deserialize(agrmntObj, Apttus__APTS_Agreement__c.class);
			List<Apttus__APTS_Template__c> tempRecLst = new List<Apttus__APTS_Template__c>();
			Apttus__DocumentVersionDetail__c documentVersionDetail = new Apttus__DocumentVersionDetail__c();
			if(string.isNotBlank(agrmntRec.Apttus__Account__c)){
				tempRecLst = [SELECT Id,CLM_Associated_Entity__c FROM Apttus__APTS_Template__c WHERE CLM_Associated_Entity__r.Name =:accLegalName AND Apttus__IsActive__c = true AND Apttus__Agreement_Types__c = 'NDA' AND CLM_Associated_Entity__c != null limit 1];
			}
			if(tempRecLst.size() == 0 && string.isNotBlank(agrmntRec.Nokia_Legal_Entity_lookup__c)){
				tempRecLst = [SELECT Id,CLM_Associated_Entity__c FROM Apttus__APTS_Template__c WHERE CLM_Associated_Entity__r.Name =:nokiaLegalName AND Apttus__IsActive__c = true AND Apttus__Agreement_Types__c = 'NDA'  AND CLM_Associated_Entity__c != null limit 1]; 
			}
			if(tempRecLst.size()>0){
				String docAction = Apttus.AgreementGenerateController.ACTION_GENERATE;
				documentVersionDetail = Apttus.AgreementGenerateController.createDocVersionSO(agrmntRec.Id,tempRecLst[0].Id, docAction, 'PDF', 'GENERATE DOCUMENT');
			}
			return documentVersionDetail;
		}catch(Exception e){
			system.debug('>>5555>'+e.getLineNumber()+'>5555>>'+e.getMessage());  
			throw new AuraHandledException(e.getMessage()); 
		}
		
	}
	
	public string agrId;
	public string docVerId;
	public string docVertempId;
	public CLM_AgrmntCustomActionsCtrl (ApexPages.StandardController controller){
		agrId = Apexpages.currentPage().getParameters().get('Id');
		docVerId = Apexpages.currentPage().getParameters().get('docVersionId');
		docVertempId = Apexpages.currentPage().getParameters().get('docVersTempId');
	}
	
	public PageReference generateDocument(){
		Apttus__DocumentVersion__c vers = [SELECT Id,Apttus__TemplateId__c FROM Apttus__DocumentVersion__c WHERE Id=:docVertempId];
		String apiServerURL = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/14.0/' + UserInfo.getOrganizationId();
		String SessionId = UserInfo.getSessionId(); 
		Apttus.AgreementGenerateController agreementController = new Apttus.AgreementGenerateController(new ApexPages.StandardController(new Apttus__APTS_Agreement__c(Id=agrId)));   
		agreementController.generateDoc(vers.Apttus__TemplateId__c,   CLM_GlobalConstants.pLevel,  'PDF', false, docVerId, SessionId, apiServerURL);
		Apttus__APTS_Agreement__c agrmntRec = new Apttus__APTS_Agreement__c();
		agrmntRec.Id = agrId;
		agrmntRec.Apttus__Status__c = 'Ready for Signatures';
		agrmntRec.Apttus__Status_Category__c = 'In Signatures';  
		update agrmntRec;
		return new PageReference('/'+agrId);
	}
	
	Public static void checkAgrmntQualificationForNDA(Map<Id,Apttus__APTS_Agreement__c> newAgrmntMap){
		Map<string,string> agrmntSourceMap = new Map<string,string>();
		Set<string> legalEntitySet = new Set<string>();
		Set<string> ndaAgrmntIds = new Set<string>();
		for(Apttus__APTS_Agreement__c agrmnt:newAgrmntMap.values()){
			if(Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(agrmnt.RecordTypeId).getName() == 'NDA' ){
				ndaAgrmntIds.add(agrmnt.Id);
				if(string.isNotBlank(agrmnt.Nokia_Legal_Entity_lookup__c)){
					legalEntitySet.add(agrmnt.Nokia_Legal_Entity_lookup__c);
				}
				if(string.isNotBlank(agrmnt.Apttus__Account__c)){
					legalEntitySet.add(agrmnt.Apttus__Account__c);
				}
			}
		}
		
		
		if(ndaAgrmntIds.size()>0){
			List<echosign_dev1__SIGN_Agreement__c> dicRecLst = [SELECT Id,Apttus_Echosign__Apttus_Agreement__c,echosign_dev1__Sender_Recorded__c FROM echosign_dev1__SIGN_Agreement__c 
																WHERE Apttus_Echosign__Apttus_Agreement__c IN:ndaAgrmntIds
																AND echosign_dev1__Status__c = 'Signed'];
			if(!dicRecLst.isEmpty()){
				Apttus__APTS_Agreement__c agr = new Apttus__APTS_Agreement__c();
				for(echosign_dev1__SIGN_Agreement__c rec:dicRecLst){
					if(newAgrmntMap.containsKey(rec.Apttus_Echosign__Apttus_Agreement__c)){
						agr = newAgrmntMap.get(rec.Apttus_Echosign__Apttus_Agreement__c);
						agr.Apttus__Activated_By__c = rec.echosign_dev1__Sender_Recorded__c;
					}
				}
			}
		}
		if(legalEntitySet.size()>0){
			Map<Id,Account> accRecdsMap = new Map<Id,Account>([SELECT Id,Name FROM Account WHERE Id IN:legalEntitySet]);
			set<string> entityTemplateSet = new set<string>();
			for(Apttus__APTS_Template__c tempRec: [SELECT Id,CLM_Associated_Entity__c,CLM_Associated_Entity__r.Name FROM Apttus__APTS_Template__c WHERE Apttus__IsActive__c = true AND Apttus__Agreement_Types__c = 'NDA' AND CLM_Associated_Entity__c != null]){
				entityTemplateSet.add((tempRec.CLM_Associated_Entity__r.Name).toLowerCase());
			}
			for(Apttus__APTS_Agreement__c agrmnt:newAgrmntMap.values()){
				if(Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(agrmnt.RecordTypeId).getName() == 'NDA' ){
					
					if(string.IsNotBlank(agrmnt.Apttus__Account__c) && accRecdsMap.containskey(agrmnt.Apttus__Account__c) 
					   && entityTemplateSet.contains((accRecdsMap.get(agrmnt.Apttus__Account__c).Name).toLowerCase())){
						   agrmnt.CLM_Qualifies_for_Self_Service__c = 'Yes';
					   }else if(string.IsNotBlank(agrmnt.Nokia_Legal_Entity_lookup__c) 
								&& accRecdsMap.containskey(agrmnt.Nokia_Legal_Entity_lookup__c) 
								&& entityTemplateSet.contains((accRecdsMap.get(agrmnt.Nokia_Legal_Entity_lookup__c).Name).toLowerCase())){
									agrmnt.CLM_Qualifies_for_Self_Service__c = 'Yes';
									agrmnt.CLM_Term_Years__c = (!agrmnt.Apttus__Perpetual__c && string.isBlank(agrmnt.CLM_Term_Years__c)) ? string.valueOf(3) : agrmnt.CLM_Term_Years__c;
								}else{
									agrmnt.CLM_Qualifies_for_Self_Service__c = 'No';
								}
					
				}
			}
		}
	}
	
	@AuraEnabled
	public static string getDefaultAccountFromHierarchy(string accId){
		
		Account actRec = [SELECT Id,RecordType.Name FROM Account WHERE Id=:accId];
		String defaultAccId = '';
		if(actRec.RecordType.Name == 'Legal Entity'){
			defaultAccId = accId;
		}else{
			List<Account> hierarchyList = [SELECT Name,RecordType.Name, Id,Active__c,Default_Legal_Entity__c 
										   FROM Account 
										   WHERE ParentId =:accId 
										   AND Default_Legal_Entity__c = true
										   AND Active__c = true];
			if(!hierarchyList.isEmpty()){
				for(Account hierarchyRec:hierarchyList){
					if(hierarchyRec.Active__c 
					   && hierarchyRec.Default_Legal_Entity__c){
						   defaultAccId = hierarchyRec.Id;
					   }
				}
			}
		}
		return defaultAccId;
	}
	
	@future(callout =true)
	public static void activateNDAAgrmnt(string jsonString){
		Apttus__APTS_Agreement__c agrmnt = (Apttus__APTS_Agreement__c) JSON.deserialize(jsonString, Apttus__APTS_Agreement__c.class);
		List<String> activateDocIds = new List<String>();
		List<String> remDocIds = new List<String>(); 
		
		if(Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(agrmnt.RecordTypeId).getName() == 'NDA' 
		   && agrmnt.Apttus__Status__c == CLM_GlobalConstants.fullSignedSts){
			   Map<string,Apttus__DocumentVersionDetail__c> docDetAgrmntMap = new Map<string,Apttus__DocumentVersionDetail__c>();
			   Map<string,Apttus__DocumentVersion__c> docAgrmntMap = new Map<string,Apttus__DocumentVersion__c>();
			   Map<Id,Apttus__DocumentVersion__c> docLst = new Map<Id,Apttus__DocumentVersion__c> ([SELECT Id,Apttus__AgreementId__c FROM Apttus__DocumentVersion__c
																									WHERE Apttus__AgreementId__c =:agrmnt.Id
																									AND Apttus__DocumentType__c = 'Executed Document']);
			   if(!docLst.isEmpty()){
				   List<Apttus__DocumentVersionDetail__c> docDetailLst = [SELECT Id,Apttus__ContentId__c,Apttus__DocumentVersionId__c
																		  FROM Apttus__DocumentVersionDetail__c
																		  WHERE Apttus__DocumentVersionId__c IN:docLst.keySet()];
				   
				   if(!docDetailLst.isEmpty()){
					   for(Apttus__DocumentVersionDetail__c rec:docDetailLst){
						   docDetAgrmntMap.put(rec.Apttus__DocumentVersionId__c,rec);
					   }
					   for(Apttus__DocumentVersion__c rec:docLst.values()){
						   docAgrmntMap.put(rec.Apttus__AgreementId__c,rec);
					   }
					   activateDocIds.add(docDetAgrmntMap.get((docAgrmntMap.get(agrmnt.Id).Id)).Apttus__ContentId__c);
					   System.enqueueJob(new CLM_AgrmntActivationCtrl(agrmnt.Id, activateDocIds, remDocIds));
				   }
			   }
		   }
	}
	
	public static void checkActivationEligibility(List<Apttus__APTS_Agreement__c> agrmntRecLst){
		List<string> validRecordTypes = CLM_GlobalConstants.activationRecordTypes;
		List<CLM_RequiredFields__c> reqFieldLst = [SELECT Id,FieldAPI__c, Action__c, FieldLabel__c, DependentField__c, 
												   DependentCondition__c, DependentValue__c, ObjectAPI__c, Name, DependentCombination__c 
												   FROM CLM_RequiredFields__c 
												   WHERE ObjectAPI__c= :CLM_GlobalConstants.agrmntAPIName 
												   AND ( Action__c=:CLM_GlobalConstants.frameRequestAct  OR Action__c=:CLM_GlobalConstants.requestAct ) AND Active__c= true 
												   order by Name];
		Map<string,List<string>> actioFielMap = new Map<string,List<string>>();
		List<string> fields = new List<string>();
		Map<string,CLM_RequiredFields__c> reqFldMap = new Map<string,CLM_RequiredFields__c>();
		
		for(CLM_RequiredFields__c reqFld:reqFieldLst){
			reqFldMap.put(reqFld.FieldAPI__c,reqFld);
			if(actioFielMap.containsKey(reqFld.Action__c)){
				fields =  actioFielMap.get(reqFld.Action__c);
				fields.add(reqFld.FieldAPI__c);
				actioFielMap.put(reqFld.Action__c, fields);
			}else{
				actioFielMap.put(reqFld.Action__c, new List<string>{reqFld.FieldAPI__c});
			}
		}
		set<string> parntAgrmntIds = new set<string>();
		for(Apttus__APTS_Agreement__c rec:agrmntRecLst){
			if(string.isNotBlank(rec.Apttus__Parent_Agreement__c)){
				parntAgrmntIds.add(rec.Apttus__Parent_Agreement__c);
			}
		}
		Map<Id,Apttus__APTS_Agreement__c> parentAgmntMap = new Map<Id,Apttus__APTS_Agreement__c>();
		if(!parntAgrmntIds.isEmpty()){
			parentAgmntMap = new Map<Id,Apttus__APTS_Agreement__c>([SELECT Id,Apttus__Subtype__c
																	FROM Apttus__APTS_Agreement__c
																	WHERE Id IN:parntAgrmntIds]);
		}
		
		List<string> requiredFields = new List<string>();
		string recordTypeName = '';
		List<wrapper> wrapLst = new List<wrapper>();
		wrapper wrap = new wrapper();
		CLM_RequiredFields__c csRec = new CLM_RequiredFields__c();
		List<string> valComp = new List<string>();
		for(Apttus__APTS_Agreement__c rec:agrmntRecLst){
			system.debug('===1229===='+rec);
			system.debug('===1230===='+rec.RecordTypeId);
			recordTypeName = Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(rec.RecordTypeId).getName();
			
			if(recordTypeName != 'NDA' && (validRecordTypes).contains(recordTypeName)
			   && rec.Apttus__Status__c == CLM_GlobalConstants.fullSignedSts){
				   Sobject objRec = rec;
				   requiredFields = (recordTypeName == 'Non-Transactional Agreement') ? actioFielMap.get(CLM_GlobalConstants.frameRequestAct) : actioFielMap.get(CLM_GlobalConstants.requestAct);
				   for(string s:requiredFields){
					   if(string.isBlank(string.valueOf(objRec.get(s)))){
						   wrap = new wrapper();
						   csRec = reqFldMap.containsKey(s) ? reqFldMap.get(s) : new CLM_RequiredFields__c();
						   if(string.IsBlank(csRec.DependentField__c)){
							   wrap.fieldAPI = s;
							   wrap.fieldLabel = csRec.FieldLabel__c;
							   wrapLst.add(wrap); 
						   }else{
							   if(csRec.DependentCondition__c == CLM_GlobalConstants.Equal_To){
								   if((csRec.DependentValue__c).contains(';')){
									   valComp = csRec.DependentValue__c.split(';');
									   if(valComp.Contains(string.ValueOf(objRec.get(csRec.DependentField__c)))){
										   wrap.fieldAPI = s;
										   wrap.fieldLabel = csRec.FieldLabel__c;
										   wrapLst.add(wrap);
									   }
								   }else{
									   
									   if(csRec.DependentCombination__c == 'OR'){
										   wrap.fieldAPI = s;
										   wrap.fieldLabel = csRec.FieldLabel__c;
										   wrapLst.add(wrap);
										   if((csRec.DependentValue__c == 'Null' && string.isNotBlank(string.ValueOf(objRec.get(csRec.DependentField__c)))) 
											  || (csRec.DependentValue__c != 'Null' &&(string.ValueOf(objRec.get(csRec.DependentField__c)) != csRec.DependentValue__c))){
												  for ( Integer i = wrapLst.size() - 1; i >= 0; --i ){
													  wrapper wr=wrapLst[i];
													  if (wr.fieldAPI== csRec.FieldAPI__c){
														  wrapLst.remove(i);
													  }
												  }
											  }
									   }else if(csRec.DependentCombination__c == 'AND' 
			&& ((csRec.DependentValue__c == 'Null' && string.isBlank(string.ValueOf(objRec.get(csRec.DependentField__c)))) 
											  || (csRec.DependentValue__c != 'Null' &&(string.ValueOf(objRec.get(csRec.DependentField__c)) == csRec.DependentValue__c)))){
										   
												  wrap.fieldAPI = s;
												  wrap.fieldLabel = csRec.FieldLabel__c;
												  wrapLst.add(wrap);
											 
									   }
								   }
							   }
						   }
					   }
				   }
				   for ( Integer i = wrapLst.size() - 1; i >= 0; --i ){
					   wrapper wr=wrapLst[i];
					   if(wr.fieldAPI == 'Apttus__Related_Opportunity__c' || wr.fieldAPI == 'End_Customer__c'){
						   if(wr.fieldAPI != 'End_Customer__c' 
							  && Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(string.valueOf(objRec.get('RecordTypeId'))).getName() == 'Supply and Services Agreement' 
							  && objRec.get('Apttus__Subtype__c') == 'Amendment' && objRec.get('Apttus__Parent_Agreement__c') != null
							  && parentAgmntMap.containsKey(Id.valueOf(string.valueOf(objRec.get('Apttus__Parent_Agreement__c'))))
							  && parentAgmntMap.get(Id.valueOf(string.valueOf(objRec.get('Apttus__Parent_Agreement__c')))).Apttus__Subtype__c == 'Partner Agreement (GPP)'){
								  wrapLst.remove(i);
							  }else if(objRec.get('Apttus__Subtype__c') == 'Partner Agreement (GPP)'){
								  wrapLst.remove(i);
							  }
						   
					   }
				   }
				   
				   rec.CLM_Ready_for_Activation__c = wrapLst.size()>0 ? false: true;
			   }else{
				   rec.CLM_Ready_for_Activation__c =  true;
			   }
			
		}
	}
	
	public static void updateCopyOptyFieldsToAgrmnt(List<Apttus__APTS_Agreement__c> agrmntRecLst,Map<Id,Apttus__APTS_Agreement__c> agrmntOldMap, boolean isInsert, boolean isUpdate){
		set<string> optyIds = new set<string>();
		List<string> validRecordTypes = CLM_GlobalConstants.agreementRecordTypeNames;
		
		for(Apttus__APTS_Agreement__c rec:agrmntRecLst){
			if(isInsert && string.IsNotBlank(rec.Apttus__Related_Opportunity__c)){
				optyIds.add(rec.Apttus__Related_Opportunity__c);
			}
			if(isUpdate && string.IsNotBlank(rec.Apttus__Related_Opportunity__c) && rec.Apttus__Related_Opportunity__c != (agrmntOldMap.get(rec.Id).Apttus__Related_Opportunity__c)){
				optyIds.add(rec.Apttus__Related_Opportunity__c);
			}
			
		}
		
		if(optyIds.size()>0){
			Map<Id,Opportunity> optyMap = new Map<Id,Opportunity>([SELECT Id,Notes_Comments__c ,AccountId ,Description ,
																   Document_Collaboration__c ,Amount ,G4_Planned_Date__c ,
																   CurrencyIsoCode ,Lead_BG__c ,Lead_BU__c ,Supporting_BG__c ,
																   Reference_Opportunity__c
																   FROM Opportunity
																   WHERE Id IN:optyIds]);
			if(!optyMap.isEmpty()){
				Opportunity optyRec = new Opportunity();
				for(Apttus__APTS_Agreement__c rec:agrmntRecLst){
					if(string.isNotBlank(rec.Apttus__Related_Opportunity__c) && optyMap.containsKey(rec.Apttus__Related_Opportunity__c)
					   && (validRecordTypes).contains(Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(rec.RecordTypeId).getName())){
						   optyRec = optyMap.get(rec.Apttus__Related_Opportunity__c);
						   rec.CLM_Opportunity_Comments__c = optyRec.Notes_Comments__c;
						   rec.CLM_Document_Collaboration_Link__c = optyRec.Document_Collaboration__c;
						   rec.CurrencyIsoCode = optyRec.CurrencyIsoCode;
						   rec.Lead_BG__c = optyRec.Lead_BG__c;
						   rec.Lead_BU__c = optyRec.Lead_BU__c;
						   rec.CLM_Opportunity_Account__c = optyRec.AccountId;
						   rec.Apttus__Description__c = optyRec.Description;
						   rec.Apttus__Total_Contract_Value__c = optyRec.Amount;
						   rec.CLM_Expected_G4_Date__c = optyRec.G4_Planned_Date__c;
						   rec.CLM_Supporting_BGs__c = optyRec.Supporting_BG__c;
						   rec.CLM_Reference_Opportunity__c = optyRec.Reference_Opportunity__c;
						   
					   }
				}
				
			}
		}
	}
	
	@AuraEnabled
	public static void reactivateContract(string agmrntRec, date endDate){
		try{
			Apttus__APTS_Agreement__c agrmnt = (Apttus__APTS_Agreement__c) JSON.deserialize(agmrntRec, Apttus__APTS_Agreement__c.class);
			agrmnt.Apttus__Status__c = 'Activated';
			agrmnt.Apttus__Status_Category__c = 'In Effect';
			agrmnt.Apttus__Contract_End_Date__c = endDate;
			update agrmnt;
		}catch(exception e){
			if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION,')){
				List<string> messageLst = (e.getMessage()).split('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
				string messages = '';
				if(messageLst.size()>1){
					messages = messageLst[1];
				}
				if(string.isNotBlank(messages)){
					throw new AuraHandledException(messages);
				}
			 
			}else{
				throw new AuraHandledException(e.getMessage()); 
			}
			
		}
	}
	
	public class sessionWrapper{
		@AuraEnabled public string session;
		@AuraEnabled public string baseUrl;
	}
	/**************************************************************************************
* @Name		 wrapper 
* @Description  Wrapper class to store field info
**************************************************************************************/
	public class wrapper{
		@AuraEnabled public string fieldAPI {get;set;}
		@AuraEnabled public string fieldValue {get;set;}
		@AuraEnabled public string fieldLabel {get;set;}
		@AuraEnabled public string fieldType {get;set;}
		@AuraEnabled public string fieldId {get;set;}
		@AuraEnabled public boolean disable {get;set;}
	} 
	
	/**************************************************************************************
* @Name		 permissionWrapper 
* @Description  Wrapper class to permissions of user
**************************************************************************************/
	
	public class permissionWrapper{
		@AuraEnabled public boolean hasAMPermission;
		@AuraEnabled public boolean hasCCMPernission;
		@AuraEnabled public boolean isSysAdmin;
	}
	
	/**************************************************************************************
* @Name		 userSearchWrapper 
* @Description  Wrapper class to store agreement/opportunity team info
**************************************************************************************/
	
	public class userSearchWrapper{
		@AuraEnabled public string message;
		@AuraEnabled public CLM_Agreement_Team__c agrmentTeamRec;
		@AuraEnabled public OpportunityTeamMember opportunityTeamRec;
	}
	
	/**************************************************************************************
* @Name		 wrapper 
* @Description  Wrapper class to store object info
**************************************************************************************/
	
	public class objInfoWrapper{
		@AuraEnabled public List<wrapper> wrapRecdsList;
		@AuraEnabled public Sobject objRecd;
		
		public objInfoWrapper(){
			wrapRecdsList = new List<wrapper>();
		}
	}
	
}