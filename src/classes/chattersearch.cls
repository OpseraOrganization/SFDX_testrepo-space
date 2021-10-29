public class chattersearch {


/* Constructor Function. The campaign id is captured in this function */
public chattersearch()
{
 cid=System.currentPageReference().getParameters().get('id');
}
/* Variable declarations */

Public String cid;                                                            // Stroes Campaign Id
public List<cContact> contactList {get; set;}                                 // Wrapper class which stores contact data and a boolean flag.
public Boolean selectAllCheckbox {get; set;} 
public boolean callwindow1{get;set;}//sucess message alert                                 // Stores checkbox data.
public boolean errormsg=false;                                                // Error msg. When no contact has been selected.
String userinput;                                                             // Contact Email
String userinp;                                                               // Contact Name
 public boolean closewindow{get;set;}
Public boolean displayboxes;

Public List<CollaborationGroup> results = new List<CollaborationGroup>();                                     // Contact search results.
Public List<CollaborationGroup> selectedContactsstep2 = new List<CollaborationGroup>();             // Selcted Contacts


/* End of Variable declarations */

/* Getter and setter methods for getting the user input ie. Contact name and email from the UI */

public String getuserinput(){return userinput;}
public void setuserinput(String userinp){this.userinput=userinp;}
public String getuserinp(){return userinp;}
public void setuserinp(String userinp){this.userinp=userinp;}


/*End of Getter and Setter methods */



/* Method to Search the contact database to fetch the query results */
public List<CollaborationGroup> contactsearch()
{
     system.debug('uuuuuuuuuuuuuuuuuuu'+userinput);
     errormsg=false;
     contactList = new List<cContact>();
     for(CollaborationGroup c : [SELECT Name,Description,CollaborationType,Owner.name from CollaborationGroup where name like :'%'+userinput+'%' and IsArchived = false])
     {
         contactList.add(new cContact(c));
     }

 return null;
}
/* End of method */


/* Method for returning the contact search results to the UI */
public List<cContact> getresults()
{

 return contactList;

}
/* End of Method */


/* Wrapper class to contain contact record and a boolean flag */
public class cContact
{
 public CollaborationGroup con {get; set;}
 public Boolean selected {get; set;}

 /*This is the contructor method. When we create a new cContact object we pass a
 Contact that is set to the con property. We also set the selected value to false*/
 public cContact(CollaborationGroup c)
 {
     con = c;
     selected = false;
 }
}
/* end of Wrapper class */


/* Method to fetch the selected records and send email to them */
public void processSelected()
{

  List<CollaborationGroup> selectedContacts = new List<CollaborationGroup>();
  if (contactList!= null)
  {
     for(cContact cCon : getresults()){
        if(cCon.selected == true){
             selectedContacts.add(cCon.con);
         }
     }

     selectedContactsstep2=selectedContacts;
  }
 /* return error message if no contact is selected */
 if (selectedcontacts.size()==0)
 {
     errormsg=true;
    // return null;
 }
 else
 {
     errormsg=false;
     callwindow1=true;
     String id=System.currentpagereference().getparameters().get('id');
      List<CustomerStory__c> t=[SELECT id,Name,Story_Type__c,Win_Against__c,Product__c,Solutions__c from CustomerStory__c where id=:cId]; 
        //List<CollaborationGroup> t1=[SELECT id,Name from CollaborationGroup where id=:stringList];
        for(CollaborationGroup t1:[SELECT id,Name from CollaborationGroup where id=:selectedcontacts ])
        {                  
            for(CustomerStory__c c:t)
            {                     
                system.debug('-------->test2222'+t1.id);   
                system.debug('-------->test2222'+c.name);     
                //String userID = '005e0000000ESvW';
                String groupId = t1.id;
                system.debug('test333--->'+groupId);
                FeedItem fitem=new FeedItem();
                fItem.parentId=groupId;
                fItem.linkUrl='/' + c.id;
                fitem.type = 'LinkPost';
                fItem.title='View';
                fItem.body=    c.Name +':Customer Story '+
                                + '\n\nTitle: ' + c.Name
                                + '\n\nStory Type:' + c.Story_Type__c
                                + '\n\nWin Against: ' + c.Win_Against__c
                                + '\n\nProducts: ' + c.Product__c
                                + '\n\nStory: ' + c.Solutions__c;
                             
                insert fItem;                       
            }
        }

 }
}
public List<SelectOption> getItems()
{
 List<SelectOption> options = new List<SelectOption>();
 options.add(new SelectOption('YES','YES'));
 options.add(new SelectOption('NO','NO'));
 return options;
}


/* return error message if no contact is selected */
public boolean geterrormsg()
{
 return errormsg;
}


/* Method to cancel the entire process */
public Pagereference Cancel()
{
        Pagereference p =new Pagereference('/'+cid);
        return p;
}
       

}