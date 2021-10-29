Public with sharing class OVOC_SearchPage_Controller {
    Public string Search_Keyword{get;set;}
    Public string Search_StartDate{get;set;}
    Public string Search_EndDate{get;set;}
    Public string Search_Customer_Name{get;set;}
    Public string Search_OEM_Account{get;set;}
    Public string Search_Honeywell_Lead{get;set;}
    Public string Search_Product_Line{get;set;} 
    Public List<Voice_of_Customer__c> Search_VOC_List{get;set;}
    // Save Search variables
    Public string Save_Search_Name{get;set;}
    Public list<VOC_Save_Search__c> save_Search_Qry{get;set;}
    public string SS_Keyword;
    public date SS_StartDate;
    public date SS_EndDate;
    public string SS_Customer_Name;
    public string SS_OEM_Account;
    public string SS_Honeywell_Lead;
    public string SS_Product_Line;
    public id pageid;
    public id uid;
    
    public OVOC_SearchPage_Controller() {
        Pageid = ApexPages.currentPage().getParameters().get('id');
        uid = userinfo.getuserId();
    }
    public List<vocWrapper> Saved_VOC_List{get; set;}
    public List<vocWrapper> getsave_Search() {
        if(Saved_VOC_List == null) {
            Saved_VOC_List = new List<vocWrapper>();
            for(VOC_Save_Search__c s: [select id,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c from VOC_Save_Search__c  where createdbyId =:uid ORDER By lastModifiedDate DESC limit 5 ]) {
            
            Saved_VOC_List.add(new vocWrapper(s));  
            }    
        }
        return Saved_VOC_List;
    } 
    @RemoteAction
    public static List<Voice_of_Customer__c> Search_VOC(string Searchtext, string FromDate, string ToDate, string CustomerNameTitle, string AccountName, string HonLead, string ProductFamily, string VOCTitle, string Purpose, string RecordNumber, string CurrentStatus, string SensitiveLevel, string SearchType) {
        try {
            if(SearchType == 'Metadata') {
                List<Voice_of_Customer__c> Search_voc = new List<Voice_of_Customer__c>();
                //************** Re declaring variables start************************* //
                List<Voice_of_Customer__c> Search_VOC_List = new List<Voice_of_Customer__c>();   
                id usrid = userinfo.getUserId();         
                string Search_Keyword;
                string Search_StartDate;
                string Search_EndDate;
                string Search_Customer_Name;
                string Search_Honeywell_Lead;
                string Search_Product_Line;
                string Search_OEM_Account;
                string SS_Keyword;
                string SS_Customer_Name;
                string SS_OEM_Account;
                string SS_Honeywell_Lead;
                string SS_Product_Line;
                date SS_StartDate;
                date SS_EndDate;    
               // string recStatus = 'Submitted';        
                //************** Re declaring variables start************************* //
             //   string Searchstring = 'select Id,VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Product_Family__c,Sensitive__c,VOC_Account__c,Enddate__c,Startdate__c,Created_By_Name__c,Status__c,Honeywell_Lead__c,Honeywell_Lead_Formula__c,Pre_Draft__c from Voice_of_Customer__c';            
               // String Keyword = '%'+Searchtext+'%'; //Search_Keyword
                Searchtext = String.escapeSingleQuotes(Searchtext);
                Searchtext = Searchtext.replace('-',' ');
                String Keyword = Searchtext+'*';
                // Adding for SOSL Test Start
                if(Searchtext == null || Searchtext == '') {
                   Searchtext = 'VOC'; 
                }
                string Searchstring = 'FIND {' +Searchtext+ '} IN ALL FIELDS RETURNING VOC_Customer_Name__c(Company_Name__c,VOC_Record__c,Customer_Name__c,Customer_s_Title_Role__c,VOC_Account__c,Primary_Customer_s_Email__c), Voice_of_Customer__c(Id,VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Product_Family__c,Sensitive__c,VOC_Account__c,Enddate__c,Startdate__c,Created_By_Name__c,Status__c,Honeywell_Lead__c,Honeywell_Lead_Formula__c,Pre_Draft__c';
                // Adding for SOSL Test end
                
                
                string Startdate = FromDate; // Search_StartDate
                String EndDate = ToDate; //Search_EndDate
                String CustomerName= '%'+CustomerNameTitle+'%'; //Search_Customer_Name
                String OEM_Account= '%'+AccountName+'%'; //Search_OEM_Account
                String Honeywell_Lead = '%'+HonLead+'%'; //Search_Honeywell_Lead
                String Product_Line = ProductFamily;  //  Search_Product_Line  
                String VOC_Title_Collection = '%'+VOCTitle+'%';
                String purposeval = Purpose;
                String Recnum = '%'+RecordNumber+'%';
                string Draftstatus ='Draft';
                string Submittedstatus = 'Submitted';
                String SensitiveInfo = SensitiveLevel;
                // Added for M&PM filter
                Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                if(profileName.contains('System Administrator')) {
                if(Searchtext != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                    AccountName != null || HonLead != null || ProductFamily != null || VOCTitle != null || 
                    Purpose != null || RecordNumber != null || SensitiveLevel != null || CurrentStatus != null) {
                    SearchString+=' where Pre_Draft__c = false ';    
                }
                }
                else {
                    user usrquery = [select id,contactId from user where id =: usrid limit 1];
                    system.debug('++++++++++++++++++++++++++++++++++++++'+usrquery);
                    contact con = [select id,Employee_Contact_SBU__c from Contact where id =:usrquery.ContactId limit 1]; 
                    system.debug('++++++++++++++++++++++++++++++++++++++'+con);   
                    if(Searchtext != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                        AccountName != null || HonLead != null || ProductFamily != null || VOCTitle != null || 
                    Purpose != null || RecordNumber != null || SensitiveLevel != null || CurrentStatus != null) {
                        if(con.Employee_Contact_SBU__c == 'M&PM') {
                            SearchString+=' where Pre_Draft__c = false ';
                        }
                        else {
                            SearchString+=' where ((Pre_Draft__c = false and Sensitive__c = false) OR (Pre_Draft__c = false and CreatedbyID =:usrid)) ';    
                        }    
                    }
                }
                /*
                if(Searchtext != null && Searchtext != '') {
                    Searchstring +=' (Company_Name__c like: Keyword OR VOC_Collection__c like: Keyword OR VOC_Title__c like:Keyword OR Product_Name__c like:Keyword OR VOC__c like: keyword) '; //Name like: keyword OR
                    SS_Keyword = keyword;
                }
                */
                
                if(CustomerNameTitle != null && CustomerNameTitle != '') {
                    if(Searchtext != null && Searchtext != '') {
                        Searchstring+=' and ';
                    } 
                    List<id> Custlist = new List<id>();
                    List<VOC_Customer_Name__c> CustomerList = [select Id, Customer_Name__c,VOC_Record__c,Customer_s_Title_Role__c from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/Customer_Name__c like : CustomerName OR Customer_s_Title_Role__c like : CustomerName limit 1000];
                    for (VOC_Customer_Name__c c: CustomerList) {
                        Custlist.add(c.VOC_Record__c);    
                    }
                   // Searchstring +=' (select Id, Customer_Name__c,VOC_Record__c from VOC_Customer_Name__c where createdbyId =:usrid AND Customer_Name__c like : CustomerName)'; 
                    Searchstring +=' id in: Custlist';
                   // Searchstring +=' Customer_Participant_Name__c  like: CustomerName';
                    
                   // SS_Customer_Name = CustomerName;
                } 
                
                if(AccountName != null && AccountName != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '')) {
                        Searchstring+=' and ';
                    }
                    List<id> CustAccountlist = new List<id>();
                    List<VOC_Customer_Name__c> CustomerAccountList = [select Id, Customer_Name__c,VOC_Record__c,VOC_Account__c,VOC_Account__r.name from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ VOC_Account__r.name like : OEM_Account Limit 1000];
                    for (VOC_Customer_Name__c c: CustomerAccountList) {
                        CustAccountlist.add(c.VOC_Record__c);    
                    }
                    Searchstring +=' id in: CustAccountlist';
                    
                  //  Searchstring +=' VOC_Account__r.name  like: OEM_Account ';  
                    SS_OEM_Account = OEM_Account;
                }
                
                if(HonLead != null && HonLead != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '')) {
                        Searchstring+=' and ';
                    }
                    Searchstring +=' ( Honeywell_Lead__c like: Honeywell_Lead OR Honeywell__r.Name like: Honeywell_Lead ) ';  
                    SS_Honeywell_Lead = Honeywell_Lead;
                }
                
                if(ProductFamily != null && ProductFamily != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && HonLead != '')) {
                        Searchstring+=' and ';
                    }
                    
                    string[] prodFamily = Product_Line.split(',');
                    string prodFamilyString='';
                    for(string prdo :  prodFamily){
                        prodFamilyString += '\''+prdo +'\',';
                    }
                    prodFamilyString = prodFamilyString.substring(0,prodFamilyString.length() - 1);
                    Searchstring +=' Product_Family__c INCLUDES (' + prodFamilyString +')';                            // like: Product_Line ';  //+ Product_Line.split(',') 
                    SS_Product_Line = Product_Line;
                }
                system.debug('+++++++++++++++++++++++++++++++++++++++'+FromDate);
                if(FromDate != null && FromDate != '') {    
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '')) {
                        Searchstring+=' and ';
                    }   
                    date STD;
                    if(StartDate.contains('/')) {
                        system.debug('+++++++++++++++++++1111++++++++++++++++++++'+StartDate); 
                        STD = Date.parse(StartDate);
                    } 
                    else {
                    system.debug('++++++++++++++++++++++2222+++++++++++++++++'+StartDate); 
                        STD = date.valueOf(StartDate);
                    }
                    Searchstring +=' createddate  >=: STD'; //STD
                    //SS_StartDate = STD;
                    system.debug('....................StartDate...................'+StartDate);
                   // system.debug('....................STD...................'+STD);
                }
                
                if(ToDate != null && ToDate != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '')) {
                        Searchstring+=' and ';
                    }
                    
                    
             
                    string timestr;
                    string enddatetime;
                    if(EndDate.contains('/')) {                
                        timestr = ' 11:59 PM';
                        system.debug('///////////////////////EndDate Desktop/////////'+EndDate);
                        string Enddatestring = EndDate.Replace('/','-');
                        enddatetime = EndDate+timestr;
                        datetime NTD = Datetime.parse(enddatetime);
                        Searchstring +=' CreatedDate <=: NTD';
                        system.debug('///////////////////////NTD/////////'+NTD);
                    } 
                    else {
                     /*   timestr = 'T23:59:59';
                        system.debug('///////////////////////EndDate Mobile/////////'+EndDate); 
                        enddatetime = EndDate+timestr;     
                        system.debug('///////////////////////enddatetime Mobile/////////'+enddatetime);       
                        date NTDN = date.valueOf(enddatetime);
                        Searchstring +=' CreatedDate <=: NTDN';
                        system.debug('///////////////////////NTDN/////////'+NTDN);
                       */ 
                       
                        // Starting fixes starts
                        timestr = ' 23:59:59';
                        system.debug('///////////////////////EndDate Mobile/////////'+EndDate); 
                        enddatetime = EndDate+timestr;     
                        system.debug('///////////////////////enddatetime Mobile/////////'+enddatetime);       
                        datetime NTDN = datetime.valueOf(enddatetime);
                        Searchstring +=' CreatedDate <=: NTDN';
                        system.debug('///////////////////////NTDN/////////'+NTDN);
                        // Starting fixes ends
                    } 
                  //  string dds = string.valueOf(NTD);
                  //  date ddt = date.valueOf(dds);
                  //  String strConvertedDate = myDate.format('MM/dd/yyyy HH:mm:ss', 'Europe/Berlin');
                  //  datetime NewNTD = Datetime.parse(strConvertedDate); 
    
                }
                
                if(VOCTitle != null && VOCTitle != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '')) {
                        Searchstring+=' and ';
                    }
                    Searchstring +=' ( VOC_Title__c like: VOC_Title_Collection OR VOC_Collection__c like: VOC_Title_Collection ) ';  
                }
                
                if(Purpose != null && Purpose != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '')) {
                        Searchstring+=' and ';
                    }
                    
                    string[] purposelist = purposeval.split(',');
                    string PurposeString='';
                    for(string prdo :  purposelist){
                        PurposeString += '\''+prdo +'\',';
                    }
                    PurposeString = PurposeString.substring(0,PurposeString.length() - 1);
                    Searchstring +=' Purpose_of_this_VOC__c INCLUDES (' + PurposeString +')';                            
                }
    
                if(RecordNumber != null && RecordNumber != '') {
                     if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                    (Purpose != null && Purpose != '')) {
                        Searchstring+=' and ';
                    }
                    Searchstring +=' VOC__c like: Recnum ';  
                }
                
                if(CurrentStatus != null && CurrentStatus != '') { 
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                    (Purpose != null && Purpose != '') || (RecordNumber != null && RecordNumber != '')) {
                        Searchstring+=' and ';
                    }
                    If(CurrentStatus == 'Any') {
                        Searchstring +=' (Status__c =: DraftStatus OR  Status__c =:Submittedstatus)'; 
                    }
                    else if (CurrentStatus == 'Completed'){
                        Searchstring +=' Status__c =: Submittedstatus '; 
                    }
                    else {
                        Searchstring +=' Status__c =: CurrentStatus ';     
                    }
                } 
                
                if(SensitiveLevel != null && SensitiveLevel != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                    (Purpose != null && Purpose != '') || (RecordNumber != null && RecordNumber != '') || (CurrentStatus != null && CurrentStatus != '')) {
                        Searchstring+=' and ';
                    }
                    If(SensitiveInfo == 'Any') {
                            Searchstring +='(Sensitive__c = '+true+' OR Sensitive__c = '+false+')'; 
                    }
                    else if (SensitiveInfo == 'Sensitive Information'){
                        Searchstring +=' Sensitive__c = '+true+''; 
                    }
                    else {
                        Searchstring +=' Sensitive__c = '+false+'';     
                    }
                                   
                } 
                
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                    (Purpose != null && Purpose != '') || (RecordNumber != null && RecordNumber != '') || (CurrentStatus != null && CurrentStatus != '') || 
                    (SensitiveLevel != null && SensitiveLevel != '')) {
                    Searchstring+=' ORDER BY createddate DESC Limit 1000)';
                }
                system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
                
                //Search_VOC_List = Database.Query(Searchstring);
                
                // Added for SOSL Starts
                List<LIST<SObject>> searchedResult = search.query(Searchstring);
                system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE'+searchedResult[0]);
                system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE searchedResult[0].size() '+searchedResult[0].size());
                List<Id> VOCID = new List<Id>();
                if(searchedResult[0].size() > 0) {
                    if(searchedResult[1].size() > 0) {
                        for(SObject tempvoc1: searchedResult[1]) {                   
                            Voice_Of_Customer__c voc = (Voice_Of_Customer__c)tempvoc1;
                            for(SObject tempcust1: searchedResult[0]) {                       
                                VOC_Customer_Name__c cust = (VOC_Customer_Name__c)tempcust1;
                                if(cust.VOC_Record__c != voc.Id) {
                                    VOCID.add(voc.Id);
                                }
                            }                    
                        }                    
                    }
                    else {
                        
                        
                        for(SObject tempcust: searchedResult[0]) {
                            VOC_Customer_Name__c cust = (VOC_Customer_Name__c)tempcust;                                                                                   
                            VOCID.add(cust.VOC_Record__c);
                        } 
                        List<Voice_Of_Customer__c> VOCQueryList = [Select Id,VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Product_Family__c,Sensitive__c,VOC_Account__c,Enddate__c,Startdate__c,Created_By_Name__c,Status__c,Honeywell_Lead__c,Honeywell_Lead_Formula__c,Pre_Draft__c from Voice_of_Customer__c where Id in:VOCID limit 1000];
                        for(Voice_Of_Customer__c v: VOCQueryList) {
                            searchedResult[1].add(v);
                        }
                    }
                }
                system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE'+searchedResult[1]);
                return searchedResult[1];
                // Added for SOSL ends
                  
                //system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
               // system.debug('$$$$$$$$$$$$$$$$$$$$'+Search_VOC_List); 
               // system.debug('$$$$$$$$$$$$$$$$$$$$'+ProductFamily);
                //return Search_VOC_List;
        }
        else {
            List<Voice_of_Customer__c> Search_voc = new List<Voice_of_Customer__c>();
            //************** Re declaring variables start************************* //
            List<Voice_of_Customer__c> Search_VOC_List = new List<Voice_of_Customer__c>();   
            id usrid = userinfo.getUserId();         
            string Search_Keyword;
            string Search_StartDate;
            string Search_EndDate;
            string Search_Customer_Name;
            string Search_Honeywell_Lead;
            string Search_Product_Line;
            string Search_OEM_Account;
            string SS_Keyword;
            string SS_Customer_Name;
            string SS_OEM_Account;
            string SS_Honeywell_Lead;
            string SS_Product_Line;
            date SS_StartDate;
            date SS_EndDate;    
           // string recStatus = 'Submitted';        
            //************** Re declaring variables start************************* //
            string Searchstring = 'select Id,VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Product_Family__c,Sensitive__c,VOC_Account__c,Enddate__c,Startdate__c,Created_By_Name__c,Status__c,Honeywell_Lead__c,Honeywell_Lead_Formula__c,Pre_Draft__c from Voice_of_Customer__c';            
            String Keyword = '%'+Searchtext+'%'; //Search_Keyword
            string Startdate = FromDate; // Search_StartDate
            String EndDate = ToDate; //Search_EndDate
            String CustomerName= '%'+CustomerNameTitle+'%'; //Search_Customer_Name
            String OEM_Account= '%'+AccountName+'%'; //Search_OEM_Account
            String Honeywell_Lead = '%'+HonLead+'%'; //Search_Honeywell_Lead
            String Product_Line = ProductFamily;  //  Search_Product_Line  
            String VOC_Title_Collection = '%'+VOCTitle+'%';
            String purposeval = Purpose;
            String Recnum = '%'+RecordNumber+'%';
            string Draftstatus ='Draft';
            string Submittedstatus = 'Submitted';
            String SensitiveInfo = SensitiveLevel;
            // Added for M&PM filter
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            if(profileName.contains('System Administrator')) {
            if(Searchtext != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                AccountName != null || HonLead != null || ProductFamily != null || VOCTitle != null || 
                Purpose != null || RecordNumber != null || SensitiveLevel != null || CurrentStatus != null) {
                SearchString+=' where Pre_Draft__c = false and ';    
            }
            }
            else {
                user usrquery = [select id,contactId from user where id =: usrid limit 1];
                system.debug('++++++++++++++++++++++++++++++++++++++'+usrquery);
                contact con = [select id,Employee_Contact_SBU__c from Contact where id =:usrquery.ContactId limit 1]; 
                system.debug('++++++++++++++++++++++++++++++++++++++'+con);   
                if(Searchtext != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                    AccountName != null || HonLead != null || ProductFamily != null || VOCTitle != null || 
                Purpose != null || RecordNumber != null || SensitiveLevel != null || CurrentStatus != null) {
                    if(con.Employee_Contact_SBU__c == 'M&PM') {
                        SearchString+=' where Pre_Draft__c = false and ';
                    }
                    else {
                        SearchString+=' where ((Pre_Draft__c = false and Sensitive__c = false) OR (Pre_Draft__c = false and CreatedbyID =:usrid)) and ';    
                    }    
                }
            }
            if(Searchtext != null && Searchtext != '') {
                Searchstring +=' (Company_Name__c like: Keyword OR VOC_Collection__c like: Keyword OR VOC_Title__c like:Keyword OR Product_Name__c like:Keyword OR VOC__c like: keyword) '; //Name like: keyword OR
                SS_Keyword = keyword;
            }
            if(CustomerNameTitle != null && CustomerNameTitle != '') {
                if(Searchtext != null && Searchtext != '') {
                    Searchstring+=' and ';
                } 
                List<id> Custlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerList = [select Id, Customer_Name__c,VOC_Record__c,Customer_s_Title_Role__c from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/Customer_Name__c like : CustomerName OR Customer_s_Title_Role__c like : CustomerName limit 1000];
                for (VOC_Customer_Name__c c: CustomerList) {
                    Custlist.add(c.VOC_Record__c);    
                }
               // Searchstring +=' (select Id, Customer_Name__c,VOC_Record__c from VOC_Customer_Name__c where createdbyId =:usrid AND Customer_Name__c like : CustomerName)'; 
                Searchstring +=' id in: Custlist';
               // Searchstring +=' Customer_Participant_Name__c  like: CustomerName';
                
               // SS_Customer_Name = CustomerName;
            } 
            
            if(AccountName != null && AccountName != '') {
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '')) {
                    Searchstring+=' and ';
                }
                List<id> CustAccountlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerAccountList = [select Id, Customer_Name__c,VOC_Record__c,VOC_Account__c,VOC_Account__r.name from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ VOC_Account__r.name like : OEM_Account Limit 1000];
                for (VOC_Customer_Name__c c: CustomerAccountList) {
                    CustAccountlist.add(c.VOC_Record__c);    
                }
                Searchstring +=' id in: CustAccountlist';
                
              //  Searchstring +=' VOC_Account__r.name  like: OEM_Account ';  
                SS_OEM_Account = OEM_Account;
            }
            
            if(HonLead != null && HonLead != '') {
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '')) {
                    Searchstring+=' and ';
                }
                Searchstring +=' ( Honeywell_Lead__c like: Honeywell_Lead OR Honeywell__r.Name like: Honeywell_Lead ) ';  
                SS_Honeywell_Lead = Honeywell_Lead;
            }
            
            if(ProductFamily != null && ProductFamily != '') {
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && HonLead != '')) {
                    Searchstring+=' and ';
                }
                
                string[] prodFamily = Product_Line.split(',');
                string prodFamilyString='';
                for(string prdo :  prodFamily){
                    prodFamilyString += '\''+prdo +'\',';
                }
                prodFamilyString = prodFamilyString.substring(0,prodFamilyString.length() - 1);
                Searchstring +=' Product_Family__c INCLUDES (' + prodFamilyString +')';                            // like: Product_Line ';  //+ Product_Line.split(',') 
                SS_Product_Line = Product_Line;
            }
            system.debug('+++++++++++++++++++++++++++++++++++++++'+FromDate);
            if(FromDate != null && FromDate != '') {    
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '')) {
                    Searchstring+=' and ';
                }   
                date STD;
                if(StartDate.contains('/')) {
                    system.debug('+++++++++++++++++++1111++++++++++++++++++++'+StartDate); 
                    STD = Date.parse(StartDate);
                } 
                else {
                system.debug('++++++++++++++++++++++2222+++++++++++++++++'+StartDate); 
                    STD = date.valueOf(StartDate);
                }
                Searchstring +=' createddate  >=: STD'; //STD
                //SS_StartDate = STD;
                system.debug('....................StartDate...................'+StartDate);
               // system.debug('....................STD...................'+STD);
            }
            
            if(ToDate != null && ToDate != '') {
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '')) {
                    Searchstring+=' and ';
                }
                
                
         
                string timestr;
                string enddatetime;
                if(EndDate.contains('/')) {                
                    timestr = ' 11:59 PM';
                    system.debug('///////////////////////EndDate Desktop/////////'+EndDate);
                    string Enddatestring = EndDate.Replace('/','-');
                    enddatetime = EndDate+timestr;
                    datetime NTD = Datetime.parse(enddatetime);
                    Searchstring +=' CreatedDate <=: NTD';
                    system.debug('///////////////////////NTD/////////'+NTD);
                } 
                else {
                 /*   timestr = 'T23:59:59';
                    system.debug('///////////////////////EndDate Mobile/////////'+EndDate); 
                    enddatetime = EndDate+timestr;     
                    system.debug('///////////////////////enddatetime Mobile/////////'+enddatetime);       
                    date NTDN = date.valueOf(enddatetime);
                    Searchstring +=' CreatedDate <=: NTDN';
                    system.debug('///////////////////////NTDN/////////'+NTDN);
                   */ 
                   
                    // Starting fixes starts
                    timestr = ' 23:59:59';
                    system.debug('///////////////////////EndDate Mobile/////////'+EndDate); 
                    enddatetime = EndDate+timestr;     
                    system.debug('///////////////////////enddatetime Mobile/////////'+enddatetime);       
                    datetime NTDN = datetime.valueOf(enddatetime);
                    Searchstring +=' CreatedDate <=: NTDN';
                    system.debug('///////////////////////NTDN/////////'+NTDN);
                    // Starting fixes ends
                } 
              //  string dds = string.valueOf(NTD);
              //  date ddt = date.valueOf(dds);
              //  String strConvertedDate = myDate.format('MM/dd/yyyy HH:mm:ss', 'Europe/Berlin');
              //  datetime NewNTD = Datetime.parse(strConvertedDate); 

            }
            
            if(VOCTitle != null && VOCTitle != '') {
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '')) {
                    Searchstring+=' and ';
                }
                Searchstring +=' ( VOC_Title__c like: VOC_Title_Collection OR VOC_Collection__c like: VOC_Title_Collection ) ';  
            }
            
            if(Purpose != null && Purpose != '') {
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '')) {
                    Searchstring+=' and ';
                }
                
                string[] purposelist = purposeval.split(',');
                string PurposeString='';
                for(string prdo :  purposelist){
                    PurposeString += '\''+prdo +'\',';
                }
                PurposeString = PurposeString.substring(0,PurposeString.length() - 1);
                Searchstring +=' Purpose_of_this_VOC__c INCLUDES (' + PurposeString +')';                            
            }

            if(RecordNumber != null && RecordNumber != '') {
                 if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                (Purpose != null && Purpose != '')) {
                    Searchstring+=' and ';
                }
                Searchstring +=' VOC__c like: Recnum ';  
            }
            
            if(CurrentStatus != null && CurrentStatus != '') { 
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                (Purpose != null && Purpose != '') || (RecordNumber != null && RecordNumber != '')) {
                    Searchstring+=' and ';
                }
                If(CurrentStatus == 'Any') {
                    Searchstring +=' (Status__c =: DraftStatus OR  Status__c =:Submittedstatus)'; 
                }
                else if (CurrentStatus == 'Completed'){
                    Searchstring +=' Status__c =: Submittedstatus '; 
                }
                else {
                    Searchstring +=' Status__c =: CurrentStatus ';     
                }
            } 
            
            if(SensitiveLevel != null && SensitiveLevel != '') {
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                (Purpose != null && Purpose != '') || (RecordNumber != null && RecordNumber != '') || (CurrentStatus != null && CurrentStatus != '')) {
                    Searchstring+=' and ';
                }
                If(SensitiveInfo == 'Any') {
                        Searchstring +='(Sensitive__c = '+true+' OR Sensitive__c = '+false+')'; 
                }
                else if (SensitiveInfo == 'Sensitive Information'){
                    Searchstring +=' Sensitive__c = '+true+''; 
                }
                else {
                    Searchstring +=' Sensitive__c = '+false+'';     
                }
                               
            } 
            
            if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                (Purpose != null && Purpose != '') || (RecordNumber != null && RecordNumber != '') || (CurrentStatus != null && CurrentStatus != '') || 
                (SensitiveLevel != null && SensitiveLevel != '')) {
                Searchstring+=' ORDER BY createddate DESC Limit 1000';
            }
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
            
            Search_VOC_List = Database.Query(Searchstring);  
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Search_VOC_List); 
            system.debug('$$$$$$$$$$$$$$$$$$$$'+ProductFamily);
            return Search_VOC_List;    
        }
        
        }
        catch (system.typeexception t) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like some of the values you entered were incorrect. Please try again.'));
            return null;
        }  
        catch (QueryException q) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. We could not process your request. Please try again or contact your administrator.'));
            return null;    
        } 
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like something went wrong. Please try again or contact your administrator.'));
            return null;    
        }   
    }
    
    public void processSelected() {
        List<VOC_Save_Search__c> selectedRecords = new List<VOC_Save_Search__c>();
        for(vocWrapper cvoc: getsave_Search()) {
            if(cvoc.selected == true) {
                selectedRecords.add(cvoc.voc);
            }
        }
        if(selectedrecords.size() == 0) {
         //   SaveSearch();        
        }
        else if(Selectedrecords.size() > 1) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select any one of the saved searches.'));    
        }
        else {
            for(VOC_Save_Search__c voc: selectedRecords) {
                voc.Search_Name__c = Save_Search_Name;   
            }
            update selectedRecords;      
            Saved_VOC_List = null;
        }
    }
    @RemoteAction
    Public static string SaveSearch(string ssid, string searchName, string Searchtext, string FromDate, string ToDate, string CustomerNameTitle, string AccountName, string HonLead, string ProductFamily, string VOCTitle, string Purpose, string RecordNumber, string CurrentStatus, string SensitiveLevel) {        
        VOC_Save_Search__c Ins_save_Search = new VOC_Save_Search__c();
        id UID = userinfo.getuserId();
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ searchName '+searchName);
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ ssid '+ssid); 
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ SensitiveLevel'+SensitiveLevel);
        if((ssid != null && ssid != '') && (searchName != null && searchName != '')) {
            VOC_Save_Search__c savesearchObject = [select id,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c,VOC_Title_Collection__c from VOC_Save_Search__c where id =:ssid limit 1];
            savesearchObject.Search_Name__c = searchName;
            savesearchObject.Keyword__c = Searchtext;
            savesearchObject.Customer_Name__c = CustomerNameTitle;
            savesearchObject.Account_name__c = AccountName;
            savesearchObject.Honeywell_Lead__c = HonLead;
            savesearchObject.Product_Line__c = ProductFamily;
            savesearchObject.Date_Range_From__c = string.valueOf(FromDate);
            savesearchObject.Date_Range_To__c = string.valueOf(ToDate);
            savesearchObject.VOC_Title_Collection__c = VOCTitle;
            savesearchObject.VOC_Purpose__c = Purpose;
            savesearchObject.Record_Number__c = RecordNumber;
            savesearchObject.Current_Status__c = CurrentStatus;
            savesearchObject.Sensitivity_Level__c = SensitiveLevel;
            update savesearchObject;
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ savesearchObject '+savesearchObject);
            return null;
        }
        else { 
            if(Searchtext != '' && Searchtext != null) {
                Ins_save_Search.Keyword__c = Searchtext;    //.replaceAll('%','')
            }
            if(CustomerNameTitle != '' && CustomerNameTitle != null) {
                Ins_save_Search.Customer_Name__c = CustomerNameTitle;
            }
            if(AccountName != '' && AccountName != null) {
                Ins_save_Search.Account_name__c = AccountName;
            }
            if(HonLead !='' && HonLead != null) {
                Ins_save_Search.Honeywell_Lead__c = HonLead;
            }
            if(ProductFamily != '' && ProductFamily != null) {
                Ins_save_Search.Product_Line__c = ProductFamily.replaceAll('%','');
            } 
            if(VOCTitle !='' && VOCTitle != null) {
                Ins_save_Search.VOC_Title_Collection__c = VOCTitle;
            }  
            if(Purpose !='' && Purpose != null) {
                Ins_save_Search.VOC_Purpose__c = Purpose;
            }
            if(RecordNumber !='' && RecordNumber != null) {
                Ins_save_Search.Record_Number__c = RecordNumber;
            }
            if(CurrentStatus !='' && CurrentStatus != null) {
                Ins_save_Search.Current_Status__c = CurrentStatus;
            }
            if(SensitiveLevel !='' && SensitiveLevel != null) {
                Ins_save_Search.Sensitivity_Level__c = SensitiveLevel;
            }
            if(FromDate != '' && FromDate != null) {
               // Ins_save_Search.Date_Range_From__c = FromDate; //string.valueOf(FromDate);
                
                if(FromDate.contains('-')) {
                    string Fromdatestring = FromDate.Replace('-','/');
                    Ins_save_Search.Date_Range_From__c = Fromdatestring;
                    system.debug('88888888888888888888888888'+Fromdatestring);
                }
                else {
                    Ins_save_Search.Date_Range_From__c = string.valueOf(FromDate); 
                    system.debug('88888888888888888888888888'+Ins_save_Search.Date_Range_From__c);   
                }
                
            } 
            if(ToDate != '' && ToDate != null) {
                Ins_save_Search.Date_Range_To__c = ToDate; // string.valueOf(ToDate);
           }      
           if(searchName != null && searchName != '') {
                Ins_save_Search.Search_Name__c = searchName;
                List<VOC_Save_Search__c> searchNameList = new List<VOC_Save_Search__c>();
                List<VOC_Save_Search__c> savesearchObjectList = [select id,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c,VOC_Title_Collection__c from VOC_Save_Search__c where Search_Name__c =: searchName and createdbyid =: UID limit 1000];
                for (VOC_Save_Search__c ss: savesearchObjectList) {
                    if(ss.Search_Name__c == searchName) {
                        searchNameList.add(ss);
                    }
                }
                if(searchNameList.size() >0) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Search Name already exists. Please enter a different one.'));    
                    return null;    
                }
                else {
                    insert Ins_save_Search;    
                }
            }            
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ Ins_save_Search '+Ins_save_Search);
            return string.valueOf(Ins_save_Search.id);
        }
    }
    
    @RemoteAction
    Public static void UpdateSearch(string ssid, string searchName, string Searchtext, string FromDate, string ToDate, string CustomerNameTitle, string AccountName, string HonLead, string retId, string ProductFamily) {        
        VOC_Save_Search__c Ins_save_Search = new VOC_Save_Search__c();
        id UID = userinfo.getuserId();
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ searchName '+searchName);
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ ssid '+ssid);
        retId = null;
        if((ssid != null && ssid != '') && (retId == null)) {
            VOC_Save_Search__c savesearchObject = [select id,Keyword__c,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c from VOC_Save_Search__c where  id =:ssid limit 1];
            if (searchName != '' && searchName != null) {
                savesearchObject.Search_Name__c = searchName;
            }
            if(Searchtext != '' && Searchtext != null) {
                savesearchObject.Keyword__c = Searchtext;
            }
            if(CustomerNameTitle != '' && CustomerNameTitle != null) {
                savesearchObject.Customer_Name__c = CustomerNameTitle;
            }
            if(AccountName != '' && AccountName != null) {
                savesearchObject.Account_name__c = AccountName;
            }
            if(HonLead !='' && HonLead != null) {
                savesearchObject.Honeywell_Lead__c = HonLead;
            }
            if(ProductFamily != '' && ProductFamily != null) {
                savesearchObject.Product_Line__c = ProductFamily;
            }
            if(FromDate != '' && FromDate != null) {
                if(FromDate.contains('/')) {
                    string Fromdatestring = FromDate.Replace('/','-');
                    savesearchObject.Date_Range_From__c = Fromdatestring;
                    system.debug('88888888888888888888888888'+Fromdatestring);
                }
                else {
                    savesearchObject.Date_Range_From__c = string.valueOf(FromDate); 
                    system.debug('88888888888888888888888888'+savesearchObject.Date_Range_From__c);   
                }
                
                
            }
            if(ToDate != '' && ToDate != null) {
                savesearchObject.Date_Range_To__c = string.valueOf(ToDate);
            }
            update savesearchObject;
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ savesearchObject '+savesearchObject);
        }
        else if (retId != null && retId != '') {
            VOC_Save_Search__c savesearchObject = [select id,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c from VOC_Save_Search__c where id =:retId limit 1];
            if (searchName != '' && searchName != null) {
                savesearchObject.Search_Name__c = searchName;
            }
            if(Searchtext != '' && Searchtext != null) {
                savesearchObject.Keyword__c = Searchtext;
            }
            if(CustomerNameTitle != '' && CustomerNameTitle != null) {
                savesearchObject.Customer_Name__c = CustomerNameTitle;
            }
            if(AccountName != '' && AccountName != null) {
                savesearchObject.Account_name__c = AccountName;
            }
            if(HonLead !='' && HonLead != null) {
                savesearchObject.Honeywell_Lead__c = HonLead;
            }
            if(ProductFamily != '' && ProductFamily != null) {
                savesearchObject.Product_Line__c = ProductFamily;
            }
            if(FromDate != '' && FromDate != null) {
                savesearchObject.Date_Range_From__c = string.valueOf(FromDate);
            }
            if(ToDate != '' && ToDate != null) {
                savesearchObject.Date_Range_To__c = string.valueOf(ToDate);
            }
            update savesearchObject;
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ savesearchObject '+savesearchObject);    
        }
        else { //if(ssid == '') 
            if(Searchtext != '' && Searchtext != null) {
                Ins_save_Search.Keyword__c = Searchtext;    //.replaceAll('%','')
            }
            if(CustomerNameTitle != '' && CustomerNameTitle != null) {
                Ins_save_Search.Customer_Name__c = CustomerNameTitle;
            }
            if(AccountName != '' && AccountName != null) {
                Ins_save_Search.Account_name__c = AccountName;
            }
            if(HonLead !='' && HonLead != null) {
                Ins_save_Search.Honeywell_Lead__c = HonLead;
            }
            if(ProductFamily != '' && ProductFamily != null) {
                Ins_save_Search.Product_Line__c = ProductFamily.replaceAll('%','');
            }   
            if(FromDate != '' && FromDate != null) {
              //  Ins_save_Search.Date_Range_From__c = FromDate; //string.valueOf(FromDate);
               
                if(FromDate.contains('-')) {
                    string Fromdatestring = FromDate.Replace('-','/');
                    Ins_save_Search.Date_Range_From__c = Fromdatestring;
                    system.debug('88888888888888888888888888'+Fromdatestring);
                }
                else {
                    Ins_save_Search.Date_Range_From__c = string.valueOf(FromDate); 
                    system.debug('88888888888888888888888888'+Ins_save_Search.Date_Range_From__c);   
                }
                
            } 
            if(ToDate != '' && ToDate != null) {
                Ins_save_Search.Date_Range_To__c = ToDate; // string.valueOf(ToDate);
           }  
           if (searchName != '' && searchName != null) {  
               Ins_save_Search.Search_Name__c = searchName;
           }
            insert Ins_save_Search;
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@ Ins_save_Search '+Ins_save_Search);
        }
    }
    
    @remoteAction
    Public static List<Voice_of_Customer__c>fetchSaveSearch(string ssid) {
        try {
            id usrid = userinfo.getUserId(); 
        List<Voice_of_Customer__c> Search_VOC_List = new List<Voice_of_Customer__c>();
            if (ssid != null) {
                VOC_Save_Search__c ss = [select id,Keyword__c,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c,VOC_Title_Collection__c,VOC_Purpose__c,Sensitivity_Level__c,Record_Number__c,Current_Status__c from VOC_Save_Search__c where id =:ssid];
                if(ss != null) {          
                String Searchtext = string.valueOf(ss.Keyword__c);
                String FromDate=  SS.Date_Range_From__c;
                String ToDate= SS.Date_Range_To__c;
                String CustomerNameTitle= string.valueOf(SS.Customer_Name__c); 
                String AccountName = string.valueOf(SS.Account_name__c);
                String HonLead = string.valueOf(SS.Honeywell_Lead__c);
                String ProductFamily = string.valueOf(SS.Product_Line__c); 
                String VOCTitle = string.valueOf(SS.VOC_Title_Collection__c);
                String RecordNumber = string.valueOf(SS.Record_Number__c);
                String CurrentStatus= string.valueOf(SS.Current_Status__c);
                String SensitivityLevel = string.valueOf(SS.Sensitivity_Level__c);
                String Purpose = string.valueOf(SS.VOC_Purpose__c);
                string SS_Product_Line;
                date SS_StartDate;
                date SS_EndDate;  
               // string recStatus = 'Submitted';         
                string Searchstring = 'select Id,createddate,VOC__c,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Product_Family__c,Sensitive__c,Account__c,Enddate__c,Startdate__c,Created_By_Name__c,Honeywell_Lead__c,Status__c,RecordTypeId,Honeywell_Lead_Formula__c,Pre_Draft__c from Voice_of_Customer__c';            
                string Keyword = '%'+Searchtext+'%'; 
                string Startdate = FromDate; 
                system.debug('888888888888888888888888888888Startdate '+Startdate);
                system.debug('888888888888888888888888888888FromDate '+FromDate);
                string EndDate = ToDate; //Search_EndDate
                string CustomerName= '%'+CustomerNameTitle+'%';
                string OEM_Account= '%'+AccountName+'%'; 
                string Honeywell_Lead = '%'+HonLead+'%'; 
                string Product_Line = ProductFamily;  
                string VOC_Title = '%'+VOCTitle+'%'; 
                string Record_Number = '%'+RecordNumber+'%';
                string Current_Status = CurrentStatus;
                string Sensitivity_Level = SensitivityLevel;
                string VOC_Purpose = Purpose;
                string Draftstatus ='Draft';
                string Submittedstatus = 'Submitted'; 
                // Added for M&PM filter
                Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                if(profileName.contains('System Administrator')) {
                    if(Searchtext != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                        AccountName != null || HonLead != null || ProductFamily != null || VOCTitle != null || RecordNumber != null
                        || CurrentStatus != null || SensitivityLevel != null || Purpose != null) {
                        SearchString+=' where Pre_Draft__c = false and ';    
                    }
                }
                else {
                    user usrquery = [select id,contactId from user where id =: usrid limit 1];
                    system.debug('++++++++++++++++++++++++++++++++++++++'+usrquery);
                    contact con = [select id,Employee_Contact_SBU__c from Contact where id =:usrquery.ContactId limit 1]; 
                    system.debug('++++++++++++++++++++++++++++++++++++++'+con);   
                    if(Searchtext != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                        AccountName != null || HonLead != null || ProductFamily != null || VOCTitle != null || RecordNumber != null
                        || CurrentStatus != null || SensitivityLevel != null || Purpose != null) {
                        if(con.Employee_Contact_SBU__c == 'M&PM') {
                            SearchString+=' where Pre_Draft__c = false and ';
                        }
                        else {
                            SearchString+=' where ((Pre_Draft__c = false and Sensitive__c = false)  OR (Pre_Draft__c = false and CreatedbyID =:usrid)) and ';    
                        }    
                    }
                }
                
                
              /*  if(Searchtext != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                AccountName != null || HonLead != null || ProductFamily != null) {
                    SearchString+=' where Pre_Draft__c = false and ';
                } */
                if(Searchtext != null && Searchtext != '') {
                    Searchstring +=' (Company_Name__c like: Keyword OR VOC_Collection__c like: Keyword OR VOC_Title__c like:Keyword OR Product_Name__c like:Keyword OR VOC__c like: keyword) '; //OR Name like: keyword
                    system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+Keyword );
                }
                if(CustomerNameTitle != null && CustomerNameTitle != '') {
                    if(Searchtext != null && Searchtext != '') {
                        Searchstring+=' and ';
                    }
                    List<id> Custlist = new List<id>();
                    List<VOC_Customer_Name__c> CustomerList = [select Id, Customer_Name__c,VOC_Record__c,Customer_s_Title_Role__c from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ Customer_Name__c like : CustomerName OR Customer_s_Title_Role__c like : CustomerName Limit 1000];
                    for (VOC_Customer_Name__c c: CustomerList) {
                        Custlist.add(c.VOC_Record__c);    
                    }
                    Searchstring +=' id in: Custlist';
                    //Searchstring +=' Customer_Participant_Name__c  like: CustomerName';
                }
                
                if(AccountName != null && AccountName != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '')) {
                        Searchstring+=' and ';
                    }
                    List<id> CustAccountlist = new List<id>();
                    List<VOC_Customer_Name__c> CustomerAccountList = [select Id, Customer_Name__c,VOC_Record__c,VOC_Account__c,VOC_Account__r.name from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ VOC_Account__r.name like : OEM_Account Limit 1000];
                    for (VOC_Customer_Name__c c: CustomerAccountList) {
                        CustAccountlist.add(c.VOC_Record__c);    
                    }
                    Searchstring +=' id in: CustAccountlist';
                    //Searchstring +=' VOC_Account__r.name  like: OEM_Account ';  
                }
                
                if(HonLead != null && HonLead != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '')) {
                        Searchstring+=' and ';
                    }
                    Searchstring +=' ( Honeywell_Lead__c  like: Honeywell_Lead OR Honeywell__r.Name like: Honeywell_Lead ) ';  
                }
                
                if(ProductFamily != null && ProductFamily != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && HonLead != '')) {
                        Searchstring+=' and ';
                    }
                    
                    string[] prodFamily = Product_Line.split(',');
                    string prodFamilyString='';
                    for(string prdo :  prodFamily){
                        prodFamilyString += '\''+prdo +'\',';
                    }
                    
                    prodFamilyString = prodFamilyString.substring(0,prodFamilyString.length() - 1);
                    Searchstring +=' Product_Family__c INCLUDES (' + prodFamilyString +')';
                    
                  //  Searchstring +=' Product_Family__c INCLUDES ' + Product_Line.split(';') + '';                            // like: Product_Line ';  
                }
                
                if(FromDate != null && FromDate != '') {
                system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'+FromDate);
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '')) {
                        Searchstring+=' and ';
                    }
                    date STD = Date.parse(StartDate);
                    Searchstring +=' createddate  >=: STD'; 
                    SS_StartDate = STD;
                }
                
                if(ToDate != null && ToDate != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '')) {
                        Searchstring+=' and ';
                    }
                    
                    string timestr = ' 11:59 PM';
                    string enddatetime = EndDate+timestr;
                    datetime NTD = Datetime.parse(enddatetime);
                    
                   // date NTD = Date.parse(EndDate);
                    Searchstring +=' Createddate <=: NTD '; 
                   // SS_EndDate = NTD;
                }
                
                if(VOCTitle != null && VOCTitle != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '')) {
                        Searchstring+=' and ';
                    }
                    Searchstring +=' ( VOC_Title__c  like: VOC_Title OR VOC_Collection__c like: VOC_Title ) ';  
                }
                
                if(RecordNumber != null && RecordNumber != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '')) {
                        Searchstring+=' and ';
                    }
                    Searchstring +=' VOC__c  like: Record_Number ';  
                }
                
                if(CurrentStatus != null && CurrentStatus != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                    (RecordNumber != null && RecordNumber != '')) {
                        Searchstring+=' and ';
                    }
                    If(CurrentStatus == 'Any') {
                        Searchstring +=' (Status__c =: DraftStatus OR  Status__c =:Submittedstatus)'; 
                    }
                    else if (CurrentStatus == 'Completed'){
                        Searchstring +=' Status__c =: Submittedstatus '; 
                    }
                    else {
                        Searchstring +=' Status__c =: CurrentStatus ';     
                    } 
                }
                
                if(SensitivityLevel != null && SensitivityLevel != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                    (RecordNumber != null && RecordNumber != '') || (CurrentStatus != null && CurrentStatus != '')) {
                        Searchstring+=' and ';
                    }
                
                    If(SensitivityLevel == 'Any') {
                        Searchstring +='(Sensitive__c = '+true+' OR Sensitive__c = '+false+')'; 
                    }
                    else if (SensitivityLevel == 'Sensitive Information'){
                        Searchstring +=' Sensitive__c = '+true+''; 
                    }
                    else {
                        Searchstring +=' Sensitive__c = '+false+'';     
                    }     
                }
                
                if(Purpose != null && Purpose != '') {
                    if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || 
                    (RecordNumber != null && RecordNumber != '') || (CurrentStatus != null && CurrentStatus != '') || (SensitivityLevel != null && SensitivityLevel != '')) {
                        Searchstring+=' and ';
                    }
                    
                    string[] SavePurpose = VOC_Purpose.split(',');
                    string PurposeString='';
                    for(string prdo :  SavePurpose){
                        PurposeString += '\''+prdo +'\',';
                    }
                    
                    PurposeString = PurposeString.substring(0,PurposeString.length() - 1);
                    Searchstring +=' Purpose_of_this_VOC__c INCLUDES (' + PurposeString +')'; 
                }   
                
                if((Searchtext != null && Searchtext != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (VOCTitle != null && VOCTitle != '') || (RecordNumber != null && RecordNumber != '') ||
                 (CurrentStatus != null && CurrentStatus != '') || (SensitivityLevel != null && SensitivityLevel != '')) {
                    Searchstring+=' ORDER BY createddate DESC Limit 1000 ';
                }
                
                system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
                Search_VOC_List = Database.Query(Searchstring);  
                system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
                system.debug('$$$$$$$$$$$$$$$$$$$$'+Search_VOC_List); 
                }               
            }  
            return Search_VOC_List;          
            }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like something went wrong. Please try loading the page again or contact your administrator.'));    
            return null;
        }
    }
    
    public class vocWrapper {
        public VOC_Save_Search__c voc{get; set;}
        public Boolean selected {get; set;}
        public vocWrapper(VOC_Save_Search__c s) {
            voc = s;
            selected = false;
        }       
    }
    
    
    
    @RemoteAction
    public static List<SelectOption> getProductLine() {
        List<SelectOption> options = new List<SelectOption>();    
     //   List<VOC_Product_Family__c> ProductList = [Select id,name,Product_Line__c from VOC_Product_Family__c]; 
      //  List<string> ProductFamilyList = new List<string>();
     //   for (VOC_Product_Family__c v : ProductList) {
     //       ProductFamilyList.add(v.Product_Line__c);    
     //   }
        
       // for (string s: ProductFamilyList)  {
       ///     options.add(new SelectOption(s,s));
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Product_Family__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
       // system.debug(options);
        return options;
    }
    
    @RemoteAction
    public static List<VOC_Save_Search__c>getsavedSearches() {
        id uid = userinfo.getuserId();
        List<VOC_Save_Search__c> savedSearchList = [select id,Keyword__c,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c from VOC_Save_Search__c where createdbyId =:uid ORDER BY createddate DESC limit 5];    
        return savedSearchList;
    }
    
    @RemoteAction
    public static PageReference sendPdf(string expid, string usermail) {

    PageReference xls= Page.VOC_Email_to_pdf;
    // add parent id to the parameters for standardcontroller
    xls.getParameters().put('id',expid);

    // the contents of the attachment from the pdf
    Blob body;

    try {

      // returns the output of the page as a PDF
      body = xls.getContent(); 
    } catch (VisualforceException e) {
      body = Blob.valueOf('Error');
    }

    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    // attach.setContentType('application/pdf');
    attach.setFileName('VOC Record.xls');
    attach.setInline(false);
    attach.Body = body;

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    mail.setToAddresses(new String[] {usermail});
    mail.setSubject('VOC Record details');
    mail.setHtmlBody('Here is the email you requested.');
    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 

    // Send the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    return null;

  }
  
   @RemoteAction
    public static Voice_of_Customer__c getMyVOCDetails(string recId){
        
        Voice_of_Customer__c VOCList = [select Id,Name,Purpose_of_this_VOC__c,
                        VOC__c,VOC_Date__c,VOC_Title__c,Honeywell__c,Honeywell_Lead__c,Sensitive__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,createdBy.Name,CreatedDate,
                        Platform__r.Name,Platform_Formula__c,Product_Family__c,Financial_Implications__c,Key_Action_Items__c,Honeywell_Lead_Formula__c,External_Links__c, (select id,Customer_Name__c,Customer_s_Title_Role__c, Company_Name__c, Primary_Customer_s_Email__c, VOC_Account__r.Name from VOC_Customer_Names__r),(select id, name from Attachments) from Voice_of_Customer__c where Id =: recId limit 1000];
        return VOCList;                    
    }
    
    @RemoteAction
    Public static void DeleteSearch(string ssid) {
        List<VOC_Save_Search__c> savedSearchrec = [select id,Keyword__c,Search_Name__c,Product_Line__c,Honeywell_Lead__c,Date_Range_From__c,Date_Range_To__c,Customer_Name__c,Account_name__c from VOC_Save_Search__c where id =:ssid];
        if(savedSearchrec.size()>0) {
            delete savedSearchrec;
        }    
    }
    
    
    @RemoteAction
    public static List<Voice_of_Customer__c> SliderSearch_VOC(string Searchtext) {
         try {
            //************** Re declaring variables start************************* //
            List<Voice_of_Customer__c> Search_VOC_List = new List<Voice_of_Customer__c>();          
            string Search_Keyword;   
            string Searchstring = 'select Id,VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Product_Family__c,Sensitive__c,VOC_Account__c,Enddate__c,Startdate__c,Created_By_Name__c,Status__c,Honeywell_Lead__c,Honeywell_Lead_Formula__c from Voice_of_Customer__c';            
            String Keyword = '%'+Searchtext+'%'; //Search_Keyword 
               
            if(Searchtext != null) {
                SearchString+=' where ';
            }
            if(Searchtext != null && Searchtext != '') {
                Searchstring +=' (Company_Name__c like: Keyword OR VOC_Collection__c like: Keyword OR VOC_Title__c like:Keyword OR Product_Name__c like:Keyword OR VOC__c like: keyword) ORDER BY createddate DESC Limit 1000 '; //Name like: keyword OR
            }
            Search_VOC_List = Database.Query(Searchstring);  
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Search_VOC_List);
            return Search_VOC_List;
        }
        catch (system.typeexception t) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like some of the values you entered were incorrect. Please try again.'));
            return null;
        }  
        catch (QueryException q) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. We could not process your request. Please try again or contact your administrator.'));
            return null;    
        } 
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like something went wrong. Please try again or contact your administrator.'));
            return null;    
        }     
    }
    
    @RemoteAction
    public static List<SelectOption> getPurpose() {
        List<SelectOption> options = new List<SelectOption>();    
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Purpose_of_this_VOC__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
}