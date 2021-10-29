// test class DiscretionaryLineItem_UpdtEmalFieldsTest //
trigger SendEmailOnAPSOpenOrClose on Discretionary_Line_Item__c (after update) {
    List<Discretionary_Line_Item__c> dliList=Trigger.new;
    //List<id> contactIds=new List<id>();
    Set<Id> drIds=new Set<Id>();
    Set<Id> dliIds=new Set<Id>();
    for(Discretionary_Line_Item__c dli:dliList){
    //modify to include the condition to trigger only when closed
      if((System.Trigger.OldMap.get(dli.Id).Approval_Status__c !=System.Trigger.NewMap.get(dli.Id).Approval_Status__c)&& 
      (dli.Approval_Status__c=='Close' || dli.Approval_Status__c=='Open'  ))
      dliIds.add(dli.Id);
      
    }
    
if(dliIds.size()>0){
    
    /*List<Discretionary_Line_Item__c> plcodesList=[select id,Plant_Code__r.name from 
    Discretionary_Line_Item__c where id in: dliIds ];
        
    Map<Id,String> mapplantCode=new Map<Id,String>();
    
    for(Discretionary_Line_Item__c dl:plcodesList){
        mapplantCode.put(dl.Id,dl.Plant_Code__r.name);
    }*/
                for(Discretionary_Line_Item__c dli:dliList){
                
                //modify to include the condition to trigger only when closed
                //if((System.Trigger.OldMap.get(dli.Id).Approval_Status__c !=System.Trigger.NewMap.get(dli.Id).Approval_Status__c)&&
                  //(dli.Approval_Status__c=='Close' || dli.Approval_Status__c=='Open')){
                    /*Discretionary__c dr=[select id,name,Funding_Reason__c,Funding_Comments__c,
                    Total_Request_Amount_rollup__c,OwnerId,Type__c,Opportunity__r.name,Program__c,CBT__c,
                    Account__c,Account__r.name from Discretionary__c where id=:dli.Discretionary_Request__c];*/
                    
                    SendEmailToCCList secc=new SendEmailToCCList();
                    secc.sendEmail(dli);
                 //}   
              }
    }          
}