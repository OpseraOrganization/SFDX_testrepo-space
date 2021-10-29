trigger Update_Contact_Status_Task on Task (Before Insert, Before Update) {
Map<ID,String> Taskmap =  new Map<ID,String>();
Set<ID> TaskID = new Set<ID>();
List<Task> Newtask = new List<Task>();
List<Contact> Contactlist = new List<Contact>();
String Contactid;

    for(Task ntask : Trigger.new){
        if( ntask.recordtypeid!= label.General_Task && ntask.Whoid != null){
        Contactid =ntask.Whoid; 
        Contactid = Contactid.substring(0,3);
            if(Contactid == '003'){
            TaskID.add(ntask.whoid);
            Newtask.add(ntask); 
            }
        }
    }
    
    if(TaskID.size()>0){ 
        Contactlist = [Select Name, Id, Contact_Status__c from Contact where ID in : TaskID];
    }

    if(Contactlist.size()>0){
        for(Contact newconlist :Contactlist ){
        taskmap.put(newconlist.id,newconlist.contact_status__c);
        } 
    }
    
    if(Newtask.size()>0){
        for(Task tasklist : Newtask){
        tasklist.contact_status__c = taskmap.get(tasklist.whoid);
        }
    }   
}