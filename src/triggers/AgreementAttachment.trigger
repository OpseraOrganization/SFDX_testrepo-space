trigger AgreementAttachment on Attachment (after insert, after delete) {
    List<Attachment> list_att = new List<Attachment>();
    List<Attachment> caselistatt = new List<Attachment>();
    if(Trigger.isInsert)
    {
        list_att = Trigger.New;
        caselistatt = Trigger.New;
    }
    if(Trigger.isDelete)
        list_att = Trigger.Old;
    String attId;// = att.ParentId;
    String CaseId;
    set<ID> caseidset =new set<ID>();
    List<case> caselist = new List<case>();
    Map<Id, Attachment> map_att = new Map<Id,Attachment>();
    Map<Id, Attachment> map_att1 = new Map<Id,Attachment>();
    Set<ID> setAttParentId = new SET<ID>();
    Set<ID> setAttParentId1 = new SET<ID>();
    Set<ID> setAttFleetParentId = new SET<ID>();
    list<Fleet_Asset_Detail__c> lstfleetdetails = new list<Fleet_Asset_Detail__c>();
    list<Fleet_Asset_Detail__c> lstfleetdetails1 = new list<Fleet_Asset_Detail__c>();

    Attachment newAtt = new Attachment();
     Attachment caseAtt = new Attachment();
    List<Attachment> insatt = new List<Attachment>();
    List<Attachment> insatt1 = new List<Attachment>();
    List<Contract> contrlist = new List<Contract>();
    List<Case_Extension__c> PPOcasexlist=new List<Case_Extension__c>();
    for(Attachment att:list_att){
        attId = att.ParentId;
        
        if(attId.startsWith('a2I'))
        {
            setAttParentId.add(attId);
            map_att.put(attId,att);
        } 
        if(attId.startsWith('800') && att.name.startsWith('MSP Customer Profile'))
        {
            setAttParentId1.add(attId);
        } 
    } 
    for(Attachment att:caselistatt){
        CaseId = att.ParentId;
        caseidset.add(CaseId);
    }
     system.debug('Agreement Attachment begin:');
     system.debug('userinfo Agreement Attachment begin:'+userinfo.getuserid());
     system.debug('Denied party screening User:'+Label.DeniedPartyScreening_APIUser_ID);
      system.debug('Agreement Attachment Limit class start:'+ Limits.getQueries());
    if(caseidset.size()>0 && userinfo.getuserid()!=Label.DeniedPartyScreening_APIUser_ID && UserInfo.getProfileId()!=Label.API_Data_load_profile_Id)
    {
    caselist=[select id,Description,CreatedByid,LastModifiedDate,Status,Quote_Number__c,UFR_Standard_Price_Amount__c,Case_Record_Type__c,Type,Sales_Order_Number__c,OwnerId,AccountId,SBU__c,CaseOwnerChanged__c,Account.R_O_Do_Not_Send_to_Portal__c,Requestor_Email__c,SuppliedEmail,Subject,Case_Ref_Id__c,CaseNumber,Origin,RecordtypeId,(select id,Name,Manual_Intervention_Last_Modified_Date__c,UFR_SBU__c,SAP_SalesOrder_Status__c,Four_Owner_Change_count__c,Four_Owner_Changes_Date__c,Four_Owner_Changes__c,Three_ReOpen_Count__c,Three_Re_Opens_Date__c,Three_Re_Opens__c,Date_Time_Stamp_of_SBU_Determined__c from CASE.Case_Extensions__r) from Case where id in :caseidset];
    }
    if(caselist.size()>0)
    {
        for (Case cs:caselist)
        {
            system.debug('Agreement Attachment begin1:');
            if((cs.RecordtypeId == Label.OEM_Spares || cs.RecordtypeId == Label.RnO_Automation_Record_Type) && cs.Status == 'Open' && (cs.OwnerId ==  Label.CSO_OEM_Spares || cs.OwnerId == Label.CSO_R_O_Team))
            {
                system.debug('PPO inside if Attachment trigger---------->');
                Case_Extension__c CasEx = new Case_Extension__c();
                if(cs.Case_Extensions__r!=null && cs.Case_Extensions__r.size()>0){
                system.debug('---->If');
                CasEx = cs.Case_Extensions__r;
                }else{
                system.debug('---->else');
                
                CasEx.Case_object__c = cs.id;
                }
                if(CasEx.SAP_SalesOrder_Status__c=='ZRPR'||CasEx.SAP_SalesOrder_Status__c=='ZRA'){
                   system.debug('---->SAP_SalesOrder_Status__c'+CasEx.SAP_SalesOrder_Status__c);
                   system.debug('---->Manual'+CasEx.Manual_Intervention_Last_Modified_Date__c);
                   CasEx.Manual_Intervention_Last_Modified_Date__c = Date.valueOf(cs.LastModifiedDate);
                   system.debug('---->Manual1'+CasEx.Manual_Intervention_Last_Modified_Date__c);
                   PPOcasexlist.add(CasEx);
                        
                  PPO_EmailSending.EmailSend(cs.id);
              }
                
            }
            system.debug('Agreement Attachment end1:');
        }
    }
    system.debug('Agreement Attachment Limit class End:'+ Limits.getQueries());
    if(!PPOcasexlist.isEmpty()){ 
            System.debug('CaseExt Creation'+PPOcasexlist.size());
                try{
                System.debug('CaseExt:'+PPOcasexlist.size());
                    update PPOcasexlist;
                }catch(DMLException e1){}
            }
    
     
      if(Trigger.isInsert){
       for(Attachment att : Trigger.New){
        attId = att.ParentId;
        if(attId.startsWith('a1O'))
        {
        
            setAttFleetParentId.add(att.ParentId);
            map_att1.put(att.ParentId,att);
        } 
    } 
    if(setAttFleetParentId.size()>0)
     lstfleetdetails = [SELECT Id,New_Alert_Identification__c,Case_Associated__c FROM Fleet_Asset_Detail__c WHERE id =:setAttFleetParentId AND New_Alert_Identification__c = True];
      
      for(Fleet_Asset_Detail__c fad :lstfleetdetails) {
        //lstfleetdetails1.add(fad);
        Attachment newAtt2 = map_att1.get(fad.id);
        if(fad.Case_Associated__c != null){
         caseAtt = new Attachment(name = newAtt2.name, body = newAtt2.body, parentid = fad.Case_Associated__c);                            
                    insatt1.add(caseAtt);
        }
      
      }
      if(insatt1!=null && insatt1.size() > 0)
        { 
        Insert insatt1;
        }
        
        if(lstfleetdetails1!=null && lstfleetdetails1.size() > 0)
        { 
        //update lstfleetdetails1;
        }
      
      }
    }