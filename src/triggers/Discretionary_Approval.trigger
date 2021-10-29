/* Trigger to update values on Discretionary Request Approval History when the Request is Approved or Rejected*/
trigger Discretionary_Approval on Discretionary_Approval_history__c(before update)
{
   List<Id> appid = new List<ID>();
   List <String> discId=new List <String>();
   List <String> discAppBackId=new List <String>();
   List <String> discAccOpenerId=new List <String>();
   List <String> discAccBackupOpenerId=new List <String>();
   List<Discretionary_Approval_history__c> ApproveobjRec=new List<Discretionary_Approval_history__c>();
   Discretionary_Approval_history__c aprec;
      List<Discretionary_Line_Item__c> DLI= new List <Discretionary_Line_Item__c>();
      List<Discretionary_Line_Item__c> DLI1= new List <Discretionary_Line_Item__c>();
      Map <String,String>mpDisc=new Map<String,String>();
      List<Discretionary__c> discretionary= new List <Discretionary__c>();
      List<Discretionary__c> discretionaryUpdateStatus= new List <Discretionary__c>();
      Discretionary__c disup;
      Discretionary__c disupReject;
       List<Discretionary__c> discretionaryUpdateStatusReject= new List <Discretionary__c>();
     List <String> discReject=new List <String>();
     Map <Id,String> mapTotApprdAmt=new Map<Id,String>(); 
     
     
     
     
for(Discretionary_Approval_history__c DAH : Trigger.new)
{
if(DAH.Is_Discretionary_Closed__c == False)
{
 /* Check if the Discretinary Request is pending for approval with Level 1 */
 if(DAH.SendApproval_Level1__c == TRUE && DAH.SendApproval_Level1__c == FALSE && DAH.Approval_Status__c=='Pending Approval' && DAH.SendApproval_Level2__c == FALSE &&DAH.DiscretionaryBakupApproverEmailFormulae__c!=null)
             {
                aprec=new Discretionary_Approval_history__c();
                        aprec.Approval_Status__c = 'Pending Approval';
                        aprec.Approval_submitted_date__c = System.today();
                        aprec.Discretionary__c = DAH.Discretionary__c;
                        aprec.Backup_EmailId__c=DAH.DiscretionaryBakupApproverEmailFormulae__c;
                        aprec.SendApproval_Level2__c=TRUE;
                        aprec.Total_Request_Amount__c=DAH.Total_Request_Amount__c;
                        ApproveobjRec.add(aprec);
                        mpDisc.put(DAH.Discretionary__c,DAH.Discretionary__c);
             //discId.add(DAH.Discretionary__c);
             }
/* Check if the Discretinary Request is pending for approval with Level 3 */
             
else if(DAH.SendApproval_Level3__c == TRUE && DAH.SendApproval_Level3__c == FALSE && DAH.Approval_Status__c=='Pending Approval' && DAH.SendApproval_Level2__c == TRUE && DAH.DiscretionaryBakupApproverEmailFormulae__c!=null && DAH.DiscretionaryApproverEmailFormulae__c!=null)
             {
            // discAppBackId.add(DAH.Discretionary__c);
             
             for (Integer i=0;i<2;i++)
             {
                        aprec=new Discretionary_Approval_history__c();
                        aprec.Approval_Status__c = 'Pending Approval';
                        aprec.Approval_submitted_date__c = System.today();
                        aprec.Total_Request_Amount__c=DAH.Total_Request_Amount__c;
                        aprec.Discretionary__c = DAH.Discretionary__c;
                        if (i==0)
                        {
                        aprec.Backup_EmailId__c=DAH.DiscretionaryBakupApproverEmailFormulae__c;
                        }
                        else
                        {
                        aprec.ApproverEmail__c=DAH.DiscretionaryApproverEmailFormulae__c;
                        }
                        aprec.SendApproval_Level3__c=TRUE;
                        ApproveobjRec.add(aprec);             
             }
                      
             
             }
             /* Check if the Discretionary Request is Approved */
             else if (DAH.Approval_Status__c=='Approved')
             {
             DAH.Is_Discretionary_Closed__c = True;
             appid.add(DAH.Id);
             discAccOpenerId.add(DAH.Discretionary__c);
             mapTotApprdAmt.put(DAH.Discretionary__c,DAH.Total_Request_Amount__c);
             }
             /* Check if the Discretionary Request is Rejected */

             else if (DAH.Approval_Status__c=='Rejected')
             {
             DAH.Is_Discretionary_Closed__c = True;
             appid.add(DAH.Id);
             discReject.add(DAH.Discretionary__c);
             }
             
}
}


if(discReject.size()>0 || discAccOpenerId.size()>0)
{
 List<Discretionary_Approval_history__c> historylist = [select  id,Is_Discretionary_Closed__c,
 Approval_Status__c  from Discretionary_Approval_history__c where
  (Discretionary__c in  :discReject or Discretionary__c in  :discAccOpenerId ) and  (id not in :appid)];  
 
 if(historylist.size() >0 && historylist.size() != 0 )
 for (Integer k=0;k<historylist.size();k++)
 {
 historylist[k].Is_Discretionary_Closed__c = True;
 }
 if(historylist.size()>0)
 update historylist;
 
}
 
 
 
 
 
/* Update the 'Approval Status' field on Discretionary Request to 'Rejected' if Approval Status field on the corresponding Discretionary 
Approval History is 'Rejected' */
if (discReject.size()>0)
{
   list<Discretionary__c> lstdis =[select id,Total_Approved_Amount__c from Discretionary__c where id =:discReject];
    for (Integer j=0;j<discReject.size();j++)
    {
    disupReject=new Discretionary__c (id=discReject.get(j));
    for(Discretionary__c dis:lstdis)
    if(disupReject.id==dis.id){
    if(dis.Total_Approved_Amount__c>0)
    disupReject.Approval_Status__c='Open';
    if(dis.Total_Approved_Amount__c<=0)
    disupReject.Approval_Status__c='New';
    discretionaryUpdateStatusReject.add(disupReject);
    }
    }
    if (discretionaryUpdateStatusReject.size()>0)
{
    update discretionaryUpdateStatusReject;

}   
}


if (ApproveobjRec.size()>0)
{
insert ApproveobjRec;
}
/* Updates the current Approver to Current User if the Request Amount is less than the Current User's Discretionary Workflow Approver Amount,
Else updates the Current Approver to Current user's Manager*/

if (mpDisc.size()>0)
{
    for (Discretionary__c ds: [select Id,Current_UserManagerBackup_Username_Formu__c,Current_Approver__c , Total_Request_Amount_rollup__c , Discretionary_Workflow_Approver_Amount__c , Current_UserBackup_Username_Formulae__c  from Discretionary__c where id in :mpDisc.keySet()])
    
    {
    
     if (ds.Id==mpDisc.get(ds.Id))
     {
        
        if (ds.Total_Request_Amount_rollup__c< Decimal.valueOf(ds.Discretionary_Workflow_Approver_Amount__c))
                        
                        {
                                           ds.Current_Approver__c=ds.Current_UserBackup_Username_Formulae__c   ;
                        
                        }
                        else
                        {
                            ds.Current_Approver__c=ds.Current_UserManagerBackup_Username_Formu__c   ;
                        }
        
        discretionary.add(ds);
        
     }
    
    }
    if (discretionary.size()>0)
    {
        update discretionary;
    
    }
}

if (discAccOpenerId.size()>0)
{

for (Integer i=0;i<discAccOpenerId.size();i++)
{
    
    disup=new Discretionary__c (id=discAccOpenerId.get(i));
    disup.Approval_Status__c='Approved';
    disup.Total_Approved_Amount_Hidden__c=Decimal.valueOf(mapTotApprdAmt.get(discAccOpenerId.get(i)));
discretionaryUpdateStatus.add(disup);


}
if (discretionaryUpdateStatus.size()>0)
{
    update discretionaryUpdateStatus;

}
/* Update the Status of Discretionary Line Item to 'Pending Open' if a request is 'Approved' and the Account Opener
is yet to open the Account in the Legacy System.If the Account is already opened and a change in Request Amount is 'Approved', update the status to 'Open'*/

for (Discretionary_Line_Item__c DisLI: [select Id,Discretionary_Account__c ,Discretionary_Owner_Email__c,Discretionary_CC_List_Email__c,Discretionary_Engineer_Lead_User_Email__c,Discretionary_Engineer_Lead_ContactEmail__c,Discretionary_Owner_Email_Formulae__c,Discretionary_CC_List_Email_Formulae__c,Disc_Engr_LeadUser_Email_Formule__c,DisEngr_Lead_Contact_EmailFormule__c,AccountOpener__c ,Approval_Status__c,Account_Opener_Backup__c from Discretionary_Line_Item__c where Discretionary_Request__c in :discAccOpenerId and (Approval_Status__c='New' OR Approval_Status__c='Open') ])

{
    //Discretionary_SendApprovalMail dSendApp =new Discretionary_SendApprovalMail ();
//dSendApp.sendMail(DLI,'Account_opener','');
DisLI.Account_Opener_Email__c=DisLI.AccountOpener__c;
DisLI.Account_Opener_Backup_Email__c=DisLI.Account_Opener_Backup__c;

DisLI.Discretionary_Owner_Email__c=DisLI.Discretionary_Owner_Email_Formulae__c;
DisLI.Discretionary_CC_List_Email__c=DisLI.Discretionary_CC_List_Email_Formulae__c;
DisLI.Discretionary_Engineer_Lead_User_Email__c=DisLI.Disc_Engr_LeadUser_Email_Formule__c;
DisLI.Discretionary_Engineer_Lead_ContactEmail__c=DisLI.DisEngr_Lead_Contact_EmailFormule__c;

DisLI.Approval_Status__c='Pending Open';
System.Debug('Outside DisLI.Discretionary_Account__c'+DisLI.Discretionary_Account__c);
/* if(DisLI.Discretionary_Account__c!=null){
    System.Debug('Inside DisLI.Discretionary_Account__c');
    DisLI.Approval_Status__c='Open';  
}*/
DLI.add(DisLI);
}

if (DLI.size()>0)
{
update DLI;
}
/********************/
for (Discretionary_Line_Item__c DisLI: [select Id, DLIFlag__c from Discretionary_Line_Item__c where Discretionary_Request__c in :discAccOpenerId and DLIFlag__c = false])
{
DisLI.DLIFlag__c=true;
DLI1.add(DisLI);
}

if (DLI1.size()>0)
{
update DLI1;
}
/********************/
}
}