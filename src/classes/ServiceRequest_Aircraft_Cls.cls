public class ServiceRequest_Aircraft_Cls {
public static void ccMethod(){
    
    Integer i = 0;
    i++;
    }
/* this is replaced with new class "AddmultipleAircraftsController"
public List<Platform__c> list1= new List<Platform__c>();  
public List<SelectOption> optionssol;
public List<String> selvalues1 = new List<String>();
String id1;

    public ServiceRequest_Aircraft_Cls(ApexPages.StandardController controller) {
    id1 = Apexpages.currentPage().getParameters().get('id');

    }
public String list2{get;set;}
public List<String> selvalues {get;set;} 

 public List<SelectOption> getvalues() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('A-E','AirCraft A-E'));
            options.add(new SelectOption('F-J','AirCraft F-J'));
            options.add(new SelectOption('K-O','AirCraft K-O'));
            options.add(new SelectOption('P-T','AirCraft P-T'));
            options.add(new SelectOption('U-Z','AirCraft U-Z'));
            return options;
        }
 
 public void navigate()
   { 
       
     String sql = 'select name from Platform__c';
     List<String> str1 = new List<String>();
     Set<String> myset = new Set<String>();   
     System.debug(list2);
     if(list2!=null)
        sql = sql + ' where ';
         
     try{
     if(list2.contains('A-E')){
        
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
     
     if(list2!= null)   
                    list1 = Database.query(sql);
                      }
           catch(exception e){
          } 
    }    
    public void ok(){
   List<String> str = new List<String>();
 
   if(selvalues != null){
     for(String s1 : selvalues){
        selvalues1.add(s1);
      }
     } 
    }
  
   public boolean getevallist(){
   if(list1.size() > 0)
     return true;
   else
     return false;
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
  
  public PageReference doSave(){
          
   /*  s.Recordtypeid=id1;
     try{
     insert s;
     system.debug('Current Approver : '+s.Current_approver__c);
    }catch(Exception e){
     ApexPages.addMessages(e);
     return null;
   }*/
   /*
         if(selvalues1 != null) {
              for(String s1 : selvalues1){
                 Aircraft_Platforms_Affected__c sol= new Aircraft_Platforms_Affected__c();
                 sol.Service_Request__c=id1;       
                 sol.Aircraft_Platforms_Affected__c=s1;
                 insert sol;
                } 
           } 
  
      Pagereference p = new Pagereference('/'+id1);
      p.setredirect(true);
      return p;
  } 
   public PageReference doSaveandNew(){
        
         if(selvalues1 != null) {
              for(String s1 : selvalues1){
                 Aircraft_Platforms_Affected__c sol= new Aircraft_Platforms_Affected__c();
                 sol.Service_Request__c=id1;       
                 sol.Aircraft_Platforms_Affected__c=s1;
                 insert sol;       
                                 } 
           }
       Pagereference p = new Pagereference('/apex/ServiceRequest_Aircraft_VF?id='+id1);
      p.setredirect(true);
      
      return p;
      
  }

public PageReference doCancel(){ 
     Pagereference p = new Pagereference('/'+id1);
     p.setredirect(true);
     return p;
    }*/       
}