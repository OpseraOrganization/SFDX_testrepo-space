/*******************************
*Class name: CertificationTriggerHelper 
*Description: Run On Handler Call.
*Parameter: Certification Values
*******************************/ 
public without sharing class CertificationTriggerHelper{   
	/*******************************
*Method name: afterUpdateCertificationSharePSM
*Description: This Method will share Certification with PRM's of same classes.
*Parameter: Certification Values
*******************************/
	public static void afterUpdateCertificationSharePSM(List<Certification__c> certificationList){
		try{
			List<Certification__Share> certificationShareToInsert = new List<Certification__Share> ();
			List<Account_Member__c> accountMemberList = new List<Account_Member__c>();	
			accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c 
		 WHERE Account_Role__c = : PRMGlobalConstants.PARTNER_SALES_MANAGER 
		 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];	
			if(!accountMemberList.IsEmpty() ){
	
	for(Account_Member__c accTeamMeamber : accountMemberList){
		Certification__Share share = new Certification__Share();
		share.UserOrGroupId = accTeamMeamber.Name__c;
		share.ParentId = certificationList[0].Id;
		share.AccessLevel = PRMGlobalConstants.READ;
		share.RowCause = PRMGlobalConstants.MANUAL;
		certificationShareToInsert.add(share);		
	}
			}			
			Database.SaveResult[] srList = Database.insert(certificationShareToInsert, false);
		}	  
		catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHelper ,PRMGlobalConstants.afterUpdateCertificationSharePSM);
		}
	}	
	/*******************************
*Method name: updateGPPFieldsonCert
*Description: This Method will update gpp values on update
*Parameter: Certification Values
* added by supriyam
*******************************/   
	public static void updateGPPFieldsonCert(Map<id,Certification__c> CertificationOldMap , 
			Map<id,Certification__c> CertificationNewMap ){
	Set<ID> cerMatID = new Set<ID>();
	try{
	 for(Certification__c CMID : CertificationNewMap.values()){ 
		 if((CertificationOldMap.get(CMID.Id).Certification_Matrix_Number__c != CertificationNewMap.get(CMID.Id).Certification_Matrix_Number__c)
			&&(CertificationOldMap.get(CMID.Id).Partner__c != CertificationNewMap.get(CMID.Id).Partner__c)){
	cerMatID.add(CMID.Id); 
			}
		 else if(CertificationOldMap.get(CMID.Id).Certification_Matrix_Number__c != CertificationNewMap.get(CMID.Id).Certification_Matrix_Number__c){
	cerMatID.add(CMID.Id); 
		 }else if(CertificationOldMap.get(CMID.Id).Partner__c != CertificationNewMap.get(CMID.Id).Partner__c){
	cerMatID.add(CMID.Id);
		 }else{}
	 }
	 if(!cerMatID.IsEmpty()){
		 LIST<Certification__c> certdetailsUpdate = new LIST<Certification__c>();
		 for (Certification__c certDetails : [select name, Partner__c,Partner__r.Partner_Program__c,GPP_Certification_Name__c, Certification_Matrix_Number__r.GPP_0_0__c,
	Certification_Matrix_Number__r.GPP_1_0__c,Certification_Matrix_Number__r.GPP_2_0__c,Certification_Matrix_Number__r.GPP_3_0__c 
	from Certification__c where id in:CerMatID 
	Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program0){
		 certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_0_0__c;
		}else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program1){
		 certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_1_0__c;
		}else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program2){
		 certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_2_0__c;
		}else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program3){
		 certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_3_0__c;
		}else{}
		certdetailsUpdate.add(certDetails); 
	}
		 database.update(certdetailsUpdate,false);
	 }
	}Catch(Exception e){
	 ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHelper ,PRMGlobalConstants.updateGPPFieldsonCert); 
	}
			}	
	/*******************************
*Method name: updateGPPFieldsonCertonInsert when 
*Description: This Method will update gpp values on certification when new certification insert
*Parameter: Certification Values
* added by supriyam
*******************************/   
	public static void updateGPPFieldsonCertonInsert(Map<id,Certification__c> CertificationNewMap ){
		Set<ID> cerMatID = new Set<ID>();
		try{
			for(Certification__c CMID : CertificationNewMap.values()){ 
	cerMatID.add(CMID.Id);
			}
			if(!cerMatID.IsEmpty()){
	LIST<Certification__c> certdetailsUpdate = new LIST<Certification__c>();
	for (Certification__c certDetails : [select name,Partner__c,Partner__r.Partner_Program__c,GPP_Certification_Name__c,Certification_Matrix_Number__r.GPP_0_0__c,
	 Certification_Matrix_Number__r.GPP_1_0__c,Certification_Matrix_Number__r.GPP_2_0__c,Certification_Matrix_Number__r.GPP_3_0__c 
	 from Certification__c where id in:CerMatID Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){		 
		 if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program0){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_0_0__c;
		 }else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program1){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_1_0__c;
		 }else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program2){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_2_0__c;
		 }else if(certDetails.Partner__r.Partner_Program__c == PRMGlobalConstants.Partner_Program3){
	certDetails.GPP_Certification_Name__c = certDetails.Certification_Matrix_Number__r.GPP_3_0__c;
		 }else{}
		 certdetailsUpdate.add(certDetails); 
	 }
	database.update(certdetailsUpdate,false);
			}
		}Catch(Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHelper ,PRMGlobalConstants.updateGPPFieldsonCertonInsert); 
		}
	}	
	/*******************************
*******************************
*Method name: Certification to accreditation Job function Count Update
*Description: 
*Parameter: 
*******************************/
	public static void accreditationUpdate(list<Certification__c> NewCertifications ){
	
		try{
		system.debug('PRMGlobalConstants.CertificationCountUpdateExecuted .... :' +PRMGlobalConstants.CertificationCountUpdateExecuted);
		if(!PRMGlobalConstants.CertificationCountUpdateExecuted){
			
			system.debug('NewCertifications ==== ' + NewCertifications);
			set<ID> accID = new set<ID>();   
			set<ID> contactID = new set<ID>();
			set<ID> deletedCertIds = new set<ID>();
			list<String> portfolios = new list<String>();
			list<String> jobFunctions = new list<String>();
			list<Accreditation__c> accreditationToUpdate = new list<Accreditation__c>();
			map<ID, map<String, integer>> contactNumCert = new map<id, map<String, integer>>();
			System.debug('contactNumCert'+contactNumCert);
			for(Certification__c cert : NewCertifications){
	system.debug('inside loop cert-----'+cert);
	accID.add(cert.Partner__c);
	contactID.add(cert.Name__c);
	if(!portfolios.contains(cert.Technologies_Portfolio__c)){
		portfolios.add(cert.Technologies_Portfolio__c);
	}
	if(!jobFunctions.contains(cert.Job_Function__c)){
		jobFunctions.add(cert.Job_Function__c);
	}
				
	if(Trigger.isDelete != null)
	{
	if(Trigger.isDelete == true){
	deletedCertIds.add(cert.id);
	}
		
	}
	
			}
			system.debug('accID ==== ' + accID);
			for(Certification__c usercert : [select id, Name__c, Partner__c, Technologies_Portfolio__c from Certification__c 
			where Partner__c in: accID AND Id not in: deletedCertIds AND Certification_Status__c =: PRMGlobalConstants.Completed Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			system.debug('usercert .....' + usercert);
	map<string, integer> portfolioCert = contactNumCert.get(usercert.Name__c);
	if(portfolioCert == null){
	 map<string, integer> portfCert = new map<string, integer>();
	 portfCert.put(usercert.Technologies_Portfolio__c, 1);
	 system.debug('portfCert-------177'+portfCert);
	 contactNumCert.put(usercert.Name__c, portfCert);
	}
	else{
	 integer certCount = portfolioCert.get(usercert.Technologies_Portfolio__c);
	 system.debug('certCount---------182'+certCount);
	 if(certCount == null){
		 portfolioCert.put(usercert.Technologies_Portfolio__c, 1); 
		 system.debug('portfolioCert---------185'+portfolioCert);
	 }
	 else{
		 certCount = certCount + 1;
		 system.debug('certCount---------190'+certCount);
		 portfolioCert.put(usercert.Technologies_Portfolio__c, certCount);
		 system.debug('portfolioCert---------192'+portfolioCert);
	 }
	 contactNumCert.put(usercert.Name__c, portfolioCert);
	 system.debug('contactNumCert---------194'+contactNumCert);
	}	
			}			
			Map<Id, List<Certification__c>> certMap = new Map<Id, List<Certification__c>>();
			for(Certification__c  certif : [Select id, Name__c, Partner__c, Certification_Status__c, Job_Function__c, Technologies_Portfolio__c from Certification__c 
			where Partner__c in: accID AND Technologies_Portfolio__c in: portfolios and Job_Function__c in: jobFunctions
			AND Id not in: deletedCertIds Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	if(!certMap.keySet().contains(certif.Partner__c)){
		certMap.put(certif.Partner__c, new List<Certification__c>{certif});
	}else{
		certMap.get(certif.Partner__c).add(certif);
	}
			}
			system.debug('contactNumCert ==== ' + contactNumCert);			
			for(Accreditation__c Accr : database.query(PRMGlobalConstants.accreditationueryBP_Part1 + system.label.Accredittaion_Automation_certification_Job_Function +  PRMGlobalConstants.accreditationueryBP_Part2)){ system.debug('>>> For loop Content ' );
	Map<String, Integer> accredMap = new Map<String, Integer>();
	system.debug('>>> in Accreditation for loop ' + Accr.name +'Accr.Portfolio__c'+Accr.Portfolio__c );
	for(Certification__c  certif : certMap.get(Accr.Partner__c)){  
		system.debug('>>> First one ' + Accr.name + 'Cert : ' + certif);
		system.debug('>>> in certification for loop ' + Accr.name + 'Cert : '  + certif.id);
		if(Accr.Portfolio__c == certif.Technologies_Portfolio__c && Accr.Partner__c == certif.Partner__c){
			system.debug('>>> Match portfolio');
			PRM_CertificationToAccreditation_Mapping__c certToAccred = PRM_CertificationToAccreditation_Mapping__c.getInstance(certif.Job_Function__c);
			system.debug('PRM_CertificationToAccreditation_Mapping__c.getInstance(certif.Job_Function__c) ...' + PRM_CertificationToAccreditation_Mapping__c.getInstance(certif.Job_Function__c));
			string fName = certToAccred.Accreditation_Field_API_Name__c;	system.debug('>>> fName ' + fName );
			//MSilva - changes on the accreditation counter Start
			if(certif.Certification_Status__c == PRMGlobalConstants.Completed){
	if(!accredMap.keySet().contains(fName)){
		accredMap.put(fName, 1);
	}else{
		accredMap.put(fName, accredMap.get(fName) + 1);
	}
			}		
			//MSilva - changes on the accreditation counter	End	
			system.debug('contactNumCert.get(certif.Name__c)' + contactNumCert.get(certif.Name__c));
			if(contactNumCert.get(certif.Name__c) != Null && contactNumCert.get(certif.Name__c).get(Accr.Portfolio__c) > 2){
	Accr.Manual_Accreditation_Level_Update__c = true;
	system.debug('Manual accredittaion updtae');
			}
			Accr.Evaluated_Accreditation__c = true;			
		}
	}
	if(accredMap.keySet().size() > 0){
		for(String field : accredMap.keySet()){
			Accr.put(field, accredMap.get(field));
		}	 
	}else{
		for(Certification__c cert : NewCertifications){
			if(cert.Partner__c == Accr.Partner__c && cert.Technologies_Portfolio__c == Accr.Portfolio__c){
	PRM_CertificationToAccreditation_Mapping__c certToAccred = PRM_CertificationToAccreditation_Mapping__c.getInstance(cert.Job_Function__c);
	string field = certToAccred.Accreditation_Field_API_Name__c;
	Accr.put(field,0);
			}
		}
	}	 
	accreditationToUpdate.add(Accr);
			}
			system.debug('>>>accreditationToUpdate' + accreditationToUpdate);
			if(!accreditationToUpdate.isempty()){
	database.update(accreditationToUpdate, false);
			PRMGlobalConstants.CertificationCountUpdateExecuted = true;
			}
			
		 }
		}Catch(Exception e){
			system.debug('certification error in catch block--' + e);
			String exdetails = e.getTypeName() + ' ; '+e.getLineNumber();
			system.debug('exeption details' + exdetails);
			ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHelper ,exdetails);
		}
	} 
	
}