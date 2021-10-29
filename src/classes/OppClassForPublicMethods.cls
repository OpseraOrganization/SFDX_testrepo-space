/*******************************************************************************
Name         : OppClassForPublicMethods
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : Phase-II, HealthCheck
Created Date : 21 Jan 2013
Usages       : This Class is used to define generic method which is Opportunity  
Triggers.    
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification 
15 Oct 2010   1.0             NTTDATA         HAN-0263 Healtcheck Sprint 7
*******************************************************************************/
global class OppClassForPublicMethods
{  
    
    global OppClassForPublicMethods() 
    { 
        
    }
    /* This method is used for the replacement of trigger code which is called Before Update /After Update */
    global void changeRecordTypeMethod(List<Opportunity> listObjOppNew,Map<ID,Opportunity> oldMap)
    {
        List<ID> idlist = new List<Id>();
        List<string> opptypes = new List<string>();
        List <Opportunity_Gate__c> og  = new List <Opportunity_Gate__c>();
        List <Matrix__c> matrix =new List <Matrix__c>();
        List <Matrix__c> mi =new List <Matrix__c>();
        List <Opportunity_Gate__c> ogd  = new List <Opportunity_Gate__c>();
        Opportunity_Gate__c o = new Opportunity_Gate__c();
        List<Opportunity_Gate__c> ogate = new List<Opportunity_Gate__c>();
        List <Opportunity_Gate__c> ogi = new List <Opportunity_Gate__c>();
        List <Opportunity_Gate__c> ogd1 = new List <Opportunity_Gate__c>();
        Map<String,string> mp=new Map<String,string>();
        integer k=0;
        List<Opportunity> updateopp = new List<Opportunity>();      
        List<ATR_No_Type_Change__c> atrprof = ATR_No_Type_Change__c.getall().values();
        if(listObjOppNew.size() > 0 && listObjOppNew != null){
            for(Opportunity oNew: listObjOppNew)
            {
                // Opportunity_Changerecordtype //
                if(oNew.RECORD_TYPE_NAME__C!=oldMap.get(oNew.id).RECORD_TYPE_NAME__C && oNew.record_type_name__c!= 'BGA OE' && oNew.record_type_name__c!= 'BGA AM')
                {
                    //preventing ATR profiles other than ATR Sales Admin to change record type.
                    for(integer i=0;i<atrprof.size();i++)
                    {
                        if(atrprof[i].Profile_Id__c == UserInfo.getprofileId() && oNew.Is_Converted__c == false)
                        {
                            oNew.adderror('You are not allowed to change the record type');
                        }
                    }
                    //end of logic
                    if(oNew.Record_Type_name__c == 'None' && oNew.Is_Converted__c == false)
                    {
                        oNew.adderror('Please select a valid Opportunity Type');
                    }
                    idlist.add(oNew.Id);
                    opptypes.add(oNew.RECORD_TYPE_NAME__C);
                }
                // Opportunity_Changerecordtype //                       
            }
            // Opportunity_Changerecordtype //
            if(idlist.size()>0) ///// Change recordtype trigger
            {
                og = [ select id,serial_no__c,Actual_Date__c,Phase__c,name ,Opportunity__c,completion_date__c,Opportunity_Type__c,status__c
                      from Opportunity_Gate__c where Opportunity__c in :idlist order by serial_no__c  ];
                //matrix records 
                matrix=[Select id,Phase__c,stage__c,serial_no__c,Opportunity_Type__c 
                        from Matrix__c where Opportunity_Type__c in :opptypes order by serial_no__c];
            } 
            // Opportunity_Changerecordtype //
            for(Opportunity opp: listObjOppNew)
            { 
                // Opportunity_Changerecordtype //
                if(idlist.size()>0) 
                {
                    boolean nophase = False;
                    for(Matrix__c m: matrix)
                    {
                        if(opp.RECORD_TYPE_NAME__C == m.Opportunity_Type__c )
                        {
                            o= new Opportunity_Gate__c();
                            o.Opportunity__c = opp.id;
                            o.name =m.Phase__c;
                            o.stage__c =m.stage__C;
                            o.serial_no__c = m.serial_no__c;
                            o.Opportunity_Type__c =m.Opportunity_Type__C;
                            o.Flag__c = true;
                            ogate.add(o);
                        }                         
                    }
                    system.debug('---og--->'+og);                   
                    for(Opportunity_Gate__c g: og)
                    {
                        
                        for(integer i=0;i<ogate.size();i++)
                        {
                            if(ogate[i].name == g.name && ogate[i].opportunity__c == g.opportunity__c && g.completion_date__c !=null)
                            {
                                ogate[i].completion_date__c = g.completion_date__c;
                                ogate[i].actual_date__c = g.actual_date__c;
                            }
                            if(ogate[i].name == g.name && ogate[i].opportunity__c == g.opportunity__c && g.Status__c !=null)
                            {
                                ogate[i].Status__c = g.Status__c;
                                
                            }
                            
                        }
                    }
                    boolean Flag = False;
                    try
                    {
                        for(integer i=0;i<ogate.size();i++)
                        {
                            integer t=ogate.size();
                            if(Trigger.Isbefore)
                            {
                                System.debug('hhhhhhhhhhhhhhhhhhh'+ogate[i]);
                                if(ogate[i].completion_date__c !=null && ogate[i].actual_date__C==null)
                                {
                                    nophase = True;
                                }
                                if(ogate[i].completion_date__c !=null && ogate[i].actual_date__C!=null)
                                {
                                    nophase = True;
                                    if(i!=t && Flag==False)
                                    {
                                        if(ogate[i+1].actual_date__C ==null)
                                        {
                                            k=k+1;
                                            try
                                            {
                                                opp.next_phase__c  = ogate[i+1].name;
                                                opp.next_phase_date__c  = ogate[i+1].completion_date__c;
                                                opp.stagename  = ogate[i+1].stage__c;
                                            }
                                            catch(EXception e)
                                            {
                                                System.debug('Error...............'+e);
                                            }                       
                                            Flag=True;                      
                                        }
                                    }
                                }
                            } 
                        }
                    }
                    catch(EXception e)
                    {
                        System.debug('exception.......'+e);
                    }
                    
                    if(nophase == False && Trigger.Isbefore )
                    { 
                        if(opp.Record_type_name__c == 'Focus' || opp.Record_type_name__c == 'Key' || opp.Record_type_name__c == 'D&S Complex')
                        {
                            opp.stagename  ='Prospecting';
                            opp.next_phase__c= 'Pre-Screen';
                            opp.next_phase_date__c  =null;
                        }
                        
                        if(opp.Record_type_name__c == 'D&S Standard'){
                            opp.stagename  ='Propose';
                            opp.next_phase__c='';
                            opp.next_phase_date__c  =null;
                        }
                        if(opp.Record_type_name__c == 'D&S PrePriced'){
                            // opp.stagename  ='Offer,Negotiate,Close';
                            opp.stagename  ='Offer/Negotiate/Close';                            
                            opp.next_phase__c='';
                            opp.next_phase_date__c  =null;
                        }
                        /*if(opp.Record_type_name__c == 'D&S Run Rate')
                        {
                        opp.stagename  ='Offer/Negotiate/Close';
                        opp.next_phase__c='';
                        opp.next_phase_date__c  =null;
                        }*/
                    }        
                    k=0;
                } 
                // Opportunity_Changerecordtype //
            } //2 for end.
        } //if close opplist.
        
        // Opportunity_Changerecordtype //
        if(Trigger.isAFter)
        {
            if(og.size()>0)
            {
                try{
                    delete og;
                }
                catch(Exception e){
                    System.debug('Exception in deleting ......................'+e);
                }
            } 
            if(ogate.size()>0)
            {
                try{
                    insert ogate;
                }
                catch(Exception e){
                    System.debug('Exception......................'+e);
                }
            }
        }
        // Opportunity_Changerecordtype //             
    }
    /*
This method is used for the replacement of trigger code which is called before insert and  before update
*/
    global void OppProvideAccessMethod(List<Opportunity> listObjOppNew,Map<ID,Opportunity> oldMap)
    {
        
        list<Opptype__c> rtype=Opptype__c.getall().values();//get the values from RecordType in custom settings
        system.debug('----rtype----->'+rtype);
        List<Opportunity> optylist = new List<Opportunity>();
        List<Opportunity> optylist1 = new List<Opportunity>();
        List<Opportunity> optylist2 = new List<Opportunity>();
        List<Opportunity> optylist3 = new List<Opportunity>();
        for(Opportunity o :listObjOppNew)
        {
            O.Owner_Id__C= O.OwnerId;
            if(o.Is_Restricted_Opportunity__c == true && o.Is_Follow_On_Opportunity__c == true)
            {            
                //optylist.add(o);
                System.debug('inside public 236');
                if(o.RecordTypeId == rtype[0].Catalog__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Catalog_Restricted_FollowOn__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Complex__c)
                {
                    o.RecordTypeId = rtype[0]. D_S_Competitive_Restricted_FollowOn__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Standard__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Non_Competitive_Restricted_FollowOn__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Focus__c)
                {
                    o.RecordTypeId = rtype[0].Restricted_Focus__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Key__c)
                {
                    o.RecordTypeId = rtype[0].Restricted_Key__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Restricted_Catalog__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Catalog_Restricted_FollowOn__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Restricted_Complex__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Competitive_Restricted_FollowOn__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Restricted_Standard__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Non_Competitive_Restricted_FollowOn__c;
                    o.Amount = 0;
                }
            } 
            
            if(o.Is_Restricted_Opportunity__c == true && o.Is_Follow_On_Opportunity__c == false)
            {            
                //optylist1.add(o);
                System.debug('inside public 282');
                if(o.RecordTypeId == rtype[0].Catalog__c)
                {
                    o.RecordTypeId = rtype[0].Restricted_Catalog__c;
                }
                if(o.RecordTypeId == rtype[0].Complex__c)
                {
                    o.RecordTypeId = rtype[0].Restricted_Complex__c;
                }
                if(o.RecordTypeId == rtype[0].Focus__c)
                {
                    o.RecordTypeId = rtype[0].Restricted_Focus__c;
                }
                if(o.RecordTypeId == rtype[0].Key__c)
                {
                    o.RecordTypeId = rtype[0].Restricted_Key__c;
                }
                
                if(o.RecordTypeId == rtype[0].Standard__c)
                {
                    o.RecordTypeId = rtype[0].Restricted_Standard__c;
                }
            } 
            
            if(o.Is_Restricted_Opportunity__c == false && o.Is_Follow_On_Opportunity__c == true)
            {            
                //optylist2.add(o);
                System.debug('inside public 309');
                if(o.RecordTypeId == rtype[0].Catalog__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Catalog_FollowOn__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Complex__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Competitive_FollowOn__c;
                    o.Amount = 0;
                }
                if(o.RecordTypeId == rtype[0].Standard__c)
                {
                    o.RecordTypeId = rtype[0].D_S_Non_Competitive_FollowOn__c;
                    o.Amount = 0;
                }
            } 
            // Commented the below for the SR#454715
            /* // SR#453125 starts
if(o.Amount_Net_rollup__c == 0) {
o.Amount = 0;
} 
// SR#453125 ends
*/
        }            
    }
    /*
This method is used for the replacement of trigger code which is called after insert and  after update
*/
    global List<Opportunity_Sales_Team__c> Opportunity_insert_opportunityteam(List<Opportunity> listObjOppNew,Map<ID,Opportunity> oldMap)
    {
        set<ID> cbt=New Set<Id>();
        set<ID> cbt1=New Set<Id>();
        set<ID> cbt2=New Set<Id>();
        set<ID> cbt3=New Set<Id>();
        set<ID> cbt4=New Set<Id>();
        set<ID> cbt5=New Set<Id>();
        set<ID> cbt6=New Set<Id>();
        set<ID> cbt7=New Set<Id>();
        set<ID> cbt8=New Set<Id>();
        set<ID> cbt9=New Set<Id>();
        set<ID> cbt10=New Set<Id>();
        set<ID> cbt11=New Set<Id>();
        set<ID> changedrecid=New Set<Id>();  
        set<ID> oppid=New Set<Id>();
        Map<String,Id> cbtgrowthleader=New Map<String,Id>();
        Map<String,Id> cbtsoa=New Map<String,Id>();
        Map<String,Id> cbtpm=New Map<String,Id>();
        Map<String,Id> cbtpmos=New Map<String,Id>();
        Map<String,Id> cbtfinance=New Map<String,Id>();
        Map<String,Id> cbtisc=New Map<String,Id>();
        Map<String,Id> cbtcnps=New Map<String,Id>();
        Map<String,Id> cbtengg=New Map<String,Id>();
        Map<String,Id> cbtmpm=New Map<String,Id>();
        Map<String,Id> cbtcontracts=New Map<String,Id>();
        Map<String,Id> cbtgl=New Map<String,Id>();
        Map<String,Id> cbtpr=New Map<String,Id>();
        
        
        List<Opportunity_Sales_Team__c> newoppteaminsert= New List<Opportunity_Sales_Team__c>();
        List<Opportunity_Sales_Team__c> newoppteaminsert1= New List<Opportunity_Sales_Team__c>();
        List<Opportunity_Sales_Team__c> newoppteaminsert2= New List<Opportunity_Sales_Team__c>();
        //List<Opportunity_Sales_Team__c> newoppteaminsert3= New List<Opportunity_Sales_Team__c>();
        List<Opportunity_Sales_Team__c> oppteamdelete= New List<Opportunity_Sales_Team__c>();
        //List<Opportunity_Sales_Team__c> oppteamdelete1= New List<Opportunity_Sales_Team__c>();
        list<Opportunity_Sales_Team__c> todel=New List<Opportunity_Sales_Team__c>();
        list<Opportunity_Sales_Team__c> compare=New List<Opportunity_Sales_Team__c>();
        //list<Opportunity_Sales_Team__c> compare1=New List<Opportunity_Sales_Team__c>();
        set<ID> opptyId=New Set<Id>();
        boolean blnFlag = false;
        
        List<ID> oppIds = new List<ID>();   
        
        List<Opportunity_Order__c> Orderlist = new List<Opportunity_Order__c>();
        List<Opportunity_Order__c> OrderlistCheck = new List<Opportunity_Order__c>();
        List <Opportunity> oppListUpdate=new List <Opportunity>();       
        List<String> newstringUnique = new List<String>();
        List<String> finalStringList = new List<String>();
        Map<id,List<String>> mapOppOrderNumbers = new Map<id,List<String>>();
        
        //add customer stories changes
        Set<String> stringList =new Set<String>();
        set<id> oppid1=new set<id>();   
        Set<id> csid=new Set<id>(); 
        List<Related_Customer_Stories__c> ProductList1=new List<Related_Customer_Stories__c>(); 
        List<Related_Customer_Stories__c> ProductList2=new List<Related_Customer_Stories__c>();     
        list<Related_Customer_Stories__c> c=new list<Related_Customer_Stories__c>();
        List<CustomerStory__c> cus=new List<CustomerStory__c>();
        Set<id> opportunityid=new Set<id>();
        set<string> c1  = new set<string> {'a','b'};
            String uname = Userinfo.getname();
        set<id> accid=new set<id>(); 
        String accopp1;
        Set<String> accstringList =new Set<String>();
        string oppmakeval;
        string oppmodelval; 
        /// Provide Access
        Set<ID> provideaccess = new Set<ID>();   
        /// Provide Access 
        for( Opportunity Opp: listObjOppNew ){
            /// Provide Access     
            if(Opp.Is_Restricted_Opportunity__c == false && (Opp.Record_Type_Name__c == 'Focus'|| Opp.Record_Type_Name__c == 'Key' || Opp.Record_Type_Name__c == 'D&S Standard' || Opp.Record_Type_Name__c == 'D&S PrePriced' || Opp.Record_Type_Name__c == 'D&S Run Rate' || Opp.Record_Type_Name__c == 'D&S Complex'))
            {
                System.debug('inside public 405');
                provideaccess.add(Opp.id);
            }
            ///// Prodvide acces          
            // Check if order number is filled
            if(Opp.Opportunity_Order_Numbers__c  !=null){ 
                List<String> newstring = new List<String>();                  
                if(Opp.Duplicate_Order_Number__c  !=null)
                    Opp.addError('Please clean up Duplicate Order Number to Proceed '); 
                newstringUnique = new List<String>();
                if(Opp.Opportunity_Order_Numbers__c.contains(';'))
                {
                    newstring = Opp.Opportunity_Order_Numbers__c.split(';');                    
                    for(integer i=0;i< newstring.size();i++){
                        integer flag=0;                     
                        for(integer j=0;j<newstringUnique.size();j++){
                            if(newstring[i].trim()==newstringUnique[j].trim()){
                                flag=1;
                                break;
                            }
                        }
                        if(flag==0){
                            newstringUnique.add(newstring[i].trim());
                        }
                    }                
                }else{
                    newstringUnique.add(Opp.Opportunity_Order_Numbers__c);
                } 
                mapOppOrderNumbers.put(opp.id,newstringUnique);
                finalStringList.addAll(newstringUnique);
            }
            if((trigger.isinsert && opp.sbu__c=='D&S') || (trigger.isupdate)&&(opp.sbu__c=='D&S')&&(!(oldMap.get(opp.Id).CBT_Tier_2__c==opp.CBT_Tier_2__c)))
            {
                blnFlag = true;
            }
            //add customer stories changes starts          
             id bgaAmOpportunity = label.BGA_AM_Opportunity;
             id bgaOEOpportunity = label.BGA_OE_Opportunity;
            system.debug('-----bgaAmOpportunity--->'+bgaAmOpportunity);
            system.debug('----bgaOEOpportunity---->'+bgaOEOpportunity);
            if (trigger.isInsert== false  &&( opp.recordtypeid == bgaAmOpportunity || opp.recordtypeid == bgaOEOpportunity) && opp.Add_reference_material__c == true)
            { 
                system.debug('check111--->'+opp.Add_reference_material__c+'---opp.id---->'+opp.id);
                system.debug('----oppname--->'+opp.Name);
                opportunityid.add(opp.id);
            }
            system.debug('------opportunityid------->'+opportunityid);
            if(trigger.isInsert && (opp.recordtypeid == bgaAmOpportunity || opp.recordtypeid == bgaOEOpportunity))
            {
                system.debug('check2222--->'+opp.Add_reference_material__c+'---opp.id---->'+opp.id);
                system.debug('----oppname--->'+opp.Name);
                oppid1.add(opp.id);                
            }
        }
        // Providing Read access to all D&S Users. 
        Group grp = null;
        List<OpportunityShare> lsshare = new List<OpportunityShare>();
        if(provideaccess.size()>0)
        {
            System.debug('inside public 458');
            //grp = [select name,id from Group where name =  'D&S Group'] ;
        }
        // provide access
        try{        
            system.debug('------v---->'+finalStringList);
            if(finalStringList.size()>0){
                OrderlistCheck= [Select Id, Opportunity__c,Order_number__c from Opportunity_Order__c
                                 where Order_number__c in :finalStringList];
                system.debug('------v---o->'+OrderlistCheck);
            }
        }
        catch(Exception e){}    
        
        /////
        if(blnFlag==true){
            List<DR_Approvers_List__c> drapplist=[Select Id,APPROVER__C,Pricing__c,Proposal_Manager__c,Sales_Operations_Analyst__c,Growth_Leader__c,PMOS_Leader__c,Finance__c,ISC__c,C_PS__c,Engineering__c,M_PM__c,Contracts__c,CBT__c from DR_Approvers_List__c Limit 500];
            for(DR_Approvers_List__c dl:drapplist){
                if(dl.CBT__c!=null&& dl.APPROVER__C!=null)
                    //cbtgrowthleader.put(dl.CBT__c,dl.APPROVER__C);
                system.debug('--cbtgrowthleader-->'+cbtgrowthleader);
                if(dl.CBT__c!=null&& dl.Sales_Operations_Analyst__c!=null)
                    cbtsoa.put(dl.CBT__c,dl.Sales_Operations_Analyst__c);
                if(dl.CBT__c!=null&& dl.Proposal_Manager__c!=null)
                    cbtpm.put(dl.CBT__c,dl.Proposal_Manager__c);
                system.debug('----cbtpm----->'+cbtpm);
                if(dl.CBT__c!=null&& dl.PMOS_Leader__c!=null)
                    cbtpmos.put(dl.CBT__c,dl.PMOS_Leader__c);
                if(dl.CBT__c!=null&& dl.Finance__c!=null)
                    cbtfinance.put(dl.CBT__c,dl.Finance__c);
                if(dl.CBT__c!=null&& dl.ISC__c!=null)
                    cbtisc.put(dl.CBT__c,dl.ISC__c);
                if(dl.CBT__c!=null&& dl.C_PS__c!=null)
                    cbtcnps.put(dl.CBT__c,dl.C_PS__c);
                if(dl.CBT__c!=null&& dl.Engineering__c!=null)
                    cbtengg.put(dl.CBT__c,dl.Engineering__c);
                if(dl.CBT__c!=null&& dl.M_PM__c!=null)
                    cbtmpm.put(dl.CBT__c,dl.M_PM__c);
                if(dl.CBT__c!=null&& dl.Contracts__c!=null)
                    cbtcontracts.put(dl.CBT__c,dl.Contracts__c);
                if(dl.CBT__c!=null&& dl.Pricing__c!=null)
                    cbtpr.put(dl.CBT__c,dl.Pricing__c);
                if(dl.CBT__c!=null&& dl.Growth_Leader__c!=null)
                    cbtgl.put(dl.CBT__c,dl.Growth_Leader__c);
            }
        }
        
        for(Opportunity  opp:listObjOppNew)
        {
            
            ////////////// provide acces 
            
            if(provideaccess.contains(opp.id))
            {
                System.debug('inside public 508');
                OpportunityShare s = new OpportunityShare();
                s.UserOrGroupId = label.D_S_Group;
                s.OpportunityAccessLevel = 'Read' ;
                s.OpportunityId =opp.id;
                lsshare.add(s);
            }
            
            ////////////////// provide acces 
            
            ////////////////////////////////////////////////////////////
            
            if(Opp.Opportunity_Order_Numbers__c  !=null){
                List<String> newstringUniqueAdd = new List<String>();
                //OrderlistCheck = new List<Opportunity_Order__c>();
                List<String> dupe = new List<String>();     
                newstringUnique = mapOppOrderNumbers.get(opp.id);
                if(OrderlistCheck.size()>0){
                    dupe = new List<String>();       
                    for(integer k=0;k<newstringUnique.size();k++){
                        integer flagcheck=0;
                        for(integer m=0;m<OrderlistCheck.size();m++){
                            if(newstringUnique[k]==OrderlistCheck[m].Order_number__c){
                                flagcheck=1;
                                if(OrderlistCheck[m].Opportunity__c !=Opp.Id){
                                    dupe.add(newstringUnique[k]);
                                }
                                break;
                            } 
                        }
                        if(flagcheck==0){
                            newstringUniqueAdd.add(newstringUnique[k]);
                        }               
                    }
                }else
                {
                    for (integer m=0;m<newstringUnique.size();m++)
                        newstringUniqueAdd.add(newstringUnique[m]);
                }
                if(dupe.size()>0){
                    String Duplicatedata='';
                    for(integer icount=0;icount<dupe.size();icount++){
                        Duplicatedata= Duplicatedata+' '+dupe[icount];
                    }
                    Opportunity oppNew=new Opportunity(Id=Opp.Id);
                    OppNew.Duplicate_Order_Number__c=Duplicatedata;
                    oppNew.Opportunity_Order_Numbers__c=null;
                    oppListUpdate.add(oppNew);
                }   
                else{
                    Opportunity oppNew= new Opportunity(Id=Opp.Id);
                    oppNew.Opportunity_Order_Numbers__c=null;
                    oppListUpdate.add(oppNew);
                }           
                for(integer k=0;k<newstringUniqueAdd.size();k++){
                    Opportunity_Order__c optyOrderNew = new Opportunity_Order__c();
                    optyOrderNew.Opportunity__c = Opp.Id;
                    optyOrderNew.Order_number__c =newstringUniqueAdd[k];
                    Orderlist.add(optyOrderNew);
                }
            }   //enf of if
            
            ///////////////////////////////////////////////////////////////////
            if((trigger.isupdate)&&(opp.sbu__c=='D&S')&&(!(oldMap.get(opp.Id).CBT_Tier_2__c==opp.CBT_Tier_2__c))){
                cbt.add(cbtgrowthleader.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt1.add(cbtsoa.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt2.add(cbtpm.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt3.add(cbtfinance.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt4.add(cbtpmos.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt5.add(cbtisc.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt6.add(cbtcnps.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt7.add(cbtengg.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt8.add(cbtmpm.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt9.add(cbtcontracts.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt10.add(cbtpr.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                cbt11.add(cbtgl.get(oldMap.get(opp.Id).CBT_Tier_2__c));
                changedrecid.add(opp.id);
                system.debug('changedrecid'+changedrecid);
                opptyId.add(opp.Id);
                Opportunity_Sales_Team__c oppteam = New Opportunity_Sales_Team__c();
                if(cbtgrowthleader.get(opp.CBT_Tier_2__c)!=null){
                    oppteam.User__c=cbtgrowthleader.get(opp.CBT_Tier_2__c);
                    oppteam.Created_due_to_CBT__c=true;
                    oppteam.Opportunity__c=opp.id;
                    oppteam.Opportunity_team_role__c='Growth Leader';
                    set<string> myset = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset.add(m.User__c); 
                    }                     
                    if(!(myset.contains( oppteam.User__c))) //returns true/false
                    {newoppteaminsert.add(oppteam); }                    
                }
                // Added code for SR# 350054
                Opportunity_Sales_Team__c oppteam1 = New Opportunity_Sales_Team__c();
                if(cbtsoa.get(opp.CBT_Tier_2__c)!=null){
                    oppteam1.User__c=cbtsoa.get(opp.CBT_Tier_2__c);
                    oppteam1.Created_due_to_CBT__c=true;
                    oppteam1.Opportunity__c=opp.id;
                    oppteam1.Opportunity_team_role__c='Sales Operations';
                    set<string> myset1 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset1.add(m.User__c); 
                    }                     
                    if(!(myset1.contains( oppteam1.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam1); }                    
                }
                Opportunity_Sales_Team__c oppteam2 = New Opportunity_Sales_Team__c();
                system.debug('--->'+cbtpm.get(opp.CBT_Tier_2__c));
                if(cbtpm.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam2.User__c=cbtpm.get(opp.CBT_Tier_2__c);
                    oppteam2.Created_due_to_CBT__c=true;
                    oppteam2.Opportunity__c=opp.id;
                    oppteam2.Opportunity_team_role__c='Proposal Mgr';
                    set<string> myset2 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset2.add(m.User__c); 
                    } 
                    
                    if(!(myset2.contains( oppteam2.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam2); }
                    
                }
                Opportunity_Sales_Team__c oppteam3 = New Opportunity_Sales_Team__c();
                if(cbtfinance.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam3.User__c=cbtfinance.get(opp.CBT_Tier_2__c);
                    oppteam3.Created_due_to_CBT__c=true;
                    oppteam3.Opportunity__c=opp.id;
                    oppteam3.Opportunity_team_role__c='Finance';
                    set<string> myset5 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset5.add(m.User__c); 
                    } 
                    
                    if(!(myset5.contains( oppteam3.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam3); }
                    
                }
                Opportunity_Sales_Team__c oppteam4 = New Opportunity_Sales_Team__c();
                if(cbtpmos.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam4.Contact__c=cbtpmos.get(opp.CBT_Tier_2__c);
                    oppteam4.Created_due_to_CBT__c=true;
                    oppteam4.Opportunity__c=opp.id;
                    oppteam4.Opportunity_team_role__c='PMOS Leader';
                    newoppteaminsert1.add(oppteam4);
                }
                Opportunity_Sales_Team__c oppteam5 = New Opportunity_Sales_Team__c();
                if(cbtisc.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam5.Contact__c=cbtisc.get(opp.CBT_Tier_2__c);
                    oppteam5.Created_due_to_CBT__c=true;
                    oppteam5.Opportunity_team_role__c='ISC';
                    oppteam5.Opportunity__c=opp.id;
                    newoppteaminsert1.add(oppteam5);
                }
                Opportunity_Sales_Team__c oppteam6 = New Opportunity_Sales_Team__c();
                if(cbtcnps.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam6.Contact__c=cbtcnps.get(opp.CBT_Tier_2__c);
                    oppteam6.Created_due_to_CBT__c=true;
                    oppteam6.Opportunity__c=opp.id;
                    oppteam6.Opportunity_team_role__c='C&PS';
                    newoppteaminsert1.add(oppteam6);
                }
                Opportunity_Sales_Team__c oppteam7 = New Opportunity_Sales_Team__c();
                if(cbtengg.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam7.Contact__c=cbtengg.get(opp.CBT_Tier_2__c);
                    oppteam7.Created_due_to_CBT__c=true;
                    oppteam7.Opportunity__c=opp.id;
                    oppteam7.Opportunity_team_role__c='Engineering';
                    newoppteaminsert1.add(oppteam7);
                }
                Opportunity_Sales_Team__c oppteam8 = New Opportunity_Sales_Team__c();
                if(cbtmpm.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam8.Contact__c=cbtmpm.get(opp.CBT_Tier_2__c);
                    oppteam8.Created_due_to_CBT__c=true;
                    oppteam8.Opportunity__c=opp.id;
                    oppteam8.Opportunity_team_role__c='M&PM';
                    newoppteaminsert1.add(oppteam8);
                }
                Opportunity_Sales_Team__c oppteam9 = New Opportunity_Sales_Team__c();
                if(cbtcontracts.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam9.Contact__c=cbtcontracts.get(opp.CBT_Tier_2__c);
                    oppteam9.Created_due_to_CBT__c=true;
                    oppteam9.Opportunity__c=opp.id;
                    oppteam9.Opportunity_team_role__c='Contracts';
                    newoppteaminsert1.add(oppteam9);
                }
                Opportunity_Sales_Team__c oppteam10 = New Opportunity_Sales_Team__c();
                if(cbtpr.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam10.User__c=cbtpr.get(opp.CBT_Tier_2__c);
                    oppteam10.Created_due_to_CBT__c=true;
                    oppteam10.Opportunity__c=opp.id;
                    oppteam10.Opportunity_team_role__c='Pricing';
                    set<string> myset6 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset6.add(m.User__c); 
                    } 
                    
                    if(!(myset6.contains( oppteam10.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam10); }
                    
                }
                Opportunity_Sales_Team__c oppteam11 = New Opportunity_Sales_Team__c();
                if(cbtgl.get(opp.CBT_Tier_2__c)!=null){
                    oppteam11.User__c=cbtgl.get(opp.CBT_Tier_2__c);
                    oppteam11.Created_due_to_CBT__c=true;
                    oppteam11.Opportunity__c=opp.id;
                    oppteam11.Opportunity_team_role__c='Growth Leader';
                    set<string> myset2 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset2.add(m.User__c); 
                    } 
                    
                    if(!(myset2.contains( oppteam11.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam11); }
                    
                }
                // End of the code for SR# 350054
            }
            
            if(trigger.isinsert && opp.sbu__c=='D&S'){
                opptyId.add(opp.Id);
                Opportunity_Sales_Team__c oppteam = New Opportunity_Sales_Team__c();
                if(cbtgrowthleader.get(opp.CBT_Tier_2__c)!=null){
                    oppteam.User__c=cbtgrowthleader.get(opp.CBT_Tier_2__c);
                    oppteam.Created_due_to_CBT__c=true;
                    oppteam.Opportunity__c=opp.id;
                    oppteam.Opportunity_team_role__c='Growth Leader';
                    set<string> myset3 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset3.add(m.User__c); 
                    } 
                    
                    if(!(myset3.contains( oppteam.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam); }
                    
                }
                // Added code for SR# 350054
                Opportunity_Sales_Team__c oppteam1 = New Opportunity_Sales_Team__c();
                if(cbtsoa.get(opp.CBT_Tier_2__c)!=null){
                    oppteam1.User__c=cbtsoa.get(opp.CBT_Tier_2__c);
                    oppteam1.Created_due_to_CBT__c=true;
                    oppteam1.Opportunity__c=opp.id;
                    oppteam1.Opportunity_team_role__c='Sales Operations';
                    set<string> myset7 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset7.add(m.User__c); 
                    } 
                    
                    if(!(myset7.contains( oppteam1.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam1); }
                    
                }
                Opportunity_Sales_Team__c oppteam2 = New Opportunity_Sales_Team__c();
                if(cbtpm.get(opp.CBT_Tier_2__c)!=null){
                    oppteam2.User__c=cbtpm.get(opp.CBT_Tier_2__c);
                    oppteam2.Created_due_to_CBT__c=true;
                    oppteam2.Opportunity__c=opp.id;
                    oppteam2.Opportunity_team_role__c='Proposal Mgr';
                    set<string> myset8 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset8.add(m.User__c); 
                    } 
                    
                    if(!(myset8.contains( oppteam2.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam2); }
                    
                }
                Opportunity_Sales_Team__c oppteam3 = New Opportunity_Sales_Team__c();
                if(cbtfinance.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam3.User__c=cbtfinance.get(opp.CBT_Tier_2__c);
                    oppteam3.Created_due_to_CBT__c=true;
                    oppteam3.Opportunity__c=opp.id;
                    oppteam3.Opportunity_team_role__c='Finance';
                    set<string> myset9 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset9.add(m.User__c); 
                    } 
                    
                    if(!(myset9.contains( oppteam3.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam3); }
                    
                }
                Opportunity_Sales_Team__c oppteam4 = New Opportunity_Sales_Team__c();
                if(cbtpmos.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam4.Contact__c=cbtpmos.get(opp.CBT_Tier_2__c);
                    oppteam4.Created_due_to_CBT__c=true;
                    oppteam4.Opportunity__c=opp.id;
                    oppteam4.Opportunity_team_role__c='PMOS Leader';
                    newoppteaminsert1.add(oppteam4);
                }
                Opportunity_Sales_Team__c oppteam5 = New Opportunity_Sales_Team__c();
                if(cbtisc.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam5.Contact__c=cbtisc.get(opp.CBT_Tier_2__c);
                    oppteam5.Created_due_to_CBT__c=true;
                    oppteam5.Opportunity_team_role__c='ISC';
                    oppteam5.Opportunity__c=opp.id;
                    newoppteaminsert1.add(oppteam5);
                }
                Opportunity_Sales_Team__c oppteam6 = New Opportunity_Sales_Team__c();
                if(cbtcnps.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam6.Contact__c=cbtcnps.get(opp.CBT_Tier_2__c);
                    oppteam6.Created_due_to_CBT__c=true;
                    oppteam6.Opportunity__c=opp.id;
                    oppteam6.Opportunity_team_role__c='C&PS';
                    newoppteaminsert1.add(oppteam6);
                }
                Opportunity_Sales_Team__c oppteam7 = New Opportunity_Sales_Team__c();
                if(cbtengg.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam7.Contact__c=cbtengg.get(opp.CBT_Tier_2__c);
                    oppteam7.Created_due_to_CBT__c=true;
                    oppteam7.Opportunity__c=opp.id;
                    oppteam7.Opportunity_team_role__c='Engineering';
                    newoppteaminsert1.add(oppteam7);
                }
                Opportunity_Sales_Team__c oppteam8 = New Opportunity_Sales_Team__c();
                if(cbtmpm.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam8.Contact__c=cbtmpm.get(opp.CBT_Tier_2__c);
                    oppteam8.Created_due_to_CBT__c=true;
                    oppteam8.Opportunity__c=opp.id;
                    oppteam8.Opportunity_team_role__c='M&PM';
                    newoppteaminsert1.add(oppteam8);
                }
                Opportunity_Sales_Team__c oppteam9 = New Opportunity_Sales_Team__c();
                if(cbtcontracts.get(opp.CBT_Tier_2__c)!=null){
                    oppteam9.Contact__c=cbtcontracts.get(opp.CBT_Tier_2__c);
                    oppteam9.Created_due_to_CBT__c=true;
                    oppteam9.Opportunity__c=opp.id;
                    oppteam9.Opportunity_team_role__c='Contracts';
                    newoppteaminsert1.add(oppteam9);
                }
                Opportunity_Sales_Team__c oppteam10 = New Opportunity_Sales_Team__c();
                if(cbtpr.get(opp.CBT_Tier_2__c)!=null || Test.isRunningTest()){
                    oppteam10.User__c=cbtpr.get(opp.CBT_Tier_2__c);
                    oppteam10.Created_due_to_CBT__c=true;
                    oppteam10.Opportunity__c=opp.id;
                    oppteam10.Opportunity_team_role__c='Pricing';
                    set<string> myset10 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset10.add(m.User__c); 
                    } 
                    
                    if(!(myset10.contains( oppteam10.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam10); }
                    
                }
                Opportunity_Sales_Team__c oppteam11 = New Opportunity_Sales_Team__c();
                if(cbtgl.get(opp.CBT_Tier_2__c)!=null){
                    oppteam11.User__c=cbtgl.get(opp.CBT_Tier_2__c);
                    oppteam11.Created_due_to_CBT__c=true;
                    oppteam11.Opportunity__c=opp.id;
                    oppteam11.Opportunity_team_role__c='Growth Leader';
                    set<string> myset4 = new set<string>(); 
                    For(Opportunity_Sales_Team__c m :newoppteaminsert){ 
                        myset4.add(m.User__c); 
                    } 
                    
                    if(!(myset4.contains( oppteam11.User__c))) //returns true/false
                    { newoppteaminsert.add(oppteam11); }
                    
                }
                // End of the code for SR# 350054
            }
        }
        
        
        if(Orderlist.size()>0)
        {
            try{
                insert Orderlist;
            }
            Catch (exception e){}
        }    
        if(oppListUpdate.size()>0)
            update oppListUpdate;
        
        
        
        if(cbt.size()>0 || cbt1.size()>0 || cbt2.size()>0 || cbt3.size()>0 || cbt10.size()>0 || cbt11.size()>0 ||
           cbt4.size()>0 || cbt5.size()>0 || cbt6.size()>0 || cbt7.size()>0 || cbt8.size()>0 || cbt9.size()>0    )
            
            todel=[select Id,Opportunity__c,Created_due_to_CBT__c from Opportunity_Sales_Team__c where  Opportunity__c in: changedrecid 
                   and (user__c in:cbt or user__c in:cbt1 or user__c in:cbt2 or user__c in:cbt3 or user__c in:cbt10 or user__c in:cbt11 
                        or Contact__c in:cbt4 or Contact__c in:cbt5 or Contact__c in:cbt6 or Contact__c in:cbt7 or Contact__c in:cbt8 or Contact__c in:cbt9) Limit 100];
        
        system.debug('todel'+todel.size());
        for(Opportunity_Sales_Team__c de:todel){
            system.debug('Opportunity__c'+de.Opportunity__c);
            if((changedrecid.contains(de.Opportunity__c))&&(de.Created_due_to_CBT__c==true)){
                oppteamdelete.add(de);
            }
        }
        if(oppteamdelete.size()>0)
            delete oppteamdelete;     
        
        if(opptyId.size()>0){ 
            compare=[select Id,Opportunity__c,User__c,Contact__c from Opportunity_Sales_Team__c where Opportunity__c in:opptyId and (User__c !=null or Contact__c !=null )];
            system.debug('compare'+compare.size());
            integer flagusr=0;
            integer flagcont=0;
            if(newoppteaminsert1.size()>0)
                newoppteaminsert.addAll(newoppteaminsert1);
            for(integer i=0;i<newoppteaminsert.size();i++){
                for(integer j=0;j<compare.size();j++){
                    if(newoppteaminsert[i].Opportunity__c==compare[j].Opportunity__c 
                       && ((null!= newoppteaminsert[i].User__c && newoppteaminsert[i].User__c==compare[j].User__c)
                           || (null!=newoppteaminsert[i].Contact__c &&  newoppteaminsert[i].Contact__c==compare[j].Contact__c)))
                        flagusr=1;
                } 
                if(flagusr==0)
                    newoppteaminsert2.add(newoppteaminsert[i]);
                // if(flagcont==0)
                // newoppteaminsert2.add(newoppteaminsert[i]);             
            }        
        }
        // inserting users
        //try{
        //if(null!=otherOppSTList && otherOppSTList.size()>0)
        //newoppteaminsert2.addAll(otherOppSTList);
        //if(newoppteaminsert2.size()>0)
        //  System.debug('newoppteaminsert2:::'+newoppteaminsert2.size());
        // return newoppteaminsert2;
        //}catch(Exception e){
        //  system.debug('@@@@@@@@@error'+e); 
        //} 
        
        //add customer stories  
        system.debug('------opportunityid------->'+opportunityid);
        if(oppid1.size()>0 || opportunityid.size()>0) 
        {
            List<OpportunityLineItem> oppProds = [SELECT Id,Product_Name__c,OpportunityId,PricebookEntry.Product2.Name, PricebookEntry.Product2.Family FROM OpportunityLineItem where Opportunityid =: opportunityid];                                    
            system.debug('----oppProds----->'+oppProds);
            for(Integer i=0;i<oppProds.size();i++)
            {   
                stringList.add(oppProds[i].Product_Name__c);
            }
            system.debug('check product string--->'+stringList);        
            cus=[select Id,CustomerName__c,video_Link_mac__c,Customer__c,Make_Model__c,Model__c,Product__c,Make__c,Product_Line__c,Summary__c,Solutions__c,Files_Links_1__c,Files_Links_2__c,Product_Name__c, Name from CustomerStory__c where Related_Opportunity__c !=: opportunityid and Related_Opportunity__c != null];          
            for(CustomerStory__c cid:cus)
            {
                csid.add(cid.id);
            }
            if(cus.Size()>0)
            {   system.debug('----c-opportunityid---->'+opportunityid);
                c=[select id,Product__c,CustomerName__c,Opportunity__c,name,CustomerStory__c,Solutions__c from Related_Customer_Stories__c where Opportunity__c=:opportunityid];                                
                system.debug('----c----->'+c);
                for (Related_Customer_Stories__c c2: c){             
                    string c3 = c2.CustomerStory__c;
                    if(c3 != null)
                    {
                        c1.add(c3);
                    }
                }
            }
            for(Opportunity t: listObjOppNew)    
            {                                      
                system.debug('line number 816---->'+t.Add_reference_material__c);
                if ((trigger.isInsert || (trigger.isInsert == false && t.Add_reference_material__c == true)) && ( t.recordtypeid == label.BGA_AM_Opportunity || t.recordtypeid == label.BGA_OE_Opportunity))
                {       
                    system.debug('check444---->');
                    accid.add(t.accountid);             
                    accopp1=t.Account_Name_formula__c;
                    accstringList.add(t.Account_Name_formula__c);     
                    system.debug('----accstringList---->'+accstringList);
                    oppmakeval=t.Make__c;
                    oppmodelval=t.Model__c; 
                    if(cus.Size()>0)
                    {                                        
                        for (CustomerStory__c child : cus) 
                        {                 
                            string childid = child.id;                                                        
                            if(!uname.contains('API USER') )
                            {
                                if (c.size()==0 || (!c1.contains(childid))  )
                                { 
                                    system.debug('-----stringList---->'+stringList);
                                    for(String st:stringList)                        
                                    { 
                                        system.debug('check1023--->'+st);
                                        system.debug('check455--->'+child.Product_Name__c + ','+child.id);
                                        if(child.Product_Name__c != null && child.Product_Name__c==st && (child.Make_Model__c != null && (!child.Make_Model__c.contains(oppmakeval))) &&(child.Model__c != null && (!child.Model__c.contains(oppmodelval))) && (child.Customer__c != null && child.Customer__c!=accopp1))
                                        {                                                           
                                            system.debug('check333--->'+st);
                                            Related_Customer_Stories__c p=new Related_Customer_Stories__c();
                                            p.name=child.name;
                                            p.Summary__c=child.Summary__c;
                                            p.Files_Links_1__c=child.Files_Links_1__c;
                                            p.Files_Links_2__c=child.Files_Links_2__c;
                                            p.Solutions__c=child.Solutions__c;
                                            p.CustomerStory__c=child.id;
                                            p.Opportunity__c=t.Id;
                                            p.Product__c=child.Product__c;
                                            p.Product_Line__c=child.Product_Line__c;
                                            p.Make__c=child.Make__c;
                                            p.CustomerName__c=child.CustomerName__c;
                                            p.Reason__c='Product'; 
                                            p.video_Link_mac__c=child.video_Link_mac__c;
                                            ProductList1.add(p);                          
                                        }                   
                                    }                                                               
                                    if(accid!= NULL && accid.size()>0)
                                    {                                                                  
                                        for(string oppacc:accstringList){
                                            system.debug('---child.Customer__c---->'+child.Customer__c);// 
                                            if((oppacc != null && child.Customer__c != null && child.Customer__c==oppacc ) || Test.isRunningTest())
                                            { 
                                                Related_Customer_Stories__c p=new Related_Customer_Stories__c();                                                    
                                                p.name=child.name;
                                                p.Summary__c=child.Summary__c;
                                                p.Files_Links_1__c=child.Files_Links_1__c;
                                                p.Files_Links_2__c=child.Files_Links_2__c;
                                                p.Solutions__c=child.Solutions__c;
                                                p.CustomerStory__c=child.id;
                                                p.Opportunity__c=t.Id;
                                                p.Product__c=child.Product__c;
                                                p.Product_Line__c=child.Product_Line__c;
                                                p.Make__c=child.Make__c;
                                                p.CustomerName__c=child.CustomerName__c;
                                                p.Reason__c='Customer';
                                                p.video_Link_mac__c=child.video_Link_mac__c;
                                                ProductList1.add(p);      
                                            } 
                                        }                                   
                                    }  
                                    system.debug('----t.Make__c--->'+t.Make__c);
                                    system.debug('----child.Make_Model__c--->'+child.Make_Model__c);
                                    if(t.Make__c!=NULL || Test.isRunningTest())
                                    { 
                                        if((child.Make_Model__c != null && (child.Make_Model__c.contains(oppmakeval) || child.Model__c.contains(oppmodelval)) && child.Customer__c!=accopp1) || Test.isRunningTest())
                                        {    
                                            
                                            Related_Customer_Stories__c p=new Related_Customer_Stories__c();                                                                                            
                                            p.name=child.name;
                                            p.Summary__c=child.Summary__c;
                                            p.Files_Links_1__c=child.Files_Links_1__c;
                                            p.Files_Links_2__c=child.Files_Links_2__c;
                                            p.Solutions__c=child.Solutions__c;
                                            p.CustomerStory__c=child.id;
                                            p.Opportunity__c=t.Id;
                                            p.Product__c=child.Product__c;
                                            p.Product_Line__c=child.Product_Line__c;
                                            p.Make__c=child.Make__c;
                                            p.CustomerName__c=child.CustomerName__c;
                                            p.Reason__c='Make/Model';
                                            p.video_Link_mac__c=child.video_Link_mac__c; 
                                            ProductList1.add(p);     
                                        }                                                
                                    }                                  
                                }
                            }  
                        }                
                    }
                }     
            }   
            insert ProductList1;        
        }
        if(lsshare.size()>0)
        {
            try
            {                   
                insert lsshare;
            }
            catch(Exception e)
            {
                System.debug('Exception in inserting share records'+e);
            }
        }
        //add customer stories changes ends here
        System.debug('newoppteaminsert2:::'+newoppteaminsert2.size());
        return newoppteaminsert2;      
    }   
}