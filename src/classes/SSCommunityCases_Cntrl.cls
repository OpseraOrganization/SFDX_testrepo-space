/* Change Log---------------------------------

INC000008297590    NTTData  2/18/15     To show message for Honeywell Employees
                   TCS      21/9/18     Feedback:To store comment provided from feedback on TSSCommunityDetails
                   TCS      12/11/18    Feedback:To change status of the feedback
----------------------------------------------*/
public class SSCommunityCases_Cntrl {
    public SSCommunityCases_Cntrl() {}
	/*Public List<Case> CaseExportList{get;set;}
    public string recordId {get;set;}
    public string data {get;set;}
    public string Inquiry_Type_Details_var{get;set;}
    public string Aircraft_TypeId_var{get;set;}
    public string ATA_Chapter_var{get;set;}
    public string Product_TypeId_var{get;set;}
    public string Part_Number_var{get;set;}
    public string Subject_Id_var{get;set;}
    public string Description_Id_var{get;set;}
    public attachment Case_Attachment{get;set;} 
    public string AirId{set;get;} 
    public string CaseNumber{set;get;} 
    public list<Technical_Solutions__kav> casKAV1{get; set;}
    public list<Technical_Videos__kav > casKAV2{get; set;}
    public list<Knowledge_Article__kav > casKAV4{get; set;}
    public string cka {get;set;}
    public String SelectedId ='';
    public String istrue{
        get;
        set{
            istrue = value;
            system.debug('istrue' +istrue  );
           }
    }  */         
    //Case Search---------------------------
    /** 
      * Method Name: caseSearch
      * Description : This method used to search for Solutions/Knowledge Article 
      * 
    **/    
    
    /*public SSCommunityCases_Cntrl(){
    System.debug('!@#$userinfo'+Userinfo.getUSerId());
        casKAV1 = new list<Technical_Solutions__kav>();
        casKAV2 = new list<Technical_Videos__kav >();        
        casKAV4 = new list<Knowledge_Article__kav>();
        
        SelectedId = ApexPages.currentPage().getParameters().get('KId');
        cka=ApexPages.currentPage().getParameters().get('id');
        System.Debug(':::::SelectedId:::'+SelectedId);
        if(SelectedId != Null && SelectedId != ''){
            
            if( SelectedId.substring(0,4) ==Label.TSSTechSolutionId )
            {
           
            casKAV1 = [SELECT Id,Title,ArticleNumber,ArticleType,FirstPublishedDate,PublishStatus,Solution_Number__c,UrlName,VersionNumber, Summary,Model_Name__c,Aircraft_Type__c,Honeywell_Part_Number__c,ATA_Chapter__c,Article_Details_del__c,Solution_Title__c,FAQ__c FROM Technical_Solutions__kav WHERE Id =:SelectedId
            AND language='en_US' AND PublishStatus='online' LIMIT 1];  
            System.Debug(':::casKAV1:::'+casKAV1);
            
            }
             if( SelectedId.substring(0,4) ==Label.TSSTechVideosId )
            {
           
            casKAV2 = [SELECT Id, Title, Summary, Solution_Details__c,Aircraft_Type__c,ATA_Chapter__c,FAQ__c,Honeywell_Part_Number__c,Model_Name__c,Solution_Number__c,Solution_Title__c,UrlName FROM Technical_Videos__kav WHERE Id =:SelectedId
            AND language='en_US' AND PublishStatus='online' LIMIT 1];
            System.Debug(':::casKAV1:::'+casKAV2 );
            
            }
            if( SelectedId.substring(0,4) ==label.TSSKACMessageId )
            {          
            casKAV4 = [SELECT Id,ArticleType,UrlName,CreatedDate,ArchivedDate, Title,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId,Question_Problem__c,AC_Type__c,AC_Type__r.Model_Name_without_Hypen__c,Supported_Products__r.name,PN__c,SW_Version__c,Phase_of_Flight__c,Fault_Messages__c,FDE_Event__c,Answer_Solution__c,Related_Links__c,Cause_Optional__c,PublishStatus FROM Knowledge_Article__kav  WHERE Id =:SelectedId AND language='en_US' AND PublishStatus='online' LIMIT 1];
            System.Debug(':::casKAV4:::'+casKAV4 );             
            }                                
        }
    }      
    @RemoteAction
    public static CaseWithComments caseSearch(string searchString, String SortVar,string airCraftType,string productType) { 
        
        contact con;
        string conId;
        
        List<Id> ConIDList = new List<Id>();
        List<Id> UserIdList = new List<Id>();
        system.debug('userinfo.getUserId()'+userinfo.getUserId());   
        user u = [select id,Name,alias,contactid,contact.accountid,contact.Contact_Is_Employee__c,LastLoginDate,User.Profile.Name from user where id =:userinfo.getUserId() limit 1];
        
        string accId;
        string RectypeId = Label.SSCommunity_Technical_Issue;
        
        
             accId = u.contact.accountid;
            conId = u.contactid;
        
        searchString = String.escapeSingleQuotes(searchString);   
        string a = 'Online';
        string b = 'en_US';
        String searchQuery ='';
        System.debug('searchString '+searchString );
                
                 
        searchQuery = 'FIND \'' + searchString + '\' IN ALL FIELDS RETURNING KnowledgeArticleVersion (Id,'+
        ' Title,Owner.Name,UrlName,ArticleNumber,Summary,LastPublishedDate,ArticleType,LastModifiedById,'+
        'FirstPublishedDate,KnowledgeArticleId WHERE PublishStatus=\'' + a+ '\' and language=\'' + b+ '\'';
        if(SortVar == 'Recent Activity') {
            searchQuery += ' Order By lastModifiedDate DESC NULLS last Limit 1000';
            System.debug('Testing value-03'+searchQuery);
        }
        if(SortVar == 'Date Created') {
            searchQuery += ' Order By CreatedDate DESC NULLS last Limit 1000';
            System.debug('Testing value-04'+searchQuery);
        }
        if(SortVar == 'status') {
                
        }
        searchQuery +='), Case (Id,OwnerName__c,CaseNumber,Subject, Description,Status,AccountId,ContactId, CreatedDate,'+
        'CreatedBy.Name,IsClosed, CreatedById,LastModifiedDate, Classification__c,Supported_Products__c,'+
        'Supported_Products__r.Product_Type__c,Aircraft_Type__r.name,Aircraft_Type__c,'+
        'Supported_Products__r.name ';
        System.debug('Account value-04'+searchQuery);
      if(searchString != '') {
             
                searchQuery += 'Where createdDate > '+Label.TSSDeploymentDate+' and RecordTypeId =:RectypeId'; //
                System.debug('Testing value-01'+searchQuery);
            
           
        }
        if(airCraftType!='All') { 
               
                searchQuery += ' and Aircraft_Type__r.name like \'%'+airCraftType+'%\'';
        }
         if(productType!='All') { 
               // AllCasesList += ' ContactId in:ConIDList ';
                searchQuery += ' and Supported_Products__r.Product_Type__c=: productType';
        }
         if(!u.contact.Contact_Is_Employee__c) { 
               // AllCasesList += ' ContactId in:ConIDList ';
                searchQuery += ' and AccountId =: accId';
        }
       

        if(SortVar == 'Recent Activity') {
            searchQuery += ' Order By lastModifiedDate DESC NULLS last Limit 1000';
            System.debug('Testing value-03'+searchQuery);
        }
        if(SortVar == 'Date Created') {
            searchQuery += ' Order By CreatedDate NULLS last Limit 1000';
            System.debug('Testing value-04'+searchQuery);
        }
        if(SortVar == 'status') {

        }
        searchQuery += ' ), Service_Request__c(';
         string srtype = 'Technical Issue';
        string at =null;
        searchQuery += 'Subject__c, Product_Type__c,OwnerName__c ,Case_Number__c,Case_Number__r.casenumber,Case_Number__r.id, Name, Status__c,'
        +'Aircraft_Type__r.name, Account_Name__r.id,Account_Name__c where SR_type__c=: srtype and Aircraft_Type__c != '+at;
         
                searchQuery += ' and createdDate > '+Label.TSSDeploymentDate;
        
         
        if(!u.contact.Contact_Is_Employee__c) { 
               // AllCasesList += ' ContactId in:ConIDList ';
                searchQuery += ' and Account_Name__c =: accId';
        }
        if(airCraftType!='All') { 
               // AllCasesList += ' ContactId in:ConIDList ';
                searchQuery += ' and Aircraft_Type__r.name like \'%'+airCraftType+'%\'';
        }
        if(productType!='All') { 
               // AllCasesList += ' ContactId in:ConIDList ';
                searchQuery += ' and Product_Type__c like \'%'+productType+'%\'';
        }
        searchQuery +=')';
        system.debug('searchQuery '+searchQuery );
        System.debug('Testing value-05'+searchQuery);
        
        List<LIST<SObject>> searchedResult = search.query(searchQuery);
        system.debug('##############################'+searchedResult);
        list<id> CaseIDlist = new list<id>();
        for(SObject CID: searchedResult[1]){                
                CaseIDlist.add(CID.Id); 
        }
        
        Map<Id,integer> mapVotes = new Map<Id,integer>();
        Map<Id,datetime> mapModifiedDate = new Map<Id,datetime>();       
        List<Id> OwnerIdList = new List<Id>();
        Map<Id,String> Ownermap = new Map<Id,String>();
        List<CaseComment> Commentlist = [SELECT id,LastModifiedDate,IsPublished,ParentId,CommentBody,CreatedBy.Name,CreatorName,CreatedDate FROM CaseComment where parentId in: CaseIDlist and IsPublished = true Order By CreatedDate DESC Limit 1000];
      
        
        for(Id CID: CaseIDlist){
            integer i=0;
            for(CaseComment clist: Commentlist){ 
                if(clist.ParentId == CID) {
                    i = i+1;
                    mapVotes.put(clist.ParentId,i);         
                }
            }
            
        }
        
        for(CaseComment clist: Commentlist) {
            OwnerIdList.add(clist.CreatedById);
        }
        List<User> OwnerList = [Select Id,Name,UserType from User where id in: OwnerIdList Limit 1000];
            for(CaseComment clist: Commentlist) {
                for(User usr: OwnerList) {
                    Ownermap.put(clist.Id,usr.UserType);
                }
            }
        // New Loop Starts
        // To store list of comments
        List<string> CommentsBodyList = new List<String>();
        Map<Id,List<String>> mapTitle = new Map<Id,List<String>>();
        
        // To store list of Owners
        List<string> CommentsOwnerList = new List<String>();
        Map<Id,List<String>> CreatorMap = new map<Id,List<String>>();
        
        // To store list of Created dates
        List<datetime> CommentsDateList = new List<datetime>();
        Map<Id,List<datetime>> DatesMap = new map<Id,List<datetime>>();
      
        for(id d: CaseIDlist) {           
            for(CaseComment clist: Commentlist){                     
                if(d == clist.ParentId){    
                    CommentsBodyList.add(clist.CommentBody+'#%'+clist.CreatedBy.Name+'#%'+clist.CreatedDate); 
                    CommentsOwnerList.add(clist.CreatedBy.Name);
                    CommentsDateList.add(clist.CreatedDate);
                }           
            }              
            mapTitle.put(d,CommentsBodyList);
            CreatorMap.put(d,CommentsOwnerList); 
            DatesMap.put(d,CommentsDateList);
            
            CommentsBodyList = new List<String>();
            CommentsOwnerList = new List<String>();
            CommentsDateList = new List<datetime>();
        }      
        // New Loop ends
        
        // Fetching Article Rating starts
        list<id> KnowledgeIDlist = new list<id>();
        List<Id> ArticleIdlist = new List<Id>();
        list<sobject> KnowledgeResults=new list<sobject>();
        list<sobject> Results=new list<sobject>();
        for(SObject KAID: searchedResult[0]){                
                 KnowledgeIDlist.add(KAID.Id);
                
                //KnowledgeResults.add(KAID);
        }
        
        system.debug('KnowledgeIDlist'+KnowledgeIDlist.size());
        system.debug('KnowledgeIDlist1'+KnowledgeIDlist);       
        list<SObject> filteredTechSolutions=new list<SObject>();
        list<SObject> techVdoKav=new list<SObject>();
        list<SObject> casKav=new list<SObject>();
        list<SObject> knowledgekAV=new list<SObject>();
        if(airCraftType != 'All'){
            string str='%'+airCraftType+'%';
           
                  
           
                filteredTechSolutions = [SELECT Id, Title,ArticleNumber,ArticleType,FirstPublishedDate,PublishStatus,Solution_Number__c,UrlName,VersionNumber, Summary,Model_Name__c,Aircraft_Type__c,Honeywell_Part_Number__c,ATA_Chapter__c,Article_Details_del__c,Solution_Title__c,FAQ__c FROM Technical_Solutions__kav WHERE Aircraft_Type__c LIKE : str AND Id IN: KnowledgeIDlist 
                AND language='en_US' AND PublishStatus='online' AND Aircraft_Type__c != null];
                techVdoKav =[SELECT Id, Title, Summary, Solution_Details__c,Aircraft_Type__c,ATA_Chapter__c,FAQ__c,Honeywell_Part_Number__c,Model_Name__c,Solution_Number__c,Solution_Title__c,UrlName FROM Technical_Videos__kav WHERE Aircraft_Type__c LIKE : str AND Id IN: KnowledgeIDlist
                AND language='en_US' AND PublishStatus='online' AND Aircraft_Type__c != null];
                knowledgekAV =[SELECT Id,ArticleType,UrlName,CreatedDate,ArchivedDate, Title,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId,Question_Problem__c,AC_Type__c,AC_Type__r.Model_Name_without_Hypen__c,Supported_Products__r.name,PN__c,SW_Version__c,Phase_of_Flight__c,Fault_Messages__c,FDE_Event__c,Answer_Solution__c,Related_Links__c,Cause_Optional__c,PublishStatus FROM Knowledge_Article__kav WHERE AC_Type__r.name LIKE : str AND Id IN: KnowledgeIDlist
                AND language='en_US' AND PublishStatus='online'];  */
            
