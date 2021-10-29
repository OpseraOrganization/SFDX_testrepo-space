public class HWTRNG_TrngLoc2_cls {

String str = ApexPages.currentPage().getParameters().get('region');
List<Location__c> strlist = new List<Location__c>();
public List<Location__c> getallregions()
{
List<Location__c> loclist = [select name , id,region__c,street__c,city__c,postal_code__c,state__c from
 Location__c where region__c = :str and record_type_name__c='HoneywellTraining Location' and public__c = True];


return loclist;
}
public string getstr()
{
return str;
}
}