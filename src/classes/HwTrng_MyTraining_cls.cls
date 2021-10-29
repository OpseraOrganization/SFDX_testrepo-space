public class HwTrng_MyTraining_cls {

public PageReference showtrainings()
{
PageReference p = new PageReference('/apex/HwTrng_MyCourses_VF?honeywellid=2222');
return p;
}
public PageReference showcontracts()
{
PageReference p = new PageReference('/apex/HwTrng_MyContracts_VF?honeywellid=2222');
return p;
}
public PageReference showentitlements()
{
PageReference p = new PageReference('/apex/HwTrng_MyEntitlement_VF?honeywellid=2222');
return p;
}
public PageReference showonlinetrainings()
{
PageReference p = new PageReference('/apex/NetExamCustomerPortal');
return p;
}
}