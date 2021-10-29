public class HwTrng_Coursedetail_cls {

Product2 c = new Product2();
public void getdetails()
{
Id  i = ApexPages.currentPage().getParameters().get('id');
 c  = [select name,Description,Level__c,Prerequisites__c,Who_Should_Attend__c,Hours_Of_Instruction__c,Per_student_Price__c,Duration__c  from Product2 where id =:i]; 

}
public Product2 getprod()
{
return c;
}
/*public String getName()
{
return c.name;
}
public String getDescription()
{
return c.Description;
}
public String getlevel()
{
return c.Level__c;
}
public String getPrerequisites()
{
return c.Prerequisites__c;
}
public String getwho()
{
return c.Who_Should_Attend__c;
}
public decimal gethours()
{
return c.Hours_Of_Instruction__c ;
}

public decimal getprice()
{
return c.Per_student_Price__c ;
}
public String getduration()
{
return c.Duration__c ;
}*/
}