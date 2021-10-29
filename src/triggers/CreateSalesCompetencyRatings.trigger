trigger CreateSalesCompetencyRatings on Sales_Competency__c (after insert) {

    List<Sales_Competency_Rating__c> lstscr = new List<Sales_Competency_Rating__c>();
    
    for(Sales_Competency__c sc:trigger.new){
        if(UOP_RollupChildOpportunity.firstRun == true){
           if(sc.Job_Category__c == 'Sales' ){
                Sales_Competency_Rating__c scr = new Sales_Competency_Rating__c();
                scr.Sales_Competency_Assessment__c = sc.id;
                scr.Competency__c = 'Opportunity Identification, Qualification & Prioritization';
                lstscr.add(scr);
                
                Sales_Competency_Rating__c scr2 = new Sales_Competency_Rating__c();
                scr2.Sales_Competency_Assessment__c = sc.id;
                scr2.Competency__c = 'Account Planning';
                lstscr.add(scr2);
                
                Sales_Competency_Rating__c scr3 = new Sales_Competency_Rating__c();
                scr3.Sales_Competency_Assessment__c = sc.id;
                scr3.Competency__c = 'Negotiations, Closing and Administration';
                lstscr.add(scr3);
                
                Sales_Competency_Rating__c scr4 = new Sales_Competency_Rating__c();
                scr4.Sales_Competency_Assessment__c = sc.id;
                scr4.Competency__c = 'Industry & Customer Knowledge';
                lstscr.add(scr4);
                
                Sales_Competency_Rating__c scr5 = new Sales_Competency_Rating__c();
                scr5.Sales_Competency_Assessment__c = sc.id;
                scr5.Competency__c = 'Define and Deliver the Value Proposition';
                lstscr.add(scr5);
                
                Sales_Competency_Rating__c scr6 = new Sales_Competency_Rating__c();
                scr6.Sales_Competency_Assessment__c = sc.id;
                scr6.Competency__c = 'Manage Momentum Through the Sales Cycle';
                lstscr.add(scr6);
                
                Sales_Competency_Rating__c scr7 = new Sales_Competency_Rating__c();
                scr7.Sales_Competency_Assessment__c = sc.id;
                scr7.Competency__c = 'Organizational Agility';
                lstscr.add(scr7);
            }
            /*
            if(sc.Job_Category__c == 'Sales Support'){
                Sales_Competency_Rating__c scr = new Sales_Competency_Rating__c();
                scr.Sales_Competency_Assessment__c = sc.id;
                scr.Competency__c = 'Business Acumen';
                lstscr.add(scr);
                
                Sales_Competency_Rating__c scr2 = new Sales_Competency_Rating__c();
                scr2.Sales_Competency_Assessment__c = sc.id;
                scr2.Competency__c = 'Industry Knowledge';
                lstscr.add(scr2);
                
                Sales_Competency_Rating__c scr3 = new Sales_Competency_Rating__c();
                scr3.Sales_Competency_Assessment__c = sc.id;
                scr3.Competency__c = 'Customer Engagement';
                lstscr.add(scr3);
                
                Sales_Competency_Rating__c scr4 = new Sales_Competency_Rating__c();
                scr4.Sales_Competency_Assessment__c = sc.id;
                scr4.Competency__c = 'Technical Knowledge';
                lstscr.add(scr4);
                
                Sales_Competency_Rating__c scr5 = new Sales_Competency_Rating__c();
                scr5.Sales_Competency_Assessment__c = sc.id;
                scr5.Competency__c = 'Value Proposition';
                lstscr.add(scr5);
                
                Sales_Competency_Rating__c scr6 = new Sales_Competency_Rating__c();
                scr6.Sales_Competency_Assessment__c = sc.id;
                scr6.Competency__c = 'Managing Momentum';
                lstscr.add(scr6);
                
                Sales_Competency_Rating__c scr7 = new Sales_Competency_Rating__c();
                scr7.Sales_Competency_Assessment__c = sc.id;
                scr7.Competency__c = 'Organization Agility';
                lstscr.add(scr7);
            }*/
            
            if(sc.Job_Category__c == 'Sales Leader'){
                Sales_Competency_Rating__c scr = new Sales_Competency_Rating__c();
                scr.Sales_Competency_Assessment__c = sc.id;
                scr.Competency__c = 'Hires Deploys & Motivates Sales Talent';
                lstscr.add(scr);
                
                Sales_Competency_Rating__c scr2 = new Sales_Competency_Rating__c();
                scr2.Sales_Competency_Assessment__c = sc.id;
                scr2.Competency__c = 'Coaches & Develops Sales Talent';
                lstscr.add(scr2);
                
                Sales_Competency_Rating__c scr3 = new Sales_Competency_Rating__c();
                scr3.Sales_Competency_Assessment__c = sc.id;
                scr3.Competency__c = 'Manages Sales Momentum';
                lstscr.add(scr3);
                
                Sales_Competency_Rating__c scr4 = new Sales_Competency_Rating__c();
                scr4.Sales_Competency_Assessment__c = sc.id;
                scr4.Competency__c = 'Delivers Results';
                lstscr.add(scr4);
                
                Sales_Competency_Rating__c scr5 = new Sales_Competency_Rating__c();
                scr5.Sales_Competency_Assessment__c = sc.id;
                scr5.Competency__c = 'Demonstrates Business Acumen';
                lstscr.add(scr5);
                
                Sales_Competency_Rating__c scr6 = new Sales_Competency_Rating__c();
                scr6.Sales_Competency_Assessment__c = sc.id;
                scr6.Competency__c = 'Establishes and Executes Effective Sales MOS';
                lstscr.add(scr6);
            }
            
        UOP_RollupChildOpportunity.firstRun = false;
        }
    }
    insert lstscr;
}