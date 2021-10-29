/** * File Name: DiscretionaryApprovalMail
* Description Class that displays appropriate messages to the User
* based on the Approval Status of the Discretionary Request
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : 
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
public class DiscretionaryApprovalMail extends BaseEmailTemplate {
 public Id  discretionaryId ;
 public boolean backto{get; set;}
 //public string toApprovalAddres;
 List<String> toApprovalAddres = new List<String>();
 List<String> toAddresses = new List<String>();
    public DiscretionaryApprovalMail(ApexPages.StandardController controller)
     {
        discretionaryId= System.currentPageReference().getParameters().get('id');
     }
    List<Discretionary_Approval_history__c> ApproveobjRec=new List<Discretionary_Approval_history__c>();
    List<Discretionary__c> Disc=new List<Discretionary__c>();
    //private EmailTemplate emailTemplate;

public Pagereference sendMail()
{    
   System.debug('discretionaryId  - >  '+discretionaryId);
    Boolean insertApp =false;
    for (Discretionary__c dsrs :[Select Approval_Status__c,Current_Approver__c, Current_User_Name_Formulae__c,Current_ManagerName_Formulae__c,Discretionary_Workflow_Approver_Amount__c ,Total_Request_Amount_rollup__c,TrackSubmitForApproval__c, Approver_EmailId__c, Backup_EmailId__c from Discretionary__c where Id=: discretionaryId])
    {
        //if (dsrs.TrackSubmitForApproval__c==FALSE)
      //  {
            insertApp=TRUE;
            System.debug('dsrs-- > '+dsrs);
            Discretionary__c discupd =new Discretionary__c(Id=discretionaryId);
                    discupd.TrackSubmitForApproval__c=TRUE;
                    System.debug('dsrs.Discretionary_Workflow_Approver_Amount__c-- > '+dsrs.Discretionary_Workflow_Approver_Amount__c +'dsrs.Total_Request_Amount_rollup__c -- > '+dsrs.Total_Request_Amount_rollup__c);
                    /*New if block is added for Certido Ticket 311486*/
                    /* If the User clicks 'Submit for Approval' when the Request is already Rejected, Proceeds for approval */
                    if (dsrs.Approval_Status__c=='Rejected')
                    {
                        if (dsrs.Discretionary_Workflow_Approver_Amount__c!=null && dsrs.Total_Request_Amount_rollup__c!=null  &&  dsrs.Total_Request_Amount_rollup__c!=0 )
                     {
                        discupd.Approval_Status__c=    'Pending Approval';
                        if (dsrs.Total_Request_Amount_rollup__c< Decimal.valueOf(dsrs.Discretionary_Workflow_Approver_Amount__c))
                        
                        {
                            System.debug('discupd.Current_User_Name_Formulae__c-- > '+discupd.Current_User_Name_Formulae__c);
                            discupd.Current_Approver__c=dsrs.Current_User_Name_Formulae__c;
                            
                        }
                        else
                        {
                            if (dsrs.Current_ManagerName_Formulae__c!=null )
                            {
                            System.debug('discupd.Current_ManagerName_Formulae__c -- > '+discupd.Current_ManagerName_Formulae__c );
                            discupd.Current_Approver__c=dsrs.Current_ManagerName_Formulae__c;
                            }
                            else
                            {
                                //backto=true;
                                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Contact Honeywell System Admin to setup manager to proceed with Approvals. '));
                                //return null;
                                
                            }
                        }
                        System.debug('discupd.Current_Approver__c-- > '+discupd.Current_Approver__c);
                        
                     }
                    }
                    
                    /* If the User clicks 'Submit for Approval' when the Request is already approved or pending approval, display an error message */
                    if (dsrs.Approval_Status__c!='New' && dsrs.Approval_Status__c!='Rejected')
                    {
                        
                    backto=true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Discretionary request is already Approved or Pending Approval.'));
                            return null;
                    }
                    /* If there are no Line Items to approve and the User clicks 'Submit for Approval', display an error message */
                    if (dsrs.Total_Request_Amount_rollup__c==null || dsrs.Total_Request_Amount_rollup__c==0 )
                    {
                        backto=true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Discretionary Line Item is not added to Discretionary Request, please add Discretionary Line Item to Discretionary Request to proceed with Approval.'));
                            return null;
                    }
                  /* If th User clicks 'Submit for Approval' when there are Line Items to approve, update the Approval status of the Request to 'Pending Approval'
                  and set the Current Approver based on the Amount */ 
                  if (dsrs.Approval_Status__c!='Rejected' && dsrs.Discretionary_Workflow_Approver_Amount__c!=null && dsrs.Total_Request_Amount_rollup__c!=null  &&  dsrs.Total_Request_Amount_rollup__c!=0 )
                     {
                        discupd.Approval_Status__c=    'Pending Approval';
                        if (dsrs.Total_Request_Amount_rollup__c< Decimal.valueOf(dsrs.Discretionary_Workflow_Approver_Amount__c))
                        
                        {
                            System.debug('discupd.Current_User_Name_Formulae__c-- > '+discupd.Current_User_Name_Formulae__c);
                            discupd.Current_Approver__c=dsrs.Current_User_Name_Formulae__c;
                            
                        }
                        else
                        {
                            if (dsrs.Current_ManagerName_Formulae__c!=null )
                            {
                            System.debug('discupd.Current_ManagerName_Formulae__c -- > '+discupd.Current_ManagerName_Formulae__c );
                            discupd.Current_Approver__c=dsrs.Current_ManagerName_Formulae__c;
                            }
                            //else
                            //{
                              ///////////////adding to prevent error
                                //if(dsrs.Current_ManagerName_Formulae__c==null  && dsrs.Current_Approver__c==null){
                                //backto=true;
                                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Contact Honeywell System Admin to setup manager to proceed with Approvals. '));
                               // return null;
                               // }
                                
                           // }
                        }
                        System.debug('discupd.Current_Approver__c-- > '+discupd.Current_Approver__c);
                        
                     }
                  //   else
                  //   {
                        //System.debug('Error Please Enter "Total Request Amount" on Discretionary Request & "Discretionary Workflow Approver Amount" on User Detail to proceed with Approvals. ');
              //       backto=true;
       // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Contact Honeywell System Admin to update your Discretionary approver amount to proceed with Approvals. '));
            //                return null;
                  //   }   
                     Disc.add(discupd);
                    
            //}
       // else 
      //  {
       //   backto=true;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Discretionary request is already submitted for approval.'));
       //                     return null;
       // }
    }
    System.debug('Disc-- >  '+Disc);
    if (Disc.size()>0)
         {
            try 
            {
            update Disc;
            }
            catch (Exception e)
            {
            System.debug(e);
            }
         
         }
         /* Insert Approval History records based on the Discretionary Request Approval Status*/
    if (insertApp)
    {
    for (Discretionary__c dsr :[Select Total_Request_Amount_Rollup__c,TrackSubmitForApproval__c, Approver_EmailId__c, Backup_EmailId__c from Discretionary__c where Id=: discretionaryId])
    {
        
                  System.debug('dsr.Approver_EmailId__c'+dsr.Approver_EmailId__c);
                     Discretionary_Approval_history__c aprec=new Discretionary_Approval_history__c();
                    aprec.Approval_Status__c = 'Pending Approval';
                    aprec.Discretionary__c = discretionaryId;
                    aprec.ApproverEmail__c= dsr.Approver_EmailId__c;
                    if (dsr.Backup_EmailId__c != null) { 
                    aprec.Backup_EmailId__c= dsr.Backup_EmailId__c ; 
                    }
                    else { 
                    aprec.Backup_EmailId__c= dsr.Approver_EmailId__c ;
                    } 
                    aprec.Total_Request_Amount__c=String.valueOf(dsr.Total_Request_Amount_Rollup__c);
                    ApproveobjRec.add(aprec);
                    //TrackSubmitForApproval__c=TRUE;
                    
        
     }
    }
     
     if (ApproveobjRec.size()>0)
     {    
        insert ApproveobjRec;
     
     }
         
         
     PageReference oppPage = new PageReference('/' + discretionaryId);
      oppPage.setRedirect(true);
      return  oppPage;
      }
      public PageReference Back()
    {
        PageReference disPage = new PageReference('/' + discretionaryId);
        return  disPage; 
    }
}