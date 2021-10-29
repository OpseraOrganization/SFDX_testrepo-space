public class contactCaseController {
     
    /*

     * This function will fetch the RecordTypes of

     * provided object and will return a map of

     * recordTypeId and recordTypeNames

     * it excludes 'master' record type

     * */
    @AuraEnabled
    public string accounttId {get; set;}
    @AuraEnabled
    public  Map<Id, String> contactRecordTypes {get; set;}
    public static Map<Id, String> recordtypemap;

@AuraEnabled  
    public static contactCaseController fetchRecordTypeValues(Id casId){
        Contact c = [Select id,AccountId from Contact where id=:casId];
       contactCaseController obj = new contactCaseController();
        // Map<Id, String> recordtypeMap = new Map<Id, String>();
       List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfos();    
      //List<Schema.RecordTypeInfo> recordtypes = Case.SObjectType.getDescribe().getRecordTypeInfos();
        recordtypemap = new Map<Id, String>();

        for(RecordTypeInfo rt : recordtypes){

            if(rt.getName() != 'Master' && rt.getName().trim() != '')

            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
           
        } 
       
       obj.contactRecordTypes = recordtypemap;
        
        if(c.AccountId != null){
            obj.accounttId = c.AccountId;
        }
        return obj;

    }

}