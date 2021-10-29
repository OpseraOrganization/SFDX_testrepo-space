/** * File Name: Campaign_Changerecordtype
* Description Trigger to change the Phase records when Competitive Campaign gets convered to Focus or Key.
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Campaign_Changerecordtype on Campaign (after update,before update) {

        List<ID> idlist = new List<Id>();
        List<string> opptypes = new List<string>();
        List <Campaign_Gate__c> og  = new List <Campaign_Gate__c>();
        List <Matrix__c> matrix =new List <Matrix__c>();
        List <Matrix__c> mi =new List <Matrix__c>();
        List <Campaign_Gate__c> ogd  = new List <Campaign_Gate__c>();
        Campaign_Gate__c o = new Campaign_Gate__c();
        List<Campaign_Gate__c> ogate = new List<Campaign_Gate__c>();
        List <Campaign_Gate__c> ogi = new List <Campaign_Gate__c>();
        List <Campaign_Gate__c> ogd1 = new List <Campaign_Gate__c>();
        Map<String,string> mp=new Map<String,string>();
        //getting the stage changed oppty records
        for(Campaign oNew: Trigger.new){
            if(Trigger.newMap.get(oNew.id).Type!=Trigger.oldMap.get(oNew.id).Type && oNew.RecordTypeID != label.Id_of_BGA_record_type_of_Campaign){
                idlist.add(oNew.Id);
                opptypes.add(oNew.Type);
                System.debug('campListIds#############'+idlist);
                System.debug('opptypes#############'+opptypes);
            }
        }
        if(idlist.size()>0){
            og = [ select id,serial_no__c,Actual_Date__c,Phase__c,name ,Campaign__c,Expected_Date__c,Campaign_Type__c
                    from Campaign_Gate__c where Campaign__c in :idlist order by serial_no__c  desc];
                    //matrix records
                    System.debug('Old Tollget ***********************'+og);
                    matrix=[Select id,Phase__c,stage__c,serial_no__c,Campaign_Type__c 
                    from Matrix__c where Campaign_Type__c in :opptypes order by serial_no__c];
                    System.debug('matrix ***********************'+matrix);
                    for(Campaign newCamp: TRigger.new) {
                        boolean nophase = False;
                        for(Matrix__c m: matrix)  {
                            if(newCamp.Type == m.Campaign_Type__c ){
                                o= new Campaign_Gate__c();
                                o.Campaign__c = newCamp.id;
                                o.name =m.Phase__c;
                                o.serial_no__c = m.serial_no__c;
                                o.Campaign_Type__c =m.Campaign_Type__C;
                                o.phase__c = m.phase__c;
                                ogate.add(o);//NEW CAPM GATE LIST WITH MATCHING CAPM TYPE
                                system.debug('campaign get list'+ogate);
                            }
                        }
                        for(Campaign_Gate__c g: og) {
                            for(integer i=0;i<ogate.size();i++) {
                                if(ogate[i].name == g.name && ogate[i].Campaign__c == g.Campaign__c && g.Expected_Date__c !=null){
                                    nophase = True;
                                    ogate[i].Expected_Date__c = g.Expected_Date__c;
                                    ogate[i].actual_date__c = g.actual_date__c;
                                }
                            }
                        }
                        if(nophase == False && TRigger.Isbefore) {
                            System.debug('In before trigger');
                            if(newCamp.Type == 'Focus' || newCamp.Type == 'Competitive' ||newCamp.Type == 'Key'){
                                newCamp.next_phase__c= '1.0 Campaign Kickoff';
                                newCamp.next_phase_date__c  =null;
                            }
                            if(newCamp.type == 'Catalog' || newCamp.type == 'Non-Competitive'){
                                newCamp.next_phase__c= '';
                                newCamp.next_phase_date__c  =null;
                            }
                        }
                    }
                    System.debug('ogate ***********************'+ogate);
                    System.debug('ogd ***********************'+ogd);
                    
                    if(trigger.Isafter){
                    if(og.size()>0){
                        try{
                            delete og;
                            System.debug('record deleted'+og);
                        }
                        catch(Exception e){
                            System.debug('Exception in deleting ......................'+e);
                        }
                     } 
                    if(ogate.size()>0){
                        try{
                            insert ogate;
                            System.debug('record inserted'+ogate);
                        }
                        catch(Exception e){
                            System.debug('Exception......................'+e);
                        }
                    }
        }
        }
  }