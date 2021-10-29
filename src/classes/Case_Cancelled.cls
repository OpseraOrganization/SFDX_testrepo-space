global class Case_Cancelled implements Schedulable {
    global void execute(SchedulableContext SC){
    
        list<case> caselst = new list<case>();
        String can='Cancelled';
        String Classif='CSO Spares';
        String EOrigin='Email';
        
        String level='Unauthorized Dist/Brkr';
        Boolean isCan=false;
        List<Case> Case_List = new List<Case> ();
        try{
        Case_List=[SELECT id, Is_Cancelled__c,Resolution__c FROM Case where Status =:can and 
        Origin=:EOrigin and classification__c=:Classif and
        Service_Level__c=: level and Is_Cancelled__c=:isCan ];
        }
        catch(Exception e){}
              
       for(integer i=0;i<Case_List.size();i++)
        {
          /// Case CaseRec= new case(Id=Case_List[i].Id);
             // CaseRec.Is_Cancelled__c= true;
              //caselst.add(CaseRec);
              if(Case_List[i].Resolution__c==Null)
              Case_List[i].Resolution__c='None';
              Case_List[i].Is_Cancelled__c= true;
              Case_List[i].Sub_Class__c='';

        }
               if(Case_List.size()>0)
               {
               update Case_List;
               }
               } 
}