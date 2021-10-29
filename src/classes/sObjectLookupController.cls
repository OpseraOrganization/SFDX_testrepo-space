/**
 * Created by Satya Mohanty on 11/18/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public with sharing class sObjectLookupController {
    @AuraEnabled
    public static List<sObject> searchRecord(String objectAPIName, String fieldAPIName,List<String> moreFields, String searchText,Integer recordLimit)
    {
        List<sObject> objectList =  new List<sObject>();

        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

        String soqlQuery = 'SELECT Id, Name';
        if(!moreFields.isEmpty()){
            soqlQuery = soqlQuery + ',' + String.join(moreFields, ',') ;
        }
        soqlQuery = soqlQuery + ' FROM ' + objectAPIName + ' WHERE ' +
                + fieldAPIName +' LIKE '+ searchText + ' LIMIT '+ recordLimit;

        objectList = Database.query(soqlQuery);
        return objectList;
    }
}