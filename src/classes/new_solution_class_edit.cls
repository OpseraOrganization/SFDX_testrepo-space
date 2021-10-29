public with sharing class new_solution_class_edit {

    public new_solution_class_edit(ApexPages.StandardController controller) {
 }  

    solution  caserec= new solution();
    id ID1 = Apexpages.currentPage().getParameters().get('id');
    id rec = Apexpages.currentPage().getParameters().get('rec');
    String soluno;
  public String getSolno(){
      return soluno;
  }  

 Solution s = new Solution(ID = ID1);
  {
    soluno = Apexpages.currentPage().getParameters().get('solno');   
    system.debug('aaaaaaaaaaaaa'+ ID1);
    if(ID1 != null)
    caserec=[select id,SolutionName, Catalog_Product_Groups__c,Product_Types__c,Supported_Products__c,SolutionNumber,Status,Categorization__c,Product_Support_Engineer_Email__c,SBL_Solution_Legacy_Number__c,RecordTypeid,Approved_Date__c,Export_Controlled__c,Secure_Notes__c,FAQ__c,SolutionNote,Product_Type__c,Catalog_Product_Group__c,Supported_Product__c,Primary__c,Secondary__c,Product_Number__c,Audit_Frequency__c,Publish_Internal__c,Intellectual_Property_Review_By__c,Export_Review_Complete_NLR__c,Export_Review_Date__c,Expiration_Date__c,Publish_External__c,Intellectual_Property_Review_Date__c,Export_Review_By__c,Standards_Review_Approved_By__c,Technical_Review_Audit_Approved_By__c,Technical_Review_Approved_By__c,Approver__c,Approver_Name__c,Rejected_By__c,Legacy_Created_by__c,Legacy_Created_Date__c,Legacy_Solution_Approval_Date__c,Legacy_Last_Modified_by__c,Legacy_Last_Modifed_Date__c from solution where id=: ID1];
    system.debug('eeeeeeeeeee'+ caserec);
  }
  {
      
    s.SolutionName = caserec.SolutionName;
    s.Categorization__c = caserec.Categorization__c;
    s.Product_Support_Engineer_Email__c = caserec.Product_Support_Engineer_Email__c;
    s.SBL_Solution_Legacy_Number__c = caserec.SBL_Solution_Legacy_Number__c;
    s.RecordTypeid = caserec.RecordTypeid;
    s.Status = caserec.Status;
    s.Approved_Date__c = caserec.Approved_Date__c;
    s.Export_Controlled__c = caserec.Export_Controlled__c;
    s.Secure_Notes__c = caserec.Secure_Notes__c;
    s.FAQ__c = caserec.FAQ__c;
    s.SolutionNote = caserec.SolutionNote;
    s.Product_Type__c = caserec.Product_Types__c;
    s.Catalog_Product_Group__c = caserec.Catalog_Product_Groups__c;
    s.Supported_Products__c = caserec.Supported_Products__c;
    s.Primary__c = caserec.Primary__c;
    s.Secondary__c = caserec.Secondary__c;
    s.Product_Number__c = caserec.Product_Number__c;
    s.Audit_Frequency__c = caserec.Audit_Frequency__c;
    s.Publish_Internal__c = caserec.Publish_Internal__c ;
    s.Intellectual_Property_Review_By__c = caserec.Intellectual_Property_Review_By__c;
    s.Export_Review_Complete_NLR__c = caserec.Export_Review_Complete_NLR__c;
    s.Export_Review_Date__c = caserec.Export_Review_Date__c;
    s.Expiration_Date__c = caserec.Expiration_Date__c;
    s.Publish_External__c = caserec.Publish_External__c;
    s.Intellectual_Property_Review_Date__c = caserec.Intellectual_Property_Review_Date__c;
    s.Export_Review_By__c = caserec.Export_Review_By__c;
    s.Standards_Review_Approved_By__c = caserec.Standards_Review_Approved_By__c;
    s.Technical_Review_Approved_By__c = caserec.Technical_Review_Approved_By__c;
    s.Approver_Name__c = caserec.Approver_Name__c;
    s.Approver__c = caserec.Approver__c;
    s.Technical_Review_Audit_Approved_By__c = caserec.Technical_Review_Audit_Approved_By__c;
    s.Rejected_By__c = caserec.Rejected_By__c;
    s.Technical_Review_Approved_By__c = caserec.Technical_Review_Approved_By__c;
    s.Legacy_Created_by__c = caserec.Legacy_Created_by__c;
    s.Legacy_Created_Date__c = caserec.Legacy_Created_Date__c;
    s.Legacy_Solution_Approval_Date__c = caserec.Legacy_Solution_Approval_Date__c;
    s.Legacy_Last_Modified_by__c = caserec.Legacy_Last_Modified_by__c;
    s.Legacy_Last_Modifed_Date__c = caserec.Legacy_Last_Modifed_Date__c;
  }  
   
   public List<Platform__c> airsol {get;set;} 
   public List<Platform__c> list1= new List<Platform__c>();
   public String list2{get;set;}
   public List<SelectOption> optionssol;
   List<Solution_Aircraft__c> solutionAirCraft= new list<Solution_Aircraft__c>();
  
   public List<String> selvalues1 = new List<String>();
   public List<String> selvalues {get;set;}  
  
 public void navigate()
   { 
     String sql = 'select name from Platform__c';
     List<String> str1 = new List<String>();
      if(list2!=null)
        sql = sql + ' where ';
      
     System.debug(sql);
     
 //    System.debug(list2.contains('F'));
     try{
     if(list2.contains('A')){
        System.debug('Inside A'); 
        // sql = sql + ' name like \'A%\' or name like \'B%\' or name like \'C%\' or name like \'D%\' or name like \'E%\' or name like \'a%\' or name like \'b%\' or name like \'c%\' or name like \'d%\' or name like \'e%\' ';     
           sql = sql + ' name like \'A%\' or name like \'a%\'';   
     }   
     
     if(list2.contains('B')){
        System.debug('Inside B'); 
        // sql = sql + ' name like \'A%\' or name like \'B%\' or name like \'C%\' or name like \'D%\' or name like \'E%\' or name like \'a%\' or name like \'b%\' or name like \'c%\' or name like \'d%\' or name like \'e%\' ';     
           sql = sql + ' name like \'B%\' or name like \'b%\'';   
     }  
     
     if(list2.contains('C-E')){
        System.debug('Inside C-E'); 
        // sql = sql + ' name like \'A%\' or name like \'B%\' or name like \'C%\' or name like \'D%\' or name like \'E%\' or name like \'a%\' or name like \'b%\' or name like \'c%\' or name like \'d%\' or name like \'e%\' ';     
           sql = sql + ' name like \'C%\' or name like \'D%\' or name like \'E%\' or name like \'c%\' or name like \'d%\' or name like \'e%\' ';   
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
    }
    catch(exception e){
     }  
   }
 
  public List<SelectOption> getvalues() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('A','AirCraft A'));
            options.add(new SelectOption('B','AirCraft B'));
            options.add(new SelectOption('C-E','AirCraft C-E'));
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
     String SolutionId=ID1;
     Pagereference p = new Pagereference('/'+ID1);
     p.setredirect(true);
     return p;
    }  
  
  public void ok(){
   List<String> str = new List<String>();
      if(selvalues!= null){
   
  //  System.debug(selvalues.size());
       for(String s1 : selvalues){
          selvalues1.add(s1);
       }
      } 
    System.debug(selvalues1.size());   
  
 } 
  public PageReference doSave(){
      system.debug('@@@@@@@@@@@@@@@'+s.Supported_Product__c);
      String SolutionId=ID1;
      system.debug('###########'+solutionId);
      system.debug('*******************'+ SolutionId);

      system.debug('!!!!!!!!!!!!!!'+SolutionId);
      system.debug('S.ID'+s.ID);
      s.Recordtypeid=rec;
      
      try{
      system.debug('Current Approver : '+ s.Current_Approver__c);
      update s;
      }catch(Exception e){
           ApexPages.addMessages(e);
          return null;
        }
      if(selvalues1 != null) {
         for(String s1 : selvalues1){
             Solution_Aircraft__c sol= new Solution_Aircraft__c(solution__c=ID1,AirCraft_Type__c= s1);
             insert sol;       
             system.debug('$$$$$$$$$$'+ sol);
            } 
           } 
      system.debug('MMMMMMMMMMsolutionid'+ SolutionId);
      system.debug('OOOOOOOOOOsid'+ s.Id);
      Pagereference p = new Pagereference('/'+ID1);
      p.setredirect(true);
      return p;
  } 
  
   public PageReference doSaveandNew(){
      system.debug('@@@@@@@@@@@@@@@'+s.Supported_Product__c);
      String SolutionId=s.ID;
      system.debug('!!!!!!!!!!!!!!'+SolutionId);
      system.debug('S.ID'+s.ID);
      try{
      update s;
      }catch(Exception e){
          ApexPages.addMessages(e);
         return null;
        }
          
      if(selvalues != null) {
         for(String s1 : selvalues1){
             Solution_Aircraft__c sol= new Solution_Aircraft__c(solution__c=ID1,AirCraft_Type__c= s1);
             insert sol;       
             system.debug('$$$$$$$$$$'+ sol);
            } 
           }
      Pagereference p = new Pagereference('/apex/Solution_VF');
      p.setredirect(true);
      return p;
  }
  public PageReference getSupportedProduct(){
       System.debug('getSol().Supported_Products__c======= '+getSol().Supported_Products__c);
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