               /* KnowledgeResults.clear();
                KnowledgeResults.addAll(knowledgekAV);
                KnowledgeResults.addAll(filteredTechSolutions);
                KnowledgeResults.addAll(techVdoKav);
                KnowledgeResults.addAll(casKav);*/
                
               /* Results.clear();
                Results.addAll(knowledgekAV);
                Results.addAll(casKav);
                Results.addAll(filteredTechSolutions);
                Results.addAll(techVdoKav);
                
            
        }else{
            filteredTechSolutions = [SELECT Id, Title,ArticleNumber,ArticleType,FirstPublishedDate,PublishStatus,Solution_Number__c,UrlName,VersionNumber, Summary,Model_Name__c,Aircraft_Type__c,Honeywell_Part_Number__c,ATA_Chapter__c,Article_Details_del__c,Solution_Title__c,FAQ__c FROM Technical_Solutions__kav WHERE Id IN: KnowledgeIDlist 
            AND language='en_US' AND PublishStatus='online'];    
            techVdoKav =[SELECT Id, Title, Summary, Solution_Details__c,Aircraft_Type__c,ATA_Chapter__c,FAQ__c,Honeywell_Part_Number__c,Model_Name__c,Solution_Number__c,Solution_Title__c,UrlName FROM Technical_Videos__kav WHERE Id IN: KnowledgeIDlist
            AND language='en_US' AND PublishStatus='online' AND Aircraft_Type__c != null];
            knowledgekAV =[SELECT Id,ArticleType,UrlName,CreatedDate,ArchivedDate, Title,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId,Question_Problem__c,AC_Type__c,AC_Type__r.Model_Name_without_Hypen__c,Supported_Products__r.name,PN__c,SW_Version__c,Phase_of_Flight__c,Fault_Messages__c,FDE_Event__c,Answer_Solution__c,Related_Links__c,Cause_Optional__c,PublishStatus FROM Knowledge_Article__kav WHERE Id IN: KnowledgeIDlist
            AND language='en_US' AND PublishStatus='online'];  */
           /* KnowledgeResults.clear();
            KnowledgeResults.addAll(filteredTechSolutions);
            KnowledgeResults.addAll(techVdoKav);
            KnowledgeResults.addAll(casKav);
            KnowledgeResults.addAll(knowledgekAV);*/
           /* Results.clear();
            Results.addAll(knowledgekAV);
            Results.addAll(casKav);
            Results.addAll(filteredTechSolutions);
            Results.addAll(techVdoKav);
        }
        //TCS:change start - added to make TKC search based on relevance
        Map<string, sobject> resultMap = new Map<string, sobject>();
        list<sobject> seacrhRelevance =new list<sobject>();
        system.debug('### Results' +Results);
        if(Results !=null && !Results.isEmpty()){
            for(sobject obj: Results){
                resultMap.put(obj.id, obj);
            } 
        }
        
        if(searchedResult[0] !=null && !searchedResult[0].isEmpty()){    
            for(sobject obj: searchedResult[0]){
                seacrhRelevance.add(resultMap.get(obj.id));
                
            } 
            system.debug('### seacrhRelevance' +seacrhRelevance);
        }           
        Results.clear();
        if(seacrhRelevance !=null && !seacrhRelevance.isEmpty()){
            Results.addAll(seacrhRelevance); 
        }
        //TCS:change end
        Results.addAll(searchedResult[1]);
        Results.addAll(searchedResult[2]);
        Map<id,decimal> MapKnowledgerating = new Map<id,decimal>();
        List<KnowledgeArticleVersion> KV = [SELECT Id, Title,Owner.Name,UrlName,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' and Id in: KnowledgeIDlist Limit 1000];   
        for(KnowledgeArticleVersion K: KV) {
            ArticleIdlist.add(K.KnowledgeArticleId);
        }        
        List<KnowledgeArticleVoteStat> voteStat = [SELECT id,NormalizedScore,Channel,ParentId FROM KnowledgeArticleVoteStat WHERE ParentId in: ArticleIdlist Limit 1000];
        
              
            for(KnowledgeArticleVersion k: KV) {
                for(KnowledgeArticleVoteStat vs: voteStat) {
                    if(vs.Channel == 'AllChannels' && vs.ParentId == k.KnowledgeArticleId) {
                        MapKnowledgerating.put(k.id,vs.NormalizedScore);
                    }
                }
            }
       
        // Fetching Article Rating ends
        
        // User Last login date
        datetime UserLogin = u.lastLoginDate;
        CaseWithComments allData = new CaseWithComments(Results,mapVotes,mapModifiedDate,mapTitle,CreatorMap,DatesMap,UserLogin,MapKnowledgerating,conId,accid);
        
        return allData;       
    }
    
    // Wrapper Class
    public class CaseWithComments {
        List<sObject> results;
        Map<Id,integer> CommentMapping;
        Map<Id,datetime> ModifieddateMapping;
        Map<Id,List<String>> mapTitleMapping;
        Map<Id,List<String>> CreatorMapping;
        Map<Id,List<datetime>> DateMapping;
        datetime UserLoginval;
        Map<Id,decimal> RateMapping;
        string conId;
        string accid;
        public CaseWithComments(List<sObject> r, Map<Id,integer> y, Map<Id,datetime> z, Map<Id,List<String>> b, Map<Id,List<String>> c, Map<Id,List<datetime>>d, datetime e, Map<Id,decimal> f,string con,string acc){
            results = r;
            CommentMapping = y;
            ModifieddateMapping = z;
            mapTitleMapping = b;
            CreatorMapping = c;
            DateMapping = d;
            UserLoginval = e;
            RateMapping = f;
            conId=con;
            accid=acc;
        }
    }
    
    // Case Details
    @RemoteAction
    Public Static Case CaseDetails(string CaseID) {
        List<Id> PIDList = new List<Id>();
        List<TSS_Community_Attachment_visibility_List__c> ProfileFilterList = TSS_Community_Attachment_visibility_List__c.getall().values();
       // List<TSS_Community_Attachment_visibility_List__c> ProfileFilterList = [Select Id,Name,ProfileId__c from TSS_Community_Attachment_visibility_List__c];
        if(ProfileFilterList.size() > 0) {
            for(TSS_Community_Attachment_visibility_List__c p: ProfileFilterList) {
                PIDList.add(p.ProfileId__c);
            }
        }
        Case Cse = [Select id,OwnerName__c,CaseNumber,Subject,Contact_Name__c,Contact.Name,Primary_Email_Address__c,Primary_Work_Number__c,Product_Part_Number__c,
        Description,Owner.Name, CreatedBy.Name, Status,Resolution__c,Platform__c,ATA_Chapter__c,Supported_Products__c,Supported_Products__r.Name,IsClosed, 
        CreatedDate,ClosedDate,Aircraft_Type__c,Aircraft_Type__r.Name,LastModifiedDate,Supported_Products__r.Product_Type__c, (Select Id, ParentId, CreatorName,CreatedBy.Name, IsPublished, CommentBody, 
        CreatedById, CreatedDate, LastModifiedDate, LastModifiedById From CaseComments where IsPublished = true), (SELECT Id,Name FROM Attachments
         where CreatedBy.profileId in: PIDList) from case where id =:CaseID Limit 1000];
        return Cse;
    }*/
    /** 
      * Method Name: SRDetails
      * Description : This method used to fetch Service Request .
      * Owner: 
      
       GTO Team 
      * 
    **/  
   /* @RemoteAction
    Public Static Service_Request__c SRDetails(string SR) {        
        Service_Request__c SR1 = [select Subject__c, Status__c,OwnerName__c, Name, Case_Number__r.CaseNumber,
         Account_Name__c,Account_Name__r.Name,Customer_Due_Date__c, Last_Technical_Update__c,
         Escalation_Tier__c,Complexity_Level__c,Atr__c,Function_Responsible__c,Problem_Description__c,
         Status_Resolution__c from Service_Request__c where id =:SR Limit 1];
         return SR1;
    }

     // Add Comments
    @RemoteAction
    Public Static CaseComment AddComments(String caseId, String myComments) {
        CaseComment CC = new CaseComment();
        CC.ParentId = CaseID;
        CC.IsPublished = true;
        CC.CommentBody =  myComments;
        Savepoint spt = Database.setSavepoint();
        try {
            insert CC;           
            
        }
        catch (exception e) {
            Database.rollback(spt);
            return null;
        }
        // Sending Mail to Case Owner
        Case C = [Select Id,Subject,OwnerId,ContactId,Case_Ref_ID__c,E2CP__Most_Recent_Public_Comment__c,E2CP__HistoryText__c,E2CP__Case_Thread_Id__c,Owner.Email,CaseNumber from Case where id =:CaseID Limit 1];
        system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW '+string.valueOf(C.OwnerId).Substring(0,3));
        if (string.valueOf(C.OwnerId).Substring(0,3)== '005') {
            system.debug('RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR '+string.valueOf(C.OwnerId).Substring(0,3));
            string SubjectVar = C.Subject+' '+C.CaseNumber+' '+C.Case_Ref_ID__c;
            String HTMLBodyVar = 'Hi,<br/>The following comment has been added to the case number :'+C.CaseNumber+'<br/><br/><span style="font-weight: bold;">'+C.E2CP__Most_Recent_Public_Comment__c+'</span><br/>'+'<C.Case_Ref_ID__c>'+'<br/><br/><br/>'+'<span style="font-size:13px; font-color: #808080; text-align: center">Due to government regulations and/or contractual limitations, all data and/or attachments containing export control information and/or containing details related to Space, Munitions and Missiles items is not authorized for entry or use in our applications or systems at the present time</span>';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] {C.Owner.Email});
            mail.setSubject(SubjectVar);
            mail.setHtmlBody(HTMLBodyVar);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }     
        return CC; 
    }
    
    // Get Article Details
    @RemoteAction
    Public static KnowledgeArticleVersion GetKnowledgedetails(string ArticleId) {
        KnowledgeArticleVersion kv = [SELECT Id, Title,Owner.Name,UrlName,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' and id=: ArticleId Limit 1000];
        return kv;  
    }
    @RemoteAction
    Public static List<KnowledgeArticleVersion> GetKnowledgedetails1(string ArticleId) {
        system.debug('ArticleId-----'+ArticleId);
        List<KnowledgeArticleVersion> kv = [SELECT Id, Title,Owner.Name,UrlName,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate FROM KnowledgeArticleVersion WHERE  PublishStatus = 'Online' and Language = 'en_US'  and KnowledgeArticleId =: ArticleId Limit 1];  
        //Technical_Solutions__kav  kv=[SELECT Id,Model_Name__c,OwnerId,PublishStatus FROM Technical_Solutions__kav WHERE Id = 'ka2560000008R1pAAE'];
        return kv;
    }
    // rate Article Method
    @RemoteAction
    Public Static Vote RateArticleMethod (string recordId, string RateValue) {
        system.debug('::::::In RateArticleMethod');
        KnowledgeArticleVersion kv = [SELECT Id, Title,Owner.Name,Owner.Email,UrlName,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' and id=: recordId Limit 1000];  
        vote v = new Vote();
        v.Type = RateValue;
        v.ParentId = kv.KnowledgeArticleId;
        insert v;
        string KVSubject = 'Low Rate given to Knowledge Article: '+kv.Title;
        if(integer.ValueOf(RateValue) < 3) {
           // KnowledgeArticleVersion kav = [SELECT Id, Title,Owner.Name,UrlName,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' and KnowledgeArticleId=: kv.KnowledgeArticleId];        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] {kv.Owner.Email});
            mail.setSubject(KVSubject);
            mail.setHtmlBody('The knowledge article published by you has been given a low rating. Please take necessary actions.');
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        else {
            system.debug('Outside');
        }
        return v;
    }
    
    // Retrieve User's article rating
    @RemoteAction
    Public Static string RateArticleRetrieveMethod (string recordId) {
        KnowledgeArticleVersion kv = [SELECT Id, Title,Owner.Name,UrlName,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' and id=: recordId Limit 1];  
        List<Vote> votestat = [SELECT CreatedById,Id,ParentId,Type FROM Vote WHERE CreatedById =:userinfo.getUserId() AND ParentId = :kv.KnowledgeArticleId Limit 1000];
        string type = '0';
        if(votestat.size() > 0) {
            type = votestat[0].Type;
        }
            return type;
    }
    
    // Get Article Average rating
    @RemoteAction
    Public Static decimal ArticleVoteStat(string KAId) {
        decimal AvgVote;
        KnowledgeArticleVersion kv = [SELECT Id, Title,Owner.Name,UrlName,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' and id=: KAId Limit 1000];         
        List<KnowledgeArticleVoteStat> voteStat = [SELECT id,NormalizedScore,Channel FROM KnowledgeArticleVoteStat WHERE ParentId =: kv.KnowledgeArticleId Limit 1000];
        for(KnowledgeArticleVoteStat kvs: voteStat) {
            if(kvs.Channel == 'AllChannels') {
                
                AvgVote = kvs.NormalizedScore;
            }
        }
        
        return AvgVote;   
    }
    
      Public Pagereference GenerateReport() {
        CaseExportList = new List<Case>();
        contact con;
        List<Id> ConIDList = new List<Id>();
       // List<Id> UserIdList = new List<Id>();
        user u = [select id,contactid,contact.accountid,User.Profile.Name from user where id =:userinfo.getUserId() limit 1];
        system.debug('user detail'+u );
        string AccId;
        string RectypeId = Label.SSCommunity_Technical_Issue;
        //if(!u.Profile.Name.contains('System Administrator')) {
           // con = [select id,accountid from contact where id =:u.contactid Limit 1];
            AccId = u.contact.accountid;
        //}
        String QueryString = 'Select Id,CaseNumber,Subject, Description,Resolution__c,Status,RecordTypeId, CreatedDate,CreatedBy.Name,IsClosed,CreatedById,LastModifiedDate,Owner.Name,Aircraft_Type__c,ATA_Chapter__c,Product__c,(Select Id, ParentId, CreatorName,CreatedBy.Name, IsPublished, CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById From CaseComments where IsPublished = true),ClosedDate,Classification__c,Supported_Products__c from Case ';
        //if(!u.Profile.Name.contains('System Administrator')) { 
                QueryString += ' where createdDate > '+Label.TSSDeploymentDate+' and AccountId =: AccId and RecordTypeId =:RectypeId Limit 1000 ';
        //}
       
        CaseExportList = database.query(QueryString);
        system.debug('CaseExportList '+CaseExportList);
        system.debug('CaseExportList '+CaseExportList.size());
        PageReference pageRef = new PageReference('/apex/SSCommunityExcelReport');
            return pageRef;
    }
    
    @RemoteAction
    public static LandingCaseWithComments CaseLandingSearch(String SortVar,string airCraftType, string productType) { 
        contact con;
        string UserContact;
        String SearchQ =userinfo.getUserId();
        List<Id> ConIDList = new List<Id>();
     //   List<Id> UserIdList = new List<Id>();
        user u = [select id,contactid,contact.accountid,contact.Contact_Is_Employee__c,LastLoginDate,User.Profile.Name from user where id =:userinfo.getUserId() limit 1];
        string accId;
        string RectypeId = Label.SSCommunity_Technical_Issue;
        //if(!u.Profile.Name.contains('System Administrator')) {
            //con = [select id,accountid from contact where id =:u.contactid Limit 1];
            accId = u.contact.accountid;
            UserContact = u.contactid;
            
        //}
        
        String AllCasesList = 'Select Id,OwnerName__c,CaseNumber,Subject,AccountId,Description,'+
        'Status,RecordTypeId,ContactId, CreatedDate,CreatedBy.Name,IsClosed,Aircraft_Type__r.Name,'+
        'Aircraft_Type__c,Supported_Products__r.Name,Supported_Products__c,'+
         'CreatedById,LastModifiedDate,(Select Id, ParentId, CreatorName,CreatedBy.Name, IsPublished,'+
         'CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById From '+
         'CaseComments where IsPublished = true Order By CreatedDate DESC), Classification__c,'+ 
         '(select Subject__c, OwnerName__c ,Case_Number__c,Case_Number__r.casenumber, Name, '+
         'Status__c from Service_Requests__r) from Case where RecordTypeId =: RectypeId';
        //if(!u.Profile.Name.contains('System Administrator')) { 
                AllCasesList += ' and createdDate > '+Label.TSSDeploymentDate;
        //}
         
        if(!u.contact.Contact_Is_Employee__c) { 
               // AllCasesList += ' ContactId in:ConIDList ';
                AllCasesList += ' and AccountId =: accId';
        }
        if(airCraftType!='All') { 
               // AllCasesList += ' ContactId in:ConIDList ';
                AllCasesList += ' and Aircraft_Type__r.name like \'%'+airCraftType+'%\'';
        }
         if(productType!='All') { 
               // AllCasesList += ' ContactId in:ConIDList ';
                AllCasesList += ' and Supported_Products__r.Product_Type__c=: productType';
        }
        if(SortVar == 'Recent Activity') {
            AllCasesList += ' Order By lastModifiedDate DESC NULLS last Limit 500';
        }
        if(SortVar == 'Date Created') {
            AllCasesList += ' Order By CreatedDate NULLS last Limit 500';
        }
        if(SortVar == 'aircrafttype') {
            AllCasesList += ' Order By Aircrafttype__c NULLS last Limit 500';
        }
        if(SortVar == 'atachap') {
            AllCasesList += ' Order By Ata_Chapter__c NULLS last Limit 500';
        }
        if(SortVar == 'prodtype') {
            AllCasesList += ' Order By Product_Type__c NULLS last Limit 500';
        }
        if(SortVar == 'partno') {
            AllCasesList += ' Order By Part_Number__c NULLS last Limit 500';
        }
        if(SortVar == 'subject') {
            AllCasesList += ' Order By subject NULLS last Limit 500';
        }
        if(SortVar == 'Status') {
            AllCasesList += ' Order By Status NULLS last Limit 500';
        }
        SearchQ = SearchQ + AllCasesList+':'+accId+':'+RectypeId;
        System.debug('Line 442 Accid'+accId+' Line 442 RecordTypeid'+ RectypeId);
        System.debug('Query '+AllCasesList);
        System.debug('aircrafttype '+aircrafttype);
        LIST<Case> searchedResult = database.query(AllCasesList);
                
        list<id> CaseIDlist = new list<id>();
        for(Case CID: searchedResult){                
                CaseIDlist.add(CID.Id); 
        }
        
        datetime UserLogin;
        datetime LastLogin;
        if(u.LastLoginDate != null) {
            List<LoginHistory> LogHistoryList = [SELECT LoginTime,Status,UserId FROM LoginHistory WHERE UserId =: userinfo.getUserId() ORDER BY LoginTime DESC NULLS LAST Limit 5];
            
            if(LogHistoryList.size()>0) {
                if(LogHistoryList.size()== 1) {
                    UserLogin = LogHistoryList[0].LoginTime;
                }
                else {
                    UserLogin = LogHistoryList[1].LoginTime;
                }
                system.debug('Here++++++++++++++++++'+UserLogin);
            }
        }
      //  List<CaseComment> Commentlist = [SELECT id,LastModifiedDate,IsPublished,ParentId,CommentBody,CreatedBy.Name,CreatorName,CreatedDate FROM CaseComment where parentId in: CaseIDlist and IsPublished = true Order By CreatedDate DESC];
        
        List<Id> OwnerIdList = new List<Id>();
        Map<Id,String> Ownermap = new map<Id,String>();*/
        /*
        for(CaseComment clist: Commentlist) {
            OwnerIdList.add(clist.CreatedById);
        }
        */
       /* for(Case c: searchedResult) {            
            for (CaseComment Cc: c.CaseComments) {
                if(Cc.ParentId == c.Id) {
                    OwnerIdList.add(Cc.CreatedById);
                }   
            }
            
        }
        
        List<User> OwnerList = [Select Id,Name,UserType from User where id in: OwnerIdList Limit 1000];
        string UserType;
        
        for(Case c: searchedResult) {            
            for (CaseComment Cc: c.CaseComments) {
                for(User usr: OwnerList) {
                    if(Cc.CreatedById == usr.Id) {
                        if(usr.UserType.contains('Standard')) {
                            UserType = 'true';
                            Ownermap.put(Cc.Id,UserType);
                        }
                        else {
                            UserType = 'false';
                            Ownermap.put(Cc.Id,UserType);
                        }
                    }
                }   
            }
        }
        string srtype = 'Technical Issue';
        string at =null;
        String AllSRList = 'select Subject__c, Product_Type__c,OwnerName__c ,Case_Number__c,Case_Number__r.casenumber,Case_Number__r.id, Name, Status__c,'
        +'Aircraft_Type__r.name, Account_Name__r.id,Account_Name__c from Service_Request__c where SR_type__c=: srtype and Aircraft_Type__c != '+at;
       // if(!u.Profile.Name.contains('System Administrator')) { 
                AllSRList += ' and createdDate > '+Label.TSSDeploymentDate;
        //}
         
        if(!u.contact.Contact_Is_Employee__c) { 
               // AllCasesList += ' ContactId in:ConIDList ';
                AllSRList += ' and Account_Name__c =: accId';
        }
        if(airCraftType!='All') { 
               // AllCasesList += ' ContactId in:ConIDList ';
                AllSRList += ' and Aircraft_Type__r.name like \'%'+airCraftType+'%\'';
        }
        if(productType!='All') { 
               // AllCasesList += ' ContactId in:ConIDList ';
                AllSRList += ' and Product_Type__c like \'%'+productType+'%\'';
        }
        system.debug('AllSRList '+AllSRList);
        LIST<Service_Request__c> searchedSRResult = database.query(AllSRList);
        LandingCaseWithComments allData = new LandingCaseWithComments(searchedResult,searchedSRResult,UserLogin,Ownermap,UserContact,SearchQ, accId);
        
        return allData;
    }
    
 
    


    @RemoteAction
    public static boolean getUserIsEmloyee(){
        List<User> userContact = [select id, contactId from user where id =: UserInfo.getUserId() limit 1];
        if(userContact.size() > 0 ){
            if(userContact[0].contactid != null){
                List<contact> loggedInUser = [select id,Contact_Is_Employee__c from Contact where id =: userContact[0].contactid limit 1];  
                if(loggedInUser.size() > 0){
                    if(loggedInUser[0].Contact_Is_Employee__c == true || test.isRunningTest()){
                        return true;
                    }else if(loggedInUser[0].Contact_Is_Employee__c == false || test.isRunningTest()){
                        return false;
                    }   
                }   
            }
        }
        return null;
    }
    
    public class LandingCaseWithComments {
        List<Case> Casesm;
        List<Service_Request__c> SR;
        datetime UserLoginstr;
        Map<Id,String> Ownermapping;
        string ConID;
        string SearchQ;
        string AccID;
        public LandingCaseWithComments(List<Case> x, List<Service_Request__c> y,datetime b, Map<Id,String> c, string d, string e, string f){
            Casesm = x;
            SR = y;
            UserLoginstr = b;
            Ownermapping = c;
            ConID = d;
            SearchQ =e;
            AccID =f;
        }
    }*/
    
