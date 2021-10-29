public class HwTrng_CourseInfo_cls
 {
    //Added code for SR:357318
    //Download Method to download Table Data in Excel Sheet
    public pagereference Download(){
        PageReference exdownload = null;
        exdownload = Page.ExportData;
        exdownload.setRedirect(false);
        return exdownload ;
    } 
    // End for SR#357318
    public string cname,cdescp,cloc,ckey,msg,showtable,truncid;
    string ct= 'Classroom';
    string y = 'Yes';
    List<Product2> results = new List<Product2>();
    List<Product2> clist = new List<Product2>();
    List<Id> sortset = new List<Id>();
    List<Id> crlist = new List<Id>();
    List<string> idlist = new List<string>();
    List<Class__c> cls=new List<Class__c>();
    List<Id> locid = new List<Id>();
    Integer i = 20,count=0,i1 = 20,count1=0,j1 = 0, k1 = 0,flag1=0,j = 0, k = 0,flag=0;
    boolean cond2 = false, cond1=false,cond6 = false, cond11=false ;
    public String getcoursename()
    {
    return cname;
    }
    public String getcoursedescp()
    {
    return cdescp;
    }
    public string getcourseloc()
    {
    return cloc;
    }
    public string getcoursekey()
    {
    return ckey;
    }
    public string getmsg()
    {
    return msg;
    }
    public List<SelectOption> getlocation()
    {
        /*
        List<Location__c> pickloclist  = [select name from location__c where public__c = 
        true and Record_Type_Name__c = 'HoneywellTraining Location' ];*/
        //<---------- certido 353097 start--------------->//
        List<Location__c> pickloclist  = [select name from location__c where public__c = 
        true and Record_Type_Name__c = 'HoneywellTraining Location'  Order by Name];
        //<---------certido 353097 End-------------->//
         List<SelectOption> options = new List<SelectOption>(); 
         options.add(new SelectOption('Any','Any'));
         for(integer i=0;i<pickloclist.size();i++)
         options.add(new SelectOption(pickloclist[i].name,pickloclist[i].name));
         return options;
    }
    Public void setcoursename(String s)
    {    
    cname=s; 
    }
    Public void setcoursedescp(String s)
    {    
    cdescp=s; 
    }
    Public void setcourseloc(String s)
    {    
    cloc=s; 
    }
    Public void setcoursekey(String s)
    {    
    ckey=s; 
    }
    Public void setmsg(String s)
    {    
    msg=s; 
    }
    public boolean getd11(){return cond11;}
    public boolean getd6(){return cond6;}
    Public void search()
    {    
        String first,second,third,fourth;
        integer count=0;
        results.clear();
        String soql = 'select name,Description,Record_Type_Name__c,Keywords__c from Product2  where ( '; 

        if(cname != null && cname != '')
        {
        cname= cname.trim();
        first = ' Name like '+'\''+'%'+cname+'%'+'\'';
        }
        if(cdescp != null && cdescp != '')
        {
        cdescp= cdescp.trim();
        second= 'Description like '+'\''+'%'+cdescp+'%'+'\'';
        }
        if(cloc != null && cloc != ''&& cloc != 'Any')
        {
        cloc= cloc.trim();
        third = 'Location__c = '+'\''+cloc+'\'';
        }
        if(ckey != null && ckey != '')
        {
        ckey= ckey.trim();
        fourth = 'Keywords__c like '+'\''+'%'+ckey+'%'+'\'';
        }
        if(first !=null)
        {
        soql = soql + first ;
         count=1;
        }
        if(second !=null)
        {
        if(count==0)
        soql = soql + second ;
        else 
        soql = soql + 'and '+ second ;
        count=1;
        }
        if(fourth!=null)
        {
        if(count==0)
        soql = soql + fourth ;
        else 
        soql = soql + 'and '+ fourth ;
        count=1;
        }
        soql = soql + ' and Make_this_course_public__c = ' + '\''+ 'Yes' + '\'' + ' and isActive = TRUE and  Record_Type_Name__c =' + '\''+  'Classroom' + '\''  ;
        soql=soql + ')';
        if(count==0)
        {
        soql = 'select name,Record_Type_Name__c,Description,Keywords__c from Product2 where Record_Type_Name__c ='+ '\''+ ct + '\''+ ' and Make_this_course_public__c = '+'\''+'Yes'+'\''+' and isActive =TRUE' ;
        }
        soql=soql+' order by name ';
        System.debug('######################################## soql ' + soql);
        results = Database.query(soql);
        System.debug('######################################## results ' + results);
        idlist.clear();
        for(integer i=0;i<results.size();i++)
        {
        truncid = results[i].Id;
        System.debug('######################################## truncid ' + truncid);
        truncid = truncid.substring(0,15);
        System.debug('######################################## truncid ' + truncid);
        idlist.add(truncid);
        }
        System.debug('######################################## idlist ' + idlist);
        
        if(third != null)
        {
            String socql = 'select name from Location__c where name like '+'\''+'%'+cloc+'%'+'\'';
            List<Location__c> loclist = Database.query(socql);
            List<Class__c> classlist  = new List<Class__c> ();
            System.debug('######################################## loclist ' + loclist);
            if(count == 0 && loclist.size()>0)
            {
             classlist = [select name,Course_Name__c,Location__c from Class__c where location__c 
              = :loclist[0].Id ];
            }
            if(count == 1 && loclist.size()>0)
            {
             System.debug('######################################## idlist ' + idlist);
             classlist = [select name,Course_Name__c,Location__c from Class__c where location__c 
            = :loclist[0].Id and Course_Name__c in :idlist];
            System.debug('######################################## classlist ' + classlist);
            }
            crlist.clear();
            for(integer i=0;i<classlist.size();i++)
            {
            crlist.add(classlist[i].Course_Name__c);
            }
            System.debug('######################################## crlist ' + crlist);
            results = [select name,Record_Type_Name__c,Description,Per_student_Price__c from Product2 
            where id in :crlist and Record_Type_Name__c = :ct and Make_this_course_public__c = 'Yes' and isActive =TRUE];
        }
        if(results.size()==0)
            msg = 'There are no records matching this search criteria';
        else
            msg=null;
        for(Product2 c : results)  
        {
        sortset.add(c.id);
        }
        count1=results.size();                
        cond6 = false;
        getd6();
        cond11 = false;
        if(results.size()>20) 
        {
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(results[i]);
        }
        else
        {
            clist = results;
        }
        system.debug('clist1234'+clist);
        cls=[SELECT Id,Product_Name__c,name,Product_Per_Student_Price__c,Course_Name__c,Location_Name__c,Description__c,Location__c,Start_Date__c,end_Date__c  FROM Class__c WHERE Course_Name__c IN:clist and Start_Date__c >= Today];
        system.debug('cls2355'+cls);
    }
        public List<Product2> getresults()
        {
            return clist;
            //return results;
        }
        public List<Class__c> getcls()
        {
            return cls;
        }
// function to get the records on the previous page
    public PageReference prev() 
        {
    Integer temp1 = 0;
    flag1 = 0;
    cond11 = true;
    getd11();   
    if(results.size()>20)
    {
        if(j1>0)
        {
            clist.clear();
            for(integer k1=j1-1;K1>j1-21;K1--)
            if(k1>=0)
            {
                    clist.add(results[k1]);
                    temp1++;
            }
            else
                break;
            i1 = j1;
            j1 = j1-20;
        }
        if(temp1!=20)
        {
            temp1 = 20-temp1;
            j1 = j1+temp1-20;
        }

        List<Product2> g11 = new List<Product2>();
        Integer x1=0,y1=19;
        g11 = clist.deepclone();
        if(g11[0]!=results[0])
        for(x1=0;x1<20;x1++)
        {
            clist.set(y1,g11.get(x1));
            y1--;
        }
        if(clist[0] == results[0])
        cond6 = false;
        else
        cond6 = true;
        getd6();
        getresults();
    }
    else
        clist = results;
    return null;
    }

 //function to get the records in the next page
    public List<Product2> next() 
    {
    Integer temp1=0;
    cond6 = true;
    getd6();

    if(results.size()>20)      
    {
        if(results.size()>i)
        {
            clist.clear();
            i1 = i1+20;
            for(j1=j1+20;j1<i1;j1++)
            if(j1 < results.size())
            {
                clist.add(results[j1]);
                temp1++;
            }
            else
                break;
            if(i1>=results.size())
            {
                cond11=false;
                getd11();
            }
            j1 = j1-20;
        }
        getresults();
    }
    else
        clist = results;
    if((temp1!=20)&&(flag1==0))
    {
        temp1 = 20-temp1;
        j1 = j1+temp1;
        flag1 = 1;
    }

    return null;
}
//Function for sorting
public void sortascend()
{
clist = new List<Product2>();
results = [select name from Product2 where id in :sortset order by name];
count1=results.size();                
cond6 = false;
getd6();
cond11 = false;
if(results.size()>20) 
      {
         cond11 = true;  
         getd11();
         for(Integer i=0;i<20;i++)
         clist.add(results[i]);
      }
     else
      {
         clist = results;
      }
}
public void sortdescend(){
clist = new List<Product2>();
results = [select name from Product2 where id in :sortset order by name desc];
count1=results.size();                
cond6 = false;
getd6();
cond11 = false;
if(results.size()>20) 
      {
         cond11 = true;  
         getd11();
         for(Integer i=0;i<20;i++)
         clist.add(results[i]);
      }
     else
      {
         clist = results;
      }
}
//End of sorting
}