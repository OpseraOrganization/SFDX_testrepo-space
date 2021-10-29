public class casecreate_sitecontroller {
    public case c{get;set;}
    public case cs;
    public String helpinfo{get;set;}//created for red button site
    public string radiovalue{get;set;}//Anu
    public boolean requiredval1{get;set;}
    public boolean requiredval2{get;set;}
    public boolean requiredval3{get;set;}
    public boolean sure1{get;set;}
    public boolean sure2{get;set;}
    public boolean sure3{get;set;}
    public boolean showpop{get;set;}
   // public boolean showpri{get;set;}  //commented for red button site
    public string addinfo{get;set;}
    public string des{get;set;}
   // public string soldtocode{get;set;}
    public String text1 {get; set;}
    public String text2 {get; set;}
    public String text3 {get; set;}  
    public String helpinputtext {get; set;} //created for red button site
    public static Attachment att1{get;set;}
   // public String sbucustom{get; set;} //commented for red button site
    public String errorMsg { get; set;}
    //created for red button site start--
    public String GCECustomerSegment { get; set;}
    public String GCECSSRegion { get; set;}
    public String PCaseStatus { get; set;}
    public String PCaseRFH { get; set;}
   public String PCaseSubStatus { get; set;}
   public String PCaseNotes { get; set;}
     public String BusinessFocal { get; set;}
   public String CustomerSupportFocal { get; set;}
     public String PCaseHIA { get; set;}
    //created for red button site -end
        
    public Attachment att {
        get {    
            if(att1!=null)
            {
                att = new Attachment();
                att=att1;
                system.debug('----->'+att1);
            }
            else if (att == null)
                att = new Attachment();
            
            system.debug('----->'+att);
            return att;
        }
   
        set;
    }
         
    public List<SelectOption> getworkstrem()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       case.workstrem__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
        if(f.getLabel()!='OEM')
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        else
          options.add(new SelectOption(f.getLabel(),'OEM (includes all OEM and Production Return Orders)'));
       }       
       return options;
    }
    
