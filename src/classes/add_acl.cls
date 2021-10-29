/*  * File Name: add_acl
    * Description: Controller for the Visualforce page to add users and contacts to Opportunity Team based on the CBT value
    * Copyright : Wipro Technologies Limited Copyright (c) 2010
    * @author : wipro
    * Modification Log ===============================================================
    * 31/8/2010 - Modified code to include the Opportunity Team Role values as per the record type for D&S and ATR
      Ver Date Author Modification --- ---- ------ -------------*
     */ 
public class add_acl
{
public boolean backto{get; set;}
public List<SelectOption> options1 = new List<SelectOption>();
private final ApexPages.StandardController controller;
public List<Role__c> RoleList = new List<Role__c>();
public String keySkill;
public boolean buttomDisp{get; set;}
public List<contactwrapper> contactList = new List<contactwrapper>();
List<String> rtypes1=new List<String>();
Public Id oppId1;
public add_acl(ApexPages.StandardController controller)
{

  RoleList=  [Select Name from Role__c where name!= null];
Oppid1=System.currentPageReference().getParameters().get('id');
String rtypename=[Select Id,Record_Type_Name__c from Opportunity where Id=:oppid1].Record_Type_Name__c;
System.Debug('rtypename'+rtypename);

    if(rtypename=='AM Standard' || rtypename=='AM Complex' || rtypename=='OE Standard'|| rtypename=='OE Complex'|| rtypename=='AM Catalog'){
        options1.add(new SelectOption('AGBM','AGBM'));
        options1.add(new SelectOption('AMERICAS Sales Leadership','AMERICAS Sales Leadership'));
        options1.add(new SelectOption('APAC Sales Leadership','APAC Sales Leadership'));
        options1.add(new SelectOption('Boeing Growth','Boeing Growth'));
        options1.add(new SelectOption('Business Administration','Business Administration'));
        options1.add(new SelectOption('Business Administration India','Business Administration India'));
        options1.add(new SelectOption('Business Management AMERICAS','Business Management AMERICAS'));
        options1.add(new SelectOption('Business Management APAC','Business Management APAC'));
        options1.add(new SelectOption('CBTL','CBTL'));
        options1.add(new SelectOption('Contracts','Contracts'));
        options1.add(new SelectOption('Customer Business Director','Customer Business Director'));
        options1.add(new SelectOption('Customer Business Manager','Customer Business Manager'));
        options1.add(new SelectOption('Customer Support','Customer Support'));
        options1.add(new SelectOption('Direct Sales','Direct Sales'));
        options1.add(new SelectOption('EMEAI Sales Leadership','EMEAI Sales Leadership'));
        options1.add(new SelectOption('HAT','HAT'));
        options1.add(new SelectOption('Leadership India','Leadership India'));    
        options1.add(new SelectOption('Platform Director Airbus','Platform Director Airbus'));
        options1.add(new SelectOption('Pricing','Pricing'));
        options1.add(new SelectOption('Proposal Operations','Proposal Operations'));
        options1.add(new SelectOption('Sales','Sales'));
        options1.add(new SelectOption('Sales Administration','Sales Administration'));
        options1.add(new SelectOption('Sales Airbus','Sales Airbus'));
        options1.add(new SelectOption('Sales Bombardier','Sales Bombardier'));
        options1.add(new SelectOption('Sales Components','Sales Components'));
        options1.add(new SelectOption('Sales Embraer','Sales Embraer'));
        options1.add(new SelectOption('Sales HIS','Sales HIS'));
        options1.add(new SelectOption('Sales Lead','Sales Lead'));        
        options1.add(new SelectOption('SBU Leadership','SBU Leadership'));
        options1.add(new SelectOption('SIOP','SIOP'));
        options1.add(new SelectOption('Technical Sales','Technical Sales'));
}
if(rtypename=='D&S PrePriced' || rtypename=='Complex' || rtypename=='Focus'|| rtypename=='Key'|| rtypename=='Standard' || rtypename=='D&S Run Rate'||
   rtypename=='Restricted Catalog' || rtypename=='Restricted Complex' || rtypename=='Restricted Focus' || rtypename=='Restricted Key' || rtypename=='Restricted Standard'){
        options1.add(new SelectOption('Aero Offset Director','Aero Offset Director'));
        options1.add(new SelectOption('C&PS','C&PS'));
        options1.add(new SelectOption('Campaign Mgr','Campaign Mgr'));
        options1.add(new SelectOption('Capture Mgr','Capture Mgr'));
        options1.add(new SelectOption('CBT C&PS','CBT C&PS'));
        options1.add(new SelectOption('CBT Contracts','CBT Contracts'));
        options1.add(new SelectOption('CBT Demand','CBT Demand'));
        options1.add(new SelectOption('CBT Engineering','CBT Engineering'));
        options1.add(new SelectOption('CBT Finance','CBT Finance'));
        options1.add(new SelectOption('CBT ISC','CBT ISC'));
        options1.add(new SelectOption('CBT Leader','CBT Leader'));
        options1.add(new SelectOption('CBT M&PM','CBT M&PM'));
        options1.add(new SelectOption('CBT Pricing','CBT Pricing'));
        options1.add(new SelectOption('CBT Sales Leader','CBT Sales Leader'));
        options1.add(new SelectOption('CBT Sales Operations','CBT Sales Operations'));
        options1.add(new SelectOption('CBT Sales Team Leader','CBT Sales Team Leader'));
        options1.add(new SelectOption('CBT Team Leader','CBT Team Leader'));
        options1.add(new SelectOption('Contracts','Contracts')); 
       options1.add(new SelectOption('D&S Global Engineering Outsource','D&S Global Engineering Outsource'));
         options1.add(new SelectOption('D&S ISC','D&S ISC'));
        options1.add(new SelectOption('D&S Leader','D&S Leader'));
        options1.add(new SelectOption('D&S Sales Leader','D&S Sales Leader'));
        options1.add(new SelectOption('D&S Tech Sales','D&S Tech Sales'));
         options1.add(new SelectOption('Engineering','Engineering'));
        options1.add(new SelectOption('Finance','Finance'));
         options1.add(new SelectOption('HR','HR'));
         options1.add(new SelectOption('ISC','ISC'));
        options1.add(new SelectOption('IT','IT'));
        options1.add(new SelectOption('M&PM','M&PM'));
        options1.add(new SelectOption('Other','Other'));        
        options1.add(new SelectOption('Pricing','Pricing'));
        options1.add(new SelectOption('Program Mgr','Program Mgr'));
        options1.add(new SelectOption('Proposal Mgr','Proposal Mgr'));
        options1.add(new SelectOption('Safety/Security Lead','Safety/Security Lead'));
        options1.add(new SelectOption('Sales','Sales'));
         options1.add(new SelectOption('SixSigma','SixSigma'));
         options1.add(new SelectOption('Tech Sales','Tech Sales'));
        options1.add(new SelectOption('Vol. Lead Mgr','Vol. Lead Mgr'));
        options1.add(new SelectOption('Vol. Lead Past Per.','Vol. Lead Past Per.'));
        options1.add(new SelectOption('Vol. Lead Tech.','Vol. Lead Tech.'));
                
}
/*Schema.DescribeFieldResult fieldResult  = Opportunity_Sales_Team__c.Opportunity_Team_Role__c.getDescribe();
 List<Schema.PicklistEntry> ple  = fieldResult.getPicklistValues();
 for( Schema.PicklistEntry f : ple)
                          {
                             options1.add(new SelectOption(f.getLabel(), f.getValue()));
                               }  */

} 
     public List<SelectOption> getoptions1()
          {
                return options1;
           }
                 public void setoptions1(List<SelectOption> sel1)
          {
                options1=sel1;
          }  
public Id oppId;
//Wrapper class usage for Users/Contacts
public class Contactwrapper
      {  
               public Role__c cnt{get; set;}
         public List<Contact> cntc = new List<Contact>();
         public List<User> cntu = new List<User>();
         public String SelecteRole{get;set;}
         public String SelecteRole1{get;set;}
         public Opportunity_Sales_Team__c cntt {get;set;}
         public List<SelectOption> options = new List<SelectOption>(); 
         
