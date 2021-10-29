/** * File Name: Account_UpdateOwner
* Description :scheduled weekly to invoke the CreateAccountAddressBatch class
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log ========================== Ver Date Author Modification --- ---- ------ -------------* */ 

global class DeniedPartyRequestSchedulable implements Schedulable{ 
    global void execute(SchedulableContext SC) {  
        DeniedPartyRequestSchedulable  M = new DeniedPartyRequestSchedulable();
        M.callbatch();       
    }
    public void callbatch()
    {
    Id batchInstanceId = Database.executeBatch(new CreateAccountAddressBatch(), 5000);
    }   
    webservice static void call()
    {
        DeniedPartyRequestSchedulable  M = new DeniedPartyRequestSchedulable();
        M.callbatch();
    }
}