public class HwTrng_Help_cls {

public pagereference showfaq()
{
Pagereference p = new Pagereference('/apex/HwTrng_FrequentQuesVF');
return p;
}
public pagereference showdirection()
{
Pagereference p = new Pagereference('/apex/HwTrng_Directions_VF');
return p;
}
public pagereference showcontact()
{
Pagereference p = new Pagereference('/apex/HwTrng_Contact_Us_VF');
return p;
}
}