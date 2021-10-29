Public class ATROpp_ContentDeliveries_Automation
{
  public static Boolean donealready= false;
 public static string doNotRun;
   public ATROpp_ContentDeliveries_Automation()
   {
     
   }
  public static void CreateContentDeliveries(List<Opportunity>newopp, Map<id,Opportunity> oldopp, Datetime createdate, set<id>conentid,map<id,set<id>>exmap)
   {
    //donealready=true;
    set<contentversion>finalllist= new set<contentversion>();
    list<Content_Delivery__c> createcdlink= new list<Content_Delivery__c>();
     list<contentversion> AllATRContent= new list<contentversion>();
     map<id,map<string,set<contentversion>>>countmap= new map<id,map<string,set<contentversion>>>();
     map<id,map<contentversion,integer>>oppnamematchcount= new map<id,map<contentversion,integer>>();
     map<id,set<contentversion>>bothmatch= new map<id,set<contentversion>>();
    list<Opportunity> opp=newopp;
    map<id,Opportunity> oppmap= new map<id,Opportunity>();
   if(oldopp!= null)
       oppmap=oldopp;
  if(createdate==Null)
    AllATRContent=[select id,Title,ContentDocumentId,tagcsv,SBU__c from contentversion where sbu__c='ATR' and IsLatest=true];
  else if(createdate!=Null)
    AllATRContent=[select id,Title,ContentDocumentId,tagcsv,SBU__c from contentversion where sbu__c='ATR' and IsLatest=true and lastModifiedDate >:createdate  and ContentDocumentId NOT IN: conentid];
  for(Opportunity o: opp)
   { 

     if(o.SBU__c=='ATR' && (o.Related_Content_count__c<5 || createdate!=Null)){
     list<string> productname=new list<string>(); 
        list<string> platformname=new list<string>();
     for(contentversion cv: AllATRContent)
     { 
       if(exmap==null || (exmap.containskey(o.id) && (!exmap.get(o.id).contains(cv.ContentDocumentId))) || (!exmap.containskey(o.id)))
       {
       if(cv.tagcsv!='' && cv.tagcsv!=null){
        set<contentversion> tempid= new set<contentversion>();
        map<string,set<contentversion>>tempstringmap= new map<string,set<contentversion>>();
        if(countmap.containskey(o.id))
          tempstringmap=countmap.get(o.id);
       system.debug('oppmap.get(o.id)**********'+oppmap.get(o.id));
       system.debug('o.Campaign_Name__c**********'+o.Campaign_Name__c); 
       system.debug('CPUTime-->' +Limits.getCPUTime()); 
       if(Limits.getCPUTime() > 40000){
           break;
       } 
       if((oppmap.get(o.id)!=Null && oppmap.get(o.id).Campaign_Name__c !=o.Campaign_Name__c && o.Campaign_Name__c!='' && o.Campaign_Name__c!=Null )|| 
          (oppmap.get(o.id)==Null && o.Campaign_Name__c!='' && o.Campaign_Name__c!=Null))
       {
         system.debug('Inside campaign Change'+cv.tagcsv);
         system.debug('Inside campaign Change111'+o.Campaign_Name__c);
         if(cv.tagcsv.contains(o.Campaign_Name__c))
         {
           system.debug('cv.tagcsv.contains(o.Campaign_Name__c)******'+cv.tagcsv.contains(o.Campaign_Name__c));
           set<contentversion>campaignid= new set<contentversion>();
           tempid.add(cv);
           if(tempstringmap.containskey('Campaign'))
             campaignid=tempstringmap.get('Campaign');
           campaignid.add(cv);
           tempstringmap.put('Campaign',campaignid);
           system.debug('tempstringmap********'+tempstringmap);
         }
       }
       if((oppmap.get(o.id)!=Null && oppmap.get(o.id).Name !=o.Name) || (oppmap.get(o.id)==Null && o.Name!='' && o.Name!=Null))
       {
         list<string>name= new list<string>();
         map<contentversion,integer>namecount= new map<contentversion,integer>();
         if(o.name!='' && o.name!=null)
         {
           string temp= o.name.replaceall('and','');  
            temp=temp.replaceAll('or', '');
           name=temp.split(' ', -2);
         }  
         
          if(oppnamematchcount.containskey(o.id))
            namecount=oppnamematchcount.get(o.id);
                // system.debug('tempstringmap.get(Campaign).size()********'+tempstringmap.get('Campaign').size());
                for(string n:name){
         if(cv.TagCsv.contains(n))
         {
           //if(tempstringmap.get('Campaign')==Null || tempstringmap.get('Campaign').size()<5){
           system.debug('nnnnnnnnnnnnnnnn'+n);
           system.debug('cv.TagCsv*********'+cv.id);
           if(!tempid.contains(cv))
           {
              set<contentversion>nameid= new set<contentversion>();
             //tempid.add(cv);
              if(tempstringmap.containskey('Name'))
               nameid=tempstringmap.get('Name');
              nameid.add(cv);
             tempstringmap.put('Name',nameid);
             if(namecount.containskey(cv))
             {
               namecount.put(cv,namecount.get(cv)+1);
               system.debug('inside if**********+++');
             }
             else
               namecount.put(cv,1);
           }
           else
             {
             system.debug('cv@@@@@@@@@@@@@@@@@@@'+cv.Title);
             if(tempid.contains(cv) && tempstringmap.get('Campaign').contains(cv))
             {
                set<contentversion>both= new set<contentversion>();
                if(bothmatch.containskey(o.id))
                 both=bothmatch.get(o.id);
                both.add(cv);
               bothmatch.put(o.id,both);
             }
            system.debug('bothmatch***********'+bothmatch);  
           }  
          //}  
          }
               }
                tempid.addall(namecount.keyset());
                system.debug('namecount***********'+namecount);
         oppnamematchcount.put(o.id,namecount);
       }
       if(tempstringmap.size()<5)
       {
         if((oppmap.get(o.id)!=Null && oppmap.get(o.id).Content_Product_Name__c !=o.Content_Product_Name__c && o.Content_Product_Name__c!='' && o.Content_Product_Name__c!=Null) || 
            (oppmap.get(o.id)==Null && o.Content_Product_Name__c!='' && o.Content_Product_Name__c!=Null))
         {
           list<string> productnamelist=new list<string>();
           productnamelist=((o.Content_Product_Name__c).split(', ',-2));
             for(string s: productnamelist)
                    {
             if(cv.tagcsv.contains(s))
               {
               set<contentversion>productid= new set<contentversion>();
               tempid.add(cv);
               if(tempstringmap.containskey('Product'))
                 productid=tempstringmap.get('Product');
               productid.add(cv);
               tempstringmap.put('Product',productid);
               system.debug('tempstringmap********'+tempstringmap);
               }
                   }
         }
       if((oppmap.get(o.id)!=Null && oppmap.get(o.id).Content_Platform_Name__c !=o.Content_Platform_Name__c && o.Content_Platform_Name__c!='' && o.Content_Platform_Name__c!=Null) || 
          (oppmap.get(o.id)==Null && o.Content_Platform_Name__c!='' && o.Content_Platform_Name__c!=Null))
         {
           list<string> platformnamelist=new list<string>();
           platformnamelist=((o.Content_Platform_Name__c).split(', ',-2));
             for(string s: platformnamelist)
                    {
             if(cv.tagcsv.contains(s))
               {
               set<contentversion>productid= new set<contentversion>();
               tempid.add(cv);
               if(tempstringmap.containskey('Platform'))
                 productid=tempstringmap.get('Platform');
               productid.add(cv);
               tempstringmap.put('Platform',productid);
               system.debug('tempstringmap********'+tempstringmap);
               }
                   }
         }
       }
         if(tempstringmap!=null)
       countmap.put(o.id,tempstringmap);
     }
     }
     }
    if(countmap.get(o.id)!=Null && (!countmap.get(o.id).isEmpty()))
    {
       system.debug('countmap.get(o.id)************'+countmap.get(o.id));
       system.debug('countmap.get(o.id)).get(Campaign)************'+countmap.get(o.id).get('Campaign'));
       Integer tSize=integer.valueOf(o.Related_Content_count__c);
       if(countmap.get(o.id).get('Campaign')!=null)
          tSize = tSize+(countmap.get(o.id)).get('Campaign').size();
       if(tSize<5)
       {
          system.debug('tsize************'+tSize);
         if((countmap.get(o.id)).get('Name')!=null)
         tSize=tSize+(countmap.get(o.id)).get('Name').size();
         if(tSize<5)
         {
           
           if(countmap.get(o.id).get('Campaign')!=Null)
             finalllist=countmap.get(o.id).get('Campaign');
           if(countmap.get(o.id).get('Name')!=Null)
             finalllist.addall(countmap.get(o.id).get('Name'));
           if(countmap.get(o.id).get('Product')!=Null)
             tSize=tSize+(countmap.get(o.id)).get('Product').size();
           if(countmap.get(o.id).get('Platform')!=Null)
             tSize=tSize+(countmap.get(o.id)).get('Platform').size();
           if(tSize<5)
           {
             if(countmap.get(o.id).get('Product')!=Null)
             finalllist.addall(countmap.get(o.id).get('Product'));
             if(countmap.get(o.id).get('Platform')!=Null)
             finalllist.addall(countmap.get(o.id).get('Platform'));
           }
           else
           {
             list<contentversion>productlist= new list<contentversion>();
             list<contentversion>platlist= new list<contentversion>();
             if(countmap.get(o.id).get('Product')!=Null)
               productlist.addall(countmap.get(o.id).get('Product'));
             if(countmap.get(o.id).get('Platform')!=Null)
               platlist.addall(countmap.get(o.id).get('Platform'));
             integer j=0;
             integer k=0;
             for(integer i=0;(finalllist.size()+o.Related_Content_count__c)<5;)
               {
                if(productlist.size()>j)
                {
                  if(!finalllist.contains(productlist[j]))
                  {
                      finalllist.add(productlist[j]);
                      i++;
                      j++;
                  }
                }
                if(platlist.size()>k && i<=5)
                {
                  if(!finalllist.contains(platlist[k]))
                  {
                     finalllist.add(platlist[k]);
                       i++;
                       k++;
                  }
                  
                }
               }
           }
           
           system.debug('ffffffffffffffffff'+finalllist);
         }
         else
         {
           if(countmap.get(o.id).get('Campaign')!=null)
           finalllist=countmap.get(o.id).get('Campaign');
           system.debug('oppnamematchcount**************'+oppnamematchcount);
           for(integer i=0;(finalllist.size()+o.Related_Content_count__c)<5;i++)
           {
             system.debug('(countmap.get(o.id)).get(Campaign).size()**'+i);
             contentversion largematch;
             map<contentversion,integer>countmaps=oppnamematchcount.get(o.id);
             system.debug('countmaps********'+countmaps);
             for(contentversion cvid:countmaps.keyset())
             {
               system.debug('inside for***************'+cvid);
             if(!finalllist.contains(cvid))
             {
               system.debug('inside if***************');
              if(largematch==null)
              {
               largematch=new contentversion();
               largematch=cvid;
              }
              else if(countmaps.get(cvid)>countmaps.get(largematch))
              {
               system.debug('countmaps.get(largematch)*******'+countmaps.get(largematch));
               largematch=cvid;
              }
              system.debug('largematch1111**********'+largematch);
             }
              }
             system.debug('largematch**********'+largematch);
          finalllist.add(largematch);
      
           }
           
           system.debug('ffffffffffffffffff'+finalllist);
           system.debug('wwwwwwwwwwww'+finalllist.size());
         }
       }
       else
       {
         if(bothmatch.get(o.id)!=null)
           finalllist=bothmatch.get(o.id);
           system.debug('finalllist************'+finalllist);
         list<contentversion>templist= new list<contentversion>();
         set<contentversion>tempset= new set<contentversion>();
         tempset=countmap.get(o.id).get('Campaign');
         system.debug('templist@@@@@@@@@@@@'+tempset);
         system.debug('finalllist@@@@@@@@@@@@'+tempset.size());
         tempset.removeall(finalllist);
         templist.addall(tempset);
         system.debug('finalllist%%%%%%%%%%%%%%'+templist.size());
         for(integer i=0;(finalllist.size()+o.Related_Content_count__c)<5;i++)
         {
               finalllist.add(templist[i]);
         }
       }
       system.debug('msize************'+tSize);
       }
       for(contentversion cv: finalllist)
       {
         system.debug('cv.Title*********'+cv.Title);
          Content_Delivery__c cd= new Content_Delivery__c();
             //cd.Name=c.Title;
             cd.Opportunity__c=o.id;
             cd.Content_Name__c=cv.Title;
             cd.ID_Value__c=cv.ContentDocumentId;
             createcdlink.add(cd);
             donealready=true;
       }
    }
  
  }
    if(createcdlink.size()>0)
     insert createcdlink;
  }
}