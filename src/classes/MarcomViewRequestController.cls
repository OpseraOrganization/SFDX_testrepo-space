public class MarcomViewRequestController 
{       
        public String attchId{get;set;}
        public Marcom_Service_Request__c objCase {get; set;}
        public boolean showrender{get; set;}
        public boolean textrender{get;set;}
        public boolean showattach{get; set;}
        public boolean viewattach{get;set;}
        public boolean viewnotesdet{get;set;}
        public boolean addattach{get;set;}
        public String txtComments{get; set;}
        public transient  Attachment objfile;
        public Note objNote;
        public List<Attachment> attList{get;set;}
        public List<Note> notelist{get;set;}
        public  Id i = ApexPages.currentPage().getParameters().get('caseid');
    
    //getobjfile
    Public Attachment getobjfile(){
        objfile= new Attachment();
        return objfile;
    }
    
    //getobjnote
    Public Note getobjNote(){
        objNote= new Note();
        return objNote;
    }
    
    //show render methodes
    public boolean getShowrender(){
      return showrender;
    }
    public void setShowrender(){
        showrender= false;
    }
    
    //textrender methods
    public boolean getTextrender(){
      return textrender;
    }
    public void setTextrender(){
        textrender= true;
    }
    
    //getshowattach
    public boolean getShowattach(){
        return showattach;
    }
  
    //view attch get&set methodes
    public void setViewattach(){
      showattach= false;
    }
    public void getViewattach(){ 
      showattach= false;
    }
  
    //view note getter and setter methodes
    public void setViewnotesdet(){
        viewnotesdet = true;
    }
    public boolean getViewnotesdet(){
        return viewnotesdet;
    }
    
    //getter and setter methodes for txtcomments
    public String getTxtComments(){
        return txtComments;
    }
    public void setTxtComments(){
      txtComments= null;
    }
    
    //list of  records using soql
    public MarcomViewRequestController(){
      try{
           objCase=[SELECT Name,OwnerId,Marcom_Business__c,Marcomcommentstitle__c,CreatedDate,Marcom_Related_Activity__c,MarcomComments__c,Marcom_Audience__c,Marcom_Market__c,Marcom_Request_Region__c,Marcom_Request_Timeline__c,(Select ParentId From Attachments) FROM Marcom_Service_Request__c where Id=:i];
       }catch( QueryException qe){       
       }catch(Exception e){      
       }
      }
  
    //edit comments section
    public void editComments(){
        textrender= true;
        showrender = true;
        showattach= false;
        viewattach= false;
        viewnotesdet = false;
    }
    //add attach section
    public void addattach(){   
        textrender= true;
        showrender = false;
        showattach= true;
        viewattach= false;
        viewnotesdet = false;
    }
    
    //view attchment section
    public void viewattach(){ 
         system.debug('test------------->');
         showrender = false;
         textrender= true;
         showattach= false;
         viewattach= true;
         viewnotesdet = false;
         attList=new List<Attachment>();
         attList=[Select id,Name,ParentId from Attachment where ParentId=:objCase.Id limit 200];
         //attList=[Select id,Name,Body,ParentId from Attachment where ParentId=:System.currentPageReference().getParameters().get('objCase.id')];
         //attList = [Select a.ParentId, a.Name From Attachment a where ParentId=System.currentPageReference().getParameters().get('id')];
    }
    
    //view comments section
    public void viewcomments(){ 
             system.debug('test------------->');
             showrender = false;
             textrender= true;
             showattach= false;
             viewattach= false;
             viewnotesdet = true;
             notelist=new List<Note>();
             notelist=[Select id,Title,body,ParentId from Note where ParentId=:objCase.Id ];
    }
  
   //save comment section
    public void saveComments(){
          //update objCase ;
          Id idd = ApexPages.currentPage().getParameters().get('caseid');
          //Marcom_Service_Request__c noteobj =[SELECT Name,OwnerId,CreatedDate,MarcomComments__c FROM Marcom_Service_Request__c where Id=:idd];
          Note noteobj = new Note(parentId = idd, title=objNote.title, body = objNote.body);
        try{
                insert noteobj;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Comments successfully updated'));
           }
         catch(Exception objexcep){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Fatal,'Problem in Updating the Comments.'));
            } 
    }
    
    //cancel comments section
    public void cancelComments() {
        textrender= false;
        showrender=false;
        showattach= false;
        viewattach= false;
        viewnotesdet = false;
    } 
    
    //save attachment section
    public void saveattach(){
        Id idcase = ApexPages.currentPage().getParameters().get('caseid');
        Attachment attobj = new Attachment(parentId = idcase, name=objfile.name, body = objfile.body);
        try{
                insert attobj;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Attachments successfully added to the Request'));
                showattach= true;
                attobj.body = null;   
                attobj = null;
            }
        catch(Exception objexcep){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Fatal,'Problem in Uploading the Attachments.'));
            }  
    }
    
    //cancel attach
    public void cancelattach() {
        textrender= false;
        showrender=false;
        showattach= false;
        viewattach= false;
        viewnotesdet = false;
    }
  }