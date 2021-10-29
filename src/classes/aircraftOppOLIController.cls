public class aircraftOppOLIController{
    public Map<string,List<wrapper>> strMap{get;set;}
    List<opportunity> oList = new List<opportunity>();
    String oppIds;
    public boolean chk{get;set;}
    public aircraftOppOLIController(ApexPages.StandardController controller) {
        oppIds = ApexPages.CurrentPage().getparameters().get('id');
        System.debug('Opportunity Id-----'+oppIds);
        //getMatchedProduct();
    }
    
    public void getMatchedProduct() {
        //List<opportunity> oppLst = [SELECT Id, Aircraft_Ref__c FROM opportunity WHERE Id in : oppIds];
        Set<Id> aircIds = new Set<Id>();
        String pProduct;
        strMap = new Map<string,List<wrapper>>();
        System.debug('Opportunity Id in Method-----'+oppIds);
        opportunity oppData = [SELECT Id, Aircraft_Ref__c, Package_Product__c, OwnerId, SBU__c FROM opportunity WHERE Id =: oppIds];
        System.debug('Opportunity Id-----'+oppData);
        List<opportunity> oppLst = new List<opportunity>();
        
        pProduct = oppData.Package_Product__c;
        if(oppData.Aircraft_Ref__c !=NULL && oppData.SBU__c == 'BGA'){
            oppLst = [SELECT Id, Aircraft_Ref__c FROM opportunity WHERE Aircraft_Ref__c =:oppData.Aircraft_Ref__c AND SBU__c = 'BGA'];
        }        
        if(oppData.OwnerId !=NULL && oppData.SBU__c == 'ATR'){
            oppLst = [SELECT Id, Aircraft_Ref__c FROM opportunity WHERE OwnerId =:oppData.OwnerId AND SBU__c = 'ATR'];
        }
        System.debug(oppLst.size()+'Aircraft All Opp list is ===='+oppLst);
        for(opportunity oppId : oppLst){
            aircIds.add(oppId.Id);
        }
        System.debug('Aircraft All Opp is ===='+aircIds);
        
        List<OpportunityLineItem> lineItemLst = [SELECT ID, Name, Product2.name, opportunity.isClosed, opportunity.Aircraft_Ref__r.Platform_Name__r.id,Product2Id, OpportunityId, Opportunity.Package_Product_Link__c, Opportunity.SBU__c, Opportunity_Name__c, Opportunity.CBT_Team_Tier_3__c FROM OpportunityLineItem WHERE OpportunityId =: aircIds];      
        System.debug(lineItemLst.size()+'All Line Items==='+lineItemLst);
        String p1;
        String p2;
        String p3;
        String p4;
        String p5;
        Boolean tempp1 = false;
        Boolean tempp2 = false;
        Boolean tempp3 = false;
        Boolean tempp4 = false;
        Boolean tempp5 = false;
        List<String> strlist = new List<String>();
        List<wrapper> oppWrapp = new List<wrapper>();
        String olink;
        String oppName;
        String oppLink;
        List<Packaged_Products__c> ppList = new List<Packaged_Products__c>();
        if(lineItemLst[0].opportunity.SBU__c == 'ATR'){
                ppList = [SELECT Id, Name, Aircraft_Platform__c, Aircraft_Platform__r.Id, CBT_Team1__c, Product_1__r.Name, Product_1__c, Product_2__r.Name, Product_2__c, Product_3__r.Name, Product_3__c, Product_4__r.Name,Product_4__c, Product_5__r.Name, Product_5__c FROM Packaged_Products__c WHERE Name =: pProduct];
        }
        for(OpportunityLineItem oli : lineItemLst){            
            System.debug(oli+'oli size=='+pProduct+'Plateform id==='+oli.opportunity.Aircraft_Ref__r.Platform_Name__r.id);
            if(oli.opportunity.SBU__c == 'BGA'){
                ppList =  [SELECT Id, Name, Aircraft_Platform__c, Aircraft_Platform__r.Id, CBT_Team1__c, Product_1__r.Name, Product_1__c, Product_2__r.Name, Product_2__c, Product_3__r.Name, Product_3__c, Product_4__r.Name,Product_4__c, Product_5__r.Name, Product_5__c FROM Packaged_Products__c WHERE Aircraft_Platform__c =: oli.opportunity.Aircraft_Ref__r.Platform_Name__r.id AND Name =: pProduct];
            }            
            for(Packaged_Products__c pp1:ppList){
                System.debug('All Product---'+pp1);
                Integer i = 0;
                if(pp1.Product_1__c != NULL){
                    i = i+1;
                }
                if(pp1.Product_2__c != NULL){
                    i = i+1;
                }
                if(pp1.Product_3__c != NULL){
                    i = i+1;
                }
                if(pp1.Product_4__c != NULL){
                    i = i+1;
                }
                if(pp1.Product_5__c != NULL){
                    i = i+1;
                }            
                System.debug('The Total Product==='+i);
                
                for(Integer a = 0; a < i; a++){                    
                    if(pp1.Product_1__c != NULL && tempp1 == false){
                        if(pp1.Product_1__c == oli.Product2Id){
                           p1 = pp1.Product_1__r.Name;
                           strMap.remove(p1);                        
                           tempp1 = true;
                        }
                        if(pp1.Product_1__c != oli.Product2Id){
                            if(oli.opportunity.isClosed == false){
                                p1 = pp1.Product_1__r.Name;
                                olink = '/'+oli.OpportunityId;
                                oppName = oli.Opportunity_Name__c;               
                                strMap.put(p1, oppWrapp);
                            }
                        }                        
                    }
                    if(pp1.Product_2__c != NULL && tempp2 == false){
                        if(pp1.Product_2__c == oli.Product2Id){
                           p2 = pp1.Product_2__r.Name;
                           strMap.remove(p2);
                           tempp2 = true;
                        }
                        if(pp1.Product_2__c != oli.Product2Id){
                            if(oli.opportunity.isClosed == false){
                                p2 = pp1.Product_2__r.Name;
                                olink = '/'+oli.OpportunityId;
                                oppName = oli.Opportunity_Name__c;
                                strMap.put(p2, oppWrapp);
                            }
                        }                        
                    }
                    if(pp1.Product_3__c != NULL && tempp3 == false){
                        if(pp1.Product_3__c == oli.Product2Id){
                           p3 = pp1.Product_3__r.Name;
                           strMap.remove(p3);
                           tempp3 = true;
                        }
                        if(pp1.Product_3__c != oli.Product2Id){
                            if(oli.opportunity.isClosed == false){
                                p3 = pp1.Product_3__r.Name;
                                olink = '/'+oli.OpportunityId;
                                oppName = oli.Opportunity_Name__c;
                                strMap.put(p3, oppWrapp);
                            }
                        }                        
                    }
                    if(pp1.Product_4__c != NULL && tempp4 == false){
                        if(pp1.Product_4__c == oli.Product2Id){
                           p4 = pp1.Product_4__r.Name;
                           strMap.remove(p4);
                           tempp4 = true;
                        }
                        if(pp1.Product_4__c != oli.Product2Id){
                            if(oli.opportunity.isClosed == false){
                                p4 = pp1.Product_4__r.Name;
                                olink = '/'+oli.OpportunityId;
                                oppName = oli.Opportunity_Name__c;
                                strMap.put(p4, oppWrapp);
                            }
                        }                        
                    }
                    if(pp1.Product_5__c != NULL && tempp5 == false){
                        if(pp1.Product_5__c == oli.Product2Id){
                           p5 = pp1.Product_5__r.Name;
                           strMap.remove(p5);
                           tempp5 = true;
                        }
                        if(pp1.Product_5__c != oli.Product2Id){
                            if(oli.opportunity.isClosed == false){
                                p5 = pp1.Product_5__r.Name;
                                olink = '/'+oli.OpportunityId;
                                oppName = oli.Opportunity_Name__c;
                                strMap.put(p5, oppWrapp);
                            }
                        }                        
                    }                
                }                
            }
            if(olink != NULL && olink != '' && oli.opportunity.isClosed == false){
                if(!strlist.contains(olink)){
                    oppWrapp.add(new wrapper(olink, oppName));
                    strlist.add(olink);
                }                
            }  
        }
        System.debug(strMap.size()+'The final map is===='+strMap);
        if(strMap.size() == 0){
            chk = true;
            opportunity o = new opportunity();
            o.id = oppIds;
            o.Package_Product_Link__c = '';
            o.Package_Product__c = '';
            oList.add(o);
            System.debug('updte ==='+oList);
            update oList;
        }
    }
    public void updtevale(){
        getMatchedProduct();
        System.debug(strMap+'This opp have mached all product==='+oppIds);        
    }
    public class wrapper{
        Public String olink{get;set;}
        public String pName{get;set;}
        
        // Wrapper class constructor

        public wrapper(String olink, String pName){
            this.olink = olink;
            this.pName = pName;
        }
    }
}