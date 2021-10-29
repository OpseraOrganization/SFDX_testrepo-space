public class RemovalsReport{
public List<Removals__c> removals{get;set;}
public List<Removals__c> removalsclosed{get;set;}
public Document doc{get;set;}
public Document doc1{get;set;}
public Document doc2{get;set;}
public Document doc3{get;set;}
public Document doc4{get;set;}
public Document doc5{get;set;}
public Document doc6{get;set;}
String serverUrl;
Boolean ontest;
Integer countred=0;
public string test{get;set;}
Public List<Removals__c> getremovals(){

system.debug('####'+removals);
return removals;
}
public List<Removals__c> getremovalsclosed(){

return removalsclosed;
}
public RemovalsReport()
{ 
doc= new document();
doc=[select id,lastModifieddate from document where id='015130000039Zuf'];
doc1=new document();
doc1=[select id,lastModifieddate from document where id='015130000039Zuk'];
doc2=new document();
doc2=[select id,lastModifieddate from document where id='015130000039Zup'];
doc3=new document();
doc3=[select id,lastModifieddate from document where id='015130000039Zuu'];
doc4=new document();
doc4=[select id,lastModifieddate from document where id='015130000039Zuz'];
doc5=new document();
doc5=[select id,lastModifieddate from document where id='015130000039Zv4'];
doc6=new document();
doc6=[select id,lastModifieddate from document where id='015130000039Zv9'];
removals=new list<Removals__c>();
removalsclosed=new list<Removals__c>();
  removals=[select Id,CAR_Number__c,Root_Cause_Status__c,In_Service_Impact__c,RPN__c,Failure_Date__c,Removed_P_N__c,Unit_Name__c,Open_Age_in_Days__c,Program_Manager__c,Project_Engineer__c,Removals_Service_Level__c ,Removals_Service_level_Value__c from Removals__c where Root_Cause_Status__c!='Closed' order by  In_Service_Impact__c desc];
  removalsclosed=[select Id,CAR_Number__c,Root_Cause_Status__c,In_Service_Impact__c,RPN__c,Failure_Date__c,Removed_P_N__c,Unit_Name__c,Open_Age_in_Days__c,Program_Manager__c,Project_Engineer__c,Removals_Service_Level__c ,Removals_Service_level_Value__c from Removals__c where Root_Cause_Status__c ='Closed' order by In_Service_Impact__c desc];
        }
public string getserverUrl()
{
  serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
  return serverUrl;
}
public Boolean getontest(){
    return ontest;
}
}