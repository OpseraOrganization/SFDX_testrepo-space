/** * File Name: Contact_Sync_FunctionalRoles
* Description Trigger to insert new records in custom object 'Role' when a Contact is inserted/updated with a Functional Role
that does not exist already in the custom object 'Role'
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
*                  1.0            Wipro                 Initial Version created
* 04-04-2013       1.1            NTT Data              Update for SR # 377532  Pilot's Corner avionics
* 11-18-2013       1.2            NTT Data              Upadted for SR430612
* */ 
trigger Contact_Sync_FunctionalRoles on Contact (before insert, after update) {

//Variable Declaraion
List<Contact> ContactsList=Trigger.new;
Map<String,String> funcRoles=new Map<String,String>();
List<String> newRoles=new List<String>();
Role__c updateRoles=null;
List <Role__c> updateRoleslst =new List <Role__c>();
Set<String> funcRoles1=new Set<String>();
List<String> funcRoles1_lst=new List<String>();
Set<String> funcRoles2=new Set<String>();
List<Role__c> roles = new List<Role__c>();
List<Case> lstUpdtCases = new List<Case>();
Map<ID,String> mpContactFunc = new Map<ID,String>();
List<Id> lstContactIds= new List<id>();
List<Case> lstCases = new List<Case>();
//  Code Added for SR430612 - Start
List<String> contactemailList = new List<String>();
Map<String,Contact> contactsMap=new Map<String,Contact>();
List <User> userlist = new List <User>();
//  Code Added for SR430612 - End
//Added by Swastika-IBM on 08-Dec-2017 <start>
 if(TriggerInactive.avoidRecursionContact_Sync){ 
    TriggerInactive.avoidRecursionContact_Sync= false; 
    for(Integer i=0;i<ContactsList.size();i++){
        if(Trigger.isUpdate && Trigger.new[i].Functional_Role__c!=null && ContactsList[i].Customer_Portal_UserId__c ==Null ){  
            if(Trigger.old[i].Functional_Role__c!=Trigger.new[i].Functional_Role__c){
                funcRoles.put(Trigger.new[i].Functional_Role__c,Trigger.new[i].Functional_Role__c);
                funcRoles1.add(Trigger.new[i].Functional_Role__c);
                funcRoles2.add(Trigger.new[i].Functional_Role__c);
            }    
        }
        if(Trigger.isInsert && Trigger.new[i].Functional_Role__c!=null && ContactsList[i].Customer_Portal_UserId__c ==Null){
            funcRoles.put(Trigger.new[i].Functional_Role__c,Trigger.new[i].Functional_Role__c);
            funcRoles1.add(Trigger.new[i].Functional_Role__c);
            funcRoles2.add(Trigger.new[i].Functional_Role__c);  
        }        
        //  code added for SR430612 - Start
        if(Trigger.isInsert && Trigger.new[i].Primary_Email_Address__c!=null)
        { 
            System.debug('### contacts email Addr  '+Trigger.new[i].Primary_Email_Address__c);
            contactemailList.add(Trigger.new[i].Primary_Email_Address__c);
            contactsMap.put(Trigger.new[i].Primary_Email_Address__c,Trigger.new[i]); 
        }    
        //  code added for SR430612 - End
        
    }
    //Querying from the Role object
    roles=[Select Name from Role__c where name!=null];
    funcRoles1_lst.addAll(funcRoles1);
    newRoles.addAll(funcRoles1_lst);
    
    /* Check if the Functional Role of the Contact already exists as a 'Role' and if not, insert a new Role record */
    for(Integer k=0;k<newRoles.size();k++){
      for(Integer l=0;l<roles.size();l++){
        if(newroles.size()>0) {
          if(newroles[k]== roles[l].Name)
            newRoles.remove(k);
        }
      }  
    }
    if(newRoles.size()>0)
    {
    Contact_Sync_FunctionalRoles_ACL.insertRoles(newRoles);
    }
        // Code added for SR # 377532 starts
        for(Contact objContact: Trigger.new)
        {
            if(Trigger.isUpdate && Trigger.isAfter &&  System.Trigger.OldMap.get(objContact.id).Contact_Function__c!= objContact.Contact_Function__c)
            {
                mpContactFunc.put(objContact.Id,objContact.Contact_Function__c); 
                lstContactIds.add(objContact.Id);
            }
        }
        if(lstContactIds.size() > 0)
        {
             lstCases = [Select id,contact_func__c,contactid from case where contactid in :lstContactIds and recordtypeid =: label.Pilot_s_Corner_Avionics_RT_ID];
            
                for(Case objCase: lstCases)
                {
                    if(objCase.contact_func__c!=mpContactFunc.get(objCase.contactid))
                    {                
                        objCase.contact_func__c = mpContactFunc.get(objCase.contactid);
                        lstUpdtCases.add(objCase);
                    }
                }
                if(lstUpdtCases.size() > 0)
                {
                    update lstUpdtCases;
                }
             
        }
        // Code added for SR # 377532 ends
        // Code added for SR430612   
        if (contactemailList.size() > 0)
        {
            userlist = [Select id,Email,Primary_Manager_EID__c,Primary_Manager_Name__c from user where Email in :contactemailList and IsPortalEnabled = False and isactive = true ];
            System.debug('####Inside if '+userlist.size());
            if(userlist.size() == 1 ){
                for(User usr : userlist)
                {   
                    Contact objCont = contactsMap.get(usr.Email);
                    objCont.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;
                    objCont.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
                }
            }   
        } 
        //code added for SR430612  
    
    }
}