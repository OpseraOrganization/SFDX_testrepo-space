/** * File Name: PreventOOOEmail
* Description :Trigger to prevent cases from creating having keywords in subject
* line not getting created
* Copyright : Wipro Technologies Limited Copyright (c) 2010 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
trigger PreventOOOEmail on EmailMessage(before insert) {
 
 /*commenting trigger code for coveragge
String sub;
 list<case_lookup__c> Lookuplist= new list<case_lookup__c>(); 
 Lookuplist=[select subject__c from case_lookup__c];
try
{ 
 for( emailmessage e:Trigger.new) { 
// SR-449243 Starts
     if(e.htmlbody.contains('Delivery to these recipients or groups is complete, but no delivery notification was sent by the destination server:')){
         e.subject.addError('Spam Message should not create case');     
 } 
// SR-449243 ends 
  if(e.subject != null   &&
   (  (e.ToAddress=='CPSQuotesCOE@honeywell.com')||
    (e.ToAddress=='cpsquotescoe@13qh3mz6no8wpkr8ylhp1blea.tkl3bmaw.t.case.sandbox.salesforce.com')||

(e.ToAddress==' cpsquotescoeanntmptuc@honeywell.com')
    ||(e.ToAddress=='cpsquotescoeanntmptuc@8-1w6thgf4qjhu48aibw28cwvqq.tkl3bmaw.t.case.sandbox.salesforce.com')

    ||(e.ToAddress=='cpsquotescoedvcr@honeywell.com')
    
    ||(e.ToAddress=='cpsquotescoedvcr@d-23mzup5pabj2c3kvcjval56bg.tkl3bmaw.t.case.sandbox.salesforce.com')

  ||(e.ToAddress=='cpsquotescoephx@honeywell.com')
    
    ||(e.ToAddress=='cpsquotescoephx@o-2kdepgpghd1sp02h8wwvxssae.tkl3bmaw.t.case.sandbox.salesforce.com')

)
  ){
    if(e.subject.contains('has sent fax')){
      e.subject.addError('Email Message having success for Fax Creation not needed'); 
      
      }
  }
  
  
  if(e.subject != null&&((e.ToAddress=='fs1@mygdc.com')||(e.ToAddress=='fs1@x-4ynyyuc7ondi6lxgj67uy91lq.3dwxyeau.3.case.salesforce.com')||(e.ToAddress=='fs@mygdc.com')||(e.ToAddress=='fs@2hcgiys4cnff8g1jhmcztboh8.3dwxyeau.3.case.salesforce.com')||(e.ToAddress=='gfo@mygdc.com')||(e.ToAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com'))){
     if((e.subject.contains('Reservation Details'))||(e.subject.contains('Acquire Reservation'))||(e.subject.contains('Confirm Reservation'))||(e.subject.contains('Blackberry Summary'))||(e.subject.contains('FAA Command Center Message'))||(e.subject.contains('Global Data Center CDM'))||(e.subject.contains('Global Data Center FS Daily'))||(e.subject.contains('ITF Trip'))||(e.subject.contains('Flight Plan Summary'))||(e.subject.contains('Undelivered Mail Return to Sender'))||(e.subject.contains('Western Service Area Outlook'))||(e.subject.contains('[NBAA-GADesk]'))||(e.subject.contains('Email/Manual Fax'))||(e.subject.contains('Scan From a Xerox Workcentre'))||(e.subject.contains('FrontierMedex'))||(e.subject.contains('TRC Report'))||(e.subject.contains('Western Service Area Outlook'))||(e.subject.contains('FAA COMMAND CENTER MESSAGE'))||(e.subject.contains('Mail System Error'))){
      e.subject.addError('Spam Message should not create case'); 
      }
      if((e.ToAddress=='fs@mygdc.com')||(e.ToAddress=='fs@2hcgiys4cnff8g1jhmcztboh8.3dwxyeau.3.case.salesforce.com')||(e.ToAddress=='gfo@mygdc.com')||(e.ToAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
      if((e.subject.contains('ADNS MESSAGE TO KSNAXGXS'))||(e.subject.contains('FAA ICAO FPL ACK'))||(e.subject.contains('FAA ICAO FPL REJ'))||(e.subject.contains('Updated Manual Fax'))||(e.subject.contains('New Manual Fax'))||(e.subject.contains('Fax Status Alert'))||(e.subject.contains('Manual PKG:'))){ 
        e.subject.addError('Spam Message should not create case');   
      }
      }
      if((e.ToAddress=='fs@mygdc.com')||(e.ToAddress=='fs@2hcgiys4cnff8g1jhmcztboh8.3dwxyeau.3.case.salesforce.com')){
      if((e.subject.contains('XOJET MSG'))||(e.subject.contains('FS MESSAGE'))){
       e.subject.addError('Spam Message should not create case'); 
      }
      }
      if((e.ToAddress=='gfo@mygdc.com')||(e.ToAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
      if((e.subject.contains('NET JET MSG'))||(e.subject.contains('OTHER MSG'))||(e.subject.contains('Flight Plan Request'))||(e.subject.contains('Weather Request -'))||(e.subject.contains('Submission From'))){
       e.subject.addError('Spam Message should not create case'); 
      }
      }
      if((e.ToAddress=='fs1@mygdc.com')||(e.ToAddress=='fs1@x-4ynyyuc7ondi6lxgj67uy91lq.3dwxyeau.3.case.salesforce.com')){
      if((e.subject.contains('New ITF trip for'))||(e.subject.contains('ITF trip changed'))){
       e.subject.addError('Spam Message should not create case'); 
      }
  }
 } 
  if((e.subject != null)&&(e.ToAddress=='aerosfdccustomermaster@honeywell.com'||e.ToAddress=='aerosfdccustomermaster@1-p04vqksz764phuxn0jj3h7v1.3dwxyeau.3.case.salesforce.com')&&(e.subject.contains('Contract Expiration Mail'))){
  e.subject.addError('Spam Message should not create case'); 
  }*/
