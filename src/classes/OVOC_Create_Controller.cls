Public class OVOC_Create_Controller {
    // Variables declaration
    Public id uid;
    Public Voice_of_Customer__c VOCInsert {get;set;}
    Public List<VOC_Customer_Name__c> VOCCustomers{get;set;}
    Public List<VOC_Customer_Name__c> InsertVOCCustomers;
    public string prevoc;
    Public string preovoc;
    Public id pgid;
    Public List<string> VocCustEmail;
    Public List<Contact> conlist;
    Public Transient Attachment myfile;
    Public integer cnt{get;set;}
    public Integer numberOfRowToRemove { get; set; }
    public Integer rowNum{get;set;}
    // New page variables
    Public string VOC_Title{get;set;}
    Public string VOC_Date{get;set;}
    Public string Honeywell_Lead{get;set;}
    Public string VOC_COllection{get;set;}
    Public string Customer_Name{get;set;}
    Public string Company_Name{get;set;}
    Public String Customer_Title{get;set;}
    Public string Customer_Email{get;set;}
    Public String VOC_Hypothesis{get;set;}
    Public String Key_Takeaways{get;set;}
    Public string Financial_Implications{get;set;}
    Public string Key_Action_Items{get;set;}
    Public string Product_Name{get;set;}
    Public string Platform{get;set;}
    Public string Product_Family{get;set;}
    Public string Sensitive_Information{get;set;}
    Public string VOC_purpose{get;set;}
    Public string secGroup{get;set;}
    public string recordType{get;set;}
    public string deleteList{get;set;}
    Public string customerDetails{get;set;}
    public string deleteFileList{get;set;}
    public blob attachBody{get;set;}
    public string attachName{get;set;}
    public Attachment attach{get;set;}
    
    public string title{get;set;}
    // Attachment method
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
     
    // Constructor
    Public OVOC_Create_Controller() {
        attach = new Attachment();
        pgid = ApexPages.currentPage().getParameters().get('id');    // Get record id
        uid = userinfo.getUserId();                                  // get UserId
        VOCCustomers = new List<VOC_Customer_Name__c>();            // Instantiate a new list of Customers to be added
        VOCInsert = new Voice_of_Customer__c();
        VocCustEmail = new List<string>();
        
        // The following is to run only when clicked on an existing record. Checking if url has an ID
        if(pgid != null) {
            VOCInsert = [select id,name,VOC__c,OVOC__c,recordtype.name, VOC_Topic__c,VOC_Title__c from Voice_of_Customer__c where id=: pgid]; 
            List<VOC_Customer_Name__c> SavedVOCCustomer = [select id,VOC_Record__c,Customer_Name__c,Company_Name__c,Customer_s_Title_Role__c,Primary_Customer_s_Email__c from VOC_Customer_Name__c where VOC_Record__c =: VOCInsert.id]; 
            for (VOC_Customer_Name__c vcc: SavedVOCCustomer) {
                VOCCustomers.add(vcc);
            }
        } 
        else {
             VOCCustomers.add(new VOC_Customer_Name__c());      
        }
    }
    
    // Declare the VOC/OVOC radio button values 
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('VOC','VOC')); 
        options.add(new SelectOption('OVOC','OVOC')); 
        return options; 
    }   
     
    // Adding new customer row   
     public void AddRow() {
        VOCCustomers.add(new VOC_Customer_Name__c());
    }
    
    // Removing new customer row
    public void removeNewObject(){
    if(VOCCustomers.size() > 1) {
    rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        VOCCustomers.remove(numberOfRowToRemove); 
    }
    }
    
    // Save VOC/OVOC method
    @RemoteAction
    Public static pagereference Save_Voc(string title, string topic, string rectype) { //, List<string>cust
        Voice_of_Customer__c VOCInsert = new Voice_of_Customer__c();
        VOCInsert.Status__c = 'Submitted';
        VOCInsert.VOC_Title__c = title;
        VOCInsert.VOC_Topic__c = topic;
        if (rectype == 'VOC') {
            VOCInsert.recordtypeId = Label.VOC_RecType_Id;
        }
        if (rectype == 'OVOC') {
            VOCInsert.recordtypeId = Label.OVOC_RecType_Id;
        }
        insert VOCInsert;
     /*   if (pgid == null) {
            VOC_OVOC_Record_Number__c VVR = [select id,name,VOC__c,OVOC__c from VOC_OVOC_Record_Number__c where name =:'Reference record'];
           
            if(RecordTypes != null && RecordTypes == 'VOC') {
                integer vocrec = integer.valueOf(VVR.VOC__c);
                VOCInsert.RecordTypeId = Label.VOC_RecType_Id;           
                vocrec++; 
                if (vocrec > 0 && vocrec<=9) {
                    prevoc = '0000';
                }
                else if (vocrec >= 10 && vocrec<=99) {
                    prevoc = '000';    
                }
                else if (vocrec >= 100 && vocrec<=999) {
                    prevoc = '00';    
                }
                else if (vocrec >= 1000 && vocrec<=9999) {
                    prevoc = '0';    
                }
                else {
                    prevoc = '';
                }
                VOCInsert.VOC__c = 'VOC-'+prevoc+vocrec;
                VVR.VOC__c = string.valueOf(vocrec);
                VOCInsert.Status__c = 'Submitted';
                insert VOCInsert;
                update VVR;
                if(VOCCustomers.size()>0) {
                    for(VOC_Customer_Name__c vc: VOCCustomers) {
                        if (vc.Customer_Name__c != null && vc.Customer_Name__c != '') { 
                            if (vc.Primary_Customer_s_Email__c == null && vc.Primary_Customer_s_Email__c =='') {
                                vc.VOC_Record__c = VOCInsert.id;
                                InsertVOCCustomers.add(vc);
                            }
                            else {
                                VocCustEmail.add(vc.Primary_Customer_s_Email__c);
                            }   
                        }
                    }
                    if(VocCustEmail.size()>0) {
                        List<Contact> Conlist = [select id,Email from Contact where email in :VocCustEmail];
                        For(VOC_Customer_Name__c vc: VOCCustomers) {
                            if(conlist.size()>0) {
                                for(contact c: conlist) {
                                    if(vc.Primary_Customer_s_Email__c == c.email) {
                                        vc.Contact__c = c.id;     
                                        vc.VOC_Record__c = VOCInsert.id;                                           
                                    }  
                                    else {
                                        vc.VOC_Record__c = VOCInsert.id;     
                                    }                          
                                } 
                            }
                            else {
                                vc.VOC_Record__c = VOCInsert.id;  
                            }
                            InsertVOCCustomers.add(vc);
                            
                        } 
                    }               
                }
                if(InsertVOCCustomers.size()>0) {
                    upsert InsertVOCCustomers;
                }
                
            }
            if(RecordTypes != null && RecordTypes == 'OVOC') {
                integer ovocrec = integer.valueOf(VVR.OVOC__c);
                VOCInsert.RecordTypeId = Label.OVOC_RecType_Id;
                ovocrec++;
                if (ovocrec > 0 && ovocrec<=9) {
                    preovoc = '0000';
                }
                else if (ovocrec >= 10 && ovocrec<=99) {
                    preovoc = '000';    
                }
                else if (ovocrec >= 100 && ovocrec<=999) {
                    preovoc = '00';    
                }
                else if (ovocrec >= 1000 && ovocrec<=9999) {
                    preovoc = '0';    
                }
                else {
                    preovoc = '';
                }
                VOCInsert.OVOC__c = 'OVOC-'+preovoc+ovocrec; 
                VVR.OVOC__c = string.valueOf(ovocrec); 
                VOCInsert.Status__c = 'Submitted';
                insert VOCInsert;
                update VVR;
                
                if(VOCCustomers.size()>0) {
                    for(VOC_Customer_Name__c vc: VOCCustomers) {
                        if (vc.Customer_Name__c != null && vc.Customer_Name__c != '') { 
                            if (vc.Primary_Customer_s_Email__c == null && vc.Primary_Customer_s_Email__c =='') {
                                vc.VOC_Record__c = VOCInsert.id;
                                InsertVOCCustomers.add(vc);
                            }
                            else {
                                VocCustEmail.add(vc.Primary_Customer_s_Email__c);
                            }   
                        }
                    }
                    if(VocCustEmail.size()>0) {
                        Conlist = [select id,Email from Contact where email in :VocCustEmail];
                        For(VOC_Customer_Name__c vc: VOCCustomers) {
                            if(conlist.size()>0) {
                                for(contact c: conlist) {
                                    if(vc.Primary_Customer_s_Email__c == c.email) {
                                        vc.Contact__c = c.id;     
                                        vc.VOC_Record__c = VOCInsert.id;                                           
                                    }  
                                    else {
                                        vc.VOC_Record__c = VOCInsert.id;     
                                    }                          
                                } 
                            }
                            else {
                                vc.VOC_Record__c = VOCInsert.id;    
                            }
                            InsertVOCCustomers.add(vc);
                        } 
                    }               
                }
                if(InsertVOCCustomers.size()>0) {
                    upsert InsertVOCCustomers;
                }
            } 
        } 
        else {
            List<ID> remainingCustRec = new List<ID>();
            List<VOC_Customer_Name__c>DeleteCustomer = new List<VOC_Customer_Name__c>();
            update VOCInsert; 
            if(VOCCustomers.size()>0) {
                    for(VOC_Customer_Name__c vc: VOCCustomers) {
                        if (vc.Customer_Name__c != null && vc.Customer_Name__c != '') { 
                            if (vc.Primary_Customer_s_Email__c == null && vc.Primary_Customer_s_Email__c =='') {
                                vc.VOC_Record__c = VOCInsert.id;
                                InsertVOCCustomers.add(vc);
                            }
                            else {
                                VocCustEmail.add(vc.Primary_Customer_s_Email__c);
                            }   
                        }
                    }
                    if(VocCustEmail.size()>0) {
                        Conlist = [select id,Email from Contact where email in :VocCustEmail];
                        For(VOC_Customer_Name__c vc: VOCCustomers) {
                            if(conlist.size()>0) {
                                for(contact c: conlist) {
                                    if(vc.Primary_Customer_s_Email__c == c.email) {
                                        vc.Contact__c = c.id;     
                                        vc.VOC_Record__c = VOCInsert.id;                                           
                                    }  
                                    else {
                                        vc.VOC_Record__c = VOCInsert.id;     
                                    }                          
                                } 
                            }
                            else {
                                vc.VOC_Record__c = pgid;  
                            }
                            InsertVOCCustomers.add(vc);
                            
                        } 
                    }               
                }
                For(VOC_Customer_Name__c vc: VOCCustomers) {
                    remainingCustRec.add(vc.id);
                }
                List<VOC_Customer_Name__c> RemainingCust = [select id, VOC_Record__c from VOC_Customer_Name__c where id Not in:remainingCustRec AND VOC_Record__c =:pgid];
                if(RemainingCust.size() >0) {
                    for(VOC_Customer_Name__c rc: RemainingCust) {
                        DeleteCustomer.add(rc);    
                    }
                }
                if(InsertVOCCustomers.size()>0) {
                    upsert InsertVOCCustomers;
                }
                if(DeleteCustomer.size()>0) {
                    delete DeleteCustomer;
                }
        } */
     //   Attachment a = new Attachment(parentId = VOCInsert.Id, name=myfile.name, body = myfile.body);
     //   insert a;    
        return null;
    }
    
    //****************Auto complete feature for Platform ********************//
    public string selectedPlatfrom{get;set;}
    
    @RemoteAction
    public static List<Platform__c> searchPlatforms(String searchTerm) {
        System.debug('Platform-->'+searchTerm );
        List<Platform__c> platforms = Database.query('Select Id, Name from Platform__c where name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC');
        System.debug('platforms -->'+ platforms );
        return platforms;
    }
    
    @RemoteAction
    public static List<Platform__c> getPlatform(String searchTerm) {
        System.debug('Platform-->'+searchTerm );
        List<Platform__c> platforms = Database.query('Select Id, Name from Platform__c where name = \'' + String.escapeSingleQuotes(searchTerm) + '\' limit 1');
        System.debug('platforms -->'+ platforms );
        return platforms;
    }
    
    @RemoteAction
    public static List<VOC_Accounts__c> searchVOCAccounts(String searchTerm) {
        
        List<VOC_Accounts__c> vocAccounts = Database.query('Select Id, Name from VOC_Accounts__c where name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC');
        //System.debug('platforms -->'+ platforms );
        return vocAccounts;
    }
    
    @RemoteAction
    public static List<VOC_Accounts__c> getVOCAccounts(String searchTerm) {
        
        List<VOC_Accounts__c> vocAccounts = Database.query('Select Id, Name from VOC_Accounts__c where name =\'' + String.escapeSingleQuotes(searchTerm) + '\'');
        //System.debug('platforms -->'+ platforms );
        return vocAccounts;
    }
    //****************Auto complete feature for Platform ********************//  
    
     //****************Auto complete feature for Honeywell Lead (User) ********************//
    
    @RemoteAction
    public static List<User> searchHoneywellLead(String searchTerm) {
        
        List<User> HoneywellLead = Database.query('Select Id, Name from user where name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' and ContactId != null ORDER BY Name ASC');
        
        return HoneywellLead;
    }
    
    @RemoteAction
    public static List<User> searchHoneywellLeadBasedName(String searchTerm) {
        
        List<User> HoneywellLead = Database.query('Select Id, Name from user where name =\'' + String.escapeSingleQuotes(searchTerm) + '\' and ContactId != null limit 1');
        
        return HoneywellLead;
    }
    //****************Auto complete feature for Honeywell Lead (User)********************//  
    
    
    @RemoteAction
    public static List<SelectOption> getVOCPurpose() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Purpose_of_this_VOC__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    @RemoteAction
    public static List<SelectOption> getProductFamily() {
        List<SelectOption> options = new List<SelectOption>();    
      /*  List<VOC_Product_Family__c> ProductList = [Select id,name,Product_Line__c from VOC_Product_Family__c]; 
        List<string> ProductFamilyList = new List<string>();
        for (VOC_Product_Family__c v : ProductList) {
            ProductFamilyList.add(v.Product_Line__c);    
        }
         for (string s: ProductFamilyList)  {
            options.add(new SelectOption(s,s));
         }
        
         */     
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Product_Family__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    @RemoteAction
    public static List<SelectOption> getSecurityGroup() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Security_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    @RemoteAction
    public static List<CollaborationGroup> getchattergroup() {
        List<SelectOption> options = new List<SelectOption>();
        string id= label.Voc_Group_Id;
        list<id> groupid= new list<id>();
        groupid=id.split(',');
        system.debug('id*************'+id);
       // options.add(new selectoption('None','--Select--'));
        List<CollaborationGroup> chatgroup= new List<CollaborationGroup>();  
        chatgroup=[select id,name from CollaborationGroup where id in:groupid ORDER BY Name];
        for(CollaborationGroup g:chatgroup) {
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+g.name);
          //  string temp=g.name.replace('VOC - ', '');
            options.add(new selectoption(g.id,g.name));
        }
        return chatgroup;
    }
    
    @RemoteAction
    public static List<SelectOption> getVOCCollection() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.VOC_Collection__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    /*@RemoteAction
    public static Id uploadAttachment(String attachmentBody, String attachmentName, String vocRecordId, String attachmentId) {
        
        
        if(attachmentBody != null) {
            Attachment att = getAttachment(attachmentId);
            String newBody = '';
            if(att.Body != null) {
                newBody = EncodingUtil.base64Encode(att.Body);
            }
            newBody += attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            if(attachmentId == '') {
                att.Name = attachmentName;
                att.parentId = vocRecordId;
            }
            upsert att;
            return att.Id;
        }else{
            return null;
        }
    }*/
    
    @RemoteAction
    public static Voice_of_Customer__c getDraftRecord(string recordId){
        Voice_of_Customer__c draftRecord = [select Id,recordTypeID,Name,Status__c, VOC_Type__c, Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,
                        Security_Group__c,Current_Tab__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell_Lead__c,Honeywell__r.Name,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Financial_Implications__c,Key_Action_Items__c,  
                        Platform__r.Name, Platform_Name__c,Product_Family__c,Content_Links__c, Sensitive__c,Account__c,Enddate__c,Startdate__c,CreatedById, CreatedDate,External_Links__c, (select id,Customer_Name__c,Customer_s_Title_Role__c, Company_Name__c, Primary_Customer_s_Email__c,VOC_Account__r.Name from VOC_Customer_Names__r),(select id, name from Attachments) from Voice_of_Customer__c where Id =:recordId limit 1]; // Querying VOC records
        return draftRecord;
    
    }
    
    @RemoteAction
    public static void addCustomer(List<VOC_Customer_Name__c> listCustomers,string vocRecordId){
        List<VOC_Customer_Name__c> InsertVOCCustomers = new List<VOC_Customer_Name__c>();
        List<string> VocCustEmail = new List<string>();
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! listCustomers.size()'+listCustomers.size());
      //  if(listCustomers.size() >0) {
         system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! listCustomers.size()'+listCustomers.size());
         Map<string,id> mapCreatedVOCAccounts = new Map<string,id>();
            for(VOC_Customer_Name__c c : listCustomers){
                if (c.Primary_Customer_s_Email__c == null && c.Primary_Customer_s_Email__c =='') {
                    c.VOC_Record__c = Id.valueOf(vocRecordId);
                    
                    //Populating the VOC Account by creating new VOC account
                    system.debug('c.VOC_Account__c---->' + c.VOC_Account__c);
                    string accName = c.VOC_Account__c;
                    system.debug('accName---->' + accName);
                    
                    
                    if((accName == null || accName == '') && (c.Company_Name__c != null && c.Company_Name__c != '')){
                        if(mapCreatedVOCAccounts.get(c.Company_Name__c) == null){
                            VOC_Accounts__c vocAcc = new VOC_Accounts__c();
                            vocAcc.Name = c.Company_Name__c;
                            vocAcc.OVOC_New_Account__c = true;
                            
                            insert vocAcc;
                            c.VOC_Account__c = vocAcc.Id;
                            mapCreatedVOCAccounts.put(c.Company_Name__c,vocAcc.Id);
                        }else {
                            c.VOC_Account__c = mapCreatedVOCAccounts.get(c.Company_Name__c);
                        }
                    }
                    
                    InsertVOCCustomers.add(c);
                    system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! c.Primary_Customer_s_Email__c '+c.Primary_Customer_s_Email__c);
                }
                else {
                 system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!  else  c.Primary_Customer_s_Email__c '+c.Primary_Customer_s_Email__c);
                    VocCustEmail.add(c.Primary_Customer_s_Email__c);
                    
                    
                } 
                
                
                  
            }
            if(VocCustEmail.size()>0) {
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!  VocCustEmail.size() '+VocCustEmail.size());
                List<Contact> Conlist = [select id,Email from Contact where email in :VocCustEmail];
                system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! Conlist  '+Conlist );
                For(VOC_Customer_Name__c vc: listCustomers) {
                    if(conlist.size()>0) {
                        for(contact c: conlist) {
                            if(vc.Primary_Customer_s_Email__c == c.email) {
                                vc.Contact__c = c.id;     
                                vc.VOC_Record__c = Id.valueOf(vocRecordId); 
                                system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! vc.VOC_Record__c '+vc.VOC_Record__c);                                         
                            }  
                            else {
                                vc.VOC_Record__c = Id.valueOf(vocRecordId);     
                                system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! vc.VOC_Record__c '+vc.VOC_Record__c); 
                            }                          
                        } 
                    }
                    else {
                        vc.VOC_Record__c = Id.valueOf(vocRecordId);  
                    }
                    
                    //Populating the VOC Account by creating new VOC account
                    system.debug('vc.VOC_Account__c---->' + vc.VOC_Account__c);
                    string accName = vc.VOC_Account__c;
                    system.debug('accName---->' + accName);
                    
                    if((accName == null || accName == '') && (vc.Company_Name__c != null && vc.Company_Name__c != '')){
                        if(mapCreatedVOCAccounts.get(vc.Company_Name__c) == null){
                            VOC_Accounts__c vocAcc = new VOC_Accounts__c();
                            vocAcc.Name = vc.Company_Name__c;
                            vocAcc.OVOC_New_Account__c = true;
                            
                            insert vocAcc;
                            vc.VOC_Account__c = vocAcc.Id;
                            mapCreatedVOCAccounts.put(vc.Company_Name__c,vocAcc.Id);
                        }else {
                            vc.VOC_Account__c = mapCreatedVOCAccounts.get(vc.Company_Name__c);
                        }
                    }
                    
                    
                    InsertVOCCustomers.add(vc);  
                     system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! InsertVOCCustomers '+InsertVOCCustomers);  
                } 
            }    
     //  }
     //  if(InsertVOCCustomers.size()>0) {
       system.debug('!!!!!!!!!!!!!!!!!!!!!!!!! InsertVOCCustomers last '+InsertVOCCustomers);
           upsert InsertVOCCustomers;
     //  }              
   }    
   
   @RemoteAction
    public static List<VOC_Chatter_feed_share__c> getChatterNames(string secGrp){ 
    system.debug('#####################################################'+secGrp);    
        List<VOC_Chatter_feed_share__c> ChatterGrpList = [select Id,Name,Group_ID__c,Group_Name__c from VOC_Chatter_feed_share__c where Group_ID__c =:secGrp];
        system.debug('#####################################ChatterGrpList################'+ChatterGrpList);
        return ChatterGrpList;                    
    }
    
    @RemoteAction
    public static void deleteCustomers(List<VOC_Customer_Name__c> listDeleteCustomers){     
        
        if(listDeleteCustomers.size() > 0){
            delete listDeleteCustomers;
        }
    }
    
    @RemoteAction
    public static List<VOC_Group_Queue_Map__c> getownerQueue(){     
        List<VOC_Group_Queue_Map__c> ChatterGrpQueueList = [select Id,Name,groupid__c,Queue_Id__c from VOC_Group_Queue_Map__c ORDER By Name];
        return ChatterGrpQueueList;                    
    }
    
    /*@RemoteAction
    
    Public static void ShareVOCRecord(string recId) {
        Voice_of_Customer__Share vocshare= new Voice_of_Customer__Share();
        vocshare.ParentId = id.valueOf(recId);
        vocshare.UserOrGroupId = userinfo.GetuserId();
        vocshare.AccessLevel = 'Read';
        vocshare.RowCause = Schema.Voice_of_Customer__Share.RowCause.Manual;
        Database.SaveResult sr = Database.insert(vocshare,false);        
    }
    */
    @RemoteAction
    Public static void ShareVOCRecord(string recId, string vocTitle) {
        /*List<Feeditem> insertfeedlist = new List<Feeditem>();
        List<VOC_Group_Queue_Map__c> ChatterGrpQueueList = [select Id,Name,groupid__c,Queue_Id__c from VOC_Group_Queue_Map__c];
        system.debug('===================================================');
            for(VOC_Group_Queue_Map__c vcs: ChatterGrpQueueList) {
                        FeedItem fitem=new FeedItem();
                        fitem.parentId = vcs.groupid__c;
                        fitem.linkUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + recId;
                        fitem.title = vocTitle;
                        insertfeedList.add(fitem);
            }
            system.debug('==================================================='+insertfeedList);
        if(insertfeedList.size() >0) {
            insert insertfeedList; 
        } */         
    }
    
    /*@RemoteAction
    public static string getownerQueue( string secGrp) {
        list<VOC_Group_Queue_Map__c> ownerqueue= VOC_Group_Queue_Map__c.getall().values();
        for(VOC_Group_Queue_Map__c temp: ownerqueue){
           if(temp.groupid__c == secGrp) {
               secGrp = temp.groupid__c;
           }
           else {
               secGrp = label.VOC_NON_Senstive;
           }
           
        } 
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+secGrp);
        return secGrp; 
              
    }*/
    
    /*private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }*/
    
    public pagereference addAttachment() {
        if(this.attach.body != null && this.attach.name != null){
            Id draftID = ApexPages.currentPage().getParameters().get('id'); 
            system.debug('draftID----->' + draftID);
            Voice_of_Customer__c vocToBeCreated = new Voice_of_Customer__c();
            string status;
            if(draftID != null){
                vocToBeCreated.Id = draftID ;
                status = [select id,status__c from Voice_of_Customer__c where id=: draftId].status__c;
            }
            vocToBeCreated.RecordTypeId= Id.valueOf(recordType);
            system.debug('vocToBeCreated.status__c-->' + vocToBeCreated.status__c);
            if(status != 'Draft' && status != 'Submitted'){
                vocToBeCreated.Pre_Draft__c = true;
            }
            vocToBeCreated.VOC_Title__c = VOC_Title;
            if(VOC_Date != null && VOC_Date != '' && VOC_Date != 'undefined')
            vocToBeCreated.VOC_Date__c = Date.parse(VOC_Date);
            //system.debug('---->' + Date.parse(VOC_Date));
            vocToBeCreated.Honeywell_Lead__c = Honeywell_Lead;
            vocToBeCreated.VOC_Collection__c = VOC_COllection;
            vocToBeCreated.VOC_Hypothesis__c = VOC_Hypothesis;
            vocToBeCreated.Key_Takeaways1__c= Key_Takeaways;
            vocToBeCreated.Financial_Implications__c = Financial_Implications;
            vocToBeCreated.Key_Action_Items__c = Key_Action_Items;
            vocToBeCreated.Product_Name__c = Product_Name;
            if(Platform != null && Platform !='')
                vocToBeCreated.Platform__c = Id.valueOf(Platform);
            if(Sensitive_Information != null && Sensitive_Information != '')
                vocToBeCreated.Sensitive__c = Boolean.valueOf(Sensitive_Information);
            vocToBeCreated.Product_Family__c = Product_Family;
            vocToBeCreated.Purpose_of_this_VOC__c = VOC_purpose;
            vocToBeCreated.Security_Group__c = secGroup;
            upsert vocToBeCreated;
            
            system.debug('customerDetails--->' + customerDetails);
            string[] eachCustomer = customerDetails.split(';');
            system.debug('eachCustomer--->'+eachCustomer);
            string[] allFields;
            List<VOC_Customer_Name__c> listVOCCustomers = new List<VOC_Customer_Name__c>();
            for(string customer : eachCustomer){
                if(eachCustomer[0] != '' && eachCustomer != null){
                    allFields = customer.split(',');
                    system.debug('allFields--->'+allFields);
                    system.debug('allFields.size()--->'+ allFields.size());
                    if(allFields != null && allFields.size() > 0){
                        VOC_Customer_Name__c vocCustomer = new VOC_Customer_Name__c();
                        vocCustomer.VOC_Record__c = vocToBeCreated.Id;
                        integer i = 0;
                        for(string custInfo : allFields){
                            system.debug('custInfo---->' + custInfo);
                            if(i == 0 && custInfo != 'null' && custInfo != 'undefined'){
                                vocCustomer.Id = custInfo;
                            }
                            
                            if(i == 1 && custInfo != 'null' && custInfo != 'undefined'){
                                vocCustomer.Customer_Name__c = custInfo;
                            }
                            if(i == 2 && custInfo != 'null' && custInfo != 'undefined'){
                                vocCustomer.VOC_Account__c = custInfo;
                            }
                            if(i == 3 && custInfo != 'null' && custInfo != 'undefined'){
                                vocCustomer.Customer_s_Title_Role__c = custInfo;
                            }
                            if(i == 4 && custInfo != 'null' && custInfo != 'undefined'){
                                vocCustomer.Primary_Customer_s_Email__c = custInfo;    
                            }
                            i++;
                        }
                        
                        
                        listVOCCustomers.add(vocCustomer);
                    }
                }
            }
            if(listVOCCustomers.size() > 0){
                upsert listVOCCustomers;
            }
            if(vocToBeCreated.id != null){
                if(this.attach.body != null){
                    Attachment a = this.attach.clone(false, true);
                    a.ParentId = vocToBeCreated.id;
                    this.attach.Body = null;
            
                    Database.Insert(a);
                }
            }
            
            if(deleteFileList != null && deleteFileList != ''){
                List<attachment> deleteFileFinalList = new List<attachment>();
                string[] listAttach = deleteFileList.split(';');
                for(string file: listAttach){
                    Attachment attach = new Attachment();
                    attach.Id= Id.valueOf(file);
                    deleteFileFinalList .add(attach);
                }
                if(deleteFileFinalList .size() > 0){
                    delete deleteFileFinalList;
                }
            }
            PageReference pageAsDraft = new PageReference('/apex/OVOC_Create?id='+ vocToBeCreated.Id + '&tab=7');
            pageAsDraft.setRedirect(true);
            return pageAsDraft;    
        }else{
            return null;
        }
    }
    
    
    @RemoteAction
    public static void deleteAttachments(string idList){     
        String[] fileIds;
        List<Attachment> deleteList = new List<Attachment>();
        if(idList != null && idList != ''){
            fileIds = idList.split(';');
            for(string strId : fileIds){
                Attachment att = new Attachment();
                att.id = strId;
                deleteList.add(att);
            }
            if(deleteList.size() > 0){
                delete deleteList;
            }
        }
        
                            
    }
    
    /*@RemoteAction
    public static void deleteContenVersions(string idList,string fileUrl,string draftRecordId ){     
        String[] fileIds;
        boolean success = false;
        set<Id> deleteList = new set<Id>();
        if(idList != null && idList != ''){
            fileIds = idList.split(';');
            for(string str: fileIds){
                if(str != null){
                    
                    deleteList.add(str.substring(0,18));
                }
            }
            if(deleteList.size() > 0){
                List<contentVersion> listCV = [select id, ContentDocumentId from Contentversion where id in: deleteList];
                List<ContentDocument> deleteConList = new List<ContentDocument>();
                for(ContentVersion cv : listCV){
                    ContentDocument cd = new ContentDocument();
                    cd.id = cv.ContentDocumentId;
                    deleteConList.add(cd);
                }
                if(deleteConList.size() > 0){
                    delete deleteConList;
                }
            }
        }
        if(draftRecordId != null && fileUrl != null){
            Voice_of_Customer__c vc = new Voice_of_Customer__c();
            vc.id = Id.valueOf(draftRecordId);
            vc.Content_Links__c =  fileUrl;
            update vc; 
            success = true;  
        }
                        
    }*/
    @RemoteAction
    public static List<VOC_Product_Family_Chatter__c> getProdFamilyChatter(){     
        List<VOC_Product_Family_Chatter__c> PrdFamilyChatterList = [Select Id,Name,Chatter_Group_ID__c,Chatter_Group_Name__c from VOC_Product_Family_Chatter__c];
        return PrdFamilyChatterList;                    
    }
}