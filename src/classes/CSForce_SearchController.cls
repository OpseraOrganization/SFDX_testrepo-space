public with sharing class CSForce_SearchController {

  public List <CustomerStory__c> CSStories          {get; set;}
  public CustomerStory__c csSearch                  {get; set;}
  public List <CSForce_SearchHelper> csHelperList   {get; set;}
  public String tSearch                             {get; set;}
  public list <Selectoption>  productsSelect        {get; set;}
  public String productSelected                     {get; set;}
  public list <Selectoption>  competitorsSelect     {get; set;}
  public String competitorSelected                  {get; set;}
  public String  listLink                           {get; set;}
  
  
  //setup in constructor. Used if 'All' is selected
  private String allProducts;
  private String allCompetitors;
  
  //search values
  public String storyType;
  public String title;
  public String salesRef;
  public String sharingRes;
  public String product;
  public String competitor;
  public String makeVar;
  public String modelVar;
  public String custVar;
  
  public CSForce_SearchController(){
    setupListLink();
    csSearch = new CustomerStory__c();
 //   setProductsFieldInfo();
    setCompetitorsFieldInfo();
  }

  private void setupListlink(){
    Schema.Describesobjectresult r = CustomerStory__c.sObjectType.getDescribe();
    String keyPref = r.getKeyPrefix();
    listLink = '/'+keyPref+'/o';
  }

  private void setCompetitorsFieldInfo(){
    Schema.DescribeFieldResult F = CustomerStory__c.Win_Against__c.getDescribe();
    list <Schema.PicklistEntry> plSchemaList = F.getPicklistValues();
    
    competitorsSelect = new list<Selectoption>();
    competitorsSelect.add(new Selectoption('All', 'All'));
    allCompetitors = '';
    
    for (Schema.Picklistentry ple : plSchemaList){
      competitorsSelect.add(new Selectoption(ple.getValue(), ple.getValue()));
      allCompetitors += ple.getValue()+';';
    }
  }
  public void doSearch(){
    setupSearchFields();
    
    if(tSearch != null && tSearch.length()>2){
       system.debug('11111111'+tSearch);
     CSStories = soslSearch();
      }
    else
    CSStories =  soqlSearch();
    system.debug('CSStories '+CSStories );
    csHelperList = new List<CSForce_SearchHelper>();
    if(CSStories != null){
    
        for(CustomerStory__c cs : CSStories){
        system.debug('win' + cs.Win_Again__c);
       system.debug('win' + cs.Products__c);
        csHelperList.add(new CSForce_SearchHelper(cs));
      }
    }
  }
    
  private List <CustomerStory__c> soslSearch(){
    
     String strCondition = '';
     
     if (storyType!= null && strCondition == '')
     strCondition += 'Story_Type__c =\''+ storyType+ '\'';
     else if (storyType!= null && strCondition != '')
     strCondition += 'Story_Type__c=\''+ storyType+ '\'';
     
     if (salesRef!= null && strCondition == '')
     strCondition += 'Sales_Reference__c =\''+ salesRef+ '\'';
     else if (salesRef!= null && strCondition != '')
     strCondition += ' and  Sales_Reference__c=\''+ salesRef+ '\'';
     
  
     if (sharingRes!= null && strCondition == '')
     strCondition += 'Sharing_Restriction__c =\''+ sharingRes+ '\'';
     else if (sharingRes!= null && strCondition != '')
     strCondition += ' and  Sharing_Restriction__c=\''+ sharingRes+ '\'';
     
     system.debug('test make'+csSearch.Make__c);
     //Integer mk=makeVar.length();
     if (makeVar!='' && strCondition == '')
     {
      system.debug('test make condtion');
     strCondition += 'Make__c like \'%'+ csSearch.Make__c+ '%\'';
     }
     else if (makeVar!=''&& strCondition != '')
     {
     strCondition += ' and Make__c like \''+ csSearch.Make__c+ '%\'';
     }
     
     system.debug('test model'+modelVar);
     //Integer mod=modelVar.length();
     if (modelVar!='' && strCondition == '')
     strCondition += 'Model__c like \'%'+ modelVar+ '%\'';
     else if (modelVar!=''  && strCondition != '')
     strCondition += ' and  Model__c like \''+ modelVar+ '%\'';

     system.debug('MMMMMMM'+product);
     
     if(product != null && strCondition == ''){
        product = product.substring(0,15);
        strCondition += 'Product__c =\''+ product+ '\'';
        system.debug('Test product '+product);
    }
    else if(product != null && strCondition != '')
    {
        product = product.substring(0,15);
        system.debug('Test product1 '+product);
        strCondition += ' and  Product__c =\''+ product+ '\'';
    }
     
     system.debug('test customer'+custVar);
     
     //Integer cus=custVar.length();
     if (custVar!=''&& strCondition == '')
     strCondition += 'Customer__c like \'%'+ custVar+ '%\'';
     else if (custVar!=''  && strCondition != '')
     strCondition += ' and  Customer__c like \''+ custVar+ '%\'';     
     system.debug('test111'+strCondition);
    
    
    
  String  strCondition1 = 'Find :tSearch IN ALL Fields ';
    strCondition1 += 'RETURNING CustomerStory__c ';
    strCondition1 += '(Name, Id, Synopsis__c, Product__c ,Product_Name__c ,Story_Type__c, Win_Again__c, Win_Against__c,Make__c,Model__c,Customer__c, ';
    strCondition1 += 'Sales_Reference__c, Sharing_Restriction__c, Products__c, Status__c, ';
    strCondition1 += 'callRef__c, sharingR__c ';
    if(strCondition !='')
     strCondition1 += ' WHERE '; 
     
     system.debug('test111'+strCondition);
     String queryString;
     if(strCondition == '')
     queryString = strCondition1 +') limit 150'; 
     else
    queryString = strCondition1 + strCondition +') limit 150'; 
  system.debug('BBBBBBBB'+queryString);
     
    LIST<LIST<SObject>> soList = search.query(queryString );
    system.debug('BBBBBBBB'+tSearch);
    system.debug('CCCCCCCC'+soList);
   // CSStories = soList[0];
    system.debug('DDDDDDDD'+CSStories);
    return soList[0];
    
  }
  
  private List <CustomerStory__c> soqlSearch(){
  
     String strCondition = '';
     if (storyType!= null && strCondition == '')
     strCondition += 'Story_Type__c =\''+ storyType+ '\'';
     else if (storyType!= null && strCondition != '')
     strCondition += ' and  Story_Type__c=\''+ storyType+ '\'';
     
     if (salesRef!= null && strCondition == '')
     strCondition += 'Sales_Reference__c =\''+ salesRef+ '\'';
     else if (salesRef!= null && strCondition != '')
     strCondition += ' and  Sales_Reference__c=\''+ salesRef+ '\'';
     
     if (sharingRes!= null && strCondition == '')
     strCondition += 'Sharing_Restriction__c =\''+ sharingRes+ '\'';
     else if (sharingRes!= null && strCondition != '')
     strCondition += ' and  Sharing_Restriction__c=\''+ sharingRes+ '\'';
     
     if (sharingRes!= null && strCondition == '')
     strCondition += 'Sharing_Restriction__c =\''+ sharingRes+ '\'';
     else if (sharingRes!= null && strCondition != '')
     strCondition += ' and  Sharing_Restriction__c=\''+ sharingRes+ '\'';
     
     system.debug('test make'+csSearch.Make__c);
     //Integer mk=makeVar.length();
     if (makeVar!='' && strCondition == '')
     {
      system.debug('test make condtion');
     strCondition += 'Make__c like \'%'+ csSearch.Make__c+ '%\'';
     }
     else if (makeVar!=''&& strCondition != '')
     {
     strCondition += ' and  Make__c like \''+ csSearch.Make__c+ '%\'';
     }
     
     system.debug('test model'+modelVar);
     //Integer mod=modelVar.length();
     if (modelVar!='' && strCondition == '')
     strCondition += 'Model__c like \'%'+ modelVar+ '%\'';
     else if (modelVar!=''  && strCondition != '')
     strCondition += ' and  Model__c like \''+ modelVar+ '%\'';

     system.debug('MMMMMMM'+product);
     
     if(product != null && strCondition == ''){
        product = product.substring(0,15);
        strCondition += 'Product__c =\''+ product+ '\'';
        system.debug('Test product '+product);
    }
    else if(product != null && strCondition != '')
    {
        product = product.substring(0,15);
        system.debug('Test product1 '+product);
        strCondition += ' and  Product__c =\''+ product+ '\'';
    }
     
     system.debug('test customer'+custVar);
     
     //Integer cus=custVar.length();
     if (custVar!='' && strCondition == '')
     strCondition += 'Customer__c like \'%'+ custVar+ '%\'';  
     else if (custVar!=''  && strCondition != '')
     strCondition += ' and  Customer__c like \''+ custVar+ '%\'';   
      
    system.debug('test111'+strCondition);
     
    
    String strQuery = '';
   
    strQuery = 'select Name, Id, Synopsis__c, Story_Type__c,Product__c,Product_Name__c, Win_Again__c, Win_Against__c,Make__c,Model__c,Customer__c, Sales_Reference__c, Sharing_Restriction__c, Products__c, Status__c, callRef__c, sharingR__c from CustomerStory__c ';
     if(strCondition != '')
     strQuery +=' where '+strCondition+' limit 500';
    
    system.debug('test222'+strQuery);
   // CSStories = Database.query(strQuery);
    system.debug('CCCCCCCC'+CSStories);
    
    return Database.query(strQuery);
  }
  
  private void setupSearchFields(){
    if(csSearch.Story_Type__c != null)
     storyType = csSearch.Story_Type__c;
    else
     storyType = null;
    
    if(csSearch.Name != null)
     title = '%'+csSearch.Name+'%';
    else 
     title ='%';
    
    if(csSearch.Sales_Reference__c == null)
     salesRef = null;
    else
     salesRef = csSearch.Sales_Reference__c;
     
    if(csSearch.Sharing_Restriction__c == null)
     sharingRes = null;
    else sharingRes = csSearch.Sharing_Restriction__c;
    
    if(csSearch.Make__c == null)
     makeVar = null;
    else makeVar = csSearch.Make__c;
    
    if(csSearch.Model__c == null)
     modelVar = null;
    else modelVar = csSearch.Model__c;
    
    if(csSearch.Customer__c == null)
     custVar = null;
    else custVar = csSearch.Customer__c;
      
    if(csSearch.Product__c == null)
     product = null;
    else
     product = csSearch.Product__c;
     system.debug('MMMMMMM'+product);
      
    if(csSearch.Win_Again__c == null)
      competitor = null;
    else 
      competitor = csSearch.Win_Again__c;
  }
}