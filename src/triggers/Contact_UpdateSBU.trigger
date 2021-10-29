// Trigger to inherit the SBU, CBT values from Contact when it is a business contact

trigger Contact_UpdateSBU on Contact (before insert,before update) {

string profileId = userinfo.getProfileId();
        string customLabel = Label.Data_Loading_Profile;
        if(profileId.substring(0,profileId.length()-3) != customLabel){ 
        
    // variable declaration
    List <Contact> conlist = Trigger.new;
    integer flag=0;
    Set<id> accid = new Set<id>();
    List<Account> acclist = new List<Account>();
    // Added code for MyMaintainer Project Changes
    List<Case> caslist = new List<Case>(); 
    List<Case> caslistUpdate = new List<Case>(); 
    // End code for MyMaintainer Project Changes
    for(integer i=0;i<conlist.size();i++)
    {
        flag=0;
        // for New records
        if(Trigger.isInsert){
            flag=1;
            // Added code for INC000008215170
            system.debug('Entry by Anu');
            System.debug(Userinfo.getUserId());
            if(conlist[i].AccountId == Label.Hon_Unidentified_Portal_Users_AccId && Userinfo.getUserId()!= Label.API_User_My_Aerospace_Portal){
                conlist[i].addError('"HONEYWELL UNIDENTIFIED PORTAL USERS" Account cannot be assigned');
            }
            // End Code for INC000008215170
        }
        // for update
        if(Trigger.isUpdate){
            // when the contact become a business contact
            if(System.Trigger.oldMap.get(conlist[i].Id).Contact_Is_Employee__c==True  && System.Trigger.newMap.get(conlist[i].Id).Contact_Is_Employee__c==False)
            flag=1;
            // when account is changed
            if(System.Trigger.oldMap.get(conlist[i].Id).AccountId  != System.Trigger.newMap.get(conlist[i].Id).AccountId)
            flag=2;
        } 
        if(flag==1){
            if(conlist[i].Contact_Is_Employee__c == False)
            {
                //assigning the values from account
                if(conlist[i].SBU_Contact__c==null && conlist[i].AccountId!=null)
                {
                    conlist[i].SBU_Contact__c =conlist[i].SBU_Formulae__c;
                }
                if(conlist[i].CBT__c==null && conlist[i].AccountId!=null)
                {
                    conlist[i].CBT__c =conlist[i].CBT_Formulae__c;
                }
                if(conlist[i].CBT_Team__c==null && conlist[i].AccountId!=null)
                {
                    conlist[i].CBT_Team__c =conlist[i].CBT_Team_Formulae__c;
                }
                if(conlist[i].CBT_Directorate__c==null && conlist[i].AccountId!=null)
                {
                    conlist[i].CBT_Directorate__c =conlist[i].CBT_Directorate_Formulae__c;
                }
                if(conlist[i].Sales_Channel_Contact__c ==null && conlist[i].AccountId!=null)
                {
                    conlist[i].Sales_Channel_Contact__c =conlist[i].Sales_Channel_Formulae__c;
                }
                if(conlist[i].SC1__c ==null && conlist[i].AccountId!=null)
                {
                    conlist[i].SC1__c =conlist[i].Sub_Channel_Formulae__c;
                }
                if(conlist[i].SC2__c ==null && conlist[i].AccountId!=null)
                {
                    conlist[i].SC2__c =conlist[i].Sub_Channel2_Formulae__c;
                }
            }
        }         
        if(flag==2){
            if(conlist[i].Contact_Is_Employee__c == False)
            {
                if(conlist[i].AccountId!=null)
                {
                    conlist[i].SBU_Contact__c =conlist[i].SBU_Formulae__c;
                }
                if(conlist[i].AccountId!=null)
                {
                    conlist[i].CBT__c =conlist[i].CBT_Formulae__c;
                }
                if(conlist[i].AccountId!=null)
                {
                    conlist[i].CBT_Team__c =conlist[i].CBT_Team_Formulae__c;
                }
                if(conlist[i].AccountId!=null)
                {
                    conlist[i].CBT_Directorate__c =conlist[i].CBT_Directorate_Formulae__c;
                }
                if(conlist[i].AccountId!=null)
                {
                    conlist[i].Sales_Channel_Contact__c =conlist[i].Sales_Channel_Formulae__c;
                }
                if(conlist[i].AccountId!=null)
                {
                    conlist[i].SC1__c =conlist[i].Sub_Channel_Formulae__c;
                }
                if(conlist[i].AccountId!=null)
                {
                    conlist[i].SC2__c =conlist[i].Sub_Channel2_Formulae__c;
                }
            }
            // Added code for MyMaintainer Project Changes
            caslist = [select id,AccountId,ContactID,Subject from Case where ContactID=:conlist[i].id and Accountid!=:conlist[i].AccountId and (Subject=:Label.MyMaintainer_Cases_Update or Subject=:Label.ASDS_Tool_Cases_Update)];
            if(caslist.size()>0){
                for(Case cas:caslist){
                    cas.AccountId = conlist[i].AccountId;
                    caslistUpdate.add(cas);
                }
            }
            // End code for MyMaintainer Project Changes
        }  
    }// end of for loop
       // Added code for INC000006634253
       //Map<id, contact> conMap = new Map<id,contact>();
       //Map<id, list<account>> accMap = new Map<id,list<account>>();
       //list<account> oldlstaccs = new list<account>();
    /*    for(Contact con:trigger.new){
            if(con.AccountId!=null)
                accid.add(con.AccountId);
                //conMap.put(con.AccountId,con);
                
                
        } */
        
        
        
    /*    if(accid!=null){
            
            acclist = [Select id,Name,Strategic_Business_Unit__c,CBT__c,CBT_Team__c,CBT_Directorate__c,Sales_Channel__c,SC1__c,SC2__c from Account where id IN:accid];
        }
        
        
         if(acclist.size()>0 && acclist!=null){
            for(Integer i=0;i<acclist.size();i++){
               if(accMap.containskey(acclist[i].id)){
                 oldlstaccs=accMap.get(acclist[i].id);
                 oldlstaccs.add(acclist[i]);
                 accMap.put(acclist[i].id,oldlstaccs);
               }else{
                list<account> lstaccs = new list<account>();
                lstaccs.add(acclist[i]);
                accMap.put(acclist[i].id,lstaccs);
              }
            }
         
         }
        
          */
        
     
       
                for(Contact con:trigger.new){
                  
                    if(con.Contact_Is_Employee__c == false && con.AccountId!= null){
                        con.SBU_Contact__c = con.SBU_Formulae__c;
                        con.CBT__c = con.CBT_Formulae__c;
                        con.CBT_Team__c = con.CBT_Team_Formulae__c;
                        con.CBT_Directorate__c = con.CBT_Directorate_Formulae__c;
                        con.Sales_Channel_Contact__c = con.Sales_Channel_Formulae__c;
                        con.SC1__c = con.Sub_Channel_Formulae__c;
                        con.SC2__c = con.Sub_Channel2_Formulae__c;
                    }
                }
           
    // End code for INC000006634253
    // Added code for MyMaintainer Project Changes
        if(caslistUpdate.size()>0){
            try{
                update caslistUpdate;
            }catch(DMLException e){}
        }
    // End code for MyMaintainer Project Changes
}
}
// end of triggr