         public contactwrapper(Role__c roles,List<Contact> a,List<User> u,Opportunity_Sales_Team__c o)
           {
              cnt= roles;
               cntc = a;
               cntu = u;
               cntt = o;
                  system.debug('Contact :' + a);
                  if(a!=null)
               {   for(integer i=0;i<a.size();i++)
               {
                    system.debug('Contact Options :: ' + a );
                    options.add(new SelectOption(String.valueOf(a[i].Name)  ,String.valueOf(a[i].NAme)));
                    }
                    }
                  System.debug('options...........'+options);
                    if(u!=null)
                    {
                    for(integer i=0;i<u.size();i++)
                    {
                     options.add(new SelectOption(String.valueOf(u[i].Name)  ,String.valueOf(u[i].NAme)));
                     }
                     }
                 //    Schema.DescribeFieldResult fieldResult = null;
                 //    List<Schema.PicklistEntry> ple = new List<Schema.PicklistEntry>();
                  //   options1 = new List<SelectOption>(); 
                   


                       
          }
          
    
        public void setoptions(List<SelectOption> sel)
          {
                this.options=sel;
          }  
           public List<SelectOption> getoptions()
          {
                return this.options;
           }
    
            
   }
   public List<contactwrapper> getcontacts()
    {
         if(contactList.size()>0)
            return contactList;    
         else
            return null;
    }
  public void setcontacts(List<contactwrapper> con)
    {
        this.contactList=con;
    }
    
