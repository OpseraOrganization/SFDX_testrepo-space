@isTest(SeeAllData=true)
public class GenericListViewTest
{    
  
    public testMethod static void testMethod1()
    { 
         List<sObject> recList = GenericListView.getRecordList('ASC','name','Discretionary__c');
         Discretionary__c opp = [select id,name from Discretionary__c limit 1];
         List<sObject> recListId = GenericListView.getRecordListWithId('ASC','name','Discretionary__c',opp.id);
         String temp = GenericListView.getUIThemeDescription();
         temp = GenericListView.deleteRecord(opp.id);        
         List<sObject> recListAll = GenericListView.getRecordListWithAll('ASC','name','Discretionary__c',opp.id);
    }
}