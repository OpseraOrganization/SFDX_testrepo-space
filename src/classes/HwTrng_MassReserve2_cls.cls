public class HwTrng_MassReserve2_cls 
{
    
    Class__c c = new Class__c();
    public  boolean showselectedlist{get;set;}
    public  boolean showdetails{get;set;}
    public  boolean lookupshow{get;set;}
    public  boolean dropdownshow {get;set;}
    public string relatedContactName;
    public string accid;
    public string addrow;
    list<String> selectedcontactlist = new List<String>();
    list<Reservation__c> rv  = new list<Reservation__c>();
    list<Reservation__c> reservetoinsert = new List<Reservation__c>();
    list<string> addrowname=New list<string>();
    List<Contact> ls=new list<contact>();
    list<ID> reservetoinsertadd = new List<ID>();
    List<Reservation__c> existcon=new  List<Reservation__c>();
    set<ID> oldcon = new set<ID>();
    Map<Id,String> conname=New Map<Id,String>();
    String  uid;
    Id i;
    public string callfunc{get;set;}
    
    public void getdetails()
    {
        uid=Userinfo.getuserid();
        //uid='005a000000AMx5EAAT';
        i = ApexPages.currentPage().getParameters().get('id');
        c  = [select name,contact__c,Course_Name__c,Description__c,End_Date__c,Start_Date__c,Product_Per_Student_Price__c,Course__c,Location__r.name,Duration__c,Seats_Remaining__c  from Class__c where id =:i]; 
        List<Contact> userlst =[select name,Accountid from Contact where Customer_Portal_UserId__c = :uid];  
        if(userlst.size()>0)
        accid=userlst[0].Accountid;
        existcon = [select Student__c from Reservation__c where Class_Name__r.ID =: i];
        
        if(existcon.size()>0)
        for(Reservation__c stdid :existcon)
        {
           oldcon.add(stdid.Student__c);
        }
        List<user> use=new List<user>();
        use = [select id,name,contactid from user where contact.accountid =:accid and  contactid not in : oldcon and contact.Honeywell_ID__c != '' and contact.Customer_Portal_UserId__c != '' and Federation_Formula__c != null and (ProfileId =: label.Training_Customer_Portal_label or ProfileId =: label.Training_and_Idea_Customer_Portal_label) and contactid != null limit 500];
        List<id> con12=new List<id>();
        for(user u12:use)
        {
           con12.add(u12.contactid);
        }
        if(use.size()>0)
        {           
            ls = [select id,name from contact where id=:con12];       
        }
        if(ls.size()>= 500)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'For Accounts with more than 500 Contacts, please select the Contact from the Lookup');
            ApexPages.addMessage(myMsg);
            dropdownshow =false;
            lookupshow=true;
        }
        else
        {        
            lookupshow=false;
            dropdownshow =true; 
        }
    }

    public class__c getclass()
    {
        return c;
    }
    public List<SelectOption> getlistofcontacts()    
    {      
        //string str=(Userinfo.getuserid()).substring(0,15); 
        List<SelectOption> options = new List<SelectOption>();                    
        options.add(new SelectOption('0001','--None--'));            
        for(Contact cn:ls)           
        {                   
            options.add(new SelectOption(cn.Id,cn.name));
            conname.put(cn.Id,cn.name);            
        } 
        //cn.clear();
        //showcontactpicklist=True;                    
        return options;   
    }
    
    public string getrelatedContactName()
    {
        return relatedContactName;
    }
    
    public void setrelatedContactName(string relatedContactName)
    {
        this.relatedContactName=relatedContactName;
    }
    
    public void addrow()
    {
        contact con;
        if(c.Contact__c != null || relatedContactName != null)
        {                   
            if(relatedContactName != null )
            {
                con=[select id,name,Customer_Portal_UserId__c,Honeywell_ID__c from contact where  id=:relatedContactName limit 1];
            }
            if(c.Contact__c != null && relatedContactName == null)
            {
                con=[select id,name,Customer_Portal_UserId__c,Honeywell_ID__c from contact where id=:c.Contact__c limit 1];
            }
            if(con.Honeywell_ID__c != null)
            {
                List<user> traininguser=[select id,name from user where Federation_Formula__c=:con.Honeywell_ID__c and (ProfileId =: label.Training_Customer_Portal_label or ProfileId =: label.Training_and_Idea_Customer_Portal_label) and contactid != null limit 1];               
                if(traininguser.size()<=0)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Sorry,the contact you have selected is not have an account in MyAerospace and needs to create an account prior to registration.');
                    ApexPages.addMessage(myMsg); 
                }
                else
                {
                    if(relatedContactName==Null)
                    {
                        if(oldcon.contains(c.Contact__c))
                        {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'This contact has been already reserved');
                            ApexPages.addMessage(myMsg);
                        } 
                        else 
                        {
                            List<Contact> Name = [Select id, name,Accountid from contact where id =: c.Contact__c];
                            if(Name[0].Accountid !=accid)
                            {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Sorry,the contact you have selected is not associated with your account');
                                ApexPages.addMessage(myMsg);
                            } 
                            else
                            {
                                selectedcontactlist.add(Name[0].name); 
                                showselectedlist=True;        
                                Reservation__c  rv0 = new Reservation__c();
                                rv0.Student__c =c.Contact__c;
                                rv0.Class_Name__c = i;
                                rv0.Reservation_Type__c = 'Item';
                                rv0.Reservation_Status__c = 'Registered';
                                rv0.Attended__c = 'No Show';
                                rv0.Booking_Per_student_Price__c = c.Product_Per_Student_Price__c;
                                reservetoinsert.add(rv0);
                            }
                        }
                    }  
                    else
                    {                                                                      
                        addrow=conname.get(relatedContactName);
                        selectedcontactlist.add(addrow);
                        showselectedlist=True; 
                        Reservation__c  rv0 = new Reservation__c();
                        rv0.Student__c =relatedContactName;
                        rv0.Class_Name__c = i;
                        rv0.Reservation_Type__c = 'Item';
                        rv0.Reservation_Status__c = 'Registered';
                        rv0.Attended__c = 'No Show';
                        rv0.Booking_Per_student_Price__c = c.Product_Per_Student_Price__c;
                        reservetoinsert.add(rv0); 
                    }
                }           
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Sorry,the contact you have selected is not have an account in MyAerospace and needs to create an account prior to registration.');
                ApexPages.addMessage(myMsg); 
            }
        }       
    }
    
    public List<String> getselectedcontactlist()
    {
        return selectedcontactlist ;
    }
         
    public void reserve()
    {
        System.debug('************************* Inside reserve block');
        try
        {
            insert reservetoinsert;
            
            if(reservetoinsert.size()>0)
                for(Reservation__c rev : reservetoinsert)
                {
                    reservetoinsertadd.add(rev.ID);
                }
                
            rv  = [select name,Reservation_Type__c,Reservation_Status__c,Student__c,Course_Name__c,Class_Name__c,Student_Name__c,Class__c from Reservation__c where Id In: reservetoinsertadd]; 
            showdetails = true;
            reservetoinsert.clear();
        }
        catch(Exception e)
        {
            String str = String.valueof(e);
            
            if(str.contains('Unique_Field__c duplicates value')||str.contains('INVALID_FIELD_FOR_INSERT_UPDATE'))
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
    public list<Reservation__c> getrv()
    {
        return rv;
    }

}