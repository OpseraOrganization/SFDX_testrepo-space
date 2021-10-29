public class HwTrng_CancelReservation_cls
{
String  i = ApexPages.currentPage().getParameters().get('id');

public boolean msg{get;set;}
List<Reservation__c> r = new List<Reservation__c>();
{
if(i!= null)
{

r = [select name,Class__c,Course_Name__c,End_Date__c,Reservation_Status__c,Reservation_Type__c,Start_Date__c from Reservation__c where id = :i limit 1];
}
}
public Reservation__c getdetails()
{
return r[0];
}
public void cancel()
{
r[0].Reservation_Status__c = 'Cancel';
try
{
update r[0];
msg=True;
}
catch(Exception e )
{

//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot cancel this Reservation.');
//ApexPages.addMessage(myMsg);

}

}
public pagereference gotohome()
{
PageReference p =new PageReference('/apex/CP_Myreservations_VF');
return p ;
}
}