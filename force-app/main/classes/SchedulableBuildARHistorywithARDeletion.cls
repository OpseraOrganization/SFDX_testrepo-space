global class SchedulableBuildARHistorywithARDeletion implements schedulable
{

public final Integer  batchSize;
public SchedulableBuildARHistorywithARDeletion (Integer  batchSize){
this.batchSize = batchSize;
}  

global void execute(SchedulableContext sc)
{
BuildARHistorywithARDeletion b = new BuildARHistorywithARDeletion(); // batch class
database.executebatch(b,batchSize);
}
}