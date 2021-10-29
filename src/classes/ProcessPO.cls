/*
Email Handler to detect PO and Serial Numbers in incoming emails and search for cases with any matches

12/6/12    CC @ IC    Created per Internet Creations Case 76323
2/27/13    CC @ IC    Added diags
3/4/13     CC         Only search Subject
5/22/13    CC         Enable truncate on email message insertion
5/23/13    CC         Enable attachment insertion
5/28/12    CC         Send all messages to E2CP
7/22/13               SR #408951 - Add _(underscore) in the pattern match
7/22/13               SR #407791 - Attach email only if account matches to Contact's Account
*/
global class ProcessPO implements Messaging.InboundEmailHandler { 

    private set<string> searchForPOs(string text){
    
        System.debug('@@@@ ProcessPO ~ Enter searchForPOs with text:\n' + text + '\n'); 
    
        Set<string> hits = new Set<String>();
        String[] Patterns = new String[]{};
        
        // Code modified for SR #408951 starts
        //Patterns.add('([0-9]|[A-Z]|-){4,15}'); //(?<=[0-9]) digits, upper case letters, and dashes with at least one number, 4 to 15 characters total
        Patterns.add('([0-9]|[A-Z]|-|_){4,15}'); //(?<=[0-9]) digits, upper case letters, and dashes with at least one number, 4 to 15 characters total
        // Code modified for SR #408951 ends
        Patterns.add('([0-9]|[A-Z]|/){4,15}'); //(?<=[0-9]) digits, upper case letters, and slash with at least one number, 4 to 15 characters total
        //Patterns.add('([0-9]|[A-Z]){5}(?<=[0-9])');      // digits and upper case letters with at least one number,  exactly 5 characters   
        Patterns.add('([0-9]){7}[\\s]([0-9]){2}');       // exactly 7 digits, space, exactly  2 digits

        Patterns.add('^(?=.*[0-9].*)([-|A-Z|0-9]{4,15})$'); //alternate version of first above

        Pattern p; 
        Matcher m; 
        
        for(string pat : patterns){
            p = Pattern.compile(pat);
            m = p.matcher(text);
            while(m.find()){
                System.debug('@@@@ ProcessPO ~ Pattern ' + pat + ', Hit ' + m.group());
                hits.add(m.group());
            }
        }
        
        Set<string> hitsTemp = new Set<string>();
        for(string h : hits){
            if(!h.containsAny('1234567890')){
                System.debug('@@@@ ProcessPO ~ removing hit: ' + h);
                continue;
            }
            hitsTemp.add(h);
        }
        
        hits = hitsTemp;
        
        return hits;
    }
    
    string getHeaderText(Messaging.inboundEmail eml){
        String HeaderText = '';
        if(eml.Headers == null) return HeaderText;
        for(Messaging.InboundEmail.Header hdr : eml.Headers){
            HeaderText += hdr.name + ': ' + hdr.value + '\n';
        }
        return HeaderText;     
    }
    
    string blankNull(string s){
        if(string.isNotBlank(s)) return s;
        return '';
    }
    
    boolean hasThreadId(string text){
        //checks for ref tags indicating presence of thread id
        
        if(text == null) return false;
        text = text.replace('mailto:',''); 
    
        Integer stRef = text.LastIndexOf('ref:');
        Integer enRef = text.LastIndexOf(':ref');
        
        if (stRef != -1 && enRef != -1 && enRef > stRef)
            return true;
        else 
            return false;

    }
    
    void insertAttachments(Messaging.inboundEmail eml, id pid){ 
        //inserts attachments individually to avoid heap size errors

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.allowFieldTruncation = true;

        if(eml.binaryAttachments != null && eml.binaryAttachments.size() > 0){
            for(Messaging.InboundEmail.BinaryAttachment binAtt : eml.binaryAttachments){
                Attachment a = new Attachment(ParentId = pid, Name = binAtt.filename, Body = binAtt.body );
                a.setOptions(dmo);
                try{
                    insert a;
                }
                catch(Exception e){
                    System.debug('Exception - @@@@ ProcessPO ~ An error occurred when inserting attachment ' + binAtt.filename + ':\n[' + e.getTypeName() + '] ' + e.getMessage() + '\n');
                }
            }
        }
        
        if(eml.textAttachments != null && eml.textAttachments.size() > 0){
            for(Messaging.InboundEmail.TextAttachment txtAtt : eml.textAttachments){
                Attachment a = new Attachment(ParentId = pid, Name = txtAtt.filename, Body = Blob.valueOf(txtAtt.body));
                a.setOptions(dmo);
                try {
                    insert a;
                }
                catch (Exception e) {
                     System.debug('Exception - @@@@ ProcessPO ~ An error occurred when inserting attachment ' + txtAtt.filename + ':\n[' + e.getTypeName() + '] ' + e.getMessage() + '\n');
                }
            }
        }
    }

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail eml, Messaging.InboundEnvelope env){

        if(eml.Subject == null) eml.Subject = '';
        //if(eml.PlainTextBody == null) eml.PlainTextBody = '';
        
        //immediately pass to E2CP if thread id is detected
        if(hasThreadId(eml.Subject)){
            System.debug('@@@@ ProcessPO ~ Thread Id detected in email subject - passing email to E2CP');
            E2CP.ProcessMessage ProcMsg = new E2CP.ProcessMessage(); 
            ProcMsg.handleInboundEmail(eml,env); 
            Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
            result.success = true;
            return result;     
        }
        List<Contact> lstContact = [select id,accountid from contact where email =: eml.fromaddress];
        Case[] CaseList = New Case[]{};
        if(lstContact!=null && lstContact.size() == 1)
        {
            Set<string> POs = new Set<String>();
        
            POs.addAll(searchForPOs(blankNull(eml.Subject)));
            //POs.addAll(searchForPOs(blankNull(eml.PlainTextBody)));
            System.debug('@@@@ ProcessPO ~ POs '+POs);
            Case[] CaseList1 = [Select id, Customer_PO_RO_WONumber__c, E2CP__Case_Thread_Id__c,accountid From Case 
                Where Customer_PO_RO_WONumber__c in :POs];
                
            Case[] CaseList2 = [Select id, Customer_PO_RO_WONumber__c, E2CP__Case_Thread_Id__c,accountid From Case 
                Where Product_Serial_Number__c in :POs];

            CaseList.addAll(CaseList1);
        
        //prevent issue when case has same value in SN and PO field (selected by both queries above)
        set<string> IdSet = new Set<String>(); //cids from CaseList1
        for(case cs : CaseList){
            IdSet.add(cs.id);
        }
                
        for(case cs : CaseList2){
            if(!IdSet.contains(cs.id)) CaseList.add(cs); //dont add to list if cid was in CaseList1                 
        }
        }
        if(CaseList.size() == 1 && lstContact!=null && lstContact.size() == 1 && CaseList[0].accountid==lstContact[0].accountid){
           //single hit - attach to case
            System.debug('@@@@ ProcessPO ~ Single case match with id ' + CaseList[0].Id + ' - attaching email');
            
            string ThreadId = CaseList[0].E2CP__Case_Thread_Id__c;
            eml.Subject += ' ' + ThreadId;
            E2CP.ProcessMessage ProcMsg = new E2CP.ProcessMessage(); 
            ProcMsg.handleInboundEmail(eml,env);
                                   
        }
        else if(CaseList.isEmpty() || CaseList.size() == 1){
            //no results - pass message to e2cp
            System.debug('@@@@ ProcessPO ~ No matching cases - passing email to E2CP');
            E2CP.ProcessMessage ProcMsg = new E2CP.ProcessMessage(); 
            ProcMsg.handleInboundEmail(eml,env); 
        }
        else{
            //multiple hits - pass to E2CP
            String resText = '@@@@ ProcessPO ~ ' + CaseList.size() + ' matching cases with ids below ' + CaseList.size() + ' - passing email to E2CP';
            for(Case cs : CaseList) resText += '\nhttps://cs15.salesforce.com/' + cs.id;
            resText += '\n';
            System.debug(resText);
            E2CP.ProcessMessage ProcMsg = new E2CP.ProcessMessage(); 
            ProcMsg.handleInboundEmail(eml,env); 
        }
        
        //return success
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        result.success = true;
        return result;
    }
}