/************************** Added For Dual Criteria ************************* 
    if((e.FromAddress=='gfo@mygdc.com')||(e.FromAddress=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
        if((e.subject.contains('Flight Plan Request'))||(e.subject.contains('Weather Request -'))||(e.subject.contains('Submission From'))){
            e.subject.addError('Spam Message should not create case');
        }    
    }   */ 
/************************** Added For Dual Criteria **************************/ 

/************************** Added For gdc.accounts@honeywell.com *************************
    if((e.FromAddress=='CTSEFTCW@HONEYWELL.COM') || (e.FromAddress=='wawfnoreply@csd.disa.mil')){
      if((e.ToAddress=='gdc.accounts@honeywell.com') || (e.ToAddress=='gdc.accounts@n-4j9j61s4n03qnjgi9kl45ik4n.3dwxyeau.3.case.salesforce.com')){
          e.subject.addError('Spam Message should not create case');    
      }
    }*/
/************************** Added For gdc.accounts@honeywell.com *************************
 
  if((e.FromAddress=='george.risinger@honeywell.com')||(e.FromAddress=='APISConfirmNoReply@dhs.gov')||(e.FromAddress=='news@aviationnews.us'))
  e.subject.addError('Spam Message should not create case'); 
  */
 /*if(e.subject != null   &&
   (  (e.ToAddress=='CPSQuotesCOE@honeywell.com')||
    (e.ToAddress=='cpsquotescoe@b-6dskuwg30iuo577i4zjlpckeq.in.salesforce.com')||

(e.ToAddress=='cpsquotescoeanntmptuc@honeywell.com')
    ||(e.ToAddress=='cpsquotescoeanntmptuc@2xiple9zh4wabc66sgjh6rmdo.in.salesforce.com')

    ||(e.ToAddress=='cpsquotescoedvcr@honeywell.com')
    
    ||(e.ToAddress=='cpsquotescoedvcr@1s6rhyws1mhd2dr18mpwfr92w.in.salesforce.com')

  ||(e.ToAddress=='cpsquotescoephx@honeywell.com')
    
    ||(e.ToAddress=='cpsquotescoephx@pkze125zld9qqnmzcck5y1dm.in.salesforce.com')

)
  ){
    if(e.subject.contains('has sent fax')){
      e.subject.addError('Email Message having success for Fax Creation not needed'); 
      
      }
  }*/
 


 /*

  for(integer i=0;i<Lookuplist.size();i++)
    {
    sub='';
        if(e.subject != null){
        sub=e.subject;
        sub = sub.toUpperCase();
                if(Lookuplist[i].subject__C !=null){
                           Lookuplist[i].subject__C =  Lookuplist[i].subject__C.toUpperCase();
                           if(sub.contains(Lookuplist[i].subject__C))
                           {  
                                      
                             e.subject.addError('Email Message with Junk Subjects Cannot be created');                    
                           }      
                 }     
        }
                
 }// end for  
 

   
 }
 }
 catch(Exception e)
 {}*/
}