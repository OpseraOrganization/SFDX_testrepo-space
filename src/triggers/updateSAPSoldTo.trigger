//The trigger is created for the INC000008923162 to populate SAP Sold To# on Account
trigger updateSAPSoldTo on Account_Cross_Ref__c (after insert,after update) {
    Map<ID, Account> AccMap = new Map<ID, Account>(); //Making it a map instead of list for easier lookup
    List<Id> listIds = new List<Id>();
    List<Account_Cross_Ref__c> listIds1 = new List<Account_Cross_Ref__c>();
    List<Account> Accupdate = new List<Account>();
    
    for (Account_Cross_Ref__c childObj : Trigger.new) {
        if(null!=childObj.XREF_Type__c && null!= childObj.XREF_Name__c && childObj.XREF_Type__c=='SAP_SOLD_TO' && childObj.XREF_Name__c=='SAP' )
        {
            listIds1.add(childobj);
            listIds.add(childObj.Account_Name__c);
        }
    }
    
    for(Account acc: [SELECT id, SAP_Account_Name__c,SAP_Sold_To__c,(SELECT ID,XREF_Type__c,XREF_Name__c,External_Account_ID__c,External_Account_Name__c FROM Account.Account_Cross_Ref__r) FROM Account WHERE ID IN :listIds]){
        AccMap.put(acc.id,acc);  
    }
    
    
    for (Account_Cross_Ref__c quote: listIds1){
        
        if(null!=quote.XREF_Type__c && quote.XREF_Type__c=='SAP_SOLD_TO' && null!= quote.XREF_Name__c && quote.XREF_Name__c=='SAP' ){
            Account myParentAcc = AccMap.get(quote.Account_Name__c);
            myParentAcc.SAP_Account_Name__c = quote.External_Account_Name__c;
            myParentAcc.SAP_Sold_To__c = quote.External_Account_ID__c;
            Accupdate.add(myParentAcc); 
        }
    }
    
    if(Accupdate.size() >0)
        update Accupdate;
    
}