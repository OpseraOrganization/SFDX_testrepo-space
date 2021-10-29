/** * File Name: Test_Feedback_ApexClass
* Description Test Method
* Copyright : NTT DATA
* * @author :  NTT DATA
* Modification Log =============================================================== 
*  2/19/13-Modified to cover Duplicate_Check_for_Feedback trigger code
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest(SeeAllData=true)
private  class Test_Feedback_ApexClass {
static testmethod void testCallCenter(){
//creating account;
 Account acc= new Account(name='Test Account');
 insert acc;
 

//creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
 insert cont;
 List<RecordType> recordTypeList=new List<RecordType>();
        recordTypeList=[SELECT id,DeveloperName FROM RecordType WHERE DeveloperName IN ('SR_VOC','SR_VOC_GCC','SR_VOC_GCC_Read_Only')];

 RecordType[] rec1 = [Select Id,Name from RecordType where name='VOC'];
 Feedback__C voc= new Feedback__C(RecordTypeId=rec1[0].Id,contact__C=cont.Id,   Delivery_Weight__c=100, Delivery_Customer_Rating__c='Blue - Best in Class');
 insert voc;
 Go_Green_plan__C GGP= new Go_Green_plan__C(Account__c=acc.Id,contact__C=cont.Id);
 insert GGP;
Associated_VOC_Card_Number__c avcn= new Associated_VOC_Card_Number__c(Go_Green_Plan__c=ggp.Id,feedback_number__C=voc.Id);
 insert avcn;
 Associated_VOC_Card_Number__c avcn1= new Associated_VOC_Card_Number__c(Go_Green_Plan__c=ggp.Id,feedback_number__C=voc.Id);
 try{
 insert avcn1;
 }catch(Exception e){
    //Catch code
}
 
Service_Request__c SRrec1 = new Service_Request__c(recordtypeid=recordTypeList[0].id,VOC_Card_Numb__c=voc.id,Contact_Name__c=cont.id);              
            insert SRrec1;
Deliverable_item__c di1 = new Deliverable_item__c(SR_Number__c=SRrec1.id,Go_Green_Plan__c=ggp.Id,CSB_owner__c = 'test', Function__c = 'CBM', Honeywell_Site__c = 'Australia', progress_to_go_green__c = 'red');              
        insert di1;
SRrec1.Problem_Description__c = 'test';
update SRrec1;
}// end of method
}// end of class