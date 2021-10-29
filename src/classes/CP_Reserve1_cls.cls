public class CP_Reserve1_cls {
public string paramval{get;set;}
public CP_Reserve1_cls(){
user Batchuser =new user();
 Batchuser = [select id,Batch_User__c from user where id =:Userinfo.getuserid()];
  if(Batchuser.Batch_User__c==False){
   pageblock1=false;
  }else{
  pageblock1=true;
  }
}
Class__c c = new Class__c();
List<Class__c> classlist = new List<Class__c>();
List<contact> lstcon=new List<contact>();
Id i;
public Class__c vid{ get; set; }
public boolean showclass {get;set;}
public boolean pageblock1{get;set;}
public boolean callwindow{get;set;}
public boolean callwindow1{get;set;}
public String  uid ;
public string relatedContactName {get; set;}
public void getdetails()
{
 uid = Userinfo.getuserid();
 i = ApexPages.currentPage().getParameters().get('id');
 system.debug('*****Idoffirstclass**********'+i);
 c  = [select Course_Name__c,Product_name__c,Product_Description__c,Product_Level__c,Product_Prerequisites__c,Product_Who_Should_Attend__c,
       Product_Hours_Of_Instruction__c,Product_Per_student_Price__c,Product_Duration__c,Total_Number_of_Seats__c,Start_Date__c,End_Date__c,
       Name,Location__c,duration__c,Number_of_reservations__c,Seats_Remaining__c,Location__r.name,Course__c,Description__c  from Class__c where id =:i]; 
// Modified for SR# 358547 - Start
//classlist = [select Class_Name__c,Total_Number_of_Seats__c,Start_Date__c,End_Date__c,Name,Location__c,duration__c,Number_of_reservations__c,Seats_Remaining__c,Location__r.name,Course__c,Product_Per_student_Price__c from Class__c where Course_Name__c = :c.Course_Name__c and start_date__c >= today];
classlist = [select Class_Name__c,Total_Number_of_Seats__c,Start_Date__c,End_Date__c,Name,Location__c,duration__c,Number_of_reservations__c,Seats_Remaining__c,
             Location__r.name,Course__c,Waitlist_students__c,Product_Per_student_Price__c,status__C from Class__c where Course_Name__c = :c.Course_Name__c  and start_date__c >= today];
// Modified for SR# 358547 - End
 if(classlist.size()>0)
 {
  showclass = True;
  }
 //Modified for SR# 385885 - Start
    callwindow=false;
    callwindow1=false;
    lstcon=[SELECT id,name,Service_Level__c,AccountId ,Customer_Portal_UserId__c FROM Contact WHERE Customer_Portal_UserId__c = :uid limit 1];      
    
}
 
public String getName()
{
return c.Product_name__c;
}
public String getDescription()
{
return c.Product_Description__c;
}
public String getlevel()
{
return c.Product_Level__c;
}
public String getPrerequisites()
{
return c.Product_Prerequisites__c;
}
public String getwho()
{
return c.Product_Who_Should_Attend__c;
}
public decimal gethours()
{
return c.Product_Hours_Of_Instruction__c ;
}

public decimal getprice()
{
return c.Product_Per_student_Price__c ;
}
public String getduration()
{
return c.Product_Duration__c ;
}
 public List<Class__c> getclasses()
{
return classlist;
}  
 public pagereference reserve() {
             
        system.debug('ttttttttttttt'+paramval);
       if(lstcon.size()>0)
       {  
        //Commented the below line for SR#403520 to remove the service level 'Refer to Network'     
        //if((lstcon[0].Service_Level__c == 'Unauthorized Dist/Brkr')||(lstcon[0].Service_Level__c == 'Refer to Network'))   
        if(lstcon[0].Service_Level__c == 'Unauthorized Dist/Brkr')     
        {    
           callwindow=true;        
        }
        else if(lstcon[0].AccountId == null)
        {
           callwindow1=true;
        }
        else
        {        
         pagereference ref=new pagereference('/apex/CP_Reserve2_VF?id='+paramval);
         return ref;
        }
       }          
     return null;
    }
}