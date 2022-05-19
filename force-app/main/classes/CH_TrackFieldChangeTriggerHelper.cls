/****************************************
 * Class Name : CH_TrackFieldChangeTriggerHelper 
 * Created Date: 19 November 2018
 * Created By : aelhitary
 * Last Modified by: aelhitary
 * Last Modified Date: 19 November 2018
 * Description : Contains common business logic
 * Test Class: CH_TrackFieldChangeTriggerHelperTest
 *****************************************/

public class CH_TrackFieldChangeTriggerHelper{
	/********************
	* Method Name: duplicateRecordCheck
	* Parameter: List < CH_Track_Field_Change__c >
	* Description: Used to replace ID with names in CH_Track_Field_Change__c custom object
	* Reference: 
	*******************/
	public static void replaceIDwithName(List < CH_Track_Field_Change__c > newTFCList) {
		 
		map<String,  map<id, String> > sObjectIDsNames = new Map <String,  map<id, String> > ();
		Schema.SObjectType sobjectType= null;
		String myStringId;
		id myId;
		String sobjectName;
		
		//filling the map  for each Sobject list of ID/null map
		for (CH_Track_Field_Change__c tfc :newTFCList){
			myStringId = tfc.Text_new__c;
			if (myStringId instanceOf Id){
	myId = myStringId;
	sobjectType = myId.getSObjectType();
	sobjectName = sobjectType.getDescribe().getName();
	if (!sObjectIDsNames.containsKey(sobjectName)){
		sObjectIDsNames.put(sobjectName, new Map<id, String>());
	}
	sObjectIDsNames.get(sobjectName).put(myId,null);
			}
			myStringId = tfc.Text_old__c;
			if (myStringId instanceOf Id){
	myId = myStringId;
	sobjectType = myId.getSObjectType();
	sobjectName = sobjectType.getDescribe().getName();
	if (!sObjectIDsNames.containsKey(sobjectName)){
		sObjectIDsNames.put(sobjectName, new Map<id, String>());
	}
	sObjectIDsNames.get(sobjectName).put(myId,null);
			}
		}
		List<SObject> records;
		List<id>idsList;
		// here is my first query in loop 8) 
		// prforming query for each Sobject type , getting the names and putting theme next to there ids in the map
		for (String mySobject : sObjectIDsNames.keySet()){
			idsList=  new List<id>() ;
			idsList.addAll(sObjectIDsNames.get(mySobject).keySet());
			if(mySobject == 'Case'){
				records = Database.query('Select Id, CaseNumber From ' + mySobject + ' Where Id IN :idsList');
	for(SObject myObject :  records ){
		sObjectIDsNames.get(mySobject).put(myObject.id,(String)myObject.get('CaseNumber')) ;
	}
			}
			else{
				records = Database.query('Select Id, Name From ' + mySobject + ' Where Id IN :idsList');
				for(SObject myObject :  records ){
					sObjectIDsNames.get(mySobject).put(myObject.id,(String)myObject.get('Name')) ;
				}
			}
		}
		//replacing the ids by names in the Sobject
		for (CH_Track_Field_Change__c tfc :newTFCList){
			myStringId = tfc.Text_new__c;
			if (myStringId instanceOf Id){
	myId = myStringId;
	sobjectType = myId.getSObjectType();
	sobjectName = sobjectType.getDescribe().getName();
	if (!sObjectIDsNames.containsKey(sobjectName)){
		sObjectIDsNames.put(sobjectName, new Map<id, String>());
	}
	tfc.Text_new__c = sObjectIDsNames.get(sobjectName).get(myId);
	tfc.Id_new__c = myId;
			}
			myStringId = tfc.Text_old__c;
			if (myStringId instanceOf Id){
	myId = myStringId;
	sobjectType = myId.getSObjectType();
	sobjectName = sobjectType.getDescribe().getName();
	if (!sObjectIDsNames.containsKey(sobjectName)){
		sObjectIDsNames.put(sobjectName, new Map<id, String>());
	}
	tfc.Text_old__c = sObjectIDsNames.get(sobjectName).get(myId);
	tfc.Id_old__c = myId;
			}
		}

	}
	public static void bouleanLargeLetters(List < CH_Track_Field_Change__c > newTFCList) {
		//replacing the value to have first letter in large
		for (CH_Track_Field_Change__c tfc :newTFCList){
			if (tfc.Text_new__c == 'true' )  tfc.Text_new__c = 'True' ; 
			if (tfc.Text_old__c == 'true' )  tfc.Text_old__c = 'True' ; 
			if (tfc.Text_new__c == 'false' )  tfc.Text_new__c = 'False' ; 
			if (tfc.Text_old__c == 'false' )  tfc.Text_old__c = 'False' ; 
		}
	}

}