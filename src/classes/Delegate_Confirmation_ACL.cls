//This class is used for managing the delegation

Public with sharing class Delegate_Confirmation_ACL
  {
     public Delegate_Confirmation_ACL(ApexPages.StandardController controller) 
        {
              
        }
        
     List<ID> Delid = new List<ID>(); 
     List<Approver__c> APPlist2 = new List<Approver__c>();   
     public string approvername{get; set;}
     public string delegatename{get; set;}
     public string delegate_bu{get; set;}
     
     Public List<MyInnerClass> myClassList{
         get{
             if(myClassList == null)
                 myClassList = new List<MyInnerClass>();
             return myClassList;
             }
         set;}
     
     Public class MyInnerClass{
                        
                        Public string Name1{get; set;}
                        Public string Title{get; set;}
                        Public string Email{get; set;}
                        Public string BU{get; set;}
     }
     
           
     public string approver_title{get; set;}
     
     
     public string delegate_Stdrevenue{get; set;}
     public string delegate_NonStdrevenue{get; set;}
     List<Approver__C> trial = new List<Approver__C>();



     public Boolean VarConf{ get; set; }
     {
        VarConf=False;
     }
     Approver__c APPlist= new Approver__c();
     Approver__c APPlist1= new Approver__c();
     
     id AppId = System.currentPageReference().getParameters().get('id');
     {
        APPlist = [select Delegate_Name1__c, Delegation_Valid_From1__c, Delegation_Valid_To1__c, Out_of_Office1__c, Approver_Name__c,Approver_Name__r.name,X5_Year_revenue__c,Title__c,Terms_and_Conditions__c,Ownerid,Delegate_Name_dummy__c,To__c,From__c,id, Out_of_Office__c, 
        Delegate_Name2__c, Delegation_Valid_From2__c, Delegation_Valid_To2__c, Out_of_Office2__c,
        Delegate_Name3__c, Delegation_Valid_From3__c, Delegation_Valid_To3__c, Out_of_Office3__c,
        Delegate_Name4__c, Delegation_Valid_From4__c, Delegation_Valid_To4__c, Out_of_Office4__c, Delegation_Required_From__c, Delegation_Required_To__c from Approver__c where id=:AppId];
        
        system.debug('APPLIST : '+Applist);
        
        approvername = APPlist.Approver_Name__r.name;
        if(APPlist.Terms_and_Conditions__c=='Standard')
          {
                 delegate_Stdrevenue=String.valueOf(APPlist.X5_Year_revenue__c);
                 delegate_NonStdrevenue='0';
           }
         if(APPlist.Terms_and_Conditions__c=='Non standard')
           {
                 delegate_NonStdrevenue=string.valueOf(APPlist.X5_Year_revenue__c); 
                 delegate_Stdrevenue='0';
           }
         approver_title=APPlist.Title__c;
      }
      
/********************************************* Checking for User privelege ************************************************/
      public Boolean VarConf1{ get; set; }
       {
           USER u=[select profile.name from user where id =: userinfo.getuserid()];
           string user1 = Userinfo.getuserid();
           string user2 = APPlist.Ownerid;
           if(user1==user2 || u.profile.name=='Honeywell System Administrator' || u.profile.name=='eGreensheet Approver Admin' || u.profile.name=='System Administrator')
           VarConf1=True;
           else
           {
              VarConf1=False;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot assign delegate for another approver'));
           }

       }
      public Approver__c getAPPlist1()
        {
           return APPlist1;
        }
        
      public void setAPPlist1(Approver__c APPlist1)
        {
           system.debug('APPLIST '+Applist1);
           this.APPlist1=APPlist1;
        }
       
         
       public pagereference Submit()
        {
               if(APPlist2.size()>0)
               update APPlist2;
               PageReference APPPage = new PageReference('/'+ AppId);
               return APPPage;
        }
        
/************************************************************** Cancel ******************************************/

        public pagereference Cancel()
         {
            PageReference APPPage = new PageReference('/'+ AppId);
            return APPPage;
         }

/*********************************************************** Confirm ***************************************************/

       public PageReference Confirm()
        {
              
                         
/****************************************** Validation Rules *****************************************************************/

          Set<Date> Fromdatelist = new Set<Date>();
          Fromdatelist.add(APPlist1.From__c);
          Fromdatelist.add(APPlist1.Delegation_Valid_From1__c);
          Fromdatelist.add(APPlist1.Delegation_Valid_From2__c);
          Fromdatelist.add(APPlist1.Delegation_Valid_From3__c);
          Fromdatelist.add(APPlist1.Delegation_Valid_From4__c);
          List<Date> fdl = new List<Date>();
          fdl.addAll(Fromdatelist);
          fdl.sort();
          system.debug('FDL BEFORE REMOVING :'+fdl);
          if(fdl[0] == null)
          fdl.remove(0);
          
          Set<Date> todatelist = new Set<Date>();
          Todatelist.add(APPlist1.To__c);
          Todatelist.add(APPlist1.Delegation_Valid_To1__c);
          Todatelist.add(APPlist1.Delegation_Valid_To2__c);
          Todatelist.add(APPlist1.Delegation_Valid_To3__c);
          Todatelist.add(APPlist1.Delegation_Valid_To4__c);
          List<Date> tdl = new List<Date>();
          tdl.addAll(Todatelist);
          tdl.sort();
          system.debug('TDL BEFORE REMOVING :'+tdl);
          if(tdl[0] == null)
          tdl.remove(0);
          
          
          
       /*   if((APPlist1.Out_of_Office__c) && (APPlist1.Delegation_Required_From__c == null || Applist1.Delegation_Required_To__c == null))
          {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the Delegation Time Period details'));
                  PageReference APPPage = new PageReference('/'+ AppId);
                  return null;
          }*/
          
          
          if((APPlist1.Out_of_Office__c) && (APPlist1.Delegate_Name_dummy__c != null && ( APPlist1.To__c== null || APPlist1.From__c== null))  )
           {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all the details'));
                   PageReference APPPage = new PageReference('/'+ AppId);
                   return null;
           }
           
          else if(APPlist1.Delegate_Name_dummy__c<> null  && (APPlist1.To__c<> null) && (APPlist1.From__c<> null)&& (!APPlist1.Out_of_Office__c))
          {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Delegate will not be assigned unless Activate Delegation is selected'));
               PageReference APPPage = new PageReference('/'+ AppId);
               return null;
          }
          
          if((APPlist1.Out_of_Office__c) && (APPlist1.Delegate_Name1__c != null && ( APPlist1.Delegation_Valid_To1__c== null || APPlist1.Delegation_Valid_From1__c== null))  )
           {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all the details for Delegate 1'));
                   PageReference APPPage = new PageReference('/'+ AppId);
                   return null;
           }
           
          else if(APPlist1.Delegate_Name1__c<> null  && (APPlist1.Delegation_Valid_To1__c<> null) && (APPlist1.Delegation_Valid_From1__c<> null)&& (!APPlist1.Out_of_Office__c))
          {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Delegate 1 will not be assigned unless Activate Delegation is selected'));
               PageReference APPPage = new PageReference('/'+ AppId);
               return null;
          }

          if((APPlist1.Out_of_Office__c) && (APPlist1.Delegate_Name2__c != null && ( APPlist1.Delegation_Valid_To2__c== null || APPlist1.Delegation_Valid_From2__c== null))  )
           {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all the details for Delegate 2'));
                   PageReference APPPage = new PageReference('/'+ AppId);
                   return null;
           }
           
          else if(APPlist1.Delegate_Name2__c<> null  && (APPlist1.Delegation_Valid_To2__c<> null) && (APPlist1.Delegation_Valid_From2__c<> null)&& (!APPlist1.Out_of_Office__c))
          {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Delegate 2 will not be assigned unless Activate Delegation is selected'));
               PageReference APPPage = new PageReference('/'+ AppId);
               return null;
          }
          
          if((APPlist1.Out_of_Office__c) && (APPlist1.Delegate_Name3__c != null && ( APPlist1.Delegation_Valid_To3__c== null || APPlist1.Delegation_Valid_From3__c== null))  )
           {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all the details for Delegate 3'));
                   PageReference APPPage = new PageReference('/'+ AppId);
                   return null;
           }
           
          else if(APPlist1.Delegate_Name3__c<> null  && (APPlist1.Delegation_Valid_To3__c<> null) && (APPlist1.Delegation_Valid_From3__c<> null)&& (!APPlist1.Out_of_Office__c))
          {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Delegate 3 will not be assigned unless Activate Delegation is selected'));
               PageReference APPPage = new PageReference('/'+ AppId);
               return null;
          }
          
          if((APPlist1.Out_of_Office__c) && (APPlist1.Delegate_Name4__c != null && ( APPlist1.Delegation_Valid_To4__c== null || APPlist1.Delegation_Valid_From4__c== null))  )
           {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter all the details for Delegate 4'));
                   PageReference APPPage = new PageReference('/'+ AppId);
                   return null;
           }
           
          else if(APPlist1.Delegate_Name4__c<> null  && (APPlist1.Delegation_Valid_To4__c<> null) && (APPlist1.Delegation_Valid_From4__c<> null)&& (!APPlist1.Out_of_Office__c))
          {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Delegate 4 will not be assigned unless Activate Delegation is selected'));
               PageReference APPPage = new PageReference('/'+ AppId);
               return null;
          }
          
          

          
/******************************************************* Remove Delegation ****************************************************/

          else if(!APPlist1.Out_of_Office__c) // && !APPlist1.Out_of_Office1__c && !APPlist1.Out_of_Office2__c && !APPlist1.Out_of_Office3__c && !APPlist1.Out_of_Office4__c)
          {     
                system.debug('iiiiiiiii'+APPlist1.Out_of_Office__c);
                system.debug('11iiiiiiiii'+APPlist1);
                list<Approver__c> APPlist3=[select Approver_Name__c, Delegate_Name__c,Approver_Name__r.name,Title__c,Delegate_Name_dummy__c,Delegate_Name_dummy__r.name,To__c,From__c,id,Out_of_Office__c,Delegate_Email__c,Delegate_Name1__c,Delegate_Name2__c,Delegate_Name3__c,Delegate_Name4__c,Delegation_Valid_From1__c,Delegation_Valid_From2__c,Delegation_Valid_From3__c,Delegation_Valid_From4__c,Delegation_Valid_To1__c,Delegation_Valid_To2__c,Delegation_Valid_To3__c,Delegation_Valid_To4__c,Delegate_Email_1__c,Delegate_Email_2__c,Delegate_Email_3__c,Delegate_Email_4__c, Delegate_Name_Text1__c, Delegate_Name_Text2__c, Delegate_Name_Text3__c, Delegate_Name_Text4__c from Approver__c where Approver_Name__r.name=:APPlist.Approver_Name__r.name];
                system.debug('GGGGGGGG'+APPlist3);            
                for(Approver__c APP1: APPlist3)
                   { 
                      
                      APP1.Delegation_Required_From__c = null;
                      APP1.Delegation_Required_To__c = null;
                      
                      APP1.Out_of_Office__c=APPlist1.Out_of_Office__c;
                      APP1.To__c=null;
                      APP1.From__c=null;
                      APP1.Delegate_Name__c='';
                      APP1.Delegate_Email__c='';
                      
                      APP1.Out_of_Office1__c=APPlist1.Out_of_Office__c;
                      APP1.Delegation_Valid_To1__c=null;
                      APP1.Delegation_Valid_From1__c=null;
                      APP1.Delegate_Name_Text1__c='';
                      APP1.Delegate_Email_1__c='';
                      
                      APP1.Out_of_Office2__c=APPlist1.Out_of_Office__c;
                      APP1.Delegation_Valid_To2__c=null;
                      APP1.Delegation_Valid_From2__c=null;
                      APP1.Delegate_Name_Text2__c='';
                      APP1.Delegate_Email_2__c='';
                      
                      APP1.Out_of_Office3__c=APPlist1.Out_of_Office__c;
                      APP1.Delegation_Valid_To3__c=null;
                      APP1.Delegation_Valid_From3__c=null;
                      APP1.Delegate_Name_Text3__c='';
                      APP1.Delegate_Email_3__c='';
                      
                      APP1.Out_of_Office4__c=APPlist1.Out_of_Office__c;
                      APP1.Delegation_Valid_To4__c=null;
                      APP1.Delegation_Valid_From4__c=null;
                      APP1.Delegate_Name_Text4__c='';
                      APP1.Delegate_Email_4__c='';
                   }
                if(APPlist3.size()>0)
                update APPlist3;
                PageReference APPPage = new PageReference('/'+ AppId);
                return APPPage;
            }      
            
          else  
          {          
             try
              {
                  trial.clear();
                  delid.clear();  
                      delid.add(APPlist1.Delegate_Name_dummy__c);
                      delid.add(APPlist1.Delegate_Name1__c);
                      delid.add(APPlist1.Delegate_Name2__c);
                      delid.add(APPlist1.Delegate_Name3__c);
                      delid.add(APPlist1.Delegate_Name4__c);
                      
            
                map<ID,Approver__c> maprec = new map<ID, Approver__c>([select Approver_Name__r.name,id, Delegation_Required_From__c, Delegation_Required_To__c, name, Email_from_user__c from Approver__c where ID in : delid ]);
            
                                            
                system.debug('fffffffffffff'+delid);
                                
                  system.debug('ENTERED INSIDE TRY');
                  List<Approver__c> u = new List<Approver__c>([select Approver_Name__r.name, Delegation_Required_From__c, Delegation_Required_To__c,Title__c,Out_of_Office__c,id,name,Email__c,Email_from_user__c,Terms_and_Conditions__c,X5_Year_revenue__c,Business_Unit__c,To__c,From__c from Approver__c where id In: delid]);
                  system.debug('aaaaaaaaaaaaaaaaaaa'+u);
                  if(u.size()>0){
                  Date D1, D2;
                      for(Approver__c appnew : u){
                              system.debug('Approver : '+appnew.Approver_Name__r.name);
                              D1 = maprec.get(appnew.ID).Delegation_Required_From__c;
                              D2 = maprec.get(appnew.ID).Delegation_Required_To__c;
                              system.debug('Date D1 : '+D1);
                              system.debug('Date D2 : '+D2);
                          if( appnew.Out_of_Office__c && appnew.id == Applist1.Delegate_Name_dummy__c && ( ((APPlist1.From__c >= D1 ) && (APPlist1.From__c <= D2)) || ((APPlist1.To__c >= D1) && (APPlist1.To__c <= D2)) || ((APPlist1.From__c <= D1) && (APPlist1.To__c >= D2)) ) ){
                              system.debug('ccccccccccccc'+appnew.Approver_Name__r.name);
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, appnew.Approver_Name__r.name+ ' is out of office from '+appnew.Delegation_Required_From__c.format()+ ' to '+appnew.Delegation_Required_To__c.format()+'.' ));
                              PageReference APPPage = new PageReference('/'+ AppId);
                              return null;
                          }
                          
                          else if( appnew.Out_of_Office__c && appnew.id == Applist1.Delegate_Name1__c && ( ((APPlist1.Delegation_Valid_From1__c >= D1 ) && (APPlist1.Delegation_Valid_From1__c <= D2)) || ((APPlist1.Delegation_Valid_To1__c >= D1) && (APPlist1.Delegation_Valid_To1__c <= D2)) || ((APPlist1.Delegation_Valid_From1__c < D1) && (APPlist1.Delegation_Valid_To1__c > D2)) ) ){
                              system.debug('dddddddddddddd'+appnew.Approver_Name__r.name);
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, appnew.Approver_Name__r.name+ ' is out of office from '+appnew.Delegation_Required_From__c.format()+ ' to '+appnew.Delegation_Required_To__c.format()+'.' ));
                              return null;
                          }
                          
                          else if( appnew.Out_of_Office__c && appnew.id == Applist1.Delegate_Name2__c && ( ((APPlist1.Delegation_Valid_From2__c >= D1 ) && (APPlist1.Delegation_Valid_From2__c <=  D2)) || ((APPlist1.Delegation_Valid_To2__c >= D1) && (APPlist1.Delegation_Valid_To2__c <= D2)) || ((APPlist1.Delegation_Valid_From2__c <= D1) && (APPlist1.Delegation_Valid_To2__c >= D2)) ) ){
                              system.debug('eeeeeeeeeeeeeee'+appnew.Approver_Name__r.name);
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, appnew.Approver_Name__r.name+ ' is out of office from '+appnew.Delegation_Required_From__c.format()+ ' to '+appnew.Delegation_Required_To__c.format()+'.' ));
                              return null;
                          }
                          
                          else if( appnew.Out_of_Office__c && appnew.id == Applist1.Delegate_Name3__c && ( ((APPlist1.Delegation_Valid_From3__c >= D1 ) && (APPlist1.Delegation_Valid_From3__c <= D2)) || ((APPlist1.Delegation_Valid_To3__c >= D1) && (APPlist1.Delegation_Valid_To3__c <= D2)) || ((APPlist1.Delegation_Valid_From3__c <= D1) && (APPlist1.Delegation_Valid_To3__c >= D2)) ) ){
                              system.debug('fffffffffffffff'+appnew.Approver_Name__r.name);
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, appnew.Approver_Name__r.name+ ' is out of office from '+appnew.Delegation_Required_From__c.format()+ ' to '+appnew.Delegation_Required_To__c.format()+'.' ));
                              return null;
                          }
                          
                          else if( appnew.Out_of_Office__c && appnew.id == Applist1.Delegate_Name4__c && ( ((APPlist1.Delegation_Valid_From4__c >= D1 ) && (APPlist1.Delegation_Valid_From4__c <= D2)) || ((APPlist1.Delegation_Valid_To4__c >= D1) && (APPlist1.Delegation_Valid_To4__c <= D2)) || ((APPlist1.Delegation_Valid_From4__c <= D1) && (APPlist1.Delegation_Valid_To4__c >= D2)) ) ){
                              system.debug('gggggggggggggggggg'+appnew.Approver_Name__r.name);
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, appnew.Approver_Name__r.name+ ' is out of office from '+appnew.Delegation_Required_From__c.format()+ ' to '+appnew.Delegation_Required_To__c.format()+'.' ));
                              return null;
                          }
                          
                          else{
                                  system.debug('TRIAL : '+trial);
                                  trial.add(appnew);
                          }
                      }
                  }
                  
                                  
                   
                  if(trial.size()>0)
                    {
                        myClassList.clear();
                        system.debug('TTTTTTTTTTTT'+trial);
                        for(Approver__c appnew : trial){
                            VarConf=True;
                            MyInnerClass cl = new MyInnerClass();
                            cl.Name1    = appnew.Approver_Name__r.name;
                            cl.Title    = appnew.Title__c;
                            cl.Email    = appnew.Email_from_user__c;
                            cl.BU       = appnew.Business_Unit__c;
                            myClassList.add(cl);
                            system.debug('wwwwwwwwwwwwwwwwwwww'+myClassList);
                        }
                    }


                  APPlist2=[select Mail_Alert__c,Approver_Name__c,Delegate_Name__c,Approver_Name__r.name,Title__c,Delegate_Name_dummy__c,Delegate_Name_dummy__r.name,To__c,From__c,id,Out_of_Office__c,Delegate_Email__c,
               Delegation_Valid_To1__c, Delegation_Valid_From1__c,Delegate_Name_Text1__c, Delegate_Email_1__c, 
               Delegation_Valid_To2__c, Delegation_Valid_From2__c,Delegate_Name_Text2__c, Delegate_Email_2__c,
               Delegation_Valid_To3__c, Delegation_Valid_From3__c,Delegate_Name_Text3__c, Delegate_Email_3__c,
               Delegation_Valid_To4__c, Delegation_Valid_From4__c,Delegate_Name_Text4__c, Delegate_Email_4__c ,
               Delegation_Required_From__c, Delegation_Required_To__c
               from Approver__c where Approver_Name__r.name=:APPlist.Approver_Name__r.name];
               system.debug('BBBBBBBB'+APPlist2);
               
