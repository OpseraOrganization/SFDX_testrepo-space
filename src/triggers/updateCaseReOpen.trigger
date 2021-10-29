/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : updateCaseReOpen
* Description           : Trigger to Reopen a Case based on the new incoming email
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-11-2010      1.0            NTTData               Initial Version created
* May-02-2013      1.2            NTTDATA               SR#395433 Code changes for assigning Case
                                                        status to Re-Open based on Incoming email
                                                        from status Waiting for customer
*Sep-16-2013      1.2            NTTDATA                SR#419758 - Assign the Queue Owner for
                                                        the cases get reopned 
*Nov-03-2014      1.3            NTTDATA                INC000006656211--Commented Code where Email-GBS-AES-Repair,Email-CPSQuotesEMEA contains 
*Nov 19-2014    INC000007007934  NTTDATA                Line 119 for SR INC000007007934- Auto close case if mail received from Unauthorized contact
**************************************************************************************************/
trigger updateCaseReOpen on EmailMessage (after insert) 
{  
    // Build a list of Case IDs to query against
    /*commenting trigger code for coverage
    Boolean stopemail = false;
    String CaseId; 
    List<Id> caseIds = new List<Id>();
    List<Case> cases = new List<Case>();
    List<Case> updcase = new List<Case>();
    List<Case> cases1 = new List<Case>();
    List<Case> updcase1 = new List<Case>();
    // Added for INC000006348757 Starts //
    List<Case> cases2 = new List<Case>();
    List<Case> updcase2 = new List<Case>();
    // Added for INC000006348757 Starts //
    //SR#419758
    List<string> listE2cEmailOrigin = new List<string>{'Email-AeroAirbus',
                                        'Email-AeroBoeing',
                                        'Email-AeroComponents',
                                        'Email-BGAOEMQuoteOrders',
                                        'Email-CPSQuotesApprovals',
                                        'Email-CSO BGA Spares',
                                        'Email-D&Sorders',
                                        'Email-D&Squotes',
                                        'Email-R&O D&S',
                                        'Email-Order Changes',
                                        'Email-Order Status',
                                        'Email-Orders',
                                        'Email-Quotes',
                                        'Email-R&O Avionics',
                                        'Email-R&O MechComponents',
                                        'Email-ROEMEAIAvionics',
                                        'Email-ROEMEAIMechanical'};
    List<Case_Matrix__c> listCaseMatrix = [select id,Name, OwnerId__c from Case_Matrix__c where Name in: listE2cEmailOrigin and Email_Public_Group__c = null];
    system.debug('listCaseMatrix ----->' + listCaseMatrix );
    Map<string,id> mapOwnerIds = new Map<string,id>();
    for(Case_Matrix__c cmItem:listCaseMatrix){
        mapOwnerIds.put(cmItem.Name,cmItem.OwnerId__c) ;
    }
    
    Set<id> setCaseIds = new Set<id>();
    set<id> setContIds = new set<id>();
    list<string> listProcess = new list<string>();
    for(EmailMessage em:Trigger.New){
        setCaseIds.add(em.parentid);
    }
    for(Case cs:[select id, contactid, R_O_Case_Origin__c from case where id in: setCaseIds])
    {
        listProcess.add(cs.R_O_Case_Origin__c);
        setContIds.add(cs.contactid);
    } 
    
    List<EmailMessage> elist = new List<EmailMessage>();
    elist = [select id,parentid from EmailMessage where parentId in:setCaseIds limit 5]; //deb
    system.debug('YYYYYYYYYYYYYYY'+elist);   //deb
    List<Agent_Contact_Mapping__c> listAgent =
         [select id,CSR__c,CSR__r.Signature1__c,CSR__r.IsActive,Contact__c,Process__c from Agent_Contact_Mapping__c where
        Agent_Contact_Mapping__c.Contact__c in: setContIds and Agent_Contact_Mapping__c.Process__c in: listProcess ];
    
    //End SR#419758
    
    for(EmailMessage e : Trigger.new){
        // Code starts for INC000005970188
        if(e.FromAddress!=null && (e.FromAddress.toUpperCase().contains('DONT-REPLY-AOG-DESK@SERVICES.DLH.DE'))){
            stopemail = true;
        }
        // Code ends for INC000005970188
        CaseId = e.ParentId;
        //12/11/12 - Code change to add emailmessage status 1(read) for E2CP cases to reopen
        if(CaseId != null && (e.Status == '0' || e.Status == '1'))
        caseId = caseId.substring(0,3);
        if(caseId == '500'){ 
            if(e.subject != null){
                caseIds.add(e.ParentId);
            }
        }      
    }
    if(caseIds.size() > 0){
        try{
            cases = [Select OwnerId__r.IsActive,subject,classification__c,Origin, Status,Case_Record_Type__c,RecordTypeId,SuppliedEmail,OpenTask__c,service_level__c,Emailbox_Origin__c,Sub_Status__c,Case_OwnerId_After_Close__c 
                    From Case Where Id in :caseIds and (isClosed = true or (Status_changed1__c =:true and
                    Sub_Status__c =:'Waiting for Customer response' and
                    (Case_Record_Type__c = 'Customer Master Data' or Case_Record_Type__c = 'Warranty'
                    or Case_Record_Type__c = 'Web Support')))];
                      
            if(cases.size() > 0){
                if(stopemail == false){
                    for(integer i=0;i<cases.size();i++){ system.debug('XXXXXXXXXXXXXXXXXXXX1'+cases[i].subject);
                        if(cases[i].subject != 'ARINC Update' && cases[i].subject != 'HONEYWELL FLIGHT TRACKING REQUESTS'
                            && cases[i].subject != 'OCD Updates 620' && cases[i].subject != 'OCD Updates 623'
                            && cases[i].subject != 'PDC Update' && cases[i].subject != 'Sat Updates'
                            && cases[i].subject != 'SITA JetBlue Updates' && cases[i].subject != 'SITA Updates'
                            && cases[i].subject != 'VHF Updates' && 
                            !(cases[i].service_level__c == 'Unauthorized Dist/Brkr' && cases[i].classification__c == 'CSO Spares' && cases[i].status == 'Cancelled' && cases[i].Origin != 'Phone' && cases[i].Origin != 'Web'))
                        {
                        system.debug('XXXXXXXXXXXXXXXXXXXX'+cases[i].Emailbox_Origin__c);
                        system.debug('XXXXXXXXXXXXXXXXXXXX'+elist.size());
                        system.debug('XXXXXXXXXXXXXXXXXXXX'+elist);
                          system.debug('XXXXXXXXXXXXXXXXXXXX2'+cases[i].subject);
                             if((cases[i].service_level__c != 'Unauthorized Dist/Brkr')&&(null!=cases[i].subject && !(cases[i].subject.contains('FAA COMMAND CENTER MESSAGE')
                                || cases[i].subject.contains('FrontierMEDEX – HOT SPOTS')
                                || cases[i].subject.contains('GA DESK') || (cases[i].Emailbox_Origin__c == 'Email-trandsupport' && elist.size() == 1 && setCaseIds.contains(cases[i].id))))
                               || (cases[i].subject == null || cases[i].subject == ''))
                            { 
                                system.debug('XXXXXXXXXXXXXXXXXXXX3'+cases[i].subject);
                                // Added for INC000006348757 Starts //
                                if(((cases[i].status == 'Done' && cases[i].Sub_Status__c == 'Approved') ||(cases[i].status == 'Done' && cases[i].Sub_Status__c == 'Rejected')) && cases[i].Case_Record_Type__c == 'CP Outside Purchase Request') {
                                    cases[i].Sub_Status__c = '';    
                                }
                                // Added for INC000006348757 Ends//
                                cases[i].status = 'Re-Open';
                                cases[i].OpenTask__c = true;
                                cases[i].Reopen_Case__c = false;
                                if( mapOwnerIds.size()>0){//SR#419758
                                        for(string emailBox : listE2cEmailOrigin){
                                            if(cases[i].Emailbox_Origin__c == emailBox  && cases[i].OwnerId__r.IsActive == false)
                                            {
                                                system.debug('cases[i].Emailbox_Origin__c --->' + cases[i].Emailbox_Origin__c);
                                                cases[i].ownerid = mapOwnerIds.get(cases[i].Emailbox_Origin__c);
                                            }
                                        }
                                }
                                if(listAgent.size()>0 && cases[i].OwnerId__r.IsActive == false){
                                    if(listAgent[0].CSR__r.IsActive == true){
                                        cases[i].ownerid = listAgent[0].CSR__c;

                                    }
                                }else if(cases[i].Emailbox_Origin__c == 'Email-R&O Avionics' || cases[i].Emailbox_Origin__c == 'Email-R&O MechComponents'){
                                    if(null!=cases[i].Case_OwnerId_After_Close__c){
                                        cases[i].ownerId = cases[i].Case_OwnerId_After_Close__c;
                                        system.debug('------------->'+cases[i].Case_OwnerId_After_Close__c);
                                    }
                                }
                                //End SR#419758
                                updcase.add(cases[i]);
                            } 
                        } 
                    }
                    update updcase;
                }
            }
        }
        catch(Exception e){
        }
        //Add for SR#399645
        try{
            cases1 = [Select Ownerid__r.Isactive,subject,Status,Case_Record_Type__c,RecordTypeId,SuppliedEmail,OpenTask__c,service_level__c,Emailbox_Origin__c
                     From Case Where Id in :caseIds and (isClosed = true or (Status_changed__c =:true
                      and Sub_Status__c=:'Waiting for Customer response' and
                     (Case_Record_Type__c='Customer Master Data' or Case_Record_Type__c='Warranty'
                     or Case_Record_Type__c='Web Support')))];
            system.debug('Qry Val1' + Cases1);
            if(cases1.size() > 0){
                if(stopemail == false){
                    for(integer i=0;i<cases1.size();i++){
                        if(cases1[i].subject != 'ARINC Update' && cases1[i].subject != 'HONEYWELL FLIGHT TRACKING REQUESTS'
                            && cases1[i].subject != 'OCD Updates 620' && cases1[i].subject != 'OCD Updates 623'
                            && cases1[i].subject != 'PDC Update' && cases1[i].subject != 'Sat Updates'
                            && cases1[i].subject != 'SITA JetBlue Updates' && cases1[i].subject != 'SITA Updates'
                            && cases1[i].subject != 'VHF Updates' && cases[i].service_level__c != 'Unauthorized Dist/Brkr')
                        {
                            if(!(cases1[i].subject.contains('FAA COMMAND CENTER MESSAGE')
                                || cases1[i].subject.contains('FrontierMEDEX – HOT SPOTS')
                                || cases1[i].subject.contains('GA DESK') || (cases[i].Emailbox_Origin__c == 'Email-trandsupport' && elist.size() == 1 && setCaseIds.contains(cases[i].id)))
                               )
                            {
                                cases1[i].status = 'Open';
                                cases1[i].OpenTask__c = true;
                                if(mapOwnerIds.size()>0){
                                for(string emailBox : listE2cEmailOrigin){
                                    if(cases1[i].Emailbox_Origin__c == emailBox && cases[i].OwnerId__r.IsActive == false)
                                        {
                                            system.debug('cases1[i].Emailbox_Origin__c --->' + cases1[i].Emailbox_Origin__c);
                                            cases1[i].ownerid = mapOwnerIds.get(cases1[i].Emailbox_Origin__c);
                                        }
                                    }
                                }
                                if(listAgent.size()>0 && cases[i].OwnerId__r.IsActive == false){
                                    if(listAgent[0].CSR__r.IsActive == true){
                                        cases[i].ownerid = listAgent[0].CSR__c;
                                        
                                    }
                                }   
                                updcase1.add(cases1[i]);
                            } 
                        } 
                    }
                    update updcase1;
                }
            }
        }
        catch(Exception ee){}
        // End for SR#399645
    }  */                  
}