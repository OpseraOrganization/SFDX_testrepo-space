/** * File Name: AccountAddress_PrimaryAddress
* Description  Trigger to update Primary Address fields on Account when a
*Account Address associated with the Account is marked as 'Primary Addess' 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger AccountAddress_PrimaryAddress on Account_Address__c (after delete,  before insert, after update) {
    String profid=(UserInfo.getProfileId().substring(0,15));
    if(profid!=label.DeniedpartyAPIuserprofile){
    List <Id>accId=new List <Id>();
    Account acc=null;
    Account accDel=null;
    List <Account>accAdd=new List <Account> ();
    List <Account>accAddDel=new List <Account> ();
    List <Account_Address__c>errorlist=new List <Account_Address__c> ();
    Map<String,Account_Address__c>addressDetails=new Map<String,Account_Address__c>();
    Map <Id,Id>accAddrssmpId=new Map <Id,Id>();
    List <Id>delAccId=new List <Id>();
    if (trigger.isInsert || trigger.isUpdate)
    {
        for (Account_Address__c add: Trigger.new)
        {
             if (add.Is_Primary_Address__c)
                {
                     accId.add(add.Account_Name__c );
                     addressDetails.put(add.Account_Name__c, add);
                     accAddrssmpId.put(add.Id,add.Id);
               }
               if (Trigger.isUpdate && Trigger.oldMap.get(add.Id).Is_Primary_Address__c==TRUE && 
               Trigger.oldMap.get(add.Id).Account_Name__c == Trigger.newMap.get(add.Id).Account_Name__c && 
               Trigger.newMap.get(add.Id).Is_Primary_Address__c==FALSE )
               {
               delAccId.add(add.Account_Name__c);
               }
        }
    }
    else if (Trigger.isDelete)
    {
    
        for (Account_Address__c addDel: Trigger.old)
        {
            if (addDel.Is_Primary_Address__c)
                {
                    delAccId.add(addDel.Account_Name__c);
                }
        
        }
    
    }
    /* Nullify the Primary Address fields on Account if we uncheck the Primary Address checkbox on Account Address */
    if (delAccId.size()>0)
    {
    
    for (Integer z=0 ;z<delAccId.size();z++)
                {
                    accDel=new Account(Id=delAccId.get(z));
                            /* accDel.Address_Line_1__c = '';
                            accDel.Address_Line_2__c = '';
                            accDel.Address_Line_3__c = '';
                            accDel.City_Name__c = '';
                            accDel.Postal_Code__c = '';
                            accDel.State_Code__c = '';
                            accDel.Country_Name__c = ''; 
                            */
                            
                            accDel.Report_Address_Line_1__c = '';
                            accDel.Report_Address_Line_2__c = '';
                            accDel.Report_Address_Line_3__c = '';
                            accDel.Report_City_Name__c = '';
                            accDel.Report_Postal_Code__c = '';
                            accDel.Report_State_Code__c = '';
                            accDel.Report_Country_Name__c = '';

                    accAddDel.add(accDel);
                }
                if (accAddDel.size()>0)
            {
                try
                {
                    update accAddDel;
                }
                catch (Exception e)
                {
                    System.debug('Exception in Updating Address on Account Trigger '+e);
                }
            }
    
    }
    /* Update the Primary Address fields if a Account Address is created for the Account with Primary Address=true */
    if (accId.size()>0)
    {
        list<Account_Address__c> Addr = [select Id,Account_Name__c , Report_Address_Line_1__c,Report_Address_Line_2__c,Report_Address_Line_3__c,Report_City_Name__c,Report_Postal_Code__c,Report_State_Code__c, Report_Country_Name__c from Account_Address__c where Is_Primary_Address__c =: True and Account_Name__c in:accId];
        if (Addr.size()>0 )
        {
            for (Account_Address__c a:Addr)
            {
                /* Check only one Primary Address exists for the Account */
                if (accAddrssmpId.get(a.Id)!=a.Id)
                {
                  errorlist.add(a);
                  }
                else
                {
                            acc=new Account(Id=a.Account_Name__c);
                            /*
                            acc.Address_Line_1__c = a.Report_Address_Line_1__c;
                            acc.Address_Line_2__c = a.Report_Address_Line_2__c;
                            acc.Address_Line_3__c = a.Report_Address_Line_3__c;
                            acc.City_Name__c = a.Report_City_Name__c;
                            acc.Postal_Code__c = a.Report_Postal_Code__c;
                            acc.State_Code__c = a.Report_State_Code__c;
                            acc.Country_Name__c = a.Report_Country_Name__c;
                            */
                            acc.Report_Address_Line_1__c = a.Report_Address_Line_1__c;
                            acc.Report_Address_Line_2__c = a.Report_Address_Line_2__c;
                            acc.Report_Address_Line_3__c = a.Report_Address_Line_3__c;
                            acc.Report_City_Name__c = a.Report_City_Name__c;
                            acc.Report_Postal_Code__c = a.Report_Postal_Code__c;
                            acc.Report_State_Code__c = a.Report_State_Code__c;
                            acc.Report_Country_Name__c = a.Report_Country_Name__c;
                            
                            try
                            {
                                acc.Country__c =[SELECT id FROM Country__c WHERE Name =: acc.Report_Country_Name__c].id;
                            }
                            catch (Exception e)
                            {
                                System.debug('Exception in Updating Country'+e);
                            }
                 
                            accAdd.add(acc);
                }
            }
        }
        else
        {
            for (Integer i=0 ;i<accId.size();i++)
                {
                    acc=new Account(Id=accId.get(i));
                            /*
                            acc.Address_Line_1__c = addressDetails.get(accId.get(i)).Report_Address_Line_1__c;
                            acc.Address_Line_2__c = addressDetails.get(accId.get(i)).Report_Address_Line_2__c;
                            acc.Address_Line_3__c = addressDetails.get(accId.get(i)).Report_Address_Line_3__c;
                            acc.City_Name__c = addressDetails.get(accId.get(i)).Report_City_Name__c;
                            acc.Postal_Code__c = addressDetails.get(accId.get(i)).Report_Postal_Code__c;
                            acc.State_Code__c = addressDetails.get(accId.get(i)).Report_State_Code__c;
                            acc.Country_Name__c = addressDetails.get(accId.get(i)).Report_Country_Name__c;
                            */
                            acc.Report_Address_Line_1__c = addressDetails.get(accId.get(i)).Report_Address_Line_1__c;
                            acc.Report_Address_Line_2__c = addressDetails.get(accId.get(i)).Report_Address_Line_2__c;
                            acc.Report_Address_Line_3__c = addressDetails.get(accId.get(i)).Report_Address_Line_3__c;
                            acc.Report_City_Name__c = addressDetails.get(accId.get(i)).Report_City_Name__c;
                            acc.Report_Postal_Code__c = addressDetails.get(accId.get(i)).Report_Postal_Code__c;
                            acc.Report_State_Code__c = addressDetails.get(accId.get(i)).Report_State_Code__c;
                            acc.Report_Country_Name__c = addressDetails.get(accId.get(i)).Report_Country_Name__c;

                            try
                            {
                                acc.Country__c =[SELECT id FROM Country__c WHERE Name =: acc.Report_Country_Name__c].id;
                            }
                            catch (Exception e)
                            {
                                System.debug('Exception in Updating Country'+e);
                            }
                    
                            accAdd.add(acc);
                }
        }   
        if (accAdd.size()>0)
            {
                try
                {
            update accAdd;
                }
                catch (Exception e)
                {
                System.debug('Exception in Updating Address on Account Trigger '+e);
                }
            }   
        for(integer i=0;i<Trigger.new.size();i++)
        {
            for(integer k=0;k<errorlist.size();k++)
            {
              if(Trigger.new[i].Account_Name__c == errorlist[k].Account_Name__c)
               Trigger.new[i].addError('Primary address already exists for this Account, Please deselect Is Primary Address checkbox  ');
            }
        }    
    }
  }
}