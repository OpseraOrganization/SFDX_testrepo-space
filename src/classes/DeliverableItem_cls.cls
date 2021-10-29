/***************************************************
**File Name: DeliverableItem_cls1
** Description: to create reord in Deliverable Item object
**Company Name : Honeywell Aero
**Date Of Creation:24-Jan-2013
**Version No:0.01
**Created By:Siva Nannapaneni
** 
*****************************************************/ 

public class DeliverableItem_cls {
        public String srNum{get;set;}
       //public String pickvalue{get;set;}
        //public String resVlue{get;set;}
       // public String probdecValue{get;set;}
       // public String dateValue{get;set;}
        public String actOwner{get;set;}
        public String ggpvalue{get;set;}
        public String ggpval1{get;set;}
        //public String srval{get;set;}
       // public String text{get;set;}
        public String textValue{get;set;}
        public String Value{get;set;}
        public String srValue{get;set;}
        public String ggpname{get;set;}
        public String srname{get;set;}
        Public String account;
        Public String ggpid;
       // Public List<Go_Green_Plan__c> ggpidlist;
        //Public String prodline;
        public Boolean displayPopup{get;set;}
        public Boolean displayPopup1{get;set;}
        public boolean showsites{get;set;}
        Public List<Go_Green_Plan__c> filterggp;
        Public List<Service_Request__c> filtersr;
        Public  Set<Id> ggpidSet;
        Public Set<Id> sridSet;
        Public List<Service_Request__c> srListt{get;set;}
        Public List<Go_Green_Plan__c> ggpList{get;set;}
        List<Service_Request__c> srrList;
        List<Go_Green_Plan__c> gList;
         //public Deliverable_Item__c.csb_owner__c{get;set;}
         
        /*
         public String currentDate{
                get{
                date dt=System.Today();
                currentDate=dt.format();
                return currentDate;
                }
                set;} */
                
