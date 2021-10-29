public class HwTrng_HomePage_cls{

String msg1,msg2,msg3,msg4,msg5,msg6,msg7,globalvar='show home page';
String msg11,msg12,msg13,msg14;
public string func1()
{
String retnurl = '/apex/HwTrng_HomePage_VF';
msg1= 'Show Classroom TRaining';
globalvar=null;
msg2 = null;
msg3=null;
msg4= null;
msg5=null;
msg6=null;
msg7=null;
msg11=null;
msg12=null;
msg13=null;
msg14=null;
return retnurl;
}
public PageReference func11()
{
PageReference p = new PageReference('/apex/HwTrng_Custlogin_VF');
return p;
}
public PageReference func12()
{
PageReference p = new PageReference('/apex/HwTrng_CourseSchedule_VF');
return p;
}
public PageReference func13()
{
PageReference p = new PageReference('/apex/HwTrng_CourseInfo');
return p;
}
public PageReference func14()
{
PageReference p = new PageReference('/apex/HwTrng_SpclTrngForm');
return p;
}
public PageReference func21()
{
PageReference p = new PageReference('/apex/HWTRNG_TrngLoc_VF');
return p;
}
public PageReference func22()
{
PageReference p = new PageReference('/apex/HWTRNG_Hotellist_VF');
return p;
}
public PageReference func31()
{
PageReference p = new PageReference('/apex/HwTrng_Vision_VF');
return p;
}
public PageReference func32()
{
PageReference p = new PageReference('/apex/HwTrng_Policies_VF');
return p;
}
public PageReference func33()
{
PageReference p = new PageReference('/apex/HwTrng_Curriculum_VF');
return p;
}
public PageReference func41()
{
PageReference p = new PageReference('/apex/HwTrng_Simulator_support_VF');
return p;
}
public PageReference func42()
{
PageReference p = new PageReference('/apex/HwTrng_TechPublication_VF');
return p;
}
public PageReference func43()
{
PageReference p = new PageReference('/apex/HwTrng_Contact_Us_SIS_VF');
return p;
}
public PageReference func51()
{
PageReference p = new PageReference('/apex/HwTrng_FrequentQuesVF');
return p;
}
public PageReference func52()
{
PageReference p = new PageReference('/apex/HwTrng_Directions_VF');
return p;
}
public PageReference func53()
{
PageReference p = new PageReference('/apex/HwTrng_Contact_Us_VF');
return p;
}
public PageReference func61()
{
PageReference p = new PageReference('/apex/HwTrng_MyCourses_VF');
return p;
}
public PageReference func62()
{
PageReference p = new PageReference('/apex/NetExamCustomerPortal');
return p;
}
public PageReference func63()
{
PageReference p = new PageReference('/apex/HwTrng_MyContracts_VF');
return p;
}
public PageReference func64()
{
PageReference p = new PageReference('/apex/HwTrng_MyEntitlement_VF');
return p;
}
public void func0()
{
msg2 = 'hiii';
}
public string func2()
{
String retnurl = '/apex/HwTrng_HomePage_VF';
msg1= null;
globalvar = null;
msg2 = 'show online training';
msg3=null;
msg4= null;
msg5=null;
msg6=null;
msg7=null;
return retnurl;
}
public string func3()
{
String retnurl = '/apex/HwTrng_HomePage_VF';
globalvar = null;
msg1= null;
msg2 = null;
msg3='show travel info';
msg4= null;
msg5=null;
msg6=null;
msg7=null;
return retnurl;
}
public string func4()
{
String retnurl = '/apex/HwTrng_HomePage_VF';
globalvar = null;
msg1= null;
msg2 = null;
msg3=null;
msg4 = 'Show Abt training Sol';
msg5=null;
msg6=null;
msg7=null;
return retnurl;
}
public string func5()
{
String retnurl = '/apex/HwTrng_HomePage_VF';
globalvar = null;
msg1= null;
msg2 = null;
msg3=null;
msg4 = null;
msg5 = 'show simulator';
msg6=null;
msg7=null;
return retnurl;
}
public string func6()
{
String retnurl = '/apex/HwTrng_HomePage_VF';
globalvar = null;
msg1= null;
msg2 = null;
msg3=null;
msg4 = null;
msg5 = null;
msg6 = ' show cps';
msg7=null;
return retnurl;
}
public string func7()
{
String retnurl = '/apex/HwTrng_HomePage_VF';
globalvar = null;
msg1= null;
msg2 = null;
msg3=null;
msg4 = null;
msg5 = null;
msg6 = null;
msg7 = 'show help';
return retnurl;
}
public string callmsg1()
{
String msg = '/apex/HwTrng_Test';
msg1=null;
msg2= 'hiii';
globalvar= null;
return msg;
}
public string getmsg1()
{
return msg1;
}
public string getmsg2()
{
return msg2;
}
public string getmsg3()
{
return msg3;
}
public string getmsg4()
{
return msg4;
}
public string getmsg5()
{
return msg5;
}
public string getmsg6()
{
return msg6;
}
public string getmsg7()
{
return msg7;
}
public string getglobalvar()
{
return globalvar;
}

//remove site 
public PageReference func54()
{
PageReference p = new PageReference('/apex/HwTrng_ClassroomTrng_VF');
return p;
}
public PageReference func55()
{
PageReference p = new PageReference('/apex/HwTrng_OnlineTraining_VF');
return p;
}
public PageReference func56()
{
PageReference p = new PageReference('/apex/HwTrng_TravelInfo_VF');
return p;
}
public PageReference func57()
{
PageReference p = new PageReference('/apex/HwTrng_AbtTrngSol');
return p;
}
public PageReference func58()
{
PageReference p = new PageReference('/apex/HwTrng_Simulator_VF');
return p;
}
public PageReference func59()
{
PageReference p = new PageReference('/apex/HWTRNG_CustFlightInfo_VF');
return p;
}
public PageReference func60()
{
PageReference p = new PageReference('/apex/HwTrng_Help_VF');
return p;
}
}