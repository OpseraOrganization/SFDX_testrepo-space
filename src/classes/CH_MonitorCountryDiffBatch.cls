/****************************************
* Class Name : CH_MonitorCountryDiffBatch 
* Created Date: 07 February 2020
* Created By : Sónia Reis
* Last Modified by: Sónia Reis
* Last Modified Date: 23 April 2020
* Description : Batch to monitoring differences between the lists of Countries
* Test Class: CH_MonitorCountryDiffBatchTest 
************/
global class CH_MonitorCountryDiffBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable{
	
	static final String CHATTER_GROUP_NAME ='Error - Country Alignment Issues';
	static final String REPLY_EMAIL ='sonia.reis@nokia.com';
	
	String chatterGroupName='';
	String replyEmail='';
	
	global CH_MonitorCountryDiffBatch(String chatterName, String replyInfoEmail) {
		chatterGroupName=chatterName;
		replyEmail = replyInfoEmail;
	} 
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		system.debug('CH_MonitorCountryDiffBatch - START');
		
		//get custom setting ISO_Country_Codes__c
		String query = 'select id, name, Country_Name__c from ISO_Country_Codes__c'; 
		return Database.getQueryLocator(query);
		
	}
	
	global void execute(Database.BatchableContext BC, list<SObject> scope){
		system.debug('CH_MonitorCountryDiffBatch - EXECUTE');
		
		List<CollaborationGroup> chatterGroups = [select id from CollaborationGroup where name =: chatterGroupName limit 1];
		List<FeedItem> chatterPostsList = new List<FeedItem>();
		
		if(chatterGroups.isEmpty()){   // the group has to be created, if it isn't created an email is going to be send
			system.debug('a group has to be created - ' + chatterGroupName + ' '+replyEmail);
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses( new String[] {replyEmail});
			mail.setSubject('Chatter Group needs to be created');
			mail.setHtmlBody('Chatter Group needs to be created with the name "Error - Country Alignment Issues"');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			
			return;
		}
		
		
		//tranform ISO_Country_Codes__c (scope) in a map (code, name)
		Map<String, String> ISOCountryCodesMap = new Map<String, String>();
		for(ISO_Country_Codes__c cod : (List<ISO_Country_Codes__c>) scope){
			if(!ISOCountryCodesMap.containsKey(cod.name)){
				ISOCountryCodesMap.put(cod.name, cod.Country_Name__c);
			}
		}
		system.debug('ISOCountryCodesMap size '+ISOCountryCodesMap.size());
		
		//tranform ISO_Country_Codes__c (scope) in a map (name, code)
		Map<String, String> CountryCodeNamesMap = new Map<String, String>();
		for(ISO_Country_Codes__c cod : (List<ISO_Country_Codes__c>) scope ){  
			if(!CountryCodeNamesMap.containsKey(cod.Country_Name__c)){
				CountryCodeNamesMap.put(cod.Country_Name__c, cod.name);
			}
		}
		system.debug('CountryCodeNamesMap size '+CountryCodeNamesMap.size());
		
		//get State and Country/Territory picklists
		Schema.DescribeFieldResult fieldResultOOTB = User.Countrycode.getDescribe();
		List<Schema.PicklistEntry> pleOOTB = fieldResultOOTB.getPicklistValues();
		/* for( Schema.PicklistEntry f : pleOOTB){
		System.debug(f.getLabel() +'::'+ f.getValue());
		}*/
		system.debug('OOTB size'+pleOOTB.size());
		
		//get values from global picklist CH_Countries
		Schema.DescribeFieldResult fieldResult = CH_Workgroup_Rule__c.CH_Country1__c.getDescribe();
		List<Schema.PicklistEntry> pleGP = fieldResult.getPicklistValues(); 
		system.debug('CH_Countries size '+pleGP.size());
		
		//get values from global picklist Countries
		Schema.DescribeFieldResult fieldResultC = CH_WorkgroupCountryAssociation__c.CH_Country__c.getDescribe();
		List<Schema.PicklistEntry> pleGPCountries = fieldResultC.getPicklistValues(); 
		system.debug('Countries size '+pleGPCountries.size());
		
		/*	  1- Check ISO2 in OOTB with ISO_Country_Codes__c
		2- Check ISO2 in ISO_Country_Codes__c with OOTB
		3- Check Country Name in ISO_Country_Codes__c with OOTB
		4- Check Country Name in ISO_Country_Codes__c with CH_Countries
		5- Check Country Name in CH_Countries with ISO_Country_Codes__c
		6- Check Country Name in ISO_Country_Codes__c with Countries
		7- Check Country Name in Countries with ISO_Country_Codes__c  
		8- Check ISO2 in ISO_Country_Codes__c with Countries
		9- Check ISO2 in Countries with ISO_Country_Codes__c  */
		
		//check1 - Check ISO2 in OOTB with ISO_Country_Codes__c
		system.debug('CH_MonitorCountryDiffBatch - check1');
		Integer countCheck1 = 0;
		for( Schema.PicklistEntry entryOOTB : pleOOTB){
			if(!ISOCountryCodesMap.containskey(entryOOTB.getValue())){
				//Send chatter post
				FeedItem post = new FeedItem();
				post.ParentId = chatterGroups[0].id;	 
				post.Body = 'Error – Country Name >> ISO_Country_Code is missing entry for ISO Code '+ entryOOTB.getValue()+ ' which exists in the OOTB list of Countries.' ;
				system.debug('Error – Country Name >> ISO_Country_Code is missing entry for ISO Code '+ entryOOTB.getValue()+ ' which exists in the OOTB list of Countries.');
				countCheck1++;
				chatterPostsList.add(post);
			}
		}
		system.debug('CH_MonitorCountryDiffBatch - check1 size '+ countCheck1);
		
		//check2 - Check ISO2 in ISO_Country_Codes__c with OOTB
		system.debug('CH_MonitorCountryDiffBatch - check2');
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
				FeedItem post = new FeedItem(); post.ParentId = chatterGroups[0].id; countCheck2++; chatterPostsList.add(post);
				post.Body = 'Error – Country Name >> OOTB country list is missing entry for ISO Code '+ code +' which exists in ISO_Country_Code.' ;
				system.debug('Error – Country Name >> OOTB country list is missing entry for ISO Code '+ code +' which exists in ISO_Country_Code.');
				
			}
		}
		system.debug('CH_MonitorCountryDiffBatch - check2 size '+ countCheck2);
		
		//check3 - Check Country Name in ISO_Country_Codes__c with OOTB
		system.debug('CH_MonitorCountryDiffBatch - check3');
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
				FeedItem post = new FeedItem();
				post.ParentId = chatterGroups[0].id;
				post.Body = 'Error – Country Name >> For ISO2 ' + CountryCodeNamesMap.get(codeName) + ', ISO_Country_Code has Country Name '+ codeName +' which does not match OOTB Country Name '; //+ entryOOTB.getLabel() +'.' ;
				system.debug('Error – Country Name >> For ISO2 ' + CountryCodeNamesMap.get(codeName) + ', ISO_Country_Code has Country Name '+ codeName +' which does not match OOTB Country Name. ');
				countCheck3++;
				chatterPostsList.add(post);
			}
		}
		system.debug('CH_MonitorCountryDiffBatch - check3 size '+ countCheck3);
		
		//check4 - Check Country Name in ISO_Country_Codes__c with CH_Countries
		system.debug('CH_MonitorCountryDiffBatch - check4');
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
				FeedItem post = new FeedItem();
				post.ParentId = chatterGroups[0].id;
				post.Body = 'Error – Country Name >> ISO_Country_Code has Country Name ' + codeName + ' that is not in CH_Countries picklist.' ;
				system.debug('Error – Country Name >> ISO_Country_Code has Country Name ' + codeName + ' that is not in CH_Countries picklist.');
				countCheck4++;
				chatterPostsList.add(post);
			}
		} 
		system.debug('CH_MonitorCountryDiffBatch - check4 size '+ countCheck4);
		
		//check5 - Check Country Name in CH_Countries with ISO_Country_Codes__c
		system.debug('CH_MonitorCountryDiffBatch - check5');
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
				//Send chatter post
				FeedItem post = new FeedItem();
				post.ParentId = chatterGroups[0].id;
				post.Body = 'Error – Country Name >> CH_Countries picklist has Country Name ' + entryGP.getLabel() + ' that is not in ISO_Country_Code.' ;
				system.debug('Error – Country Name >> CH_Countries picklist has Country Name ' + entryGP.getLabel() + ' that is not in ISO_Country_Code.');
				countCheck5++;
				chatterPostsList.add(post);
			}	
		} 
		system.debug('CH_MonitorCountryDiffBatch - check5 size '+ countCheck5);
		
		//check6 - Check Country Name in ISO_Country_Codes__c with Countries
		system.debug('CH_MonitorCountryDiffBatch - check6');
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
				FeedItem post = new FeedItem();
				post.ParentId = chatterGroups[0].id;
				post.Body = 'Error – Country Name >> ISO_Country_Code has Country Name ' + codeName + ' that is not in Countries picklist.' ;
				system.debug('Error – Country Name >> ISO_Country_Code has Country Name ' + codeName + ' that is not in Countries picklist.');
				countCheck6++;
				chatterPostsList.add(post);
			}
		} 
		system.debug('CH_MonitorCountryDiffBatch - check6 size '+ countCheck6);
		
		//check7 - Check Country Name in Countries with ISO_Country_Codes__c
		system.debug('CH_MonitorCountryDiffBatch - check7');
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
				//Send chatter post
				FeedItem post = new FeedItem();
				post.ParentId = chatterGroups[0].id;
				post.Body = 'Error – Country Name >> Countries picklist has Country Name ' + entryGP.getLabel() + ' that is not in ISO_Country_Code.' ;
				system.debug('Error – Country Name >> Countries picklist has Country Name ' + entryGP.getLabel() + ' that is not in ISO_Country_Code.');
				countCheck7++;
				chatterPostsList.add(post);
			}	
		} 
		system.debug('CH_MonitorCountryDiffBatch - check7 size '+ countCheck7);
		
		//check8 - Check ISO2 in ISO_Country_Codes__c with Countries
		system.debug('CH_MonitorCountryDiffBatch - check8');
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
				FeedItem post = new FeedItem(); post.ParentId = chatterGroups[0].id;
				post.Body = 'Error – Country Name >> Countries list is missing entry for ISO Code '+ code +' which exists in ISO_Country_Code.' ;
				system.debug('Error – Country Name >> Countries list is missing entry for ISO Code '+ code +' which exists in ISO_Country_Code.');
				countCheck8++; chatterPostsList.add(post);
			}
		}
		system.debug('CH_MonitorCountryDiffBatch - check8 size '+ countCheck8);
		
		//check9 - Check ISO2 in Countries with ISO_Country_Codes__c
		system.debug('CH_MonitorCountryDiffBatch - check9');
		Integer countCheck9 = 0;
		for( Schema.PicklistEntry entryGP : pleGPcountries){
			if(!ISOCountryCodesMap.containskey(entryGP.getValue())){
				FeedItem post = new FeedItem();
				post.ParentId = chatterGroups[0].id;
				post.Body = 'Error – Country Name >> ISO_Country_Code is missing entry for ISO Code '+ entryGP.getValue()+ ' which exists in the list of Countries.' ;
				system.debug('Error – Country Name >> ISO_Country_Code is missing entry for ISO Code '+ entryGP.getValue()+ ' which exists in the list of Countries.');
				countCheck9++;
				chatterPostsList.add(post);
			}
		}
		system.debug('CH_MonitorCountryDiffBatch - check9 size '+ countCheck9);
		
		
		if(chatterPostsList.size()>0){
			system.debug('CH_MonitorCountryDiffBatch - chatterPostsList size= '+chatterPostsList.size());
			insert chatterPostsList;
		} 
	}
	
	global void finish(Database.BatchableContext BC){
		system.debug('CH_MonitorCountryDiffBatch - FINISH');
	}
	
	
	global void execute(SchedulableContext sc)
	{
		// We now call the batch class to be scheduled
		CH_MonitorCountryDiffBatch b = new CH_MonitorCountryDiffBatch (CHATTER_GROUP_NAME, REPLY_EMAIL);
		
		//Parameters of ExecuteBatch(context,BatchSize)
		database.executebatch(b,2000);
	}
	
	
}