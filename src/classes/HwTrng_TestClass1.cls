@isTest(SeeAllData=true)
public class HwTrng_TestClass1
{
    static testmethod void dotest()
    {
   //TriggerInactive.testReservationUpdateUsage = true;
    HwTrng_AbtTrngSol_cls ht = new HwTrng_AbtTrngSol_cls();
    ht.showvision();
    ht.showpolicy();
    ht.showcurriculum();
    
    HWTRNG_ClassroomTrng_c hwt = new HWTRNG_ClassroomTrng_c();
    hwt.showschedule();
    hwt.showreq();
    hwt.showinfo();
    
    HwTrng_FrqQues_cls fq = new HwTrng_FrqQues_cls();
    fq.getSol();
    fq.getallsol();
    
    HwTrng_Help_cls hlp = new HwTrng_Help_cls();
    hlp.showfaq();
    hlp.showdirection();
    hlp.showcontact();
    
    HwTrng_HomePage_cls cl = new HwTrng_HomePage_cls();
    cl.func1();
    cl.func11();
    cl.func12();
    cl.func13();
    cl.func14();
    cl.func21();
    cl.func22();
    cl.func31();
    cl.func32();
    cl.func33();
    cl.func41();
    cl.func42();
    cl.func43();
    
    cl.func51();
    cl.func52();
    cl.func53();
    
    cl.func0();
    cl.func2();
    cl.func3();
    cl.func4();
    cl.func5();
    cl.func6();
    cl.func7();
    cl.callmsg1();
    cl.getmsg1();
    cl.getmsg2();
    cl.getmsg3();
    cl.getmsg4();
    cl.getmsg5();
    cl.getmsg6();
    cl.getmsg7();
    cl.getglobalvar();
    
   HWTRNG_Hotellist_cls htl = new HWTRNG_Hotellist_cls();
    RecordType r1 = [select id , name from RecordType where name='Hotel'];
     RecordType r2 = [select id , name from RecordType where name='HoneywellTraining Location'];
    Location__c l = new Location__c(Name = 'Taj', recordtypeid=r1.Id,Region__c = 'cochin');
    insert l;
    htl.getallregions();
    
    HwTrng_MyTraining_cls mt = new HwTrng_MyTraining_cls();
    mt.showtrainings();
    mt.showcontracts();
    mt.showentitlements();
    mt.showonlinetrainings();
    
    HwTrng_Simulator_cls sm  = new HwTrng_Simulator_cls();
    sm.test();
    sm.showsupport();
    sm.showtechpub();
    sm.showcontact() ;
    
    HWTRNG_TravelInfo_c tr = new HWTRNG_TravelInfo_c();
    tr.showlocation();
    tr.showhotels();
    
     System.currentPagereference().getParameters().put('region', l.Region__c);
     HWTRNG_TrngHotel_cls th = new HWTRNG_TrngHotel_cls();
     th.getstr();
     th.getallregions();
     
    Location__c lh = new Location__c(Name = 'Taj', recordtypeid=r2.Id,Region__c = 'asia',public__c = True,City__c='Bangalore',State__c='Karnataka',Postal_Code__c='081234s',Country__c='india'
         );
    insert lh;
    
    lh.Region__c='Europe';
    update lh;
    
    HWTRNG_TrngLoc2_cls trng = new HWTRNG_TrngLoc2_cls();
    trng.getallregions();
    trng.getstr();
    HWTRNG_TrngLoc_cls trl = new HWTRNG_TrngLoc_cls();
    trl.getallregions(); 
    
    HwTrng_Quicklinks_Cls qc= new HwTrng_Quicklinks_Cls();
    qc.funcq1();
    qc.funcq2();
    qc.funcq3();
    
    /* ********************************************************* */
    HwTrng_CourseInfo_cls c= new HwTrng_CourseInfo_cls();
    c.getlocation();
    c.getcoursename();
    c.getcoursedescp();
    c.getcourseloc();
    c.getcoursekey();
    c.getmsg();
    RecordType r3 = [select id , name from RecordType where name='ClassRoom'];
    Product2 p1 = new Product2();
    p1.Name = 'test product';
    p1.Description = 'test product';
    p1.Keywords__c = 'ADM';
    p1.Make_this_course_public__c = 'Yes';
    p1.isActive = TRUE;
    p1.recordtypeid='01230000000azJe';
    p1.Level__c='Level I';
    p1.Prerequisites__c='Good';
    p1.Who_Should_Attend__c='Very good class';
    p1.Hours_of_Instruction__c=12;
    p1.Duration__c='23';
    p1.Make_this_course_public__c='Yes'; 
    insert p1;
     
    p1.Description='ADM COURSE DETAILS';
    update p1;
    Class__c cs = new Class__c(Location__c=lh.Id,Course_name__c= p1.Id,Class_Name__c = 'Day1'); 
    insert cs;   c.search();
 
    c.setcoursename('polymer');
        c.setcoursename('SFDC ADM Training');
    c.setcoursedescp('ADM Course');
    c.setcourseloc('Taj');
    c.setcoursekey('ADM');
    c.search();
    c.getresults();
    c.prev();
    c.next();
    c.sortascend();
    c.sortdescend();
    
    
    System.currentPagereference().getParameters().put('Id', p1.Id);
    HwTrng_Coursedetail_cls hcd= new HwTrng_Coursedetail_cls();
    hcd.getdetails();
    hcd.getprod();
    
    HwTrng_Reserve1_cls  hr = new HwTrng_Reserve1_cls ();
    hr.getdetails();
    hr.getName();
    hr.getDescription();
    hr.getlevel();
    hr.getPrerequisites();
    hr.getwho();
    hr.gethours();
    hr.getprice();
    hr.getduration();
    hr.getclasses();
    
   /* System.currentPagereference().getParameters().put('Id', cs.Id);
    HwTrng_Reserve2_cls hrs = new HwTrng_Reserve2_cls();
    hrs.getdetails();
    hrs.getshowdetails();
    hrs.getclass();
    hrs.reserve();
    hrs.getName1();
    hrs.getReservationType();
    hrs.getReservationstatus();
    hrs.getStudent();
    hrs.getCourseName();
    hrs.getClassName();*/
    
    Contact acc=new Contact();
        acc.Lastname='Sample Contact';
        acc.firstname='Sample';
        acc.Address_Line_1__c = '';
        acc.Address_Line_2__c = '';
        acc.Address_Line_3__c = '';
        acc.City_Name__c = '';
        acc.Postal_Code__c = '';
        acc.State_Code__c = '';
        acc.Country_Name__c = '';
        acc.phone_3__c='89099';
        insert acc;
    Reservation__c rs = new Reservation__c(Class_Name__c = cs.Id,Attended__c='No Show', Student__c = acc.Id);
    insert rs;
     System.currentPagereference().getParameters().put('Id', rs.Id);
    HwTrng_Reserve3_cls hr3 = new HwTrng_Reserve3_cls();
    hr3.getName();
    hr3.getReservationType();
    hr3.getReservationstatus();
    hr3.getStudent();
    hr3.getCourseName();
    hr3.getClassName();
        
        
     HwTrng_CancelReservation_cls hc= new HwTrng_CancelReservation_cls();
     hc.getdetails();
     hc.cancel();   
    }
    
}