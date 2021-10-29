/***************************************************
**File Name: AssociatedVoc_Cls
** Description: to create reord in AssociatedVocCard object
**Company Name : Honeywell Aero
**Date Of Creation:23-Dec-2013
**Version No:0.01
**Created By:Manoj Kumar Jena
** 
*****************************************************/ 

public class AssociatedVoc_Cls {
        public String ggpval{get;set;}
        public String ggpval1{get;set;}
        public String fbbval{get;set;}
        public String text{get;set;}
        public String textValue{get;set;}
        public String Value{get;set;}
        public String fbValue{get;set;}
        public String ggpname{get;set;}
        public String fbname{get;set;}
        Public String account;
        Public String ggpid;
        Public List<Go_Green_Plan__c> ggpidlist;
        Public String prodline;
        public Boolean displayPopup{get;set;}
        public Boolean displayPopup1{get;set;}
        Public List<Go_Green_Plan__c> filterggp;
        Public List<Feedback__c> filterfb;
        Public  Set<Id> ggpidSet;
        Public Set<Id> fbidSet;
        Public List<Feedback__c> febList{get;set;}
        Public List<Go_Green_Plan__c> ggpList{get;set;}
        List<Feedback__c> fbbList;
        List<Go_Green_Plan__c> gList;
      
     public ApexPages.StandardSetController con {
          get {
            if(con == null){
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select id,name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where id IN:ggpidSet]));
                ggpList=con.getRecords();
            }
            return con;
        }set;
      
      }
      
       public ApexPages.StandardSetController fbcon {
          get {
            if(fbcon == null){
                
               fbcon = new ApexPages.StandardSetController(Database.getQueryLocator([Select id,Name,Account__c,Prod_LN_Prgm_Product_LIne__c from Feedback__c Where Account__c=:account AND Prod_LN_Prgm_Product_LIne__c=:prodline limit 100 ]));
               
            }
            return fbcon;
        }set;
      
      }
     
    public AssociatedVoc_Cls(ApexPages.StandardController controller) {
        ggpval= Apexpages.currentpage().getparameters().get('GGP');
        ggpidSet=new Set<Id>();
        fbidSet=new Set<Id>();
        filterggp=new List<Go_Green_Plan__c>();
        gList=new  List<Go_Green_Plan__c>();
        List<Feedback__c> fbbList=[Select id,Name,Account__c,Prod_LN_Prgm_Product_LIne__c,CreatedDate  from Feedback__c ORDER BY CreatedDate DESC LIMIT 1000 ];
        List<Go_Green_Plan__c> gList=[Select id,name,Account__c,Prod_LN_Prgm_Product_LIne__c,CreatedDate  from Go_Green_Plan__c ORDER BY CreatedDate DESC LIMIT 1000 ];
        for(Go_Green_Plan__c ggp:gList){
            for(Feedback__c fb:fbbList){
                if(ggp.Account__c != null &&  fb.Account__c != null &&  fb.Prod_LN_Prgm_Product_LIne__c != null && ggp.Prod_LN_Prgm_Product_LIne__c != null){
                    if(fb.Account__c==ggp.Account__c && fb.Prod_LN_Prgm_Product_LIne__c==ggp.Prod_LN_Prgm_Product_LIne__c){
                        ggpidSet.add(ggp.Id);
                        fbidSet.add(fb.id);
                
                    }
                }
            }
        }
     }
     public void popupCallGgp(){
        ggpList=new List<Go_Green_Plan__c>();
        ggpList=[Select id,name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where id IN:ggpidSet];
        displayPopup=true;
        displayPopup1=false;
    }
     public void popupCallFb(){
          Go_Green_Plan__c gplan=[Select id,Name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where Name=:ggpval];
          account=gplan.Account__c;
          prodline=gplan.Prod_LN_Prgm_Product_LIne__c;
          febList=new  List<Feedback__c>();
          febList= [Select id,Name,Account__c,Prod_LN_Prgm_Product_LIne__c,Year__c,Quarter__c from Feedback__c Where Account__c=:account AND Prod_LN_Prgm_Product_LIne__c=:prodline limit 100 ];
          displayPopup1=true;
          displayPopup=false;
    }
    
    public void setValue(){
        ggpval=ggpname;
        Go_Green_Plan__c gplan=[Select id,Name,Account__c,Prod_LN_Prgm_Product_LIne__c from Go_Green_Plan__c where Name=:ggpval];
        account=gplan.Account__c;
        prodline=gplan.Prod_LN_Prgm_Product_LIne__c;
        displayPopup=false;
    }
    public void goBack(){
      fbbval=fbname;
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

    public pagereference  doSave(){
        Associated_VOC_Card_Number__c avcn=new Associated_VOC_Card_Number__c();
        Go_Green_Plan__c  gp=[Select id,name from Go_Green_Plan__c where name=:ggpval limit 1];
        Feedback__c  fb=[Select id,Name from Feedback__c where name=:fbbval limit 1];
        avcn.Feedback_Number__c=fb.id;
        avcn.Go_Green_Plan__c=gp.id;
                try{
            Insert avcn;
            //addInfo('Voc Card is created you can create the new one');
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
         
    PageReference pageRef = new PageReference('/'+avcn.id);
    return pageRef;

       }
     public void doSaveNew(){
        Associated_VOC_Card_Number__c avcn=new Associated_VOC_Card_Number__c();
        Go_Green_Plan__c  gp=[Select id,name from Go_Green_Plan__c where name=:ggpval limit 1];
        Feedback__c  fb=[Select id,Name from Feedback__c where name=:fbbval limit 1];
        avcn.Feedback_Number__c=fb.id;
        avcn.Go_Green_Plan__c=gp.id;
        try{
            Insert avcn;
            addInfo('Voc Card is created you can create the new one');
        }catch(Exception e){
           // addError( 'Could not save'+ e.getMessage());
            ApexPages.addMessages(e);
            //return null;
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
     public void letsfbGo(){
        if(fbValue != 'null'){
            Value='%'+fbValue+'%';
            try{
                fbcon = new ApexPages.StandardSetController([ Select id,name,Quarter__c,Year__c,Account__c,Prod_LN_Prgm_Product_LIne__c from Feedback__c where Name Like : Value LIMIT 1000 ]);
                febList=fbcon.getRecords();
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
}