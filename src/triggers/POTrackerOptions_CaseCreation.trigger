trigger POTrackerOptions_CaseCreation on BGA_PO_Tracker_Entry__c (after insert) 
{
     /*commenting trigger code for coverage
     list<case>insertcaselist= new list<case>();
     list<AccountTeamMember>accteamlist= new list<AccountTeamMember>();
     list<account>updateacclist= new list<account>();
     list<BGA_PO_Tracker_Entry__c>bgalist=new list<BGA_PO_Tracker_Entry__c>();
     set<id> accid= new set<id>();
     set<id> bgaid= new set<id>();
     map<id,id>accmap= new map<id,id>();
      map<id,id> accteammap=new map<id,id>();
     set<string> productname=new set<string>();
     list<PO_tracker_Case_Creation_Products__c>polist=new list<PO_tracker_Case_Creation_Products__c>();
     map<string,string> pomap=new map<string,string>();
     id recordtypeid = [select id from recordtype where name = 'RMU EIS' limit 1].id;
     for(BGA_PO_Tracker_Entry__c bga : Trigger.new)
     {
        bgaid.add(bga.id);
     }
     bgalist=[select id,BGA_Purchase_Order__c,BGA_Purchase_Order__r.Charts_Platform_Family__c,BGA_Purchase_Order__r.Make_Model__c,Customer_Request_Ship_Date__c,
              BGA_Purchase_Order__r.SN__c,BGA_Purchase_Order__r.Region__c,BGA_Purchase_Order__r.Account__c,Product_Name__c,Product__r.name,
              Retrofit_or_Completion__c,Product__c,Fleet_Asset_Aircraft__c from BGA_PO_Tracker_Entry__c where id IN:bgaid];
     
     for(BGA_PO_Tracker_Entry__c bga : bgalist)
     {
        productname.add(bga.Product_Name__c);
        if(bga.BGA_Purchase_Order__r.Account__c!=null)
        {
            accmap.put(bga.BGA_Purchase_Order__r.Account__c,bga.id);
            accid.add(bga.BGA_Purchase_Order__r.Account__c);
        }
           
     }
     system.debug('accmap****************'+accmap);
     system.debug('jagsdjghajsdgh'+accid);
     polist=[select name,Product_Name_del__c from PO_tracker_Case_Creation_Products__c where Product_Name_del__c in:productname];
     for(PO_tracker_Case_Creation_Products__c p: polist)
        pomap.put(p.Product_Name_del__c,p.Product_Name_del__c);
    
     if(accmap.size()>0)
     {
        accteamlist=[select id,AccountId, UserId from AccountTeamMember where accountid IN: accid and TeamMemberRole='Customer Service Manager'];
        for(AccountTeamMember acc: accteamlist)
        {
            system.debug('accmap$$$$$$$$$$$$$$$$$'+accmap.containskey(acc.accountid));
            if(accmap.containskey(acc.accountid))
                accteammap.put(accmap.get(acc.accountid),acc.UserId);
        }
           
     }
     for(BGA_PO_Tracker_Entry__c bga : bgalist)
     {
        system.debug('bga.product__r.name****************'+ accteammap.get(bga.id));
        if(Bga.Product__c!=null && pomap.get(bga.Product_Name__c)!=null)
        {
            case c= new case();
            c.RecordTypeId=recordtypeid;
            system.debug('bga.BGA_Purchase_Order__r.Make_Model__c***************'+bga.BGA_Purchase_Order__r.Make_Model__c);
          //  c.Subject=bga.Product__r.name+' - '+bga.BGA_Purchase_Order__r.Charts_Platform_Family__c+' &' +bga.BGA_Purchase_Order__r.Make_Model__c+' - '+bga.BGA_Purchase_Order__r.SN__c;
             c.Subject=bga.Product__r.name+' - '+bga.BGA_Purchase_Order__r.Make_Model__c+' - '+bga.BGA_Purchase_Order__r.SN__c;
            c.Aircraft_Name__c=bga.Fleet_Asset_Aircraft__c;
            c.Make__c=bga.BGA_Purchase_Order__r.Charts_Platform_Family__c;
            c.Model__c=bga.BGA_Purchase_Order__r.Make_Model__c;
            c.Serial_Number__c=bga.BGA_Purchase_Order__r.SN__c;
            c.CSM_Region__c=bga.BGA_Purchase_Order__r.Region__c;
            c.Product__c=bga.Product__c;
            c.BGA_Dealer_Name__c=bga.Retrofit_or_Completion__c;
            c.AccountId=bga.BGA_Purchase_Order__r.Account__c;
            if(accteammap.containskey(bga.id))
               c.OwnerId=accteammap.get(bga.id);
            else
               c.OwnerId=label.Steve_Ferensak_User_Id;
           c.Due_Date__c=bga.Customer_Request_Ship_Date__c;
           c.PO_Tracker__c=bga.BGA_Purchase_Order__c;
            insertcaselist.add(c); 
        }
     }
    
    insert insertcaselist;*/
    
   /* for(case c: insertcaselist)
    {
        if(c.Accountid!=null)
          accid.add(c.Accountid);
    }
   acclist=[select id,Po_Tracker_Email_Check__c from account where id IN: accid];
   for(Account acc: acclist)
   {
    acc.Po_Tracker_Email_Check__c=true;
    updateacclist.add(acc);
   }
   update  updateacclist;**/
}