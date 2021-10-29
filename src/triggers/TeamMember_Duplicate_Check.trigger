trigger TeamMember_Duplicate_Check on Team_Members__c (Before Insert, Before Update){

List<ID> greenlist = new List<ID>();
List<ID> teamlist = new List<ID>();
Map<ID,ID> dupcheckmap = new Map<ID,ID>();
List<Team_Members__c> dupcheck = new List<Team_Members__c>();

    for(Team_Members__c team : trigger.new){
        if(team.Go_Green_Plan__c != null && team.Team_Members__c != null){
            greenlist.add(team.Go_Green_Plan__c);
            teamlist.add(team.Team_Members__c);
   //         mapcheck.put(voc.Feedback_Number__c,voc.Go_Green_Plan__c);            
        }
    }
    
    
    dupcheck = [select id, Team_Members__c, Go_Green_Plan__c from Team_Members__c where Go_Green_Plan__c in : greenlist and Team_Members__c in: teamlist];
    if(dupcheck.size()>0){
        for(Team_Members__c tm : dupcheck){
            dupcheckmap.put(tm.Team_Members__c, tm.Go_Green_Plan__c);
        }
    }

    if(Trigger.isInsert){
        if(dupcheckmap.size()>0){
            for(Team_Members__c team : trigger.new){
                if(dupcheckmap.containsKey(team.Team_Members__c))
                team.adderror('Go Green Plan already exists for the team member selected!');
            }
        }
    }
    
    if(Trigger.isUpdate){
        if(dupcheckmap.size()>0){
            for(Team_Members__c team : trigger.new){
                if((System.Trigger.OldMap.get(team.Id).Team_Members__c != System.Trigger.NewMap.get(team.Id).Team_Members__c) || (System.Trigger.OldMap.get(team.Id).Go_Green_Plan__c != System.Trigger.NewMap.get(team.Id).Go_Green_Plan__c)){
                    if(dupcheckmap.containsKey(team.Team_Members__c))
                    team.adderror('Go Green Plan already exists for the team member selected!');
                }    
            }
        }
    }
}