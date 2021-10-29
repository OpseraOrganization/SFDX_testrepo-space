public with sharing class CSForce_SearchHelper {
/*
  <apex:inputField value="{!csSearch.name}"/>
        <apex:inputField value="{!csSearch.Story_Type__c}"/>
        <apex:inputField value="{!csSearch.Win_Against__c}"/>
        <apex:inputField required="true" value="{!csSearch.Products__c}"/>
        <apex:inputField value="{!csSearch.Sales_Reference__c}"/>
        <apex:inputField value="{!csSearch.Sharing_Restriction__c}"/>
*/

  public String title       {get; set;}
  public String link        {get; set;}
  public String storyType   {get; set;}
  public String winAgainst  {get; set;}
  public String products    {get; set;}
  public String synopsis    {get; set;}
  public String salesRef    {get; set;}
  public String sharingRes  {get; set;}
  
  public CSForce_SearchHelper(CustomerStory__c cs){
    title = cs.Name;
    link = '/'+cs.Id;
    storyType = cs.Story_Type__c;
    if(cs.Win_Again__c != null && cs.Win_Again__c.length()>0)
     winAgainst = cs.Win_Again__c.replace(';',', ');
    if(cs.Product__c != null )
     products = cs.Product_Name__c;
    if(cs.Synopsis__c != null && cs.Synopsis__c.length() >=50)
     synopsis = cs.Synopsis__c.substring(0,50)+'...';
    else
     synopsis = cs.Synopsis__c;
     system.debug('test111'+cs.callRef__c);
     system.debug('test2222'+cs.sharingR__c);
      if(cs.callRef__c != null)
      {
      salesRef = getImageUrl(cs.callRef__c);
      }
      if(cs.sharingR__c != null)
      {
      sharingRes = getImageUrl(cs.sharingR__c);
      }
  }
  
  public String getImageUrl(String img){
    integer s = img.indexOf('/');
    img = img.substring(s, img.length());
    integer e = img.indexOf('"');
    return img.substring(0,e);
  }

}