 //Function called when page is loaded. Queries the User and Contact having same CBT value as Oppportunity and having a functional role

     public Pagereference getretrieveData()
        {
             System.debug('calling retrieved data//////////////');        
        backto=false;
        oppId = System.currentPageReference().getParameters().get('id');
                 System.debug('Opportunity Id '+oppId);
                Opportunity o = [Select SBU__c,CBT_Tier_2__c from Opportunity where id=: oppId];
             //   keySkill =o.SBU__c;
                 keySkill =o.CBT_Tier_2__c;
                if (keySkill==null)
                {
                 backto=true;
                   buttomDisp=false;
                  System.debug('keySkill==null..........');
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There is no CBT associated to Opportunity. Please associate CBT to Opportunity in order to add User and Contacts. '));
                   return null;
                }
              List <Opportunity_Sales_Team__c> existContactRoles=[select Contact__c from  Opportunity_Sales_Team__c where Opportunity__c =: oppId];
              List<Opportunity_Sales_Team__c>existOppMem =[select User__c from  Opportunity_Sales_Team__c where Opportunity__C =: oppId]; 
                List <String>existContactRoleOpp=new List<String>();
                List <String>existOppMemS=new List<String>();
                  for (Opportunity_Sales_Team__c ocr :existContactRoles)
                  {
                    existContactRoleOpp.add(String.valueOf(ocr.Contact__c));
                  }
                  for (Opportunity_Sales_Team__c ocr :existOppMem)
                  {
                    existOppMemS.add(String.valueOf(ocr.User__c));
                  } 
                  System.debug('existOppMemS-- >  '+existOppMemS);
                  List <User>existingUsers=[Select Name ,User.Functional_Role__c,CBT__c, id from User where CBT__c =: keySkill and id not in :existOppMemS and Functional_Role__c!=null order by name];
                  System.debug('existingUsers-- >  '+existingUsers);
                  
                 List <Contact>existingContacts=[Select Name ,Contact.Functional_Role__c,CBT__c, id,Contact_Is_Employee__c from Contact where CBT__c =:keySkill and id not in :existContactRoleOpp and Functional_Role__c!=null and Contact_Is_Employee__c = true order by name];
                     System.debug('existing contacts..........'+ existingContacts);
              if (existingContacts.size()==0 &&existingUsers.size()==0)
                 {
                   backto=true;
                   buttomDisp=false;
                   System.debug('existing contacts is null');
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There are no Contacts Or Users associated To CBT '));
                   return null;
                 }
               else
                 {
                  buttomDisp=true;
                  System.debug('existing contacts..........'+ existingContacts);
                  System.debug('existing contacts.size..........'+ existingContacts.size());
                  System.debug('existing existingUsers.size..........'+ existingUsers.size());
                  System.debug('existing existingUsers..........'+ existingUsers);
            map<String,Contactwrapper> contactwrapperMap = new map<String,Contactwrapper>();
                 for (Contact c :existingContacts)
                    {
                      for(Role__c r: RoleList)
                      {
                         if(r.Name == c.Functional_Role__c)
                             {
                                if(contactwrapperMap.containskey(c.Functional_Role__c))
                                   {
                                      system.debug('Inside contains #####');
                                      contactwrapperMap.get(c.Functional_Role__c).cntc.add(c);
                                      contactwrapperMap.get(c.Functional_Role__c).options.add(new SelectOption(String.valueOf(c.Name)  ,String.valueOf(c.NAme)));
                                      system.debug('####:' +contactwrapperMap.get(c.Functional_Role__c).cntc);
                                    }
                                else
                                    {
                                      List<Contact> con = new List<contact>();
                                      con.add(c);
                                      contactwrapperMap.put(c.Functional_Role__c,new contactwrapper(r,con ,null,null));
                                    }
                      
                              } 
                       }
                     }
              //  map<String,Contactwrapper> contactwrapperMap1 = new map<String,Contactwrapper>();      
                   for (User c :existingUsers)
                     {
                       for(Role__c r: RoleList)
                           {
                              if(r.Name == c.Functional_Role__c)
                                 {
                                     if(contactwrapperMap.containskey(c.Functional_Role__c) && contactwrapperMap.get(c.Functional_Role__c).cntu!= null)
                                       {
                                         system.debug('Inside contains #####');
                                         contactwrapperMap.get(c.Functional_Role__c).cntu.add(c);
                                         contactwrapperMap.get(c.Functional_Role__c).options.add(new SelectOption(String.valueOf(c.Name)  ,String.valueOf(c.NAme)));
                                         system.debug('####:' +contactwrapperMap.get(c.Functional_Role__c).cntu);
                                        }
                                     else
                                     {
                                         List<User> con = new List<User>();
                                         con.add(c);
                                         contactwrapperMap.put(c.Functional_Role__c,new contactwrapper(r,null,con,null));
                                       }
                                  }
                            }
                    }
                   contactList = contactwrapperMap.values();
                   system.debug('contactList' + contactList );
                   
                   system.debug('contactList' + contactList );
                 } 
                 return null;
          }
    //Function called when user clicks on Insert button .Inserts records to Opportunity Sales team  
    public pagereference InsertSelected()
    {
     
      Opportunity_Sales_Team__c oppCr=null;
      Opportunity_Sales_Team__c teamMember = null;
      List<Opportunity_Sales_Team__c> oppCrLst = new List<Opportunity_Sales_Team__c>();
      List<Opportunity_Sales_Team__c> teamMembers = new List<Opportunity_Sales_Team__c>(); 
    Map<String,id> m = new Map<String,id>();
     List<id> s = new List<id>();
      for(integer i=0;i<contactList.size();i++)
     {
    if(contactList[i].cntc!= null)
    {
    for(integer j=0;j<contactList[i].cntc.size();j++)
    {
     if(contactList[i].cntc[j].name == contactList[i].SelecteRole)
     //s.add(cntwrap.cntc.id);
     m.put(contactList[i].SelecteRole,contactList[i].cntc[j].id);
     }
     }
     if(contactList[i].cntu!= null)
    {
    for(integer j=0;j<contactList[i].cntu.size();j++)
    {
     if(contactList[i].cntu[j].name == contactList[i].SelecteRole)
     //s.add(cntwrap.cntc.id);
     m.put(contactList[i].SelecteRole,contactList[i].cntu[j].id);
     }
     }
     }
      for(contactwrapper cntwrap:contactList)
        {
           System.debug('cntwrap.cntc****'+cntwrap.cntc);
          System.debug('cntwrap.cnt****'+cntwrap.cnt);
          System.debug('cntwrap.cnt****'+cntwrap.cnt.Id);
          System.debug('cntwrap.Role****'+cntwrap.SelecteRole);
          System.debug('cntwrap.Role1111****'+cntwrap.SelecteRole1);
       //   m.put(cntwrap.SelecteRole,c);
          if(cntwrap.cntc!=null && cntwrap.SelecteRole!= 'None')
          {
              oppCr=new Opportunity_Sales_Team__c ();
              oppCr.Opportunity__c=oppId;
           //   oppCr.Team_Role__c=cntwrap.cnt.Name;
          //    oppCr.Contact__c=cntwrap.cntc[0].Id;
             oppCr.Contact__c=m.get(cntwrap.SelecteRole);
      //   oppCr.Contact__c=cntwrap.SelecteRole;
      System.debug('*************************'+cntwrap.SelecteRole1);
      if(cntwrap.SelecteRole1 == 'None')
      {      
             System.debug('*************************'+cntwrap.SelecteRole1);
             oppCr.Opportunity_Team_Role__c='';
             }
      else
              oppCr.Opportunity_Team_Role__c =cntwrap.SelecteRole1;
              
              oppCrLst.add(oppCr);
           }
           if(cntwrap.cntu!=null  && cntwrap.SelecteRole!= 'None')
          {
              teamMember=new Opportunity_Sales_Team__c  ();
              teamMember.Opportunity__c=oppId;
           //   teamMember.Team_Role__c=cntwrap.cnt.Name;
             teamMember.User__c=m.get(cntwrap.SelecteRole);
             System.debug('*************************'+cntwrap.SelecteRole1);
             if(cntwrap.SelecteRole1 == 'None')
             {
             System.debug('*************************'+cntwrap.SelecteRole1);
             teamMember.Opportunity_Team_Role__c='';
             }
             else
             {
              teamMember.Opportunity_Team_Role__c=cntwrap.SelecteRole1;
              }
              teamMembers.add(teamMember);
           }
         }
       try{
            if(oppCrLst.size()>0){
            insert oppCrLst;
            }
            if(teamMembers.size()>0){
            insert teamMembers;
            }
        }catch(Exception e){
            System.debug('Known Exception for Opportunity Share as Owner is same as Opportunity Team: '+e);
        }
      
      PageReference oppPage = new PageReference('/' + oppId);
      oppPage.setRedirect(true);
      return  oppPage;    
      }  
       //Function called when user clicks on Cancel button .Returns to the Opportunity record   
      public pagereference Cancelation()
     {
      PageReference oppPage = new PageReference('/' + oppId);
        oppPage.setRedirect(true);
        return  oppPage;
     } 
      //Function called when user clicks on Back button .Returns to the Opportunity record
      public PageReference Back()
    {
      PageReference oppPage = new PageReference('/' + oppId);
        return  oppPage; 
    }
}