    /*Returns details of an article when a particular article is clicked*/
    /*@RemoteAction
    public static sObject getArticleOnClick(String artId){        
        KnowledgeArticleVersion kav;
        system.debug('@@@artId@@@'+artId);
        Technical_Solutions__kav techSolKav;
        Technical_Videos__kav  techVdoKav;
        Knowledge_Article__kav knowledgearticlelist;
        system.debug('***'+artId+'**'+Label.TSSCASMessageId);
        
          if(((artId).startsWith(Label.TSSTechSolutionId))){
            techSolKav = [SELECT Id, Title,ArticleNumber,ArticleType,FirstPublishedDate,LastPublishedDate,PublishStatus,Solution_Number__c,UrlName,VersionNumber, Summary,Model_Name__c,Aircraft_Type__c,Honeywell_Part_Number__c,ATA_Chapter__c,Article_Details_del__c,Solution_Title__c,FAQ__c FROM Technical_Solutions__kav WHERE Id =:artId 
            AND language='en_US' AND PublishStatus='online' LIMIT 1];  
            system.debug('***sol'+techSolKav);
            return techSolKav;
        }
        else if((artId).startsWith(Label.TSSTechVideosId)){
            techVdoKav =[SELECT Id, Title, Summary,ArticleType, VersionNumber,LastPublishedDate,Solution_Details__c,Aircraft_Type__c,ATA_Chapter__c,FAQ__c,Honeywell_Part_Number__c,Model_Name__c,Solution_Number__c,Solution_Title__c,UrlName FROM Technical_Videos__kav WHERE Id =:artId 
            AND language='en_US' AND PublishStatus='online' LIMIT 1]; 
            return techVdoKav;
        } 
       else if((artId).startsWith(Label.TSSKACMessageId))
        {   
            //added by TCS GTO Team to fetch CAS Message Article            
            knowledgearticlelist =[SELECT Id,ArticleType,UrlName,CreatedDate,ArchivedDate, Title,ArticleNumber,Summary,VersionNumber,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId,Question_Problem__c,AC_Type__c,AC_Type__r.Model_Name_without_Hypen__c,Supported_Products__r.name,PN__c,SW_Version__c,Phase_of_Flight__c,Fault_Messages__c,FDE_Event__c,Answer_Solution__c,Related_Links__c,Cause_Optional__c,PublishStatus,File_1__Name__s,File_2__Name__s,File_3__Name__s,File_4__Name__s,File_5__Name__s FROM Knowledge_Article__kav  WHERE Id =:artId 
            AND language='en_US' AND PublishStatus='online' LIMIT 1];  
            system.debug('***knowledgearticlelist'+knowledgearticlelist);
            return knowledgearticlelist;
        }        
        return null;
        //else {
            //kav =[SELECT Id, Title, Summary FROM KnowledgeArticleVersion WHERE Id =:artId 
            //AND language='en_US' AND PublishStatus='online' LIMIT 1];
            //return kav;
        //}       
    }
    
   

    public string modelno{get;set;}
    public string partno{get;set;}
    public string articletitle{get;set;}
    public string articledescription{get;set;}
    public string kcssp{get;set;}
    public string kcsas{get;set;}
    public string kcsfde{get;set;}
    public string kcsfm{get;set;}
    public string kcspf{get;set;}
    public string kcscause{get;set;}
    public string kcsrl{get;set;}
    public string kcsswv{get;set;}
    public Knowledge_Article__kav knowledgearticlelist{get;set;}

    public  void exptopdf() 
    {
         KnowledgeArticleVersion kav;
        
        Technical_Solutions__kav techSolKav;
        Technical_Videos__kav  techVdoKav;       
        
     String artId=ApexPages.currentPage().getParameters().get('kid');
     system.debug('@@@artId@@@'+artId);
     system.debug('artId-----'+artId);   
      if(((artId).startsWith(Label.TSSTechSolutionId))){
            techSolKav = [SELECT Id, Title,ArticleNumber,ArticleType,FirstPublishedDate,PublishStatus,Solution_Number__c,UrlName,VersionNumber, Summary,Model_Name__c,Aircraft_Type__c,Honeywell_Part_Number__c,ATA_Chapter__c,Article_Details_del__c,Solution_Title__c,FAQ__c FROM Technical_Solutions__kav WHERE Id =:artId 
            AND language='en_US' AND PublishStatus='online' LIMIT 1];  
            system.debug('***sol'+techSolKav);
            //return techSolKav;

            modelno='NA';
            if(techSolKav.Model_Name__c !=null)
            modelno=techSolKav.Model_Name__c;
            
            partno='NA';
            if(techSolKav.Honeywell_Part_Number__c != null)
            partno=techSolKav.Honeywell_Part_Number__c;
            
            articletitle='NA';
            if(techSolKav.Title != null)
            articletitle=techSolKav.Title;
            
            articledescription='NA';
            if(techSolKav.Article_Details_del__c != null)
            articledescription=techSolKav.Article_Details_del__c;
        }
        else if((artId).startsWith(Label.TSSTechVideosId)){
            techVdoKav =[SELECT Id, Title, Summary,ArticleType, Solution_Details__c,Aircraft_Type__c,ATA_Chapter__c,FAQ__c,Honeywell_Part_Number__c,Model_Name__c,Solution_Number__c,Solution_Title__c,UrlName FROM Technical_Videos__kav WHERE Id =:artId 
            AND language='en_US' AND PublishStatus='online' LIMIT 1];
            //return techVdoKav;
        } 
       else if((artId).startsWith(Label.TSSKACMessageId))
        {              
            knowledgearticlelist =[SELECT Id,ArticleType,UrlName,CreatedDate,ArchivedDate, Title,ArticleNumber,Summary,LastPublishedDate,LastModifiedById,FirstPublishedDate,KnowledgeArticleId,Question_Problem__c,AC_Type__c,AC_Type__r.Model_Name_without_Hypen__c,Supported_Products__r.name,PN__c,SW_Version__c,Phase_of_Flight__c,Fault_Messages__c,FDE_Event__c,Answer_Solution__c,Related_Links__c,Cause_Optional__c,PublishStatus FROM Knowledge_Article__kav  WHERE Id =:artId 
            AND language='en_US' AND PublishStatus='online' LIMIT 1];  
            system.debug('***knowledgearticlelist'+knowledgearticlelist);
            
            modelno='NA';
            if(knowledgearticlelist.AC_Type__c !=null)
            modelno=knowledgearticlelist.AC_Type__r.Model_Name_without_Hypen__c;
            
            partno='NA';
            if(knowledgearticlelist.PN__c != null)
            partno=knowledgearticlelist.PN__c;
            
            articletitle='NA';
            if(knowledgearticlelist.Title != null)
            articletitle=knowledgearticlelist.Title;
            
            articledescription='NA';
            if(knowledgearticlelist.Question_Problem__c != null)
            articledescription=knowledgearticlelist.Question_Problem__c;
            
            
            kcsas='NA';
            if(knowledgearticlelist.Answer_Solution__c != null)
            kcsas=knowledgearticlelist.Answer_Solution__c;
            
            kcsfm='NA';
            if(knowledgearticlelist.Fault_Messages__c != null)
            kcsfm=knowledgearticlelist.Fault_Messages__c;
            
            kcsswv='NA';
            if(knowledgearticlelist.SW_Version__c != null)
            kcsswv=knowledgearticlelist.SW_Version__c;
            
            kcspf='NA';
            if(knowledgearticlelist.Phase_of_Flight__c != null)
            kcspf=knowledgearticlelist.Phase_of_Flight__c;
            
            kcsfde='NA';
            if(knowledgearticlelist.FDE_Event__c != null)
            kcsfde=knowledgearticlelist.FDE_Event__c;
            
            kcsrl='NA';
            if(knowledgearticlelist.Related_Links__c != null)
            kcsrl=knowledgearticlelist.Related_Links__c;
            
            kcscause='NA';
            if(knowledgearticlelist.Cause_Optional__c != null)
            kcscause=knowledgearticlelist.Cause_Optional__c;
            
            kcssp='NA';
            if(knowledgearticlelist.Supported_Products__c != null)
            kcssp=knowledgearticlelist.Supported_Products__r.name;
        }   */
             
