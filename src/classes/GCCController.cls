public class GCCController {
 
 public static list < Service_Request__c > globaldataexporttovf{get;set;}
 public static list < Service_Request__c > globaldataexporttovf1{get;set;}
 public list <servicerequest1__c> globaldataexporttovftest{get;set;}
 public list <servicerequest1__c> globaldataexporttovftest1{get;set;}
 public static list < servicerequest1__c > deldata{get;set;}
 public static list < servicerequest1__c > deldata1{get;set;}
     public List<Document> att{get;set;}
 
  
    //public list<account> acc{get;set;}

   
    /*
    @RemoteAction
    public static Account ServiceSearch(string searchString)
    {

    system.debug('inside controller'+searchString);

    string searchquery='select name,industry from Account where   (name like \'%'+searchString+'%\') limit 10'; 
     Account acc= Database.query(searchquery);
    system.debug('the list values are'+acc);
    return acc;
    }
    */
    @RemoteAction
    public static Service_Request__c DetailSearch(string searchString1) {

        Service_Request__c obj = [select Moved_to_Top_25__c,GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Name,Date_Initiated__c,Region__c, 
                                  Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c,
                                  RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name,LastModifiedDate, Problem_Description_new__c, 
                                  Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, 
                                  Estimated_Completion_Date__c from Service_Request__c where id =: searchString1];
        
       /* system.debug('rail owner' + obj.New_RAIL_Owner__r.Name);
        system.debug('last modified by ' + obj.LastModifiedBy.name);*/
        return obj;

    }
 public PageReference SearchResult()
{
   String id = System.Label.GCCFolderId;
   //att=[SELECT ContentWorkspace.name,ContentWorkspace.LastModifiedDate,ContentWorkspace.CreatedDate,ContentDocument.CreatedDate,ContentDocument.LastModifiedDate,ContentDocument.title FROM ContentWorkspaceDoc where ContentWorkspace.Name = 'GCC Library' LIMIT 1];
    att = [select a.id,a.Name,a.Description From Document a where a.FolderId=: id];
    return null;
//return null;
}
 

   public  PageReference GenerateReport()
   {
   globaldataexporttovftest=[select Moved_to_Agenda_Followup__c,GCC_Date_Closed__c,Region_of_Origin__c,Moved_to_Top_25__c,Name,Actual_Completion__c,One_list_type__c,RAIL_Item_Number__c,Date_Initiated__c,RAIL_Description__c,ProblemDescriptionLong__c,RAIL_Owner__c,Contact_Name1__c,Last_Modified__c,Supported_Products__c,Criteria_to_close__c,Original_Commit_Date__c,Affected_OEMs__c,Source__c,Status_dates__c,Impacted_Regions__c,Estimated_completion_date__c,Type__c from  servicerequest1__c  ];
      /* system.debug('Total records are'+globaldataexporttovftest.size());
   system.debug('value of globalarrayis inside pagereference'+globaldataexporttovftest);*/
    PageReference pageRef = new PageReference('/apex/ExportingGCCResults');

        pageRef.setredirect(false);

    return pageRef;
   
   }
   
   public  PageReference GenerateReport1()
   {
   globaldataexporttovftest1=[select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Region_of_Origin__c,Name,Actual_Completion__c,One_list_type__c,RAIL_Item_Number__c,Date_Initiated__c,RAIL_Description__c,ProblemDescriptionLong__c,RAIL_Owner__c,Contact_Name1__c,Last_Modified__c,Supported_Products__c,Criteria_to_close__c,Original_Commit_Date__c,Affected_OEMs__c,Source__c,Status_dates__c,Impacted_Regions__c,Estimated_completion_date__c,Type__c from  servicerequest1__c  ];
    /*   system.debug('Total records are'+globaldataexporttovftest1.size());
   system.debug('value of globalarrayis inside pagereference'+globaldataexporttovftest1);*/
    PageReference pageRef = new PageReference('/apex/ExportingGCCResultspdf');

        pageRef.setredirect(false);

    return pageRef;
   
   }
  
    
    
    

@RemoteAction
public static list < Service_Request__c > exportmethodcontroller(list < Service_Request__c > globaldataarray) {
 

 globaldataexporttovf=globaldataarray;
/*system.debug('INSIDE EXPORT METHOD');
system.debug('value of globalarrayis'+globaldataexporttovf);
system.debug('value of globalarrayis'+globaldataexporttovf.size());*/

deldata=[select id,Name from servicerequest1__c];
if(deldata.size()>0)
{
delete deldata;

}


list<servicerequest1__c> objList=new  list<servicerequest1__c>();

for(integer i=0;i<globaldataexporttovf.size();i++)
{
servicerequest1__c obj=new servicerequest1__c();
//system.debug('value of globalarrayis'+globaldataexporttovf[i].One__c);
obj.One_list_type__c=globaldataexporttovf[i].One__c;
obj.Name=globaldataexporttovf[i].Name;
obj.RAIL_Item_Number__c=globaldataexporttovf[i].RAIL_Number__c ;
obj.Date_Initiated__c=globaldataexporttovf[i].Date_Initiated__c;
obj.Actual_Completion__c=globaldataexporttovf[i].Actual_Completion__c;
obj.RAIL_Description__c=globaldataexporttovf[i].RAIL_Description__c;
obj.ProblemDescriptionLong__c=globaldataexporttovf[i].Problem_Description_new__c;
obj.RAIL_Owner__c=globaldataexporttovf[i].New_RAIL_Owner__r.Name;
obj.Contact_Name1__c=globaldataexporttovf[i].Contact_Name__r.Name;
obj.Last_Modified__c=globaldataexporttovf[i].LastModifiedBy.Name;
obj.Supported_Products__c=globaldataexporttovf[i].Supported_Products__r.Name;
//obj.Criteria_to_close__c=globaldataexporttovf[i].Deliverable__c;
obj.Original_Commit_Date__c=globaldataexporttovf[i].Original_Commit_Date__c;
obj.Affected_OEMs__c=globaldataexporttovf[i].Affected_OEMs__c;
obj.Source__c=globaldataexporttovf[i].Source__c; 
obj.Status_dates__c=globaldataexporttovf[i].Status_Dates__c; 
obj.Impacted_Regions__c=globaldataexporttovf[i].Region__c;
obj.Estimated_completion_date__c=globaldataexporttovf[i].Estimated_Completion_Date__c;
obj.Type__c=globaldataexporttovf[i].RAIL_Type__c;
obj.Moved_to_Top_25__c=globaldataexporttovf[i].Moved_to_Top_25__c;
obj.Region_of_Origin__c=globaldataexporttovf[i].Region_of_Origin__c;
obj.GCC_Date_Closed__c=globaldataexporttovf[i].GCC_Date_Closed__c;
obj.Moved_to_Agenda_Followup__c=globaldataexporttovf[i].Moved_to_Agenda_Followup__c;
objList.add(obj);

}
insert objList;

return globaldataexporttovf;
//GenerateReport();

 /*
 PageReference pageRef = new PageReference('/apex/ExportingGCCResults');
     pageRef.setredirect(true);

    return pageRef;
    
 */
    
 
}

 
@RemoteAction
public static list < Service_Request__c > exportmethodcontroller1(list < Service_Request__c > globaldataarray1) {
 

 globaldataexporttovf1=globaldataarray1;
/*system.debug('INSIDE EXPORT METHOD1');
system.debug('value of globalarray1is'+globaldataexporttovf1);
system.debug('value of globalarray1is'+globaldataexporttovf1.size());*/

deldata1=[select id,Name from servicerequest1__c];
if(deldata1.size()>0)
{
delete deldata1;

}


list<servicerequest1__c> objList1=new  list<servicerequest1__c>();

for(integer i=0;i<globaldataexporttovf1.size();i++)
{
servicerequest1__c obj1=new servicerequest1__c();
//system.debug('value of globalarray1is'+globaldataexporttovf1[i].One__c);
obj1.One_list_type__c=globaldataexporttovf1[i].One__c;
obj1.Name=globaldataexporttovf1[i].Name;
obj1.RAIL_Item_Number__c=globaldataexporttovf1[i].RAIL_Number__c ;
obj1.Date_Initiated__c=globaldataexporttovf1[i].Date_Initiated__c;
obj1.Actual_Completion__c=globaldataexporttovf1[i].Actual_Completion__c;
obj1.RAIL_Description__c=globaldataexporttovf1[i].RAIL_Description__c;
obj1.ProblemDescriptionLong__c=globaldataexporttovf1[i].Problem_Description_new__c;
obj1.RAIL_Owner__c=globaldataexporttovf1[i].New_RAIL_Owner__r.Name;
obj1.Contact_Name1__c=globaldataexporttovf1[i].Contact_Name__r.Name;
obj1.Last_Modified__c=globaldataexporttovf1[i].LastModifiedBy.Name;
obj1.Supported_Products__c=globaldataexporttovf1[i].Supported_Products__r.Name;
//obj1.Criteria_to_close__c=globaldataexporttovf1[i].Deliverable__c;
obj1.Original_Commit_Date__c=globaldataexporttovf1[i].Original_Commit_Date__c;
obj1.Affected_OEMs__c=globaldataexporttovf1[i].Affected_OEMs__c;
obj1.Source__c=globaldataexporttovf1[i].Source__c; 
obj1.Status_dates__c=globaldataexporttovf1[i].Status_Dates__c; 
obj1.Impacted_Regions__c=globaldataexporttovf1[i].Region__c;
obj1.Estimated_completion_date__c=globaldataexporttovf1[i].Estimated_Completion_Date__c;
obj1.Type__c=globaldataexporttovf1[i].RAIL_Type__c;
obj1.Moved_to_Top_25__c=globaldataexporttovf1[i].Moved_to_Top_25__c;
obj1.Region_of_Origin__c=globaldataexporttovf1[i].Region_of_Origin__c;
obj1.GCC_Date_Closed__c=globaldataexporttovf1[i].GCC_Date_Closed__c;
obj1.Moved_to_Agenda_Followup__c=globaldataexporttovf1[i].Moved_to_Agenda_Followup__c;
objList1.add(obj1);

}
insert objList1;

return globaldataexporttovf1;
//GenerateReport();

 /*
 PageReference pageRef = new PageReference('/apex/ExportingGCCResults');
     pageRef.setredirect(true);

    return pageRef;
    
 */
    
 
} 


    @RemoteAction
    public static servicerequestall ServiceSearch(string searchString) {
        
        String Sourcefieldvalue='GCC';
        string searchquery = '';
        
        searchquery = 'select  GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Region_of_Origin__c ,Moved_to_Top_25__c,Copy_Rail__c,Name,Date_Initiated__c,Affected_OEMs__c,Region__c,Date_Closed__c,Created_Date__c,One__c,RAIL_Type__c,RAIL_Description__c,Problem_Description_new__c,RAIL_Number__c,Actual_Completion__c,New_RAIL_Owner__r.Name,Contact_Name__r.Name,LastModifiedBy.Name,Supported_Products__r.Name,Deliverable__c,Original_Commit_Date__c,Source__c,Status_Dates__c, Estimated_Completion_Date__c from Service_Request__c where   ( (One__c like \'%' + searchString + '%\') or (Copy_Rail__c   like \'%' + searchString + '%\') or (RAIL_Type__c like \'%' + searchString + '%\')  or (RAIL_Description__c like \'%' + searchString + '%\') or (Problem_Description_new__c like \'%' + searchString + '%\') or (Region_of_Origin__c like \'%' + searchString + '%\')  or   Affected_OEMs__c includes (:searchString) or Region__c INCLUDES (:searchString) or (Source__c  like \'%' + searchString + '%\')) and GCC__c=true ';

        //searchquery='select Affected_OEMs__c,Region__c,Working_Team__c,Date_Closed__c,Created_Date__c,One__c,RAIL_Type__c,RAIL_Description__c,Problem_Description_new__c,RAIL_Number__c from Service_Request__c where Affected_OEMs__c =:Bombardier';


        // List<LIST<SObject>> searchedResult = search.query(searchQuery);

        list < Service_Request__c > searchedResult = database.query(searchquery);



        servicerequestall data = new servicerequestall(searchedResult);

        system.debug('object return is:' + data);
        return data;
    }
    public class servicerequestall {

      List < sObject > results;
        public servicerequestall(List < Service_Request__c > r) {
            results = r;

        }
    }

    @RemoteAction
    public static servicerequestallsecond ServiceSearch1(string searchString, string a, string b, string d, string c,string e, string f, string g, string h, string i, string j, string k,string l,string m,string n,string o,string p,string q,string r,string s,string t,string u,string v,string w,string x,string y,string z,string sr1,string sr2,string check,string check1,string check2) {
        string searchquery1 = '';
        string defaultvalue = 'Top 25';
        String Sourcefieldvalue='GCC';
        string con = '';
        
    if(b!= null && !string.isEmpty(b)){
       string splitString = b;
        system.debug('String b ::::'+b);
         
       string[] splitString1 = splitString.split('-');
       if(splitString1 !=null && splitString1.size()>0){
        system.debug('StringSplit:::'+splitString1);
         b =  splitString1[0];
        system.debug('String b::::'+b);
           if(splitString1.size() >1){
        con = splitString1[1];
           }
         
      //   system.debug('String con::::'+con);
        }
        }  

        list < Service_Request__c > searchedfilterdata;
        string searchquery2 = 'and ((One__c like \'%' + searchString + '%\') or (Copy_Rail__c   like \'%' + searchString + '%\') or (RAIL_Type__c like \'%' + searchString + '%\') or (Problem_Description_new__c like \'%' + searchString + '%\')   or (RAIL_Description__c like \'%' + searchString + '%\') or (Region_of_Origin__c like \'%' + searchString + '%\') or    Affected_OEMs__c includes (:searchString) or Region__c INCLUDES (:searchString) or (Source__c  like \'%' + searchString + '%\') )';

        if (a != '') {
           // system.debug('inside a');
            if (searchquery1 == '') {

                searchquery1 = searchquery1 + '    (RAIL_Type__c like \'%' + a + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (RAIL_Type__c like \'%' + a + '%\')';

            }


        }

        if (b != '') {
          //  system.debug('inside b');
            if (searchquery1 == '') {

                searchquery1 = searchquery1 + '    (RAIL_Type__c like \'%' + b + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (RAIL_Type__c like \'%' + b + '%\')';

            }


        }

        if (c != '') {
          //  system.debug('inside c');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (RAIL_Type__c like \'%' + c + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (RAIL_Type__c like \'%' + c + '%\')';

            }


        }




        if (d != '') {
        //    system.debug('inside d');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (RAIL_Type__c like \'%' + d + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (RAIL_Type__c like \'%' + d + '%\')';

            }


        }
        
         if (con != '') {
          //  system.debug('inside con');
            if (searchquery1 == '') {

                searchquery1 = searchquery1 + '    (RAIL_Type__c like \'%' + con + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (RAIL_Type__c like \'%' + con + '%\')';

            }


        } 

        if (e != '') {
          //  system.debug('inside e');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (One__c like \'%' + e + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (One__c like \'%' + e + '%\')';

            }


        }




        if (f != '') {
           // system.debug('inside f');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (One__c like \'%' + f + '%\')';

            } else {

                searchquery1 = searchquery1 + ' and  (One__c like \'%' + f + '%\')';

            }


        }

        if (g != '') {
       //     system.debug('inside g');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (One__c like \'%' + g + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (One__c like \'%' + g + '%\')';

            }


        }


        if (h != '') {
        //    system.debug('inside h');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (One__c like \'%' + h + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (One__c like \'%' + h + '%\')';

            }


        }


        if (i != '') {
        //    system.debug('inside i');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Region_of_Origin__c like \'%' + i + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (Region_of_Origin__c like \'%' + i + '%\')';

            }


        }



        if (j != '') {
           // system.debug('inside j');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Region_of_Origin__c like \'%' + j + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (Region_of_Origin__c like \'%' + j + '%\')';

            }


        }


        if (k != '') {
          //  system.debug('inside k');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Region_of_Origin__c like \'%' + k + '%\')';

            } else {
                searchquery1 = searchquery1 + ' and  (Region_of_Origin__c like \'%' + k + '%\')';

            }


        }
        
         if (l != '') {
         //   system.debug('inside l');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Region__c INCLUDES (:l))';

            } else {
                searchquery1 = searchquery1 + ' and  (Region__c INCLUDES (:l))';

            }


        }
        
         if (m != '') {
        //    system.debug('inside m');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Region__c INCLUDES (:m))';

            } else {
                searchquery1 = searchquery1 + ' and  (Region__c INCLUDES (:m))';

            }


        }
        
         if (n != '') {
         //   system.debug('inside n');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Region__c INCLUDES (:n))';

            } else {
                searchquery1 = searchquery1 + ' and  (Region__c INCLUDES (:n))';

            }


        }
         if (o != '') {
       //     system.debug('inside o');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:o))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:o))';

            }


        }
        if (p != '') {
        //    system.debug('inside p');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:p))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:p))';

            }


        }
         if (q != '') {
        //    system.debug('inside p');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:q))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:q))';

            }


        }
        if (r != '') {
        //    system.debug('inside r');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:r))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:r))';

            }


        }
        if (s != '') {
       //     system.debug('inside s');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:s))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:s))';

            }


        }
        
         if (t != '') {
        //    system.debug('inside t');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:t))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:t))';

            }


        }
          if (u != '') {
       //     system.debug('inside u');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:u))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:u))';

            }


        }
        
         if (v != '') {
      //      system.debug('inside v');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Affected_OEMs__c INCLUDES (:v))';

            } else {
                searchquery1 = searchquery1 + ' and  (Affected_OEMs__c INCLUDES (:v))';

            }


        }
         if (w != '') {
        //    system.debug('inside w');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    (Date_Initiated__c =This_Year)';

            } else {
                searchquery1 = searchquery1 + ' and  (Date_Initiated__c =This_Year)';

            }


        }
         if (x != '') {
       //     system.debug('inside x');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    ( Date_Initiated__c =Last_Year)';

            } else {
                searchquery1 = searchquery1 + ' and  ( Date_Initiated__c =Last_Year)';

            }


        }
        
        if (y != '') {
      //      system.debug('inside y');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    ( GCC_Date_Closed__c =This_Year)';

            } else {
                searchquery1 = searchquery1 + ' and  ( GCC_Date_Closed__c =This_Year)';

            }


        }
         if (z != '') {
       //     system.debug('inside z');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    ( GCC_Date_Closed__c =Last_Year)';

            } else {
                searchquery1 = searchquery1 + ' and  ( GCC_Date_Closed__c =Last_Year)';

            }


        }
         if (sr1 != '') {
       //     system.debug('inside sr1');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    ( Source__c like \'%' + sr1 + '%\' )';

            } else {
                searchquery1 = searchquery1 + ' and  ( Source__c like \'%' + sr1 + '%\' )';

            }


        }
         if (sr2 != '') {
      //     system.debug('inside sr2');
            if (searchquery1 == '') {
                searchquery1 = searchquery1 + '    ( Source__c like \'%' + sr2 + '%\' )';

            } else {
                searchquery1 = searchquery1 + ' and  ( Source__c like \'%' + sr2 + '%\' )';

            }


        }

 /*-----------------------------------------------------------MYRails with filters starts--------------------------------------------*/
 

 /*According to myrails filters */
 
        if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!=''  ) && (check1!='' && check2=='')) {
            system.debug('according to filters and my rails');
string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true  and (Contact_Name__r.name=:loginusername) ';

           system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        /*According to myrails filters and sort by*/
        
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check1!='' && check2=='sortby'  )) {
        //    system.debug('according to filters and my rails and sort by');
string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c,Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true  and (Contact_Name__r.name=:loginusername) ORDER BY Date_Initiated__c DESC ';

            system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        
        /*According to myrails filters and sort by CREATEDDATE in REVERSE ORDER*/
        
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check1!='' && check2=='sortbyreverse'  )) {
        //    system.debug('according to filters and my rails and sort by');
string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true  and (Contact_Name__r.name=:loginusername) ORDER BY Date_Initiated__c ASC';

       //     system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        }  
        
        
        
        
         /*According to myrails filters and closedsortby*/
        
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check1!='' && check2=='closedsortby'  )) {
      //      system.debug('according to filters and my rails and closedsortby');
string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true  and (Contact_Name__r.name=:loginusername) ORDER BY GCC_Date_Closed__c DESC ';

     //       system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        /*According to myrails filters and closedsortby in reverse order*/
        
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check1!='' && check2=='closedsortbyreverse'  )) {
     //       system.debug('according to filters and my rails and closedsortby');
string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true  and (Contact_Name__r.name=:loginusername) ORDER BY GCC_Date_Closed__c ASC';

       //     system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        
        
        
        /*-----------------------------------------------------------MYRails with filters ends--------------------------------------------*/
      
        
        /*------------------------------------------------FILTERS ONLY STARTS------------------------------------------------*/
        
        /*According to filters only*/
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check=='' && check2=='') ) {
      //      system.debug('according to filters only');

            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true  ';

     //       system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        /*According to filters only and sortby*/
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check!='' && check2=='sortby') ) {
    //        system.debug('according to filters only and sortby');

            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true ORDER BY Date_Initiated__c DESC ';

   //         system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        
         /*According to filters only and sortby CREATEDDATE in Reverse order*/
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!=''  ) && (check!='' && check2=='sortbyreverse') ) {
     //       system.debug('according to filters only and sortby');

            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true ORDER BY Date_Initiated__c ASC';

     //       system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        
        
        
        /*According to filters only and closedsortby*/
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check!='' && check2=='closedsortby') ) {
        //    system.debug('according to filters only and sortby');

            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true ORDER BY GCC_Date_Closed__c DESC ';

       //     system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
         /*According to filters only and closedsortby in reverse order*/
        else if (searchString == '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!='' || o!='' || p!='' || q!='' || r!='' || s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && (check!='' && check2=='closedsortbyreverse') ) {
       //     system.debug('according to filters only and sortby');

            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' and GCC__c=true ORDER BY GCC_Date_Closed__c ASC';

       //     system.debug('final query with out search is' + finalquery);
            searchedfilterdata = database.query(finalquery);
        } 
        
        
          /*------------------------------------------------FILTERS ONLY ENDS------------------------------------------------*/
        
         
       /*-----------------------------FILTER AND GLOBAL SEARCH QUERIES START--------------------------------*/ 
        
        
        
        /*  according to filters and global search  */
        else if (searchString != '' && (a != '' || b != '' || c != '' || d != '' ||con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!=''|| o!='' || p!='' || q!='' || r!='' ||  s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && check2==''  ) {
        //    system.debug('according to filters and global search');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' ' + searchquery2 + ' and  GCC__c=true ';
            searchedfilterdata = database.query(finalquery);
        } 
        
         /*  according to filters and global search and sort by created date  */
        else if (searchString != '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!=''|| o!='' || p!='' || q!='' || r!='' ||  s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && check2=='sortby'  ) {
       //     system.debug('according to filters and global search and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' ' + searchquery2 + ' and  GCC__c=true ORDER BY Date_Initiated__c DESC ';
            searchedfilterdata = database.query(finalquery);
        } 
        
         /*  according to filters and global search and sort by createddate in reverse order  */
        else if (searchString != '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!=''|| o!='' || p!='' || q!='' || r!='' ||  s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && check2=='sortbyreverse'  ) {
        //    system.debug('according to filters and global search and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' ' + searchquery2 + ' and  GCC__c=true ORDER BY Date_Initiated__c ASC';
            searchedfilterdata = database.query(finalquery);
        } 
        
        
        
        
         /*  according to filters and global search and closedsortby   */
        else if (searchString != '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!=''|| o!='' || p!='' || q!='' || r!='' ||  s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && check2=='closedsortby'  ) {
      //      system.debug('according to filters and global search and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' ' + searchquery2 + ' and  GCC__c=true ORDER BY GCC_Date_Closed__c DESC ';
            searchedfilterdata = database.query(finalquery);
        } 
        /*  according to filters and global search and closedsortby in reverse order  */
        else if (searchString != '' && (a != '' || b != '' || c != '' || d != '' || con != '' || e != '' || f != '' || g != '' || h != '' || i != '' || j != '' || k != '' || l!='' || m!='' || n!=''|| o!='' || p!='' || q!='' || r!='' ||  s!='' || t!='' || u!='' || v!='' || w!='' || x!='' || y!='' || z!='' || sr1!='' || sr2!='' ) && check2=='closedsortbyreverse'  ) {
     //       system.debug('according to filters and global search and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where ' + searchquery1 + ' ' + searchquery2 + ' and  GCC__c=true ORDER BY GCC_Date_Closed__c ASC';
            searchedfilterdata = database.query(finalquery);
        } 
        
       /*-----------------------------FILTER AND GLOBAL SEARCH QUERIES END--------------------------------*/  
       
        
        else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && check=='' && check1=='') {

      //      system.debug('global is null and filters are null and check is null and check1 is null');
           string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true ';
            searchedfilterdata = database.query(finalquery);
        } 
        
        
        
        /*-------------------------------------------ALL RAILS FILTERS STARTS-------------------------------------------*/
        
        
        /*Displaying AllRails without sortby*/
        
        else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check!='' && check2=='')) {

       //     system.debug('global is null and filters are null and check is not null');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true ';
            searchedfilterdata = database.query(finalquery);
        }
        
         /*Displaying AllRails with sortby*/
         else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check!='' && check2=='sortby'  )) {

       //     system.debug('global is null and filters are null and check is not null and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true ORDER BY Date_Initiated__c DESC ';
            searchedfilterdata = database.query(finalquery);
        }
        /*Displaying AllRails with sortby CREATEDDATE in REVERSE ORDER*/
         else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check!='' && check2=='sortbyreverse'  )) {

      //      system.debug('global is null and filters are null and check is not null and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true ORDER BY Date_Initiated__c ASC';
            searchedfilterdata = database.query(finalquery);
        }
        
        
        
        
        
        /*Displaying AllRails with closedsortby*/
         else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check!='' && check2=='closedsortby'  )) {

      //      system.debug('global is null and filters are null and check is not null and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true ORDER BY GCC_Date_Closed__c DESC ';
            searchedfilterdata = database.query(finalquery);
        }
        /*Displaying AllRails with closedsortby in reverse order*/
         else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check!='' && check2=='closedsortbyreverse'  )) {

     //       system.debug('global is null and filters are null and check is not null and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true ORDER BY GCC_Date_Closed__c ASC ';
            searchedfilterdata = database.query(finalquery);
        }
        
        
        /*-------------------------------------------ALL RAILS FILTERS ENDS-------------------------------------------*/
        
   
        /*------------------------------------------MY RAILS ONLY-------------------------------------------------------*/
        
          /*       My RAILS without filter   */
         else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == ''|| e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check1!='' && check2=='')) {
 string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
/*system.debug('user name is '+loginusername);
system.debug('user id is '+userrid);


            system.debug('global is null and filters are null and check1 is not null');*/
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true  and   (Contact_Name__r.name=:loginusername) ';
            searchedfilterdata = database.query(finalquery);
        }
        /*      To SORT My RAILS without filter WITH CREATED DATE  */
        
        else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check1!='' && check2=='sortby')) {
//system.debug('sort by with my rails without filter');
 string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
/*system.debug('user name is '+loginusername);
system.debug('user id is '+userrid);


            system.debug('global is null and filters are null and check1 is not null');*/
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true  and   (Contact_Name__r.name=:loginusername) ORDER BY Date_Initiated__c DESC ';
            searchedfilterdata = database.query(finalquery);
        }
         /*      To SORT My RAILS without filter WITH CREATED DATE in reverse order  */
        
        else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check1!='' && check2=='sortbyreverse')) {
//system.debug('sort by with my rails without filter');
 string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
/*system.debug('user name is '+loginusername);
system.debug('user id is '+userrid);


            system.debug('global is null and filters are null and check1 is not null');*/
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true  and   (Contact_Name__r.name=:loginusername) ORDER BY Date_Initiated__c ASC';
            searchedfilterdata = database.query(finalquery);
        }
        
        
        
        
        /*      To SORT My RAILS without filter WITH closed date  */
        
        else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check1!='' && check2=='closedsortby')) {
//system.debug('sort by with my rails without filter');
 string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
/*system.debug('user name is '+loginusername);
system.debug('user id is '+userrid);


            system.debug('global is null and filters are null and check1 is not null');*/
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true  and   (Contact_Name__r.name=:loginusername) ORDER BY GCC_Date_Closed__c DESC ';
            searchedfilterdata = database.query(finalquery);
        }
         
        /*      To SORT My RAILS without filter WITH closed date in reverse order  */
        
        else if (searchString == '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r=='' || s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && (check1!='' && check2=='closedsortbyreverse')) {
//system.debug('sort by with my rails without filter');
 string userrid =UserInfo.getUserId();
user uservar=[select name from user where id=:userrid limit 1];
string loginusername=uservar.name;
/*system.debug('user name is '+loginusername);
system.debug('user id is '+userrid);


            system.debug('global is null and filters are null and check1 is not null');*/
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where (One__c !=null) and GCC__c=true  and   (Contact_Name__r.name=:loginusername) ORDER BY GCC_Date_Closed__c ASC';
            searchedfilterdata = database.query(finalquery);
        }
        
      /*---------------------------------------------MYRAILS ENDS--------------------------------------------------*/  
        
     /*-------------------------------------------GLOBAL ONLY STARTS-------------------------------------------*/
        
        
        /*GLOBAL is not null and filters are null */
        
        else if (searchString != '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r==''|| s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2==''  ) && check2 == '') {
   //         system.debug('GLOBAl is not null and filters are null');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where    ((One__c like \'%' + searchString + '%\') or (Copy_Rail__c   like \'%' + searchString + '%\')  or (RAIL_Type__c like \'%' + searchString + '%\')  or (RAIL_Description__c like \'%' + searchString + '%\') or  (Problem_Description_new__c like \'%' + searchString + '%\') or (Region_of_Origin__c like \'%' + searchString + '%\')  or  Affected_OEMs__c includes (:searchString) or Region__c INCLUDES (:searchString) or  (Source__c  like \'%' + searchString + '%\')  ) and GCC__c=true  ';
            searchedfilterdata = database.query(finalquery);
        }
        
        /*GLOBAL is not null and filters are null and sort by createddate */
        else if(searchString != '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r==''|| s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && check2 == 'sortby')
        {
   //      system.debug('GLOBAl is not null and filters are null and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where    ((One__c like \'%' + searchString + '%\') or (Copy_Rail__c   like \'%' + searchString + '%\') or  (Problem_Description_new__c like \'%' + searchString + '%\')  or (RAIL_Type__c like \'%' + searchString + '%\')  or (RAIL_Description__c like \'%' + searchString + '%\') or (Region_of_Origin__c like \'%' + searchString + '%\')  or  Affected_OEMs__c includes (:searchString) or Region__c INCLUDES (:searchString) or (Source__c  like \'%' + searchString + '%\')  ) and GCC__c=true ORDER BY Date_Initiated__c DESC';
            searchedfilterdata = database.query(finalquery);
        
        
        }
         /*GLOBAL is not null and filters are null and sort by createddate reverse order */
        else if(searchString != '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r==''|| s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && check2 == 'sortbyreverse')
        {
   //      system.debug('GLOBAl is not null and filters are null and sort by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where    ((One__c like \'%' + searchString + '%\') or (Copy_Rail__c   like \'%' + searchString + '%\') or  (Problem_Description_new__c like \'%' + searchString + '%\')  or (RAIL_Type__c like \'%' + searchString + '%\')  or (RAIL_Description__c like \'%' + searchString + '%\') or (Region_of_Origin__c like \'%' + searchString + '%\')  or  Affected_OEMs__c includes (:searchString) or Region__c INCLUDES (:searchString) or (Source__c  like \'%' + searchString + '%\')  ) and GCC__c=true ORDER BY Date_Initiated__c ASC';
            searchedfilterdata = database.query(finalquery);
        
        
        }
        
        /*GLOBAL is not null and filters are null and closedsortby by */
        else if(searchString != '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r==''|| s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && check2 == 'closedsortby')
        {
   //      system.debug('GLOBAl is not null and filters are null and closedsortby by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where    ((One__c like \'%' + searchString + '%\') or (Copy_Rail__c   like \'%' + searchString + '%\') or  (Problem_Description_new__c like \'%' + searchString + '%\')  or (RAIL_Type__c like \'%' + searchString + '%\')  or (RAIL_Description__c like \'%' + searchString + '%\') or (Region_of_Origin__c like \'%' + searchString + '%\')  or  Affected_OEMs__c includes (:searchString) or Region__c INCLUDES (:searchString) or (Source__c  like \'%' + searchString + '%\')  ) and GCC__c=true ORDER BY GCC_Date_Closed__c DESC';
            searchedfilterdata = database.query(finalquery);
        
        
        }
         /*GLOBAL is not null and filters are null and closedsortby by in reverse order */
        else if(searchString != '' && (a == '' || b == '' || c == '' || d == '' || con == '' || e == '' || f == '' || g == '' || h == '' || i == '' || j == '' || k == '' || l=='' || m=='' || n=='' || o=='' || p=='' || q=='' || r==''|| s=='' || t=='' || u=='' || v=='' || w=='' || x=='' || y=='' || z=='' || sr1=='' || sr2=='' ) && check2 == 'closedsortbyreverse')
        {
  //       system.debug('GLOBAl is not null and filters are null and closedsortby by');
            string finalquery = 'select GCC_Date_Closed__c,Moved_to_Agenda_Followup__c,Moved_to_Top_25__c,Name,Date_Initiated__c,Region__c, Supported_Products__r.Name, Status_Update_Date__c, Actual_Completion__c, Contact_Name__r.Name, Created_Date__c, One__c, RAIL_Type__c, RAIL_Description__c, RAIL_Number__c, New_RAIL_Owner__r.Name, LastModifiedBy.Name, Problem_Description_new__c, Deliverable__c, Source__c, Original_Commit_Date__c, OEMs_Affected__c, Affected_OEMs__c, Status_Dates__c, Region_of_Origin__c, Estimated_Completion_Date__c from Service_Request__c where    ((One__c like \'%' + searchString + '%\') or (Copy_Rail__c   like \'%' + searchString + '%\') or  (Problem_Description_new__c like \'%' + searchString + '%\')  or (RAIL_Type__c like \'%' + searchString + '%\')  or (RAIL_Description__c like \'%' + searchString + '%\') or (Region_of_Origin__c like \'%' + searchString + '%\')  or  Affected_OEMs__c includes (:searchString) or Region__c INCLUDES (:searchString) or (Source__c  like \'%' + searchString + '%\')  ) and GCC__c=true ORDER BY GCC_Date_Closed__c ASC';
            searchedfilterdata = database.query(finalquery);
        
        
        }
        
        /*-----------------------------------------------GLOBAL ONLY END--------------------------------------------------*/
        /*
        else
        { system.debug('value of serachstring is:'+searchString);
        system.debug('value is again here');
        system.debug('search query 2 is'+searchquery2);
        string  finalquery = 'select Created_Date__c,One__c,RAIL_Type__c,RAIL_Description__c from Service_Request__c where ('+searchquery1+') '+searchquery2+' ';
        system.debug('final query is'+finalquery);
        searchedfilterdata=database.query(finalquery );
        system.debug('in serchfilterdata'+searchedfilterdata);
        }

        */

        system.debug('result is' + searchedfilterdata);
        servicerequestallsecond data1 = new servicerequestallsecond(searchedfilterdata);

        return data1;

    }
    public class servicerequestallsecond {

        List < sObject > resultsfilter;
        public servicerequestallsecond(List < Service_Request__c > r) {
            resultsfilter = r;

        }
    }

}