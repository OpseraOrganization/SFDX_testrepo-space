public class SalesCompetencyRatingController {

    //Our collection of the class/wrapper objects Sscr 
    public List<Sscr> ScrList {get; set;}
    public Sales_Competency__c sc;
    public List<development_resource__c> dr { get; set; }
    List<development_resource__c> jb1 = new List<development_resource__c>();
    String jbdid;
    String s1;
    public boolean displayPopup {get; set;} 
    public string varA { get; set; }
    public list<string> varB { get; set; }
    public string str1 { get; set; }
    public Boolean usernameExists;
    set<id> selectedaccounts=new set<id>();
    set<string> st=new set<string>();
    set<string> st1=new set<string>();
    list<String> k1=new list<string>();
    list<String> k2=new list<string>();
    list<String> k22=new list<string>();
    String k='';
    String k3='';
    String k4='';
    String k44='';
    String k5=''; 
    List<Sales_Competency_Rating__c> selectedscr = new List<Sales_Competency_Rating__c>(); 

    public Boolean getUsernameExists() {
        return usernameExists;
    }
    Public boolean isSF1{get;set;}
    private ApexPages.StandardController controller;
     private ApexPages.StandardController setcon;
    public SalesCompetencyRatingController(ApexPages.StandardController controller) {
        this.controller=controller;
        sc=(Sales_Competency__c)controller.getRecord();
        
        for(Sales_Competency_Rating__c s1: [select name,id,Self_Assessment_Proficiency__c,Competency__c,Examples_of_Proficiency__c,Potential_Development_Actions__c,Self_Assessment_Comment__c,Proficiency_Expectation_for_Role_Target__c,Employee_Proficiency_Rating__c,SubCompetency_Needs_Development__c,Suggested_Development_Action_New__c,Suggested_Development_Actions__c,Comments_New__c,Proficiency_Delta__c from Sales_Competency_Rating__c Where Sales_Competency_Assessment__c =: sc.Id]) {
                ScrList1.add(s1);
            }
        
        String useragent=ApexPages.currentPage().getHeaders().get('USER-AGENT');
        if(useragent!=null){
            if(useragent.contains('iphone')|| useragent.contains('iPad')||useragent.contains('safari')){
                isSF1=true;
            }
        }
    }
    public void closePopup()
    {       
        displayPopup = false;
        selectedContactIds.clear();  
    }  
     
    public void Add()
    { 
        
        jb1=[select Development_Resource_Name__c,Suggested_Development_Action__c,Format__c from development_resource__c where id in: selectedContactIds ];
        k3='';
        system.debug('ssssssssssssssssssskkkkkkkkkkk++++++++++++++++++++++++++++++++++++++++ssssssssssssssssssssssssss'+selectedContactIds);
        for(Development_Resource__c j:jb1)
        {     
           if(j.Suggested_Development_Action__c == null)
           {     
           k1.add('['+j.Format__c+']'+' - '+j.Development_Resource_Name__c);        
           } 
           else
           {     
           k1.add('['+j.Format__c+']'+' - '+j.Development_Resource_Name__c+' - '+j.Suggested_Development_Action__c);        
           }     
        }
        st.addAll(k1);
        for(String s:st)
        {            
           k3=s+'\n'+'\n'+k3;             
        } 
        this.selectedContactIds.clear();  
        st.clear();
        k1.clear(); 
          
        for(Sscr cCon: getsalesCompRatings()) 
        {
             if(cCon.scr.id == jbdid) 
             {
               if(cCon.scr.Suggested_Development_Action_New__c==null)
                 {
                     cCon.scr.Suggested_Development_Action_New__c=k3;
                     selectedscr.add(cCon.scr);
                 }
                if(cCon.scr.Suggested_Development_Action_New__c!=null)
                 {
                     k5='';
                     k44=k3;
                     k22=k44.split('\n'+'\n'); //Current selection
                     k4=cCon.scr.Suggested_Development_Action_New__c;
                     k2=k4.split('\n'+'\n');   //Existing selection
                     st1.addAll(k22);
                     st1.addAll(k2);

                     for(string st2:st1)
                         {
                             k5=st2+'\n'+'\n'+k5;                
                         }  
                         k5=k5.removeEnd('\n'+'\n'+'\n');    
                         cCon.scr.Suggested_Development_Action_New__c=k5;
                         selectedscr.add(cCon.scr);
           
                 }
                 
             }
        
        }                
        update selectedscr;
        system.debug('++++++++update selectedscr++++++++'+selectedscr);
        this.selectedContactIds.clear();
        selectedscr.clear();
        k3=''; 
        displayPopup = false; 
        k22.clear();
        k2.clear();
        st1.clear();
        k5=''; 
    }
    
    public Integer getSelectedCount()
   {
        system.debug('+++++++++++++++++++'+this.selectedContactIds.size());
        return this.selectedContactIds.size();
    }

    
    public void showPopup()
    {     
        string s=ApexPages.CurrentPage().getParameters().get('jd');
        jbdid=s;
        s1=[select id,Competency__c from Sales_Competency_Rating__c where id =: s].Competency__c;
        dr =[select Development_Resource_Name__c,Competency__c,Sub_Competency_Needs_Development__c,Format__c from development_resource__c where Competency__c =:s1 ORDER BY Sub_Competency_Needs_Development__c  desc,Format__c asc];
        displayPopup = true;  
        
    }

    public List<Sscr> getsalesCompRatings() {
        if(ScrList == null) {
            ScrList = new List<Sscr>();
            for(Sales_Competency_Rating__c s: [select name,id,Self_Assessment_Proficiency__c,Competency__c,Examples_of_Proficiency__c,Potential_Development_Actions__c,Self_Assessment_Comment__c,Proficiency_Expectation_for_Role_Target__c,Employee_Proficiency_Rating__c,SubCompetency_Needs_Development__c,Suggested_Development_Action_New__c,Suggested_Development_Actions__c,Comments_New__c,Proficiency_Delta__c from Sales_Competency_Rating__c Where Sales_Competency_Assessment__c =: Apexpages.currentpage().getparameters().get('id')]) {
                ScrList.add(new Sscr(s));
            }
        }
        return ScrList;
    }
    

    public Sales_Competency_Rating__c[] oldRecords;
    List<Sales_Competency_Rating__c> ScrList1 = new List<Sales_Competency_Rating__c>(); 
    
    public PageReference savescr() {
        List<Sales_Competency_Rating__c> selectedscr = new List<Sales_Competency_Rating__c>();
        for(Sscr cCon: getsalesCompRatings()) {
            selectedscr.add(cCon.scr);
        }
        //update selectedscr;
        try{
            update selectedscr;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        
        //ApexPages.Message myMsg= new ApexPages.Message(ApexPages.severity.CONFIRM,'Saved Successfully');
        //ApexPages.addMessage(myMsg);
         
        for(Sales_Competency_Rating__c scr: selectedscr) {
            system.debug(scr);
        }
        ScrList=null;
        return null;
    }
    
    public PageReference savecloseemp() { 
        //sc.Status__c = 'Draft (Manager)';
        //update sc;
        List<Sales_Competency_Rating__c> selectedscr = new List<Sales_Competency_Rating__c>();
        for(Sscr cCon: getsalesCompRatings()) {
            selectedscr.add(cCon.scr);
        }
        //update selectedscr;
        try{
            update selectedscr;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        
        ApexPages.Message myMsg= new ApexPages.Message(ApexPages.severity.CONFIRM,'Saved Successfully');
        ApexPages.addMessage(myMsg);
        for(Sales_Competency_Rating__c scr: selectedscr) {
            system.debug(scr);
        }
        ScrList=null;
        return null;
    }
    
    public PageReference saveclosemgr() {
        //sc.Status__c = 'In Review (Employee)';
        //update sc;
        usernameExists = false;
        
        List<Sales_Competency_Rating__c> selectedscr = new List<Sales_Competency_Rating__c>();
        for(Sscr cCon: getsalesCompRatings()) {
            selectedscr.add(cCon.scr);
        }
        
        oldRecords = ScrList1.deepClone(true,true,true);
        system.debug('oldRecords>>>'+oldRecords);
        
        List<Sales_Competency_Rating__c> selectedscr2 = new List<Sales_Competency_Rating__c>();
        List<string> comp = new List<string>();
        for(Integer i = 0;i < selectedscr.size();i++){
            if((((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Basic') && (selectedscr[i].Employee_Proficiency_Rating__c ==null)) || 
            ((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Experienced') && ((selectedscr[i].Employee_Proficiency_Rating__c ==null) || (selectedscr[i].Employee_Proficiency_Rating__c =='Basic'))) || 
            ((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Advanced') && (selectedscr[i].Employee_Proficiency_Rating__c ==null || selectedscr[i].Employee_Proficiency_Rating__c =='Basic' || selectedscr[i].Employee_Proficiency_Rating__c =='Experienced')) || 
            ((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Mastery') && (selectedscr[i].Employee_Proficiency_Rating__c ==null || selectedscr[i].Employee_Proficiency_Rating__c =='Experienced' || selectedscr[i].Employee_Proficiency_Rating__c =='Advanced' || selectedscr[i].Employee_Proficiency_Rating__c =='Basic'))) && 
            (selectedscr[i].SubCompetency_Needs_Development__c == null) && 
            (selectedscr[i].Employee_Proficiency_Rating__c != oldRecords[i].Employee_Proficiency_Rating__c)){ 
                system.debug('Proficiency_Delta__c'+selectedscr[i].Proficiency_Delta__c);
                system.debug('SubCompetency_Needs_Development__c'+selectedscr[i].SubCompetency_Needs_Development__c);
                system.debug('selectedscr[i].Employee_Proficiency_Rating__c'+selectedscr[i].Employee_Proficiency_Rating__c);
                system.debug('oldRecords[i].Employee_Proficiency_Rating__c'+oldRecords[i].Employee_Proficiency_Rating__c);
                usernameExists = true;
                selectedscr2.add(selectedscr[i]);
                varA = selectedscr[i].Competency__c;
                comp.add(selectedscr[i].Competency__c);
            }
        }
        
        varB = comp;
        
        for(String strn : varB){
        if(str1 == NULL){
        str1 = strn;
        }
        else{
        str1 += '/n' + strn; 
        }
        }
        
        if(selectedscr2.size() ==0){
        //update selectedscr;
        try{
            update selectedscr;
            //PageReference redirecturl = new PageReference('/'+sc.id);
            //return redirecturl;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        }
        
        //ApexPages.Message myMsg= new ApexPages.Message(ApexPages.severity.CONFIRM,'Saved Successfully');
        //ApexPages.addMessage(myMsg);
        //ScrList=null;
        return null;
    }
    
    public PageReference saveclosemgr1() {
        //sc.Status__c = 'In Review (Employee)';
        //update sc;
        usernameExists = false;
        
        String TargProf;
        String EmpProf;
        
        
        List<Sales_Competency_Rating__c> selectedscr = new List<Sales_Competency_Rating__c>();
        for(Sscr cCon: getsalesCompRatings()) {
            selectedscr.add(cCon.scr);
            //TargProf = cCon.Proficiency_Expectation_for_Role_Target__c;
            //EmpProf = cCon.Employee_Proficiency_Rating__c;
        }
        
        oldRecords = ScrList1.deepClone(true,true,true);
        system.debug('oldRecords>>>'+oldRecords);
        
        List<Sales_Competency_Rating__c> selectedscr2 = new List<Sales_Competency_Rating__c>();
        List<string> comp = new List<string>();
        for(Integer i = 0;i < selectedscr.size();i++){
            if((((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Basic') && (selectedscr[i].Employee_Proficiency_Rating__c ==null)) || 
            ((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Experienced') && ((selectedscr[i].Employee_Proficiency_Rating__c ==null) || (selectedscr[i].Employee_Proficiency_Rating__c =='Basic'))) || 
            ((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Advanced') && (selectedscr[i].Employee_Proficiency_Rating__c ==null || selectedscr[i].Employee_Proficiency_Rating__c =='Basic' || selectedscr[i].Employee_Proficiency_Rating__c =='Experienced')) || 
            ((selectedscr[i].Proficiency_Expectation_for_Role_Target__c =='Mastery') && (selectedscr[i].Employee_Proficiency_Rating__c ==null || selectedscr[i].Employee_Proficiency_Rating__c =='Experienced' || selectedscr[i].Employee_Proficiency_Rating__c =='Advanced' || selectedscr[i].Employee_Proficiency_Rating__c =='Basic'))) && 
            (selectedscr[i].SubCompetency_Needs_Development__c == null) && 
            (selectedscr[i].Employee_Proficiency_Rating__c != oldRecords[i].Employee_Proficiency_Rating__c)){ 
                system.debug('Proficiency_Delta__c'+selectedscr[i].Proficiency_Delta__c);
                system.debug('SubCompetency_Needs_Development__c'+selectedscr[i].SubCompetency_Needs_Development__c);
                system.debug('selectedscr[i].Employee_Proficiency_Rating__c'+selectedscr[i].Employee_Proficiency_Rating__c);
                system.debug('oldRecords[i].Employee_Proficiency_Rating__c'+oldRecords[i].Employee_Proficiency_Rating__c);
                usernameExists = true;
                selectedscr2.add(selectedscr[i]);
                comp.add(selectedscr[i].Competency__c);
            }
        }

        varB = comp;
        
        
        if(selectedscr2.size() ==0){
        //update selectedscr;
        try{
            update selectedscr;
            PageReference redirecturl = new PageReference('/'+sc.id);
            return redirecturl;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        }
        
        //ApexPages.Message myMsg= new ApexPages.Message(ApexPages.severity.CONFIRM,'Saved Successfully');
        //ApexPages.addMessage(myMsg);
        //ScrList=null;
        return null;
    }
    
    
    // This is our wrapper/container class.
    public class Sscr {
        public Sales_Competency_Rating__c scr {get; set;}
        public Boolean selected {get; set;}
        
        public Sscr(Sales_Competency_Rating__c s) {
            scr = s;
            selected = false;
        }
     }
    
    public pagereference goback(){
        PageReference  p=new PageReference('/'+sc.id);
        p.setRedirect(true);
        return p;
    }
    
    public boolean b{get;set;}
    public List<CCWRowItem> getContacts()
    {
     
        list<CCWRowItem> rows= new List<CCWRowItem>();

        for(development_resource__c r : dr)
        //[select id,Name,Competency__c,Sub_Competency_Needs_Development__c,Suggested_Development_Action__c from development_resource__c where id =: selected  ])
        {
                  Development_Resource__c c= (Development_Resource__c)r;
                  
                 
                    CCWRowItem row = new CCWRowItem(c);
                    if(this.selectedContactIds.contains(c.Id))
                    {
                        row.IsSelected=true;
                    }
                    else
                    {
                        row.IsSelected=false;
                    }
                    rows.add(row);
            
        }
 
        return rows;
 
    }
    public with sharing class CCWRowItem{
 
        public Development_Resource__c tContact{get;set;}
        public string apply{get;set;}
        public boolean IsSelected{get;set;}
        public CCWRowItem(Development_Resource__c c)
        {
            this.tContact=c;
            this.IsSelected=false;
           
        }
 
    }
    
    list<CCWRowItem> contacts{get;set;}
     
   
public Set<Id> selectedContactIds=new  Set<Id>();
    public String contextItem{get;set;}
    public Boolean IsSelected{get;set;}

public void doSelectItem()
    {
 
        this.selectedContactIds.add(this.contextItem);
        
 
    }
 
    /*
    *   handle item deselected
    */
    public void doDeselectItem()
    {
 
        this.selectedContactIds.remove(this.contextItem);
 
    }

}