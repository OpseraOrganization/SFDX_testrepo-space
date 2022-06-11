/****************************************
* Class Name : CH_MonitorCountryDiffBatch 
* Created Date: 07 February 2020
* Created By : Sónia Reis
* Last Modified by: Sónia Reis
* Last Modified Date: 23 April 2020
* Description : Batch to monitoring differences between the lists of Countries
* Test Class: CH_MonitorCountryDiffBatchTest 
************/
global without sharing class CH_MonitorCountryDiffBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable{
	
	static final String CHATTER_GROUP_NAME ='Error - Country Alignment Issues';
	
	String chatterGroupName='';
	//Removing replyEmail and stored it in CH_UserIdForMonitorBtach label as part of NOKIASC-29479
	global CH_MonitorCountryDiffBatch(String chatterName) {
		chatterGroupName=chatterName;
	} 
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		system.debug('CH_MonitorCountryDiffBatch - START');
		
		//get custom setting ISO_Country_Codes__c
		String query = 'select id, name, Country_Name__c from ISO_Country_Codes__c'; 
		return Database.getQueryLocator(query);
		
	}
	
	global void execute(Database.BatchableContext BC, list<SObject> scope){
		
		List<CollaborationGroup> chatterGroups = [select id, Name, OwnerId, Owner.Name, Owner.Email  from CollaborationGroup where name =: chatterGroupName limit 1];
	   
		
		if(chatterGroups.isEmpty()){   // the group has to be created, if it isn't created an email is going to be send
			Id userId = System.Label.CH_UserIdForMonitorBtach;
			system.debug('a group has to be created - ' + chatterGroupName + ' '+userId);			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		   
			mail.setTargetObjectId(userId );
			mail.saveAsActivity= false;
			mail.setSubject('Chatter Group needs to be created');
			mail.setHtmlBody('Chatter Group needs to be created with the name "Error - Country Alignment Issues"');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			
			return;
		}
		
		Map<String, String> ISOCountryCodesMap = new Map<String, String>();
		for(ISO_Country_Codes__c cod : (List<ISO_Country_Codes__c>) scope){
			if(!ISOCountryCodesMap.containsKey(cod.name)){
				ISOCountryCodesMap.put(cod.name, cod.Country_Name__c);
			}
		}
	  
		Map<String, String> CountryCodeNamesMap = new Map<String, String>();
		for(ISO_Country_Codes__c cod : (List<ISO_Country_Codes__c>) scope ){  
			if(!CountryCodeNamesMap.containsKey(cod.Country_Name__c)){
				CountryCodeNamesMap.put(cod.Country_Name__c, cod.name);
			}
		}
	  
		Schema.DescribeFieldResult fieldResultOOTB = User.Countrycode.getDescribe();
		List<Schema.PicklistEntry> pleOOTB = fieldResultOOTB.getPicklistValues();
	   
	   
		Schema.DescribeFieldResult fieldResult = CH_Workgroup_Rule__c.CH_Country1__c.getDescribe();
		List<Schema.PicklistEntry> pleGP = fieldResult.getPicklistValues(); 
		Schema.DescribeFieldResult fieldResultC = CH_WorkgroupCountryAssociation__c.CH_Country__c.getDescribe();
		List<Schema.PicklistEntry> pleGPCountries = fieldResultC.getPicklistValues(); 
		
	 
		FeedItem post = new FeedItem();
		post.ParentId = chatterGroups[0].id;	
		Integer countCheck1 = 0;
		string header ='Error Message\n';
		String finalstr = header;
		for( Schema.PicklistEntry entryOOTB : pleOOTB){
			if(!ISOCountryCodesMap.containskey(entryOOTB.getValue())){
			  
				String CurrentString = 'Error – Country Name >> ISO_Country_Code is missing entry for ISO Code '+ entryOOTB.getValue()+ ' which exists in the OOTB list of Countries.' ;
				finalstr = finalstr+CurrentString+'\n';
				countCheck1++;
				
			}
		}
		//check2 - Check ISO2 in ISO_Country_Codes__c with OOTB
		Integer countCheck2 = 0;
		for( String code : ISOCountryCodesMap.keyset()){
			Boolean found = false;
			for( Schema.PicklistEntry entryOOTB : pleOOTB){
				if(code.equals(entryOOTB.getValue())){
					found = true;
					break;
				}
			}
			if(!found){
			   
				String CurrentString = 'Error – Country Name >> OOTB country list is missing entry for ISO Code '+ code +' which exists in ISO_Country_Code.' ;
				finalstr = finalstr+CurrentString+'\n';
			}
		}
		Integer countCheck3 = 0;
		for( String codeName : ISOCountryCodesMap.values()){
			Boolean found = false;
			for( Schema.PicklistEntry entryOOTB : pleOOTB){
				if(codeName.equals(entryOOTB.getLabel())){
					found = true;
					break;
				}
			}
			if(!found){
			   
				countCheck3++;
			   
				String CurrentString = 'Error – Country Name >> For ISO2 ' + CountryCodeNamesMap.get(codeName) + ', ISO_Country_Code has Country Name '+ codeName +' which does not match OOTB Country Name '; //+ entryOOTB.getLabel() +'.' ;
				finalstr = finalstr+CurrentString+'\n';
			}
		}
	  
		Integer countCheck4 = 0;
		for( String codeName : ISOCountryCodesMap.values()){
			Boolean found = false;
			for( Schema.PicklistEntry entryGP : pleGP){
				if(codeName.equals(entryGP.getLabel())){
					found = true;
					break;
				}
			}
			if(!found){
			   
				countCheck4++;
			   
				String CurrentString = 'Error – Country Name >> ISO_Country_Code has Country Name ' + codeName + ' that is not in CH_Countries picklist.' ;
				finalstr = finalstr+CurrentString+'\n';
			}
		} 
		Integer countCheck5 = 0;
		for( Schema.PicklistEntry entryGP : pleGP){
			Boolean found = false;
			for( String codeName : ISOCountryCodesMap.values()){
				if(codeName.equals(entryGP.getLabel())){
					found = true; 
					break;
				}
			}
			if(!found){
			  
				countCheck5++;
			   
				String CurrentString = 'Error – Country Name >> CH_Countries picklist has Country Name ' + entryGP.getLabel() + ' that is not in ISO_Country_Code.' ;
				finalstr = finalstr+CurrentString+'\n';
			}   
		} 
		
		Integer countCheck6 = 0;
		for( String codeName : ISOCountryCodesMap.values()){
			Boolean found = false;
			for( Schema.PicklistEntry entryGP : pleGPCountries){
				if(codeName.equals(entryGP.getLabel())){
					found = true;
					break;
				}
			}
			if(!found){
			
				countCheck6++;
				String CurrentString = 'Error – Country Name >> ISO_Country_Code has Country Name ' + codeName + ' that is not in Countries picklist.' ;
				finalstr = finalstr+CurrentString+'\n';
			}
		} 
	 
		Integer countCheck7 = 0;
		for( Schema.PicklistEntry entryGP : pleGPcountries){
			Boolean found = false;
			for( String codeName : ISOCountryCodesMap.values()){
				if(codeName.equals(entryGP.getLabel())){
					found = true; 
					break;
				}
			}
			if(!found){
			   
				countCheck7++;
				
				String CurrentString = 'Error – Country Name >> Countries picklist has Country Name ' + entryGP.getLabel() + ' that is not in ISO_Country_Code.' ;
				finalstr = finalstr+CurrentString+'\n';
			}   
		} 
	   
		
		Integer countCheck8 = 0;
		for( String code : ISOCountryCodesMap.keyset()){
			Boolean found = false;
			for( Schema.PicklistEntry entryGP : pleGPcountries){
				if(code.equals(entryGP.getValue())){
					found = true;
					break;
				}
			}
			if(!found){
				
				countCheck8++;
			   
				String CurrentString = 'Error – Country Name >> Countries list is missing entry for ISO Code '+ code +' which exists in ISO_Country_Code.' ;
				finalstr = finalstr+CurrentString+'\n';
			}
		}
	   
		Integer countCheck9 = 0;
		for( Schema.PicklistEntry entryGP : pleGPcountries){
			if(!ISOCountryCodesMap.containskey(entryGP.getValue())){
			   
				countCheck9++;
			   
				String CurrentString = 'Error – Country Name >> ISO_Country_Code is missing entry for ISO Code '+ entryGP.getValue()+ ' which exists in the list of Countries.' ;
				finalstr = finalstr+CurrentString+'\n';
			}
		}
	  
		if(finalstr !=null){
			
			Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
			blob excel = blob.valueOf(finalstr);
			attach.setBody(excel);
			attach.setFileName('ISOCountryErrorCode.xls');
			String subject = 'ISO Error';
			String body = 'This file is generated using Schedulable - ISO_Country_Code is missing entry for ISO Code ';
			string[] address = new string[]{chatterGroups[0].Owner.Email};
				
			Messaging.singleEmailMessage Emailwithattch = new Messaging.singleEmailMessage();
			
			Emailwithattch.setSubject(subject);
			
			Emailwithattch.setToaddresses(address);
			
			Emailwithattch.setPlainTextBody(body);
			
			
			
			Emailwithattch.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
			
		
			
			Messaging.SendEmailResult [] r =
				
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {Emailwithattch});
			String s2 = ' ISO_Country_Code is missing entry for ISO Code';
			post.Body = s2;
			insert post; 
			
			//Upload File
			ContentVersion cv = new ContentVersion();
			cv.Title = 'Chatter Post Document';
			cv.PathOnClient = 'chattertestdoc.xls';
			cv.VersionData = Blob.valueOf(finalstr);
			cv.Description = 'Chatter Post Document';
			insert cv;
			
	   
		   
			FeedAttachment fa = new FeedAttachment();
			fa.FeedEntityId = post.Id;
			fa.RecordId = cv.Id;
			fa.Type = 'CONTENT'; 
			insert fa;
		}
	}
	
	global void finish(Database.BatchableContext BC){
		system.debug('CH_MonitorCountryDiffBatch - FINISH');
	}
	
	
	global void execute(SchedulableContext sc)
	{ 
	  
		//NOKIASC-29479
		CH_MonitorCountryDiffBatch b = new CH_MonitorCountryDiffBatch (CHATTER_GROUP_NAME);
		
	  
		database.executebatch(b,2000);
	}
	
	
}