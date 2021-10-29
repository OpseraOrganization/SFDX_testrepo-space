global class BatchOpportunityTeamMemberSharing implements Database.Batchable<sObject>{
    
    global Set<Id> oppId = new Set<Id>();
    global Map<Id,opportunity>  oppMap = new Map<Id,opportunity>(); 
    global List<OpportunityShare> lsshare = new List<OpportunityShare>();
    global List<OpportunityShare> removelsshare = new List<OpportunityShare>();
    global Database.QueryLocator start(Database.BatchableContext BC){        
        String query = 'select id, name, OwnerId from opportunity';       
        System.debug('query is---------->'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<opportunity> aOppList){
        try{
            for (opportunity opp : aOppList){                
                oppId.add(opp.Id);
                oppMap.put(opp.Id,opp);
            }
            if(oppId != null && oppId.size() > 0){              
                System.debug('-------inside----opp--->');
                Map<Id, List<Opportunity_Sales_Team__c>> oppTeamListMap = new Map<Id, List<Opportunity_Sales_Team__c>>();
                Map<Id, List<OpportunityShare>> oppShareListMap = new Map<Id, List<OpportunityShare>>();                
                //querying opp Shareing
                for(OpportunityShare oshare : [select id, OpportunityAccessLevel, OpportunityId, UserOrGroupId from OpportunityShare where OpportunityId IN : oppId ORDER BY OpportunityId LIMIT 50000]){
                    System.debug('------oppshare---->'+oshare);                                                     
                    //Order Opportunity and fill map withlistow
                    if(oppShareListMap.containsKey(oshare.OpportunityId)){
                        oppShareListMap.get(oshare.OpportunityId).add(oshare);
                    }else{ 
                        oppShareListMap.put(oshare.OpportunityId, new List<OpportunityShare> { oshare });
                    }                   
                } 
                System.debug('------oppShareListMap----->'+oppShareListMap);
                // querying opp Team
                for(Opportunity_Sales_Team__c oppTeam : [SELECT id, User__c, Opportunity__c FROM Opportunity_Sales_Team__c WHERE Opportunity__c IN : oppId ORDER BY opportunity__c LIMIT 50000]){
                    System.debug('----oppTeam--------->'+oppTeam);                                                     
                    //Order Opportunity and fill map withlistow
                    if(oppTeamListMap.containsKey(oppTeam.Opportunity__c)){
                        oppTeamListMap.get(oppTeam.Opportunity__c).add(oppTeam);
                    }else{ 
                        oppTeamListMap.put(oppTeam.Opportunity__c, new List<Opportunity_Sales_Team__c> { oppTeam });
                    }
                }
                System.debug('------oppTeamListMap----->'+oppTeamListMap);              
                //for one opp               
                if(oppTeamListMap.size() > 0){ 
                    for(Id opId : oppTeamListMap.keySet()){ 
                        //get the all users shareing for this opportunity
                        for(OpportunityShare os : oppShareListMap.get(opId)){
                            Boolean foundUserInTeam = false;
                            for(Opportunity_Sales_Team__c ot : oppTeamListMap.get(opId)){
                                if(os.UserOrGroupId != ot.User__c && os.UserOrGroupId != oppMap.get(opId).OwnerId){                     
                                    //removelsshare.add(os);                                  
                                } else {
                                    //os.OpportunityAccessLevel = 'Edit';
                                    //lsshare.add(os);
                                    foundUserInTeam = true;
                                }                           
                            }
                            if(foundUserInTeam){
                                os.OpportunityAccessLevel = 'Edit';
                                lsshare.add(os);
                            }else{
                                removelsshare.add(os);
                            }  
                        }                       
                        // giving access to all team members who are not having sharing.                        
                        for(Opportunity_Sales_Team__c ot : oppTeamListMap.get(opId)){                           
                            OpportunityShare s = new OpportunityShare();
                            s.UserOrGroupId = ot.User__c;
                            s.OpportunityAccessLevel = 'Edit';
                            s.OpportunityId =ot.opportunity__c;
                            lsshare.add(s);
                        }                       
                    }
                }
                //System.debug('-------sharing-----records----->'+lsshare);
                //System.debug('------remove-----records----->'+removelsshare);
                // if extra user access there remove it 
                if(removelsshare.size() > 0)
                    Database.delete(removelsshare,false);
                // giving access
                if(lsshare.size() > 0)
                    Database.upsert(lsshare,false);
                    //upsert lsshare;               
            }           
        }catch(Exception e){
            //System.debug('Error1 : '+e.getMessage()); 
            //System.debug('Error line1 : '+e.getLineNumber());
        }        
    }
      
    global void finish(Database.BatchableContext BC){
       /* try{
            System.debug('------sharing complete list--------->'+lsshare);
                    
        } catch(Exception e){
              System.debug('Error2 : '+e.getMessage());
               System.debug('Error line2 : '+e.getLineNumber());
        }  */
    }   
}