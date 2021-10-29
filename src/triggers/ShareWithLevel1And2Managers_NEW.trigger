trigger ShareWithLevel1And2Managers_NEW on Sales_Competency__c (after update, before insert) {
    if(trigger.isUpdate){
        //Declarations
        Set<Id> set_SCUserIds = new Set<Id>();  
        Map<Id, User> map_Users = new Map<Id, User>();
        List<Sales_Competency__Share> list_SCSharesToCreate = new List<Sales_Competency__Share>();
            
        for(Sales_Competency__c objSC : trigger.new){           
            //if((trigger.oldMap.get(objSC.Id).User__c == objSC.User__c) && (trigger.oldMap.get(objSC.Id).OwnerId != objSC.OwnerId))
                set_SCUserIds.add(objSC.User__c);            
        }
        
        if(!set_SCUserIds.isEmpty()){
            for(User objUser : [SELECT Id, Name, Level_1_Manager__c, Level_2_Manager__c FROM User WHERE Id IN : set_SCUserIds])
                    map_Users.put(objUser.Id, objUser);
                    
               
            for(Sales_Competency__c objSC : trigger.new){
                if(map_Users.get(objSC.User__c).Level_1_Manager__c != null){
                    If(map_Users.get(objSC.User__c).Level_1_Manager__c != ObjSC.OwnerId){                
                        //objSC.Level_1_Manager__c = map_Users.get(objSC.User__c).Level_1_Manager__c;
                        
                        Sales_Competency__Share objSCShare_Level1 = new Sales_Competency__Share();
                        objSCShare_Level1.AccessLevel = 'Edit';
                        objSCShare_Level1.ParentId = objSC.Id;
                        objSCShare_Level1.UserOrGroupId = map_Users.get(objSC.User__c).Level_1_Manager__c;
                        list_SCSharesToCreate.add(objSCShare_Level1);
                    }
                }
                
                if(map_Users.get(objSC.User__c).Level_2_Manager__c != null){
                    If(map_Users.get(objSC.User__c).Level_2_Manager__c != ObjSC.OwnerId){                  
                        Sales_Competency__Share objSCShare_Level2 = new Sales_Competency__Share();
                        objSCShare_Level2.AccessLevel = 'Edit';
                        objSCShare_Level2.ParentId = objSC.Id;
                        objSCShare_Level2.UserOrGroupId = map_Users.get(objSC.User__c).Level_2_Manager__c;
                        list_SCSharesToCreate.add(objSCShare_Level2);
                    }
                }                                
            }                
            
            system.debug('>>>list_SCSharesToCreate>>>>'+list_SCSharesToCreate);
            if(!list_SCSharesToCreate.isEmpty())
                insert list_SCSharesToCreate;  
                    
            /*if(trigger.isBefore){
                for(Sales_Competency__c objSC : trigger.new){
                    if(map_Users.get(objSC.User__c).Level_1_Manager__c != null)
                        objSC.Level_1_Manager__c = map_Users.get(objSC.User__c).Level_1_Manager__c;
                }
            }*/
        }
    }
    
    if(trigger.isInsert){
        Set<Id> set_SCUserIds = new Set<Id>();  
        Map<Id, User> map_Users = new Map<Id, User>();
        
        for(Sales_Competency__c objSC : trigger.new){                       
            set_SCUserIds.add(objSC.User__c);            
        }
        
        if(!set_SCUserIds.isEmpty()){
            for(User objUser : [SELECT Id, Name, Level_1_Manager__c, Level_2_Manager__c FROM User WHERE Id IN : set_SCUserIds])
                map_Users.put(objUser.Id, objUser);
        }
        
        for(Sales_Competency__c objSC : trigger.new){
            if(map_Users.get(objSC.User__c).Level_1_Manager__c != null){
                objSC.Level_1_Manager__c = map_Users.get(objSC.User__c).Level_1_Manager__c;
            }
        }
    }
}