/*****************************************************************
Name            :   CPNFromAccountAddress
Created By      :   Shanthi
Company Name    :   NTTData
Created Date    :   01-JAN-2020
Usages          :   To make customizations on CPN Form
******************************************************************/
public class CPNFromAccountAddress {
    
    public static void getDistributorLineItems(List<Channel_Partner_Nomination__c> CPNlst){
      
        set<id> accountId = new set<id>();
        set<id> accountAddId = new set<id>();
        list<String> temp1;
           Set<String> setDistributorProducts = new set<String>();
           Set<String> setRepLocatorProds = new set<String>();
        for(Channel_Partner_Nomination__c objCPN : CPNlst){
            if(objCPN != null){
                accountId.add(objCPN.Account__c);
                accountAddId.add(ObjCPN.Id);
                system.debug('account Id:::::'+accountId);
            }
        }
        
        Map<id,List<Account_Address__c>> accAddMap  = new Map<id,List<Account_Address__c>>();
     for(Account_Address__c objAccAdd :[select Id,Account_Name__r.name,Account_Name__r.Type,Account_Name__r.Sub_Region_Name__c,Distributor_Sub_Category__c,Rep_Locator_Products__c from Account_Address__c where Rep_Locator_Visibility__c = true and account_name__c IN: accountId])    
  	{
      if(objAccAdd != null && !accAddMap.containsKey(objAccAdd.Account_Name__c)){
      accAddMap.put(objAccAdd.Account_Name__c,new List<Account_Address__c> {objAccAdd} );
          system.debug('Account Address :::'+accAddMap.get(objAccAdd.Account_Name__c));
      }
      else
      {
           accAddMap.get(objAccAdd.Account_Name__c).add(objAccAdd);
          
   }
    }
        List<Account_Address__c> accAddLst = new List<Account_Address__c>();
       
        for(Channel_Partner_Nomination__c objCPN : CPNlst)
        {
            if(objCPN != Null && accAddMap!=null && accAddMap.containsKey(objCPN.Account__c)){
           accAddLst = accAddMap.get(objCPN.Account__c);
            system.debug('Values in accAddLst...!!'+accAddLst);
            }
        }
        
        for(Account_Address__c  objAccAdd: accAddLst){
            
        if(objAccAdd.Distributor_Sub_Category__c != Null){
           setDistributorProducts.addAll(objAccAdd.Distributor_Sub_Category__c.split(';'));
        }
        if(objAccAdd.Rep_Locator_Products__c != Null ){
             setRepLocatorProds.addAll(objAccAdd.Rep_Locator_Products__c.split(';'));
        }
        }
          String tempDistrubtorProds=''+setDistributorProducts;
          String tempRepLocatorProds= ''+setRepLocatorProds;
          
         if(string.isNotBlank(tempRepLocatorProds) ){
           tempDistrubtorProds = tempDistrubtorProds.remove('{');
            tempDistrubtorProds = tempDistrubtorProds.remove('}');
         }
        if(string.isNotBlank(tempDistrubtorProds)){
            tempRepLocatorProds= tempRepLocatorProds.remove('{');
            tempRepLocatorProds= tempRepLocatorProds.remove('}');
            
         }
         map<id,Account> mapAccName = new map<id,Account>();
        if(accountId != null)
        {
        for(Account objAcc : [select Id,name,type,Sub_Region_Name__c,(select Id from Account_Address__r where Rep_Locator_Visibility__c = true) from Account where Customer_Status__c = 'Active' and (ATR_Channel_Partner__c = true or BGA_Account__c = true or D_S_Channel_Partner__c = true)
                              and Id in:accountId]){
            if(objAcc.Account_Address__r != null && objAcc.Account_Address__r.size() > 0 ){
                mapAccName.put(objAcc.id,objAcc);
            }
            }
        }
  
        for(Channel_Partner_Nomination__c objCPN : CPNlst)
            {  
             objCPN.Products_and_Services__c = tempRepLocatorProds; 
             objCPN.Current_Products_and_Services__c = tempDistrubtorProds;    
            if(!mapAccName.isEmpty() && mapAccName.containsKey(objCPN.Account__c)&&(mapAccName.get(objCPN.Account__c).Type == objCPN.Type__c )&&( mapAccName.get(objCPN.Account__c).Sub_Region_Name__c == objCPN.Target_Market_Sub_Region__c)){
            objCPN.Current_HON_Channel_Serving_Market__c = mapAccName.get(objCPN.Account__c).name;
                system.debug('Account Name::::'+mapAccName.get(objCPN.Account__c).name);
            }
    }      
}

 public static Void legalApproverField(List<Channel_Partner_Nomination__c> cpnLst){
 for(Channel_Partner_Nomination__c objCPN1: cpnLst){
 
   try{ 
      if(objCPN1.Legal_Approval__c == True && objCPN1.Legal_team_Consulted__c == Null && objCPN1.Approved_By_Legal__c == False){
              objCPN1.Legal_Approval__c = False;   
              objCPN1.addError('Please enter your option for Any Claims or Adverse Conditions?');    
           } 
           }
           catch(Exception e){
                   objCPN1.addError(e.getmessage());
           }
           
         }
     }
 
 public static void getAttachments(List<Channel_Partner_Nomination__c> lstCPN)
 {
 set<id> setCPN = new set<id>();
 list<Channel_Partner_Nomination__c> lstCPNUpdte = new list<Channel_Partner_Nomination__c>();
  list<Attachment> lstAttachments = new list<Attachment>();
  map<id,id> mapcpnAttachCount = new map<id,id>();
 for(Channel_Partner_Nomination__c objCPN1 : lstCPN){
  if(objCPN1.Check_Attachment__c == false && objCPN1.Approval_Status__c == Null){
    setCPN.add(objCPN1.id);
    }
   }
 if(!setCPN.isempty()){
 for(Attachment objAtt : [SELECT  id,Parent.Id FROM Attachment WHERE Parent.Type = 'Channel_Partner_Nomination__c' and Parent.Id in :setCPN]){
      mapcpnAttachCount.put(objAtt.Parent.Id,objAtt.id);
 }
 
 for(Channel_Partner_Nomination__c objCPN  : lstCPN){
   if( !mapcpnAttachCount.containskey(objCPN.id)){
      objCPN.Check_Attachment__c = True;
   }
 }
 }
 }
 }