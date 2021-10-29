@isTest
public class CustomGoogleReportCtrlTest {

       

public static Service_Request__c sro = new Service_Request__c();
public static Case css = new Case();
public static Planned_Meeting__c pm = new Planned_Meeting__c();


  static testMethod void testSRSearch(){
  test.startTest();
  CustomGoogleReportCtrl.SRSearch('ALL','open','all','global','a0Ja000000Qf0bVEAR','00130000015Ns2gAAC','Dassault','7017300-61010','2015-06-05T18:29:33.000Z','2015-09-22T22:28:16.000Z','By Quarter','yes','no','no',true);
  test.stopTest();
  }
  
  static testMethod void SRBothSearch(){
   test.startTest();
    //Openclosed = Closed 
     CustomGoogleReportCtrl.SRBothSearch('atr', 'Closed','all','americas','a0Ja000000Qf0bVEAR','00130000015Ns2gAAC','','','','','By Month','Yes','Yes','Yes');
    
    //openclosed = open
    CustomGoogleReportCtrl.SRBothSearch('bga', 'Open','all','global','','00130000015Ns2gAAC','','','','','By Month','Yes','Yes','Yes');
    test.stopTest();
}
  
  static testMethod void CaseSearchTest(){
  test.startTest();
  CustomGoogleReportCtrl.caseSearch('ATS','First Call Resolution','BGA','Open','all','americas','','','','','3204802-1-1','','','By Month','Yes','','','','Yes','Yes');
  test.stopTest();
  }
  
  static testMethod void CaseNSSSearchTest() {
  test.startTest();
  CustomGoogleReportCtrl.caseNSSSearch('ATS (Cases)','First Call Resolution','BGA','Open','all','americas','','','','3204802-1-1','','','By Month','Yes','','');
  test.stopTest();
  }
  
  static testMethod void PlannedMeetingSearchTest() {
    test.startTest();
    CustomGoogleReportCtrl.PlannedMeetingSearch('ATS','BGA','Expected','0013000000bFxtlAAC','','','By month');
    test.stopTest();
  }
  
   static testMethod void PlannedMeetingBothSrch() {
   test.startTest();
   CustomGoogleReportCtrl.PlannedMeetingBothSrch('ATS','BGA','both','','','','By month');
   test.stopTest();
    }
  
  static testMethod void getMonthTest() {

    test.startTest();
    
    date d = date.newInstance(1990,4,21);
    Integer year = d.dayOfYear();
    
    date myDate = Date.newInstance(1960,10,11);
    Integer yea = d.dayOfYear();
    String cqt = CustomGoogleReportCtrl.getMonth(year,yea,'month');
    test.stopTest();
   }
 
    static testMethod  void DataTest(){
    test.startTest();
    CustomGoogleReportCtrl.Data da = new CustomGoogleReportCtrl.Data('X Axis',12,12.12);
    test.stopTest();
    }
    static testMethod void DataBothTest() {
    test.startTest();
    CustomGoogleReportCtrl.DataBoth DaB = new CustomGoogleReportCtrl.DataBoth('X Axis', 20,15,20.15,20.16);
    test.stopTest();
    }
    
