public class CP_Myreservations
{
String  i = Userinfo.getuserid();
List<ID> cnctidlist = new List<ID>();
List<ID> accidlist = new List<ID>();
List<ID> contractidlst = new List<ID>();
List<Entitlement__c> entitlelst = new List<Entitlement__c>();
List<Entitlement__c> allentitlelst = new List<Entitlement__c>();
List<Contract> contractlst = new List<Contract>();
List<Contact> contactlst = new List<Contact>();
List<Reservation__c> studlist = new List<Reservation__c>();
List<Reservation__c> allstudlist = new List<Reservation__c>();
public boolean showres{get;set;}
public boolean nores{get;set;}
public boolean showent{get;set;}
public boolean noent{get;set;}

Integer ci = 20,count=0,i1 = 20,count1=0,j1 = 0, k1 = 0,flag1=0,j = 0, k = 0,flag=0;
 boolean cond2 = false, cond1=false,cond6 = false, cond11=false ;
User userlst = new User();
public boolean getd11(){return cond11;}
public boolean getd6(){return cond6;}

Integer cir = 20,countr=0,i1r = 20,count1r=0,j1r = 0, k1r = 0,flag1r=0,jr = 0, kr = 0,flagr=0;
 boolean cond2r = false, cond1r=false,cond6r = false, cond11r=false ;
public boolean getd11r(){return cond11r;}
public boolean getd6r(){return cond6r;}

{
System.debug('****************************i    '+i);
if(i!= null)
{
userlst =[select name,contactid from User where id = :i ];
contactlst = [select name,id,Accountid from Contact where id = :userlst.Contactid];
System.debug('****************************contactlst    '+contactlst);
}
for(integer i=0;i<contactlst.size();i++)
{
accidlist.add(contactlst[i].accountid);
}
if(accidlist.size()>0)
{
contractlst = [select name,id,Accountid,startdate,enddate,Type__c,Description,record_type_name__c,Status from Contract where Accountid in : accidlist and record_type_name__c = 'Training Contracts' and Status = 'Active'];
}
for(integer i=0;i<contractlst.size();i++)
{
contractidlst.add(contractlst[i].id);
System.debug('****************************contractidlst    '+contractidlst);
}
if(contractlst.size()>0)
{
allentitlelst = [select  Usage_Count__c,Usage_Percent__c,Usage_Value__c,Number_Of_Seats__c,Course_Name__c, Status__c,name,id,Contract_Number__c,Entitlement_Type__c,Entitlement_Start_Date__c,Entitlement_Name__c,End_Date__c,Contract_Number_Formula__c from Entitlement__c where Contract_Number__c in : contractidlst and Entitlement_Type__c='Training' and Status__c = 'Active'];
System.debug('****************************entitlelst    '+entitlelst);
if(allentitlelst.size()>0)
{
showent = true;
}
else 
noent=true;
if(allentitlelst.size()>20) 
      {
         cond11 = true;  
         getd11();
         for(Integer i=0;i<20;i++)
         {
         entitlelst.add(allentitlelst[i]);
        
         }
      }
     else
      {
         entitlelst = allentitlelst;
      }

}
else
noent=true;

if(userlst != null)
{
allstudlist = [select name,course_name__c,class_name__c,student__C,class__c,Reservation_Status__c,Start_Date__c,End_Date__c from Reservation__c where student__c = :userlst.Contactid and Reservation_Status__c != 'Cancel' and class_name__r.Course_Name__r.Record_type_name__c = 'Classroom' order by  Start_Date__c desc];
System.debug('****************************studlist    '+studlist);
if(allstudlist.size()>0)
{
showres = true;
}
else nores=true;
if(allstudlist.size()>20) 
      {
         cond11r = true;  
         getd11r();
         for(Integer i=0;i<20;i++)
         {
        studlist.add(allstudlist[i]);
        
         }
      }
     else
      {
         studlist = allstudlist;
      }
}
}

public List<Entitlement__c> getentitlements()
{
return entitlelst;
}
public List<Contract> getcontractlist()
{
return contractlst;
}
public List<Reservation__c> getstudseglist()
{
return studlist;
}
public Id testassign {get; set;}
public PageReference cancel()
{
PageReference p =new PageReference('/apex/CP_CancelReservation?id='+testassign);
return p ;
}




// function to get the records on the previous page
    public PageReference prev() 
        {
        cond6 = false;
        
    Integer temp1 = 0;
    flag1 = 0;
    cond11 = true;
    getd11();   
    if(allentitlelst.size()>20)
    {
        if(j1>0)
        {
            entitlelst.clear();
            for(integer k1=j1-1;K1>j1-21;K1--)
            if(k1>=0)
            {
                    entitlelst.add(allentitlelst[k1]);
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

        List<Entitlement__c> g11 = new List<Entitlement__c>();
        Integer x1=0,y1=19;
        g11 = entitlelst.deepclone(true,true,true);
        if(g11[0]!=allentitlelst[0])
        for(x1=0;x1<20;x1++)
        {
            entitlelst.set(y1,g11.get(x1));
            y1--;
        }
          if(entitlelst[0] == allentitlelst[0])
         cond6 = false;
        else
        cond6 = true;
     
        getd6();
        getentitlements();
    }
    else
       entitlelst = allentitlelst;
    return null;
    }


 //function to get the records in the next page
    public List<Product2> next() 
    {
    Integer temp1=0;
    cond6 = true;
    getd6();

    if(allentitlelst.size()>20)      
    {
        if(allentitlelst.size()>ci)
        {
            entitlelst.clear();
            i1 = i1+20;
            for(j1=j1+20;j1<i1;j1++)
            if(j1 < allentitlelst.size())
            {
                entitlelst.add(allentitlelst[j1]);
                temp1++;
            }
            else
                break;
            if(i1>=allentitlelst.size())
            {
                cond11=false;
                getd11();
            }
            j1 = j1-20;
        }
        getentitlements();
    }
    else
        entitlelst = allentitlelst;
    if((temp1!=20)&&(flag1==0))
    {
        temp1 = 20-temp1;
        j1 = j1+temp1;
        flag1 = 1;
    }

    return null;
}

// function to get the records on the previous page
    public PageReference prevr() 
        {
        cond6r = false;
        
    Integer temp1r = 0;
    flag1r = 0;
    cond11r = true;
    getd11r();   
    if(allstudlist.size()>20)
    {
        if(j1r>0)
        {
            studlist.clear();
            for(integer k1r=j1r-1;K1r>j1r-21;K1r--)
            if(k1r>=0)
            {
                    studlist.add(allstudlist[k1r]);
                    temp1r++;
            }
            else
                break;
            i1r = j1r;
            j1r = j1r-20;
        }
        if(temp1r!=20)
        {
            temp1r = 20-temp1r;
            j1r = j1r+temp1r-20;
        }

        List<Reservation__c> g11r = new List<Reservation__c>();
        Integer x1r=0,y1r=19;
        g11r = studlist.deepclone(true,true,true);
        if(g11r[0]!=allstudlist[0])
        for(x1r=0;x1r<20;x1r++)
        {
            studlist.set(y1r,g11r.get(x1r));
            y1r--;
        }
          if(studlist[0] == allstudlist[0])
         cond6r = false;
        else
        cond6r = true;
     
        getd6r();
        getstudseglist();
    }
    else
       entitlelst = allentitlelst;
    return null;
    }
    
     //function to get the records in the next page
    public List<Product2> nextr() 
    {
    Integer temp1r=0;
    cond6r = true;
    getd6r();

    if(allstudlist.size()>20)      
    {
        if(allstudlist.size()>cir)
        {
            studlist.clear();
            i1r = i1r+20;
            for(j1r=j1r+20;j1r<i1r;j1r++)
            if(j1r < allstudlist.size())
            {
                studlist.add(allstudlist[j1r]);
                temp1r++;
            }
            else
                break;
            if(i1r>=allstudlist.size())
            {
                cond11r=false;
                getd11r();
            }
            j1r = j1r-20;
        }
        getstudseglist();
    }
    else
        studlist = allstudlist;
    if((temp1r!=20)&&(flag1r==0))
    {
        temp1r = 20-temp1r;
        j1r = j1r+temp1r;
        flag1r = 1;
    }

    return null;
}

}