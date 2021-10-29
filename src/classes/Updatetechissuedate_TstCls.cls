@isTest
private class Updatetechissuedate_TstCls
{
 static testmethod void Updatetechissuedate_TstMthd()
  {
        Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI',Market_Name__c='Space');insert a1;
        Contact cont=new Contact(firstname='Test',LastName='Contactfor upd',AccountId=a1.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E157567',Employee_Contact_Role__c='Administrator');
        insert cont;
        Feedback__c fedbck=New Feedback__c(Year__c='2011',Development_Weight__c=100.00,Development_Customer_Rating__c='Blue - Best in Class',Prod_LN_Prgm_Product_LIne__c='Advanced Programs', Quarter__c='Q1',Date_of_Interview__c=system.today(),Supplier_Rating_Syst__c='No',Contact__c=cont.id);
        insert fedbck;
        Service_Request__c serreq= new Service_Request__c(Subject__c='test ser',SR_Type__c='Field Event',Priority__c='AOG',status__c='Open',Problem_Description_new__c='hgcdatrd',Deliverable__c='htfrd',
        Risk_Assessment__c='Red',Contact_Name__c=cont.id,Customer_Due_Date__c=system.now()+1,Customer_Reason_Change__c='Original',Atr__c='Value',Attribute_Details__c='Allocation Priority',
        Complexity_Level__c='1-Part Price/Availability', 
        // HON_Commit_Date__c=system.now()+1,
        VOC_Card_Numb__c=fedbck.id);
        insert serreq;
        SR_Status__c srs=new SR_Status__c(Service_Request__c=serreq.id,SR_Status__c='test');
        insert srs;
        
        srs.SR_Status__c='test2';
        update srs;

}


}