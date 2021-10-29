public class Sendreferencematerialcls{
 public String email1 {get; set;}
  public String name1 {get; set;}
  public String email2 {get; set;}
  public String name2 {get; set;}
  public String email3 {get; set;}
  public String name3 {get; set;}
    public List<String> stringList2 =new List<String>();
    public List<string> connamelist=new List<string>();    
    CustomIterable obj;
    CustomIterable obj1;
    public list<AccountInner> accInnerObj {get;set;}
     public list<AccountInner> conInnerObj {get;set;}
     //public String posId='006e0000002WwJq';
     public String posId=ApexPages.currentPage().getParameters().get('Id');
    List<Related_Customer_Stories__c> accs {get; set;} 
    List<contact> con  {get; set;} 
   public AccountInner accInner;
   public AccountInner conInner;
   public boolean callwindow{get;set;}//reference materail error alert
    public boolean callwindow1{get;set;}//sucess message alert
    public boolean callwindow2{get;set;}//contact error alert
    public boolean callwindow3{get;set;}//contact email error alert
    public opportunity conopp=[select id,name,AccountId from opportunity where id=:posId];
  public   list<AccountInner>   accInnerList;
  public   list<AccountInner>   conInnerList;
   String uid = Userinfo.getuserid();
   User usr = [Select id,Name,Email from User where id =: uid];
  public void echoVal()
    { 
     if(isSelectedAccts().size()==0)
     {
           callwindow = true;
           return;
     } 
     else
     { 
      callwindow = false;
     }    
      if(isSelectedCons().size() == 0 && email1 == '' && email2 == '' && email3 == '')
      {
       callwindow2 = true;
       return; 
       }
       else
       { 
       callwindow2 = false;
        }       
    }
    public void successMessage(){
       }
       
       public List<String> isSelectedAccts()
       {
        List<Related_Customer_Stories__c> selectedAccounts=new List<Related_Customer_Stories__c>();
         List<string> accSelectedList=new List<string>();       
         //  system.debug('selectedAccounts'+accInnerList);
         for(AccountInner accwrapper : accInnerList)
          {
            if(accwrapper.isSelected  == true)
            selectedAccounts.add(accwrapper.acc);
           system.debug('selectedAccounts'+selectedAccounts);
           
          }
           for(Integer a=0;a<selectedAccounts.size();a++)
            {
             accSelectedList.add(selectedAccounts[a].id);          
            }          
          return accSelectedList;        
      }     
       public List<contact> isSelectedCons()
       {
       List<contact>  conSelectedAccounts=new List<contact>();
        List<String>  conSelectedList=new List<String>();
        system.debug('conSelectedAccounts'+conInnerList);
         for(AccountInner accwrapper : conInnerList)
          {
            if(accwrapper.isConSelected == true)
            conSelectedAccounts.add(accwrapper.con);
           
            for(Integer a=0;a<conSelectedAccounts.size();a++)
            {
              conSelectedList.add(conSelectedAccounts[a].id);          
            }
          }
          
          return conSelectedAccounts;
      }      
  //  public list<ContactInner> conInnerObj {get;set;}
    public Sendreferencematerialcls() {       
        string sQuery = 'select id,Product__c,CustomerName__c,Opportunity__c,name,CustomerStory__c,Solutions__c from Related_Customer_Stories__c where Opportunity__c =:posId';
        accs = Database.Query(sQuery);
        accInnerList = new list<AccountInner>();   
       for(Related_Customer_Stories__c  a : accs) {
            accInner= new AccountInner(false, a);
            accInnerList.add(accInner);
       }
       Id temp =conopp.AccountId;
         string sQuery1 = 'SELECT AccountId,Name,Job_Title__c,Primary_Email_Address__c FROM Contact WHERE AccountId=:temp';
        con= Database.Query(sQuery1);
        conInnerList = new list<AccountInner>();    
       for(Contact a : con) {
            conInner = new AccountInner(false, a);
            conInnerList.add(conInner);
       }        
        obj = new CustomIterable(accInnerList); 
        obj.setPageSize = 10;
        next();
        
        obj1 = new CustomIterable(conInnerList); 
        obj1.setPageSize = 10;
        next1();
      callwindow2=false;  
      callwindow1=false; 
       callwindow=false;
    }
    public Boolean hasNext {
        get {
            return obj.hasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return obj.hasPrevious();
        }
        set;
    }
    public void next() {
        accInnerObj = obj.next();
    }   
    public void previous() {
        accInnerObj = obj.previous();
    }
    
   
    public Boolean hasNext1 {
        get {
            return obj1.hasNext();
        }
        set;
    }
    public Boolean hasPrevious1 {
        get {
            return obj1.hasPrevious();
        }
        set;
    }
    public void next1() {
        conInnerObj = obj1.next();
    }   
    public void previous1() {
        conInnerObj = obj1.previous();
    }
    public PageReference getSelected()
    {
    if(callwindow ||callwindow2 )
    return null;
    
         List<String> temp=isSelectedAccts();
         List<opportunity> newopp=[select id,name,Is_Reference_Materials_used__c from opportunity where id=:posId]; 
         //system.debug('accSelectedList'+accSelectedList);        
         List<opportunity> t1=new List<opportunity>();
         List<Related_Customer_Stories__c> rt1= new List<Related_Customer_Stories__c>();
         List<Related_Customer_Stories__c> t=[SELECT id,Name,CustomerStory__c,Files_Links_1__c,Files_Links_2__c, Video_link_mac__c from Related_Customer_Stories__c where id IN :temp];
          system.debug('test---->'+t);   
         List<String> cuslist=new List<String>();
          for(Integer b=0;b<t.size();b++)
            {
             cuslist.add(t[b].CustomerStory__c);          
            }
         List<CustomerStory__c> cus1=[SELECT id,Name,Contact__c,Story_Type__c,Files_Links_1__c,Files_Links_2__c,Video_link_mac__c,Win_Against__c,Product__c,Product_Name__c,Solutions__c from CustomerStory__c where id=:cuslist];
         List<String> cusid=new List<String>();
          for(Integer c=0;c<cus1.size();c++)
            {
             cusid.add(cus1[c].id);          
            }          
          system.debug('contactnames1'+connamelist);                           
          String htmlBody='';
          String htmlBody2=usr.name;
          String useremail=usr.email;
          String htmlBody1= 'I am sharing this story of a Honeywell customer who has achieved real benefits using the same technology for which you are interested. I hope you find this valuable and look forward to speaking with you further. In the interim, please contact me if you would like additional information or have questions.';           
               if(name1!= '')
           connamelist.add(name1);    
           if(name2!= '')
           connamelist.add(name2); 
            if(name3!= '')
           connamelist.add(name3); 
           string names1 =' ';
           
            List<contact> conSelectedAccounts1=isSelectedCons();
                for(Integer r=0;r<conSelectedAccounts1.size();r++)
                {
                    if(conSelectedAccounts1[r].name== null){
                    continue; 
                    }
                    else
                    {
                    connamelist.add(conSelectedAccounts1[r].name);
                    }                                                
                    system.debug('contactnames'+connamelist);
                }
                if(connamelist.size()>0){ 
                for(integer n=0;n<connamelist.size();n++)
                {  
                     names1 = names1 +connamelist[n]+'; ';                    
                 }
               }                         
            for(Related_Customer_Stories__c c:t)
            {                                       
                if (c.Files_Links_1__c != null && c.Files_Links_2__c != null && c.Video_link_mac__c != null)
                {  
                  htmlBody= htmlBody + '<br/><br/>Customer story:'+c.Name+'<br/><br/>PDF Link: '+ '<a href="'+c.Files_Links_1__c+'">Click Here</a>' + '<br/><br/>Video Link Windows:'+ '<a href="'+c.Files_Links_2__c+'">Click Here</a>'+ '<br/><br/>Video Link Mac:'+ '<a href="'+c.Video_Link_mac__c+'">Click Here</a>';                                 
                } 
                else if (c.Files_Links_1__c != null && c.Files_Links_2__c == null && c.Video_link_mac__c == null)
                {  
                  htmlBody= htmlBody + '<br/><br/>Customer story:'+c.Name+'<br/><br/>PDF Link: '+ '<a href="'+c.Files_Links_1__c+'">Click Here</a>';                                 
                } 
                else if (c.Files_Links_1__c == null && c.Files_Links_2__c != null && c.Video_link_mac__c == null)
                {   
                   htmlBody= htmlBody + '<br/><br/>Customer story:'+c.Name+ '<br/><br/>Video Link Windows:'+ '<a href="'+c.Files_Links_2__c+'">Click Here</a>';                                 
                } 
                 else if (c.Files_Links_1__c == null && c.Files_Links_2__c == null  && c.Video_link_mac__c != null)
                {   
                   htmlBody= htmlBody + '<br/><br/>Customer story:'+c.Name+ '<br/><br/>Video Link Mac:'+ '<a href="'+c.Video_Link_mac__c+'">Click Here</a>';                                 
                }
                else if (c.Files_Links_1__c != null && c.Files_Links_2__c != null && c.Video_link_mac__c == null)
                {  
                  htmlBody= htmlBody + '<br/><br/>Customer story:'+c.Name+'<br/><br/>PDF Link: '+ '<a href="'+c.Files_Links_1__c+'">Click Here</a>' + '<br/><br/>Video Link Windows:'+ '<a href="'+c.Files_Links_2__c+'">Click Here</a>';                                 
                }
                else if (c.Files_Links_1__c != null && c.Files_Links_2__c == null && c.Video_link_mac__c != null)
                {  
                  htmlBody= htmlBody + '<br/><br/>Customer story:'+c.Name+'<br/><br/>PDF Link: '+ '<a href="'+c.Files_Links_1__c+'">Click Here</a>'+ '<br/><br/>Video Link Mac:'+ '<a href="'+c.Video_Link_mac__c+'">Click Here</a>';                                 
                } 
                 else if (c.Files_Links_1__c == null && c.Files_Links_2__c != null && c.Video_link_mac__c != null)
                {  
                  htmlBody= htmlBody + '<br/><br/>Customer story:'+c.Name+'<br/><br/>Video Link Windows:'+ '<a href="'+c.Files_Links_2__c+'">Click Here</a>'+ '<br/><br/>Video Link Mac:'+ '<a href="'+c.Video_Link_mac__c+'">Click Here</a>';                                 
                } 
                else 
                {    
                   htmlBody= htmlBody;                                 
                }  
              c.Is_Reference_Materials_used__c=true;
              rt1.add(c);
            }           
             htmlbody = 'Dear' +names1+'<br/><br/>'+htmlBody1 + htmlbody +'<br/><br/><br/><br/>Regards,'+'<br/>'+htmlBody2+'<br/>'+useremail;
              stringList2.clear();
            
              for(opportunity o:newopp)
              {
               o.Is_Reference_Materials_used__c=true;
               t1.add(o);
              }              
                List<contact> conSelectedAccounts=isSelectedCons();                                   
                for(Integer v=0;v<conSelectedAccounts.size();v++)
                {                      
                    if(conSelectedAccounts[v].Primary_Email_Address__c == null){
                    continue; 
                    }
                    else
                    {
                    stringList2.add(conSelectedAccounts[v].Primary_Email_Address__c);
                    }
                }             
                system.debug('venkat10'+stringList2.size());
           if(email1!= '')
            stringList2.add(email1); 
           
         if(email2!= '')
            stringList2.add(email2); 
           
           if(email3!= '')
            stringList2.add(email3); 
             system.debug('venkat10'+connamelist.size());
             system.debug('venkat10'+connamelist);
              if(stringList2.size()!=0)
              {            
                   Messaging.SingleemailMessage Mail=new Messaging.SingleemailMessage();
                   mail.setSubject('Honeywell Success Story');
                   mail.setToAddresses(stringList2);
                   mail.setHtmlBody(htmlBody); 
                   
                   //adding attachments
                   List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    for (Attachment a : [select Id, Name, Body, BodyLength from Attachment where ParentId =:cusid])
                    {
                       Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                       efa.setFileName(a.Name);
                       efa.setBody(a.Body);
                       fileAttachments.add(efa);       
                    }                   
                    mail.setFileAttachments(fileAttachments);
                                             
                   messaging.sendEmail(new Messaging.singleemailmessage[] {mail});
                   callwindow1=true;
              }
              stringList2.clear();
                   
          upsert t1;
          upsert rt1;
        return null;         
    }
     
}