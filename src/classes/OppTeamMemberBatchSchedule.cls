global class OppTeamMemberBatchSchedule implements Schedulable{

    global void execute(SchedulableContext SC){
        BatchOpportunityTeamMemberSharing objOP = new BatchOpportunityTeamMemberSharing();
        database.executebatch(objOP,200);
    }
}