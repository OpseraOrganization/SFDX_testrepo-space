public class TOC_Live_Dashboard {
    public TOC_Live_Dashboard(ApexPages.StandardController controller) {}
    public Integer tsk7{get;set;}
    public Integer tsk8{get;set;}
    public Integer tsk9{get;set;}
    public Integer tsk10{get;set;}
    public Integer tsk11{get;set;}
    public Integer tsk12{get;set;}
    public Integer tsk13{get;set;}
    
    Public Integer cas7{get;set;}
    Public Integer cas8{get;set;}
    Public Integer cas9{get;set;}
    Public Integer cas10{get;set;}
    Public Integer cas11{get;set;}
    Public Integer cas12{get;set;}
    Public Integer cas13{get;set;}
    
    Public Integer curval2{get;set;}
    public Integer lastval2{get;set;}
    Public Integer fcrper0{get;set;}
    public Integer lastfcrper0{get;set;}
    public Integer NSS1{get;set;}
    public Integer LastNSS1{get;set;}
    public Integer fsecases0{get;set;}
    public Integer fbval0{get;set;}
    public Integer Lastfbval00{get;set;}
    public List<Case> uname0{get;set;}
    public Integer tsval{get;set;}
    public Integer tsval2{get;set;}
    public Integer tsval3{get;set;}
    public Integer tsval4{get;set;}
    // For report Case Volume This Week
    public PageReference thisweekcase(){
        //PageReference ref = new PageReference('https://na13.salesforce.com/00Oa0000007vNUl');
        String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        PageReference ref = new PageReference(strbaseURL +'/00Oa0000007vNUl');
        return ref;
    }
    // Owner Manager = 'Patrick Beem,William Kirkham' Record Type = Technical Issue
    Integer tsk0 = [SELECT Count() FROM Case WHERE CreatedDate = THIS_WEEK and Day_of_the_Week__c = 'Sunday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer tsk1 = [SELECT Count() FROM Case WHERE CreatedDate = THIS_WEEK and Day_of_the_Week__c = 'Monday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer tsk2 = [SELECT Count() FROM Case WHERE CreatedDate = THIS_WEEK and Day_of_the_Week__c = 'Tuesday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer tsk3 = [SELECT Count() FROM Case WHERE CreatedDate = THIS_WEEK and Day_of_the_Week__c = 'Wednesday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer tsk4 = [SELECT Count() FROM Case WHERE CreatedDate = THIS_WEEK and Day_of_the_Week__c = 'Thursday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer tsk5 = [SELECT Count() FROM Case WHERE CreatedDate = THIS_WEEK and Day_of_the_Week__c = 'Friday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer tsk6 = [SELECT Count() FROM Case WHERE CreatedDate = THIS_WEEK and Day_of_the_Week__c = 'Saturday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    
    // For report Case Volume Last Month
    public PageReference lastmonthcase(){
        //PageReference ref = new PageReference('https://na13.salesforce.com/00Oa0000007vNUq');
        String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        PageReference ref = new PageReference(strbaseURL +'/00Oa0000007vNUq');
        return ref;
    }
    // Owner Manager = 'Patrick Beem,William Kirkham' Recordtype = 'technicalIsse' Case Origin = Email
    Integer cas = [SELECT Count() FROM Case WHERE CreatedDate = LAST_MONTH and Day_of_the_Week__c = 'Sunday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer cas1 = [SELECT Count() FROM Case WHERE CreatedDate = LAST_MONTH and Day_of_the_Week__c = 'Monday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer cas2 = [SELECT Count() FROM Case WHERE CreatedDate = LAST_MONTH and Day_of_the_Week__c = 'Tuesday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer cas3 = [SELECT Count() FROM Case WHERE CreatedDate = LAST_MONTH and Day_of_the_Week__c = 'Wednesday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer cas4 = [SELECT Count() FROM Case WHERE CreatedDate = LAST_MONTH and Day_of_the_Week__c = 'Thursday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer cas5 = [SELECT Count() FROM Case WHERE CreatedDate = LAST_MONTH and Day_of_the_Week__c = 'Friday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    Integer cas6 = [SELECT Count() FROM Case WHERE CreatedDate = LAST_MONTH and Day_of_the_Week__c = 'Saturday' and RecordtypeId ='01230000000ZJvUAAW' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham') and status != 'cancelled'];
    
    
    Decimal fcrper1=0,lastfcrper1=0,curval=0,lastval=0,fbval=0,fbval1=0,fbval2,lastfbval=0,lastfbval1=0,lastfbval2;
    Integer fcrper,lastfcrper,curval1,lastval1,fbval3,lastfbval3;
            
    //For Report TOCTTGF for value current month of Avg Case Age TTGF
    List<case> curTTGFList = [SELECT Age_Custom_in_Hours__c FROM Case WHERE ClosedDate = THIS_MONTH AND RecordTypeId = '01230000000ZJvU' AND (Status = 'Done' OR Status = 'Completed') and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    Integer curTTGF = [SELECT Count() FROM Case WHERE ClosedDate = THIS_MONTH AND RecordTypeId = '01230000000ZJvU' AND (Status = 'Done' OR Status = 'Completed') and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    //For Report TOCTTGFLastWeek for value last month result of Avg Case Age TTGF
    List<case> TTGFList = [SELECT Age_Custom_in_Hours__c FROM Case WHERE ClosedDate = LAST_MONTH AND RecordTypeId = '01230000000ZJvU' AND (Status = 'Done' OR Status = 'Completed') and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    Integer TTGF = [SELECT Count() FROM Case WHERE ClosedDate = LAST_MONTH AND RecordTypeId = '01230000000ZJvU' AND (Status = 'Done' OR Status = 'Completed') and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    
    //For Report TOCFCR for This MOnth % FCR
    Integer FCR = [SELECT Count() FROM Case WHERE ClosedDate = THIS_MONTH AND (Status = 'Done' OR Status = 'Completed') AND RecordTypeId = '01230000000ZJvU' AND Origin = 'Phone' AND OwnerID__r.UserRole.name LIKE '%TOC%' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    List<Case> FCRlist = [SELECT CalcFCR__c,OwnerID__r.UserRole.name FROM Case WHERE ClosedDate = THIS_MONTH AND (Status = 'Done' OR Status = 'Completed') AND RecordTypeId = '01230000000ZJvU' AND Origin = 'Phone' AND OwnerID__r.UserRole.name LIKE '%TOC%' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    //For Report TOCFCRLastWeek for Last month value % FCR
    Integer lastFCR = [SELECT Count() FROM Case WHERE ClosedDate = LAST_MONTH AND (Status = 'Done' OR Status = 'Completed') AND RecordTypeId = '01230000000ZJvU' AND Origin = 'Phone' AND OwnerID__r.UserRole.name LIKE '%TOC%' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    List<Case> lastFCRlist = [SELECT CalcFCR__c FROM Case WHERE ClosedDate = LAST_MONTH AND (Status = 'Done' OR Status = 'Completed') AND RecordTypeId = '01230000000ZJvU' AND Origin = 'Phone' AND OwnerID__r.UserRole.name LIKE '%TOC%' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    
    //For Report TOCNSS this month for value # of NSS Received
    Integer NSS = [SELECT count() FROM Feedback__c WHERE CreatedDate = THIS_MONTH AND RecordTypeId = '01230000000ZewI' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    //For Report TOCNSSLastMonth for value # of NSS Received
    Integer lastNSS = [SELECT count() FROM Feedback__c WHERE CreatedDate = LAST_MONTH AND RecordTypeId = '01230000000ZewI' and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    
    // For Report TOCNSS for This MOnth value % Overall NSS
    List<Feedback__c> fblist = [SELECT OS_Detractor__c,OS_Promoter__c FROM Feedback__c WHERE RecordTypeId = '01230000000ZewI' AND CreatedDate = THIS_MONTH and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    Integer fb = [SELECT count() FROM Feedback__c WHERE RecordTypeId = '01230000000ZewI' AND CreatedDate = THIS_MONTH and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    // For Report TOCNSSLastMonth for value % Overall NSS
    List<Feedback__c> lastfblist = [SELECT OS_Detractor__c,OS_Promoter__c FROM Feedback__c WHERE RecordTypeId = '01230000000ZewI' AND CreatedDate = LAST_MONTH and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    Integer lastfb = [SELECT count() FROM Feedback__c WHERE RecordTypeId = '01230000000ZewI' AND CreatedDate = LAST_MONTH and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    
    //For Report TOCEscalations VNUser for value # of Cases Escalated,CaseNumber,User VN Name and Age in hours
    Integer fsecases = [SELECT count() FROM Case WHERE RecordTypeId = '01230000000ZJvU' AND (Resolution_Tool__c INCLUDES ('VN PSE') OR Resolution_Tool__c INCLUDES ('VN FSE') OR Resolution_Tool__c INCLUDES ('VN Other')) AND (Status = 'On Hold' OR Status = 'On Hold Escalated' OR Status = 'Open') and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    List<Case> uname = [SELECT CaseNumber,Age_in_Hours__c,User_VN_Name__r.name FROM Case WHERE RecordTypeId = '01230000000ZJvU' AND (Resolution_Tool__c INCLUDES ('VN PSE') OR Resolution_Tool__c INCLUDES ('VN FSE') OR Resolution_Tool__c INCLUDES ('VN Other')) AND (Status = 'On Hold' OR Status = 'On Hold Escalated' OR Status = 'Open') and (Owner_Manager__c='Patrick Beem' or Owner_Manager__c='William Kirkham')];
    
    //For Report TOCCallVolumeThisWeek
    Integer tscallval = [SELECT count() FROM Task WHERE Subject LIKE '%Call%' AND ActivityDate = THIS_WEEK and (Assigned_Manager__c='Patrick Beem' or Assigned_Manager__c='William Kirkham')];
    
    //FOR Report TOC Email - This Week
    Integer tsemailval = [SELECT count() FROM Task WHERE Subject LIKE '%Email%' AND ActivityDate = THIS_WEEK and (Assigned_Manager__c='Patrick Beem' or Assigned_Manager__c='William Kirkham')];
    
    //For Report TOCCallVolumeLastMonth
    Integer tscallval1 = [SELECT count() FROM Task WHERE Subject LIKE '%Call%' AND ActivityDate = LAST_MONTH and (Assigned_Manager__c='Patrick Beem' or Assigned_Manager__c='William Kirkham')];
    
    //FOR Report TOC Email - Last Month
    Integer tsemailval1 = [SELECT count() FROM Task WHERE Subject LIKE '%Email%' AND ActivityDate = LAST_MONTH and (Assigned_Manager__c='Patrick Beem' or Assigned_Manager__c='William Kirkham')];
    
    public TOC_Live_Dashboard(){
        tsk7=tsk0;tsk8=tsk1;tsk9=tsk2;tsk10=tsk3;tsk11=tsk4;tsk12=tsk5;tsk13=tsk6;
        cas7=cas;cas8=cas1;cas9=cas2;cas10=cas3;cas11=cas4;cas12=cas5;cas13=cas6;
        NSS1 = NSS; fsecases0 = fsecases;tsval = tscallval;tsval2 = tsemailval; 
        LastNSS1 = LastNSS; uname0 = uname;tsval3=tscallval1;tsval4=tsemailval1;
        if(curTTGFList.size()>0 && curTTGF>0){
            for(Integer i=0;i<curTTGFList.size();i++){
                curval = curval+curTTGFList[i].Age_Custom_in_Hours__c;
            }
            curval1 = Integer.valueOf(curval/curTTGF);
            curval2 = curval1;
        }
        if(TTGFList.size()>0 && TTGF>0){
            for(Integer i=0;i<TTGFList.size();i++){
                lastval = lastval+TTGFList[i].Age_Custom_in_Hours__c;
            }
            lastval1 = Integer.valueOf(lastval/TTGF);
            lastval2 = lastval1;
        }
        if(FCR>0 && FCRlist.size()>0){
            for(integer i=0;i<FCRlist.size();i++){
                fcrper1 = fcrper1+FCRlist[i].CalcFCR__c;
            }
            fcrper = math.round(fcrper1*100/FCR);
            fcrper0 = fcrper;
        }
        if(lastFCR>0 && lastFCRlist.size()>0){
            for(integer i=0;i<lastFCRlist.size();i++){
                lastfcrper1 = lastfcrper1+lastFCRlist[i].CalcFCR__c;
            }
            lastfcrper = math.round(lastfcrper1*100/lastFCR);
            lastfcrper0 = lastfcrper;
        }
        if(fblist.size()>0 && fb>0){
            for(Integer i=0;i<fblist.size();i++){
                fbval = fbval+fblist[i].OS_Promoter__c;
                fbval1 = fbval1+fblist[i].OS_Detractor__c;
            }
            fbval2 = math.round(((fbval-fbval1)*100)/fb);
            fbval3 = Integer.valueOf(fbval2);
            fbval0 = fbval3;
        }
        if(lastfblist.size()>0 && lastfb>0){
            for(Integer i=0;i<lastfblist.size();i++){
                lastfbval = lastfbval+lastfblist[i].OS_Promoter__c;
                lastfbval1 = lastfbval1+lastfblist[i].OS_Detractor__c;
            }
            lastfbval2 = math.round(((lastfbval-lastfbval1)*100)/lastfb);
            lastfbval3 = Integer.valueOf(lastfbval2);
            lastfbval00 = lastfbval3;
        }
    }
}