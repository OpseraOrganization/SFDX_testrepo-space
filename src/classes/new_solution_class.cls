public with sharing class new_solution_class {
    public boolean bl = true;
    public String rectype{get;set;}
    String id1;
    public Solution s{get; set;}
    case  caserec1 = new case();        
    public new_solution_class(ApexPages.StandardController controller) {
        s = new Solution();
        rectype = 'Solution Record Type   :   Solution GTO Technical' ;
        id1 = Apexpages.currentPage().getParameters().get('rec');
        system.debug('ddddddddddd'+id1);   
   
        case  caserec= new case();
        id Caseid = Apexpages.currentPage().getParameters().get('cas');
    
        if(Caseid != null)
        caserec=[select Subject,Product_Types__c,Product_Type__c,Supported_Products__c,Supported_Product__c, Catalog_Product_Group__c,Catalog_Product_Groups__c, Description,Resolution__c,id from case where id=: Caseid];
        system.debug('casereccasereccaserec -- '+caserec);
          caserec1 = caserec; 
         s.SolutionName=caserec.Subject;
         //s.SolutionName=caserec.Subject;
         //s.Product_Type__c=caserec.Product_Type__c;
         s.Supported_Product__c=caserec.Supported_Product__c;
         //s.Catalog_Product_Group__c=caserec.Catalog_Product_Group__c;
         
        s.Product_Type__c=caserec.Product_Types__c;
         s.Supported_Products__c=caserec.Supported_Products__c;
        s.Catalog_Product_Group__c=caserec.Catalog_Product_Groups__c;
         
         s.FAQ__c=caserec.Description;
         s.SolutionNote=caserec.Resolution__c;      // s.Recordtypeid=id1;
   
    }
   
   //set method for Skills
    public void setcaserec1(Case caserec1) {
        this.caserec1= caserec1;
    }

    //Getting the Skils Object    
    public Case getCaseRec1(){
        return caserec1;
    }
     
   public List<Platform__c> airsol {get;set;} 
   public List<Platform__c> list1= new List<Platform__c>();
   public String list2{get;set;}
   public List<SelectOption> optionssol;
   List<Solution_Aircraft__c> solutionAirCraft= new list<Solution_Aircraft__c>();
  
   public List<String> selvalues1 = new List<String>();
   public List<String> selvalues {get;set;}
  
 /*  public String getsolutionId() {
   return s.ID;
  }
  
  public void setsolutionId(String solutionId) {
   s = [select ID,Catalog_Product_Group__c,Supported_Product__c,Export_Controlled__c,Secure_Notes__c,Publish_External__c,Export_Review_By__c,Export_Review_Date__c from Solution where ID =: solutionId] ;
  }*/
   
   
  public void navigate()
   { 
     System.debug('wwwwwwwwwwwww'+list1);     
     String sql = 'select name from Platform__c';
     List<String> str1 = new List<String>();
     Set<String> myset = new Set<String>();   
     System.debug(list2);
     if(list2!=null)
        sql = sql + ' where ';
         
     try{
     if(list2.contains('A-E')){
        system.debug('aaaaaaaaa');
        System.debug('Inside A-E'); 
        sql = sql + ' name like \'A%\' or name like \'B%\' or name like \'C%\' or name like \'D%\' or name like \'E%\' or name like \'a%\' or name like \'b%\' or name like \'c%\' or name like \'d%\' or name like \'e%\' ';     
     }   
        
     if(list2.contains('F-J')){
        if(sql.indexof('like') ==  -1){
        sql = sql + ' name like \'F%\' or name like \'G%\' or name like \'H%\' or name like \'I%\' or name like \'J%\' or name like \'f%\' or name like \'g%\' or name like \'h%\' or name like \'i%\' or name like \'j%\' ';         
        }
        else{
            sql = sql + ' or name like \'F%\' or name like \'G%\' or name like \'H%\' or name like \'I%\' or name like \'J%\' or name like \'f%\' or name like \'g%\' or name like \'h%\' or name like \'i%\' or name like \'j%\' ';    
        }
     }   
     
     if(list2.contains('K-O')){
        if(sql.indexof('like') ==  -1){
        sql = sql + ' name like \'K%\' or name like \'L%\' or name like \'M%\' or name like \'N%\' or name like \'O%\' or name like \'k%\' or name like \'l%\' or name like \'m%\' or name like \'n%\' or name like \'o%\' ';         
        }
        else{
            sql = sql + ' or name like \'K%\' or name like \'L%\' or name like \'M%\' or name like \'N%\' or name like \'O%\' or name like \'k%\' or name like \'l%\' or name like \'m%\' or name like \'n%\' or name like \'o%\' ';    
        }
     }
     
     if(list2.contains('P-T')){
        if(sql.indexof('like') ==  -1){
        sql = sql + ' name like \'P%\' or name like \'Q%\' or name like \'R%\' or name like \'S%\' or name like \'T%\' or name like \'p%\' or name like \'q%\' or name like \'r%\' or name like \'s%\' or name like \'t%\' ';       
        }
        else{
            sql = sql + ' or name like \'P%\' or name like \'Q%\' or name like \'R%\' or name like \'S%\' or name like \'T%\' or name like \'p%\' or name like \'q%\' or name like \'r%\' or name like \'s%\' or name like \'t%\' ';    
        }
     }
     
     if(list2.contains('U-Z')){
        if(sql.indexof('like') ==  -1){
        sql = sql + ' name like \'U%\' or name like \'V%\' or name like \'W%\' or name like \'X%\' or name like \'Y%\' or name like \'Z%\' or name like \'u%\' or name like \'v%\' or name like \'w%\' or name like \'x%\'  or name like \'y%\' or name like \'z%\' ';         
        }
        else{
            sql = sql + ' or name like \'U%\' or name like \'V%\' or name like \'W%\' or name like \'X%\' or name like \'Y%\' or name like \'Z%\' or name like \'u%\' or name like \'v%\' or name like \'w%\' or name like \'x%\'  or name like \'y%\' or name like \'z%\' ';    
        }
     }
     sql = sql + 'order by Name';
     system.debug('XXXXXXXXXXXXXX'+ sql);
     if(list2!= null)   
          System.debug('0000000000'+sql);
           list1 = Database.query(sql);
           System.debug('wwwwwwwwwwwww'+list1);
           }
           catch(exception e){
          } 
    }  
 
 
  public List<SelectOption> getvalues() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('A-E','AirCraft A-E'));
            options.add(new SelectOption('F-J','AirCraft F-J'));
            options.add(new SelectOption('K-O','AirCraft K-O'));
            options.add(new SelectOption('P-T','AirCraft P-T'));
            options.add(new SelectOption('U-Z','AirCraft U-Z'));
            return options;
        }
   
  public List<SelectOption> getlist1()
  { 
   List<Platform__c> sol=new List<platform__c>();
   optionssol= new List<SelectOption>();
   for(integer i=0;i<list1.size();i++) 
   {
     optionssol.add(new SelectOption(list1[i].id,list1[i].name));
   }
   System.debug(selvalues);
   return optionssol;
  }
 
  public boolean getevallist(){
   if(list1.size() > 0)
     return true;
   else
     return false;
  }  
  
    public solution getSol(){
        return s;
    }
    public void setSol(Solution s1) {
        s = s1;
    }
  public PageReference doCancel(){ 
     Pagereference p = new Pagereference('/501/o');
     p.setredirect(true);
     return p;
    }  
  
  public void ok(){
   List<String> str = new List<String>();
   System.debug(selvalues);
   if(selvalues != null){
     for(String s1 : selvalues){
        selvalues1.add(s1);
      }
     } 
   System.debug(selvalues1.size());   
  }
  
  public PageReference doSave(){
          
     s.Recordtypeid=id1;
     try{
     insert s;
     system.debug('Current Approver : '+s.Current_approver__c);
    }catch(Exception e){
     ApexPages.addMessages(e);
     return null;
   }
       if(selvalues1 != null) {
              for(String s1 : selvalues1){
                 Solution_Aircraft__c sol= new Solution_Aircraft__c(solution__c=s.Id, AirCraft_Type__c= s1);
                 insert sol;       
                 system.debug('$$$$$$$$$$'+ sol);
                } 
           } 
  
      Pagereference p = new Pagereference('/'+s.ID);
      p.setredirect(true);
      return p;
  } 
  
   public PageReference doSaveandNew(){
        
     s.Recordtypeid=id1;
     try{
      insert s;
     }catch(Exception e){
        ApexPages.addMessages(e); 
        return null;
     }
      if(selvalues1 != null) {
              for(String s1 : selvalues1){
                 Solution_Aircraft__c sol= new Solution_Aircraft__c(solution__c=s.Id, AirCraft_Type__c= s1);
                 insert sol;       
                 system.debug('$$$$$$$$$$'+ sol);
                } 
           }
      Pagereference p = new Pagereference('/apex/Solution_VF');
      p.setredirect(true);
      
      return p;
      
  } 
  
  public PageReference getSupportedProduct(){
       List<Supported_Products__c> sps=[Select Id,name,Product_Type__c ,Catalog_Product_Group__c from Supported_Products__c where Id=:getSol().Supported_Products__c];
       System.debug('query ======= '+sps);
       if(sps!=null && sps.size()>0){
           s.Catalog_Product_Group__c=sps[0].Catalog_Product_Group__c;
           s.Product_Type__c=sps[0].Product_Type__c;
       }else{
           s.Catalog_Product_Group__c='';
           s.Product_Type__c='';    
       }
       
       return null;
   } 
  
 }