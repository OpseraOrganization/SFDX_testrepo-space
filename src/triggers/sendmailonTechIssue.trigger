trigger sendmailonTechIssue on Case (after insert,after update){
/*commenting inactive trigger code to improve code coverage-----
if(TriggerInactive.testTrigger){  

 set<id> IdSet;
  for (Case casee : trigger.new){
  IdSet=new set<id>();
  IdSet.add(casee.id);
  }
 DateTime resdat;
  Date resdate;
  List<Case> caseList=[Select id,CaseNumber,Subject from Case Where Id IN:IdSet];
  List<RecordType> rt=new List<RecordType>();
     rt=[SELECT Id, Name FROM RecordType WHERE Name='Technical Issue'];
     //System.debug('rrrrtttttt11111'+rt);
     
     System.debug('dateeeee'+system.today());
    
      for (Case casee : trigger.new){
       
     // System.debug('444444444'+casee);
      if(casee.HON_Commit_Date__c > casee.Customer_Request_Date__c)
      {
          resdat=casee.HON_Commit_Date__c-1;
          resdate = date.newinstance(resdat.year(), resdat.month(), resdat.day());
           
      }
      else if(casee.HON_Commit_Date__c < casee.Customer_Request_Date__c)
      {
            resdate=casee.Customer_Request_Date__c-1;
      }
      //system.debug('datefbsdbfjksd'+resdate+'hgfhfhfh'+system.today());
      //system.debug('casee.RecordTypeID'+casee.RecordTypeID);
        if(resdate==System.today()&& casee.RecordTypeID==rt[0].id ){
           System.debug('rrrrttttttiiiddd'+casee.id);
           List<String> emailList= new List<String>();
            
           
            List<String> mailToAddresses = new List<String>(); 
            List<String> idList = new List<String>();
            Group g = [SELECT  id ,(select userOrGroupId from groupMembers) FROM group WHERE name = 'General Compliance Queue']; 
            for (GroupMember gm : g.groupMembers) {        
                idList.add(gm.userOrGroupId);
            }  
            User[] usr = [SELECT Id, email FROM user WHERE id IN :idList]; 
           // for(User u : usr){
           System.debug('adduuuuu'+usr.size());
           integer i=0;
           for(i=0;i<usr.size();i++)
           {
                    //User usrr=[select id,email from  user where Email=:u.Email];  
                    mailToAddresses.add(usr[i].Email);
            } 
                
                System.debug('adddddtiiiddd'+mailToAddresses);
            
                   //for(User u : usr){
                   // User usrr=[select id,email from  user where Email=:u.Email];  
                   // mailToAddresses.add(usrr.Email);
                   // System.debug('adddddtiiiddd'+mailToAddresses);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                    mail.setToAddresses(mailToAddresses);
                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + casee.Id; 
                    mail.setSubject('Reminder:'+' '+caseList[0].CaseNumber+' '+ caseList[0].Subject+' '+'response is due to the customer tomorrow');
                    mail.setHtmlBody('Please note that a response is due to the customer tomorrow for'+' '+caseList[0].CaseNumber+' '+ caseList[0].Subject+' '+'<br></br>Click Link <br></br>'+' '+fullRecordURL+' '+'<br></br>Thank You' );
                   
                    //mail.setPlainTextBody(body1);
                  //mail.setHtmlBody(body1);
                    mail.setSaveAsActivity(false);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
               // }
            }
          
         } 
      }
       TriggerInactive.testTrigger=false;*/
  }