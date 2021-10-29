trigger CustomerPortalUsernameMatchesEmailAddress on User (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (User u : Trigger.new) {
            if (u.userType.endsWith('CustomerSuccess') && (u.profileid == label.Idea_Customer_Portal_Profile_ID)) {
                if (u.username != u.email) {
                    u.username = u.email;
                }
            }
        }
    }
// Changes DOne by Tejashri for Incident INC000010790827 - Start
list<Id> psManagerId = new List<id>();
set<String> managerId = new Set<String>(); 
List<user> userList= new List<user>();
Map<String,User> userMap = new Map<String,User>();
set<String> userId = new set<String>();
string test;
    for(User us: trigger.New){
        if(Trigger.NewMap.get(us.Id).PS_Manager_EID__c != Trigger.OldMap.get(us.Id).PS_Manager_EID__c){
            managerId.add(us.PS_Manager_EID__c);
        }
    }
if(managerId.size()>0){
    userList = [select Id, Name,PS_Manager_EID__c,EmployeeNumber,PS_Manager_Name__c ,Primary_Manager_Name__c,Secondary_Manager__c from user where EmployeeNumber in:managerId];
    for(user us:userList){
        userMap.put(us.EmployeeNumber,us);
    } 
}
if(userMap.size()>0){
    for(User u:Trigger.new){
        if(userMap.containsKey(u.PS_Manager_EID__c)){
            u.Primary_Manager_Name__c = userMap.get(u.PS_Manager_EID__c).Name;
            u.Secondary_Manager__c= userMap.get(u.PS_Manager_EID__c).PS_Manager_Name__c ;
        }
    }    
}   
// Changes DOne by Tejashri for Incident INC000010790827 - End
}