/** * File Name: Case_PreventCreation
* Description :Trigger to prevent cases from creating having same subject
* more than 4 times on same day from same sender
* Copyright : Wipro Technologies Limited Copyright (c) 2010 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
trigger Case_PreventCreation on Case (before insert) {
/*commenting inactive trigger code to improve code coverage-----
String userName;
userName=Userinfo.getUserName();
 if(userName!='SFDC Admin'){    

 for( case c :Trigger.new){
 
 System.debug('$$$$$$$$$'+c.SuppliedEmail );
 
 
 //variable declaration
  case[] check;
  //selecting the email cases only
  if(c.origin.contains('Email')){
  c.case_subject__c=c.subject;
      Date dt=System.today();
      DateTime tm = System.now();
       System.debug('$$$$$$$$$'+tm );
       System.debug('$$$$$$$$$'+c.createddate );
              try{
              //checking whether already cases has been created in the system on the same day with same subject
                 check = [select ID, CreatedDate, subject from Case where createddate>=:dt and
                 case_subject__c = :c.case_subject__c  and SuppliedEmail = :c.SuppliedEmail  and isclosed = false 
                 order by createddate asc ];
                 }
              catch(Exception e){}
                  if(c.Subject != null) {  
                    //We have a subject, proceed.
                    if(c.subject.contains('[ ref:')){
                      //No Errors.  Email should be attached to the case.
                    }else{
                          System.debug('In else'+ check.size());
                          if(check.size() > 2){
                             c.addError('Automatic email loop has been terminated');
                              //Loop Was Killed.
                            }else{
                              //New Case should be created now!       
                           }
                      }//e nd of else
                    }                  
          }
}// end of for
}*/
}// end of trigger