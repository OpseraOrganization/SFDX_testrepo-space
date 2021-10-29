global class UpdateCountOpenActivities {
    
    public static boolean flag = true;
    public static void updateCountOpenActivity(List<Id> updateTaskIds1, List<Id> deletedList){
        List<Case> cases=new List<Case>();
        List<Task> task1=new List<Task>();
        List<Case> casetoUpdate= new List<Case>();        
        List<id> MergedList = new List<id>();
        MergedList.addAll(updateTaskIds1);      
        MergedList.addAll(deletedList);        
        Decimal eCount;        
        
        if(MergedList.size()>0){
            cases=[Select Id, OF_OPEN_ACTIVITY__C from case where Id in:MergedList];
            if(cases.size()>0){
                for(integer i=0;i<cases.size();i++){
                     if(cases[i].OF_OPEN_ACTIVITY__C==null){
                        eCount=0;
                     }else{
                          eCount= cases[i].OF_OPEN_ACTIVITY__C;
                     }
                    if (updateTaskIds1!=null  && updateTaskIds1.contains(cases[i].Id)){
                        eCount= eCount + 1;
                    }
                    if(deletedList!=null  && deletedList.contains(cases[i].Id)){
                        eCount= eCount- 1; 
                        }
                        cases[i].OF_OPEN_ACTIVITY__C=eCount;
                    casetoUpdate.add(cases[i]);
                }
            }            
            if(casetoUpdate.size()>0){
                try{
                    update casetoUpdate;
                }catch(Exception e){
                }
            }
        }  
    }    
}