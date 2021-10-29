trigger UpdateProficiencyExpectationForRole on Sales_Competency__c (after insert, after update) {

    //Declarations
    Map<Id, String> map_SCId_Role = new Map<Id, String>();
    List<Id> list_SCIds = new List<Id>();
    Map<Id, List<Sales_Competency_Rating__c>> map_SCId_SCRatings = new Map<Id, List<Sales_Competency_Rating__c>>();
    List<Sales_Competency_Rating__c> list_SCRatings = new List<Sales_Competency_Rating__c>();
    List<Sales_Competency_Rating__c> list_SCRatingsToUpdate = new List<Sales_Competency_Rating__c>();
    
    for(Sales_Competency__c obj : trigger.new){
        if(Trigger.isInsert || Trigger.isUpdate && (Trigger.oldMap.get(obj.Id).Role_Category__c != obj.Role_Category__c)){
            map_SCId_Role.put(obj.Id, obj.Role_Category__c);
            list_SCIds.add(obj.Id);
        }
    }
    
    for(Sales_Competency_Rating__c temp : [SELECT Id, Name, Sales_Competency_Assessment__c, Competency__c, Proficiency_Expectation_for_Role_Target__c
                                            FROM Sales_Competency_Rating__c
                                            WHERE Sales_Competency_Assessment__c IN : list_SCIds]){
        /*if(!map_SCId_SCRatings.containsKey(temp.Sales_Competency_Assessment__c))
            map_SCId_SCRatings.put(temp.Sales_Competency_Assessment__c, new List<Sales_Competency_Rating__c>{temp});
        else
            map_SCId_SCRatings.get(temp.Sales_Competency_Assessment__c).add(temp);*/
        list_SCRatings.add(temp);
    }
    system.debug('map_SCId_SCRatings>>'+map_SCId_SCRatings);
    system.debug('list_SCRatings>>'+list_SCRatings);
            
    for(Sales_Competency_Rating__c oneRec : list_SCRatings){        
        system.debug('oneRec>>>'+oneRec);
        //********Role Category - A********
        /*if(map_SCId_Role.get(oneRec.Sales_Competency_Assessment__c) == 'A'){
            if(oneRec.Competency__c == 'Opportunity Conversion')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Account Planning')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Mastery';
            if(oneRec.Competency__c == 'Negotiations/Closing')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Mastery';
            if(oneRec.Competency__c == 'Industry/Customer IQ')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Value Propositions')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Mastery';
            if(oneRec.Competency__c == 'Driving Momentum')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Mastery';
            if(oneRec.Competency__c == 'Organizational Agility')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Mastery';
        }
        //********Role Category - B********
        if(map_SCId_Role.get(oneRec.Sales_Competency_Assessment__c) == 'B'){
            if(oneRec.Competency__c == 'Opportunity Conversion')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Account Planning')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Negotiations/Closing')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Industry/Customer IQ')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Value Propositions')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Driving Momentum')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Organizational Agility')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
        }
        //********Role Category - C********
        if(map_SCId_Role.get(oneRec.Sales_Competency_Assessment__c) == 'C'){
            if(oneRec.Competency__c == 'Opportunity Conversion')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Account Planning')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Negotiations/Closing')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Industry/Customer IQ')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Value Propositions')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Driving Momentum')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Organizational Agility')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
        }
        //********Role Category - D********
        if(map_SCId_Role.get(oneRec.Sales_Competency_Assessment__c) == 'D'){
            if(oneRec.Competency__c == 'Opportunity Conversion')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Account Planning')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Negotiations/Closing')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Industry/Customer IQ')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Value Propositions')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Driving Momentum')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Advanced';
            if(oneRec.Competency__c == 'Organizational Agility')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
        }
        //********Role Category - E********
        if(map_SCId_Role.get(oneRec.Sales_Competency_Assessment__c) == 'E'){
            if(oneRec.Competency__c == 'Opportunity Conversion')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Basic';
            if(oneRec.Competency__c == 'Account Planning')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Negotiations/Closing')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Industry/Customer IQ')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Basic';
            if(oneRec.Competency__c == 'Value Propositions')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Experienced';
            if(oneRec.Competency__c == 'Driving Momentum')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Basic';
            if(oneRec.Competency__c == 'Organizational Agility')
                oneRec.Proficiency_Expectation_for_Role_Target__c = 'Basic';
        }*/
        list_SCRatingsToUpdate.add(oneRec);
        system.debug('list_SCRatingsToUpdate>>>>'+list_SCRatingsToUpdate);
    }   
    //}
    
    if(!list_SCRatingsToUpdate.isEmpty())
        update list_SCRatingsToUpdate;                                          

}