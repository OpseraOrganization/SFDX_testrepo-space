public class GenericListView {

    @AuraEnabled
    public static List<sObject> getRecordList(string sortOrder, string fieldNames, string objectName) {
        
        //Note: SQL Injection best practice
        fieldNames = String.escapeSingleQuotes(fieldNames);
        objectName = String.escapeSingleQuotes(objectName);
             
        List<sObject> myList = new List<sObject>();

        if(sortOrder == 'ASC')
        {
          myList = Database.query('SELECT  id, ' + fieldNames + ' FROM ' + objectName + ' ORDER BY NAME ASC LIMIT 100');

        }else{
          myList = Database.query('SELECT id, ' + fieldNames + ' FROM ' + objectName + ' ORDER BY NAME DESC LIMIT 100');

        }   
        
        return myList;  
     
    }
    
    @AuraEnabled
    public static List<sObject> getRecordListWithId(string sortOrder, string fieldNames, string objectName, string recordId) {
        
        //Note: SQL Injection best practice
        fieldNames = String.escapeSingleQuotes(fieldNames);
        objectName = String.escapeSingleQuotes(objectName);
        system.debug('fieldNames :'+fieldNames);
        system.debug('objectName :'+objectName);
        List<sObject> myList = new List<sObject>();

        if(sortOrder == 'ASC')
        {
          myList = Database.query('SELECT id ,' + fieldNames + ' FROM ' + objectName + ' WHERE Opportunity__c  =: recordId ORDER BY NAME ASC LIMIT 100');

        }else{
          myList = Database.query('SELECT ' + fieldNames + ' FROM ' + objectName + ' WHERE Opportunity__c  =: recordId ORDER BY NAME DESC LIMIT 100');

        }   
        
        return myList;  
     
    }
    //
      @AuraEnabled
    public static List<sObject> getRecordListWithAll(string sortOrder, string fieldNames, string objectName, string recordId) {
        
        //Note: SQL Injection best practice
        fieldNames = String.escapeSingleQuotes(fieldNames);
        objectName = String.escapeSingleQuotes(objectName);
        system.debug('fieldNames :'+fieldNames);
        system.debug('objectName :'+objectName);
        List<sObject> myList = new List<sObject>();

        if(sortOrder == 'ASC')
        {
          myList = Database.query('SELECT id ,' + fieldNames + ' FROM ' + objectName + ' WHERE Opportunity__c  =: recordId ORDER BY NAME ASC LIMIT 100');

        }else{
          myList = Database.query('SELECT ' + fieldNames + ' FROM ' + objectName + ' WHERE Opportunity__c  =: recordId ORDER BY NAME DESC LIMIT 100');

        }   
        
        return myList;  
     
    }
    
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
    
    @AuraEnabled
    public static String deleteRecord(String id){
        try{
            Database.DeleteResult delResult = Database.delete(id);
            if(delResult.isSuccess()){
                return 'Record Deleted Successfully';
            }
        }catch(Exception e){
            return 'Exception :'+e.getMessage();
        }
        return 'Success';
    }

}