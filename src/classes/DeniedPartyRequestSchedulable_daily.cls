/** * File Name: Account_UpdateOwner
* Description :scheduled daily to invoke the CreateAccountAddressBatch_daily class
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log ========================== Ver Date Author Modification --- ---- ------ -------------* */ 

global class DeniedPartyRequestSchedulable_daily implements Schedulable{ 
    global void execute(SchedulableContext SC) {  
        DeniedPartyRequestSchedulable_daily  M = new DeniedPartyRequestSchedulable_daily();
        M.callbatch();       
    }
    public void callbatch()
    {
    Id batchInstanceId = Database.executeBatch(new CreateAccountAddressBatch_daily(), 5000);
    }   
    webservice static void call()
    {
        DeniedPartyRequestSchedulable_daily  M = new DeniedPartyRequestSchedulable_daily();
        M.callbatch();
    }
}