/************************************** Updating SEA Approver matrix with the delegate details *******************************************/

              for(Approver__c APP: APPlist2)         
               {
                  if(APPlist1.Delegate_Name_dummy__c!= null){
                      APP.Out_of_Office__c=APPlist1.Out_of_Office__c;
                      APP.To__c = APPlist1.To__c;
                      APP.From__c= APPlist1.From__c;
                      APP.Delegate_Name__c= maprec.get(APPlist1.Delegate_Name_dummy__c).Approver_Name__r.name;
                      APP.Delegate_Email__c= maprec.get(APPlist1.Delegate_Name_dummy__c).Email_from_user__c;
                  }
            
                  if(APPlist1.Delegate_Name1__c!= null){
                      APP.Out_of_Office1__c=APPlist1.Out_of_Office__c;
                      APP.Delegation_Valid_To1__c = APPlist1.Delegation_Valid_To1__c;
                      APP.Delegation_Valid_From1__c= APPlist1.Delegation_Valid_From1__c;
                      APP.Delegate_Name_Text1__c= maprec.get(APPlist1.Delegate_Name1__c).Approver_Name__r.name;
                      APP.Delegate_Email_1__c= maprec.get(APPlist1.Delegate_Name1__c).Email_from_user__c;
                  }
                  
                  if(APPlist1.Delegate_Name2__c!= null){
                      APP.Out_of_Office2__c=APPlist1.Out_of_Office__c;
                      APP.Delegation_Valid_To2__c = APPlist1.Delegation_Valid_To2__c;
                      APP.Delegation_Valid_From2__c= APPlist1.Delegation_Valid_From2__c;
                      APP.Delegate_Name_Text2__c= maprec.get(APPlist1.Delegate_Name2__c).Approver_Name__r.name;
                      APP.Delegate_Email_2__c= maprec.get(APPlist1.Delegate_Name2__c).Email_from_user__c;
                  }
                  
                  if(APPlist1.Delegate_Name3__c!= null){
                      APP.Out_of_Office3__c=APPlist1.Out_of_Office__c;
                      APP.Delegation_Valid_To3__c = APPlist1.Delegation_Valid_To3__c;
                      APP.Delegation_Valid_From3__c= APPlist1.Delegation_Valid_From3__c;
                      APP.Delegate_Name_Text3__c= maprec.get(APPlist1.Delegate_Name3__c).Approver_Name__r.name;
                      APP.Delegate_Email_3__c= maprec.get(APPlist1.Delegate_Name3__c).Email_from_user__c;
                  }
                  
                  if(APPlist1.Delegate_Name4__c!= null){
                      APP.Out_of_Office4__c=APPlist1.Out_of_Office__c;
                      APP.Delegation_Valid_To4__c = APPlist1.Delegation_Valid_To4__c;
                      APP.Delegation_Valid_From4__c= APPlist1.Delegation_Valid_From4__c;
                      APP.Delegate_Name_Text4__c= maprec.get(APPlist1.Delegate_Name4__c).Approver_Name__r.name;
                      APP.Delegate_Email_4__c= maprec.get(APPlist1.Delegate_Name4__c).Email_from_user__c;
                  }
                  
                  if(fdl.size()>0){
                          system.debug('FROMDATELIST : '+fdl);
                          APP.Delegation_Required_From__c = fdl[0];
                  }
                  
                  if(tdl.size()==1){
                      
                      system.debug('TODATELIST : '+tdl);
                      APP.Delegation_Required_To__c = tdl[0];
                  }
                  else if(tdl.size()>1){
                      Integer num = tdl.size();
                      system.debug('asdasd: '+tdl);
                      system.debug('asdasd1: '+tdl[num-1]);
                      APP.Delegation_Required_To__c = tdl[num-1];
                  }
                  
                  if((APP.Delegate_Email__c!= null && APP.Delegate_Email__c != ' ') || (APP.Delegate_Email_1__c!= null && APP.Delegate_Email_1__c != ' ') || (APP.Delegate_Email_2__c!= null && APP.Delegate_Email_2__c != ' ') || (APP.Delegate_Email_3__c!= null && APP.Delegate_Email_3__c != ' ') || (APP.Delegate_Email_4__c!= null && APP.Delegate_Email_4__c != ' '))
                    { APPlist2[0].Mail_Alert__c = true;
                     system.debug('qweqweqwe : '+APPlist2[0].Mail_Alert__c);}
                  else
                  {
                          if(APP.Mail_Alert__c == true)
                            APP.Mail_Alert__c = false;
                  }

                  
            } 
                   
                   
                   
              }
           catch (Exception e) 
              {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter delegate approver'));
               //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception :'+e));

              }

              PageReference APPPage = new PageReference('/'+ AppId);
              return null;

           }
        }
  }