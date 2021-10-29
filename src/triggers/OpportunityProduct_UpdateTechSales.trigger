trigger OpportunityProduct_UpdateTechSales on OpportunityLineItem (before insert,before update, after update,after delete) {
    if(AvoidRecursion.isFirstRun_OpportunityProduct_UpdateTechSales()){
    if(Label.Stopupdatetechsales == 'Active'){
    list<id> prodlineids = new list<id>(); list<id> oppids = new list<id>();set<id> plcrids = new set<id>();set<id> plcrids1 = new set<id>();
    transient  list<Product_Line_Tech_Sales__c> lstplts1 = new list<Product_Line_Tech_Sales__c>();
    list<Opportunity> lstopp = new list<Opportunity>();
    map<id,Product_Line_Cross_Ref__c> mapplcr; map<id,Product_Line_Cross_Ref__c> mapplcr1;
    list<string> usernames = new list<string>();
    map<string,id> usermap = new map<string,id>(); map<id,Opportunity> oppmap;
    list<Opportunity_Sales_Team__c> lstoppteam= new list<Opportunity_Sales_Team__c>();
    map<id,id> dupmap = new map<id,id>();list<user> userlst = new list<user>();
    set<id> contids = new set<id>(); Boolean op = true;
    if( TriggerInactive.TestOpportunityProduct_UpdateTechSales == True){
        if(trigger.isinsert){ 
            for(integer i=0;i<trigger.new.size();i++){
            oppids.add(trigger.new[i].Opportunityid);
                if(trigger.new[i].M_PM_Product__c!= null){plcrids.add(trigger.new[i].M_PM_Product__c);
                 system.debug('@@plcridsinsert'+plcrids);
                }    
            }
        }  
        if(Trigger.isupdate){
            for(integer i=0;i<trigger.new.size();i++){
                oppids.add(trigger.new[i].Opportunityid);
                if(trigger.new[i].M_PM_Product__c!=trigger.old[i].M_PM_Product__c){
                    plcrids.add(trigger.new[i].M_PM_Product__c);plcrids1.add(trigger.old[i].M_PM_Product__c);
                 system.debug('@@plcridsupdate'+plcrids);
                  system.debug('**plcrids1update'+plcrids1);
                }
            }
        }
        if(Trigger.isdelete){
            for(integer i=0;i<trigger.old.size();i++){
                plcrids1.add(trigger.old[i].M_PM_Product__c);oppids.add(trigger.old[i].Opportunityid);
                system.debug('**plcrids1update'+plcrids1);
                system.debug('$$oppidsupdate'+oppids);
            }
        }
        if(oppids.size()>0 ){
            oppmap = new map<id,Opportunity>([select id,Tech_Sales__c,Tech_Sales_Product_Area__c, Tech_Sales1__c, Tech_Sales2__c,Default_Product_Sales__c,Default_Tech_Sales__c,Default_Tech_Sales_Product__c,Default_Tech_Sales_Manager__c,Default_Tech_Sales_Manager__r.Name,Default_Tech_Sales_Manager_Secondary__c,Default_Tech_Sales_Manager_Secondary__r.Name,(select id,Contact__c from Opportunity.Opportunity_Sales_Teams__r),(select id,M_PM_Product__c,M_PM_Product__r.Product_Line_Chief_Engineer__c, M_PM_Product__r.Product_Leader__c, M_PM_Product__r.Product_Line__r.Product_Line_Finance_POC__c from OpportunityLineItems ) from Opportunity where id=:oppids]);
            if( Trigger.isinsert || (Trigger.isupdate && Trigger.isbefore )){
                if(!Test.isRunningTest()) { 
                    lstplts1 = [select id,CBT__c,SBU__c,Region__c,Country__c,Tech_Sales__c,Tech_Sales_Product__c,Product_Type__c,Tech_Sales_Manager__r.Name,Tech_Sales_Manager__c,Tech_Sales_Manager_Secondary__r.Name,Tech_Sales_Manager_Secondary__c,Product_Line__r.Name,Product_Line__c,Product_Sales__c from Product_Line_Tech_Sales__c Limit 20000];
                system.debug('%%lstplts1'+lstplts1);
                }
                else{
                               
                lstplts1 = [select id,CBT__c,SBU__c,Region__c,Country__c,Tech_Sales__c,Tech_Sales_Product__c,Product_Type__c,Tech_Sales_Manager__r.Name,Tech_Sales_Manager__c,Tech_Sales_Manager_Secondary__r.Name,Tech_Sales_Manager_Secondary__c,Product_Line__r.Name,Product_Line__c,Product_Sales__c from Product_Line_Tech_Sales__c limit 10];
                system.debug('%%lstplts1else'+lstplts1);
                }       
            }
        }  
        if(plcrids.size()>0 && (Trigger.isinsert || (Trigger.isupdate && Trigger.isbefore ))){
            mapplcr = new map<id,Product_Line_Cross_Ref__c>([select id,Product_Line__c,Product_Line__r.Product_Line_Finance_POC__c,Product_Leader__c,Product_Line_Chief_Engineer__c from Product_Line_Cross_Ref__c where id=:plcrids]);
            system.debug('##mapplcr'+mapplcr);
        }
        if(plcrids1.size()>0 && (Trigger.isdelete || ( Trigger.isupdate && Trigger.isAfter ))){
            mapplcr1 = new map<id,Product_Line_Cross_Ref__c>([select id,Product_Line__c,Product_Line__r.Product_Line_Finance_POC__c,Product_Leader__c,Product_Line_Chief_Engineer__c from Product_Line_Cross_Ref__c where id=:plcrids1]);
            system.debug('##mapplcr1'+mapplcr1);    
        }  
        for(Opportunity opp:oppmap.values()){
            usernames.add(opp.Tech_Sales1__c);usernames.add(opp.Tech_Sales2__c);
        }
        if(usernames.size()>0){
            userlst = [SELECT Id,Name FROM User WHERE Name =: usernames AND IsPortalEnabled = false];
        for(user u :userlst ){usermap.put(u.name,u.id);}
        }  
        if( Trigger.isinsert || (Trigger.isupdate && Trigger.isbefore )){
            for(OpportunityLineItem oplt:trigger.new){
                op = true;
                system.debug('##op'+op);
                if(oppmap.containsKey(oplt.Opportunityid) && (oppmap.get(oplt.Opportunityid).Default_Tech_Sales__c!=null || oppmap.get(oplt.Opportunityid).Default_Tech_Sales_Product__c!=null)){
                    oplt.Tech_Sales__c = oppmap.get(oplt.Opportunityid).Default_Tech_Sales__c;
                    oplt.Tech_Sales_Product__c = oppmap.get(oplt.Opportunityid).Default_Tech_Sales_Product__c;
                    oplt.Tech_Sales_Manager__c = oppmap.get(oplt.Opportunityid).Default_Tech_Sales_Manager__c;
                     oplt.Product_Sales__c = oppmap.get(oplt.Opportunityid).Default_Product_Sales__c;
                    oplt.Tech_Sales_Manager_Secondary__c = oppmap.get(oplt.Opportunityid).Default_Tech_Sales_Manager_Secondary__c;oplt.OpportunityAccountChange__c = false;
                }
                else{
                    if(op == true){
                    system.debug('&&Op'+op);
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                        
                            if( oplt.Tech_Sales_Product_Line__c == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && oplt.CBT__c == plts.CBT__c && oplt.Tech_Sales_Region__c == plts.Region__c && oplt.Tech_Sales_Country__c == plts.Country__c && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c;
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c;
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c; 
                                oplt.Product_Sales__c = plts.Product_Sales__c;
                                oplt.OpportunityAccountChange__c = false; 
                                op = false;
                            }
                        }
                    }
                    if(op == true){
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                            if( oplt.Tech_Sales_Product_Line__c == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && oplt.CBT__c == plts.CBT__c && oplt.Tech_Sales_Region__c == plts.Region__c && plts.Country__c == null && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c; 
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c;
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c;
                                oplt.Product_Sales__c = plts.Product_Sales__c; 
                                oplt.OpportunityAccountChange__c = false; 
                                op = false; 
                            } 
                        }//lstplts1.clear();
                    }
                    if(op == true){
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                            if( oplt.Tech_Sales_Product_Line__c == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && plts.CBT__c == null && oplt.Tech_Sales_Region__c == plts.Region__c && oplt.Tech_Sales_Country__c == plts.Country__c && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c;
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c;
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c;
                                oplt.Product_Sales__c = plts.Product_Sales__c;
                                oplt.OpportunityAccountChange__c = false; 
                                op = false;
                            }
                        }// lstplts1.clear();
                    }
                    if(op == true){ 
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                            if( oplt.Tech_Sales_Product_Line__c == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && plts.CBT__c == null && oplt.Tech_Sales_Region__c == plts.Region__c && plts.Country__c == null && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c; 
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c;
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c;
                                oplt.Product_Sales__c = plts.Product_Sales__c;
                                oplt.OpportunityAccountChange__c = false; 
                                op = false;
                            }
                        }//stplts1.clear();
                    }
                    if(op == true){ 
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                            if( oplt.Tech_Sales_Product_Type__c == plts.Product_Type__c && '*All*' == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && oplt.CBT__c == plts.CBT__c && oplt.Tech_Sales_Region__c == plts.Region__c && oplt.Tech_Sales_Country__c == plts.Country__c && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c;
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c; 
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c;
                                oplt.Product_Sales__c = plts.Product_Sales__c;
                                oplt.OpportunityAccountChange__c = false; 
                                op = false;
                            }
                        }//lstplts1.clear();
                    }
                    if(op == true){ 
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                            if( oplt.Tech_Sales_Product_Type__c == plts.Product_Type__c && '*All*' == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && oplt.CBT__c == plts.CBT__c && oplt.Tech_Sales_Region__c == plts.Region__c && plts.Country__c == null && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c;
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c;
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c;
                                oplt.Product_Sales__c = plts.Product_Sales__c;
                                oplt.OpportunityAccountChange__c = false;   
                                op = false;
                            }
                        } //lstplts1.clear();
                    }
                    if(op == true){ 
                        
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                            //system.debug('oplt value:'+oplt);
                            //system.debug('plts value:'+plts);
                            if( oplt.Tech_Sales_Product_Type__c == plts.Product_Type__c && '*All*' == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && plts.CBT__c == null && oplt.Tech_Sales_Region__c == plts.Region__c && oplt.Tech_Sales_Country__c == plts.Country__c && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c;
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c; 
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c;
                                oplt.Product_Sales__c = plts.Product_Sales__c;
                                oplt.OpportunityAccountChange__c = false; 
                                op = false;
                            }
                        }//lstplts1.clear();
                    }
                    if(op == true){ 
                        for(Product_Line_Tech_Sales__c plts:lstplts1){
                           if( oplt.Tech_Sales_Product_Type__c == plts.Product_Type__c && '*All*' == plts.Product_Line__r.Name && oplt.SBU__c == plts.SBU__c && plts.CBT__c == null && oplt.Tech_Sales_Region__c == plts.Region__c && plts.Country__c == null && op == true){
                                oplt.Tech_Sales__c=plts.Tech_Sales__c;
                                oplt.Tech_Sales_Product__c = plts.Tech_Sales_Product__c;
                                oplt.Tech_Sales_Manager__c = plts.Tech_Sales_Manager__c;
                                oplt.Tech_Sales_Manager_Secondary__c = plts.Tech_Sales_Manager_Secondary__c;
                                oplt.Product_Sales__c = plts.Product_Sales__c;
                                oplt.OpportunityAccountChange__c = false;   
                                op = false;
                            }
                        }//lstplts1.clear();
                    }
                    if(op == true){
                        oplt.Tech_Sales__c = oppmap.get(oplt.Opportunityid).Tech_Sales__c;
                        oplt.Tech_Sales_Product__c = oppmap.get(oplt.Opportunityid).Tech_Sales_Product_Area__c;
                        oplt.OpportunityAccountChange__c = false;
                        oplt.Tech_Sales_Manager__c =  usermap.get(oppmap.get(oplt.Opportunityid).Tech_Sales1__c);
                        oplt.Tech_Sales_Manager_Secondary__c = usermap.get(oppmap.get(oplt.Opportunityid).Tech_Sales2__c);
                       
                        oplt.Product_Sales__c = usermap.get(oppmap.get(oplt.Opportunityid).Default_Product_Sales__c);
                    }
                }
                map<id,id> contmap = new map<id,id>();
                /**for(Opportunity_Sales_Team__c oppsateam :oppmap.get(oplt.Opportunityid).Opportunity_Sales_Teams__r){
                    contmap.put(oppsateam.Contact__c,oppsateam.Contact__c);
                }  
                system.debug('@@mapplcr'+mapplcr);
                if(mapplcr!=null && !mapplcr.isempty()){
                    system.debug('Line187'+mapplcr);
                    system.debug('Line231'+(oplt.M_PM_Product__c));
                    system.debug('Line189'+contmap);
                    system.debug('!!mapplcr.get(oplt.M_PM_Product__c).Product_Leader__c'+mapplcr.get(oplt.M_PM_Product__c).Product_Leader__c);
                    system.debug('##mapplcr.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c'+mapplcr.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c);
                    system.debug('$$mapplcr.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c'+mapplcr.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c);
                    if( mapplcr.get(oplt.M_PM_Product__c).Product_Leader__c!=null && (!contmap.containsKey(mapplcr.get(oplt.M_PM_Product__c).Product_Leader__c))){
                        if( dupmap.get(mapplcr.get(oplt.M_PM_Product__c).Product_Leader__c) != oplt.Opportunityid ){
                            Opportunity_Sales_Team__c oppteam = new Opportunity_Sales_Team__c();
                            oppteam.Contact__c = mapplcr.get(oplt.M_PM_Product__c).Product_Leader__c;
                            oppteam.Opportunity__c = oplt.Opportunityid; 
                            dupmap.put(mapplcr.get(oplt.M_PM_Product__c).Product_Leader__c,oplt.Opportunityid);lstoppteam.add(oppteam);
                        }
                    }
                    if( mapplcr.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c!=null && (!contmap.containsKey(mapplcr.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c))){
                        if( dupmap.get(mapplcr.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c) != oplt.Opportunityid ){
                            Opportunity_Sales_Team__c oppteam = new Opportunity_Sales_Team__c();
                            oppteam.Contact__c = mapplcr.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c;
                            oppteam.Opportunity__c = oplt.Opportunityid; 
                            dupmap.put(mapplcr.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c,oplt.Opportunityid); lstoppteam.add(oppteam);
                        }
                    }           
                    if( mapplcr.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c!=null && (!contmap.containsKey(mapplcr.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c))){
                        if( dupmap.get(mapplcr.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c) != oplt.Opportunityid ){
                            Opportunity_Sales_Team__c oppteam = new Opportunity_Sales_Team__c();
                            oppteam.Contact__c = mapplcr.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c;
                            oppteam.Opportunity__c = oplt.Opportunityid;
                            dupmap.put(mapplcr.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c,oplt.Opportunityid); lstoppteam.add(oppteam);
                        }
                    }
                }**/
            }
        }
        if(lstoppteam.size()>0){ 
        insert lstoppteam; 
        }
        system.debug('**mapplcr1'+mapplcr1);
        if((Trigger.isdelete && mapplcr1!=null && !mapplcr1.isempty() ) || (mapplcr1!=null && !mapplcr1.isempty() && Trigger.isupdate && Trigger.isAfter  )){
            set<id> setids = new set<id>(); list<Opportunity_Sales_Team__c> oppsalteamlst = new list<Opportunity_Sales_Team__c>();
            for(OpportunityLineItem oplt:trigger.old){
                map<id,Opportunity_Sales_Team__c> contmap1 = new map<id,Opportunity_Sales_Team__c>();
                for(Opportunity_Sales_Team__c oppsateam :oppmap.get(oplt.Opportunityid).Opportunity_Sales_Teams__r){
                    contmap1.put(oppsateam.Contact__c,oppsateam);
                } 
                for(OpportunityLineItem oplt2:oppmap.get(oplt.Opportunityid).OpportunityLineItems){
                    setids.add(oplt2.M_PM_Product__r.Product_Leader__c);
                    setids.add(oplt2.M_PM_Product__r.Product_Line_Chief_Engineer__c);
                    setids.add(oplt2.M_PM_Product__r.Product_Line__r.Product_Line_Finance_POC__c);
                } 
                    /*system.debug('Line230'+mapplcr1);
                    system.debug('Line231'+(oplt.M_PM_Product__c));
                    system.debug('Line232'+setids);
                    system.debug('Line233'+contmap1);
                    system.debug('!!mapplcr1.get(oplt.M_PM_Product__c).Product_Leader__c'+mapplcr1.get(oplt.M_PM_Product__c).Product_Leader__c);
                    system.debug('##mapplcr1.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c'+mapplcr1.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c);
                    system.debug('$$mapplcr1.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c'+mapplcr1.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c);
                    */
                if(oplt.M_PM_Product__c !=null && mapplcr1.containsKey(oplt.M_PM_Product__c)){
                    if(mapplcr1.get(oplt.M_PM_Product__c).Product_Leader__c!=null){
                        if(mapplcr1.get(oplt.M_PM_Product__c).Product_Leader__c!=null && (!setids.contains(mapplcr1.get(oplt.M_PM_Product__c).Product_Leader__c)) && (contmap1.containsKey(mapplcr1.get(oplt.M_PM_Product__c).Product_Leader__c))){
                            oppsalteamlst.add( contmap1.get( mapplcr1.get(oplt.M_PM_Product__c).Product_Leader__c));
                        }
                        if(mapplcr1.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c!=null && (!setids.contains(mapplcr1.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c)) && (contmap1.containsKey(mapplcr1.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c))){
                            oppsalteamlst.add( contmap1.get( mapplcr1.get(oplt.M_PM_Product__c).Product_Line_Chief_Engineer__c));
                        }
                        if( mapplcr1.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c!=null && (!setids.contains(mapplcr1.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c)) && (contmap1.containsKey(mapplcr1.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c))){
                            oppsalteamlst.add( contmap1.get( mapplcr1.get(oplt.M_PM_Product__c).Product_Line__r.Product_Line_Finance_POC__c));              
                        }
                    }
                }
            }
            //if(oppsalteamlst.size()>0){delete oppsalteamlst;}      
        } 
    }
   }
    }
}