        /*else if( ((artId).startsWith(Label.TSSTechSolutionId1))){
           techSolKav = [SELECT Id, Title,ArticleNumber,ArticleType,FirstPublishedDate,PublishStatus,Solution_Number__c,UrlName,VersionNumber, Summary,Model_Name__c,Aircraft_Type__c,Honeywell_Part_Number__c,ATA_Chapter__c,Article_Details_del__c,Solution_Title__c,FAQ__c FROM Technical_Solutions__kav WHERE Id =:artId 
            AND language='en_US' AND PublishStatus='online' LIMIT 1];  
            system.debug('***sol'+techSolKav);
            //return techSolKav;
        }*/
        /*else {
            //kav =[SELECT Id, Title, Summary FROM KnowledgeArticleVersion WHERE Id =:artId 
            //AND language='en_US' AND PublishStatus='online' LIMIT 1];
            //return kav;
        }  
    }*/
   
    /* public void AddAttachment(id caseid) { 
        try{
            insert Case_Attachment; 
            if(Case_Attachment.Name != null && Case_Attachment.Body != null){ 
                if(Case_Attachment.Body.size() < 10000000) { 
                    //Case_Attachment.parentid = caseid;
                    insert Case_Attachment;     
                    Case_Attachment = null;
                }
                else {}
            }
        }catch(Exception ex){
        }
        
       // return null;
     }*/
     
