public class OpportunityProductLineController{
public String accId{get;set;}
public String stage{get;set;}
public String rt{get;set;}
public String rorg{get;set;}
public String soltype{get;set;}
public String oppId{get;set;}
public String actMsg{get;set;}
public String accNameToSearch{get;set;}
//public String quantity{get;set;}
public String platform{get;set;}
public String platformtype{get;set;}
public String tableheader{get;set;}
public String tableheader1{get;set;}
public String tableheader2{get;set;}

public List<Opportunity_Product_Line__c> searchResults1{get;set;}
public List<OppProdLine__c> searchResults{get;set;}
public List<Account_Email_Domains__c> emailDomains{get;set;}
public List<EmailDomains> emailDomainsList{get;set;}
public Set<String> selectedEmailDomains{
    get {
        if(selectedEmailDomains == null) selectedEmailDomains= new Set<String>();
            return selectedEmailDomains;
    }
    set;
}
    String s = Apexpages.currentpage().getParameters().get('platformtype');
 
    public String getString() {
        return s;
    }
            
    public void setString(String s) {
        this.s = s;
    }

String rtype;
public OpportunityProductLineController(){
    
    accId=Apexpages.currentpage().getParameters().get('accId');
    rt=Apexpages.currentpage().getParameters().get('rt');
    rorg=Apexpages.currentpage().getParameters().get('rorg');
    stage=Apexpages.currentpage().getParameters().get('stage');
    soltype=Apexpages.currentpage().getParameters().get('soltype');
    oppId=Apexpages.currentpage().getParameters().get('oppId');
   //quantity=Apexpages.currentpage().getParameters().get('quantity');
    
    platform=Apexpages.currentpage().getParameters().get('platform');
    platformtype=Apexpages.currentpage().getParameters().get('platformtype');
    
    if(rt != null || rt != ''){
        try {
            rtype = [Select Name from RecordType where Id = :rt].Name;
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Selected Opportunity Product Line has already been added to Opportunity, Please select another Opportunity Product Line.'));
        }
    }
    //System.debug(' Record Type : '+rtype);
    actMsg ='';
    
    
    search();
    /*
    if(rtype == 'OE Complex' || rtype == 'OE Standard'){
        if((rorg == 'Avionics & Lighting Services' || rorg == 'Avionics LRU') ){  //&& (stage == 'Closed Won' || stage == 'Closed Lost' || stage == 'Closed Cancelled')
            search();
        }else{
            actMsg ='Error : Opportunity Product Line is applicable only for Stage as Closed Won/Closed Lost/Closed Cancelled and Review Org as Avionics LRU/Avionics & Lighting Services.';
        }
    }else {
        if((soltype == 'BFE / SSFE' || soltype == 'OE - Original Equipment') && (rorg == 'Avionics & Lighting Services' || rorg == 'Avionics LRU')){  // && (stage == 'Closed Won' || stage == 'Closed Lost' || stage == 'Closed Cancelled')
            search();
        }else{
            actMsg ='Error : Opportunity Product Line is applicable only for Stage as Closed Won/Closed Lost/Closed Cancelled and Solution Type as BFE / SSFE or OE - Original Equipment and Review Org as Avionics LRU/Avionics & Lighting Services.';
        }
    }
    */
    if(stage == 'Closed Won'){
        tableheader='Maintain Incumbency';
        tableheader1='Overturn Non-Incumbency';
        tableheader2='New Customer-No Incumbency';
    } else if(stage == 'Closed Lost' || stage == 'Closed Cancelled') {
        tableheader='Was Incumbent';
        tableheader1='Was Non-Incumbent';
        tableheader2='New Customer-No Incumbency';
    }else {
        tableheader='Incumbent';
        tableheader1='Non-Incumbent';
        tableheader2='New Customer-No Incumbency';
    }
    
    
}
public void search(){
    
    emailDomainsList=new List<EmailDomains>();
    String accNameToSearchWthWld=accNameToSearch+'%';
    
    searchResults1 = [SELECT Id,Opportunity__c, Product_Line__c FROM Opportunity_Product_Line__c where Opportunity__c =: oppId];
    List<String> prodLine = new List<String>();
    for(Opportunity_Product_Line__c opline:searchResults1){
        prodLine.add(opline.Product_Line__c);
    }
    //if(prodLine.size()>0){
        searchResults=[SELECT Id, Name FROM OppProdLine__c where Name not in : prodLine order by OrderNumber__c];
    //}else {
    //    searchResults=[SELECT Id, Name FROM OppProdLine__c order by OrderNumber__c];
    //}
    
    integer i=0;
    actMsg = '';
    for(OppProdLine__c acc:searchResults){
            EmailDomains ed=new EmailDomains();
            ed.pLine=acc.Name;
            
            ed.checked=false;
            ed.checked1=false;
            ed.checked2=false;
            emailDomainsList.add(ed);
        i=i+1;
     }
     if(emailDomainsList!=null && emailDomainsList.size()==0){
         emailDomainsList=null;
         actMsg ='No Data Found';
     }
    }
public PageReference addToAccount(){
    selectedEmailDomains.clear();
    
    List<Opportunity_Product_Line__c> opl1 = new List<Opportunity_Product_Line__c>();
    Opportunity oppty = new Opportunity();
    if(oppId != null || oppId != ''){
        try {
        oppty = [Select Opportunity_Product_Line_Quantity__c,Opportunity_Product_Line_Platform__c,Opportunity_Product_Line_Platform_Type__c from Opportunity where Id = : oppId];
        }catch(Exception e){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Selected Opportunity Product Line has already been added to Opportunity, Please select another Opportunity Product Line.'));
        }
    }
    
    //oppty.Opportunity_Product_Line_Quantity__c = Integer.valueOf(quantity);
    oppty.Opportunity_Product_Line_Platform__c = platform;
    oppty.Opportunity_Product_Line_Platform_Type__c = getstring();
    
    for(EmailDomains val:emailDomainsList){
        Opportunity_Product_Line__c opl = new Opportunity_Product_Line__c();
        
            if(val.checked){
                opl.Product_Line__c = val.pLine;
                opl.Maintain_Incumbency__c = val.checked;
                opl.Comments__c = val.pComments;
                opl.Opportunity__c = oppId;
                opl.Stage__c = stage;
                opl1.add(opl);
                
            }
            if(val.checked1){
                opl.Product_Line__c = val.pLine;
                opl.Overturn_Non_Incumbency__c = val.checked1;
                opl.Comments__c = val.pComments;
                opl.Opportunity__c = oppId;
                opl.Stage__c = stage;
                opl1.add(opl);
                
            }
            if(val.checked2){
                opl.Product_Line__c = val.pLine;
                opl.New_Customer_No_Incumbency__c = val.checked2;
                opl.Comments__c = val.pComments;
                opl.Opportunity__c = oppId;
                opl.Stage__c = stage;
                opl1.add(opl);
                
            }
            if(val.checked){
                selectedEmailDomains.add(val.pLine);
            }
    }
    
    try {
        insert opl1;
    }catch(Exception e){
        System.debug(e);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Selected Opportunity Product Line has already been added to Opportunity, Please select another Opportunity Product Line.'));
        return new PageReference('/apex/OpportunityProductLine?soltype='+soltype+'&rt='+rt+'&rorg='+rorg+'&stage='+stage+'&oppId='+oppId);
    }
    try {
        update oppty;
    }catch(Exception e){
        System.debug(e);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Selected Opportunity Product Line has already been added to Opportunity, Please select another Opportunity Product Line.'));
        return new PageReference('/apex/OpportunityProductLine?soltype='+soltype+'&rt='+rt+'&rorg='+rorg+'&stage='+stage+'&oppId='+oppId);
    }
   
    return new PageReference('/'+oppId);
    }
    
    public PageReference doCancel(){
        return new PageReference('/'+oppId);
    }
    public class EmailDomains{
        public Boolean checked{get;set;}
        public Boolean checked1{get;set;}
        public Boolean checked2{get;set;}
        public String pLine{get;set;}
        public String pComments{get;set;}
        
        public String emailDomain{get;set;}
    }
}