public with sharing class OVOC_myVOC_Controller {

    public static List<Voice_of_Customer__c> vocMainList{get;set;}
    public List<Voice_of_Customer__c> vocMainListForPage{get;set;}
    public List<ProductWrapper> ProductWrapperList{get; set;}
    public List<ProductWrapper> PurposeWrapperList{get; set;}
    
    public void getProdList(){
        ProductWrapperList = new List<ProductWrapper> (); 
        List<string> ProductFamilyList = new List<string>();
        List<SelectOption> options = new List<SelectOption>();
    /*    List<VOC_Product_Family__c> ProductList = [Select id,name,Product_Line__c from VOC_Product_Family__c];
        for (VOC_Product_Family__c v : ProductList) {
            ProductFamilyList.add(v.Product_Line__c);    
        }
        for (string s: ProductFamilyList)  {
            options.add(new SelectOption(s,s)); 
            ProductWrapper prodLine =  new ProductWrapper();
            prodLine.pickListEntry = s;  
            ProductWrapperList.add(prodLine);          
        }
     */         
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Product_Family__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
           ProductWrapper prodLine =  new ProductWrapper();
           prodLine.pickListEntry = f.getValue();
           
           ProductWrapperList.add(prodLine);
        }         
    }
    
    public void getPurposeList(){
        PurposeWrapperList = new List<ProductWrapper> (); 
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Purpose_of_this_VOC__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
           ProductWrapper purpose =  new ProductWrapper();
           purpose.pickListEntry = f.getValue();
           
           PurposeWrapperList.add(purpose);
        }         
    }
    
    public OVOC_myVOC_Controller(){
        getProdList();
        getPurposeList();
        ReportMail = false;
    }
    
    public class ProductWrapper{
        public string pickListEntry{get;set;}
        public  boolean checked{get;set;}
        public ProductWrapper(){
            pickListEntry = null;
            checked = false;
        }
    }
    
    @RemoteAction
    public static List<Voice_of_Customer__c> getMyVOCRecords(string status){
        
        List<Voice_of_Customer__c> VOCList;
        Id uid = userinfo.getuserId();
        
        VOCList = [select Id,Name,Status__c, VOC_Type__c, Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,
                        Security_Group__c,VOC__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,
                        Platform__c,Platform_Formula__c, Product_Family__c,Sensitive__c,Account__c,Enddate__c,Startdate__c,CreatedById, CreatedDate,Honeywell_Lead__c,Honeywell_Lead_Formula__c,External_Links__c,Pre_Draft__c from Voice_of_Customer__c where createdbyId =:uid and status__c =: status and Pre_Draft__c =false order by Lastmodifieddate DESC Limit 1000]; // Querying VOC records
        system.debug('VOCList--->' + VOCList.size());                
        return VOCList;                    
    }
    
    @RemoteAction
    public static Voice_of_Customer__c getMyVOCDetails(string recId){
        
        Voice_of_Customer__c VOCList = [select Id,Name,Purpose_of_this_VOC__c,
                        VOC__c,VOC_Date__c,VOC_Title__c,Honeywell__c,Honeywell_Lead__c,Sensitive__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,createdBy.Name,CreatedDate,
                        Platform__r.Name,Platform_Formula__c,Product_Family__c,Financial_Implications__c,Key_Action_Items__c,Honeywell_Lead_Formula__c,External_Links__c, (select id,Customer_Name__c,Customer_s_Title_Role__c, Company_Name__c, Primary_Customer_s_Email__c, VOC_Account__r.Name from VOC_Customer_Names__r),(select id, name from Attachments) from Voice_of_Customer__c where Id =: recId limit 1000];
        return VOCList;                    
    }
    
    @RemoteAction
    public static List<SelectOption> getProductLine() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Product_Family__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    @RemoteAction
    public static List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();       
        Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple) {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        system.debug(options);
        return options;
    }
    
    @RemoteAction
    public static List<SelectOption> getPurpose() {
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
    public static List<Voice_of_Customer__c> QueryRecords(string RecordNumber, string CurrentStatus, String SensitiveLevel, string FromDate, string ToDate, string CustomerNameTitle, string AccountName, string HonLead, string ProductFamily, string VOCPurpose, string OrderByValue) { 
        
        system.debug('in action');
        try {
            List<Voice_of_Customer__c> Search_voc = new List<Voice_of_Customer__c>();
            List<Voice_of_Customer__c> Search_VOC_List = new List<Voice_of_Customer__c>();
            
            string Searchstring = 'select Id,VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Product_Family__c,Sensitive__c,Account__c,Enddate__c,Startdate__c,Honeywell_Lead__c from Voice_of_Customer__c';            
            String RecNum = '%'+RecordNumber+'%'; 
            String CurStat = CurrentStatus;
            string Startdate = FromDate; 
            String EndDate = ToDate; 
            String CustomerName= '%'+CustomerNameTitle+'%'; 
            String OEM_Account= '%'+AccountName+'%'; 
            String Honeywell_Lead = '%'+HonLead+'%'; 
            String Product_Line = ProductFamily;   
            String Purpose = VOCPurpose;
            String SensitiveInfo = SensitiveLevel; 
            string Draftstatus ='Draft';
            string Submittedstatus = 'Submitted';
            id usrid = userinfo.getUserId();   
            if(RecordNumber != null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                AccountName != null || HonLead != null || ProductFamily != null || CurrentStatus != null || VOCPurpose != null) {
                SearchString+=' where ';
            }
            if(RecordNumber != null && RecordNumber != '') {
                Searchstring +=' VOC__c like: RecNum ';
            }
            if(CustomerNameTitle != null && CustomerNameTitle != '') {
                if(RecordNumber != null && RecordNumber != '') {
                    Searchstring+=' and ';
                }
                List<id> Custlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerList = [select Id, Customer_Name__c,VOC_Record__c,Customer_s_Title_Role__c from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ Customer_Name__c like : CustomerName OR Customer_s_Title_Role__c like : CustomerName];
                for (VOC_Customer_Name__c c: CustomerList) {
                    Custlist.add(c.VOC_Record__c);    
                }
                Searchstring +=' id in: Custlist';
            }
            
            if(AccountName != null && AccountName != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '')) {
                    Searchstring+=' and ';
                }
                List<id> CustAccountlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerAccountList = [select Id, Customer_Name__c,VOC_Record__c,VOC_Account__c,VOC_Account__r.name from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ VOC_Account__r.name like : OEM_Account];
                for (VOC_Customer_Name__c c: CustomerAccountList) {
                    CustAccountlist.add(c.VOC_Record__c);    
                }
                Searchstring +=' id in: CustAccountlist';
                
               // Searchstring +=' VOC_Account__r.name  like: OEM_Account ';  
            }
            
            if(HonLead != null && HonLead != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '')) {
                    Searchstring+=' and ';
                }
                Searchstring +=' ( Honeywell_Lead__c  like: Honeywell_Lead OR Honeywell__r.Name like: Honeywell_Lead ) ';  // Changed from Honeywell__r.Name
            }
            
            if(ProductFamily != null && ProductFamily != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && HonLead != '')) {
                    Searchstring+=' and ';
                }
                
                string[] prodFamily = Product_Line.split(';');
                string prodFamilyString='';
                for(string prdo :  prodFamily){
                    prodFamilyString += '\''+prdo +'\',';
                }
                prodFamilyString = prodFamilyString.substring(0,prodFamilyString.length() - 1);
                Searchstring +=' Product_Family__c INCLUDES (' + prodFamilyString +')'; 
            }
            
            if(FromDate != null && FromDate != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '')) {
                    Searchstring+=' and ';
                }
                date STD = Date.parse(StartDate);
                Searchstring +=' createddate  >=: STD'; 
            }
            
            if(ToDate != null && ToDate != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '')) {
                    Searchstring+=' and ';
                }
                //date NTD = Date.parse(EndDate);
                string timestr = ' 11:59 PM';
                string enddatetime = EndDate+timestr;
                datetime NTD = Datetime.parse(enddatetime);
                system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'+enddatetime);
                system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'+NTD);
                Searchstring +=' lastmodifieddate <=: NTD '; 
            }
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CurStat '+CurStat);
            if(CurrentStatus != null && CurrentStatus != '') { 
                    if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '')) {
                        Searchstring+=' and ';
                    }
                    If(CurrentStatus == 'Any') {
                        Searchstring +=' (Status__c =: Draftstatus OR  Status__c =: Submittedstatus )'; 
                    }
                    else if (CurrentStatus == 'Completed'){
                        Searchstring +=' Status__c =: Submittedstatus '; 
                    }
                    else {
                        Searchstring +=' Status__c =: CurrentStatus ';     
                    }
            }         
            
            if(VOCPurpose != null && VOCPurpose != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (CurrentStatus != null && CurrentStatus != '')) {
                    Searchstring+=' and ';
                }
                string[] PurposeVoc = VOCPurpose.split(';');
                string purposeString='';
                for(string prs :  PurposeVoc){
                    purposeString += '\''+prs +'\',';
                }
                purposeString = purposeString.substring(0,purposeString.length() - 1);
                Searchstring +=' Purpose_of_this_VOC__c INCLUDES (' + purposeString +')';                
            } 
            
            if(SensitiveLevel != null && SensitiveLevel != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '')) {
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
            
            if(OrderByValue != null && OrderByValue != '') {
                if((RecordNumber != null && RecordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '') || (SensitiveLevel != null && SensitiveLevel != '')) {
                    if(OrderByValue == 'RecordNumber') {
                        Searchstring +=' ORDER BY VOC__c DESC Limit 1000';    
                    }
                    else if(OrderByValue == 'Status') {
                        Searchstring +=' ORDER BY Status__c,VOC_Date__c ASC Limit 1000';    
                    }
                    else if(OrderByValue == 'Date') {
                        Searchstring +=' ORDER BY createddate DESC Limit 1000';    
                    }
                    else if(OrderByValue == 'HoneywellLead') {
                        Searchstring +=' ORDER BY Honeywell_Lead__c,Honeywell__r.Name DESC Limit 1000 Nulls Last';  // changed from Honeywell__r.Name  
                    }
                    else if(OrderByValue == 'Acc') {
                        Searchstring +=' ORDER BY VOC_Account__c DESC Limit 1000';    
                    }
                    else if(OrderByValue == 'Sensitive') {
                        Searchstring +=' ORDER BY Sensitive__c DESC Limit 1000';    
                    }
                    else if(OrderByValue == 'ProductFamily') {
                        Searchstring +=' ORDER BY Product_Family__c DESC Limit 1000';    
                    }
                }    
            }
            
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
            Search_VOC_List = Database.Query(Searchstring);  
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Search_VOC_List); 
            system.debug('$$$$$$$$$$$$$$$$$$$$'+ProductFamily);
            system.debug('------------>' + Search_VOC_List);
            
            //vocMainListForPage = Search_VOC_List;
            
            //VOC_Report_controller exp = new VOC_Report_controller();
            //PageReference pageRef = new PageReference('apex/Test_Report');
            //exp.generateExcel(Search_VOC_List);
            //pageRef.setRedirect(true);
            return vocMainList;
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
    
    Public void Generatepage() {
        
        vocMainListForPage = vocMainList;
    }
    
    public string recordNumber{get;set;}
    //public string CurrentStatus{get;set;}
   // public string SensitiveLevel{get;set;}
    public string FromDate{get;set;}
    public string FromDate_Mob{get;set;}
    public string ToDate{get;set;}
    public string ToDate_Mob{get;set;}
    public string CustomerNameTitle{get;set;}
    public string AccountName{get;set;}
    public string HonLead{get;set;}
    public string platform{get;set;}
    public Boolean MailReport{get;set;}
    public string voctitle{get;set;}
   // public string VOCCollection{get;set;}
  //  public string ProductFamily{get;set;}
   // public string VOCPurpose{get;set;}
    //public string orderBy{get;set;}
    public string pdfORxls{get;set;}
    public string xls{get;set;}
    public boolean ReportMail{get;set;}
    string s = 'Any';
    string l = 'Any';
    string o = 'Record Number';
    public String getCurrentStatus() {
        return s;
    }                   
    public void setCurrentStatus(string s) {
        this.s = s;
    } 
    public String getSensitiveLevel() {
        return l;
    }                   
    public void setSensitiveLevel(string l) {
        this.l = l;
    }
    public String getOrderBy() {
        return o;
    }                   
    public void setOrderBy(string o) {
        this.o = o;
    } 
    
    String GenerateFormat = null; 
    
    
    public List<SelectOption> getthisformat() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('PDF','PDF')); 
        options.add(new SelectOption('XLS','XLS')); 
        return options; 
    }
                   
    public String getGenerateFormat() {
        return GenerateFormat;
    }
                    
    public void setGenerateFormat(String GenerateFormat) { 
        this.GenerateFormat = GenerateFormat; 
    }
      
    
    public PageReference setParams()
    {
        id usrid = userinfo.getUserId();
        string prodFamilyList = '';
        for(ProductWrapper prod :ProductWrapperList){
            if(prod.checked == true){
                prodFamilyList  += prod.pickListEntry+';';
            }
        }
        system.debug('----->prodFamilyList ' + prodFamilyList );
        string purposeFamilyList = '';
        for(ProductWrapper p :PurposeWrapperList){
            if(p.checked == true){
                purposeFamilyList += p.pickListEntry+';';
            }
        }
        system.debug('-----> purposeFamilyList  ' + purposeFamilyList);
        
        system.debug('prod list--->' + prodFamilyList  );
        try {
            List<Voice_of_Customer__c> Search_voc = new List<Voice_of_Customer__c>();
            List<Voice_of_Customer__c> Search_VOC_List = new List<Voice_of_Customer__c>();
            
            string Searchstring = 'select Id,(select id,Company_Name__c,Customer_s_Title_Role__c,Primary_Customer_s_Email__c,Contact__c,VOC_Record__c, Customer_name__c from VOC_Customer_Names__r),VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c, Honeywell__r.name, VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Platform__r.name,Product_Family__c,Sensitive__c,Account__c,Enddate__c,Startdate__c,Financial_Implications__c,Honeywell_Lead__c,Honeywell_Lead_Formula__c,Status__c from Voice_of_Customer__c';            
            String RecNum = '%'+recordNumber+'%'; 
            String CurrentStatus = s;
            string Startdate = FromDate; 
            string Startdate_Mob = FromDate_Mob;
            system.debug('00000000000000000000000000000ToDate0000000'+FromDate);
            String EndDate = ToDate; 
            String EndDate_Mob = ToDate_Mob;
            system.debug('00000000000000000000000000000ToDate0000000'+ToDate);
            String CustomerName= '%'+CustomerNameTitle+'%'; 
            String OEM_Account= '%'+AccountName+'%'; 
            String Honeywell_Lead = '%'+HonLead+'%'; 
            String Platform = '%'+platform+'%';
            string ProductFamily = prodFamilyList;
            String Product_Line = ProductFamily ;
            String voc_title = '%'+voctitle+'%';
           // String VOC_Collection = '%'+VOCCollection+'%'; 
            string VOCPurpose = purposeFamilyList;   
           // String Purpose = VOCPurpose;
            
            string SensitiveLevel = l;
            String SensitiveInfo = SensitiveLevel; 
            String OrderByValue = o;
            string Draftstatus ='Draft';
            string Submittedstatus = 'Submitted';
            date STD;
            datetime NTD;
            ///////////////////// system debugs////////////////////////////   
            ///////////////////// system debugs////////////////////////////
            
            // Added for M&PM filter
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            if(profileName.contains('System Administrator')) {
                if(recordNumber!= null || (FromDate != null || FromDate_Mob != null) || (ToDate != null || ToDate_Mob != null) || CustomerNameTitle != null || 
                AccountName != null || HonLead != null || ProductFamily != null || VOCPurpose != null) {
                    SearchString+=' where Pre_Draft__c = false and ';    
                }
            }
            else {
                user usrquery = [select id,contactId from user where id =: usrid limit 1];
                system.debug('++++++++++++++++++++++++++++++++++++++'+usrquery);
                contact con = [select id,Employee_Contact_SBU__c from Contact where id =:usrquery.ContactId limit 1]; 
                system.debug('++++++++++++++++++++++++++++++++++++++'+con);   
                if(recordNumber!= null || (FromDate != null || FromDate_Mob != null) || (ToDate != null || ToDate_Mob != null) || CustomerNameTitle != null || 
                    AccountName != null || HonLead != null || ProductFamily != null || VOCPurpose != null) {
                    if(con.Employee_Contact_SBU__c == 'M&PM') {
                        SearchString+=' where Pre_Draft__c = false and ';
                    }
                    else {
                        SearchString+=' where ((Pre_Draft__c = false and Sensitive__c = false) OR (Pre_Draft__c = false and CreatedbyID =:usrid)) and ';    
                    }    
                }  
            }
          /*  if(recordNumber!= null || (FromDate != null || FromDate_Mob != null) || (ToDate != null || ToDate_Mob != null) || CustomerNameTitle != null || 
                AccountName != null || HonLead != null || ProductFamily != null || VOCPurpose != null) {
                SearchString+=' where ';
            }
          */  
            if(recordNumber != null && recordNumber != '') {
                Searchstring +=' VOC__c like: RecNum ';
            }
            if(CustomerNameTitle != null && CustomerNameTitle != '') {
                if(recordNumber != null && recordNumber != '') {
                    Searchstring+=' and ';
                }
                List<id> Custlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerList = [select Id, Customer_Name__c,VOC_Record__c,Customer_s_Title_Role__c from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ Customer_Name__c like : CustomerName OR Customer_s_Title_Role__c like : CustomerName];
                for (VOC_Customer_Name__c c: CustomerList) {
                    Custlist.add(c.VOC_Record__c);    
                }
                Searchstring +=' id in: Custlist';
            }
            
            if(AccountName != null && AccountName != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '')) {
                    Searchstring+=' and ';
                }
                List<id> CustAccountlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerAccountList = [select Id, Customer_Name__c,VOC_Record__c,VOC_Account__c,VOC_Account__r.name from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ VOC_Account__r.name like : OEM_Account];
                for (VOC_Customer_Name__c c: CustomerAccountList) {
                    CustAccountlist.add(c.VOC_Record__c);    
                }
                Searchstring +=' id in: CustAccountlist';
             //   Searchstring +=' VOC_Account__r.name  like: OEM_Account ';  
            }
            
            if(HonLead != null && HonLead != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '')) {
                    Searchstring+=' and ';
                }
                Searchstring +=' ( Honeywell_Lead__c  like: Honeywell_Lead OR Honeywell__r.Name like: Honeywell_Lead ) ';   // changed from Honeywell__r.name
            }
            
            if(ProductFamily != null && ProductFamily != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && HonLead != '')) {
                    Searchstring+=' and ';
                }
                
                string[] prodFamily = Product_Line.split(';');
                string prodFamilyString='';
                for(string prdo :  prodFamily){
                    prodFamilyString += '\''+prdo +'\',';
                }
                prodFamilyString = prodFamilyString.substring(0,prodFamilyString.length() - 1);
                Searchstring +=' Product_Family__c INCLUDES (' + prodFamilyString +')'; 
            }
            
            if(FromDate != null && FromDate != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '')) {
                    Searchstring+=' and ';
                }
                STD = Date.parse(StartDate);
                Searchstring +=' createddate  >=: STD'; 
            }
            
            
            if(FromDate_Mob != null && FromDate_Mob != '') {
            system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+FromDate_Mob );
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || (FromDate != null && FromDate != '')) {
                    Searchstring+=' and ';
                }              
                    string timestr;
                    string startdatetime;
                    if(FromDate_Mob.contains('/')) {                
                       STD = Date.parse(FromDate_Mob);
                        Searchstring +=' CreatedDate >=: STD';
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@STD @@@'+ STD);
                    } 
                    else {
                        date STDM = date.valueOf(FromDate_Mob);
                        Searchstring +=' CreatedDate >=: STDM';
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@STDM@@@'+ STDM);
                    } 
            }
            
            
            if((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '')|| (FromDate_Mob != null && FromDate_Mob != ''))) {
                    Searchstring+=' and ';
                }
                
                if(ToDate != null && ToDate != '') {
                    string timestr;
                    string enddatetime;
                    timestr = ' 04:59 PM';
                    
                  //  string Enddatestring = EndDate.Replace('/','-');
                    enddatetime = Enddate+timestr;
                    NTD = datetime.parse(enddatetime);
                    system.debug('555555555555555555555555555555555555555555enddatetime  '+enddatetime);
                    system.debug('555555555555555555555555555555555555555555 NTD '+NTD);
                    Searchstring +=' createddate  <=: NTD ';
                    
                    
                }
                
                if(ToDate_Mob != null && ToDate_Mob != '') {               
                    string timestr;
                    string enddatetime;
                    if(ToDate_Mob.contains('/')) {                
                        timestr = ' 04:59 PM';
                        string Enddatestring = ToDate_Mob.Replace('/','-');
                        enddatetime = ToDate_Mob+timestr;
                        NTD = Datetime.parse(enddatetime);
                        Searchstring +=' CreatedDate <=: NTD';
                        system.debug('555555555555555555555555555555555555555555 NTD '+NTD);
                    } 
                    else {
                       // timestr = ' 04:59:59';
                        timestr = ' 16:59:59';
                        enddatetime = ToDate_Mob+timestr;
                        system.debug('555555555555555555555555555555555555555555 enddatetime  '+enddatetime);
                        datetime NTDM = datetime.valueOf(enddatetime);
                        Searchstring +=' CreatedDate <=: NTDM';
                        system.debug('555555555555555555555555555555555555555555 NTDM '+NTDM);
                    } 
                }
            }
            if(CurrentStatus != null && CurrentStatus != '') { 
                    if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    (FromDate != null && FromDate != '')  || (FromDate_Mob != null && FromDate_Mob != '')|| ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != ''))) {
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
            
            if(VOCPurpose != null && VOCPurpose != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '')) || ((ToDate != null && ToDate != '')|| (ToDate_Mob != null && ToDate_Mob != '')) || (CurrentStatus != null && CurrentStatus != '')) {
                    Searchstring+=' and ';
                }
                string[] PurposeVoc = VOCPurpose.split(';');
                string purposeString='';
                for(string prs :  PurposeVoc){
                    purposeString += '\''+prs +'\',';
                }
                purposeString = purposeString.substring(0,purposeString.length() - 1);
                Searchstring +=' Purpose_of_this_VOC__c INCLUDES (' + purposeString +')';                
            } 
            
            if(SensitiveLevel != null && SensitiveLevel != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '')) || ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '')) {
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
            if(voctitle != null && voctitle != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '')) || 
                ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || 
                (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '') ||
                (SensitiveLevel != null && SensitiveLevel != '')) {
                    Searchstring+=' and ';    
                } 
                Searchstring +=' (VOC_Title__c Like : voc_title OR VOC_Collection__c Like: voc_title) ';                
            }
            
          /*   if(VOCCollection != null && VOCCollection != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '')) || 
                ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || 
                (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '') ||
                (SensitiveLevel != null && SensitiveLevel != '') || (voctitle != null && voctitle != '')) {
                    Searchstring+=' and ';    
                } 
                Searchstring +='VOC_Collection__c Like : VOC_Collection';                
            }
            */
            
          /*  if(platform != null && platform != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '') || (ToDate != null && ToDate != '') || (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '') || (SensitiveLevel != null && SensitiveLevel != '')) {
                    Searchstring+=' and ';
                }
                Searchstring +='Platform__r.Name Like : platform';                 
            } 
            */
            if(OrderByValue != null && OrderByValue != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '')) || 
                ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || 
                (CurrentStatus != null && CurrentStatus != '') || 
                (VOCPurpose != null && VOCPurpose != '') || 
                (SensitiveLevel != null && SensitiveLevel != '')||
                (voctitle != null && voctitle != '')) {
                    if(OrderByValue == 'Record Number') {
                        Searchstring +=' ORDER BY VOC__c Limit 1000';    
                        system.debug('^^^^^^^^^^^^^^Record Number^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                    }
                    else if(OrderByValue == 'Status') {
                    system.debug('^^^^^^^^^^^^^^ Status^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY Status__c,VOC_Date__c ASC Nulls Last Limit 1000';    
                    }
                    else if(OrderByValue == 'Date') {
                    system.debug('^^^^^^^^^^^^^^Date^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY VOC_Date__c DESC Nulls Last Limit 1000';    
                    }
                    else if(OrderByValue == 'Honeywell Lead') {
                    system.debug('^^^^^^^^^^^^^^Honeywell Lead^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY Honeywell_Lead_Formula__c ASC Nulls Last Limit 1000';    //Honeywell_Lead__c,Honeywell__r.Name
                    }
                    else if(OrderByValue == 'Acc') {
                        Searchstring +=' ORDER BY Account__c Limit 1000';    
                    }
                    else if(OrderByValue == 'Sensitive') {
                    system.debug('^^^^^^^^^^^^^^Sensitive^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY Sensitive__c Limit 1000';    
                    }
                    else if(OrderByValue == 'ProductFamily') {
                        Searchstring +=' ORDER BY Product_Family__c Limit 1000';    
                    }
                }    
            }
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
            Search_VOC_List = Database.Query(Searchstring);  
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Searchstring);
            system.debug('$$$$$$$$$$$$$$$$$$$$'+Search_VOC_List.size()); 
            system.debug('$$$$$$$$$$$$$$$$$$$$'+ProductFamily);
            system.debug('------------>' + Search_VOC_List);
            
            vocMainListForPage = Search_VOC_List;
            //Mail_VOC_List = Search_VOC_List;
            ///// Testing order by Starts///////
          /*  List<id> Acclist = new List<id>();
            
            for(Voice_Of_Customer__c v: Search_VOC_List) {
                for(VOC_Customer_Name__c  c: v.VOC_Customer_Names__r){
                    Acclist.add(c.VOC_Account__r.name);    
                }
            }
           */ 
            
            ///// Testing order by Ends///////   
                     
            //VOC_Report_controller exp = new VOC_Report_controller();
            if(GenerateFormat == 'PDF') {
                PageReference pageRef = new PageReference('/apex/OVOC_Download_Pdf'); // VOC_Report_PDF
                //exp.generateExcel(Search_VOC_List);
                //pageRef.setRedirect(true);
                return pageRef;
            }
            else if (GenerateFormat == 'XLS') {
                PageReference pageRef = new PageReference('/apex/Test_Report');
                //exp.generateExcel(Search_VOC_List);
                //pageRef.setRedirect(true);
                return pageRef;    
            }
        }
        catch (system.typeexception t) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like some of the values you entered were incorrect. Please try again.'));
            system.debug(t.getmessage());
            return null;
        }  
        catch (QueryException q) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. We could not process your request. Please try again or contact your administrator.'));
            system.debug(q.getmessage());
            return null;  
              
        } 
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like something went wrong. Please try again or contact your administrator.'));
            system.debug(e.getmessage());
            return null;    
        }
        return null;
    }
    
    Public void Generatemailreport() {
        id usrid = userinfo.getUserId();
        string usermailemail = UserInfo.getUserEmail();
        string prodFamilyList = '';
        for(ProductWrapper prod :ProductWrapperList){
            if(prod.checked == true){
                prodFamilyList  += prod.pickListEntry+';';
            }
        }
        system.debug('----->prodFamilyList ' + prodFamilyList );
        string purposeFamilyList = '';
        for(ProductWrapper p :PurposeWrapperList){
            if(p.checked == true){
                purposeFamilyList += p.pickListEntry+';';
            }
        }
        system.debug('-----> purposeFamilyList  ' + purposeFamilyList);
        
        system.debug('prod list--->' + prodFamilyList  );
        try {
            List<Voice_of_Customer__c> Search_voc = new List<Voice_of_Customer__c>();
            List<Voice_of_Customer__c> Search_VOC_List = new List<Voice_of_Customer__c>();
            
            string Searchstring = 'select Id,(select id,Company_Name__c,Customer_s_Title_Role__c,Primary_Customer_s_Email__c,Contact__c,VOC_Record__c, Customer_name__c from VOC_Customer_Names__r),VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c, Honeywell__r.name, VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Platform__r.name,Product_Family__c,Sensitive__c,Account__c,Enddate__c,Startdate__c,Financial_Implications__c,Honeywell_Lead__c,Honeywell_Lead_Formula__c,Status__c from Voice_of_Customer__c';            
            String RecNum = '%'+recordNumber+'%'; 
            String CurrentStatus = s;
            string Startdate = FromDate; 
            string Startdate_Mob = FromDate_Mob;
            String EndDate = ToDate; 
            String EndDate_Mob = ToDate_Mob;
            String CustomerName= '%'+CustomerNameTitle+'%'; 
            String OEM_Account= '%'+AccountName+'%'; 
            String Honeywell_Lead = '%'+HonLead+'%'; 
            String Platform = '%'+platform+'%';
            string ProductFamily = prodFamilyList;
            String Product_Line = ProductFamily ;
            string VOCPurpose = purposeFamilyList;  
           // String Purpose = VOCPurpose;
            
            string SensitiveLevel = l;
            String SensitiveInfo = SensitiveLevel; 
            String OrderByValue = o;
            string Draftstatus ='Draft';
            string Submittedstatus = 'Submitted';
            date STD;
            datetime NTD;
            String voc_title = '%'+voctitle+'%';
           // String VOC_Collection = '%'+VOCCollection+'%';
            
            
            system.debug('//////////////////////////////////////////////RecNum '+RecNum); 
            system.debug('//////////////////////////////////////////////CurrentStatus '+CurrentStatus); 
            system.debug('//////////////////////////////////////////////Startdate '+Startdate); 
            system.debug('//////////////////////////////////////////////EndDate '+EndDate); 
            system.debug('//////////////////////////////////////////////CustomerName '+CustomerName); 
            system.debug('//////////////////////////////////////////////OEM_Account '+OEM_Account); 
            system.debug('//////////////////////////////////////////////Honeywell_Lead '+Honeywell_Lead); 
            system.debug('//////////////////////////////////////////////Platform '+Platform); 
            system.debug('//////////////////////////////////////////////ProductFamily '+ProductFamily); 
            system.debug('//////////////////////////////////////////////Product_Line '+Product_Line); 
            system.debug('//////////////////////////////////////////////VOCPurpose '+VOCPurpose);
            system.debug('//////////////////////////////////////////////SensitiveLevel '+SensitiveLevel);
            system.debug('//////////////////////////////////////////////SensitiveInfo '+SensitiveInfo);
            system.debug('//////////////////////////////////////////////OrderByValue '+OrderByValue);
            system.debug('//////////////////////////////////////////////voctitle '+voc_title);
            ///////////////////// system debugs////////////////////////////   
            ///////////////////// system debugs////////////////////////////
            
            
            // Added for M&PM filter
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            if(profileName.contains('System Administrator')) {
                if(recordNumber!= null || (FromDate != null || FromDate_Mob != null) || (ToDate != null || ToDate_Mob != null) || CustomerNameTitle != null || 
                AccountName != null || HonLead != null || ProductFamily != null || VOCPurpose != null) {
                    SearchString+=' where Pre_Draft__c = false and ';    
                }
            }
            else { 
                user usrquery = [select id,contactId from user where id =: usrid limit 1];
                system.debug('++++++++++++++++++++++++++++++++++++++'+usrquery);
                contact con = [select id,Employee_Contact_SBU__c from Contact where id =:usrquery.ContactId limit 1]; 
                system.debug('++++++++++++++++++++++++++++++++++++++'+con);   
                if(recordNumber!= null || (FromDate != null || FromDate_Mob != null) || (ToDate != null || ToDate_Mob != null) || CustomerNameTitle != null || 
                    AccountName != null || HonLead != null || ProductFamily != null || VOCPurpose != null) {
                    if(con.Employee_Contact_SBU__c == 'M&PM') {
                        SearchString+=' where Pre_Draft__c = false and ';
                    }
                    else {
                        SearchString+=' where ((Pre_Draft__c = false and Sensitive__c = false) OR (Pre_Draft__c = false and CreatedbyID =:usrid)) and ';    
                    }    
                }  
            }
            /* if(recordNumber!= null || FromDate != null || ToDate != null || CustomerNameTitle != null || 
                AccountName != null || HonLead != null || ProductFamily != null || VOCPurpose != null) {
                SearchString+=' where ';
            }
            */
            if(recordNumber != null && recordNumber != '') {
                Searchstring +=' VOC__c like: RecNum ';
            }
            if(CustomerNameTitle != null && CustomerNameTitle != '') {
                if(recordNumber != null && recordNumber != '') {
                    Searchstring+=' and ';
                }
                List<id> Custlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerList = [select Id, Customer_Name__c,VOC_Record__c,Customer_s_Title_Role__c from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ Customer_Name__c like : CustomerName OR Customer_s_Title_Role__c like : CustomerName];
                for (VOC_Customer_Name__c c: CustomerList) {
                    Custlist.add(c.VOC_Record__c);    
                }
                Searchstring +=' id in: Custlist';
            }
            
            if(AccountName != null && AccountName != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '')) {
                    Searchstring+=' and ';
                }
                List<id> CustAccountlist = new List<id>();
                List<VOC_Customer_Name__c> CustomerAccountList = [select Id, Customer_Name__c,VOC_Record__c,VOC_Account__c,VOC_Account__r.name from VOC_Customer_Name__c where /*createdbyId =:usrid AND*/ VOC_Account__r.name like : OEM_Account];
                for (VOC_Customer_Name__c c: CustomerAccountList) {
                    CustAccountlist.add(c.VOC_Record__c);    
                }
                Searchstring +=' id in: CustAccountlist';
             //   Searchstring +=' VOC_Account__r.name  like: OEM_Account ';  
            }
            
            if(HonLead != null && HonLead != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '')) {
                    Searchstring+=' and ';
                }
                Searchstring +=' ( Honeywell__r.name  like: Honeywell_Lead OR Honeywell_Lead__c like: Honeywell_Lead ) ';  
            }
            
            if(ProductFamily != null && ProductFamily != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && HonLead != '')) {
                    Searchstring+=' and ';
                }
                
                string[] prodFamily = Product_Line.split(';');
                string prodFamilyString='';
                for(string prdo :  prodFamily){
                    prodFamilyString += '\''+prdo +'\',';
                }
                prodFamilyString = prodFamilyString.substring(0,prodFamilyString.length() - 1);
                Searchstring +=' Product_Family__c INCLUDES (' + prodFamilyString +')'; 
            }
            
          /*  if(FromDate != null && FromDate != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '')) {
                    Searchstring+=' and ';
                }
                date STD = Date.parse(StartDate);
                Searchstring +=' createddate  >=: STD'; 
            }
            */
            if((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '')) {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '')) {
                    Searchstring+=' and ';
                }
                if(FromDate != null && FromDate != '') {
                    system.debug('444444444444444444444444444444444444444444 FromDate  '+FromDate);
                    STD = Date.parse(Startdate);
                    system.debug('444444444444444444444444444444444444444444 STD   '+STD );
                    Searchstring +=' createddate  >=: STD ';
                    
                }
                if(FromDate_Mob != null && FromDate_Mob != '') {               
                    string timestr;
                    string startdatetime;
                    if(FromDate_Mob.contains('/')) {                
                       // timestr = ' 11:59 PM';
                       // string Startdatestring = FromDate_Mob.Replace('/','-');
                      //  startdatetime = FromDate_Mob+timestr;
                        STD = date.parse(FromDate_Mob);
                        Searchstring +=' CreatedDate >=: STD';
                    } 
                    else {
                      //  timestr = 'T23:59:59';
                     //   startdatetime = FromDate_Mob+timestr;
                        date STDM = date.valueOf(FromDate_Mob);
                        Searchstring +=' CreatedDate >=: STDM';
                    } 
                }
            }
            
            
            
             if((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '')|| (FromDate_Mob != null && FromDate_Mob != ''))) {
                    Searchstring+=' and ';
                }
                
                if(ToDate != null && ToDate != '') {
                    string timestr;
                    string enddatetime;
                    timestr = ' 04:59 PM';
                  //  string Enddatestring = EndDate.Replace('/','-');
                    enddatetime = Enddate+timestr;
                    NTD = datetime.parse(enddatetime);
                    system.debug('555555555555555555555555555555555555555555enddatetime  '+enddatetime);
                    system.debug('555555555555555555555555555555555555555555 NTD '+NTD);
                    Searchstring +=' createddate  <=: NTD ';
                    
                    
                }
                
                if(ToDate_Mob != null && ToDate_Mob != '') {               
                    string timestr;
                    string enddatetime;
                    if(ToDate_Mob.contains('/')) {                
                        timestr = ' 04:59 PM';
                        string Enddatestring = ToDate_Mob.Replace('/','-');
                        enddatetime = ToDate_Mob+timestr;
                        NTD = Datetime.parse(enddatetime);
                        Searchstring +=' CreatedDate <=: NTD';
                    } 
                    else {
                       // timestr = ' 04:59:59'; 
                        timestr = ' 16:59:59';
                        enddatetime = ToDate_Mob+timestr;
                        datetime NTDM = datetime.valueOf(enddatetime);
                        Searchstring +=' CreatedDate <=: NTDM';
                    } 
                }
            }
            
            
            
            /*
            
            if(ToDate != null && ToDate != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                (FromDate != null && FromDate != '')) {
                    Searchstring+=' and ';
                }
                string timestr = ' 11:59 PM';
                string enddatetime = EndDate+timestr;
                datetime NTD = Datetime.parse(enddatetime);
                
                //date NTD = Date.parse(EndDate);
                system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'+enddatetime);
                system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'+NTD);
                Searchstring +=' createddate <=: NTD '; 
            }
            */
           // system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CurStat '+CurStat);
            if(CurrentStatus != null && CurrentStatus != '') { 
                    if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                    || (AccountName != null && AccountName != '') || (HonLead != null && 
                    HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                    ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '' )) || ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != ''))) {
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
            
            if(VOCPurpose != null && VOCPurpose != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '' )) || ((ToDate != null && ToDate != '') ||  (ToDate_Mob != null && ToDate_Mob != ''))|| (CurrentStatus != null && CurrentStatus != '')) {
                    Searchstring+=' and ';
                }
                string[] PurposeVoc = VOCPurpose.split(';');
                string purposeString='';
                for(string prs :  PurposeVoc){
                    purposeString += '\''+prs +'\',';
                }
                purposeString = purposeString.substring(0,purposeString.length() - 1);
                Searchstring +=' Purpose_of_this_VOC__c INCLUDES (' + purposeString +')';                
            } 
            
            if(SensitiveLevel != null && SensitiveLevel != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != ''))|| ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '')) {
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
            
            if(voctitle != null && voctitle != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != ''))|| ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || 
                (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '') || (SensitiveLevel != null && SensitiveLevel != '')) {
                    Searchstring+=' and ';
                }
                    Searchstring +=' (VOC_Title__c like: voc_title OR VOC_Collection__c like: voc_title) ';    
                system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'+voc_title);
            }
            
          /*  if(VOCCollection != null && VOCCollection != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != ''))|| ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || 
                (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '') || (SensitiveLevel != null && SensitiveLevel != '') || (voctitle != null && voctitle != '')) {
                    Searchstring+=' and ';
                }
                    Searchstring +=' VOC_Collection__c like: VOC_Collection';    
                
            }
            */
            
            if(OrderByValue != null && OrderByValue != '') {
                if((recordNumber != null && recordNumber != '') || (CustomerNameTitle != null && CustomerNameTitle != '') 
                || (AccountName != null && AccountName != '') || (HonLead != null && 
                HonLead != '') || (ProductFamily != null && ProductFamily != '') || 
                ((FromDate != null && FromDate != '') || (FromDate_Mob != null && FromDate_Mob != '')) || 
                ((ToDate != null && ToDate != '') || (ToDate_Mob != null && ToDate_Mob != '')) || 
                (CurrentStatus != null && CurrentStatus != '') || (VOCPurpose != null && VOCPurpose != '') || 
                (SensitiveLevel != null && SensitiveLevel != '') || (voctitle != null && voctitle != '')) {
                    if(OrderByValue == 'Record Number') {
                        Searchstring +=' ORDER BY VOC__c';    
                        system.debug('^^^^^^^^^^^^^^Record Number^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                    }
                    else if(OrderByValue == 'Status') {
                    system.debug('^^^^^^^^^^^^^^ Status^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY Status__c,VOC_Date__c ASC Nulls Last Limit 1000';    
                    }
                    else if(OrderByValue == 'Date') {
                    system.debug('^^^^^^^^^^^^^^Date^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY VOC_Date__c DESC Nulls Last Limit 1000';    
                    }
                    else if(OrderByValue == 'Honeywell Lead') {
                    system.debug('^^^^^^^^^^^^^^Honeywell Lead^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY Honeywell_Lead_Formula__c  ASC Nulls Last Limit 1000';    // Honeywell_Lead__c,Honeywell__r.Name
                    }
                    else if(OrderByValue == 'Acc') {
                        Searchstring +=' ORDER BY Account__c Limit 1000';    
                    }
                    else if(OrderByValue == 'Sensitive') {
                    system.debug('^^^^^^^^^^^^^^Sensitive^^^^^^^^^^^^^^^^^^^^'+OrderByValue);
                        Searchstring +=' ORDER BY Sensitive__c Limit 1000';    
                    }
                    else if(OrderByValue == 'ProductFamily') {
                        Searchstring +=' ORDER BY Product_Family__c Limit 1000';    
                    }
                }    
            }
            Search_VOC_List = Database.Query(Searchstring);  

            
            vocMainListForPage = Search_VOC_List;
                     
        string header = '<table border="1" style="font-weight:bold"><tr><td>VOC</td> <td>VOC Date</td><td>VOC Status</td> <td>VOC Collection</td> <td>VOC Title</td> <td>Honeywell Lead</td> <td>Product Family</td> <td>Product Name</td> <td>Platform</td> <td>Company Name</td> <td>Customer (Participant) Name</td> <td>Customers Title/Role</td> <td>Customers Email</td> <td>Purpose of this VOC</td> <td>VOC Hypothesis</td> <td>Key Takeaways</td><td>Financial Implications</td> <td>Sensitive Information?</td> <td>Security Group</td></tr></table>\n';
        string finalstr = header;
        String EXPVOCCustomerName;
        String EXPVOCCustomerTitle;
        string EXPVOCCustomerEmail;
        String EXPVOCCompanyName;
        String EXPVOCCollection;
        String EXPVOCTitle;
        String EXPVOCDate;    //changed from var date
        String EXPHoneywellLead;
        String EXPProductFamily;
        String EXPProductName;
        String EXPPlatform;
        String EXPCompanyName;
        String EXPVOCPurpose;
        String EXPVOCHypothesis;
        String EXPKeyTakeaways;
        String EXPFinancialImplications;
        String EXPSensitive;
        String EXPSecurityGroup;
        String VOCStatus;
        String VOCNumber;
        for(Voice_Of_Customer__c vc: Search_VOC_List) {
            if(vc.VOC_Customer_Names__r != null) {
                EXPVOCCustomerName = '<table border="1">';
                for(VOC_Customer_Name__c cust: vc.VOC_Customer_Names__r) {
                    EXPVOCCustomerName += '<tr>';
                    if(cust.VOC_Record__c == vc.id) {
                    
                        if(cust.Company_Name__c != null) {
                            EXPVOCCustomerName += '<td>'+cust.Company_Name__c+'</td>';   
                        }
                        if(cust.Company_Name__c == null) {
                            EXPVOCCustomerName += '<td></td>';    
                        } 
                        if(cust.Customer_Name__c != null) {
                            EXPVOCCustomerName += '<td>'+cust.Customer_Name__c+'</td>';      
                        }
                        if(cust.Customer_Name__c == null) {
                            EXPVOCCustomerName  += '<td></td>';    
                        } 
                        if(cust.Customer_s_Title_Role__c != null) {
                            EXPVOCCustomerName += '<td>'+cust.Customer_s_Title_Role__c+'</td>';       
                        } 
                        if(cust.Customer_s_Title_Role__c == null) {
                            EXPVOCCustomerName  += '<td></td>';    
                        }   
                        if(cust.Primary_Customer_s_Email__c != null) {
                            EXPVOCCustomerName += '<td>'+cust.Primary_Customer_s_Email__c+'</td>';    
                        }
                        if(cust.Primary_Customer_s_Email__c == null) {
                            EXPVOCCustomerName  += '<td></td>';    
                        }                                               
                    }
                    EXPVOCCustomerName += '</tr>';
                }
                EXPVOCCustomerName += '</table>';
            }
            if(vc.VOC_Date__c != null) {
             //  datetime EXPVOCDatevar = vc.VOC_Date__c;
             //   Date dateTemp = Date.newInstance(EXPVOCDatevar.year(),EXPVOCDatevar.month(),EXPVOCDatevar.day());
             //   EXPVOCDate = dateTemp.format();   
               // EXPVOCDate =  string.valueOf(vc.VOC_Date__c);  
               string t1 =  string.valueOf(vc.VOC_Date__c.Month());
               string t2 =  string.valueOf(vc.VOC_Date__c.Day());
               string t3 =  string.valueOf(vc.VOC_Date__c.Year());
               EXPVOCDate = t1+'/'+t2+'/'+t3;
               system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+EXPVOCDate);
            }
            if(vc.VOC_Date__c == null) {
                EXPVOCDate = null;    
            }
            if(vc.VOC_Collection__c != null) {
                EXPVOCCollection = vc.VOC_Collection__c;    
            }
            if(vc.VOC_Collection__c == null) {
                EXPVOCCollection ='';    
            }
            if(vc.VOC_Title__c != null) {
                EXPVOCTitle = vc.VOC_Title__c;    
            }
            if(vc.VOC_Title__c == null) {
                EXPVOCTitle ='';    
            }
            /*
            if(vc.Honeywell_Lead__c != null) {            // Changed from Honeywell__r.Name
                EXPHoneywellLead = vc.Honeywell_Lead__c;  // Changed from Honeywell__r.Name  
            }
            
            if(vc.Honeywell_Lead__c == null && vc.Honeywell__r.Name != null) {            // Changed from Honeywell__r.Name
                EXPHoneywellLead = vc.Honeywell__r.Name;    
            }
            if(vc.Honeywell_Lead__c == null && vc.Honeywell__r.Name == null) {
                EXPHoneywellLead = '';    
            }
            */
            if(vc.Honeywell_Lead_Formula__c != null) {            
                EXPHoneywellLead = vc.Honeywell_Lead_Formula__c;    
            }
            if(vc.Honeywell_Lead_Formula__c == null) {            
                EXPHoneywellLead = '';    
            }
            if(vc.Product_Family__c != null) {
                EXPProductFamily = vc.Product_Family__c;    
            }
            if(vc.Product_Family__c == null) {
                EXPProductFamily ='';    
            }
            if(vc.Product_Name__c != null) {
                EXPProductName = vc.Product_Name__c;    
            }
            if(vc.Product_Name__c == null) {
                EXPProductName ='';    
            }
            if(vc.Platform__r.Name != null) {
                EXPPlatform = vc.Platform__r.Name;    
            }
            if(vc.Platform__r.Name == null) {
                EXPPlatform ='';    
            }
            if(vc.Purpose_of_this_VOC__c != null) {
                EXPVOCPurpose = vc.Purpose_of_this_VOC__c;    
            }
            if(vc.Purpose_of_this_VOC__c == null) {
                EXPVOCPurpose ='';    
            }
            if(vc.VOC_Hypothesis__c != null) {
                EXPVOCHypothesis = vc.VOC_Hypothesis__c;    
            }
            if(vc.VOC_Hypothesis__c == null) {
                EXPVOCHypothesis ='';    
            }
            if(vc.Key_Takeaways1__c != null) {
                EXPKeyTakeaways = vc.Key_Takeaways1__c;    
            }
            if(vc.Key_Takeaways1__c == null) {
                EXPKeyTakeaways ='';    
            }
            if(vc.Financial_Implications__c != null) {    
                EXPFinancialImplications = vc.Financial_Implications__c;    
            }
            if(vc.Financial_Implications__c == null) {    
                EXPFinancialImplications ='';    
            }
            if(vc.Sensitive__c == false) {
                EXPSensitive ='No';    
            }
            else if(vc.Sensitive__c == true) {
                EXPSensitive ='Yes';    
            }
            if(vc.Security_Group__c != null) {
                EXPSecurityGroup = vc.Security_Group__c;    
            }
            if(vc.Security_Group__c == null) {
                EXPSecurityGroup ='';    
            }
            if(vc.Status__c != null) {
                VOCStatus = vc.Status__c;    
            }
            if(vc.Status__c == null) {
                VOCStatus = '';    
            }
            if(vc.VOC__c == null) {
                if(vc.RecordtypeId == Label.OVOC_RecType_Id) {
                    VOCNumber = 'OVOC-Draft';            
                }
                else if(vc.RecordtypeId == Label.VOC_RecType_Id) {
                    VOCNumber = 'OVOC-Draft';    
                }
                else {
                    VOCNumber = '';    
                }
            }
            if(vc.VOC__c != null) {
                 VOCNumber = vc.VOC__c;    
            }
            
            string recordString = '<table border="1"><tr><td>'+VOCNumber+'</td><td>'+EXPVOCDate+'</td><td>'+VOCStatus+'</td><td>'+EXPVOCCollection+'</td><td>'+EXPVOCTitle+'</td><td>'+EXPHoneywellLead+'</td><td>'+EXPProductFamily+'</td><td>'+EXPProductName+'</td><td>'+EXPPlatform+'</td><td>'+EXPVOCCustomerName+'</td><td>'/*+EXPVOCCustomerName+'</td><td>'+EXPVOCCustomerName+'</td><td>'+EXPVOCCustomerName+'</td><td>'*/+EXPVOCPurpose+'</td><td>'+EXPVOCHypothesis+'</td><td>'+EXPKeyTakeaways+'</td><td>'+EXPFinancialImplications+'</td><td>'+EXPSensitive+'</td><td>'+EXPSecurityGroup+'</td></tr></table>'+'\n';
            finalstr = finalstr +recordString;    
        }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob;
            csvBlob = blob.valueOf(finalstr);
            csvAttc.setFileName('VOC Records.xls');
            csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] {usermailemail});
            mail.setSubject('VOC Record details');
            mail.setHtmlBody('Here is the email you requested.');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { csvAttc }); 
    
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         //   pagereference pageref = new pagereference('/apex/OVOC_MyVOC?success=true');
         //   pageref.setredirect(true);
         //   return pageref;
        }
        catch (system.typeexception t) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like some of the values you entered were incorrect. Please try again.'));
          //  return null;
        }  
        catch (QueryException q) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. We could not process your request. Please try again or contact your administrator.'));
          //  return null;    
        } 
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. Looks like something went wrong. Please try again or contact your administrator.'));
         //   return null;    
        }   
        if(Limits.getHeapSize()>= Limits.getLimitHeapSize()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'We are sorry. There seems to be too many records found for the criteria prvided. Please try filtering your result criteria.'));  
            System.debug(LoggingLevel.Debug, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
        }
        System.debug(LoggingLevel.Debug, 'Heap Size Out: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize()); 
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
  
      public void assignReportFormat(){
          system.debug('GenerateFormat-->' + GenerateFormat);
      }
    @RemoteAction 
    Public static void DeleteDraft(string expid) {
        List<ID> VOCIDlist = new List<ID>();  
        List<Voice_of_Customer__c> VOCDeleterec = [select id,Name,VOC__c from Voice_of_Customer__c where id =:expid];
        if(VOCDeleterec.size()>0) {
            for(Voice_of_Customer__c vc : VOCDeleterec) {
                VOCIDlist.add(vc.id);    
            }
        }
        if(VOCDeleterec.size()>0) {
            if(VOCIDlist.size()>0) {
                List<VOC_Customer_Name__c> CustomerNames = [select id,Company_Name__c,Customer_s_Title_Role__c,Primary_Customer_s_Email__c,Contact__c,VOC_Record__c, Customer_name__c from VOC_Customer_Name__c where VOC_Record__c in :VOCIDlist];
                if(CustomerNames.size()>0) {
                    delete CustomerNames;
                }
            }
            delete VOCDeleterec;
        }    
    }
}