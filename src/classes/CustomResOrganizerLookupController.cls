public with sharing class CustomResOrganizerLookupController {

    transient public List<Contact> results { get; set; }
    public string domainemail;
    public string domainemail1;
    //public String  uid = '005e0000000wIrFAAU';
    public String  uid = Userinfo.getuserid();
    public String stremail;
    public String searchString { get; set; }    
    public integer recordCount;
    public integer recordLimit;
    public integer offsetLimit;    
    public integer indexCount;
    public boolean enablePrevious{get;set;}
    public boolean enableNext{get;set;}
    
    public CustomResOrganizerLookupController()
    {
        recordLimit = 10;
        offsetLimit = 0;              
        indexCount = 10;
        enableNext= true;
        
        user use=[select id,Batch_User__c ,ProfileId,name,ContactId from user where id=:uid ];         
        contact c=[select id,name,email from contact where id=:use.ContactId];
        stremail=c.email;
        domainemail1=stremail.substring(stremail.indexof('@')+1,stremail.length()); 
        domainemail='%'+domainemail1+'%';
                
        if( domainemail!=null || domainemail!='' )
            recordCount = [select count() from contact where email LIKE :domainemail limit 10000];
        if(recordCount<=indexCount)    
            enableNext = false;        
        enablePrevious = false;
        runSearch();        
    }
    
    // Pagination    
    public PageReference next()
    {
        offsetLimit += 10;
        indexCount += 10;
        
        if(indexCount>10)
            enablePrevious = true;
                    
        if(indexCount + 10>=recordCount)
            enableNext= false;
        runSearch();
        return null;
    }    
    public PageReference previous()
    {
        offsetLimit -= 10;
        indexCount -= 10;
        if(indexCount <=10)
            enablePrevious = false;
            
        enableNext = true;
        runSearch();
        return null;
    }
    //End Pagination     
    // performs the keyword search
    public PageReference Search() 
    {
        indexCount = 10;
        enablePrevious = false;
        offsetLimit = 10;        
        user use=[select id,Batch_User__c ,ProfileId,name,ContactId from user where id=:uid ];                        
        String soql = 'select id from contact';
        if(searchString != '' && searchString != null)
        {
          soql = soql + ' where name LIKE \'%' + searchString +'%\' and email LIKE \'%' + domainemail+'%\'';              
        }
        else
        {
           soql = soql + ' where email LIKE \'%' + domainemail+'%\'' + 'limit 10000';           
        }           
        List<Contact> connts = database.query(soql);       
        recordCount = connts.size();
        enablePrevious = false;
        enableNext = true;            
        if(recordCount<=indexCount)
            enableNext =false;             
        runSearch();        
        return null;                         
    }
    private void runSearch() {
      results = performSearch(searchString);
    }  
    private List<contact> performSearch(string searchString) 
    {
        user use=[select id,Batch_User__c ,ProfileId,name,ContactId from user where id=:uid ];         
        contact c=[select id,name,email from contact where id=:use.ContactId];
        stremail=c.email;
        domainemail=stremail.substring(stremail.indexof('@')+1,stremail.length()); 
       
        String soql = 'select id, name,email,Contact_Status__c,Accountid,Title,Phone_1__c,Primary_Email_Address__c,City_Name__c,State_Code__c,Country_Name__c from contact';
        if(searchString != '' && searchString != null)
        {
            soql = soql + ' where name LIKE \'%' + searchString +'%\' and email LIKE \'%' + domainemail+'%\'';     
            soql = soql + ' limit ' + recordLimit + ' OFFSET ' + offsetLimit ;
        }
        else
        {
            soql = soql + ' where email LIKE \'%' + domainemail+'%\'';
            soql = soql + ' limit ' + recordLimit + ' OFFSET ' + offsetLimit ;
        }       
            System.debug(soql);
            return database.query(soql);
    }
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }  
    
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    } 
}