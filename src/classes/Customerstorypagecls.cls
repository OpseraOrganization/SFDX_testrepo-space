public with sharing class Customerstorypagecls {

    private final CustomerStory__c Lead;
    List<String> stringList =new List<String>();
    List<Customer_story_usage_tracking__c> ProductList1=new List<Customer_story_usage_tracking__c>(); 
    List<Customer_story_usage_tracking__c> ProductList2=new List<Customer_story_usage_tracking__c>();
    public String  uid; 
    public String  oldurl; 
    Public id newid;
    Public String keyCode;
    public List<String> lstUrls=new List<String>();
    
    public Customerstorypagecls(ApexPages.StandardController stdController) {
     this.Lead= (CustomerStory__c) stdController.getRecord();
     uid =Userinfo.getuserid();
     oldurl = ApexPages.currentPage().getHeaders().get('Referer');  
     if (oldurl != null)
     {
       lstUrls.addAll(oldurl.split('/')); 
       }
       }
    
     public PageReference loadEvent() {       
        String strLeadId  = this.Lead.Id;        
        List<CustomerStory__c> cus = [select Id,Summary__c,Solutions__c,Files_Links_1__c,Files_Links_2__c, Name from CustomerStory__c where Id = :strLeadId ];       
        stringList.clear();
        Integer i=lstUrls.size();
        if (lstUrls.size() > 1)
         {
         String keyCode  = lstUrls[i-1];
         }
         system.debug('&&&&'+keyCode);
         Try{
         newid= [select id from opportunity where id =:keyCode].id;
         system.debug('&&&&'+newid);
         }
          catch (exception e){
          //apexpages.addMessages(e);
          }
          for(Integer k=0;k<cus.size();k++)
          {
           stringList.add(cus[k].id);                  
          }        
          if(cus.Size()>0)
            {              
             for (CustomerStory__c child : cus) 
             {              
              // List<Customer_story_usage_tracking__c> c=[select id,name,LastModifiedDate,CustomerStory__c,UserName__c,IsRead__c from Customer_story_usage_tracking__c where CustomerStory__c =:child.id and UserName__c=:uid];
               //system.debug('test5--->'+c);
                
                 // if(c.Size()<=0 )
                  // {
                       Customer_story_usage_tracking__c p=new Customer_story_usage_tracking__c();                  
                       p.name=child.name;                                 
                       p.CustomerStory__c=child.id;
                       p.UserName__c=uid;
                       p.IsRead__c =true;
                       //p.oldpage__c = oldurl;
                       p.Opportunity_Reference__c = newid;
                       ProductList1.add(p);
                         
                   // } 
                   // else
                   //{
                    // for(Customer_story_usage_tracking__c c1:c)
                    // {
                   //   c1.Last_ModifiedDate__c=system.today();
                      //ProductList2.add(c1);  
                    // }
                   // }
                }
                } 
                system.debug('test5--->'+ProductList1.Size());
              if(ProductList1.Size()>0)
              Try{
          insert ProductList1;
         
         }
          catch (exception e){
          //apexpages.addMessages(e);
          }
           
            if(ProductList2.Size()>0)
           
             update ProductList2;                     
            return null;   
        }
}