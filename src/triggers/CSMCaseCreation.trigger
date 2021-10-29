//Trigger to create a case automatically when a feed back is passive or detractor
// Owner of the case will the owner of the Account
trigger CSMCaseCreation on Feedback__c (after insert,after update) {
//Declaring variables
List<Case> caselst = new List<Case>();
List<ID> acclst = new List<ID>();
List<ID> acclst1 = new List<ID>();
Map<ID,Map<Id,Account>> FeedMap = new Map<ID,Map<Id,Account>>();
//INC000008436952
String htmlBody='';
string conname;
string fbname;
string fbsatis2;
string fbsatis4;
string fbsatis6;
string fbhon;
string fbcustom;
// INC000008843002 - Start 
List<String> lstAttribute = new List<String>();
Map<id,List<string>> mapLstAtt = new Map<id,List<string>>();

// INC000008843002 - End
    for(Feedback__c fb : Trigger.New){
        //Checking condition if NPS classification is Detractor or Passive
        //if(fb.recordtypeid == label.Feedback_Recordtype && (fb.NPS_Classification__c=='Passive' ||fb.NPS_Classification__c=='Detractor') 
        //&& (Trigger.IsInsert|| (Trigger.isUpdate && fb.NPS_Classification__c != System.Trigger.OldMap.get(fb.Id).NPS_Classification__c )))
        //{
            if(fb.account__c != null){
            acclst.add(fb.account__c);
        }
        //INC000008436952 ---changes start
        if(fb.recordtypeid == label.ATR_VOC_Record_Type 
        && ((Trigger.IsInsert && fb.Airbus_Rating__c == 'Red - Very Dissatisfied')
        || (Trigger.isUpdate && fb.Airbus_Rating__c != System.Trigger.OldMap.get(fb.Id).Airbus_Rating__c && fb.Airbus_Rating__c == 'Red - Very Dissatisfied'))
        )
        {
            if(fb.account__c != null)           
            acclst1.add(fb.account__c);
            
            fbname = fb.Name;
            conname = fb.Contact_Name__c;
            fbsatis2=fb.Level_Of_Satisfaction2__c;
            fbsatis4=fb.Level_Of_Satisfaction4__c;
            fbsatis6=fb.Level_Of_Satisfaction6__c;
            fbhon=fb.HON_Knows_My_Business__c;
            fbcustom=fb.Customer_Overall_Satisfaction_Metric__c;
            
        }
        //INC000008436952 ---changes end
        lstAttribute = new List<String>();
        ///// INC000008843002 - Start 
        if(fb.recordtypeid == label.ATR_VOC_Record_Type )
        {
            System.debug('inside1');
            if(fb.Metric_for_Delivery__c!=null && fb.Customer_Rating_For_Delivery__c != null )
            {
             if(fb.Customer_Rating_For_Delivery__c.contains('Red') || fb.Customer_Rating_For_Delivery__c.contains('RED'))
                {
                //Service_Request__c SRrec1 = new Service_Request__c(recordtypeid=Label.SR_RecordtypeID,VOC_Card_Numb__c=fb.id,status__c='Open',
                  //  Atr__C='Delivery',ownerid=); 
            System.debug('inside2');
                  lstAttribute.add('Delivery');  
                  }
            }
            if(fb.Metric_for_Quality__c!=null && fb.Quality_Metric_IND__c != null)
            {
             if(fb.Quality_Metric_IND__c.contains('Red'))
                {
                lstAttribute.add('Quality');
                }
            }
            if(fb.Metric_for_Reliability__c!=null && fb.Reliability_Metric_IND__c != null)
            {
            if(fb.Reliability_Metric_IND__c.contains('Red'))
            {
            lstAttribute.add('Reliability');
            }
            }
            if(fb.Metric_for_Responsiveness__c!=null &&  fb.Customer_Rating_For_Responsiveness__c != null )   
            {
            if(fb.Customer_Rating_For_Responsiveness__c.contains('Red')|| fb.Customer_Rating_For_Responsiveness__c.contains('RED'))
            {
            lstAttribute.add('Responsiveness');
            }
            }
            if(fb.Metric_for_Service_Support__c!=null && fb.Service_Support_Metric_IND__c != null)
            {
            if(fb.Service_Support_Metric_IND__c.contains('Red'))
            {
            lstAttribute.add('Service/Support');
            }
            }
            if(fb.Metric_for_Value__c!=null && fb.Value_Metric_IND__c != null)  
            {
            if(fb.Value_Metric_IND__c.contains('Red'))
            {
            lstAttribute.add('Value');
            }
            }
            if(fb.Warranty__c!=null &&  fb.Warranty_IND__c != null) 
            {
            if(fb.Warranty_IND__c.contains('Red'))
            {
            lstAttribute.add('Warranty');
            }
            }
            if(fb.Repair_Performance__c!=null && fb.Repair_Performance_IND__c != null)  
            {
            if(fb.Repair_Performance_IND__c.contains('Red'))
            {
            lstAttribute.add('Repairs Delivery');
            }
            }
            if(fb.Spares_Performance__c!=null && fb.Spares_Performance_IND__c != null)
            {
            if(fb.Spares_Performance_IND__c.contains('Red'))
            {
            lstAttribute.add('Spares Delivery');
            }
            }
            if( (fb.Recommend_HON__c!=null && fb.Recommend_HON_IND__c != null && fb.Recommend_HON_IND__c.contains('Red')) ||             
            (fb.Cost__c!=null && fb.Cost_IND__c != null && fb.Cost_IND__c.contains('Red')) ||        
            (fb.Overall_Perception__c!=null && fb.Overall_Perception_IND__c != null && fb.Overall_Perception_IND__c.contains('Red')) ||             
            (fb.Communication__c!=null && fb.Communication_IND__c != null && fb.Communication_IND__c.contains('Red')) ||       
            (fb.Documentation__c!=null && fb.Documentation_IND__c != null && fb.Documentation_IND__c.contains('Red')) ||               
            (fb.Global_Technical_Ops_Support__c!=null && fb.Global_Technical_Ops_Support_IND__c != null && 
            fb.Global_Technical_Ops_Support_IND__c.contains('Red')) ||          
            (fb.Flexibility__c!=null && fb.Flexibility_IND__c != null && fb.Flexibility_IND__c.contains('Red')) )             
            {
            lstAttribute.add('Other');
            }
            mapLstAtt.put(fb.id,lstAttribute);
        }
        ///// INC000008843002 - End
    }    
    Map<Id,Account> AccMap = new Map<ID,Account>([Select id, ownerid from account where id in : acclst]);    
    for(Feedback__c fb : Trigger.New){
        FeedMap.put(fb.id,Accmap);
    }
    List<Service_Request__c> lstSRrec1 = new List<Service_Request__c>();
    for(Feedback__c fb : Trigger.New){
        //if(acclst.size() > 0){
        //Checking condition if NPS classification is Detractor or Passive
        if(fb.recordtypeid == label.Feedback_Recordtype && (fb.NPS_Classification__c=='Passive' ||fb.NPS_Classification__c=='Detractor') 
        && (Trigger.IsInsert|| (Trigger.isUpdate && fb.NPS_Classification__c != System.Trigger.OldMap.get(fb.Id).NPS_Classification__c )))
        {
            Case cs = new case();
            cs.Case_Subject__c = fb.Name +'- NPS Classification';
            cs.Origin='Email';
            cs.Status='Open';
            cs.recordtypeid=label.Case_Feedback_Recordtype;
            cs.Description=fb.Comments__c;
            cs.type='Net Promoter Score';
            cs.CSM_Feedback_Case__c=True;
            cs.CSM_Feedback__c = fb.Id;
            cs.AccountID = fb.Account__c;
            cs.ContactID = fb.Contact__c;
            cs.ownerid = Accmap.get(fb.account__c).OwnerID;
            caselst.add(cs);
        }
        ///  INC000008843002 - Start
        System.debug(fb.recordtypeid);
        System.debug(label.ATR_VOC_Record_Type);
        System.debug(Accmap.get(fb.account__c));
        if(trigger.isupdate && fb.recordtypeid == label.ATR_VOC_Record_Type && fb.ggp_number__c!=null){
        if(trigger.oldMap.get(fb.id).ggp_number__c != fb.ggp_number__c )// && trigger.isInsert)
        {  
            Service_Request__c SRrec1 = new Service_Request__c(recordtypeid=Label.SR_RecordtypeID,VOC_Card_Numb__c=fb.id,status__c='Open',
                   GGP_Number__c=fb.GGP_Number__c, Contact_Name__c=fb.Contact__c);         
            Service_Request__c tempSRrec = new Service_Request__c();
            for(String strAtt : mapLstAtt.get(fb.id))
            {                
                tempSRrec = new Service_Request__c();
                tempSRrec = SRrec1.clone();
                if(fb.account__c!=null && Accmap.get(fb.account__c)!=null)
                {
                    System.debug('fb.account__c::'+fb.account__c);
                    tempSRrec.Account_Name__c = fb.account__c;
                    tempSRrec.ownerid = Accmap.get(fb.account__c).OwnerID;
                }
                tempSRrec.atr__c = strAtt;
                lstSRrec1.add(tempSRrec );    
            }
        }
        }
        ///  INC000008843002 - End
    }   
    //Inserting case list
    if(caselst.size() > 0)
    insert caselst;
    
    //INC000008436952 -- sending email to account CBM 
    List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
    if(acclst1.size()>0)
    {
        atmlist = [SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE AccountId =:acclst1 AND TeamMemberRole='Customer Business Manager (CBM)'];
        List<Messaging.SingleEmailMessage> UFRbulkEmails = new List<Messaging.SingleEmailMessage>();
            
        if(atmlist.size()>0)
        {
                
            for(AccountTeamMember atm:atmlist)
            {
                   htmlBody='<html><center ><table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" ><tr valign="top" ><td  style=" vertical-align:top; height:60; text-align:right; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;"><img id="r1sp1" bLabel="headerImage" border="0" bEditID="r1sp1" src="https://c.na1.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D560000008mxZ" ></img></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent1; bEditID:r2st1;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;"><table height="400" width="550" cellpadding="5" border="0" cellspacing="5" ><tr height="400" valign="top" ><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" >'+ atm.account.name +'    has indicated dissatisfaction with Honeywell on the last Airbus survey.&nbsp; Please see the ratings below.&nbsp; You are expected to create an action plan and address all ratings of 1 or 2. <br>Please attach your action plan to '+fbname+' in Salesforce.com within 14 days of the receipt of this message.<br><br>'+conname+'<br><br>'+fbsatis2+'<br>'+fbsatis4+'<br>'+fbsatis6+'<br>'+fbhon+'<br>'+fbcustom+'<br><br><br><br><br><br><br></td></tr></table></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent2; bEditID:r4st1;"></td></tr><tr valign="top" ><td  style=" vertical-align:top; height:60; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;"></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF0000; bLabel:accent3; bEditID:r6st1;"></td></tr></table></center></html>';
                   
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {atm.user.email};          
                mail.setToAddresses(toAddresses);           
                mail.setSubject(atm.account.name  +'Aiirbus Survey Red Rating Assignment');
                mail.setHtmlBody(htmlBody);
                UFRbulkEmails.add(mail);
            }           
            Messaging.sendEmail(UFRbulkEmails);
        }
    }
    ///// INC000008843002 - Start
    if(lstSRrec1.size()>0)
    {
        insert lstSRrec1;    
    }
    
    //// INC000008843002 - End
}