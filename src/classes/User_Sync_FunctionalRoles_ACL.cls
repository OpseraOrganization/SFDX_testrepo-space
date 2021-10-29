/** * File Name: User_Sync_FunctionalRoles_ACL
* Description Class that inserts new Roles when a User is inserted/updated and if the Role does not already exist in 'Role'
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 


public with sharing class User_Sync_FunctionalRoles_ACL {


@future public static void insertRoles(List<String> newRoles)
{

try{
    Role__c updateRoles=null;

List <Role__c> updateRoleslst =new List <Role__c>();
        for(Integer m=0;m<newroles.size();m++){
            updateRoles = new Role__c ();
            updateRoles.Name=newroles[m];
            updateRoleslst.add(updateRoles);
        }
        insert updateRoleslst;
        System.Debug('New Values to be added');
    }
    catch(Exception e){
        System.Debug('Exception e'+e);
    }
}

}