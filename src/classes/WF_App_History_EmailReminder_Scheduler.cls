/*  * File Name: WF_App_History_EmailReminder_Scheduler
    * Description: Scheduler Class To Schedule The Daily Email Reminder
    * Copyright : Wipro Technologies Limited Copyright (c) 2010
    * @author : wipro
    * Modification Log ===============================================================
      Ver Date Author Modification --- ---- ------ -------------*
     */

//Scheduler class

global class WF_App_History_EmailReminder_Scheduler implements Schedulable{
      
    global void execute(SchedulableContext sc){ 
            
        WFAH_EmailReminder  a = new WFAH_EmailReminder();
        datetime test = system.now().addHours(-24);
        // Querying the records from the WOrkflow approval history
        a.query = 'select Id, Approval_Status__c, Approver__c, CreatedDate from WorkFlow_Approval_History__c where Date_Formula__c = \'True\' ';
        System.debug(a.query);
        Id BatchProcessId=Database.ExecuteBatch(a);
    }
}