/*//commented for red button site to remove region start
     public List<SelectOption> getRegion()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       case.CSM_Region__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }commented for red button site to remove region end*/
    
    /*commented for red button site-start

    public List<SelectOption> getpriority() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Normal','Normal - Response required < 24 hours. This SLA is standard operating procedure and the majority of submissions should fall into this category.'));
        options.add(new SelectOption('High','High - Response required < 4 hours. High Priorities must cause an OTTR miss, line stop, payment receipt delay, or needs to be an expedite request in order to be considered a "High" Priority'));
        options.add(new SelectOption('Urgent','Urgent  - Must meet the following criteria: 1.Customer order is due today 2.Order is ready to ship 3.CSR action required to ship unit (ex. remove delivery block) immediately. Failure to meet this criteria could delay your case response.'));
        return options;
    }
    public List<SelectOption> getpriorityadd() {

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('OTTR','OTTR - Request can only be prioritized as HIGH if it impacts OTTR. This means that the unit is 5 days or less from the customer request date or requested goods issue date. Failure to meet this criteria could delay your case response.'));
        options.add(new SelectOption('Line Stop','Line Stop - Request can only be prioritized as HIGH if it could cause a LINE STOP.  This means that this is related to an OEM order and is halting a customer ‘s production line. Failure to meet this criteria could delay your case response.'));
        options.add(new SelectOption('Payment received','Payment received - Request can only be prioritized as HIGH if customer has Pay Prior to Order or Pay Prior to Ship accounting terms and CSR needs to complete payment processing. Failure to meet this criteria could delay your case response.'));
        options.add(new SelectOption('Expedite Request','Expedite Request - Request can only be prioritized as HIGH if a CSR must perform an action within a 24 hour period. Failure to meet this criteria could delay your case response.'));
        return options;
    }commented for red button site-start*/
    
    /************Added for SR INC000009202273 starts *********************/
  /*  public List<SelectOption> getsbuimp() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('--None--','--None--'));
    options.add(new SelectOption('ATR','ATR'));
    options.add(new SelectOption('BGA','BGA'));
    options.add(new SelectOption('D&S','D&S'));
    return options;
    }*/ //hema
    
   /* commented for red button site start
     public String getsbucustom() {
            return sbucustom;
        }commented for red button site end*/

    /************Added for SR INC000009202273 ends*********************/
    
   public void callpopup()
   {
      showpop=true;
   }
   
   public void add()
   {
     showpop=false;
   }
  /*/*commented for red button site-start
    public void check()
   {
      if(c.Priority=='High' || c.Priority=='Urgent')
        showpri=true;
      else
        showpri=false;
   }/*commented for red button site-end*/
    public casecreate_sitecontroller(ApexPages.StandardController controller) 
    {   
     text1 = apexpages.currentpage().getparameters().get('EmailAddress');
      c= new case();
    //  c.Priority='Normal';
      c.Primary_Email__c = text1;
       sure1=true;
       sure2=true;
       sure3=true;
      radiovalue='Yes';
      c.type='other';
       text2 ='Repair Inquiry';

    }
   
    public PageReference  savecase()
    {
    system.debug('helpinfoifsave'+helpinfo);
    c.Workstrem__c=text3;
     if(c.Workstrem__c=='Repair and Overhaul')
    {
        if(text2=='Quotes Escalation')
        c.type='Quotes Escalation';
        else
        c.type=text2;
        
    }
    system.debug('c.workstrem__c >>>>>>>'+c.workstrem__c);
    // Changes done by Shwetha    
        if(c.workstrem__c=='Repair and Overhaul')
        {            
            c.ownerid= label.CSO_R_O_Team;
        }         
        if(c.workstrem__c=='OEM' || c.workstrem__c=='Spares')
        {
            c.ownerid=label.CSO_OEM_Spares;
        }
        //changes ended by Shwetha
  /*commented for red button site-start 
    if(c.Priority =='High' && (addinfo=='' || addinfo==null))
    {
       apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'If Priority is High then OTTR/Line Stop/Payment received/Expedite Request are Mandatory'));
       return null;
    }/*commented for red button site-end*/
   list<contact>conlist= new list<contact>();
    
    // Modified for INC000006650064    
 /*   if(c.workstrem__c=='Spares' && c.CSM_Region__c=='Americas')
    {
       c.Classification__c='US ACT Internal';
       c.ownerid=label.ACT_Team;
      // c.Type = 'Internal Communication';
    }
    if(c.workstrem__c=='Spares' && c.CSM_Region__c=='EMEAI')
    {
       c.Classification__c='EMEA ACT Internal';
       c.ownerid=label.ACT_Team;
      // c.Type = 'Internal Communication';
    }
    if(c.workstrem__c=='Spares' && c.CSM_Region__c=='Asia/Pacific Rim')
    {
       c.Classification__c='APAC ACT Internal';
       c.ownerid=label.ACT_Team;
      // c.Type = 'Internal Communication';
    }
    if(c.workstrem__c=='OEM')
    {
       c.Classification__c='OEM Internal';
       c.ownerid=label.OEM_Team;
      // c.Type = 'Internal Communications';
    }
    if(c.workstrem__c=='Repair and Overhaul' && c.CSM_Region__c=='Americas')
    {
       c.Classification__c='R&O Americas Internal';
       c.ownerid=label.R_O_Internal_Queue_Id;
      // c.Type = 'Internal Communications';
    }
    if(c.workstrem__c=='Repair and Overhaul' && c.CSM_Region__c=='EMEAI')
    {
       c.Classification__c='R&O EMEAI Internal';
       c.ownerid=label.R_O_Internal_Queue_Id;
      // c.Type = 'Internal Communications';
    }
    if(c.workstrem__c=='Repair and Overhaul' && c.CSM_Region__c=='Asia/Pacific Rim')
    {
       c.Classification__c='R&O APAC Internal';
       c.ownerid=label.R_O_Internal_Queue_Id;
      // c.Type = 'Internal Communications';
    }
    // Completed Modifications for INC000006650064
    // Added code for INC000006650064
    if(c.workstrem__c=='OEM' && c.CSM_Region__c=='Americas'){
        c.Classification__c='OEM Americas Internal';
        c.ownerid=label.OEM_Team;
    }
    if(c.workstrem__c=='OEM' && c.CSM_Region__c=='EMEAI'){
        c.Classification__c='OEM EMEAI Internal';
        c.ownerid=label.OEM_Team;
    }
    if(c.workstrem__c=='OEM' && c.CSM_Region__c=='Asia/Pacific Rim'){
        c.Classification__c='OEM APAC Internal';
        c.ownerid=label.OEM_Team;
    }*/
    // End code for INC000006650064
      //created for Red Button Site Start
       
     if(c!=null && cs!=null && c.AccountId != null && cs.AccountId != null && c.AccountId != cs.AccountId)
         {
         	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Select either Case Number or Customer Account'));
      		return null;
        }
  //created for Red Button Site end
        
    if(c.Primary_Email__c!=null && c.Primary_Email__c!=''){
     conlist=[select id,email from contact where Email=:c.Primary_Email__c];
     c.Requestor_Email__c=c.Primary_Email__c;
     }
         if(conlist.size()>0)
      c.contactid=conlist[0].id;
  /*commented for red button site start 
   
    list<Account_Cross_Ref__c>acrlist= new list<Account_Cross_Ref__c>();
    if(c.Customer_Name__c!='' && c.Customer_Name__c!=Null)
    {
    soldtocode=c.Customer_Name__c;
    for(integer i=soldtocode.length();i<10;i++)
      soldtocode='0'+soldtocode;
    soldtocode=soldtocode+'%';
    system.debug('soldtocode*****'+soldtocode);
     
    }
    if(c.Customer_Name__c!='' && c.Customer_Name__c!=Null)
       acrlist=[select id,Account_Name__r.Name,Concierge_Customer__c from Account_Cross_Ref__c where XREF_Type__c='SAP_SOLD_TO' and External_Account_ID__c like: soldtocode];
    if(acrlist.size()>0)
    {
      c.Customer_Sold_To__c=c.Customer_Name__c;
      c.Customer_Name__c=acrlist[0].Account_Name__r.Name;
      c.Concierge_Customer__c=acrlist[0].Concierge_Customer__c;
    }
    else
    {
       c.Customer_Sold_To__c='';
       //c.Customer_Name__c=soldtocode;
    }
    if(addinfo!=null && addinfo!=''){
        if(addinfo=='OTTR')
          c.ottr__c=true;
        if(addinfo=='Line Stop')
          c.Line_Stop__c=true;
        if(addinfo=='Payment received')
          c.Payment_received__c=true;
        if(addinfo=='Expedite Request')
          c.Expedite_Request__c=true;
    }*///commented for red button site end
        
     //c.No_FCR_Reason__c='Integrated Supply Chain Hold'; For Ticket INC000009687923
     c.recordtypeId=label.Internal_Escalations;
     c.Origin='Web';
     system.debug('des***********'+c.accountid);
     c.Part_Number__c=des;
     //c.ownerid='00Ge0000000Ga8m';
    /* //created for Red Button Site Start
      if(sbucustom=='--None--')
      {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'SBU Impacted: You must enter a value'));
      return null; 
      }
      else
      c.SBU_w2c__c=sbucustom; //created for Red Button Site Start*/
     if(c.Plant__c != null)
    {
     Plant_Code_Master__c pcm = [SELECT name,SAP_Plant_Code__c FROM Plant_Code_Master__c WHERE id = :c.Plant__c];
       c.Hon_Plant_Code_del__c = pcm.SAP_Plant_Code__c;
    } 
        
           // c.Case_Complexity__c = helpinputtext;
          If(helpinfo == 'False')
           {
               c.Case_Complexity__c = 'OMS';
               // create both your records
           }
   			 else If(helpinfo == 'True')
         {
               c.Case_Complexity__c = 'CSS';
               // create both your records
           }
          insert c;   
        
     case cas=[select id,casenumber from case where id =: c.id];

     if(att.name!=null){
     att.parentid=cas.id;
     insert att;
     }
     PageReference pageRef = new PageReference('/apex/casefinalpage?casenumber='+cas.CaseNumber);
     pageRef.setRedirect(true);
     return pageRef;
    }
     //created for Red Button Site Start
