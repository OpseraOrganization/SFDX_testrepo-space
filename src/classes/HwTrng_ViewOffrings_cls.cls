public class HwTrng_ViewOffrings_cls {

   


    public HwTrng_ViewOffrings_cls(ApexPages.StandardController controller) {

    }

list<product2> CourseList=new list<product2>();

public list<product2> getCourselistrecrds()

{

return CourseList;
}

 public PageReference Courselist() {
 
 CourseList = [select id,Name,Description,isActive,Record_Type_Name__c from product2 where Record_Type_Name__c='Online' and isActive=TRUE and Make_this_course_public__c ='Yes'];

        return null;
    }


}