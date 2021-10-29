public with sharing class Reservationdetailcls {

    public String  uid ;
    private final Reservation__c reserv;
    public Reservation__c res=new Reservation__c();
     public String posId;
    public Reservationdetailcls(ApexPages.StandardController controller) {
        uid = Userinfo.getuserid();
        this.reserv= (Reservation__c ) controller.getRecord();
        posId= this.reserv.Id; 
        res= [SELECT id,Class_Name__c,Legacy_Id__c,LastModifiedDate ,CreatedDate,createdbyid,lastmodifiedbyid,Reservation_Name__c,End_Time__c,Start_Time__c,Reservation_Organizer__c,Reservation_Type__c,Entitlement__c,End_Date__c,Legacy_Confirmation_Key__c,Start_Date__c,Organizer_Email__c,Class__c,Attended__c,Student__c,Course_Name__c,Reservation_Status__c,email__c,Name FROM Reservation__c WHERE id=:posId];                       
    }
    public Reservation__c  getres()
    {
       return res;
    }
}