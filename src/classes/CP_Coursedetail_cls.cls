public class CP_Coursedetail_cls {

Class__c c = new Class__c();
public void getdetails()
{
Id  i = ApexPages.currentPage().getParameters().get('id');
 c  = [select Product_Name__c,name,Course_Name__c,Product_Description__c,Product_Level__c,Product_Prerequisites__c,Product_Who_Should_Attend__c,Product_Hours_Of_Instruction__c,Product_Per_student_Price__c,Product_Duration__c  from Class__c where id =:i limit 1]; 

}
public Class__c getprod()
{
return c;
}

}