/** * File Name: ContactAddress_PrimaryAddress
* Description: Trigger to update Primary Address fields on Contact when a Contact Address associated with the Contact is marked as 'Primary Addess'
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger ContactAddress_PrimaryAddress on Contact_Address__c (after delete, after update, before insert) {

    List <Id>accId=new List <Id>();
    Contact acc=null;
    Contact accDel=null;
    List <Contact>accAdd=new List <Contact> ();
    List <Contact>accAddDel=new List <Contact> ();
    Map<String,Contact_Address__c>addressDetails=new Map<String,Contact_Address__c>();
    Map <Id,Id>accAddrssmpId=new Map <Id,Id>();
    List <Id>delAccId=new List <Id>();
    List<Contact_Address__c> errorlist = new List<Contact_Address__c>();
    
    List<Id> ContactId= new  List<Id> ();
    
    
    if (trigger.isInsert || trigger.isUpdate)
    {
        for (Contact_Address__c add: Trigger.new)
        {
             if (add.Is_Primary_Address__c)
                {
                integer flag=0;
                for(integer i=0;i<ContactId.size();i++){
                  if(ContactId[i]==add.Contact__c )
                  flag=1;
                }
                
                     if(flag==0){
                     contactId.add(add.Contact__c );
           // newly added 
                     if(add.Contact__c != null){
                     accId.add(add.Contact__c );}
           // newly added          
                     addressDetails.put(add.Contact__c, add);
                     accAddrssmpId.put(add.Id,add.Id);                   
                     }
               }
               if (Trigger.isUpdate && Trigger.oldMap.get(add.Id).Is_Primary_Address__c==TRUE && 
               Trigger.oldMap.get(add.Id).contact__c == Trigger.newMap.get(add.Id).contact__c && Trigger.newMap.get(add.Id).Is_Primary_Address__c==FALSE )
               {
               delAccId.add(add.Contact__c);
               }
        }
    }
    else if (Trigger.isDelete)
    {
    
        for (Contact_Address__c addDel: Trigger.old)
        {
            if (addDel.Is_Primary_Address__c)
                {
                    delAccId.add(addDel.Contact__c);
                }
        
        }
    
    }
    /* Nullify the Primary Address fields on Contact if we uncheck the Primary Address checkbox on Contact Address */
    if (delAccId.size()>0)
    {
    
    for (Integer z=0 ;z<delAccId.size();z++)
                {
                    accDel=new Contact(Id=delAccId.get(z));
                            accDel.Address_Line_1__c = '';
                            accDel.Address_Line_2__c = '';
                            accDel.Address_Line_3__c = '';
                            accDel.City_Name__c = '';
                            accDel.Postal_Code__c = '';
                            accDel.State_Code__c = '';
                            accDel.Country_Name__c = '';
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
                    System.debug('Exception in Updating Address on Contact Trigger '+e);
                }
            }
    
    }
    /* Update the Primary Address fields if a Contact Address is created for the Contact with Primary Address=true */
    if (accId.size()>0)
    {
        list<Contact_Address__c> Addr = [select Id,Contact__c , Reporting_Street_Address_Line_1__c,Reporting_Street_Address_Line_2__c,Reporting_Street_Address_Line_3__c,Reporting_City_Name__c,Reporting_Address_Postal_Code__c,Reporting_Address_State_Code__c, Reporting_Country_Name__c from Contact_Address__c where Contact__c != null and Is_Primary_Address__c =: True and Contact__c in:accId];
        if (Addr.size()>0 )
        {
            for (Contact_Address__c a:Addr)
            {
                /* Check only one Primary Address exists for a Contact */
                if (accAddrssmpId.get(a.Id)!=a.Id)
                {
                  errorlist.add(a);
                 }
                else
                {
                            acc=new Contact(Id=a.Contact__c);
                            acc.Address_Line_1__c = a.Reporting_Street_Address_Line_1__c;
                            acc.Address_Line_2__c = a.Reporting_Street_Address_Line_2__c;
                            acc.Address_Line_3__c = a.Reporting_Street_Address_Line_3__c;
                            acc.City_Name__c = a.Reporting_City_Name__c;
                            acc.Postal_Code__c = a.Reporting_Address_Postal_Code__c;
                            acc.State_Code__c = a.Reporting_Address_State_Code__c;
                            acc.Country_Name__c = a.Reporting_Country_Name__c;
                            
                            accAdd.add(acc);
                }
            }
        }
        else
        {
            for (Integer i=0 ;i<accId.size();i++)
                {
                    acc=new Contact(Id=accId.get(i));
                            acc.Address_Line_1__c = addressDetails.get(accId.get(i)).Reporting_Street_Address_Line_1__c;
                            acc.Address_Line_2__c = addressDetails.get(accId.get(i)).Reporting_Street_Address_Line_2__c;
                            acc.Address_Line_3__c = addressDetails.get(accId.get(i)).Reporting_Street_Address_Line_3__c;
                            acc.City_Name__c = addressDetails.get(accId.get(i)).Reporting_City_Name__c;
                            acc.Postal_Code__c = addressDetails.get(accId.get(i)).Reporting_Address_Postal_Code__c;
                            acc.State_Code__c = addressDetails.get(accId.get(i)).Reporting_Address_State_Code__c;
                            acc.Country_Name__c = addressDetails.get(accId.get(i)).Reporting_Country_Name__c;
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
                System.debug('Exception in Updating Address on Contact Trigger '+e);
                }
            }  
         for(integer i=0;i<Trigger.new.size();i++)
        {
           for(integer k=0;k<errorlist.size();k++)
            {
              if(Trigger.new[i].Contact__c == errorlist[k].Contact__c)
               Trigger.new[i].addError('Primary address already exists for this Contact, Please deselect Is Primary Address checkbox  ');
            }
        }      
    }

}