    /* @RemoteAction
    Public Static String createCaseRemote(string casedetails) {
        string CaseNumber;
        case CaseNum;
        Case c = new case();
        id mechid;
        id Elecid; 
        String[] casedetail = casedetails.split(',');
        
        system.debug('casedetail'+casedetail);
        
        if(casedetail.size() >1){
        string productid =casedetail[0];
        string partnumber = casedetail[1];
        string subject =casedetail[2];
        string description =casedetail[3];
        string actid =casedetail[4];
        string atachapter =casedetail[5];
        string inqtype =casedetail[6];
        string attname =casedetail[7];
        string attbody =casedetail[8];
        string contenttype =casedetail[9];
        
        List<Case> CaseList = new list<Case>(); 
        user u = [select id,contactid,User.Profile.Name from user where id =:userinfo.getUserId() limit 1];
        //attachment Case_Attachment = new Attachment();
        if(!u.Profile.Name.contains('System Administrator')) {
            contact con = [select id,accountid from contact where id =:u.contactid Limit 1];
            // Fetching Account team begins
            if (string.valueOf(con.accountid) != '') {
               List<AccountTeamMember> actmem = [select id,userid,AccountId,TeamMemberRole from AccountTeamMember where accountid =:con.accountid];
                for(AccountTeamMember act: actmem) {
                    if (string.valueOf(act.TeamMemberRole).contains('Field Service Engineer (FSE) - Mech')) {
                        mechid = act.userid;                   
                    }
                    if (string.valueOf(act.TeamMemberRole).contains('Field Service Engineer (FSE) - Elect')) {
                        Elecid = act.userid;
                    }
                }            
            }
            // Fetching Account team ends
        }
        //productid='a2qa0000000yPgD';
        if(productid!= null && productid != '' && productid!= 'undefined') {
            Supported_Products__c sp = [select id,Product_type__c from Supported_Products__c where id =: productid limit 1];
            
            if(sp.Product_type__c != null && sp.Product_type__c != '') {  
                if (string.valueOf(SP.Product_type__c).contains('Electrical')) {
                    c.Sub_Class__c = 'Electrical';
                   // c.Supported_Products__c = Product_TypeId_var;
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@Electrical(GTO)'+c.Sub_Class__c);
                }
                else if(string.valueOf(SP.Product_type__c).contains('Mechanical')) {
                    c.Sub_Class__c = 'Mechanical';
                    //c.Supported_Products__c = Product_TypeId_var;
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@Mechanical(GTO)'+c.Sub_Class__c);
                } 
                c.Supported_Products__c = productid;
            }
        }else{
            if(inqtype != null && inqtype != '' && inqtype!= 'undefined'){
            c.Sub_Class__c = inqtype;
            }
        }
        c.RecordtypeId = Label.SSCommunity_Technical_Issue;
        c.Classification__c = 'GTO'; 
        //if(!u.Profile.Name.contains('System Administrator')) {
            c.ContactID = u.contactId;
            system.debug('1111111111111111111111111111'+c.ContactID);
        //}
        if(partnumber != null && partnumber != '' && partnumber!= 'undefined') {
            c.Product_Part_Number__c =partnumber;
        }
        if(subject != null && subject != '' && subject != 'undefined') {
            c.Subject = subject;
        }else
          c.Subject ='IT Testing please ignore';
        if(description != null && description != '' && description != 'undefined') {
            c.Description = description;
        }
        c.Origin = 'Web';
        
        
        // Assigning Owner begins
        if(c.Sub_Class__c != null && c.Sub_Class__c != '') {
            if(c.Sub_Class__c == 'Electrical(GTO)') {
                    if(string.valueOf(elecid) != '' && string.valueOf(elecid) != null && !u.Profile.Name.contains('System Administrator')) {
                        c.ownerid = elecid;
                        system.debug(' c.ContactID '+c.ContactID);
                    }
                else {
                    c.ownerid = Label.SSCommunity_TOC_Elect_Team_ID;   //TOC Elect Team
                    system.debug(' TOC Elect Team');
                }
            }
            if(c.Sub_Class__c == 'Mechanical(GTO)') {
                    if (string.valueOf(mechid) != '' && string.valueOf(mechid) != null && !u.Profile.Name.contains('System Administrator')) {
                        c.ownerid = mechid;
                    }           
               else {
                   c.ownerid = Label.SSCommunity_TOC_Mech_Team_ID;    //TOC Mech Team
               } 
            }
        }
        else {
            c.ownerid = Label.SSCommunity_TOC_Team_ID;
        }
        // Assigning Owner ends
        
       // c.Detail_Class__c = Inquiry_Type_Details_var;
       system.debug('actid '+actid);
        if(actid != null && actid!= '' && actid != 'undefined'){
            c.Aircraft_Type__c = actid;
        }
        c.ATA_Chapter__c = atachapter;
        
        Savepoint spt = Database.setSavepoint();
        
        try{
                insert c;
             CaseNum = [select id, CaseNumber from case where id=:c.id];
           if(attname != 'null' && attbody != 'null'){ 
                if(attbody.length() < 10000000) {
                    attachment a= new attachment();
                    a.parentid =c.id;
                    a.name = attname;
                    a.ContentType =contenttype;
                    //a.body=EncodingUtil.base64Decode(attbody);
                    a.body=EncodingUtil.base64Decode(EncodingUtil.urlDecode(attbody,'UTF-8'));
                    insert a;
                }
           }
        }catch(Exception ex){
            Database.rollback(spt);
        
        }
        if(casenum != null){
        CaseNumber = CaseNum.CaseNumber;
        }
        }
        return CaseNumber; 
        }
    
    
    
     @RemoteAction
    Public Static List<Platform__c>SearchAircraft()  {
        //List<Platform__c> PlatformList = Database.Query('Select Id,name from platform__c where Name Like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC LIMIT 1000'); 
        List<Platform__c> PlatformList = Database.Query('Select Id,name from platform__c where Active__c = true'); 
        return PlatformList;    
    }
         @RemoteAction
    Public Static List<Supported_Products__c> SearchProduct() {
        //List<Platform__c> PlatformList = Database.Query('Select Id,name from platform__c where Name Like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' ORDER BY Name ASC LIMIT 1000'); 
        string status ='Active';
        List<Supported_Products__c> ProductList = Database.Query('Select Id,name from Supported_Products__c'); 
        return ProductList;    
    }
    @RemoteAction
    Public static List<string> aircraftValues() {
        List<AircraftTypes__c> mcs = AircraftTypes__c.getall().values();
        list<string> values=new list<string>();
        for(AircraftTypes__c ac:mcs)
           values.add(ac.name);
           return values;  
    }
    @RemoteAction
    Public static List<string> productTypeValues() {
        List<productType__c> pt = productType__c.getall().values();
        list<string> values=new list<string>();
        for(productType__c p:pt)
           values.add(p.name);
           return values;  
    }*/
     //Update Article Values---------------------------
    /** 
      * Method Name: updateArticleValues
      * Description : This method is used to store the feedback info by user from article to Feedback 
      * and Case objects conditionally.
    **/     
      /* public List<selectoption> getitems1() {
         List<SelectOption> options1 = new List<SelectOption>();  
                 options1.add(new SelectOption('Yes' , 'Yes'));  
              
                 
                 return options1;
       }
    
    public List<selectoption> getitems2() {
         List<SelectOption> options2 = new List<SelectOption>();  
                   
                 options2.add(new SelectOption('No' , 'No'));
                 
                 return options2;
       }
   
       
   public string rateId {get;set;}
   public string rateIds1 {get;set;}
   public string rateIds2 {get;set;}
   public string articleId {get;set;}
   public string mytext{get;set;}
   */
   //21/9/18:To store comment provided from feedback on TSSCommunityDetails
      /* public void save(){
    
    String userId1 = UserInfo.getUserId();
    List<Feedback__c>  obj1 = [SELECT Id,Article_Id__c,Article_Name__c,Article_Number__c,Article_Created_by_Full_Name__c,Interviewer_Name__c,Article_Type__c,Was_Article_Helpful__c, RecordTypeId FROM Feedback__c where Article_Id__c=: SelectedId and Interviewer_Name__c =:userId1  ]; // added article number for the task SCTASK2918929
     system.debug('####obj1' +obj1);
       
        obj1[0].Comments__c = mytext;
        update obj1 ;
    
    }*/
   /*
    Public void updateArticleValues() {
      //string Ids = apexpages.currentpage().getparameters().get('select');
      //String istrue = 'NA';
      string ownerId = '';*/
     /* if(Ids == 'Yes'){
      istrue = 'Yes';
      }
      if(Ids == 'No'){
      istrue = 'No';
      
      }*/
      
