trigger PrimaryPart_FieldEvents on Parts__c (after delete, after update, before insert) {

		List <Id>accId=new List <Id>();
    Field_Event__c acc=null;
    Field_Event__c accDel=null;
    List <Field_Event__c>accAdd=new List <Field_Event__c> ();
    List <Field_Event__c>accAddDel=new List <Field_Event__c> ();
    List <Parts__c>errorlist=new List <Parts__c> ();
    Map<String,Parts__c>addressDetails=new Map<String,Parts__c>();
    Map <Id,Id>accAddrssmpId=new Map <Id,Id>();
    List <Id>delAccId=new List <Id>();
    if (trigger.isInsert || trigger.isUpdate)
    {
        for (Parts__c add: Trigger.new)
        {
             if (add.Primary_Part__c)
                {
                     accId.add(add.Field_Event__c );
                     addressDetails.put(add.Field_Event__c, add);
                     accAddrssmpId.put(add.Id,add.Id);
               }
               if (Trigger.isUpdate && Trigger.oldMap.get(add.Id).Primary_Part__c==TRUE && Trigger.newMap.get(add.Id).Primary_Part__c==FALSE )
               {
               delAccId.add(add.Field_Event__c);
               }
        }
    }
    else if (Trigger.isDelete)
    {
    
        for (Parts__c addDel: Trigger.old)
        {
            if (addDel.Primary_Part__c)
                {
                    delAccId.add(addDel.Field_Event__c);
                }
        
        }
    
    }
    /* Nullify the Primary Address fields on Account if we uncheck the Primary Address checkbox on Account Address */
    if (delAccId.size()>0)
    {
    
    for (Integer z=0 ;z<delAccId.size();z++)
                {
                    accDel=new Field_Event__c(Id=delAccId.get(z));
                            /*accDel.Address_Line_1__c = '';
                            accDel.Address_Line_2__c = '';
                            accDel.Address_Line_3__c = '';
                            accDel.City_Name__c = '';
                            accDel.Postal_Code__c = '';
                            accDel.State_Code__c = '';
                            accDel.Country_Name__c = '';*/
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
        list<Parts__c> Addr = [select Id, Field_Event__c from Parts__c where Primary_Part__c =: True and Field_Event__c in:accId];
        if (Addr.size()>0 )
        {
            for (Parts__c a:Addr)
            {
                /* Check only one Primary Address exists for the Account */
                if (accAddrssmpId.get(a.Id)!=a.Id)
                {
                  errorlist.add(a);
                  }
                else
                {
                            acc=new Field_Event__c(Id=a.Field_Event__c);
                            /*acc.Address_Line_1__c = a.Report_Address_Line_1__c;
                            acc.Address_Line_2__c = a.Report_Address_Line_2__c;
                            acc.Address_Line_3__c = a.Report_Address_Line_3__c;
                            acc.City_Name__c = a.Report_City_Name__c;
                            acc.Postal_Code__c = a.Report_Postal_Code__c;
                            acc.State_Code__c = a.Report_State_Code__c;
                            acc.Country_Name__c = a.Report_Country_Name__c;
                            */
                            accAdd.add(acc);
                }
            }
        }
        else
        {
            for (Integer i=0 ;i<accId.size();i++)
                {
                    acc=new Field_Event__c(Id=accId.get(i));
                            /*acc.Address_Line_1__c = addressDetails.get(accId.get(i)).Report_Address_Line_1__c;
                            acc.Address_Line_2__c = addressDetails.get(accId.get(i)).Report_Address_Line_2__c;
                            acc.Address_Line_3__c = addressDetails.get(accId.get(i)).Report_Address_Line_3__c;
                            acc.City_Name__c = addressDetails.get(accId.get(i)).Report_City_Name__c;
                            acc.Postal_Code__c = addressDetails.get(accId.get(i)).Report_Postal_Code__c;
                            acc.State_Code__c = addressDetails.get(accId.get(i)).Report_State_Code__c;
                            acc.Country_Name__c = addressDetails.get(accId.get(i)).Report_Country_Name__c;
                    */
                    accAdd.add(acc);
                }
        }   
        if (accAdd.size()>0)
            {
                try
                {
              System.debug('Acc Address : '+accAdd);  
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
              if(Trigger.new[i].Field_Event__c == errorlist[k].Field_Event__c)
               Trigger.new[i].addError('Primary part already exists for this Field Event, Please deselect Primary Part checkbox  ');
            }
        }    
    }

}