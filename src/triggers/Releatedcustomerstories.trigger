trigger Releatedcustomerstories on OpportunityLineItem  (after insert) 
{ 
    if(AvoidRecursion.isFirstRun_Releatedcustomerstories()){
    Set<String> stringList =new Set<String>();
    List<String> stringList6 =new List<String>();
    List<String> stringList7 =new List<String>();
    List<String> stringList8 =new List<String>();
    List<String> stringList9 =new List<String>(); 
    set<id> oppid=new set<id>();   
    Set<id> csid=new Set<id>(); 
    List<Related_Customer_Stories__c> ProductList1=new List<Related_Customer_Stories__c>();  
    List<CustomerStory__c> customer=new List<CustomerStory__c>();
    for (OpportunityLineItem  t : Trigger.new) 
    {               
    if (trigger.isInsert && (t.opportunity.recordtypeid == '01230000000bN7l' ||t.opportunity.recordtypeid == '01230000000bN7k') || Test.isRunningTest())
    //if (trigger.isInsert || (trigger.is{pdate && trigger.oldmap.get(t.Product_Name__c) != trigger.newmap.get(t.Product_Name__c)))
   {
         
          Opportunity oppacc=[select AccountId,Make__c,Model__c from Opportunity where id=:t.OpportunityId];
          system.debug('oppacc'+oppacc.Make__c);
          
          account accopp=[SELECT Name FROM Account WHERE Id =:oppacc.AccountId];
          system.debug('accopp'+accopp.Name);
          List<product2> prod=[SELECT Id,Name FROM Product2 WHERE Name =:t.Product_Name__c limit 100];
          System.debug('@products'+prod);                  
          for(Integer j=0;j<prod.size();j++)
          {
           stringList9.add(prod[j].Name);
          }  
          System.debug('@String9'+stringList9); 
           System.debug('t.OpportunityId value:'+t.OpportunityId);
          List<CustomerStory__c> cus=[select Id,video_Link_mac__c,CustomerName__c,Customer__c,Make_Model__c,Product__c,Make__c,Product_Line__c,Summary__c,Solutions__c,Files_Links_1__c,Files_Links_2__c,Product_Name__c, Name from CustomerStory__c where Related_Opportunity__c !=: t.OpportunityId AND Related_Opportunity__c !=: NULL]; 
          System.debug('@@@Stories '+cus);
          for(CustomerStory__c cid:cus)
          {
           csid.add(cid.id);
          }  
          for(Integer k=0;k<cus.size();k++)
          {
           stringList.add(cus[k].id);                  
          }                 
           if(cus.Size()>0)
            {              
             List<Related_Customer_Stories__c> c=[select id,Product__c,CustomerName__c,Opportunity__c,name,CustomerStory__c,Solutions__c from Related_Customer_Stories__c where Opportunity__c=:t.OpportunityId];
            set<string> c1  = new set<string> {'a','b'};
             
             
             For (Related_Customer_Stories__c c2: c)
           {
             System.debug('Related Stories '+c2.CustomerStory__c);
            string c3 = c2.CustomerStory__c;
             if(c3 != null){
             c1.add(c3);}
             } 
                    String uid = Userinfo.getuserid();
                    User usr = [Select id,Name,Email from User where id =: uid];          
              for (CustomerStory__c child : cus) 
             {        
                string childid = child.id;                                                           
                    if(!usr.Name.contains('API USER') )
                    {
                  
                    if ((c.size()>0 && (!c1.contains(childid))) || c.size()==0 )
                    {
                        Related_Customer_Stories__c p=new Related_Customer_Stories__c();                  
                        for(integer u=0;u<stringList9.size();u++)
                            {                       
                               system.debug('child.Product_Name__c'+child.Product_Name__c);
                               system.debug('stringList9'+stringList9);
                                if(child.Product_Name__c != null && child.Product_Name__c==stringList9[u])
                                    {                                                           
                                       System.debug('@StringlistTest'+child);
                                        p.name=child.name;
                                        p.Summary__c=child.Summary__c;
                                        p.Files_Links_1__c=child.Files_Links_1__c;
                                        p.Files_Links_2__c=child.Files_Links_2__c;
                                        p.Solutions__c=child.Solutions__c;
                                        p.CustomerStory__c=child.id;
                                        p.Opportunity__c=t.OpportunityId;
                                        p.Product__c=child.Product__c;
                                        p.Product_Line__c=child.Product_Line__c;
                                        p.Make__c=child.Make__c;
                                        p.CustomerName__c=child.CustomerName__c;
                                        p.Reason__c='Product';
                                        p.video_Link_mac__c = child.video_Link_mac__c;                     
                                    }                   
                            }                                           
                        if(accopp.Name!= NULL)
                                {
                                    system.debug('child.Customer__c'+child.Customer__c);
                                   system.debug('accopp.Name'+accopp.Name);
                                    if(child.Customer__c != null && child.Customer__c==accopp.Name)
                                    {   
                                       system.debug('test123'+accopp.Name); 
                                       system.debug('test12345'+child.Customer__c);                                                       
                                        p.name=child.name;
                                        p.Summary__c=child.Summary__c;
                                        p.Files_Links_1__c=child.Files_Links_1__c;
                                        p.Files_Links_2__c=child.Files_Links_2__c;
                                        p.Solutions__c=child.Solutions__c;
                                        p.CustomerStory__c=child.id;
                                        p.Opportunity__c=t.OpportunityId;
                                        p.Product__c=child.Product__c;
                                        p.Product_Line__c=child.Product_Line__c;
                                        p.Make__c=child.Make__c;
                                        p.CustomerName__c=child.CustomerName__c;
                                        p.Reason__c='Customer';
                                        p.video_Link_mac__c = child.video_Link_mac__c;
                                     }                   
                                 }                        
                           if(oppacc.Make__c!=NULL)
                            {
                                    system.debug('child.Make_Model__c'+child.Make_Model__c);
                                   system.debug('oppacc.Make__c'+oppacc.Make__c);
                                    if(child.Make_Model__c != null && child.Make_Model__c==oppacc.Make__c)
                                {                                                                                                
                                    p.name=child.name;
                                    p.Summary__c=child.Summary__c;
                                    p.Files_Links_1__c=child.Files_Links_1__c;
                                    p.Files_Links_2__c=child.Files_Links_2__c;
                                    p.Solutions__c=child.Solutions__c;
                                    p.CustomerStory__c=child.id;
                                    p.Opportunity__c=t.OpportunityId;
                                    p.Product__c=child.Product__c;
                                    p.Product_Line__c=child.Product_Line__c;
                                    p.Make__c=child.Make__c;
                                    p.CustomerName__c=child.CustomerName__c;
                                    p.Reason__c='Make/Model';
                                    p.video_Link_mac__c = child.video_Link_mac__c;
                                 }                   
                             }
                      ProductList1.add(p);                 
                 }
               }  
              
             
              }
              }
              }
}

       insert ProductList1;
       }
}