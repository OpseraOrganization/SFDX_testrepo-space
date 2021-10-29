public class VoiceofcustomerClass
{
    public string dependent{get;set;}
    public string control{get;set;}
    public boolean showaccount{get;set;}
    public boolean sensitivedata{get;set;}
    public List<SelectOption> Publicgroup{get;set;}
    public list<string>selectedgroup=new list<string>();
    map<string,list<string>> dependentmap= new map<string,list<string>>();
    public Voice_of_Customer__c ExceptionRecord{get;set;}
    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
    //private final Voice_of_Customer__c ExceptionRecord;
  public list<string> getselectedgroup() {
            return selectedgroup;
        }
            
        public void setselectedgroup(list<string> selectedgroup) {
            this.selectedgroup= selectedgroup;
        }
    
    public VoiceofcustomerClass(ApexPages.StandardController controller)
    {
          
          if(controller !=null)
            this.ExceptionRecord= (Voice_of_Customer__c)controller.getRecord();
          if(ExceptionRecord==null)
            ExceptionRecord= new Voice_of_Customer__c();
          
            ExceptionRecord.Date_of_VOC__c=system.today();
          if(apexpages.currentpage().getparameters().get('RecordType')!=null)
            ExceptionRecord.recordtypeid=apexpages.currentpage().getparameters().get('RecordType');
          
        
           
    }
  public void depedentvalue()
  {
  dependent=apexpages.currentpage().getparameters().get('dependent');
  control=apexpages.currentpage().getparameters().get('control');
 system.debug('aaaaaaaaaaaaaaaaaaaaaaaaaa'+dependent);
 system.debug('bbbbbbbbbbbbbbbbbbbbbbb'+control);
  list<string> templist= new list<string>();
  if(dependentmap.containsKey(control))
     templist=dependentmap.get(control);
   templist.add(dependent);
   dependentmap.put(control,templist);
   system.debug('dependentmap********************'+dependentmap);
  }
  public void oemsetval()
  {
     
  }
    public Attachment attachment {
    get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
    set;
  }
  
  public list<selectOption> gettype()
  {
   list<selectoption>options=new list<selectoption>();
   options.add(new selectoption(label.Observational,'Observational'));//012e0000000Co5P
   options.add(new selectoption(label.Anecdotal,'Anecdotal'));//012e0000000Co5K
   return options;
  }
  
  public  List<SelectOption> getchattergroup()
  {
      List<SelectOption> options = new List<SelectOption>();
      string id= label.Voc_Group_Id;
      list<id> groupid= new list<id>();
      groupid=id.split(',');
      system.debug('id*************'+id);
      options.add(new selectoption('None','--Select--'));
      List<CollaborationGroup> chatgroup= new List<CollaborationGroup>();  
      chatgroup=[select id,name from CollaborationGroup where id in:groupid ORDER BY Name];
      for(CollaborationGroup g:chatgroup)
      {
        string temp=g.name.replace('VOC - ', '');
        options.add(new selectoption(g.id,temp));
      }
      return options;
  }
  
  public List<SelectOption> getproductfamily()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       Voice_of_Customer__c.Product_Family__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
  
   public Pagereference save()
    {      
        try
        {
         String device = System.currentPageReference().getParameters().get('device');
            
            /*if(apexpages.currentpage().getparameters().get('RecordType')==null)
                   ExceptionRecord.RecordtypeId='012e0000000Co5K';*/
              
             
            if(ExceptionRecord.Date_of_VOC__c<system.today()-1)
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Date can not be less than one day'));
            if(ExceptionRecord.selectedgroup__c!=null)
            {
            
            string groupid=ExceptionRecord.selectedgroup__c.substring(0,15);
            system.debug('test***************'+groupid);
            list<VOC_Group_Queue_Map__c> ownerqueue= VOC_Group_Queue_Map__c.getall().values();
            for(VOC_Group_Queue_Map__c temp: ownerqueue){
               if(temp.groupid__c==groupid)
                 ExceptionRecord.ownerid=temp.Queue_Id__c;
                 }
            }
            else 
               ExceptionRecord.ownerid=label.VOC_NON_Senstive;
            
           system.debug('xxxxxxxxxxxxxxxxxxxxxxxx'+ExceptionRecord.recordtypeid);
           insert ExceptionRecord;
           system.debug('xxxxxxxxxxxxxxxx11111'+ExceptionRecord.ownerid);
           if(attachment.body!=null)
           {
             try{
               attachment.ParentId=ExceptionRecord.id;
               insert attachment;
               attachment.body=null;
              }
              catch(exception e)
              {
                attachment.body=null;
              }
           }
           system.debug('eeeeeeeeeeeee'+ExceptionRecord.Sensitive__c);
          if(apexpages.currentpage().getparameters().get('RecordType')==null){
           pagereference pag= new pagereference('/apex/vocdetails?id='+ExceptionRecord.id+'&createpage=true');
           pag.setRedirect(true);
           return pag;
           }
           else
           {
              if(ExceptionRecord.sensitive__c==true)
              {
                 Voice_of_Customer__Share vocshare= new Voice_of_Customer__Share();
                 vocshare.ParentId = ExceptionRecord.id;
                 vocshare.UserOrGroupId =ExceptionRecord.createdbyid;
                 vocshare.AccessLevel = 'Read';
                 vocshare.RowCause = Schema.Voice_of_Customer__Share.RowCause.Manual;
                 //insert vocshare;
                 Database.SaveResult sr = Database.insert(vocshare,false);
                 system.debug('sharing id******************'+vocshare.id);
              }
              String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm();
              PageReference pageRef = new PageReference(fullRecordURL+'/'+ExceptionRecord.id);
               return pageRef;
           }
        }
        catch(Exception e){ 
          if(string.valueof(e).contains('Ending position out of bounds: 15'))
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Group'));
          else
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'why not working here?'+e));}
      return null;
     }
     
 public pagereference clearform()
 {
    pagereference pag= new pagereference('/apex/voccreate');
    pag.setRedirect(true);
    return pag;
 }
  public void checkforaccount()
  {
      system.debug('ccccccccccccccccccccccccccccc'+ExceptionRecord.Source__c);
      
      if(ExceptionRecord.Source__c=='Customer')
        showaccount=true;
               
      else
        showaccount=false;
        system.debug('ExceptionRecord.Source__c*********'+showaccount);
   }
   public void showgroup()
  {
      system.debug('ccccccccccccccccccccccccccccc'+ExceptionRecord.Source__c);
      
      if(ExceptionRecord.Sensitive__c==true)
        sensitivedata=true;
      else
        sensitivedata=false;
        system.debug('ExceptionRecord.Sensitive__c*********'+sensitivedata);
   }
}