/*  * File Name:  Contact_UpdateUser
    * Description: This trigger is used to update the corresponding user record (if any)when an internal contact record record is inserted or updated. 
    * Copyright : Wipro Technologies Limited Copyright (c) 2010
    * @author : wipro
    * Modification Log =============================================================== 
    
*/ 

trigger Contact_UpdateUser on Contact (before insert,after update) {

//Declaring variables
/*commenting trigger code for coverage
List<Contact> ContactsList=Trigger.new;
List<String> contactempnoList = new List<String>();
List<String> userempnoList = new List<String>();
Map<String,Contact> contactsMap=new Map<String,Contact>();
Map<String,User> usersMap=new Map<String,User>();
List<User> UpdateList = new List<USer>();

//Condition check. Only if the Contact Employee number is present and Contact is a Honeywell Employee should the code execute
for(Integer i=0;i<ContactsList.size();i++)
{
if(ContactsList[i].Employee_Number__c!=null && ContactsList[i].Contact_Is_Employee__c == True)
{
contactempnoList.add(ContactsList[i].Employee_Number__c);
contactsMap.put(ContactsList[i].Employee_Number__c,ContactsList[i]);
}
}

if(contactempnoList.size()>0)
{
//Querying the User table for Users with the same Employee number as that of the contacts
for(User u : [select id,EmployeeNumber from User where EmployeeNumber in :contactempnoList])
{
 userempnoList.add(u.EmployeeNumber);
 usersMap.put(u.EmployeeNumber,u);
}
}

for(Integer i=0;i<contactempnoList.size();i++)
{
     for(Integer j=0;j<userempnoList.size();j++)
      {
   //Checking if the User contact number and Employee contact number matches   
         if(contactempnoList[i] == userempnoList[j]) 
           {
   //Updating the User fields with values from contact        
            usersMap.get(userempnoList[j]).FirstName=contactsMap.get(contactempnoList[i]).FirstName;
            usersMap.get(userempnoList[j]).LastName=contactsMap.get(contactempnoList[i]).LastName;
            usersMap.get(userempnoList[j]).SBU_User__c=contactsMap.get(contactempnoList[i]).SBU_Contact__c;
            usersMap.get(userempnoList[j]).CBT__c=contactsMap.get(contactempnoList[i]).CBT__c;
            usersMap.get(userempnoList[j]).CBT_Team__c=contactsMap.get(contactempnoList[i]).CBT_Team__c;
            UpdateList.add(usersMap.get(userempnoList[j]));
           }
      }

}
if(UpdateList.size()>0)
{
try
{
//Updating User List
Update UpdateList;
}
catch(Exception e)
{
System.debug('Exception in updating User.... '+e);
}
}*/
}