trigger ATROpp_ContentDeliveries_Automation on Opportunity (after insert, after update) 
{
    if(AvoidRecursion.isAtrAutomation()){
    string profileId = userinfo.getProfileId();
    string dataLoadUsr = Label.SpiraldataLoadUser;
    
    if(profileId != dataLoadUsr){
        if(ATROpp_ContentDeliveries_Automation.donealready == false
             && ATROpp_ContentDeliveries_Automation.donotrun == null){
        
            if(trigger.isinsert){
                ATROpp_ContentDeliveries_Automation.CreateContentDeliveries(trigger.new, Null, Null,Null,Null);
            }
          
          if(trigger.isupdate){
             map<id,set<id>>exconmap= new map<id,set<id>>();
             System.debug('trigger.new==='+trigger.new);
             List<Content_Delivery__c> cdelv = [select id,ID_Value__c,Opportunity__c from Content_Delivery__c where Opportunity__c IN: trigger.new];
             System.debug('cdelv==='+cdelv);
             set<id>temp= new set<id>();
             for(Content_Delivery__c cd : cdelv){                
                if(exconmap.containskey(cd.Opportunity__c))
                  temp=exconmap.get(cd.Opportunity__c);
                temp.add(cd.ID_Value__c);
                exconmap.put(cd.Opportunity__c,temp);
             }
             system.debug('exconmap******'+exconmap);
             ATROpp_ContentDeliveries_Automation.CreateContentDeliveries(trigger.new, trigger.oldmap, Null,Null,exconmap);
            // ATROpp_ContentDeliveries_Automation.donealready=true;
            
            //calling refresh web service class when ATR content delivery is updated
            for(opportunity opp:trigger.new)
            {
                if(opp.SBU__c == 'ATR'&& (Trigger.newMap.get(opp.id).ATROpportunitycontentupdate__c != Trigger.oldMap.get(opp.id).ATROpportunitycontentupdate__c) &&  opp.ATROpportunitycontentupdate__c == true)
                {
                  RefreshContent_Webservice.refresh(opp.id);            
                }
            }
          }
        }
    }
    }
}