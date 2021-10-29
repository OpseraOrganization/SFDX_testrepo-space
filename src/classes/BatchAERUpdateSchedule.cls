/*******************************************************************************
Name         : BatchAERUpdateSchedule
Created By   : Haritha Lekkala
Company Name : HoneyWell
Project      : 
Created Date : 2/20/2017 
Usages       : This class is used to schedule the BatchAERUpdate apex class.

Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
*******************************************************************************/

// The class to schedule BatchAERUpdate batch class.
global class BatchAERUpdateSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        // We now call the batch class to be scheduled
        BatchAERUpdate b = new BatchAERUpdate();
        database.executebatch(b,200);
    }
   
}