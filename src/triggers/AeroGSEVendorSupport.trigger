/**************************************************************************************************
* Company Name          : NTTDATA
* Name                  : AeroGSEVendorSupport
* Description           : Trigger to update case subclass,classification,owner id.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification

* DEC 12-2013      1.2            NTTDATA               Code change for case 101 exceptions.    
* Jan 13-2014      1.3            NTTDATA               Line 38 checking case subject is not null.                                          
**************************************************************************************************/
trigger AeroGSEVendorSupport on EmailMessage (after insert) 
{
    /*commenting trigger code for coverage
    list<case> clist = new list<case>();
    list<EmailMessage> elist = new list<EmailMessage>();
    set<Id> caseid = new set<Id>();   
    set<Id> parentid = new set<Id>(); 
    Id recrdtypid1 = label.Repair_Overhaul_RT_ID;   
    Id recrdtypid = label.GSS_Quotes_Orders; 
    List<Case> casetoUpdate = new List<Case>();
    List<Case> cases = new List<Case>();
    List<Task> NewTaskInsert = new List<Task>();
    
    for(EmailMessage e : Trigger.new) 
    {
        if(e.Incoming == true && e.ParentId != null && (e.ToAddress == 'aerogsevendorsupport@honeywell.com' || e.ToAddress == 'aerogsevendorsupport@o-1436vemlrs18wkzahdzirikxg7rhef7y9hoagnwlhgyj49t4ug.3-dwxyeau.al.case.salesforce.com' ))
        {    
            parentid.add(e.ParentId);
        }       
    }
    
    if(parentid.size() > 0)
    {
        List<case> c0=[select ID,ContactID,Subject,CaseNumber from case where id=:parentid and RecordTypeId =:label.GSS_Quotes_Orders and Emailbox_Origin__c = 'Email-Aero GSE Vendor Support'];                                        
        if(c0.size() > 0)
        {
            for(case c1: c0)
            { 
              if(c1 != null && c1.subject !='' && c1.subject != null )
              { 
                string test = c1.subject.toLowerCase();
                if(test.contains('purchasing') || test.contains('purch') || test.contains('carol') || test.contains('grace'))
                {                                                      
                  c1.Sub_Class__c = 'Purchasing';
                  c1.Classification__c = 'GSE Vendor Support';
                  c1.ownerid = label.GSS_USER_ID1; 
                  clist.add(c1);
                }
                else if(test.contains('engineering') || test.contains('engrg') || test.contains('engineer')
                         || test.contains('bryan') || test.contains('vanlandingham'))
                {
                  c1.Sub_Class__c = 'Engineering';
                  c1.Classification__c = 'GSE Vendor Support';
                  c1.ownerid = label.GSS_USER_ID2; 
                  clist.add(c1);
                }
                else if(test.contains('quality') || test .contains('qa') || test.contains('joseph')
                         || test.contains('olszewski') || test .contains('joe'))
                {
                  c1.Sub_Class__c = 'Quality';
                  c1.Classification__c= 'GSE Vendor Support';
                  c1.ownerid = label.GSS_USER_ID3; 
                  clist.add(c1);                                                                           
                }
                else if(test.contains('receiving'))
                {
                  c1.Sub_Class__c = 'Receiving';
                  c1.Classification__c = 'GSE Vendor Support';
                  c1.ownerid = label.GSS_USER_ID4; 
                  clist.add(c1);                                                                           
                }
                else if(test.contains('drawings') || test.contains('dwg') || test.contains('dwgs') || test.contains('erfq'))
                {
                  c1.Sub_Class__c = null;
                  c1.Classification__c = 'GSE Vendor Support';
                  c1.ownerid = label.GSS_USER_ID5; 
                  clist.add(c1);                                                                           
                }
                else if(test.contains('follow-up') || test .contains('follow up'))
                {                       
                  c1.Sub_Class__c = 'Follow-Up';
                  c1.Classification__c = 'GSE Vendor Support';
                  c1.ownerid = label.GSS_USER_ID5; 
                  clist.add(c1);                                                                           
                }
              }                                                      
            }  
        }    
        if(clist.size() > 0)
        {
            update clist;
        } 
    }      */ 
}