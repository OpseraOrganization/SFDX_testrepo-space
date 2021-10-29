public class HwTrng_CourseSchedule_cls {
    public HwTrng_CourseSchedule_cls() {}
    //Added code for SR:357318
    //Download Method to download Table Data in Excel Sheet
    public pagereference Download(){
        PageReference exdownload = null;
        exdownload = Page.ExportDataSchedule;
        exdownload.setRedirect(false);
        return exdownload ;
    } 
    List<String> strList = new List<String>();
    List<Class__c> cls = new List<Class__c>();
    // End for SR#357318
    public HwTrng_CourseSchedule_cls(ApexPages.StandardController controller) {}
    //variable decleration
    class__c ClassRec= new class__c();
    List<Class__c> clist = new List<Class__c>();
    List<Class__c> allclist = new List<Class__c>();
    list<id> sortset= new list<id>();
    boolean  showdetails;
    Integer ci = 20,count=0,i1 = 20,count1=0,j1 = 0, k1 = 0,flag1=0,j = 0, k = 0,flag=0;
    boolean cond2 = false, cond1=false,cond6 = false, cond11=false ;
    public boolean getd11(){return cond11;}
    public boolean getd6(){return cond6;}
    //get and set method for the class record
    public class__c getClassRec()
    {
        return classRec;
    }
    Public void setClassRec(class__c ClassRec)
    {    
        ClassRec=ClassRec; 
    }
    date currentDate = Date.today();
    date  edate= date.newInstance(currentDate.year()+1, 1, 1);
    public datetime getenddate()
    {    
        return edate;
    }
    Public void setenddate(date s)
    {    
        edate=s; 
    }
    string criteria;
    public string getcriteria()
    {
        return criteria;
    }
    Public void setcriteria(String s)
    {    
        criteria=s; 
    }
    public List<SelectOption> getfilter()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('APU, ECS and Engines','APU, ECS and Engines'));
        options.add(new SelectOption('Avionics','Avionics'));
        return options;
    }
    /*public Pagereference search()
    {
    UnholdForBilling();
    Pagereference p = new pagereference('/apex/HwTrng_Thanku_VF');    
    return p;  
    }  */
    public void search()
    {
        showdetails =false;
        sortset= new list<id>();
        clist = new List<Class__c>();
        System.debug('&&&&&&&&&&&&&&&Start Date'+classRec.start_date__c);
        System.debug('&&&&&&&&&&&&&&&SEnd Date'+classRec.end_date__c);
        System.debug('&&&&&&&&&&&&&&&criteria'+criteria );
        if(criteria=='All' ||criteria==null)
        {           
            allclist = [select Class_Name__c,name,ProductDescription__c,Course_Name__r.name,Location__r.name,Business_Unit__c,start_date__c,end_date__c,Product_Per_student_Price__c,Seats_Remaining__c,Total_Number_of_Seats__c,Number_of_reservations__c,status__C from   Class__c where start_date__c >= :classRec.start_date__c and end_date__c <= :classRec.end_date__c order by start_date__c limit 1000];
        }
        else
        {
            allclist = [select Class_Name__c,name,ProductDescription__c,Course_Name__r.name,Business_Unit__c,Location__r.name,start_date__c,end_date__c,Product_Per_student_Price__c,Seats_Remaining__c,Total_Number_of_Seats__c,Number_of_reservations__c,status__C from   Class__c where start_date__c >= :classRec.start_date__c and end_date__c <= :classRec.end_date__c and Business_Unit__c=:criteria order by start_date__c limit 1000];
        }
        for(Class__C clsidlst : allclist)  
        {
            sortset.add(clsidlst.id);
        }  
        if(allclist.size()>0)
        {
            showdetails=True;
        }
        if(allclist.size()>20) 
        {
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            {
                clist.add(allclist[i]);        
            }
        }
        else
        {
            clist = allclist;
        }      
    }
    public boolean getshowdetails()
    {
        return showdetails;
    }
    public List<Class__c> getallclist()
    {
        return allclist;
    }
    public void sortascend()
    {
        clist = new List<Class__c>();
        allclist = [select Class_Name__c,name,Course_Name__r.name,ProductDescription__c,Location__r.name,Business_Unit__c,start_date__c,end_date__c,Product_Per_student_Price__c,Seats_Remaining__c,Total_Number_of_Seats__c,Number_of_reservations__c,status__C from   Class__c where id in :sortset order by Course_Name__r.name];
        count1=allclist.size();                
        cond6 = false;
        getd6();
        cond11 = false;
        if(allclist.size()>20) 
        {
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(allclist[i]);
        }
        else
        {
            clist = allclist;
        }  
    }
    public void sortdescend()
    {
        allclist.clear();
        clist.clear();
        allclist = [select Class_Name__c,name,Course_Name__r.name,ProductDescription__c,Location__r.name,Business_Unit__c,start_date__c,end_date__c,Product_Per_student_Price__c,Seats_Remaining__c,Total_Number_of_Seats__c,Number_of_reservations__c,status__C from   Class__c where id in :sortset order by Course_Name__r.name desc];
        if(allclist.size()>20) 
        {        
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(allclist[i]);
        }
        else
        {
            clist = allclist;
        }      
    }
    public void sortascendstrdte()
    {
        clist = new List<Class__c>();
        allclist = [select Class_Name__c,name,Course_Name__r.name,ProductDescription__c,Location__r.name,Business_Unit__c,start_date__c,end_date__c,Product_Per_student_Price__c,Seats_Remaining__c,Total_Number_of_Seats__c,Number_of_reservations__c,status__C from   Class__c where id in :sortset order by start_date__c];
        count1=allclist.size();                
        cond6 = false;
        getd6();
        cond11 = false;
        if(allclist.size()>20) 
        {       
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(allclist[i]);
        }
        else
        {
            clist = allclist;
        }
    }
    public void sortdescendstrdte()
    {
        allclist.clear();
        clist.clear();
        allclist = [select Class_Name__c,name,Course_Name__r.name,ProductDescription__c,Location__r.name,Business_Unit__c,start_date__c,end_date__c,Product_Per_student_Price__c,Seats_Remaining__c,Total_Number_of_Seats__c,Number_of_reservations__c,status__C from   Class__c where id in :sortset order by start_date__c desc];
        if(allclist.size()>20) 
        {
            cond11 = true;  
            getd11();
            for(Integer i=0;i<20;i++)
            clist.add(allclist[i]);
        }
        else
        {
            clist = allclist;
        }
    }  
    public List<Class__c> getresults()
    {    
        return clist;     
    }
    // function to get the records on the previous page
    public PageReference prev() 
    {
        cond6 = false;
        Integer temp1 = 0;
        flag1 = 0;
        cond11 = true;
        getd11();   
        if(allclist.size()>20)
        {
            if(j1>0)
            {
                clist.clear();
                for(integer k1=j1-1;K1>j1-21;K1--)
                if(k1>=0)
                {
                    clist.add(allclist[k1]);
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
            if(g11[0]!=allclist[0])
            for(x1=0;x1<20;x1++)
            {
                clist.set(y1,g11.get(x1));
                y1--;
            }
            if(clist[0] == allclist[0])
            cond6 = false;
            else
            cond6 = true;
            getd6();
            getresults();
        }
        else
        clist = allclist;
        return null;
    }
    //function to get the records in the next page
    public List<Class__c> next() 
    {
        Integer temp1=0;
        cond6 = true;
        getd6();
        if(allclist.size()>20)      
        {
            if(allclist.size()>ci)
            {
                clist.clear();
                i1 = i1+20;
                for(j1=j1+20;j1<i1;j1++)
                if(j1 < allclist.size())
                {
                    clist.add(allclist[j1]);
                    temp1++;
                }
                else
                break;
                if(i1>=allclist.size())
                {
                    cond11=false;
                    getd11();
                }
                j1 = j1-20;
            }
            getresults();
        }
        else
        clist = allclist;
        if((temp1!=20)&&(flag1==0))
        {
            temp1 = 20-temp1;
            j1 = j1+temp1;
            flag1 = 1;
        }
        return null;
    }
}