      /*
      SelectedId = ApexPages.currentPage().getParameters().get('Id');
      system.debug('*******Ids'+rateIds1 + '------rateIds2  '+rateIds2  );
      if(articleId  != null){
       SelectedId = articleId ;
      }
     // system.debug('*******Ids ****'+Ids );
       system.debug('*******Ids'+rateIds1 + '------rateIds2  '+rateIds2  );
      system.debug('*****------SelectedId '+SelectedId  );
      
      
      
      KnowledgeArticleVersion  objKnowledgeArticleVersion  =  [SELECT ArticleType,Id,ArticleNumber, CreatedById,CreatedBy.name, CreatedBy.Manager.name,LastModifiedById,LastModifiedBy.name,LastModifiedBy.Manager.name,KnowledgeArticleId,Title FROM KnowledgeArticleVersion where Id =: SelectedId]; // added article number for the task SCTASK2918929 , // added created , last modified fields for SCTASK3067866
      ownerId  = objKnowledgeArticleVersion.createdById;
      system.debug('*******objKnowledgeArticleVersion '+objKnowledgeArticleVersion  );
      String userId = UserInfo.getUserId();
       String caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
       String feedRecTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Article Feedback').getRecordTypeId();
       */
      /* User CreatedName = [Select name From User Where id =:ownerId];
      System.debug('****CreatedName***'+CreatedName.Name);
      
      User LastmodifiedName = [Select name From User Where id =:objKnowledgeArticleVersion.LastModifiedById];
      System.debug('****LastmodifiedName***'+LastmodifiedName.Name); */
      
