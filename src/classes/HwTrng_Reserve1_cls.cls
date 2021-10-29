public class HwTrng_Reserve1_cls {

Product2 c = new Product2();
List<Class__c> classlist = new List<Class__c>();
Id i;
public boolean showclass {get;set;}
public void getdetails()
{
 i = ApexPages.currentPage().getParameters().get('id');
 c  = [select name,Description,Level__c,Prerequisites__c,Who_Should_Attend__c,Hours_Of_Instruction__c,Per_student_Price__c,Duration__c from Product2 where id =:i]; 
// Modified for SR# 355122/358547 - Start
 //classlist = [select Class_Name__c,Total_Number_of_Seats__c,Start_Date__c,End_Date__c,Name,Location__c,duration__c,Number_of_reservations__c,Seats_Remaining__c,Location__r.name,Course__c,Product_Per_student_Price__c from Class__c where Course_name__c = :i and Start_Date__c >= Today];
 classlist = [select Class_Name__c,Total_Number_of_Seats__c,Start_Date__c,End_Date__c,Name,Location__c,duration__c,Number_of_reservations__c,Seats_Remaining__c,Location__r.name,Course__c,Product_Per_student_Price__c,status__C from Class__c where Course_name__c = :i and Start_Date__c >= Today];
// Modified for SR# 355122/358547 - End
 if(classlist.size()>0)
 showclass = True;
}
public String getName()
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
}
public List<Class__c> getclasses()
{
//classlist = [select Class_Name__c,Total_Number_of_Seats__c,Start_Date__c,End_Date__c,Name,Location__c,duration__c,Number_of_reservations__c,Seats_Remaining__c,Location__r.name,Course__c,Product_Per_student_Price__c,status__C from Class__c where Course_name__c = :i and Start_Date__c >= Today];

return classlist;
}


}