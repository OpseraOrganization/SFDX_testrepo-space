/**
* @author Luis Camacho
* @date 10/30/2017
*
* @description Genric record type service class to get record type from by object, name, developername or id
*/
public with sharing class RecordTypeServices {
	
	private static Map<String, Schema.SObjectType> globalDescribeObject {
		get{
			if(globalDescribeObject == null){
				globalDescribeObject = Schema.getGlobalDescribe();
			}
			return globalDescribeObject;
		}
		set;
	}
   
    
    public static List<RecordTypeClass> getRecordTypesForSObjectType(string sObjectType) {
        
        DescribeSObjectResult result = globalDescribeObject.get(sObjectType).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = result.getRecordTypeInfos();
        List<RecordTypeClass> recordTypeList = new List<RecordTypeClass>();
        
        for(Schema.RecordTypeInfo rType : recordTypeInfo){
        		recordTypeList.add(new RecordTypeClass(rType.getRecordTypeId(), rType.getName(), rType.isAvailable()));
        }
        
        return recordTypeList;
    }
    
    public static RecordTypeClass getRecordTypeByName(String name, String sObjectType){
    	
        for(RecordTypeClass rtc : getRecordTypesForSObjectType(sObjectType)){  
        		if(rtc.Name == name){
        			return rtc;
        		}
        }
        return null;
    }
     
    
    public class RecordTypeClass{
    		public String Name {get; set;}
    		public String Id {get; set;}
    		public Boolean isAvailable {get; set;}
    		
    		public RecordTypeClass(string Id, string Name, boolean isAvailable){
    			this.Name = Name;
    			this.Id = Id;
    			this.isAvailable = isAvailable;
    		}
    }

}