      /*
      User objUser = [Select AccountId, ContactID From User Where id =: UserInfo.getUserId()];
      
          
     
      List<Feedback__c>  obj = [SELECT Id,Article_Id__c,Article_Name__c,Article_Number__c,Interviewer_Name__c,Article_Type__c,Was_Article_Helpful__c, Article_Created_by_Full_Name__c,Article_LastModified_By_Full_Name__c, Article_Created_by_Manager_name__c,Article_last_modified_manger_name__c,RecordTypeId, Status__c FROM Feedback__c where Article_Id__c=: SelectedId and Interviewer_Name__c =:userId  ]; // added article number for the task SCTASK2918929 ,  // added created , last modified fields for SCTASK3067866
       system.debug('*******obj ****'+obj );
      Feedback__c objFeed = new Feedback__c();
      if(obj.isEmpty()){
      
      
     
      objFeed.recordTypeId = feedRecTypeId ;
      objFeed.Was_Article_Helpful__c = istrue  ;
      objFeed.Interviewer_Name__c = UserInfo.getUserId();
      objFeed.Article_Id__c = objKnowledgeArticleVersion.id;
      objFeed.Article_Name__c = objKnowledgeArticleVersion.Title;
      objFeed.Article_Type__c = objKnowledgeArticleVersion.ArticleType;
      objFeed.Article_Number__c = objKnowledgeArticleVersion.ArticleNumber; // added article number for the task SCTASK2918929   
     objFeed.Article_Created_by_Full_Name__c = objKnowledgeArticleVersion.CreatedBy.name;
     objFeed.Article_LastModified_By_Full_Name__c = objKnowledgeArticleVersion.LastModifiedBy.name;
     objFeed.Article_Created_by_Manager_name__c = objKnowledgeArticleVersion.CreatedBy.Manager.name;
     objFeed.Article_last_modified_manger_name__c = objKnowledgeArticleVersion.LastModifiedBy.Manager.name;  // added created , last modified fields for SCTASK3067866
      objFeed.Customer_Feedback__c = mytext;
       system.debug('*******objFeed.Comments__c****'+objFeed.Comments__c );
      if(istrue == 'Yes'&& (string.ISBLANK(mytext))){
      objFeed.Status__c = 'Closed';
      }
      if(istrue == 'No'){
      objFeed.Status__c = 'Open';
      }  
      if(istrue == 'Yes'&& (!string.ISBLANK(mytext))){
      objFeed.Status__c = 'In Progress';
      }        
      insert objFeed ;
       system.debug('*******rateIds  ****'+rateIds1  );
      }
    
      
      if(obj != null && !obj.isEmpty()){
      obj[0].recordTypeId = feedRecTypeId ;
      obj[0].Was_Article_Helpful__c = istrue  ;
      obj[0].Interviewer_Name__c = UserInfo.getUserId();
      obj[0].Article_Id__c = objKnowledgeArticleVersion.id;
      obj[0].Article_Name__c = objKnowledgeArticleVersion.Title;
      obj[0].Article_Type__c = objKnowledgeArticleVersion.ArticleType;
      obj[0].Article_Number__c = objKnowledgeArticleVersion.ArticleNumber;  // added article number for the task SCTASK2918929
      obj[0].Article_Created_by_Full_Name__c = objKnowledgeArticleVersion.CreatedBy.name; 
      obj[0].Article_LastModified_By_Full_Name__c = objKnowledgeArticleVersion.LastModifiedBy.name;
      obj[0].Article_Created_by_Manager_name__c = objKnowledgeArticleVersion.CreatedBy.Manager.name;
      obj[0].Article_last_modified_manger_name__c = objKnowledgeArticleVersion.LastModifiedBy.Manager.name; // added created , last modified fields for SCTASK3067866
      obj[0].Customer_Feedback__c = mytext;
      if(istrue == 'Yes' && (string.ISBLANK(mytext))){
      obj[0].Status__c = 'Closed';
      }
      if(istrue == 'No'){
      obj[0].Status__c = 'Open';
      } 
      if(istrue == 'Yes' && (!string.ISBLANK(mytext))){
      obj[0].Status__c = 'In Progress';
      }      
      update obj[0] ;
       system.debug('*******obj[0]****'+obj[0]);
      }
      
      String SW_Version = 'NA'; 
        String FDE_Event = 'NA'; 
          String Phase_of_Flight = 'NA'; 
            String Fault_Messages = 'NA'; 
            String Title = objKnowledgeArticleVersion.Title; 
            String Description = 'NA'; 
            String Resolution = 'NA'; 
            String Supported_Product = ''; 
            Id objContactId= objUser.ContactId;
            String Aircraft_Type = 'NA';
            
            
       if(objKnowledgeArticleVersion.ArticleType== 'Technical_Solutions__kav' ){
          list<Technical_Solutions__kav> lstTech  = [SELECT Aircraft_Type__c,FAQ__c, publishstatus, ArticleType,Article_Details_del__c,Honeywell_Part_Number__c,Id,KnowledgeArticleId,Model_Name__c,
           Solution_Number__c,Solution_Title__c,Summary,Title FROM Technical_Solutions__kav Where publishstatus = 'Online' and Id =: objKnowledgeArticleVersion.id];
           
           Technical_Solutions__kav objTech = lstTech[0];
           Description = objTech.Article_Details_del__c;
           Aircraft_Type = objTech.Aircraft_Type__c;
      }
      
      
      else if(objKnowledgeArticleVersion.ArticleType== 'Technical_Videos__kav' ){
          
          list<Technical_Videos__kav> lstTech  = [SELECT Aircraft_Type__c,Honeywell_Part_Number__c, FAQ__c, Solution_Details__c, ArticleType,Id,KnowledgeArticleId,Model_Name__c,PublishStatus,Title FROM Technical_Videos__kav Where publishstatus = 'Online' and Id =: objKnowledgeArticleVersion.id];
          
          Technical_Videos__kav objTech = lstTech[0];
          Description = objTech.Solution_Details__c;
          Aircraft_Type = objTech.Aircraft_Type__c;
      }
      
      else if(objKnowledgeArticleVersion.ArticleType == 'Knowledge_Article__kav' ){
          
           list<Knowledge_Article__kav> lstTech  = [SELECT AC_Type__c,Answer_Solution__c, Environment__c, ArticleType,Fault_Messages__c,FDE_Event__c,KCS_Coach__c,KnowledgeArticleId,Model_Name__c,Phase_of_Flight__c,PN__c,PublishStatus,Question_Problem__c,Status_Technical_Review__c,Supported_Products__c,Supported_Product_Name__c,SW_Version__c,Technical_reviewer__c,Title FROM Knowledge_Article__kav  Where publishstatus = 'Online' and Id =: objKnowledgeArticleVersion.id];
           
           Knowledge_Article__kav objTech = lstTech[0];
          Description = (objTech.Question_Problem__c + objTech.Environment__c) != null ? (objTech.Question_Problem__c + objTech.Environment__c) : 'N/A' ;
           Resolution = objTech.Answer_Solution__c != null ? (objTech.Answer_Solution__c) : '' ;
           Supported_Product = objTech.Supported_Products__c;
           Fault_Messages= objTech.Fault_Messages__c;
           Phase_of_Flight = objTech.Phase_of_Flight__c;
           FDE_Event = objTech.FDE_Event__c;
           SW_Version= objTech.SW_Version__c;
      }
      
       
       if((objFeed != null ||  obj[0] != null ) &&  istrue == 'Yes' ){
          TriggerInactive.testTrigger = false;
          Case objCase = new Case();
          objCase.Subject =  Title;
          objCase.Description =Description.replaceAll('<[^>]+>',' ');
          objCase.Additional_Web_Form_Info__c   = Description.replaceAll('<[^>]+>',' ');
          objCase.SW_Version__c = SW_Version;
          objCase.FDE_Event__c  = FDE_Event;
          objCase.Fault_Messages__c = Fault_Messages;
          objCase.Phase_of_Flight__c = Phase_of_Flight;
          objCase.Resolution__c = Resolution.replaceAll('<[^>]+>',' ');
          objCase.Supported_Product__c =Supported_Product;
          objCase.status = 'Closed';
          objCase.ContactId = objContactId;
          objCase.AircraftType__c = Aircraft_Type;
          objCase.No_of_Contacts_to_Resolve__c = '1'; 
          objCase.ClosedDate = Datetime.now();
          objCase.CreatedDate = Datetime.now();
          objCase.Origin= 'Web';
          objCase.Export_Compliance_Content_ITAR_EAR__c = 'No';
          objCase.Government_Compliance_SM_M_Content__c= 'No';
          objCase.recordTypeId = caseRecTypeId;    
          objcase.ownerId = ID.valueOf(ownerId) ;
          objcase.Other__c= objKnowledgeArticleVersion.id;
          objcase.Created_by_feedback_submission__c = 'True';
          insert objCase; 
          
          String feedbackId = '';
         // if(obj.size() > 0){
          system.debug('***obj ********'+obj );
          //system.debug('***obj[0]********'+obj[0]);
          system.debug('***objFeed ********'+objFeed );
          if((obj != null && !obj.isEmpty()   && obj[0].Id != null ) || (objFeed != null && objFeed.Id != null))
          {
              system.debug('***inside********' );
              if(obj != null && !obj.isEmpty() && obj[0].Id != null)
               feedbackId =  obj[0].Id;
              else
               feedbackId =  objFeed.Id;
               
              Feedback__c objFeedbackNew = new Feedback__c(Id = feedbackId,Case__c= objCase.Id);
              //objFeedbackNew.Case__c= objCase.Id;
              update objFeedbackNew ;
              system.debug('***objFeed********'+objFeedbackNew );
              CaseArticle casart = new CaseArticle();
              casart.caseId = objCase.Id;
              casart.KnowledgeArticleId = objKnowledgeArticleVersion.KnowledgeArticleId ;
              system.debug('***casart********'+casart);
              if(casart != null){
                  insert casart; 
              }         

          
          }
          
         //  }   
           
        
        
          system.debug('******objCase*****'+objCase);
          //objCase.Status ='Closed';
         // update objCase; 
          system.debug('objCase'+objCase);
      } 
      
   
     //system.debug('*******obj[0]****'+obj[0]);
     //system.debug('*******obj[0]1111****'+[Select id,Was_Article_Helpful__c  from Feedback__c where Id =:obj[0].Id]);   
      
    }
    */


}