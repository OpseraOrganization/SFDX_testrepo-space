/** * File Name: Solution_updateWorkflowFields
* Description :Trigger to update solution fields used for workflows
* Copyright : Wipro Technologies Limited Copyright (c) 2001 
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Solution_updateWorkflowFields on Solution (before insert,before update) {
// Techincal Audit commented - start
/*boolean techchk = true;
for(Solution sol1: Trigger.new){
if((sol1.Record_Type_Name__c == 'Solution GTO Technical' 
     || sol1.Record_Type_Name__c == 'Solution GTO Technical (Read Only)')
   &&  sol1.status=='Approved' )
    techchk = false;
}
if(techchk==true){
*/
// Techincal Audit commented - end
//declaration of variables
List<String> approvers=new List<String>();
List<user> userApprovers=new List<user>();
Id sfdcAdminId='005300000041m9d';
List<user> users=new List<user>();
List<Id> userId=new List<Id>();
List<String> productArray=new List<String>();
//List<Skills2__c>  Skills= new  List<Skills2__c>();
List<Supported_Products__c>  Skills= new  List<Supported_Products__c>();
String Qualityemail,Auditemail,ContentEmail,AuditemailCallTransfer,AuditemailGeneral,
AuditemailSite,AuditemailDataBase,AuditemailInstallation,AuditemailMaintenance,AuditemailOperation;
List<QueueSobject> emailArray=[Select Queue.email,Queue.name from QueueSobject where 
SobjectType = 'Case' and  (Queue.name='CSO Quality Team' 
or Queue.name='CSO Audit Call Transfer Instructions'
or Queue.name='CSO Audit General Information'
or Queue.name='CSO Audit Site Coordinators'
or Queue.name='CSO Audit DataBase'
or Queue.name='CSO Audit Installation'
or Queue.name='CSO Audit Maintenance & Troubleshooting'
or Queue.name='CSO Audit Operation' or
  Queue.name='CSO Content Audit Team')];
  /*
for(integer i=0;i<emailArray.size();i++)
{
if(emailArray[i].Queue.name == 'CSO Quality Team')
Qualityemail = emailArray[i].Queue.email ;
//if(emailArray[i].Queue.name == 'CSO Audit Team')
//Auditemail = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Call Transfer Instructions')
AuditemailCallTransfer = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit General Information')
AuditemailGeneral = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Site Coordinators')
AuditemailSite = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit DataBase')
AuditemailDataBase = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Installation')
AuditemailInstallation = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Maintenance & Troubleshooting')
AuditemailMaintenance = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Operation')
AuditemailOperation = emailArray[i].Queue.email ; 

if(emailArray[i].Queue.name == 'CSO Content Audit Team')
ContentEmail = emailArray[i].Queue.email ; 
}
*/

