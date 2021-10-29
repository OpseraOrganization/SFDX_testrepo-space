public class TestReg_cls {
Class__c c = new Class__c();
public boolean showselectedlist{get;set;}
public boolean showdetails{get;set;}
//public string relatedContactName {get; set;}
 

list<Contact> selectedcontactlist = new List<Contact>();
list<Reservation__c> rv  = new list<Reservation__c>();
list<Reservation__c> reservetoinsert = new List<Reservation__c>();
list<ID> reservetoinsertadd = new List<ID>();
String  uid;
Id i;

public void getdetails(){
        system.debug('****************Userid******'+Userinfo.getuserid());
        i = ApexPages.currentPage().getParameters().get('id');
        //i= System.currentPagereference().getParameters().get('id');
        system.debug('************ID VALUE*************'+i);
        
        c  = [select name,Contact__c, Course_Name__c,Description__c,End_Date__c,Start_Date__c,Course__c,Location__r.name,Duration__c,Seats_Remaining__c  from Class__c where id =:i]; 
    }

public class__c getclass(){
        return c;
    }
 
public void addrow(){
         //system.debug('***********gotta*********'+c);
         contact addrow= new contact(id=c.Contact__c);
         selectedcontactlist.add(addrow);
         showselectedlist=True;
         Reservation__c  rv0 = new Reservation__c();
         rv0.Student__c = c.Contact__c;
         rv0.Class_Name__c = i;
         rv0.Reservation_Type__c = 'Item';
         rv0.Reservation_Status__c = 'Registered';
         rv0.Attended__c = 'No Show';
         reservetoinsert.add(rv0);
    } 
    
public List<contact> getselectedcontactlist(){
        List<Contact> Name = [Select id, name from contact where id in : selectedcontactlist];
        return Name;
    }
         
public void reserve(){
        System.debug('************************* Inside reserve block');
    try
        {
            insert reservetoinsert;
            if(reservetoinsert.size()>0)
        for(Reservation__c rev : reservetoinsert){
            reservetoinsertadd.add(rev.ID);
            selectedcontactlist.clear();
        }
            rv = [select name,Reservation_Type__c,Reservation_Status__c,Student__c,Course_Name__c,Class_Name__c,Student_Name__c,Class__c from Reservation__c where Id In: reservetoinsertadd]; 
            showdetails = true;
            showselectedlist = False;
            reservetoinsert.clear();
        }
    catch(Exception e)
        {
            String str = String.valueof(e);
            if(str.contains('Unique_Field__c duplicates value'))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You already have a reservation or Same contact has been added again.');
                ApexPages.addMessage(myMsg);
            }
    else
        {
            ApexPages.addMessages(e);
        }
            System.debug('************************* Exception in inserting reservation records');
        }
}

public list<Reservation__c> getrv(){
        return rv;
    }
    
public PageReference Done(){   
        Pagereference p = new Pagereference('/'+i);
        p.setredirect(true);
        return p;
    }        
}