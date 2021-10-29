public class HwTrng_Quicklinks_Cls {

public PageReference funcq1()
{
PageReference p = new PageReference('/apex/HwTrng_Contact_Us_VF');
return p;
}
public PageReference funcq2()
{
PageReference p = new PageReference('/apex/HwTrng_FrequentQuesVF');
return p;
}
public PageReference funcq3()
{
PageReference p = new PageReference('/apex/HwTrng_Trngrates');
return p;
}
public PageReference funcq4()
{
PageReference p = new PageReference('/apex/HwTrng_CAETrng');
return p;
}
}