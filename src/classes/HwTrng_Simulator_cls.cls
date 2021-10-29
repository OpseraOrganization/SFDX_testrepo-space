public class HwTrng_Simulator_cls {

 public PageReference test() 
{
Pagereference p = new Pagereference('/apex/HwTrng_Simulator_support_VF');
return p;
}
public PageReference showsupport() 
{
Pagereference p = new Pagereference('/apex/HwTrng_Simulator_support_VF');
return p;
}
public PageReference showtechpub() 
{
Pagereference p = new Pagereference('/apex/HwTrng_TechPublication_VF');
return p;
}
public PageReference showcontact() 
{
Pagereference p = new Pagereference('/apex/HwTrng_Contact_Us_SIS_VF');
return p;
}
}