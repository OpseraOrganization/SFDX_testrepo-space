public class GoGreenPlanClass {

    id FeedID,AccID, rtId;
    Go_Green_Plan__c gogreen = new Go_Green_Plan__c();
    Feedback__C feed = new Feedback__c();
    Associated_VOC_Card_Number__C assovoc = new Associated_VOC_Card_Number__c();
    List<Go_Green_Plan__c> greenlist = new List<Go_Green_Plan__c>();
    List<Feedback__c> feedlist = new List<Feedback__c>(); 
    
    public GoGreenPlanClass() {
  /*      FeedID = Apexpages.currentPage().getParameters().get('Id');
        if(FeedID != null){
            feed = [select Year__c, Overall_Satisfaction_VOCSurvey__c, Interviewer_Name__c, SBU__c, Prod_LN_Prgm_Product_LIne__c, Site__c, Supplier_Rating_Syst__c, Contact__c, Contact_Status__c, CBT__c, Market_Name__c,Account__c, SR_S__c, SR_CBT__c, CBT_Team__c from Feedback__c where id =:FeedId ];
        }
         
        if(feed.Overall_Satisfaction_VOCSurvey__c == 'Red - Very Dissatisfied' || feed.Overall_Satisfaction_VOCSurvey__c == 'Yellow - Somewhat Dissatisfied'){       
            gogreen.Year__c = feed.Year__c;
            gogreen.Interviewer_Name__c = feed.Interviewer_Name__c;
            gogreen.Prod_LN_Prgm_Product_LIne__c = feed.Prod_LN_Prgm_Product_LIne__c;
            gogreen.Site__c = feed.Site__c;
            gogreen.Supplier_Rating_Syst__c = feed.Supplier_Rating_Syst__c;
            gogreen.Contact__c = feed.Contact__c;
            gogreen.Account__c = feed.Account__c;
            gogreen.SR_SBU__c = feed.SR_S__c;
            gogreen.SR_CBT__c = feed.SR_CBT__c;
            gogreen.CBT_Team__c = feed.CBT_Team__c;
        
            AccID = feed.Account__c;
            if(AccID != null){
                List<Go_Green_Plan__c> greenlist = new List<Go_Green_Plan__c>();
                List<Feedback__c> feedlist = new List<Feedback__c>();   
                feedlist = [Select id, Quarter__c, Legacy_VOC_Number__c, Go_Green_Yr_Qtr__c, Go_Green_Status__c, Type_Formula__c, Date_of_Interview__c, Report_Flag__c, Locked__c, Overall_Satisfaction_VOCSurvey__c, Overall_Satisfaction_Value__c, createddate from Feedback__c where Account__c =: AccID order by createddate DESC Limit 1];
                if(feedlist.size()>0){
                    system.debug('PPPPPP'+feedlist);
                    gogreen.Quarter__c = feedlist[0].Quarter__c;
                    gogreen.Legacy_VOC_Number__c = feedlist[0].Legacy_VOC_Number__c;
                    gogreen.Go_Green_Yr_Qtr__c = feedlist[0].Go_Green_Yr_Qtr__c;
                    gogreen.Go_Green_Status__c = feedlist[0].Go_Green_Status__c;
                    gogreen.Type__c = feedlist[0].Type_Formula__c;
                    gogreen.Date_of_Interview__c = feedlist[0].Date_of_Interview__c;
                    gogreen.Report_Flag__c = feedlist[0].Report_Flag__c;
                    gogreen.Overall_Calculated_Satisfaction__c = feedlist[0].Overall_Satisfaction_VOCSurvey__c;
                    gogreen.Overall_Calculated_Satisfaction_Value__c = feedlist[0].Overall_Satisfaction_Value__c;
               } 
            }
        }*/
    }

    public GoGreenPlanClass(ApexPages.StandardController controller) {
    FeedID = Apexpages.currentPage().getParameters().get('feedid');
    rtId = Apexpages.currentPage().getParameters().get('recordTypeId');
        if(FeedID != null){
            feed = [select Year__c, Overall_Satisfaction_VOCSurvey__c,
             Interviewer_Name__c, SBU__c, Prod_LN_Prgm_Product_LIne__c,
              Site__c, recordtypeid, name, Consolidated_score__c,
             Supplier_Rating_Syst__c, Contact__c, Contact_Status__c, CBT__c, 
             Market_Name__c,Account__c, SR_S__c, SR_CBT__c, CBT_Team__c,
             Account_SBU__c,Account_CBT__c,Quarter__c,Go_Green_Yr_Qtr__c,
             Go_Green_Status__c,Type_Formula__c,Date_of_Interview__c,
             Report_Flag__c,Overall_Satisfaction_Value__c from Feedback__c where id =:FeedId ];
        }
         system.debug (feed);
        if(feed.Overall_Satisfaction_VOCSurvey__c == 'Red - Very Dissatisfied' || feed.Overall_Satisfaction_VOCSurvey__c == 'Yellow - Somewhat Dissatisfied' || feed.Consolidated_score__c <= 2){       
            gogreen.Feedback_Record_Number__c = feed.name;
            gogreen.Year__c = feed.Year__c;
            gogreen.Interviewer_Name__c = feed.Interviewer_Name__c;
            gogreen.Prod_LN_Prgm_Product_LIne__c = feed.Prod_LN_Prgm_Product_LIne__c;
            gogreen.Site__c = feed.Site__c;
            gogreen.Supplier_Rating_Syst__c = feed.Supplier_Rating_Syst__c;
            gogreen.Contact__c = feed.Contact__c;
            gogreen.Account__c = feed.Account__c;
            gogreen.SR_SBU__c = feed.SR_S__c;
            gogreen.SR_CBT__c = feed.SR_CBT__c;
            gogreen.CBT_Team__c = feed.CBT_Team__c;
             gogreen.Account_SBU1__c = feed.Account_SBU__c;
            gogreen.Account_CBT1__c = feed.Account_CBT__c;
             gogreen.Quarter__c = feed.Quarter__c;
                //    gogreen.Legacy_VOC_Number__c = feedlist[0].Legacy_VOC_Number__c;
             gogreen.Go_Green_Yr_Qtr__c = feed.Go_Green_Yr_Qtr__c;
                    gogreen.Go_Green_Status__c = feed.Go_Green_Status__c;
                    gogreen.Type__c = feed.Type_Formula__c;
                    gogreen.Date_of_Interview__c = feed.Date_of_Interview__c;
                    gogreen.Report_Flag__c = feed.Report_Flag__c;
                    gogreen.Overall_Calculated_Satisfaction__c = feed.Overall_Satisfaction_VOCSurvey__c;
                    gogreen.Overall_Calculated_Satisfaction_Value__c = feed.Overall_Satisfaction_Value__c;
        
         /*   AccID = feed.Account__c;
            if(AccID != null){
                  
                feedlist = [Select id, Quarter__c, Legacy_VOC_Number__c, Go_Green_Yr_Qtr__c, Go_Green_Status__c, Type_Formula__c, Date_of_Interview__c, Report_Flag__c, Locked__c, Overall_Satisfaction_VOCSurvey__c, Overall_Satisfaction_Value__c, createddate from Feedback__c where Account__c =: AccID order by createddate DESC Limit 1];
                if(feedlist.size()>0){
                    system.debug('PPPPPP'+feedlist);
                    gogreen.Quarter__c = feedlist[0].Quarter__c;
                //    gogreen.Legacy_VOC_Number__c = feedlist[0].Legacy_VOC_Number__c;
                    gogreen.Go_Green_Yr_Qtr__c = feedlist[0].Go_Green_Yr_Qtr__c;
                    gogreen.Go_Green_Status__c = feedlist[0].Go_Green_Status__c;
                    gogreen.Type__c = feedlist[0].Type_Formula__c;
                    gogreen.Date_of_Interview__c = feedlist[0].Date_of_Interview__c;
                    gogreen.Report_Flag__c = feedlist[0].Report_Flag__c;
                    gogreen.Overall_Calculated_Satisfaction__c = feedlist[0].Overall_Satisfaction_VOCSurvey__c;
                    gogreen.Overall_Calculated_Satisfaction_Value__c = feedlist[0].Overall_Satisfaction_Value__c;
                    
               } 
            }*/
        }
    }

    Public Go_Green_Plan__c getgogreen(){
        return gogreen;
    }

    Public void setgogreen(Go_Green_Plan__c green){
        this.gogreen = green;
    }
    
    Public PageReference Save(){
        try{
            insert gogreen;
            feed.GGP_Number__c = gogreen.id;
            update feed;
            assovoc.Feedback_Number__c = feed.id;
            assovoc.Go_Green_Plan__c = gogreen.ID;
            insert assovoc;
            system.debug('Inserted : '+feed);
            Pagereference p = new Pagereference('/'+gogreen.ID);
            p.setredirect(true);
            return p;
        }
        catch(Exception e){
            if(E.getMessage().Contains('duplicate value found')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate Legacy VOC Number.');
                ApexPages.addmessage(myMsg);
                return null;
            }
            else{
                return null;
            }
        }
    }
    
    Public PageReference Cancel(){
        try{
            Pagereference p = new Pagereference('/'+FeedId);
            p.setredirect(true);
            return p;
        }
        catch(Exception e){
            return null;
        }
    } 
}