@istest
public class HwTrng_TestClass2
{
    static testmethod void dotest()
    {
    RecordType r2 = [select id , name from RecordType where name='HoneywellTraining Location'];
    Location__c lh = new Location__c(Name = 'Taj', recordtypeid=r2.Id,Region__c = 'cochin',public__c = True);
    insert lh;
    RecordType r3 = [select id , name from RecordType where name='ClassRoom'];
    Product2 p = new Product2(Name = 'SFDC ADM Training',Description = 'ADM Course',Keywords__c = 'ADM',Make_this_course_public__c = 'Yes',isActive = TRUE,recordtypeid= r3.Id);
    insert p; 
    List<Class__c> lstClass = new List<Class__c>();
    Class__c cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day1'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day1'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day2'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day3'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day4'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day5'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day6'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day7'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day8'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day9'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day10'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day11'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day12'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day13'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day14'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day15'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day16'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day17'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day18'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day19'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day20'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day21'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day22'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day23'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day24'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day25'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day26'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day27'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day28'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day29'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day30'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day31'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day32'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day33'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day34'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day35'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day36'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day37'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day38'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day39'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day40'); 
    lstClass.add(cs);
    cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day41'); 
    lstClass.add(cs);
    insert lstClass;
    ApexPages.StandardController controller= new ApexPages.StandardController(cs);
    HwTrng_CourseSchedule_cls hc= new  HwTrng_CourseSchedule_cls(controller);
    hc.getClassRec();
    hc.getenddate();
    hc.getcriteria();
    hc.getfilter();
    hc.search();
    hc.getresults();
    hc.sortascend();
    hc.sortdescend();
    hc.Download();
    hc.setcriteria('Test');
    hc.getallclist();
    /*hc.sortascendclsname();
    hc.sortdescendclsname();
    hc.sortascendlction();
    hc.sortdescendlction();*/
    hc.sortascendstrdte();
    hc.sortdescendstrdte();
    hc.setClassRec(cs);
    Date d1 =Date.newInstance(2009,02,12);
    hc.setenddate(d1);
    hc.getshowdetails();
    hc.prev();
    hc.next();
    hc.next();
    hc.prev();
    /*HwTrng_OnlneTrng_cls onl = new HwTrng_OnlneTrng_cls(controller);
    onl.getCaseNewRec();*/
    //onl.Save();
    /*HwTrng_OnlneTrng_Non_HnyWell_emp_cls offl = new HwTrng_OnlneTrng_Non_HnyWell_emp_cls(controller);
    offl.getCaseNewRec();*/
   // offl.Save();
    HwTrng_SpclTrngForm_Cls spl = new HwTrng_SpclTrngForm_Cls(controller);
    spl.getCaseNewRec();
    spl.ClearForm();
   // spl.Save();
    
    HwTrng_ViewOffrings_cls hv= new HwTrng_ViewOffrings_cls(controller);
    hv.getCourselistrecrds();
    hv.Courselist();
    
    
    delete lstClass;
    hc= new  HwTrng_CourseSchedule_cls(controller);
    hc.next();
    
    
    }
}