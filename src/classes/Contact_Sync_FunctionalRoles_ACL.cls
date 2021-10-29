/* Class that inserts new Roles when a Contact is inserted/updated and if the Role does not already exist in 'Role' */
public with sharing class Contact_Sync_FunctionalRoles_ACL {


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