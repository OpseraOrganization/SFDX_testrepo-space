/** * File Name: PreventOOOEmailTask
* Description :Trigger to prevent cases from creating having keywords in subject
* line not getting created
* Copyright : Wipro Technologies Limited Copyright (c) 2010 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
 // Added code for INC000012036807 - to stop preventing Junk cases if REF ID available in Subject
trigger PreventOOOEmailTask on Task(before insert) {

String sub;
string tasksub;
set<id> taskrecid=new set<id>();
Boolean RefSub = FALSE;
    for( Task e:Trigger.new)
    {
        tasksub=e.subject;
        taskrecid.add(e.recordtypeid);
    } 
    if(!taskrecid.contains(label.General_Task))
    {
        list<case_lookup__c> Lookuplist= new list<case_lookup__c>(); 
        Lookuplist=[select subject__c from case_lookup__c];
        // Added code for INC000012036807
        for(integer i=0;i<Lookuplist.size();i++)
        {
            if(tasksub!=null)
                tasksub= tasksub.toUpperCase();
            if(Lookuplist[i].subject__C !=null)
            {
                Lookuplist[i].subject__C =  Lookuplist[i].subject__C.toUpperCase();
                if(tasksub!=null && tasksub.contains('REF:') && RefSub == FALSE){
                    RefSub = TRUE;
                    system.debug('RefSub=== '+RefSub);
                }
            }
        }
        // End code for INC000012036807
        for(integer i=0;i<Lookuplist.size();i++)
        {
            sub='';
            if(tasksub != null)
            {
                sub=tasksub;
                sub = sub.toUpperCase();
                if(Lookuplist[i].subject__C !=null)
                {
                    Lookuplist[i].subject__C =  Lookuplist[i].subject__C.toUpperCase();
                    if(sub.contains(Lookuplist[i].subject__C)  &&  sub.contains('EMAIL:') && !(sub.containsIgnoreCase('out of office')) && !(sub.containsIgnoreCase('out of the office')) && RefSub == FALSE)
                    {                                     
                        for( Task e:Trigger.new)
                        {
                            e.subject.addError('Task with Junk Subjects Cannot be created'); 
                        }                               
                    }      
                }     
            }
                    
        }// end for   
    }
}