    static testMethod void NSSDataTest() {
    test.startTest();
    CustomGoogleReportCtrl.NSSData NSD = new CustomGoogleReportCtrl.NSSData('X Axis',24.12,24.56, 55);
    test.stopTest();
    }
    
  
    static testMethod void calculateAgeBucketTest() {
    test.startTest();
      String searchQuery ='SELECT count(Id) FROM Service_Request__c where';
      String searchQuery1 ='SELECT count(Id) FROM Case where';
      
    List<CustomGoogleReportCtrl.Data> dataList1 = CustomGoogleReportCtrl.calculateAgeBucket('SR',searchQuery,'Open', 'Bucket1');
    List<CustomGoogleReportCtrl.Data> dataList3 = CustomGoogleReportCtrl.calculateAgeBucket('SR',searchQuery,'Closed', 'Bucket1');
    List<CustomGoogleReportCtrl.Data> dataList2 = CustomGoogleReportCtrl.calculateAgeBucket('ATS Cases',searchQuery1 ,'Closed', 'Bucket1');
    List<CustomGoogleReportCtrl.Data> dataList4 = CustomGoogleReportCtrl.calculateAgeBucket('DTS Cases',searchQuery1 ,'Closed', 'Bucket1');
    List<CustomGoogleReportCtrl.Data> dataList5 = CustomGoogleReportCtrl.calculateAgeBucket('ATS Cases',searchQuery1 ,'Open', 'Bucket1');
    List<CustomGoogleReportCtrl.Data> dataList6 = CustomGoogleReportCtrl.calculateAgeBucket('DTS Cases',searchQuery1 ,'Open', 'Bucket1');
    //List<CustomGoogleReportCtrl.Data> dataList7 = CustomGoogleReportCtrl.calculateAgeBucket('Cases',searchQuery1 ,'Open', 'Bucket1');
    test.stopTest();
    }
    
    
    
    
/*
static   void createTestData(){

    sro.Account_Name__c = '00130000015Ns2gAAC';
    sro.Aircraft_Type__c = 'a0J30000001hSkyEAE';
    sro.Region__c = 'Americas';
    sro.Status__c = 'Closed';
    
    insert sro;
}


static  void createCaseData () {
    css.AccountId = '0013000000bFuVyAAK';
    insert css;
}



static testMethod void CaseNSSSearchTest() {
    
    test.startTest();
    createCaseData();
    
    List<CustomGoogleReportCtrl.NSSData> daaList = new List<CustomGoogleReportCtrl.NSSData>();
    List<Case> cssList = [SELECT AccountId,Age__c,Aircraft_Type__c,Enterprise__c,OEM_N__c,Part_Number__c,Region__c,SBU__c FROM Case limit 1];
    if (cssList != null || cssList.size() >0  )
    daaList = CustomGoogleReportCtrl.caseNSSSearch('ATS (Cases)','First Call Resolution',cssList[0].SBU__c,'Open',cssList[0].Enterprise__c,cssList[0].Region__c,'','',cssList[0].OEM_N__c,cssList[0].Part_Number__c,'','','By Month','Yes','','');
    System.assertEquals('0013000000bFuVyAAK',css.AccountId);
    
    test.stopTest();
}

static testMethod void SRBothSearchTest() {

    test.startTest();
    createTestData();
    
    List<CustomGoogleReportCtrl.Data> data = new  List<CustomGoogleReportCtrl.Data>();
    
    Map<Integer,CustomGoogleReportCtrl.DataBoth> Dm = new Map<Integer,CustomGoogleReportCtrl.DataBoth>();
    List<Service_Request__c> sroList = [SELECT Account_Name__c,Aircraft_Type__c,CreatedDate,Date_Closed__c,Enterprise__c,Product_Number__c,Region__c,SBU__c,SR_SBU__c,Status__c FROM Service_Request__c Limit 1];
    CustomGoogleReportCtrl Cgo = new CustomGoogleReportCtrl();
    
    if (sroList != null || sroList.size() >0  )
    
    //Openclosed = Closed 
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'Closed',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes',true);
    
    //openclosed = open
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'Open',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes',true);
    
    //openclosed = OnHold 
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'OnHold',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes',true);
    
    //openclosed = Monitor
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'Monitor',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes',true);
    
    //Trend ByQuarter
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'Open',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Quarter','Yes','Yes','Yes',true);
    
    //Enterprise = APU
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'Closed','APU',sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Quarter','Yes','Yes','Yes',true);
    
    //FromDate and ToDate = from date and to date
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'Closed','APU',sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','2013-01-03T17:22:09.000Z','2013-01-28T17:22:09.000Z','By Quarter','Yes','Yes','Yes',true);
   
    //FromDate and ToDate = from date and to date openclosed = open
    data = CustomGoogleReportCtrl.SRSearch(sroList[0].SBU__c, 'Open','APU',sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','2013-01-03T17:22:09.000Z','2013-01-28T17:22:09.000Z','By Quarter','Yes','Yes','Yes',true);


    //Testing SRBothSEarch 
    
    //Openclosed = Closed 
    Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Closed',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes');
    
    //openclosed = open
    Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Open',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes');
    
    //openclosed = OnHold 
    Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'OnHold',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes');
    
    //openclosed = Monitor
    Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Monitor',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes');
    
    //Trend ByQuarter
    Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Open',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Quarter','Yes','Yes','Yes');
    
    //Enterprise = APU
    Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Closed','APU',sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Quarter','Yes','Yes','Yes');
    
    //FromDate and ToDate = from date and to date
   // Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Closed','APU',sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','2013-01-03T17:22:09.000Z','2013-01-28T17:22:09.000Z','By Quarter','Yes','Yes','Yes');
   
    //FromDate and ToDate = from date and to date openclosed = open
    //Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Open','APU',sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','2013-01-03T17:22:09.000Z','2013-01-28T17:22:09.000Z','By Quarter','Yes','Yes','Yes');
    
    //Openclosed = Closed 
    //Dm  = CustomGoogleReportCtrl.SRBothSearch(sroList[0].SBU__c, 'Closed',sroList[0].Enterprise__c,sroList[0].Region__c,sroList[0].Aircraft_Type__c,sroList[0].Account_Name__c,'','','','','By Month','Yes','Yes','Yes');
   
   // System.assertNotEquals('0130000015Ns2gAAC',sro.Account_Name__c);
   //System.assertEquals('a0J30000001hSkyEAE',sro.Aircraft_Type__c);
    test.stopTest();
}

static  void CreatePMData() {

    pm.Account_Name__c='00130000014bmuAAAQ';
    pm.SBU__c = 'BGA';
    
    insert pm;
}

static testMethod void PlannedMeetingSearchTest() {

    test.startTest();
    CreatePMData();
    
    List<CustomGoogleReportCtrl.Data> daList = new List<CustomGoogleReportCtrl.Data>();
    List<Planned_Meeting__c> PmList = [SELECT Account_Name__c,Account__c,SBU__c FROM Planned_Meeting__c limit 1];
    CustomGoogleReportCtrl Cgo = new CustomGoogleReportCtrl();
    if (PmList != null || PmList.size() >0  )
    daList = CustomGoogleReportCtrl.PlannedMeetingSearch('ATS','BGA','Expected',PmList[0].Account_Name__c,'','','By month');
    System.assertNotEquals('0130000014bmuAAAQ',pm.Account_Name__c);
    System.assertEquals('BGA',pm.SBU__c);
    
    test.stopTest();

}


static testMethod void PlannedMeetingBothSrchTest() {

    test.startTest();
    CreatePMData();
    
    Map<Integer,CustomGoogleReportCtrl.DataBoth> Dm1= new Map<Integer,CustomGoogleReportCtrl.DataBoth>();
    List<Planned_Meeting__c> PmList = [SELECT Account_Name__c,Account__c,SBU__c FROM Planned_Meeting__c limit 1];
    CustomGoogleReportCtrl Cgo = new CustomGoogleReportCtrl();
    if (PmList != null || PmList.size() >0  )
    Dm1 = CustomGoogleReportCtrl.PlannedMeetingBothSrch('ATS','BGA','Expected',PmList[0].Account_Name__c,'','','By month');
    
    System.assertNotEquals('0130000014bmuAAAQ',pm.Account_Name__c);
    System.assertEquals('BGA',pm.SBU__c);
    
    test.stopTest();
}
*/

}