public class UpdateTaskManagerRole {
    
    public static boolean flag = true;
    
    public void updateTaskManagernRole(List<Id> listOwnerId,List<Id> listTaskId){
        /*
        List<ID> managerIds = new List<ID>();
        List<ID> taskIds = new List<ID>();
        
        List<String> managerNames = new List<String>();
        List<String> roleNames = new List<String>();
        
        List<ID> roleIds = new List<ID>();
        List<ID> ownerIds = new List<ID>();
        */
        //List<User> u = [Select UserRoleId,UserRole.Name,Manager.Name, ManagerId, Id From User where Id in : listOwnerId];
        Map<Id,User> u = new Map<Id,User>([Select UserRoleId,UserRole.Name,Manager.Name, ManagerId, Id From User where Id in : listOwnerId]);
        List<Task> taskUpdate = [Select Id, OwnerId, Assigned_Manager__c,Assigned_Role__c From Task where Id in : listTaskId];
        /*
        if(taskUpdate.size() > 0){
            for(Integer j=0;j<taskUpdate.size();j++){
            for(Integer k=0;k<u.size();k++){
            if(u[k].Id == taskUpdate[j].OwnerId){
                taskUpdate[j].Assigned_Manager__c = u[k].Manager.Name;
                taskUpdate[j].Assigned_Role__c = u[k].UserRole.Name;
            }
            }
            }
        }
        */
        if(taskUpdate.size() > 0){
            for(Integer j=0;j<taskUpdate.size();j++){
                taskUpdate[j].Assigned_Manager__c = u.get(taskUpdate[j].OwnerId).Manager.Name;
                taskUpdate[j].Assigned_Role__c = u.get(taskUpdate[j].OwnerId).UserRole.Name;
            }
        }
        try {
            update taskUpdate;
        }catch(Exception ex){
            System.Debug('No Manager or Role found corresponds to owner of Task.'); 
        }
        
    }
    
}