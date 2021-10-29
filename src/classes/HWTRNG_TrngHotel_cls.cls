public class HWTRNG_TrngHotel_cls {

String str = ApexPages.currentPage().getParameters().get('region');

public String getstr(){
return str;
}
List<Location__c> strlist = new List<Location__c>();
public List<Location__c> getallregions()
{
 List<Location__c> loclist = [select name , id,region__c,street__c,city__c,postal_code__c,state__c,
    Amenities__c,Primary_Contact__c,Transportation_Provided__c,Distance__c,Contact_Address__c
 from
 Location__c where region__c = :str and record_type_name__c='Hotel' ]; 

return loclist;
}
}