for(Solution sol: Trigger.new){
//////////Modified the logic for approver for legacy data on April 27,2011 
// For legacy Data Approver field population
if(Trigger.isInsert){
if(sol.Legacy_Approved_By__c !=null  && ( sol.status=='Approved'  ||  sol.status=='Audit'))
approvers.add(sol.Legacy_Approved_By__c);
///sol.approver__c=sfdcAdminId;
}

// added the logic on april 27,2011 to update the approver field
if(Trigger.isUpdate){
if(System.Trigger.NewMap.get(sol.Id).Status =='Approved' && System.Trigger.OldMap.get(sol.Id).Status !='Approved')
sol.approver__c=Userinfo.getUserId();
}

if(sol.status=='Rejected' && System.Trigger.OldMap.get(sol.Id).Status !='Rejected' && sol.Rejected_By__c==null )
sol.Rejected_By__c=Userinfo.getUserId();

if(Trigger.IsUpdate){
   /* if(sol.Record_Type_Name__c == 'Solution_CSO_Nontechnical' && sol.Status=='Content Review' && sol.Audit_Date_CSO__c==null)
    {
    sol.Current_Approver__c = sol.Submitter_Manager__r.Id ; 
    }
    */
    // when solution is set to ' Back to Draft' to restart the whole solution cycle
    if(sol.status=='Back To Draft'  && System.Trigger.OldMap.get(sol.Id).Status !='Back To Draft'  ){
        sol.back_to_draft__C=true;       
        sol.status='Draft';
        sol.Current_Approver__c=null;
        sol.Approver_Name__c=null;
        sol.Content_Review_Status__c=null;
        sol.Content_Review_Approved_By__c=null;
        sol.Content_Review_Approval_Date__c=null;
        sol.Final_Review_Status__c=null;
        sol.Final_Review_Approved_By__c=null;
        sol.approver__c=null;
        sol.Content_Review_Audit_Status__c=null;
        sol.Content_Review_Audit_Approved_By__c=null;
        sol.Audit_Date_CSO__c=null;                  
        sol.Standards_Review_Status__c=null;
        sol.Standards_Review_Approved_By__c=null;
        sol.Technical_Review_Approved_By__c=null;
        sol.Technical_Review_Audit_Approved_By__c=null;
        sol.Technical_Review_Status__c=null;
        sol.Technical_Review_Audit_Status__c=null;         
    }          
}
  //owner array
 IF(sol.CreatedById !=NULL)
 userId.add(sol.CreatedById);
 //Based on Categorization audit team will be selected
 
 if(Trigger.isInsert ||( Trigger.isUpdate &&  (System.Trigger.OldMap.get(sol.Id).Categorization__c != System.Trigger.NewMap.get(sol.Id).Categorization__c))){

for(integer i=0;i<emailArray.size();i++)
{
if(emailArray[i].Queue.name == 'CSO Quality Team')
Qualityemail = emailArray[i].Queue.email ;
//if(emailArray[i].Queue.name == 'CSO Audit Team')
//Auditemail = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Call Transfer Instructions')
AuditemailCallTransfer = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit General Information')
AuditemailGeneral = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Site Coordinators')
AuditemailSite = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit DataBase')
AuditemailDataBase = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Installation')
AuditemailInstallation = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Maintenance & Troubleshooting')
AuditemailMaintenance = emailArray[i].Queue.email ; 
if(emailArray[i].Queue.name == 'CSO Audit Operation')
AuditemailOperation = emailArray[i].Queue.email ; 

if(emailArray[i].Queue.name == 'CSO Content Audit Team')
ContentEmail = emailArray[i].Queue.email ; 
}

  sol.CSO_Quality_Team_Email__c=Qualityemail;
  sol.Content_Audit_Team_Email__c=ContentEmail;


  if(sol.Categorization__c=='Call Transfer Instructions')
  sol.Audit_Team_Email__c=AuditemailCallTransfer;
  else if(sol.Categorization__c=='General Information')
  sol.Audit_Team_Email__c=AuditemailGeneral;
  else if(sol.Categorization__c=='Site Coordinators')
  sol.Audit_Team_Email__c=AuditemailSite;
  else if(sol.Categorization__c=='Database')
  sol.Audit_Team_Email__c=AuditemailDataBase;
  else if(sol.Categorization__c=='Installation')
  sol.Audit_Team_Email__c=AuditemailInstallation;
  else if(sol.Categorization__c=='Maintenance & Troubleshooting')
  sol.Audit_Team_Email__c=AuditemailMaintenance;
  else if(sol.Categorization__c=='Operation')
  sol.Audit_Team_Email__c=AuditemailOperation;
  }
 
  
  // to set content approval date
  //if(sol.Record_Type_Name__c == 'Solution CSO Non-Technical' && sol.Content_Review_Approval_Date__C  ==null && sol.status=='Approved')
 // sol.Content_Review_Approval_Date__c=System.Today();
  
  if(Trigger.Isupdate){
  if(sol.Status=='Audit')
  sol.Approver_Name__c='CSO Audit Team';
   //update the status of content review before audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Content Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Final Review' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') && sol.Audit_Date_CSO__c==null && sol.Content_Review_Status__c==null){
  sol.Content_Review_Status__c= sol.status;
  sol.Approver_Name__c='CSO Quality Team';}
     //update the status of content review after audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Content Review' &&
    (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled')
     && sol.Audit_Date_CSO__c!=null && sol.Content_Review_Audit_Status__c==null){
  sol.Content_Review_Audit_Status__c= sol.status;
 // sol.Audit_Date_CSO__c=null;
  }
  //update the status of Technical review before audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Final Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled')  && sol.Audit_Date_CSO__c==null && sol.Final_Review_Status__c==null){
  sol.Final_Review_Status__c= sol.status;
 // sol.Content_Review_Approval_Date__c=System.Today();
  }
  
  //to update the approval date
  if (System.Trigger.NewMap.get(sol.Id).Status =='Approved' && System.Trigger.OldMap.get(sol.Id).Status!='Approved')
  sol.Content_Review_Approval_Date__c=System.Today();
  
  
  
  // change
    //update the status of Technical review before audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Final Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') 
){

  //sol.Content_Review_Approval_Date__c=System.Today();
  }
       if(sol.Record_Type_Name__c == 'Solution CSO Non-Technical' && System.Trigger.oldMap.get(sol.Id).Status=='Content Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Final Review' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') && sol.Audit_Date_CSO__c==null &&
           sol.Content_Review_Approved_By__c==null){
           sol.Content_Review_Approved_By__c = Userinfo.getUserId();
          ////////////////// sol.approver__c=Userinfo.getUserId();
           }
       //update the content reviewed approved or rejected by after audit
       if(sol.Record_Type_Name__c == 'Solution CSO Non-Technical' && System.Trigger.oldMap.get(sol.Id).Status=='Content Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') && sol.Audit_Date_CSO__c!=null &&
           sol.Content_Review_Audit_Approved_By__c==null){
           sol.Content_Review_Audit_Approved_By__c = Userinfo.getUserId(); 
          /////////////// sol.approver__c=Userinfo.getUserId();
           }
  //update the technical reviewed approved or rejected by before audit
       if(sol.Record_Type_Name__c == 'Solution CSO Non-Technical' && System.Trigger.oldMap.get(sol.Id).Status=='Final Review'  &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled')  && sol.Audit_Date_CSO__c==null &&
           sol.Final_Review_Approved_By__c==null){
           sol.Final_Review_Approved_By__c = Userinfo.getUserId();
           //////////////sol.approver__c=Userinfo.getUserId();
           }
  }
   //Commented by Kapil for HPQC 2425.
   //if(sol.Supported_Product__c!=null)
   //  productArray.add(sol.Supported_Product__c);
   //Added by Kapil for HPQC 2425.
   if(sol.Supported_Products__c!=null)
     productArray.add(sol.Supported_Products__c);
  }// end of for

  if(userId.size()>0){
  users=[Select Id,ManagerId,email from user where Id in:userId];
      for(Solution solutions: Trigger.new){
        for(integer i=0;i<users.size();i++){
           if(solutions.OwnerId == users[i].Id)
           solutions.Submitter_Manager__c=users[i].ManagerId;
          //  User[] Approver =[Select name,id,Managerid from user where id=:users[i].ManagerId];
            //solutions.Approver_Manager__c=Approver[i].Managerid;
             
        }
      }//end of for
      //string Approver; 
               
  }//end of if
 // Supported_Products__c added in where Clause by Kapil
 System.Debug('Supported Products Id : '+productArray);
 if(productArray.size()>0){
  //skills=[Select Contact_Name__c,Contact_Email__C,Supported_Product__c,Supported_Products__c,Primary_Secondary__c,Contact_EID__c from Skills2__c 
  //where  (Primary_Secondary__c='Primary' or Primary_Secondary__c='Secondary') and Supported_Product__c in:productArray order by Primary_Secondary__c]; 
  skills=[Select Id, Primary__c, Secondary__c, Primary__r.Email,Primary__r.Name, Primary__r.Employee_Number__c ,Secondary__r.Name,Secondary__r.Employee_Number__c, Secondary__r.Email from Supported_Products__c 
  where Id in:productArray]; 
 }

 for(Solution sol: Trigger.new){
    integer flagPrime=0;
    String primaryEmail,primaryContactName,secEmail,secContactName,secContactEID,primaryContactEID;

       for(integer i=0;i<skills.size();i++){    
             if(skills[i].Id==sol.Supported_Products__c)
               {
                System.Debug('skills[i].Secondary__c : '+skills[i].Secondary__c);
                if(skills[i].Secondary__c == null){
                   System.Debug('Inside If 1');
                   sol.Secondary__c = NULL;
                   secEmail = '';                 
                   secContactName = '';                 
                   secContactEID='';
                     
                }else {
                  System.Debug('Inside else 1');
                  //sol.Secondary__c = skills[i].Secondary__r.Name;
                  Sol.Secondary_Email__c =   skills[i].Secondary__r.Email;             
                  secEmail = skills[i].Secondary__r.Email;                 
                  secContactName = skills[i].Secondary__r.Name;                 
                  secContactEID=skills[i].Secondary__r.Employee_Number__c;
                }
                
                if(skills[i].Primary__c == null){
                  System.Debug('Inside If 2');
                  sol.Primary__c = '';
                  System.debug('sol.Primary__c : '+sol.Primary__c);
                  primaryEmail = '';
                  primaryContactName = '';
                  primaryContactEID='';
                  
                }else {
                  System.Debug('Inside else 2');
                  //sol.Primary__c = skills[i].Primary__r.Name;
                  Sol.primary_Email__c =   skills[i].primary__r.Email;  
                  primaryEmail = skills[i].Primary__r.Email;
                  primaryContactName = skills[i].Primary__r.Name;
                  primaryContactEID=skills[i].Primary__r.Employee_Number__c;
                  //Added as part of HPQC 2425 - End 
                  /*
                  for(integer k=0;k<users.size();k++){
                     //if(users[k].email==skills[i].Contact_Email__C){
                     if(users[k].email==skills[i].Secondary__r.Email){
                         flagPrime=1;                                        
                     }
                   //}// end of for
                  }// for primary
                  */  
                 for(integer k=0;k<users.size();k++){
                     if(users[k].email==skills[i].Primary__r.Email){
                         flagPrime=1;                                        
                     }
                  }// for primary
              }
            }
           /* if(skills[i].Primary__c != NULL && skills[i].Primary__r.Email != NULL){
             System.Debug('Inside If 3');
             sol.Current_Approver__c=primaryContactName;
             sol.Current_Approver_EID__c=primaryContactEID;
             sol.Product_Support_Engineer_Email__c=primaryEmail;
            }else {
             System.Debug('Inside else 3');
             sol.Current_Approver__c=secContactName;
             sol.Current_Approver_EID__c=secContactEID;
             sol.Product_Support_Engineer_Email__c=secEmail;
            } */
            
            if( flagPrime==1)  {        
              sol.Current_Approver__c=secContactName;
              sol.Current_Approver_EID__c=secContactEID;
              sol.Product_Support_Engineer_Email__c=secEmail;
          }
          if( flagPrime==0 ) {  
              
              if(primaryEmail!=null)  {    
                  sol.Current_Approver__c=primaryContactName;
                  sol.Current_Approver_EID__c=primaryContactEID;
                  sol.Product_Support_Engineer_Email__c=primaryEmail;
              }
              else {
                  sol.Current_Approver__c=secContactName;
                  sol.Current_Approver_EID__c=secContactEID;
                  sol.Product_Support_Engineer_Email__c=secEmail;
              }
            
           }
       }// end of for    

  if(Trigger.Isupdate){
   //update the status of standard review before audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Standards Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Technical Review' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') && sol.Audit_Date_CSO__c==null && sol.Standards_Review_Status__c==null)
  sol.Standards_Review_Status__c= sol.status;


//update the status of Technical review before audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Technical Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled')  && sol.Audit_Date_CSO__c==null && sol.Technical_Review_Status__c==null){
  sol.Technical_Review_Status__c= sol.status;
    //sol.Content_Review_Approval_Date__c=System.Today();
    }


///change


//update the status of Technical review before audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Technical Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') 
){
    //sol.Content_Review_Approval_Date__c=System.Today();
    }
 //update the status of Technical review after audit
  if(System.Trigger.oldMap.get(sol.Id).Status=='Technical Review' &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled')  && sol.Audit_Date_CSO__c!=null && sol.Technical_Review_Audit_Status__c==null){
  sol.Technical_Review_Audit_Status__c= sol.status;
  //sol.Audit_Date_CSO__c=null;
  }

  //update the standard reviews approved or rejected by before audit
       if(sol.Record_Type_Name__c == 'Solution GTO Technical'  && System.Trigger.oldMap.get(sol.Id).Status=='Standards Review' && (System.Trigger.NewMap.get(sol.Id).Status =='Technical Review' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') && sol.Audit_Date_CSO__c==null &&
           sol.Standards_Review_Approved_By__c==null){
           sol.Standards_Review_Approved_By__c = Userinfo.getUserId();
          //////////// sol.approver__c=Userinfo.getUserId();
           }
       

  //update the technical reviewed approved or rejected by before audit
       if(sol.Record_Type_Name__c == 'Solution GTO Technical' && System.Trigger.oldMap.get(sol.Id).Status=='Technical Review'  &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled') && sol.Audit_Date_CSO__c==null &&
           sol.Technical_Review_Approved_By__c==null)
           sol.Technical_Review_Approved_By__c = Userinfo.getUserId();
    //update the technical reviewed approved or rejected by after audit
       if(sol.Record_Type_Name__c == 'Solution GTO Technical' && System.Trigger.oldMap.get(sol.Id).Status=='Technical Review'  &&  (System.Trigger.NewMap.get(sol.Id).Status =='Approved' || System.Trigger.NewMap.get(sol.Id).Status =='Rejected' || System.Trigger.NewMap.get(sol.Id).Status =='Cancelled')  && sol.Audit_Date_CSO__c!=null &&
           sol.Technical_Review_Audit_Approved_By__c==null){
           sol.Technical_Review_Audit_Approved_By__c = Userinfo.getUserId();
          //////////// sol.approver__c=Userinfo.getUserId();
           }

       }
                if(sol.status=='Approved' &&( sol.Final_Review_Status__c=='Approved'|| sol.Technical_Review_Status__c=='Approved' ) && sol.Content_Review_Approval_Date__C!=null )
              {     // to set the audit date
                    if(sol.Audit_Frequency__c=='Weekly')
                    {
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+7;
                    }
                    else if(sol.Audit_Frequency__c=='Bi-weekly')
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+14;
                    else if(sol.Audit_Frequency__c=='Monthly')
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+30;
                    else if(sol.Audit_Frequency__c=='Quarterly')
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+90;
                    else if(sol.Audit_Frequency__c=='Semi-Annual')
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+180;
                    else if(sol.Audit_Frequency__c=='Annually')
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+365;
                    else if(sol.Audit_Frequency__c=='Biennal')
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+730;    
                    else if(sol.Audit_Frequency__c=='18 Months')
                    sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+540;                    
                    if(sol.expiration_date__c  !=null)
                    sol.Audit_Date_CSO__c=sol.expiration_date__c;
              }
                                        
        /// to take care of data from data migrations             
              if(Trigger.isInsert){   
              
            if(  sol.status=='Approved' || sol.status=='Audit'){
            // if legacy approver is not present
                if(sol.Legacy_Approved_By__c==null)
                sol.approver__c=sfdcAdminId;
                if(sol.LEGACY_SOLUTION_APPROVAL_DATE__C ==null)
                sol.Content_Review_Approval_Date__C=System.Today();
                if(sol.Record_Type_Name__c == 'Solution GTO Technical' )      
                 sol.Technical_Review_Status__c='Approved';     
                 else
                 sol.Final_Review_Status__c='Approved';     
            }              
              
                         
                      if(sol.LEGACY_SOLUTION_APPROVAL_DATE__C !=null){                                            
                          String sdt= String.valueof(sol.LEGACY_SOLUTION_APPROVAL_DATE__C);
                          date dt=Date.valueof(sdt);
                          sol.Content_Review_Approval_Date__C=dt;
                      }
                     if(sol.status=='Approved'  )                    {     // to set the audit date                                  
                     if( sol.Content_Review_Approval_Date__C!=null){                      
                            if(sol.Audit_Frequency__c=='Weekly')                            {
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+7;
                            }
                            else if(sol.Audit_Frequency__c=='Bi-weekly')
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+14;
                            else if(sol.Audit_Frequency__c=='Monthly')
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+30;
                            else if(sol.Audit_Frequency__c=='Quarterly')
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+90;
                            else if(sol.Audit_Frequency__c=='Semi-Annual')
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+180;
                            else if(sol.Audit_Frequency__c=='Annually')
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+365;
                            else if(sol.Audit_Frequency__c=='Biennal')
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+730;    
                            else if(sol.Audit_Frequency__c=='18 Months')
                            sol.Audit_Date_CSO__c=sol.Content_Review_Approval_Date__C+540;                    
                            if(sol.expiration_date__c  !=null)
                            sol.Audit_Date_CSO__c=sol.expiration_date__c;
                            
                            }
                      }                         
              }                                        
  } 
 // Logic for approver field for legacy data modified on april 27,2011 
  if(approvers.size()>0){
  //getting the users having the name in legacy approver list
      try{
      userApprovers=[Select Id, name from user where name in :approvers];
    if(userapprovers.size()>0){
          for(Solution sol: Trigger.new){
              if(Trigger.isInsert){
                if(sol.Legacy_Approved_By__c !=null  && ( sol.status=='Approved'  ||  sol.status=='Audit')){
                   for(integer i=0;i<userApprovers.size();i++){
                     if(sol.Legacy_Approved_By__c==userApprovers[i].name)
                     sol.approver__C=userApprovers[i].Id;
                   }
                   //if no user records are found populate with sfdcAdmin Id
                   if(sol.approver__c==null)
                   sol.approver__c=sfdcAdminId;
                }
              }// end of isInsert
         } // end of for
     }// end of if    
      }// end of try
      catch(Exception e){}
  }// end of if
// Techincal Audit commented  - Start
 //}
// Techincal Audit commented - End     
}// end of trigger