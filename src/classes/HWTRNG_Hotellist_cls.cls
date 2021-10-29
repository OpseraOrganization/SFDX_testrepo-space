public class HWTRNG_Hotellist_cls {
Set<String> strlist = new SEt<String>();
public Set<String> getallregions()
{
 List<Location__c> loclist = [select name , id,region__c from Location__c 
where Record_Type_Name__c='Hotel' ];
for(integer i=0;i<loclist.size();i++)
{
strlist.add(loclist[i].region__c);
} 
return strlist;
}
}