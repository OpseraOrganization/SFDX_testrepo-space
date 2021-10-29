trigger updateTempBasedOnSBU on Account (before insert,before update) {
String profid=(UserInfo.getProfileId().substring(0,15));
if(profid!=label.DeniedpartyAPIuserprofile){
List<Account> updatesAccountsList=Trigger.new;
Map<String,String> mapTemps=new Map<String,String>();
List<Portal_Access_Template__c> lstTemps=[select name,id from Portal_Access_Template__c];
for(Portal_Access_Template__c temp:lstTemps){
    mapTemps.put(temp.name,temp.id);
}
if(updatesAccountsList!=null && updatesAccountsList.size()>0){
    for(Account acc:updatesAccountsList){
        System.debug('SBU ==  '+acc.Strategic_Business_Unit__c);
        System.debug('Market ==  '+acc.Market_Name__c);
        String tempId;
        if(acc.Market_Name__c=='Helicopters'){
            tempId=mapTemps.get(acc.Market_Name__c);
            acc.ATR_Portal_Access_Template__c=tempId;
        }else{
            tempId=mapTemps.get(acc.Strategic_Business_Unit__c);
            if(acc.Strategic_Business_Unit__c =='ATR'){
                acc.ATR_Portal_Access_Template__c=tempId;
            }else if(acc.Strategic_Business_Unit__c =='BGA'){
                acc.ATR_Portal_Access_Template__c=tempId;
            }else if(acc.Strategic_Business_Unit__c =='D&S'){
                acc.ATR_Portal_Access_Template__c=tempId;
            }
            /*else if(acc.Strategic_Business_Unit__c =='Intercompany'){
             tempId=mapTemps.get('Generic');
              acc.ATR_Portal_Access_Template__c=tempId;
            }*/
            
/****** Newly Added ******/
            else if(acc.Strategic_Business_Unit__c =='D&S' && acc.Market_Name__c=='Helicopters'){
                tempId=mapTemps.get('Helicopters');
                acc.ATR_Portal_Access_Template__c=tempId;
            }else if(acc.Strategic_Business_Unit__c =='Intercompany' && ((acc.Name=='HONEYWELL EMPLOYEE AMERICAS')||(acc.Name=='HONEYWELL EMPLOYEE EMEAI')||(acc.Name=='HONEYWELL EMPLOYEE APAC'))){
                tempId=mapTemps.get('Employee');
                acc.ATR_Portal_Access_Template__c=tempId;
            }else if(acc.Strategic_Business_Unit__c =='Intercompany' && acc.Name!='HONEYWELL EMPLOYEE AMERICAS' && acc.Name!='HONEYWELL EMPLOYEE EMEAI' && acc.Name!='HONEYWELL EMPLOYEE APAC'){
                tempId=mapTemps.get('Generic');
                acc.ATR_Portal_Access_Template__c=tempId;
            }
/****** Newly Added ******/            
           
            else{
                System.debug('template id ==== '+acc.ATR_Portal_Access_Template__c);
                System.debug('System.Trigger.oldMap ==='+System.Trigger.oldMap);
                System.debug('acc.Id ==='+acc.Id);
                if(System.Trigger.oldMap!=null){
                    Account beforeUpdate = System.Trigger.oldMap.get(acc.Id);
                    if(beforeUpdate.ATR_Portal_Access_Template__c!=acc.ATR_Portal_Access_Template__c && acc.ATR_Portal_Access_Template__c!=null){
                      //acc.ATR_Portal_Access_Template__c=acc.ATR_Portal_Access_Template__c;  
                    }else{
                        acc.ATR_Portal_Access_Template__c=null;
                    }
                }
            }
        }
        if((acc.PFECN__c=='Refer to Network')&&(acc.Strategic_Business_Unit__c=='BGA')){
            tempId=mapTemps.get('RTN');
            acc.ATR_Portal_Access_Template__c=tempId;
        }
}
}
}
}