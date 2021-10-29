trigger case_creatingcaselineitem on Case (after insert,after update) {
/*commenting inactive trigger code to improve code coverage-----
    if(booleanclass.creatingcaselineitem){
        booleanclass.creatingcaselineitem=false;
        list<String> nsn,PN,nsnPN =New list<string>();
        list<String> nsnall =New list<string>();
        list<String> pnall =New list<string>();
        list<String> lisnclt=New list<string>();
        list<String> nsn2=New list<string>();
        list<String> pn2=New list<string>();
        Map<String,Id> Mapofcaseid=New Map<String,Id>();
        list<Case_Line_Item__c> insertlistNSN = New list<Case_Line_Item__c>();
        list<Case> cas,casupdate= New list<case>();
        set<Id> casid=New set<Id>();
            
        for(case cs:Trigger.new){
            if(cs.NSN__c!=null&&cs.NSN__c!=''&& cs.Recordtypeid==label.D_S_Clear_House_RecordTypeId_Case){
                nsn=(cs.NSN__c).split(';');
            }else{nsn=null;}

            if(nsn!=null){
                for(string n:nsn){
                    n=n+'\\\\'+cs.id;
                    nsn2.add(n);
                }
            }

            if(cs.Part_Number__c !=null&& cs.Part_Number__c!=''&& cs.Recordtypeid==label.D_S_Clear_House_RecordTypeId_Case){
                PN=(cs.Part_Number__c).split(';');
            }else{PN=null;}

            if(PN!=null){
                for(string p:PN){
                    p=p+'\\\\'+cs.id;
                    PN2.add(p);
                }
            }

            if(nsn2 != null){
                nsnall.addall(nsn2);
                nsnPN.addall(nsn2);
            }

            if(PN2!=null){
                Pnall.addall(PN2);
                nsnPN.addall(PN2);
            }

            for(String nclt:nsnPN){
                Mapofcaseid.put(nclt,cs.id);
            }
            
            nsnPN.clear();
            nsn2.clear();
            PN2.clear();
            casid.add(cs.id);
        }

        if(nsnall!=null)
            for(String nclt:nsnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.NSN__c=lisnclt[0];
                    clt.recordtypeid=label.D_S_Clear_House_RecordTypeId_CaseLineItem;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }
            
        if(PNall!=null)
            for(String nclt:Pnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.Part_Number__c=lisnclt[0];
                    clt.recordtypeid=label.D_S_Clear_House_RecordTypeId_CaseLineItem;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }

        if(insertlistNSN.size()>0)
        insert insertlistNSN;

        cas=[select id,NSN__c,Part_Number__c,Opportunity__c,Opportunity__r.ownerid,Opportunity__r.Opportunity_Number__c from case where Id in:casid and recordtypeid !=: label.Internal_Escalations];
        if(cas.size()>0){
            for(case c: cas){
            //Below If Condition part is added for updating opp owner and Number fields from selected opportunity.
            if(c.Opportunity__c != null){
                c.Opportunity_Owner__c=c.Opportunity__r.ownerid;
                c.Opportunity_Number__c=c.Opportunity__r.Opportunity_Number__c;
                }
                else if (c.NSN__c!=null || c.Part_Number__c!=null){
                c.NSN__c=null;
                c.Part_Number__c=null;
                }
                casupdate.add(c);
                
            }
        }

        if(casupdate.size()>0)        
        update casupdate;      
        
    }*/
}