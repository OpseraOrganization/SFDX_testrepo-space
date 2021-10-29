public class HWTRNG_ClassroomTrng_c{

public PageReference showschedule()
{
PageReference p = new PageReference('/apex/HwTrng_CourseSchedule_VF');
return p;
}
public PageReference showreq()
{
PageReference p = new PageReference('/apex/hwtrng_spcltrngform');
return p;
}
public PageReference showinfo()
{
PageReference p = new PageReference('/apex/HwTrng_CourseInfo');
return p;
}
}