         public List<SelectOption> getItems() {
                List<SelectOption> options = new List<SelectOption>();
                Schema.DescribeFieldResult fieldResult =
                Deliverable_Item__c.Attribute__c.getDescribe();
                List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues();
                options.add(new SelectOption('','--None--'));
                for( Schema.PicklistEntry field : plentry){
                options.add(new SelectOption(field.getLabel(), field.getValue()));
                }       
                return options;
    
    }
            public String funpickvalue{get;set;}
                public List<SelectOption> getFunItems() {
                List<SelectOption> options = new List<SelectOption>();
                Schema.DescribeFieldResult fieldResult =
                Deliverable_Item__c.Function__c.getDescribe();
                List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues();
                options.add(new SelectOption('','--None--'));
                for( Schema.PicklistEntry field : plentry){
                options.add(new SelectOption(field.getLabel(), field.getValue()));
                }  
                return options;
                }
                 public String hsvalue{get;set;}
                public List<SelectOption> gethsItems() {
                List<SelectOption> options = new List<SelectOption>();
                Schema.DescribeFieldResult fieldResult =
                Deliverable_Item__c.Honeywell_Site__c.getDescribe();
                List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues();
                options.add(new SelectOption('','--None--'));
                for( Schema.PicklistEntry field : plentry){
                options.add(new SelectOption(field.getLabel(), field.getValue()));
                }  
                return options;
                }
        public String statuspickvalue{get;set;}
                public List<SelectOption> getstatusItems() {
                    List<SelectOption> options = new List<SelectOption>();
                        Schema.DescribeFieldResult fieldResult =
                    Deliverable_Item__c.Status__c.getDescribe();
                    List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues();
                     options.add(new SelectOption('','--None--'));
                        for( Schema.PicklistEntry field : plentry){
                            options.add(new SelectOption(field.getLabel(), field.getValue()));
                        }  
                        return options;
                    }
        public String processpickvalue{get;set;}
                public List<SelectOption> getprocessItems() {
                    List<SelectOption> options = new List<SelectOption>();
                    Schema.DescribeFieldResult fieldResult =
                    Deliverable_Item__c.Progress_to_Go_Green__c.getDescribe();
                    List<Schema.PicklistEntry> plentry = fieldResult.getPicklistValues();
                    options.add(new SelectOption('','--None--'));
                        for( Schema.PicklistEntry field : plentry){
                            options.add(new SelectOption(field.getLabel(), field.getValue()));
                        }  
                        return options;
      }
     public ApexPages.StandardSetController con {
          get {
            if(con == null){
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select id,name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where id IN:ggpidSet]));
                ggpList=con.getRecords();
            }
            return con;
        }set;
      
      }
      
       public ApexPages.StandardSetController srcon {
          get {
            if(srcon == null){
                
               srcon = new ApexPages.StandardSetController(Database.getQueryLocator([Select Subject__c,status__c,customer_due_date__c,problem_description__c,Status_Resolution__c,Complexity_Level__c,id,Name,Account_Name__c from Service_Request__c Where Account_Name__c=:account limit 100 ]));
               
            }
            return srcon;
        }set;
      
      }
     
    public DeliverableItem_cls(ApexPages.StandardController controller) {
        showsites=true;
        ggpvalue= Apexpages.currentpage().getparameters().get('GGP');
        
        ggpidSet=new Set<Id>();
        sridSet=new Set<Id>();
        filterggp=new List<Go_Green_Plan__c>();
        gList=new  List<Go_Green_Plan__c>();
        List<Service_Request__c> srrList=[Select Subject__c,status__c,customer_due_date__c,problem_description__c,Status_Resolution__c,Complexity_Level__c,id,Name,Account_Name__c from Service_Request__c ORDER BY CreatedDate DESC LIMIT 500 ];
        List<Go_Green_Plan__c> gList=[Select id,name,Account__c,Prod_LN_Prgm_Product_LIne__c,CreatedDate  from Go_Green_Plan__c ORDER BY CreatedDate DESC LIMIT 500 ];
        for(Go_Green_Plan__c ggp:gList){
            for(Service_Request__c sr:srrList){
                if(ggp.Account__c != null &&  sr.Account_Name__c != null ){
                    if(sr.Account_Name__c==ggp.Account__c ){
                        ggpidSet.add(ggp.Id);
                        sridSet.add(sr.id);
                        
                    }
                }
            }
        }
     }
     public void popupCallGgp(){
        ggpList=new List<Go_Green_Plan__c>();
        ggpList=[Select id,name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where id IN:ggpidSet];
        displayPopup=false;
        displayPopup1=true;
    }
     public void popupCallsr(){
          Go_Green_Plan__c gplan=[Select id,Name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where Name=:ggpvalue];
          account=gplan.Account__c;
          //prodline=gplan.Prod_LN_Prgm_Product_LIne__c;
         // srListt=new  List<Service_Request__c>();
          srListt= [Select Subject__c,status__c,customer_due_date__c,problem_description__c,Status_Resolution__c,Complexity_Level__c,id,Name,Account_Name__c,sr_site__c from Service_Request__c Where Account_Name__c=:account limit 100 ];
          displayPopup1=false;
          displayPopup=true;
      }
    
    public void setValue(){
        ggpvalue=ggpname;
        Go_Green_Plan__c gplan=[Select id,Name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where Name=:ggpvalue];
        account=gplan.Account__c;
       // prodline=gplan.Prod_LN_Prgm_Product_LIne__c;
        displayPopup1=false;
    }
    
    public void doClose(){
        displayPopup=false ;
        displayPopup1= false;
    }
    public void addInfo(String msg){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,msg));
    }
    public void addError(String msg){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
    }

    public Pagereference  doSave(){
    if (actowner == '' || funpickvalue == null || processpickvalue == null || hsvalue == null)
    {
    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please enter Action Owner, Function, Progress to go Green and Honeywell Site values.'));
    return null;
    }
    else
    {
        Deliverable_item__c ditem=new Deliverable_item__c();
        Go_Green_Plan__c  gp=[Select id,name from Go_Green_Plan__c where name=:ggpvalue limit 1];
        Service_Request__c  sr=[Select id,Name from Service_Request__c where name=:srname limit 1];
        ditem.SR_Number__c=sr.id;
        ditem.Go_Green_Plan__c=gp.id;
        ditem.CSB_Owner__c = actowner;
        ditem.Function__c=funpickvalue;
        ditem.Progress_to_Go_Green__c=processpickvalue;
        ditem.Honeywell_Site__c=hsvalue;
        Insert ditem;
       
        Pagereference pagref = new Pagereference('/'+ditem.id);
        pagref.setRedirect(true);
        return pagref ;
       }
       }
     public void doSaveNew(){
    if (actowner == '' || funpickvalue == null || processpickvalue == null || hsvalue == null)
    {
    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please enter Action Owner, Function Progress to go Green and Honeywell Site values.'));
    //return null;
    }
    else
    {
       Deliverable_item__c ditem=new Deliverable_item__c();
        Go_Green_Plan__c  gp=[Select id,name from Go_Green_Plan__c where name=:ggpvalue limit 1];
        Service_Request__c  sr=[Select id,Name from Service_Request__c where name=:srname limit 1];
        ditem.SR_Number__c=sr.id;
        ditem.Go_Green_Plan__c=gp.id;
       ditem.CSB_Owner__c =  actowner;
         ditem.Function__c=funpickvalue;
          ditem.Progress_to_Go_Green__c=processpickvalue;
         ditem.Honeywell_Site__c=hsvalue;
        try{
            Insert ditem;
            addInfo('Voc Card is created you can create the new one');
        }catch(Exception e){
            addError( 'Could not save'+ e.getMessage());
        }
        }
     }
    public void letsGo(){
         if(textValue != 'null'){
            Value='%'+textValue+'%';
            try{
                con = new ApexPages.StandardSetController([ Select id,name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where Name Like : Value AND Id IN:ggpidSet LIMIT 1000 ]);
                ggpList=con.getRecords();
            }Catch(Exception e){ }
        }
    }
     public void gosr(){
        if(SrValue != 'null'){
            Value='%'+SrValue+'%';
            try{
                srcon = new ApexPages.StandardSetController([ Select Subject__c,status__c,customer_due_date__c,problem_description__c,Status_Resolution__c,Complexity_Level__c,id,Name,Account_Name__c from Service_Request__c where Name Like : Value LIMIT 1000 ]);
                srListt=srcon.getRecords();
            
            }Catch(Exception e){ }
        }
    }
   public Pagereference doCancel(){
       ggpval1 = Apexpages.currentpage().getparameters().get('GGP');
       ggpid = [Select id from Go_Green_Plan__c where name=: ggpval1 limit 1].id;
       //ggpid = ggpidlist[0];
     Pagereference pagref = new Pagereference('/'+ggpid);
     pagref .setRedirect(true);
     return pagref ;
     }
     public void setSrValue(){
        srNum =srname;
        displayPopup=false;
        system.debug('srNum****'+srNum);
        Service_Request__c srr=new Service_Request__c ();
        srr=[Select sr_site__c from Service_Request__c where name=:srNum];
        system.debug('srr***'+srr.sr_site__c);
        if(srr.sr_site__c==null)
         showsites=true;
        else{
         hsvalue=srr.sr_site__c;
         showsites=false;
         }
   }
   
}