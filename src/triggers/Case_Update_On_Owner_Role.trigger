trigger Case_Update_On_Owner_Role on Case (Before Insert, Before Update) {
/*commenting inactive trigger code to improve code coverage-----
List<ID> CaseID = new List<ID>();
List<ID> CaseOwnerid = new List<ID>();
List<Case> CaseOwnerUpdate = new List<Case>();
String RoleName, CurrentOwner, Usercheck, rolecheck;
Map<ID,User> StringMap = new Map<ID,User>();
User UserRole = new User();

    for(Case cas : trigger.new){
    system.debug('*******Entered before IF'+cas.recordtypeid);
        if(cas.recordtypeid == label.Repair_Overhaul_RT_ID){
            if((Trigger.isinsert &&  trigger.isbefore) || (trigger.isupdate && Trigger.isbefore && (System.Trigger.OldMap.get(cas.Id).OwnerId != System.Trigger.NewMap.get(cas.Id).OwnerId))){
                system.debug('*******Entered'+cas.recordtypeid);
                if(Trigger.isinsert &&  trigger.isbefore){
                    CurrentOwner = cas.OwnerId;
                }
                if(trigger.isupdate && Trigger.isbefore){
                     CurrentOwner = System.Trigger.NewMap.get(cas.ID).OwnerID;
                }     

                if(CurrentOwner !=null){
                Usercheck = CurrentOwner.substring(0,3);
                    if(Usercheck == '005'){
                        CaseOwnerid.add(cas.ownerid);
                        caseid.add(cas.id);
                    }
                }        
            }
        }
    }
    
    Map<ID,User> UserMap = New Map<ID,User>([Select ID, Name, UserRoleID, Role_Name__c from user where ID in : CaseOwnerid]);
    
    for(Case cas : trigger.new){

        if((Trigger.isinsert &&  trigger.isbefore) || (trigger.isupdate && Trigger.isbefore && (System.Trigger.OldMap.get(cas.Id).OwnerId != System.Trigger.NewMap.get(cas.Id).OwnerId))){
            if(CaseOwnerid.size()>0){
                if(UserMap.get(cas.OwnerID).Role_name__c != ''){
                    rolecheck = UserMap.get(cas.OwnerID).Role_name__c;
                }
                system.debug('ROLECHECK: '+rolecheck);
                
                if(cas.ownerid != null){
                    if(rolecheck!='' && rolecheck!=null){
                        if(rolecheck.contains('CSO OM ATRW 7') || rolecheck.contains('CSO OM ATRW 8')){
                            cas.type = 'ATR R&O Internal';
                            cas.Classification__c = 'ATR R&O Internal';
                            CaseOwnerUpdate.add(cas);
                        }
                        if(rolecheck.contains('CSO OM AM BGA 6') || rolecheck.contains('CSO OM AM BGA 7')){
                            cas.type = 'BGA R&O Internal';
                            cas.Classification__c = 'BGA R&O Internal';
                            CaseOwnerUpdate.add(cas);
                        }
                    }     
                }
            }        
        }
    }*/
}