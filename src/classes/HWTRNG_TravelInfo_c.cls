public class HWTRNG_TravelInfo_c {

public PageReference showlocation()
{
PageReference p = new PageReference('/apex/HWTRNG_TrngLoc_VF');
return p;
}
public PageReference showhotels()
{
PageReference p = new PageReference('/apex/HWTRNG_Hotellist_VF');
return p;
}
}