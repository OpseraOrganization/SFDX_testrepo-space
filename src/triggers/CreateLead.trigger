trigger CreateLead on Task (after update) {
    List<Lead> leadList = new List<Lead>();
    set<id> userIds = new set<id>();
    set<id> acctIds = new set<id>();
    set<id> contIds = new set<id>();
    set<id> faaIds = new set<id>();
    map<id,string> userNameMap = new map<id,string>();
    map<id,string> accountNameMap = new map<id,string>();
    map<id,Contract> contractNameMap = new map<id,Contract>();
    map<id,Opportunity> opportunityMap = new map<id,Opportunity>();
    map<id,Fleet_Asset_Detail__c> fleetAssetDetailMap = new map<id,Fleet_Asset_Detail__c>();
    
    for(Task t :trigger.new){
    acctIds.add(t.Accounts_Name__c);
    contIds.add(t.whatId);
    faaIds.add(t.whatId);
    }
    for(User usr:[select id,LastName from User where id in :userIds]){
        userNameMap.put(usr.id,usr.LastName);
    }
    for(Account acct:[select id,Name from Account where id in :acctIds]){
        accountNameMap.put(acct.id,acct.Name);
    }
    
    for(Contract cont:[select id,Name,Aircraft__c,Aircraft_Type__c,Aircraft__r.Tail_Number__c,
     Aircraft__r.Serial_Number__c,Contract_Origin__c from Contract where id in :contIds]){
        contractNameMap.put(cont.id,cont);
    }
    for(Opportunity opp:[select id,Name,Aircraft_Ref__c from Opportunity where id in :contIds]){
        opportunityMap.put(opp.id,opp);
    }
    for(Fleet_Asset_Detail__c faa:[select id,Name,Serial_Number__c,Tail_Number__c,Platform_Name__c from Fleet_Asset_Detail__c where id in :faaIds]){
        fleetAssetDetailMap.put(faa.id,faa);
    }
        for(Task t :trigger.new){
        if(t.Create_Lead__c){
        Contract contractLocal= contractNameMap.get(t.whatId);
        Opportunity oppLocal = opportunityMap.get(t.whatId);
        Fleet_Asset_Detail__c faaLocal = fleetAssetDetailMap.get(t.whatId);
        Lead lead = new Lead();
        lead.Status = 'Sales Qualified Lead (SQL)';
        lead.LeadSource = 'Happ/MSP';
        lead.Lead_Market_Selection__c = 'Business Aviation';
        lead.Opportunity_Search_Confirmation__c = true;
        lead.Company = accountNameMap.get(t.Accounts_Name__c);
        lead.Lead_Region__c = t.Region__c;
        lead.GBE__c = 'Cockpit Systems';
        lead.RecordTypeId = Label.LeadConvertLayout;
                
        lead.Account__c = t.Accounts_Name__c;
            if(contractLocal != null){
                lead.Contract__c = t.whatId;
                lead.ATR_Product_Information__c = contractLocal.Name;
                lead.Aircraft_Type__c = contractLocal.Aircraft_Type__c;
                lead.Aircraft_Tail_Number__c = contractLocal.Aircraft__r.Tail_Number__c;
                lead.Aircraft_Serial_Number__c = contractLocal.Aircraft__r.Serial_Number__c;
                lead.Aircraft__c = contractLocal.Aircraft__c;
                
                
            }
            if(faaLocal != null){
                lead.Aircraft__c = t.whatId;
                lead.ATR_Product_Information__c = faaLocal.Name;
                lead.Aircraft_Type__c = faaLocal.Platform_Name__c;
                lead.Aircraft_Tail_Number__c = faaLocal.Tail_Number__c;
                lead.Aircraft_Serial_Number__c = faaLocal.Serial_Number__c;
                lead.OEM_Warranty_Expiraton__c = true;
             }   
            if(oppLocal != null){
                lead.Aircraft__c = oppLocal.Aircraft_Ref__c;
            }
          leadList.add(lead);
        }
    
    }
    system.debug('From the trigger:'+leadList);
    insert leadList;
}