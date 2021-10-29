/*
Created By   : NTTDATA
Description  : Page is replicated same as "Schedule Entitlement" custom button page.
Test Class   : 
Updates      : 
Created Date : 11/09/2017
*/

public class PlannedMeetingRecurrenceController 
{
    public Planned_Meeting__c plannedMeetingObj{get;set;}
    public String plannedMeetingId{get;set;}
    public String recurenceType{get;set;} 
    public Date plannedMeetingStartDate{get;set;} 
    public Date endByDate {get;set;}
    public Integer Noc{get;set;}   
    
    Date enddate;
    Date enddate1;
    Date startdate;
    Date startdate1;
       
    static String sObjName = 'Planned_Meeting__c';
    
    //Field Sets to display the fields section wise in the Visualforce page
    public List<Schema.FieldSetMember> fieldSetMemberList{get;set;}
    public List<Schema.FieldSetMember> detailfieldSetMemberList{get;set;}
    public List<Schema.FieldSetMember> recordRetentionfieldSetMemberList{get;set;}
    public List<Schema.FieldSetMember> systemInfofieldSetMemberList{get;set;}
    
    //constructor
    public PlannedMeetingRecurrenceController(ApexPages.StandardController controller) 
    {
        plannedMeetingObj = new Planned_Meeting__c();    
        List<Planned_Meeting__c> plannedMeetingList = new List<Planned_Meeting__c>(); 
        recurenceType = 'Monthly';   
        
        plannedMeetingId = Apexpages.currentPage().getParameters().get('id');
        
        if(plannedMeetingId != null && plannedMeetingId  != '')
        {
            fieldSetMemberList =  new List<Schema.FieldSetMember>();
            detailfieldSetMemberList=  new List<Schema.FieldSetMember>();
            recordRetentionfieldSetMemberList =  new List<Schema.FieldSetMember>();
            systemInfofieldSetMemberList=  new List<Schema.FieldSetMember>();
            
            //To get the fields that has to be dispalyed in the page from the field sets thar are created in the planning meeting object
            detailfieldSetMemberList.addAll(readFieldSet('PM_Planned_Meeting_Detail',sObjName));
            recordRetentionfieldSetMemberList.addAll(readFieldSet('PM_Product_Informationn',sObjName));
            systemInfofieldSetMemberList.addAll(readFieldSet('PM_System_Information',sObjName));
            
            //To add all the field set fields into a single field set member
            fieldSetMemberList.addAll(detailfieldSetMemberList);
            fieldSetMemberList.addAll(recordRetentionfieldSetMemberList);
            fieldSetMemberList.addAll(systemInfofieldSetMemberList);
            
            String query = 'Select ';
            
            for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
            {
                query += fieldSetMemberObj.getFieldPath() + ', '; //to add the field set fields in the query to fetch the values
            }          
            
            query += 'Id,recordTypeId From Planned_Meeting__c Where Id =: plannedMeetingId';
            
            plannedMeetingList = Database.query(query);
            
            if(!plannedMeetingList.isEmpty())
            {
                plannedMeetingObj = plannedMeetingList[0];
            }
        }
    }

