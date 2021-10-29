trigger FundingIncreaseApproved on Discretionary__c (after update,after insert,before update) {
list <ID> DisId = new List<ID>();
if((trigger.isafter) && (trigger.isUpdate)){
for(Discretionary__c DiscNew : Trigger.new)
{
 if(Trigger.newMap.get(DiscNew.id).approval_status__c!=Trigger.oldMap.get(DiscNew.id).approval_status__c && Trigger.newMap.get(DiscNew.id).approval_status__c == 'Approved')
    {
     DisId.add(DiscNew.id); 
    }
  }
    System.debug ('DisIdsize'+DisId.size());
    if (DisId.size()>0)
    {
 list <Discretionary_line_item__c> DliList = [select ID, Discretionary_Account__c from Discretionary_line_item__c
                                                 where  Discretionary_Request__c in :DisId and Discretionary_Account__c != '']; 
    System.debug ('DliListsize'+DliList.size());
  if (DliList.size()>0)
    {
    For (integer i=0; i<DliList.size(); i++)
    {
    DliList[i].Funding_Amount_Change_Approved__c = True;
    Update DliList[i];
    }
    }
    }
 }   
    
 if(((trigger.isafter) && (trigger.isInsert))  || ((trigger.isbefore) && (trigger.isUpdate))){
    

 


 List<Discretionary__Share> olddrShares;
 
 List<Discretionary__Share> newdrShares = new List<Discretionary__Share>();
 Set<id> opps = new Set<id>();
 for(Discretionary__c t : trigger.new){
 if(t.Opportunity__c != null){
                  opps.add(t.Opportunity__c);
                  system.debug('@@ record share 1 '+opps);
                  }
             } 
             
     
list<Opportunity_Sales_Team__c> Oppmem = new list<Opportunity_Sales_Team__c>([select id,Opportunity__c, User__r.Id from Opportunity_Sales_Team__c where Opportunity__c in :opps]);

system.debug('@@ opp mem'+oppmem);
 
  Map<id,list<Opportunity_Sales_Team__c>> teamMap= new Map<id,list<Opportunity_Sales_Team__c>>();
  list<Opportunity_Sales_Team__c> OldOppmem = new list<Opportunity_Sales_Team__c>();
   if(oppmem.size()>0){
     for(integer i = 0; i<oppmem.size(); i++){
     
     if(teamMap.containskey(oppmem[i].Opportunity__c)){
     
     OldOppmem =teamMap.get(oppmem[i].Opportunity__c);
     if(!OldOppmem.contains(oppmem[i])){
     OldOppmem.add(oppmem[i]);
     teamMap.put(oppmem[i].Opportunity__c,OldOppmem);
     }
     }else{
        list<Opportunity_Sales_Team__c> newOppmem = new list<Opportunity_Sales_Team__c>();
        newOppmem.add(oppmem[i]);
        teamMap.put(oppmem[i].Opportunity__c,newOppmem);
     }
    }
   }
     
  //list<Discretionary__c> oppdr = new list<Discretionary__c>([select id, Opportunity__c from Discretionary__c where Opportunity__c in :opps ]);
   Map<ID, Discretionary__c> jobMap = new Map<ID, Discretionary__c>([select id, Opportunity__c from Discretionary__c where Opportunity__c in :opps]); 
   /* for(Integer i=0;i<oppdr.size();i++){
       if(jobMap.containskey(oppdr[i].id)){
         
       }else{
       
       }
    
    } */

    //Set<id> drIds = new Set<id>();
    //Set<id> oppIds = new Set<id>();
   
      //List<Discretionary__share> jobShares = new List<Discretionary__share>();
  /*list<id> opps = new list<id>();
   for(Discretionary__c s :oppdc)
    {
    opps.add(s.id);
    } */

    
    olddrShares =[select UserOrGroupId,ParentId,AccessLevel,RowCause from Discretionary__Share where ParentId in:jobMap.keyset() and RowCause = :Schema.Discretionary__Share.RowCause.OppTeamShare__c and AccessLevel = 'Edit'];

    for(Discretionary__c dr : jobMap.values()){
     if(teamMap.containskey(dr.Opportunity__c)){
      for(Integer i=0;i<teamMap.get(dr.Opportunity__c).size();i++){
       
      // for(Discretionary__Share dsh:olddrShares){
      // if(dsh.ParentId != dr.id && dsh.UserOrGroupId != teamMap.get(dr.Opportunity__c)[i].User__r.Id && dsh.AccessLevel != 'edit' && dsh.RowCause != Schema.Discretionary__Share.RowCause.OppTeamShare__c)
       Discretionary__Share drShare = new Discretionary__Share();

       drShare.ParentId = dr.id;

       drShare.UserOrGroupId = teamMap.get(dr.Opportunity__c)[i].User__r.Id;
 
       drShare.AccessLevel = 'edit';
    
       drShare.RowCause = Schema.Discretionary__Share.RowCause.OppTeamShare__c;
     
       newdrShares.add(drShare);
       
       //} 
      
      } 
       //drIds.add(dr.id);
       //oppIds.add(dr.Opportunity__c);
     }
    }
    
     try{
        delete olddrShares;
        
        Database.SaveResult[] DRShareInsertResult = Database.insert(newdrShares,false);
     
     }catch(Exception e){
        
     
     }
    
    
         
    
 }
}