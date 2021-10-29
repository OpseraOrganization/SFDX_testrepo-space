trigger UpdateManagernRole on Task (after insert, after update) {
   /*commenting trigger code for coverage 
    List<Task> tasklist = Trigger.new;
    List<ID> ownerIds = new List<ID>();
    List<ID> taskIds = new List<ID>();*/
  /*  for(integer i=0;i<tasklist.size();i++){
        ownerIds.add(tasklist[i].OwnerId);
        taskIds.add(tasklist[i].Id);
    }*/
    
    /*for(Task tsk : tasklist){
        if(tsk.recordtypeid!= label.General_Task ){
        ownerIds.add(tsk.OwnerId);
        taskIds.add(tsk.Id);
        }
    }

    
    UpdateTaskManagerRole updatetask = new UpdateTaskManagerRole();
    //updatetask.updateTaskManagernRole(ownerIds);
     if(UpdateTaskManagerRole.flag == true){
         UpdateTaskManagerRole.flag = false;
         updatetask.updateTaskManagernRole(ownerIds,taskIds); 
     } */
}