/* Trigger to insert Discretionary Line Item Approval History Records when the approval is in Level1*/
trigger DiscretionaryLineItemApprovalHistory_Workflow on Discretionary_Line_Item_Approval_History__c (after update) {
Discretionary_Line_Item_Approval_History__c aprec;
List<Discretionary_Line_Item_Approval_History__c> ApproveobjRec=new List<Discretionary_Line_Item_Approval_History__c>();
List <Discretionary_Line_Item_Approval_History__c>DL =new List<Discretionary_Line_Item_Approval_History__c>();
for (Discretionary_Line_Item_Approval_History__c DLIAP:Trigger.new)
{
// Check if the Dicretionary Approval History record's status is 'Pending Close' and the approval is in 'Level1' 
if (DLIAP.Approval_Status__c=='Pending Close' && DLIAP.Level1__c==TRUE)

{
  // Create a new Discretionary Line Item Approval History Record and set the approval to be in Level2  
  aprec=new Discretionary_Line_Item_Approval_History__c();
            aprec.Approval_Status__c = 'Pending Close';
            aprec.Discretionary_Line_Item__c = DLIAP.Discretionary_Line_Item__c ;
            aprec.Account_Opener_Backup_Email__c   = DLIAP.Account_Opener_Backup_Formulae__c   ;
            aprec.level2__c=TRUE;
            ApproveobjRec.add(aprec);

}

}
if (ApproveobjRec.size()>0)
            {
                insert ApproveobjRec;
      }
}