//***************************Change Log ****************************//
//SR#437524 - To update the Opportunity Team Role in Opportunity Team records after aupdating the Functional role for user.
//************************Test Class********************************//
//Test Class Used for Test coverage - Testcls_User_Sync_FunctionalRoles
//*******************************************************************//
trigger User_Sync_FunctionalRoles on User (before insert, after update) {
    ATROpp_ContentDeliveries_Automation.DoNotRun = 'donotrun';
    //code changes for SR#415365
    public string parentid;
    //Code added for SR430612
    List<String> useremailList = new List<String>();
    Map<String,User> userMap = new Map<String,User>();
    List <Contact> conlist = new List<Contact>();
    // Added code for SR#430239 send an email notification when a  D&S user is Activated or Inactivated  for D&S Admins.
    boolean parid = false;
    String var = '';
    Map<String,DS_Sales_Profilelist__c> mapDSprofile = DS_Sales_Profilelist__c.getALL();
    System.debug('#### mapDSprofile'+mapDSprofile);
    List<String> mailToAddresses = new List<String>(); 
    String[] emailAddressArr = (label.D_S_Admin_Email).split(',');        
    if(emailAddressArr.size() > 0){            
         for(String i : emailAddressArr){
               mailToAddresses .add(i);
          }
    }   
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
    system.debug('Trigger.new value:'+Trigger.new);
    for(user u1:trigger.new)
      {
          system.debug('trigger.isinsert && u1.isactive==true:'+trigger.isinsert+' 2 value:'+u1.isactive);
        if(trigger.isinsert && u1.isactive==true)
        {
            system.debug('u1.id value:'+u1.id);
            parentid=u1.id;
        }
        
        if (Trigger.isupdate && (((u1.IsActive == True && Trigger.OldMap.get(u1.id).IsActive ==false) || (u1.IsActive == False && Trigger.OldMap.get(u1.id).IsActive ==true)) && mapDSprofile.containskey(u1.profileid)==true))
          {
            System.debug('#####');
            if (u1.IsActive == True)
               var = 'Activated';
            if (u1.IsActive == False)
               var = 'Deactivated';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();             
            mail.setToAddresses(mailToAddresses );
            mail.setSubject('D&S User Activity');
            String bodyText = '<html><head>D&S Admins,<br/><br/> </head>' + '<body>The D&S user named  '+'<font color="red" align ="right" family="Copper Black"> <b>'  + u1.firstname + ' ' + u1.lastname + '</b></font>    has been  <font color="red" align ="right" family="Copper Black"><b>' + var + '!</b></font>  '  + ' Please review to make sure the action is correct. </body></html>';
            mail.setHtmlBody(bodyText);  
            bulkEmails.add(mail);     
            
            parid=true; 
          }  
        //Code Added for SR430612 - Start
        //if (Trigger.isupdate && (u1.Primary_Manager_EID__c != Null || u1.Primary_Manager_Name__c != Null) && (u1.Primary_Manager_EID__c !=  Trigger.OldMap.get(u1.id).Primary_Manager_EID__c  || u1.Primary_Manager_Name__c != Trigger.OldMap.get(u1.id).Primary_Manager_Name__c))
        //if (Trigger.isupdate && (u1.Primary_Manager_EID__c != Null || u1.Primary_Manager_Name__c != Null) 
        //    && (u1.Primary_Manager_EID__c !=  Trigger.OldMap.get(u1.id).Primary_Manager_EID__c  || u1.Primary_Manager_Name__c != Trigger.OldMap.get(u1.id).Primary_Manager_Name__c)
        //    && (Userinfo.getUserID()!= label.PeopleSoft_API_User )) // Exception provided for PeoplesoftAPI User as per #INC000006032154 Req#1
        if (Trigger.isupdate && (u1.PS_Manager_EID__c != Null || u1.PS_Manager_Name__c != Null) 
            && (u1.PS_Manager_EID__c !=  Trigger.OldMap.get(u1.id).PS_Manager_EID__c  || u1.PS_Manager_Name__c != Trigger.OldMap.get(u1.id).PS_Manager_Name__c)
            && (Userinfo.getUserID()!= label.PeopleSoft_API_User )) // Exception provided for PeoplesoftAPI User as per #INC000006032154 Req#1        
        {
             useremailList.add(u1.Email);
             userMap.put(u1.Email,u1); 
        }
         //Code Added for SR430612 - End   
      }
        //code changes for SR#415365 checking user is active or inactive 
        system.debug('parentid :'+parentid);
        if(parentid != null || Test.isRunningTest())
        {
            //Code changes for SR#430239 ends.
            List<User> usersList=Trigger.new;
            Map<String,String> funcRoles=new Map<String,String>();
            List<String> newRoles=new List<String>();
            Role__c updateRoles=null;
             
            List <Role__c> updateRoleslst =new List <Role__c>();

            Set<String> funcRoles1=new Set<String>();
            List<String> funcRoles1_lst=new List<String>();
            Set<String> funcRoles2=new Set<String>();
            List<Role__c> roles=new List<Role__c> ();
            for(Integer i=0;i<usersList.size();i++){
                if(Trigger.isUpdate && Trigger.new[i].Functional_Role__c!=null){    
                    if(Trigger.old[i].Functional_Role__c!=Trigger.new[i].Functional_Role__c){
                        funcRoles.put(Trigger.new[i].Functional_Role__c,Trigger.new[i].Functional_Role__c);
                        funcRoles1.add(Trigger.new[i].Functional_Role__c);
                        funcRoles2.add(Trigger.new[i].Functional_Role__c);
                    }       
                }
                if((Trigger.isInsert && Trigger.new[i].PROFILEID != label.Custom_Customer_Portal )&& Trigger.new[i].Functional_Role__c!=null){
                    funcRoles.put(Trigger.new[i].Functional_Role__c,Trigger.new[i].Functional_Role__c);
                    funcRoles1.add(Trigger.new[i].Functional_Role__c);
                    funcRoles2.add(Trigger.new[i].Functional_Role__c);  
                }
            }
            System.Debug('FuncRoles_Map'+funcRoles);
            System.Debug('funcRoles2'+funcRoles2);
            if(funcRoles.size()>0)
            roles=[Select Name from Role__c where name!=null];
            System.Debug('Roles'+roles);
            funcRoles1_lst.addAll(funcRoles1);
            newRoles.addAll(funcRoles1_lst);
            System.Debug('NewRoles Size'+newRoles);
            System.Debug('Roles Size'+roles);
            for(Integer l=0;l<roles.size();l++){
                for(Integer k=0;k<newRoles.size();k++){
                    System.Debug('Newrole--'+newRoles[k]+'%%%'+k);
                    System.Debug('Roles--'+roles[l].Name+'$$$'+l);
                    if(newroles.size()>0) {
                        if(newroles[k]== roles[l].Name){
                            newRoles.remove(k);
                            System.Debug('k---'+k);
                            System.Debug('NewRoleSize'+newroles.size());
                        }
                        System.Debug('NewRoles inside'+newRoles);
                    }
                }   
            }
            System.Debug('NewRoles'+newRoles);   
            if(FutureMethodForCreatingUser.enableUser_Sync_FunctionalRoles)       
                User_Sync_FunctionalRoles_ACL.insertRoles(newRoles);                  
        }
        else
        {
        }
        //code changes ends SR#415365 
   //Added code for SR#430239 starts1.
      if (parid==true && !(Test.isRunningTest()))
         {
          Messaging.sendEmail(bulkEmails); 
         }       
   //Code changes for SR#430239 ends1.  
   //Code added for SR430612    
     if (useremailList.size() > 0)
    {
        List <contact> Contactlist = [Select id,Primary_Email_Address__c,User_Primary_Manager_Name__c,User_Primary_Manager_EID__c from Contact where Primary_Email_Address__c in :useremailList];
        System.debug('####Inside if '+Contactlist);
        if (Contactlist.size() == 1 ){
            for(Contact con :  Contactlist)
            {   
                User  objUser = userMap.get(con.Primary_Email_Address__c);
                con.User_Primary_Manager_Name__c = objUser.Primary_Manager_Name__c;
                con.User_Primary_Manager_EID__c = objUser.Primary_Manager_EID__c;
                conlist.add(con);
             }
          update conlist;  
        }
   }  
//////////////////////////Added code for ticket#185.
    if(trigger.isAfter){
       map<id,user> userOldMap = trigger.oldMap;
       set<id> userIdSet = new set<id>();
       for(User userRec:trigger.new){
           if(userRec.Functional_Role__c != userOldMap.get(userRec.id).Functional_Role__c && userRec.Functional_Role__c != null){
               userIdSet.add(userRec.id);
               system.debug('userRec.Functional_Role__c value:'+userRec.Functional_Role__c);
           }
       }
       if(userIdSet.size()>0){           
           UserUpdateHelperBatch batch = new UserUpdateHelperBatch(userIdSet);  
           Database.executeBatch(batch, 100);
       }
   }     
     
}