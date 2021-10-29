public class CP_CourseInfo_cls {
    //Added code for SR:357318
    //Download Method to download Table Data in Excel Sheet
    public pagereference Download(){
        PageReference exdownload = null;
        exdownload = Page.ExportDataLogin;
        exdownload.setRedirect(false);
        return exdownload ;
    } 
    // End for SR#357318
    public string cname,cdescp,cloc,ckey,msg,showtable,truncid;
    string y = 'Yes';
    List<Class__c> results = new List<Class__c>();
    List<Class__c> results0 = new List<Class__c>();
    List<Class__c> results1 = new List<Class__c>();
    List<Class__c> clist = new List<Class__c>();
    List<Class__c> cls = new List<Class__c>();
    set<id> cls1 = new set<id>();
    List<Id> sortset = new List<Id>();
    List<Id> crlist = new List<Id>();
    Set<Id>  setid= new Set<Id>();
    Integer countset1,countset;
    //List<string> idlist = new List<string>();
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
        List<Location__c> pickloclist  = [select name from location__c where public__c = 
        true and Record_Type_Name__c = 'HoneywellTraining Location'];
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
        results1.clear();
        String soql = 'select Start_Date__c,end_Date__c,Course_Name__c,Name,Product_Per_Student_Price__c,Location_Name__c,Product_Name__c,Product_Description__c,Product_Keywords__c from Class__c  where ( '; 
        if(cname != null && cname != '')
        {
            cname= cname.trim();
            first = ' Product_Name__c like '+'\''+'%'+cname+'%'+'\'';
            soql = soql + first ;
            count=1;
        }
        if(cloc != null && cloc != ''&& cloc != 'Any')
        {
            cloc= cloc.trim();
            third = 'Location__r.name = '+'\''+cloc+'\'';
            if(count==0)
            soql = soql + third ;
            else 
            soql = soql + 'and '+ third ;
            count=1;
        }
        if(ckey != null && ckey != '')
        {
            ckey= ckey.trim();
            fourth = 'Product_Keywords__c like '+'\''+'%'+ckey+'%'+'\'';
            if(count==0)
            soql = soql + fourth ;
            else 
            soql = soql + 'and '+ fourth ;
            count=1;
        }
        /*if(first !=null)
        {

        }
        if(second !=null)
        {
            if(count==0)
            soql = soql + second ;
            else 
            soql = soql + 'and '+ second ;
            count=1;
        }
        if(third !=null)
        {

        }
        if(fourth!=null)
        {

        }*/
        soql = soql + ' and Product_Make_this_course_public__c = ' + '\''+ 'Yes' + '\'' + ' and Product_isActive__c = TRUE ' ;
        soql=soql + ')';
        if(count==0)
        {
            soql = 'select Course_name__c,Product_Per_Student_Price__c,Location_Name__c,Product_Name__c,Product_Description__c,Product_Keywords__c,Name,Start_Date__c,end_Date__c from Class__c where  Product_Make_this_course_public__c = '+'\''+'Yes'+'\''+' and Product_isActive__c = TRUE  limit 1000'  ;
        }
        System.debug('######################################## soql ' + soql);
        results0 = Database.query(soql);
        if(cdescp != null && cdescp != '')
        {
            cdescp= cdescp.trim();
            //second= 'Product_Description__c like '+'\''+'%'+cdescp+'%'+'\'';
            for(integer i=0;i<results0.size();i++)
            {
                if(results0[i].Product_Description__c.contains(cdescp))
                results.add(results0[i]);
            }
        }
        else 
        results = results0 ;
        System.debug('######################################## results ' + results);
        /*idlist.clear();
        for(integer i=0;i<results.size();i++)
        {
            truncid = results[i].Id;
            System.debug('######################################## truncid ' + truncid);
            truncid = truncid.substring(0,15);
            System.debug('######################################## truncid ' + truncid);
            idlist.add(truncid);
        }
        System.debug('######################################## idlist ' + idlist);
        */
        system.debug('kkkkkkkkk'+results);
        setid.clear();
        for(integer i=0;i<results.size();i++)
        {
            countset = setid.size();
            countset1 = countset;
            setid.add(results[i].Course_Name__c);
            countset= setid.size();
            if(countset != countset1)
            results1.add(results[i]);
        }
        if(results1.size()==0)
        msg = 'There are no records matching this search criteria';
        else
        msg=null;
        for(Class__c c : results1)  
        {
            sortset.add(c.id);
        }
        count1=results1.size();                
        cond6 = false;
        getd6();
        cond11 = false;
        if(results1.size()>20) 
        {
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(results1[i]);
        }
        else
        {
            clist = results1;
        }
        for(integer i=0;i<results.size();i++){
            cls1.add(results[i].id);
        }
        cls = [select Course_Name__c,Product_Per_Student_Price__c,Location_Name__c,Product_Name__c,Product_Description__c,Product_Keywords__c,Name,Start_Date__c,end_Date__c from Class__c where Start_Date__c >= Today and Id IN:cls1];
    }//end of search
    public List<Class__c> getresults()
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
        if(results1.size()>20)
        {
            if(j1>0)
            {
                clist.clear();
                for(integer k1=j1-1;K1>j1-21;K1--)
                if(k1>=0)
                {
                    clist.add(results1[k1]);
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
            List<Class__c> g11 = new List<Class__c>();
            Integer x1=0,y1=19;
            g11 = clist.deepclone(true,true,true);
            if(g11[0]!=results1[0])
            for(x1=0;x1<20;x1++)
            {
                clist.set(y1,g11.get(x1));
                y1--;
            }
            if(clist[0] == results1[0])
            cond6 = false;
            else
            cond6 = true;
            getd6();
            getresults();
        }
        else
        clist = results1;
        return null;
    }
    //function to get the records in the next page
    public List<Class__c> next() 
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
                if(j1 < results1.size())
                {
                    clist.add(results1[j1]);
                    temp1++;
                }
                else
                break;
                if(i1>=results1.size())
                {
                    cond11=false;
                    getd11();
                }
                j1 = j1-20;
            }
            getresults();
        }
        else
        clist = results1;
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
        clist = new List<Class__c>();
        results1 = [select Product_name__c from Class__c where id in :sortset order by Product_name__c];
        count1=results.size();                
        cond6 = false;
        getd6();
        cond11 = false;
        if(results1.size()>20) 
        {
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(results1[i]);
        }
        else
        {
            clist = results1;
        }
    }
    public void sortdescend()
    {
        clist = new List<Class__c>();
        results1 = [select Product_name__c from Class__c where id in :sortset order by Product_name__c desc];
        count1=results1.size();                
        cond6 = false;
        getd6();
        cond11 = false;
        if(results1.size()>20) 
        {
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(results1[i]);
        }
        else
        {
            clist = results1;
        }
    }
    //End of sorting
}