public PageReference helpInfoSave()
{
      system.debug('inside helpinfosave');
           If(helpinfo == 'False')
           {
               helpinputtext = 'OMS';
           }
    else If(helpinfo == 'True')
         {
               helpinputtext = 'CSS';
            
         }
    return null;
} 
    
    public PageReference accountSelected(){
        system.debug('gcecustomersegment:');
     //   Case c1 = (Case)internalCon.getRecord();

     if(c.AccountId != null)
     {        
        Account a = new Account();
          a = [Select Id,GCE_Customer_Segment__c,GCE_CSS__c,Business_Focal_Name__c,Customer_Support_Focal_Name__c From Account where Id = :c.AccountId];
		system.debug('gcecustomersegmentinsideaccount:'+a.GCE_Customer_Segment__c);
        if(c.ParentId == null)
        {
        GCECustomerSegment = a.GCE_Customer_Segment__c;
        GCECSSRegion = a.GCE_CSS__c;
     	}
		CustomerSupportFocal = a.Customer_Support_Focal_Name__c;
        BusinessFocal = a.Business_Focal_Name__c;
     }
        else
        {
             if(c.ParentId == null)
        	{
            GCECustomerSegment = null;
         	GCECSSRegion = null;
        	}
            CustomerSupportFocal = null;
            BusinessFocal = null;
        }
       
        	return null;
     }
    public PageReference caseSelected(){
            
     if(c.ParentId != null)
     {
         cs = new Case();
             cs= [Select Id,Status,subject,account.Customer_Support_Focal_Name__c,account.Business_Focal_Name__c,Plant__c,Product_Number__r.Name,Part_Number__c,Sales_Order_Number__c,Customer_PO_RO_WONumber__c,Repair_Notification_Number__c,Reason_for_hold__c,Sub_Status__c,Notes__c,Internal_HW_Action__c,AccountId,GCE_Customer_Segment__c,GCE_CSS_Region__c From Case where Id = :c.ParentId];
           PCaseStatus=cs.Status;
        	PCaseRFH = cs.Reason_for_hold__c;
            PCaseSubStatus = cs.Sub_Status__c;
             PCaseNotes = cs.Notes__c;
       //  BusinessFocal = cs.Account.Business_Focal__r.Name;
         system.debug('gcecustomersegmenthema'+cs.GCE_Customer_Segment__c);
        GCECustomerSegment=cs.GCE_Customer_Segment__c;
         GCECSSRegion = cs.GCE_CSS_Region__c;
         c.AccountId = cs.AccountId;
         c.subject = cs.subject;// Added by shwetha as part of enhancement
         c.Repair_Notification_Number__c = cs.Repair_Notification_Number__c; //Added by shwetha for testing purpose
         c.Customer_PO_RO_WONumber__c = cs.Customer_PO_RO_WONumber__c; //Added by shwetha
         c.Sales_Order_Number__c = cs.Sales_Order_Number__c;//Added by shwetha
         des = cs.Product_Number__r.Name;//Added by shwetha
         c.Plant__c = cs.Plant__c;//Added by shwetha
         PCaseHIA = cs.Internal_HW_Action__c;
         CustomerSupportFocal = cs.account.Customer_Support_Focal_Name__c;
         BusinessFocal = cs.account.Business_Focal_Name__c;   	
     }
        else{
             GCECustomerSegment=null;
         	 GCECSSRegion =null;
           PCaseStatus=null;
        	PCaseRFH = null;
            PCaseHIA = null;
             PCaseSubStatus = null;
             PCaseNotes = null;
            c.AccountId = null;
             CustomerSupportFocal = null;
            BusinessFocal = null;
            
           }
      /*  if(c.AccountId != null)
     {        
        Account a = [Select Id,GCE_Customer_Segment__c,GCE_CSS__c,Business_Focal__r.Name,Customer_Support_Focal__r.Name From Account where Id = :c.AccountId];
		system.debug('gcecustomersegmentinsidecase:'+a.GCE_Customer_Segment__c);
        GCECustomerSegment = a.GCE_Customer_Segment__c;
         GCECSSRegion = a.GCE_CSS__c;
	//	CustomerSupportFocal = a.Customer_Support_Focal__r.Name;
        BusinessFocal = a.Business_Focal__r.Name;
     }
        else
        {
             GCECustomerSegment = null;
         GCECSSRegion = null;
            CustomerSupportFocal = null;
            BusinessFocal = null;
        }*/
    
         return null;
    } //created for Red Button Site end
    public void callattach()
    {
    system.debug('ttttttttt');
    att1= new attachment();
    att1=att;
    }
    
    //created for Red Button Site Start
    public list<SelectOption> gethelpinfoInput()
	{
    list<SelectOption> options = new list<SelectOption>();
    options.add(new SelectOption('True', 'Yes'));
    options.add(new SelectOption('False', 'No'));

    return options;
	}     //created for Red Button Site end
    /// anu
    public List<SelectOption> getoptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        options.add(new SelectOption('None','None'));
        return options;
    }  

     public void makereq()
    {
    //c.Workstrem__c=text2;
    if(c.Workstrem__c=='Repair and Overhaul'){
            text3 = c.Workstrem__c;
            requiredval1=true;
            requiredval2=false;
            requiredval3=false;
            sure1=true;
            sure2=false;
            sure3=false;
         }
    if(c.Workstrem__c=='Spares'){
            text3 = c.Workstrem__c;
            requiredval1=false;
            requiredval2=true;
            requiredval3=false;
            sure1=false;
            sure2=true;
            sure3=false;
         }
    if(c.Workstrem__c=='OEM'){
        text3 = c.Workstrem__c;
        requiredval1=false;
        requiredval2=false;
        requiredval3=true;
        sure1=false;
        sure2=false;
        sure3=true;
        }
    }
    
  /*  public void ctype()
    {
    sure=false;
    }
    
    public void ctype1()
    {
    sure=true;
    }*/
}