    //Method to return the fields based upon the field set name and object name   
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }  
    
    //Method to create recurrence records in the Planne dMeeting object
     public pagereference saveRecurrence()
     { 
        Integer ty;
        Integer tm;
        Integer td;
        Integer Noy;
        Integer Nom;
                
        Integer Noq;
        Integer Noq1;
        Integer Noq2;
        Integer tm1;
        try
        {
            if(plannedMeetingStartDate == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Start date must be entered to schedule planned meeting.')); 
                return null;
            }
            
            if(endByDate == null && (Noc == null || Noc<=0) )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date or occurences must be entered to schedule planned meeting.')); 
                return null;
            }
            
            if(endByDate <plannedMeetingStartDate)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date must be on or after start date.')); 
                return null;
            }
            
            if(plannedMeetingObj.Expected_Date__c != null && plannedMeetingStartDate < plannedMeetingObj.Expected_Date__c)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Start date must be after Planned Meeting Start Date.')); 
                //return null;
            }
            
            if(plannedMeetingObj.Expected_Date__c == null)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Expected Date is mandatory for creating the recurrence meetings.')); 
                //return null;
            }
            
            String recordType = 'Contact_Plan';
            
            ty = plannedMeetingStartDate.year(); 
            tm = plannedMeetingStartDate.Month();
            td = plannedMeetingStartDate.Day(); 
            
            Date completedDate;
            if(plannedMeetingObj.Expected_Date__c != null)
            {
                startdate = date.newinstance(ty, plannedMeetingObj.Expected_Date__c.month(), plannedMeetingObj.Expected_Date__c.day());
                
            }
            startdate1 = date.newinstance(ty, tm, td);
            
            if(plannedMeetingObj.Completed_Date__c != null && plannedMeetingObj.Expected_Date__c != null)
            {
                Integer y= ty+(plannedMeetingObj.Completed_Date__c.Year()-plannedMeetingObj.Expected_Date__c.Year());
                
                Date dd =  plannedMeetingObj.Expected_Date__c;
                Integer m = dd.monthsBetween(plannedMeetingObj.Completed_Date__c);
                enddate = date.newinstance(y, plannedMeetingObj.Completed_Date__c.month(), plannedMeetingObj.Completed_Date__c.day());
                enddate1 = plannedMeetingStartDate.addMonths(m);
            }
            
            if(plannedMeetingObj.Completed_Date__c != null)
            {
                completedDate  = date.newinstance(plannedMeetingObj.Completed_Date__c.Year(), plannedMeetingObj.Completed_Date__c.month(), plannedMeetingObj.Completed_Date__c.day());
            }
                   
            List<Planned_Meeting__c> newPlannedMeetingObjList = new List<Planned_Meeting__c>();
            Integer[] myList = new Integer[]{31,28,31,30,31,30,31,31,30,31,30,31};
                       
            if(plannedMeetingObj != null)
            {
                
                /*** Weekly ****/
                if(Recurencetype=='Weekly')
                {
                    if(Noc!= null)
                    {
                         for(integer i=0;i<Noc;i++)
                         {
                             Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                             
                             //Method to assign the field values to the new instance
                             newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);
                             
                             
                             if(plannedMeetingObj.Completed_Date__c != null)
                             {
                                enddate = enddate.addDays(7);
                                newPlannedMeeting.Completed_Date__c = enddate ;
                             }
                             if(plannedMeetingObj.Expected_Date__c != null)
                             {
                                 startdate1 = startdate1.addDays(7);
                                 newPlannedMeeting.Expected_Date__c = startdate1;
                             }
                             System.debug('###newPlannedMeeting.Completed_Date__c'+newPlannedMeeting.Completed_Date__c);     
                             System.debug('###newPlannedMeeting.Expected_Date__c'+newPlannedMeeting.Expected_Date__c);     
                             newPlannedMeetingObjList.add(newPlannedMeeting);
                        }
                    }
                    
                    if(endByDate != null)
                    {
                        
                        Integer numberofToalDays = plannedMeetingStartDate.daysBetween(endByDate );
                        Noy = numberofToalDays / 7;
                        System.debug('###numberofToalDays '+numberofToalDays );
                        System.debug('###Noy'+Noy);

                        for(integer i=0;i<Noy;i++)
                        {
                            Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                            
                            //Method to assign the field values to the new instance
                            newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);
                            
                            if(plannedMeetingObj.Completed_Date__c != null)
                             {
                                enddate  = enddate.addDays(7);
                                newPlannedMeeting.Completed_Date__c = enddate;
                             }
                             if(plannedMeetingObj.Expected_Date__c != null)
                             {
                                 startdate1 = startdate1.addDays(7);
                                 newPlannedMeeting.Expected_Date__c = startdate1 ;
                             }  
                              System.debug('###newPlannedMeeting.Completed_Date__c'+newPlannedMeeting.Completed_Date__c);     
                             System.debug('###newPlannedMeeting.Expected_Date__c'+newPlannedMeeting.Expected_Date__c); 
                             newPlannedMeetingObjList.add(newPlannedMeeting);
                        }
                    }
                 //  return null;
                }
                /***** Starof Year ******/
                if(Recurencetype=='Yearly')
                {
                    if(Noc!= null)
                    {
                        for(integer i=0;i<Noc;i++)
                        {
                             Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                             
                             //Method to assign the field values to the new instance
                             newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);
                             
                             if(plannedMeetingObj.Completed_Date__c != null)
                             {
                                newPlannedMeeting.Completed_Date__c = enddate.addYears(i);
                             }
                             if(plannedMeetingObj.Expected_Date__c != null)
                             {
                                 newPlannedMeeting.Expected_Date__c= startdate.addYears(i);
                             }
                             newPlannedMeetingObjList.add(newPlannedMeeting);
                        }
                    }
                    
                    if(endByDate != null)
                    {
                        Noy= endByDate.year()- plannedMeetingStartDate.year();
                        for(integer i=0;i<=Noy;i++)
                        {
                            Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                            
                            //Method to assign the field values to the new instance
                            newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);
                            
                            if(plannedMeetingObj.Completed_Date__c != null)
                             {
                                newPlannedMeeting.Completed_Date__c = enddate.addYears(i);
                             }
                             if(plannedMeetingObj.Expected_Date__c != null)
                             {
                                 newPlannedMeeting.Expected_Date__c= startdate.addYears(i);
                             }  
                             newPlannedMeetingObjList.add(newPlannedMeeting);
                        }
                    }
    
                }
                /***** End of Year  ******/
                 /***** Starof Month ******/
                if(Recurencetype=='Monthly')
                {
                    if(Noc!= null)
                    {
                        for(integer i=0;i<Noc;i++)
                        {
                            Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                            
                            //Method to assign the field values to the new instance
                            newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);

                             if(plannedMeetingObj.Completed_Date__c!=null)
                             {                        
                                date d2 = enddate1.addMonths(i);
                                if(plannedMeetingObj.Completed_Date__c.day()==31)
                                {                            
                                    newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                }
                                else if(d2.month()==2 && (plannedMeetingObj.Completed_Date__c.day()==31 || plannedMeetingObj.Completed_Date__c.day()==30 || plannedMeetingObj.Completed_Date__c.day()==29) )
                                {
                                    newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                }
                                else 
                                {
                                    newPlannedMeeting.Completed_Date__c =date.newinstance( d2.year(), d2.month(),plannedMeetingObj.Completed_Date__c.day());
                                }
                            }
                            date d1=startdate1.addMonths(i);
                            if(plannedMeetingObj.Expected_Date__c != null && plannedMeetingObj.Expected_Date__c.day()==31 && d1.month()!=2)
                            {
                                newPlannedMeeting.Expected_Date__c= date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                            }
                            else if(plannedMeetingObj.Expected_Date__c != null && d1.month()==2 && (plannedMeetingObj.Expected_Date__c.day()==31 || plannedMeetingObj.Expected_Date__c.day()==30 || plannedMeetingObj.Expected_Date__c.day()==29) )
                            {
                                newPlannedMeeting.Expected_Date__c= date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                            }
                            else if(plannedMeetingObj.Expected_Date__c != null)
                            {
                                 newPlannedMeeting.Expected_Date__c= date.newinstance( d1.year(), d1.month(),plannedMeetingObj.Expected_Date__c.day());
                            }
                            newPlannedMeetingObjList.add(newPlannedMeeting);
                        }
                    }
                    
                    if(endByDate != null)
                    {
                        Nom = ((endByDate.year()- plannedMeetingStartDate.year())*12)+(endByDate.Month()- plannedMeetingStartDate.Month())+1;
                        for(integer i=0;i<Nom;i++)
                        {
                            Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                            
                            //Method to assign the field value to the new instance
                            newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);
                         
                            if(plannedMeetingObj.Completed_Date__c!=null)
                            {
                                date d2 = enddate1.addMonths(i);
                                if(plannedMeetingObj.Completed_Date__c.day()==31)
                                {
                                    newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                }
                                else if(d2.month()==2 && (plannedMeetingObj.Completed_Date__c.day()==31 || plannedMeetingObj.Completed_Date__c.day()==30 || plannedMeetingObj.Completed_Date__c.day()==29) )
                                {
                                    newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                }
                                else 
                                {
                                    newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(),plannedMeetingObj.Completed_Date__c.day());
                                }
                            }
                            
                            date d1=startdate1.addMonths(i);
                            if(plannedMeetingObj.Expected_Date__c != null && plannedMeetingObj.Expected_Date__c.day()==31 && d1.month()!=2)
                            {
                                newPlannedMeeting.Expected_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                            }
                            else if(plannedMeetingObj.Expected_Date__c != null && d1.month()==2 && (plannedMeetingObj.Expected_Date__c.day()==31 || plannedMeetingObj.Expected_Date__c.day()==30 || plannedMeetingObj.Expected_Date__c.day()==29) )
                            {
                                newPlannedMeeting.Expected_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                            }
                            else if(plannedMeetingObj.Expected_Date__c != null)
                            {
                                newPlannedMeeting.Expected_Date__c =date.newinstance( d1.year(), d1.month(),plannedMeetingObj.Expected_Date__c.day());
                            }
                            newPlannedMeetingObjList.add(newPlannedMeeting);
                        }
                    }
                }
                /***** End of Month ******/
                /***** Start of Quarterly******/
                if(Recurencetype=='Quarterly')
                {
                     integer j;
                    if(((tm==1||tm==2||tm==3)&& (plannedMeetingObj.Expected_Date__c.month()==1 ||plannedMeetingObj.Expected_Date__c.month()==2 ||plannedMeetingObj.Expected_Date__c.month()==3))||
                    ((tm==4||tm==5||tm==6)&& (plannedMeetingObj.Expected_Date__c.month()==4||plannedMeetingObj.Expected_Date__c.month()==5 ||plannedMeetingObj.Expected_Date__c.month()==6))||
                    ((tm==7||tm==8||tm==9)&& (plannedMeetingObj.Expected_Date__c.month()==7 ||plannedMeetingObj.Expected_Date__c.month()==8 ||plannedMeetingObj.Expected_Date__c.month()==9))||
                    ((tm==10||tm==11||tm==12)&& (plannedMeetingObj.Expected_Date__c.month()==10 ||plannedMeetingObj.Expected_Date__c.month()==11 ||plannedMeetingObj.Expected_Date__c.month()==12)))
                    {
                        j=0;
                    }
                    
                    
                    if(((tm==4||tm==5||tm==6)&& (plannedMeetingObj.Expected_Date__c.month()==1 ||plannedMeetingObj.Expected_Date__c.month()==2 ||plannedMeetingObj.Expected_Date__c.month()==3))||
                    ((tm==7||tm==8||tm==9)&& (plannedMeetingObj.Expected_Date__c.month()==4||plannedMeetingObj.Expected_Date__c.month()==5 ||plannedMeetingObj.Expected_Date__c.month()==6))||
                    ((tm==10||tm==11||tm==12)&& (plannedMeetingObj.Expected_Date__c.month()==7 ||plannedMeetingObj.Expected_Date__c.month()==8 ||plannedMeetingObj.Expected_Date__c.month()==9))||
                    ((tm==1||tm==2||tm==3)&& (plannedMeetingObj.Expected_Date__c.month()==10 ||plannedMeetingObj.Expected_Date__c.month()==11 ||plannedMeetingObj.Expected_Date__c.month()==12)))
                    {
                        j=3;
                    }
                    
                    if(((tm==7||tm==8||tm==9)&& (plannedMeetingObj.Expected_Date__c.month()==1 ||plannedMeetingObj.Expected_Date__c.month()==2 ||plannedMeetingObj.Expected_Date__c.month()==3))||
                    ((tm==10||tm==11||tm==12)&& (plannedMeetingObj.Expected_Date__c.month()==4||plannedMeetingObj.Expected_Date__c.month()==5 ||plannedMeetingObj.Expected_Date__c.month()==6))||
                    ((tm==1||tm==2||tm==3)&& (plannedMeetingObj.Expected_Date__c.month()==7 ||plannedMeetingObj.Expected_Date__c.month()==8 ||plannedMeetingObj.Expected_Date__c.month()==9))||
                    ((tm==4||tm==5||tm==6)&& (plannedMeetingObj.Expected_Date__c.month()==10 ||plannedMeetingObj.Expected_Date__c.month()==11 ||plannedMeetingObj.Expected_Date__c.month()==12)))
                    {
                        j=6;
                    }
                    if(((tm==10||tm==11||tm==12)&& (plannedMeetingObj.Expected_Date__c.month()==1 ||plannedMeetingObj.Expected_Date__c.month()==2 ||plannedMeetingObj.Expected_Date__c.month()==3))||
                    ((tm==1||tm==2||tm==3)&& (plannedMeetingObj.Expected_Date__c.month()==4||plannedMeetingObj.Expected_Date__c.month()==5 ||plannedMeetingObj.Expected_Date__c.month()==6))||
                    ((tm==4||tm==5||tm==6)&& (plannedMeetingObj.Expected_Date__c.month()==7 ||plannedMeetingObj.Expected_Date__c.month()==8 ||plannedMeetingObj.Expected_Date__c.month()==9))||
                    ((tm==7||tm==8||tm==9)&& (plannedMeetingObj.Expected_Date__c.month()==10 ||plannedMeetingObj.Expected_Date__c.month()==11 ||plannedMeetingObj.Expected_Date__c.month()==12)))
                    {
                        j=9;
                    }
                                  
                    if(plannedMeetingObj.Completed_Date__c == null || ( plannedMeetingObj.Completed_Date__c !=null &&
                    (
                    ((plannedMeetingObj.Expected_Date__c.Month()==1||plannedMeetingObj.Expected_Date__c.Month()==2||plannedMeetingObj.Expected_Date__c.Month()==3) &&(plannedMeetingObj.Completed_Date__c.Month()==1|| plannedMeetingObj.Completed_Date__c.Month()==2||plannedMeetingObj.Completed_Date__c.Month()==3)) ||
                    ((plannedMeetingObj.Expected_Date__c.Month()==4||plannedMeetingObj.Expected_Date__c.Month()==5||plannedMeetingObj.Expected_Date__c.Month()==6) &&(plannedMeetingObj.Completed_Date__c.Month()==4|| plannedMeetingObj.Completed_Date__c.Month()==5||plannedMeetingObj.Completed_Date__c.Month()==6)) ||
                    ((plannedMeetingObj.Expected_Date__c.Month()==7||plannedMeetingObj.Expected_Date__c.Month()==8||plannedMeetingObj.Expected_Date__c.Month()==9) &&(plannedMeetingObj.Completed_Date__c.Month()==7|| plannedMeetingObj.Completed_Date__c.Month()==8||plannedMeetingObj.Completed_Date__c.Month()==9)) ||
                    ((plannedMeetingObj.Expected_Date__c.Month()==10||plannedMeetingObj.Expected_Date__c.Month()==11||plannedMeetingObj.Expected_Date__c.Month()==12) &&(plannedMeetingObj.Completed_Date__c.Month()==10|| plannedMeetingObj.Completed_Date__c.Month()==11||plannedMeetingObj.Completed_Date__c.Month()==12))
                    ) && 
                    (plannedMeetingObj.Expected_Date__c.Year()== plannedMeetingObj.Completed_Date__c.Year()))
                    )
                    {
                        if(Noc!= null)
                        {
                            for(integer i=1;i<=Noc;i++)
                            {
                                Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                                
                                //Method to assign the field value to the new instance
                                newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);
                                 
                                if(plannedMeetingObj.Completed_Date__c!=null)
                                {
                                    Date d6 = date.newinstance(ty, plannedMeetingObj.Completed_Date__c.month(), plannedMeetingObj.Completed_Date__c.day());
                                    date d2 = d6.addMonths(j);
                                    
                                    if(plannedMeetingObj.Completed_Date__c.day()==31)
                                    {                                
                                        newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                    }
                                    else if(d2.month()==2 && (plannedMeetingObj.Completed_Date__c.day()==31 || plannedMeetingObj.Completed_Date__c.day()==30 || plannedMeetingObj.Completed_Date__c.day()==29) )
                                    {
                                        newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                    }
                                    else
                                    {
                                        newPlannedMeeting.Completed_Date__c =date.newinstance( d2.year(), d2.month(),plannedMeetingObj.Completed_Date__c.day());
                                    }
                                }
                                
                                Date d5 = date.newinstance(ty, plannedMeetingObj.Expected_Date__c.month(), plannedMeetingObj.Expected_Date__c.day());
                                date d1= d5.addMonths(j);
                                
                                if(plannedMeetingObj.Expected_Date__c.day()==31 && d1.month()!=2)
                                {
                                    newPlannedMeeting.Expected_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                                }
                                else if(d1.month()==2 && (plannedMeetingObj.Expected_Date__c.day()==31 || plannedMeetingObj.Expected_Date__c.day()==30 || plannedMeetingObj.Expected_Date__c.day()==29) )
                                {
                                    newPlannedMeeting.Expected_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                                }
                                else
                                {
                                    newPlannedMeeting.Expected_Date__c =date.newinstance( d1.year(), d1.month(),plannedMeetingObj.Expected_Date__c.day());
                                }
                                newPlannedMeetingObjList.add(newPlannedMeeting);
                                j=j+3;
                            }
                        } 
                        
                        if(endByDate!=null)
                        {
                            tm1 = endByDate.Month();
                            if(tm==1||tm==2||tm==3)
                            Noq=1;
                            if(tm==4||tm==5||tm==6)
                            Noq=2;
                            if(tm==7||tm==8||tm==9)
                            Noq=3;
                            if(tm==10||tm==11||tm==12)
                            Noq=4;
                            
                            if(tm1==1||tm1==2||tm1==3)
                            Noq1=1;
                            if(tm1==4||tm1==5||tm1==6)
                            Noq1=2;
                            if(tm1==7||tm1==8||tm1==9)
                            Noq1=3;
                            if(tm1==10||tm1==11||tm1==12)
                            Noq1=4;
                            Noq2= (((endByDate.year()- plannedMeetingStartDate.year())*4)+(Noq1-Noq))+1;
                            
                            for(integer i=1;i<=Noq2;i++)
                            {
                                Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
                                
                                //Method to assign the field value to the new instance
                                newPlannedMeeting = assignPlannedMeetingValues(fieldSetMemberList, plannedMeetingObj);
                               
                                if(plannedMeetingObj.Completed_Date__c!=null)
                                {
                                    Date d6 = date.newinstance(ty, plannedMeetingObj.Completed_Date__c.month(), plannedMeetingObj.Completed_Date__c.day());
                                    date d2 = d6.addMonths(j);
                                    if(plannedMeetingObj.Completed_Date__c.day()==31)
                                    {                                
                                        newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                    }
                                    else if(d2.month()==2 && (plannedMeetingObj.Completed_Date__c.day()==31 || plannedMeetingObj.Completed_Date__c.day()==30 || plannedMeetingObj.Completed_Date__c.day()==29) )
                                    {
                                        newPlannedMeeting.Completed_Date__c = date.newinstance( d2.year(), d2.month(), myList[d2.month()-1]);
                                    }
                                    else
                                    {
                                        newPlannedMeeting.Completed_Date__c =date.newinstance( d2.year(), d2.month(),plannedMeetingObj.Completed_Date__c.day());
                                    }
                                }
                                
                                Date d5 = date.newinstance(ty, plannedMeetingObj.Expected_Date__c.month(), plannedMeetingObj.Expected_Date__c.day());
                                date d1= d5.addMonths(j);
                                if(plannedMeetingObj.Expected_Date__c.day()==31 && d1.month()!=2)
                                {
                                    newPlannedMeeting.Expected_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                                }
                                else if(d1.month()==2 && (plannedMeetingObj.Expected_Date__c.day()==31 || plannedMeetingObj.Expected_Date__c.day()==30 || plannedMeetingObj.Expected_Date__c.day()==29) )
                                {
                                    newPlannedMeeting.Expected_Date__c = date.newinstance( d1.year(), d1.month(), myList[d1.month()-1]);
                                }
                                else
                                {
                                    newPlannedMeeting.Expected_Date__c =date.newinstance( d1.year(), d1.month(),plannedMeetingObj.Expected_Date__c.day());
                                }
                                newPlannedMeetingObjList.add(newPlannedMeeting);
                                j=j+3;
                            }
                        }               
                    }
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot schedule Quarterly for this Planned Meeting.')); 
                        return null;
                    }
                }
                /***** End of Quarterly******/
            }
            system.debug('newPlannedMeetingObjList'+newPlannedMeetingObjList);
            if(!newPlannedMeetingObjList.isEmpty())
            {
                insert newPlannedMeetingObjList;
            }
        }
        catch(Exception error)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error.getMessage()));
            return null;
        }
         system.debug('plannedMeetingId---'+plannedMeetingId);
        PageReference pageRef  = new PageReference('/'+plannedMeetingId);
        system.debug('pageRef  ---'+pageRef  );
        pageRef.setRedirect(true);
        return pageRef; 
     }
   
   
    //Method to assign and return the new instance values 
    public static Planned_Meeting__c assignPlannedMeetingValues(List<Schema.FieldSetMember> fieldSetMemberList, Planned_Meeting__c  plannedMeetingObj)
    {
         List<RecordType> recordtypeList = [Select Id From RecordType Where DeveloperName = 'Contact_Plan' And SobjectType = 'Planned_Meeting__c'];
         String plannedMeetingRecordtypeId;
         
         if(!recordtypeList.isEmpty())
         {
             plannedMeetingRecordtypeId = recordtypeList[0].Id;
         }
         
         Planned_Meeting__c newPlannedMeeting = new Planned_Meeting__c();
         for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
         {
             if(!getFieldType(fieldSetMemberObj.getFieldPath()) && fieldSetMemberObj.getFieldPath() != 'Completed_Date__c' &&
                                 fieldSetMemberObj.getFieldPath() != 'Expected_Date__c')
             {
                 newPlannedMeeting.put(fieldSetMemberObj.getFieldPath(),plannedMeetingObj.get(fieldSetMemberObj.getFieldPath()));
             }    
             newPlannedMeeting.recordTypeId = plannedMeetingRecordtypeId; //Assigning the record type to the object instance
         }
         return newPlannedMeeting;
    }
   
    //Method to check if the field is a formula. To avoid populating the formula field using sobject put method.
    public static Boolean getFieldType(String fieldName)
    {
        Boolean isNotEditableField = false;
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(sObjName);
        Schema.DescribeSObjectResult sobjResult = sObjType.getDescribe();
        Schema.DescribeFieldResult fieldRes = sobjResult.fields.getMap().get(fieldName).getDescribe();
        if(fieldRes.isAutoNumber() || fieldRes.isCalculated() || fieldRes.isUnique())
        {
            isNotEditableField = true;
        }
        return isNotEditableField;
    } 
    
    //Method to redirect to the page on cancel
    public pagereference cancel()
    {
        PageReference pageRef = new PageReference('/'+plannedMeetingId);
        return pageRef;
    }   
}