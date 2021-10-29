@istest(seealldata=true)
public class HwTrng_TestClass3
{
    static testmethod void dotest()
    {
    List<Entitlement__c> eclist = new List<Entitlement__c>();
    List<Class__c> cllist = new List<Class__c>();
    List<Reservation__c> rllist = new List<Reservation__c>();
    CP_CourseInfo_cls c= new  CP_CourseInfo_cls();
    c.getcoursename();
    c.getcoursedescp();
    c.getcourseloc();
    c.getcoursekey();
    c.getmsg();
    c.getlocation();
    RecordType r2 = [select id , name from RecordType where name='HoneywellTraining Location'];
    Location__c lh = new Location__c(Name = 'Taj', recordtypeid=r2.Id,Region__c = 'cochin',public__c = True);
    insert lh;
    RecordType r3 = [select id , name from RecordType where name='ClassRoom'];
    Product2 p = new Product2(Name = 'SFDC ADM Training',Description = 'ADM Course',Keywords__c = 'ADM',Make_this_course_public__c = 'Yes',isActive = TRUE,recordtypeid= r3.Id);
    insert p; 
    Class__c cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day1'); 
    cllist.add(cs);
    Class__c cs1 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day2'); 
    cllist.add(cs1);
    Class__c cs2 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day3'); 
    cllist.add(cs2);
    Class__c cs3 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day4'); 
    cllist.add(cs3);
    Class__c cs4 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day5'); 
    cllist.add(cs4);
    Class__c cs5 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day6'); 
    cllist.add(cs5);
    Class__c cs6 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day7'); 
    cllist.add(cs6);
    Class__c cs7 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day8'); 
    cllist.add(cs7);
    Class__c cs8 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day9'); 
    cllist.add(cs8);
    Class__c cs9 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day10'); 
    cllist.add(cs9);
    Class__c cs10 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day11'); 
    cllist.add(cs10);
    Class__c cs11 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day12'); 
    cllist.add(cs11);
    Class__c cs12 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day13'); 
    cllist.add(cs12);
    Class__c cs13 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day14'); 
    cllist.add(cs13);
    Class__c cs14 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day15'); 
    cllist.add(cs14);
    Class__c cs15 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day16'); 
    cllist.add(cs15);
    Class__c cs16 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day17'); 
    cllist.add(cs16);
    Class__c cs17 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day18'); 
    cllist.add(cs17);
    Class__c cs18 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day19'); 
    cllist.add(cs18);
    Class__c cs19 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day20'); 
    cllist.add(cs19);
    Class__c cs20 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day21'); 
    cllist.add(cs20);
    Class__c cs21 = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day22'); 
    cllist.add(cs21);
    insert cllist;
    c.setcoursename('polymer');
    c.search();
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
    
    
    System.currentPagereference().getParameters().put('Id', cs.Id);
    CP_Coursedetail_cls hcd= new CP_Coursedetail_cls();
    hcd.getdetails();
    hcd.getprod();
    
    CP_Reserve1_cls  hr = new CP_Reserve1_cls();
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
    
    Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
    insert a1;
    Contact c1 = new Contact(lastname='Sumitha',firstname='menon',accountId=a1.Id,
Contact_Is_Employee__c=false,Phone_3__c ='9986555678',Honeywell_ID__c ='E6776');
insert c1;
Date d1 =Date.newInstance(2009,02,12);
RecordType r4 = [select id , name from RecordType where name='Training Contracts'];
    //Profile pf= [select id from Profile where name = 'Custom Customer Portal'];
    
        User u1;
        List<User> lstU1 = [select id from user where profileid = '00e300000017loa' and IsActive =true];
        if(lstU1!=null && lstU1.size() > 0)
        {
            u1=lstu1[0];
        }
        else
        {
            u1=new User (id=userinfo.getuserid());
        } 
    System.RunAs(u1)
    {
    CP_Myreservations cm0 = new CP_Myreservations();
    /*Contract ct = new Contract(Name='Text cnt',EndDate =d1,accountid=a1.Id,recordtypeid=r4.Id,Status='Draft');
    insert ct;
    ct.status= 'Active';
     update ct;*/
     Contract ct=[select id,name from Contract where status= 'Active' and accountid != null limit 1];
    CP_Myreservations cm1 = new CP_Myreservations();
    Entitlement__c ec1= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
   eclist.add(ec1);
    Entitlement__c ec2= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
     eclist.add(ec2);
    Entitlement__c ec3= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
   eclist.add(ec3);
    Entitlement__c ec4= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec4);
    Entitlement__c ec5= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec5);
    Entitlement__c ec6= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec6);
    Entitlement__c ec7= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec7 );
    Entitlement__c ec8= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec8);
    Entitlement__c ec9= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec9);
    Entitlement__c ec10= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec10);
    Entitlement__c ec11= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec11);
    Entitlement__c ec12= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec12);
    Entitlement__c ec13= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec13);
    Entitlement__c ec14= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec14);
    Entitlement__c ec15= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec15);
    Entitlement__c ec16= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
   eclist.add(ec16);
    Entitlement__c ec17= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec17);
    Entitlement__c ec18= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec18);
    Entitlement__c ec19= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec19);
    Entitlement__c ec20= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec20);
     Entitlement__c ec21= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec21);
    Entitlement__c ec22= new Entitlement__c(Contract_Number__c =ct.Id,Status__c='Active',Entitlement_type__c = 'Training');
    eclist.add(ec22);
    insert eclist;
  /*  RecordType r5 = [select id , name from RecordType where name='HoneywellTraining Location'];
    Location__c lch = new Location__c(Name = 'Taj', recordtypeid=r5.Id,Region__c = 'cochin',public__c = True);
    insert lch;
    RecordType r6 = [select id , name from RecordType where name='ClassRoom'];
    Product2 p = new Product2(Name = 'SFDC ADM Training',Description = 'ADM Course',Keywords__c = 'ADM',Make_this_course_public__c = 'Yes',isActive = TRUE,recordtypeid= r6.Id);
    insert p; 
    Class__c cs = new Class__c(Location__c=lch.Id,Course_name__c= p.Id,Class_Name__c = 'Day1'); 
    insert cs;*/
    Reservation__c r1 = new Reservation__c(Class_Name__c =cs.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r1);
     Reservation__c rs2 = new Reservation__c(Class_Name__c =cs1.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(rs2);
     Reservation__c rs3 = new Reservation__c(Class_Name__c =cs2.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(rs3);
     Reservation__c rs4 = new Reservation__c(Class_Name__c =cs3.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(rs4);
     Reservation__c r5 = new Reservation__c(Class_Name__c =cs4.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r5);
     Reservation__c r6 = new Reservation__c(Class_Name__c =cs5.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r6);
     Reservation__c r7 = new Reservation__c(Class_Name__c =cs6.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r7);
     Reservation__c r8 = new Reservation__c(Class_Name__c =cs7.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r8);
     Reservation__c r9 = new Reservation__c(Class_Name__c =cs8.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r9);
     Reservation__c r10 = new Reservation__c(Class_Name__c =cs9.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r10);
     Reservation__c r11 = new Reservation__c(Class_Name__c =cs10.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r11);
     Reservation__c r12 = new Reservation__c(Class_Name__c =cs11.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r12);
     Reservation__c r13 = new Reservation__c(Class_Name__c =cs12.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r13);
     Reservation__c r14 = new Reservation__c(Class_Name__c =cs13.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r14);
     Reservation__c r15 = new Reservation__c(Class_Name__c =cs14.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r15);
     Reservation__c r16 = new Reservation__c(Class_Name__c =cs15.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r16);
     Reservation__c r17 = new Reservation__c(Class_Name__c =cs16.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r17);
     Reservation__c r18 = new Reservation__c(Class_Name__c =cs17.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r18);
     Reservation__c r19 = new Reservation__c(Class_Name__c =cs18.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r19);
     Reservation__c r20 = new Reservation__c(Class_Name__c =cs19.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r20);
     Reservation__c r21 = new Reservation__c(Class_Name__c =cs20.Id,Student__c =c1.Id,Attended__c='NoShow'  );
     rllist.add(r21);
      insert rllist;
     
    CP_Myreservations cm = new CP_Myreservations();
    cm.getentitlements();
    cm.getcontractlist();
    cm.getstudseglist();
    cm.cancel();
    cm.prev();
    cm.next();
    cm.prevr();
    cm.nextr();
    
    Class__c csr = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day31'); 
   insert csr;
    HwTrng_Reserve2_cls htr = new HwTrng_Reserve2_cls();
   System.currentPagereference().getParameters().put('id', csr.Id);
  
    htr.getdetails();
    htr.getshowdetails();
    htr.getclass();
    //htr.reserve();
    htr.getdata();
    

    }
    }
}