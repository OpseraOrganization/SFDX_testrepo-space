public class HwTrng_Reserve3_cls {

Id i = ApexPages.currentPage().getParameters().get('id');
Reservation__c c  = [select name,Reservation_Type__c,Reservation_Status__c,Student__c,Course_Name__c,Class_Name__c from Reservation__c where id =:i]; 
public String getName()
{
return c.name;
}
public String getReservationType()
{
return c.Reservation_Type__c;
}
public String getReservationstatus()
{
return c.Reservation_Status__c;
}
public String getStudent()
{
return c.Student__c;
}
public String getCourseName()
{
return c.Course_Name__c;
}
public String getClassName()
{
return c.Class_Name__c;
}
}