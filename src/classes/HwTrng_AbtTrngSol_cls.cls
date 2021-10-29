public class HwTrng_AbtTrngSol_cls {

public PageReference showvision()
{
PageReference p = new PageReference('/apex/HwTrng_Vision_VF');
return p;
}
public PageReference showpolicy()
{
PageReference p = new PageReference('/apex/HwTrng_Policies_VF');
return p;
}
public PageReference showcurriculum()
{
PageReference p = new PageReference('/apex/HwTrng_Curriculum_VF');
return p;
}
}