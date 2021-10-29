/** * File Name: FeedBack_consolidated
* Description :Trigger to update consolidated value
* Copyright : NTTDATA 2015 *
 * @author : NTTDATA
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------*
Version    Date         Author         Modification 
 1.1       8/10/2015    NTTDATA        INC000008843002 - Notify only for GGP Account Owner
 1.2       9/30/2015    TCS            INC000009118340 - Stop auto creation of Deliverable Item when GGP is created **/ 
trigger FeedBack_consolidated on Feedback__c (before insert,before update) {
    
    Integer consolidated3;
    List<ID> acclst1 = new List<ID>();
    String htmlBody='';
    string conname;
    string fbname;
    string fbsatis2;
    string fbsatis4;
    string fbsatis6;
    string fbhon;
    string fbcustom;
    string fbproductcatagory;
    //set<id> fbid = new set<id>();
    //id fbid=trigger.new;
    Set<ID> fbid = new set<id>();
    set<Feedback__c> feedbackset= new set<Feedback__c>();
      List<Deliverable_Item__c> lstDI = new List<Deliverable_Item__c>();
    boolean blnChk; 
    for(Feedback__c fb : Trigger.New){
        //INC000008436952---changes start
        //set<id> fbid=trigger.new();
        //fbid.add(fb.id);
        blnChk=false; 
        if(fb.recordtypeid == label.ATR_VOC_Record_Type || (fb.recordtypeid == label.ATR_VOC_Record_Type && (Trigger.isUpdate)))        
        {
            integer warrenty,Repair,Spares,HON,Cost,Perception,Communication,Documentation,GTO,Flexibilit,Reliability,Quality,cust,val,ser,deli,res;
            integer count=0;
            integer consolidated=0;
            Decimal consolidated1;
            system.debug('Warranty__c>>>>' + fb.Warranty__c + '<<<<Warranty_IND__c>>>>'+ fb.Warranty_IND__c);
            if(fb.Warranty__c != null && fb.Warranty_IND__c != null)
            {
                if(fb.Warranty_IND__c.contains('Red'))
                {
                    warrenty=1*1;
                    blnChk=true;
                }
                else if(fb.Warranty_IND__c.contains('Yellow'))
                {
                    warrenty=1*2;
                    //blnChk=true;
                }
                else if(fb.Warranty_IND__c.contains('Green'))
                {
                    warrenty=1*3;
                }
                else if(fb.Warranty_IND__c.contains('Blue'))
                {
                    warrenty=1*4;
                }
                consolidated=warrenty;
                count++;
            }
            if(fb.Repair_Performance__c != null && fb.Repair_Performance_IND__c != null)
            {
                if(fb.Repair_Performance_IND__c.contains('Red'))
                {
                    Repair=1*1;
                    blnChk=true;
                }
                else if(fb.Repair_Performance_IND__c.contains('Yellow'))
                {
                    Repair=1*2;
                    //blnChk=true;
                }
                else if(fb.Repair_Performance_IND__c.contains('Green'))
                {
                    Repair=1*3;
                }
                else if(fb.Repair_Performance_IND__c.contains('Blue'))
                {
                    Repair=1*4;
                }
                consolidated=consolidated+Repair;
                count++;
            }
            if(fb.Spares_Performance__c != null && fb.Spares_Performance_IND__c != null)
            {
                if(fb.Spares_Performance_IND__c.contains('Red'))
                {
                    Spares=1*1;blnChk=true;
                }
                else if(fb.Spares_Performance_IND__c.contains('Yellow'))
                {
                    Spares=1*2;//blnChk=true;
                }
                else if(fb.Spares_Performance_IND__c.contains('Green'))
                {
                    Spares=1*3;
                }
                else if(fb.Spares_Performance_IND__c.contains('Blue'))
                {
                    Spares=1*4;
                }
                consolidated=consolidated+Spares;
                count++;
            }
            if(fb.Recommend_HON__c != null && fb.Recommend_HON_IND__c != null)
            {
                if(fb.Recommend_HON_IND__c.contains('Red'))
                {
                    HON=1*1;blnChk=true;
                }
                else if(fb.Recommend_HON_IND__c.contains('Yellow'))
                {
                    HON=1*2;//blnChk=true;
                }
                else if(fb.Recommend_HON_IND__c.contains('Green'))
                {
                    HON=1*3;
                }
                else if(fb.Recommend_HON_IND__c.contains('Blue'))
                {
                    HON=1*4;
                }
                consolidated=consolidated+HON;
                count++;
            }
            if(fb.Cost__c != null && fb.Cost_IND__c != null)
            {
                if(fb.Cost_IND__c.contains('Red'))
                {
                    Cost=1*1;blnChk=true;
                }
                else if(fb.Cost_IND__c.contains('Yellow'))
                {
                    Cost=1*2;//blnChk=true;
                }
                else if(fb.Cost_IND__c.contains('Green'))
                {
                    Cost=1*3;
                }
                else if(fb.Cost_IND__c.contains('Blue'))
                {
                    Cost=1*4;
                }
                consolidated=consolidated+Cost;
                count++;
            }
            if(fb.Overall_Perception__c != null && fb.Overall_Perception_IND__c != null)
            {
                if(fb.Overall_Perception_IND__c.contains('Red'))
                {
                    Perception=1*1;blnChk=true;
                }
                else if(fb.Overall_Perception_IND__c.contains('Yellow'))
                {
                    Perception=1*2;//blnChk=true;
                }
                else if(fb.Overall_Perception_IND__c.contains('Green'))
                {
                    Perception=1*3;
                }
                else if(fb.Overall_Perception_IND__c.contains('Blue'))
                {
                    Perception=1*4;
                }
                consolidated=consolidated+Perception;
                count++;
            }
            if(fb.Communication__c != null && fb.Communication_IND__c != null)
            {
                if(fb.Communication_IND__c.contains('Red'))
                {
                    Communication=1*1;blnChk=true;
                }
                else if(fb.Communication_IND__c.contains('Yellow'))
                {
                    Communication=1*2;//blnChk=true;
                }
                else if(fb.Communication_IND__c.contains('Green'))
                {
                    Communication=1*3;
                }
                else if(fb.Communication_IND__c.contains('Blue'))
                {
                    Communication=1*4;
                }
                consolidated=consolidated+Communication;
                count++;
            }
            if(fb.Documentation__c != null && fb.Documentation_IND__c != null)
            {
                if(fb.Documentation_IND__c.contains('Red'))
                {
                    Documentation=1*1;blnChk=true;
                }
                else if(fb.Documentation_IND__c.contains('Yellow'))
                {
                    Documentation=1*2;//blnChk=true;
                }
                else if(fb.Documentation_IND__c.contains('Green'))
                {
                    Documentation=1*3;
                }
                else if(fb.Documentation_IND__c.contains('Blue'))
                {
                    Documentation=1*4;
                }
                consolidated=consolidated+Documentation;
                count++;
            }
            if(fb.Global_Technical_Ops_Support__c != null)
            {
                if(fb.Global_Technical_Ops_Support_IND__c != null)
                {
                if(fb.Global_Technical_Ops_Support_IND__c.contains('Red'))
                {
                    GTO=1*1;blnChk=true;
                }
                else if(fb.Global_Technical_Ops_Support_IND__c.contains('Yellow'))
                {//blnChk=true;
                    GTO=1*2;
                }
                else if(fb.Global_Technical_Ops_Support_IND__c.contains('Green'))
                {
                    GTO=1*3;
                }
                else if(fb.Global_Technical_Ops_Support_IND__c.contains('Blue'))
                {
                    GTO=1*4;
                }
                consolidated=consolidated+GTO;
                count++;
                }
            }
            if(fb.Flexibility__c != null)
            {
                if(fb.Flexibility_IND__c != null)
                {
                    if(fb.Flexibility_IND__c.contains('Red'))
                    {
                        Flexibilit=1*1;blnChk=true;
                    }
                    else if(fb.Flexibility_IND__c.contains('Yellow'))
                    {//blnChk=true;
                        Flexibilit=1*2;
                    }
                    else if(fb.Flexibility_IND__c.contains('Green'))
                    {
                        Flexibilit=1*3;
                    }
                    else if(fb.Flexibility_IND__c.contains('Blue'))
                    {
                        Flexibilit=1*4;
                    }
                    consolidated=consolidated+Flexibilit;
                    count++;
                }
            }
            if(fb.Metric_for_Reliability__c != null)
            {
                if(fb.Reliability_Metric_IND__c != null)
                {
                    if(fb.Reliability_Metric_IND__c.contains('Red'))
                    {
                        Reliability=1*1;blnChk=true;
                    }
                    else if(fb.Reliability_Metric_IND__c.contains('Yellow'))
                    {
                        Reliability=1*2;//blnChk=true;
                    }
                    else if(fb.Reliability_Metric_IND__c.contains('Green'))
                    {
                        Reliability=1*3;
                    }
                    else if(fb.Reliability_Metric_IND__c.contains('Blue'))
                    {
                        Reliability=1*4;
                    }
                    consolidated=consolidated+Reliability;
                    count++;
                }
            }
            if(fb.Metric_for_Quality__c != null && fb.Quality_Metric_IND__c != null)
            {           
                if(fb.Quality_Metric_IND__c.contains('Red'))
                {
                    Quality=1*1;blnChk=true;
                }
                else if(fb.Quality_Metric_IND__c.contains('Yellow'))
                {
                    Quality=1*2;//blnChk=true;
                }
                else if(fb.Quality_Metric_IND__c.contains('Green'))
                {
                    Quality=1*3;
                }
                else if(fb.Quality_Metric_IND__c.contains('Blue'))
                {
                    Quality=1*4;
                }
                consolidated=consolidated+Quality;
                count++;
            }
            if(fb.Customer_Overall_Satisfaction_Metric__c != null && fb.Customer_Overall_Satisfaction_Metric_IND__c != null)
            {
                if(fb.Customer_Overall_Satisfaction_Metric_IND__c.contains('Red'))
                {
                    cust=1*1;blnChk=true;
                }
                else if(fb.Customer_Overall_Satisfaction_Metric_IND__c.contains('Yellow'))
                {
                    cust=1*2;//blnChk=true;
                }
                else if(fb.Customer_Overall_Satisfaction_Metric_IND__c.contains('Green'))
                {
                    cust=1*3;
                }
                else if(fb.Customer_Overall_Satisfaction_Metric_IND__c.contains('Blue'))
                {
                    cust=1*4;
                }
                consolidated=consolidated+cust;
                count++;
            }
            if(fb.Metric_for_Value__c != null && fb.Value_Metric_IND__c != null)
            {
                if(fb.Value_Metric_IND__c.contains('Red'))
                {
                    val=1*1;blnChk=true;
                }
                else if(fb.Value_Metric_IND__c.contains('Yellow'))
                {
                    val=1*2;//blnChk=true;
                }
                else if(fb.Value_Metric_IND__c.contains('Green'))
                {
                    val=1*3;
                }
                else if(fb.Value_Metric_IND__c.contains('Blue'))
                {
                    val=1*4;
                }
                consolidated=consolidated+val;
                count++;
            }
            if(fb.Metric_for_Service_Support__c != null && fb.Service_Support_Metric_IND__c != null)
            {
                if(fb.Service_Support_Metric_IND__c.contains('Red'))
                {
                    ser=1*1;blnChk=true;
                }
                else if(fb.Service_Support_Metric_IND__c.contains('Yellow'))
                {
                    ser=1*2;//blnChk=true;
                }
                else if(fb.Service_Support_Metric_IND__c.contains('Green'))
                {
                    ser=1*3;
                }
                else if(fb.Service_Support_Metric_IND__c.contains('Blue'))
                {
                    ser=1*4;
                }
                consolidated=consolidated+ser;
                count++;
            }
            // INC000008843002 - Start
            if(fb.Metric_for_Delivery__c != null && fb.Customer_Rating_For_Delivery__c != null)
            {
                if(fb.Customer_Rating_For_Delivery__c.contains('Red') || fb.Customer_Rating_For_Delivery__c.contains('RED'))
                {
                    deli=1*1;blnChk=true;
                }
                else if(fb.Customer_Rating_For_Delivery__c.contains('Yellow') || fb.Customer_Rating_For_Delivery__c.contains('YELLOW'))
                {
                    deli=1*2;//blnChk=true;
                }
                else if(fb.Customer_Rating_For_Delivery__c.contains('Green') || fb.Customer_Rating_For_Delivery__c.contains('GREEN'))
                {
                    deli=1*3;
                }
                else if(fb.Customer_Rating_For_Delivery__c.contains('Blue') || fb.Customer_Rating_For_Delivery__c.contains('BLUE'))
                {
                    deli=1*4;
                }
                consolidated=consolidated+deli;
                count++;
            }
            if(fb.Metric_for_Responsiveness__c != null && fb.Customer_Rating_For_Responsiveness__c != null)
            {
                if(fb.Customer_Rating_For_Responsiveness__c.contains('Red')|| fb.Customer_Rating_For_Responsiveness__c.contains('RED'))
                {
                    res=1*1;blnChk=true;
                }
                else if(fb.Customer_Rating_For_Responsiveness__c.contains('Yellow') || fb.Customer_Rating_For_Responsiveness__c.contains('YELLOW'))
                {
                    res=1*2;//blnChk=true;
                }
                else if(fb.Customer_Rating_For_Responsiveness__c.contains('Green') || fb.Customer_Rating_For_Responsiveness__c.contains('GREEN'))
                {
                    res=1*3;
                }
                else if(fb.Customer_Rating_For_Responsiveness__c.contains('Blue') || fb.Customer_Rating_For_Responsiveness__c.contains('BLUE'))
                {
                    res=1*4;
                }
                consolidated=consolidated+res;
                count++;
            }
            
            // INC000008843002 - End
            system.debug('consolidated1'+consolidated);
            system.debug('count1'+count);           
            if(consolidated != null && consolidated>0 && count != null && count > 0)
            {
                //consolidated=consolidated/count;
                system.debug('consolidated12'+consolidated);
                consolidated1 = consolidated;
                Decimal consolidated12 = consolidated1/count;
                //Decimal roundedUp =  consolidated12.setscale(0, roundingMode.UP); 
                Decimal roundedDown =  consolidated12.setscale(0, roundingMode.DOWN); 
                system.debug('test1----->'+roundedDown );
                fb.consolidated_score__c=roundedDown ;
                consolidated3=integer.valueOf(roundedDown);
                /*if(fb.account__c != null && fb.ATR_Survey_Group__c == 'Airbus')           
                acclst1.add(fb.account__c);
                */
                fbname = fb.Name;
                conname = fb.Contact_Name__c;
                fbsatis2=fb.Level_Of_Satisfaction2__c;
                fbsatis4=fb.Level_Of_Satisfaction4__c;
                fbsatis6=fb.Level_Of_Satisfaction6__c;
                fbhon=fb.HON_Knows_My_Business__c;
                fbcustom=fb.Customer_Overall_Satisfaction_Metric__c;
                //fbid.add(fb.id);
                

                fbproductcatagory=fb.Product_Category__c;
            }   
            if(fb.account__c != null  && fb.recordtypeid == label.ATR_VOC_Record_Type  ){           
                acclst1.add(fb.account__c); 
                if(blnChk==true && fb.ATR_VOC_Survey_Notification__c==false && fb.ggp_number__c==null && 
                fb.show_on_atr_voc_dashboard__c==true ){
                    fbid.add(fb.id);
                     feedbackset.add(fb);
                }      
            }
            fb.ATR_VOC_Survey_Notification__c = false;
        }
    }
    Map<id,Account> mapAcct = new Map<id,Account>();
    //INC000008436952 -- sending email to account CBM 
    List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
    Go_Green_Plan__c ggp = new Go_Green_Plan__c();
    List<Go_Green_Plan__c> lstggp = new List<Go_Green_Plan__c>();
    List<Messaging.SingleEmailMessage> UFRbulkEmails = new List<Messaging.SingleEmailMessage>();
  system.debug('consolidated3>>>>>'+ consolidated3 + '<<<acclst1.size()>>>' + acclst1.size());    
    //atmlist = [SELECT UserId,user.email,user.name,AccountId,account.ownerid,account.name,TeamMemberRole FROM AccountTeamMember WHERE AccountId =:acclst1  limit 1];
    mapAcct = new Map<id,account>([SELECT Id,ownerid,name,owner.email FROM Account WHERE Id =:acclst1]);
   
    //if((consolidated3 != null && (consolidated3 == 1 || consolidated3 == 2)) && acclst1.size()>0)
    system.debug('etet'+blnChk);
    
    if((blnChk==true || (consolidated3 != null && (consolidated3 == 1 ))) && acclst1.size()>0)
    {
        //atmlist = [SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE AccountId =:acclst1 AND TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        
        //list<Feedback__c> fb3=[select ggp_number__c,show_on_atr_voc_dashboard__c,id,name,Product_Category__c ,ATR_Survey_Group__c,ATR_VOC_Survey_Notification__c ,account__c from Feedback__c where id IN:fbid];              
        //System.debug('TEST FB# Size'+fb3.size());
        Set<id> setFB = new set<id>();
        if(mapAcct.size()>0 && feedbackset.size() >0)// && trigger.isupdate)
        { System.debug('Line 462');
            for(Feedback__c fb :feedbackset)
            {       System.debug('Line 464');                                                                    
                //if(fb.ATR_VOC_Survey_Notification__c==false && fb.ggp_number__c==null && fb.show_on_atr_voc_dashboard__c==true)
                //{
                    ggp = new Go_Green_Plan__c();
                    ggp.Feedback_Record_Number__c=fb.name;
                    ggp.recordtypeid=label.ATRGoGreenRecord;
                    ggp.Ownerid=mapAcct.get(fb.account__c).ownerid;
                    ggp.Account__c=fb.account__C;
                    ggp.Product_Category__c=fb.Product_Category__c;
                    ggp.SurveyType__C=fb.ATR_Survey_Group__c;
                    lstggp.add(ggp);
                    setFB.add(fb.id);
                //}                
            }                       
        }
        //for(Feedback__c fb1 : Trigger.New)
        //{
            if(lstggp.size()>0)// && fb1.ATR_VOC_Survey_Notification__c ==false)
            { System.debug('Line 477');
                insert lstggp;
                //fb1.GGP_Number__c=lstggp[0].id;                                   
            }
        //}
        System.debug('Line 482');
        if(lstggp.size()>0)
        {System.debug('Line 484');
            for(Go_Green_Plan__c gg : lstggp){
            
            //INC000009118340 - Start
               //Deliverable_Item__c dl= new Deliverable_Item__c();
               // dl.Go_Green_Plan__c=gg.id;
               //lstDI.add(dl);
            //INC000009118340 - End
            System.debug('Line 498 lstDI'+lstDI.size());
            System.debug('Line 486');
                for(Feedback__c fb : Trigger.new){
                    if(setFB.contains(fb.id) && gg.Feedback_Record_Number__c == fb.name)
                    {
                        System.debug('Line 488');
                        System.debug('Line 488'+gg.id);
                        fb.GGP_Number__c=gg.id;
                        fb.ATR_VOC_Survey_Notification__c=true;
                        System.debug('Line 488'+fb.GGP_Number__c);
                    }                          
                }
            }
            
           //INC000009118340 - Start
                // if(lstDI!= null && lstDI.size()>0)
                // {
                // System.debug('Line 513 lstDI');
                // insert lstDI;
                // }
           //INC000009118340 - End
            /*
            boolean emailnotification=false;
            if(atmlist.size()>0)
            {              
                emailnotification=true;
            }
            if(emailnotification==true)
            {
                for(Feedback__c fb2 : Trigger.New)
                {
                    fb2.ATR_VOC_Survey_Notification__c=true; 
                }           
            }  */         
        }
    }
    
  
  
        for(Feedback__c fbk : Trigger.New)
        {
            if(fbk.ATR_Survey_Group__c == 'Airbus' || fbk.ATR_Survey_Group__c == 'boeing')
            {
                
                if((fbk.Metric_for_Reliability__c != null && (integer.valueof(fbk.Metric_for_Reliability__c)  == 0 || integer.valueof(fbk.Metric_for_Reliability__c)  > 5 ))||
                (fbk.Warranty__c!= null && (integer.valueof(fbk.Warranty__c)==0 || integer.valueof(fbk.Warranty__c)>5)) ||
                (fbk.Metric_for_Delivery__c!= null && (integer.valueof(fbk.Metric_for_Delivery__c)==0 || integer.valueof(fbk.Metric_for_Delivery__c)>5))||
                (fbk.Metric_for_Responsiveness__c!= null && ( integer.valueof(fbk.Metric_for_Responsiveness__c)==0 || integer.valueof(fbk.Metric_for_Responsiveness__c)>5))||
                (fbk.Metric_for_Quality__c != null && (integer.valueof(fbk.Metric_for_Quality__c)== 0 || integer.valueof(fbk.Metric_for_Quality__c)>5)) ||
                ( fbk.Repair_Performance__c != null && (integer.valueof(fbk.Repair_Performance__c)==0 || integer.valueof(fbk.Repair_Performance__c)>5) )||
                (fbk.Spares_Performance__c != null &&( integer.valueof(fbk.Spares_Performance__c)==0 || integer.valueof(fbk.Spares_Performance__c)>5)) ||
                (fbk.Recommend_HON__c != null && (integer.valueof(fbk.Recommend_HON__c)== 0 || integer.valueof(fbk.Recommend_HON__c)>5)) ||
                (fbk.Metric_for_Value__c != null && (integer.valueof(fbk.Metric_for_Value__c)==0 || integer.valueof(fbk.Metric_for_Value__c)>5) )||
                (fbk.Cost__c!= null && ( integer.valueof(fbk.Cost__c)==0 || integer.valueof(fbk.Cost__c)>5))||
                (fbk.Overall_Perception__c != null && ( integer.valueof(fbk.Overall_Perception__c)==0 || integer.valueof(fbk.Overall_Perception__c)>5))||
                (fbk.Communication__c != null && (integer.valueof(fbk.Communication__c)==0 || integer.valueof(fbk.Communication__c)>5) )||
                (fbk.Documentation__c != null && (integer.valueof(fbk.Documentation__c)== 0 || integer.valueof(fbk.Documentation__c)>5) ||
                (fbk.Metric_for_Service_Support__c != null && (integer.valueof(fbk.Metric_for_Service_Support__c)== 0 || integer.valueof(fbk.Metric_for_Service_Support__c)>5)) ||
                (fbk.Flexibility__c != null && (integer.valueof(fbk.Flexibility__c)== 0 || integer.valueof(fbk.Flexibility__c)>5)) ||
                (fbk.Global_Technical_Ops_Support__c != null && (integer.valueof(fbk.Global_Technical_Ops_Support__c)==0 || integer.valueof(fbk.Global_Technical_Ops_Support__c)>5)) ||
                (fbk.Customer_Overall_Satisfaction_Metric__c != null && ( integer.valueof(fbk.Customer_Overall_Satisfaction_Metric__c)== 0 || integer.valueof(fbk.Customer_Overall_Satisfaction_Metric__c)>5) ) ||
                
                
                (fbk.Level_Of_Satisfaction1__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction1__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction1__c)>5))||
                (fbk.Importance1__c!= null && (integer.valueof(fbk.Importance1__c) == 0 || integer.valueof(fbk.Importance1__c)>5))||
                (fbk.Level_Of_Satisfaction2__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction2__c) == 0 || integer.valueof(fbk.Level_Of_Satisfaction2__c)>5))||
                (fbk.Importance2__c!= null && (integer.valueof(fbk.Importance2__c)== 0 || integer.valueof(fbk.Importance2__c)>5))|
                (fbk.Level_Of_Satisfaction3__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction3__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction3__c)>5))||
                (fbk.Importance3__c!= null && (integer.valueof(fbk.Importance3__c)==0 || integer.valueof(fbk.Importance3__c)>5))||
                (fbk.Level_Of_Satisfaction4__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction4__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction4__c)>5))||
                (fbk.Importance4__c!= null && (integer.valueof(fbk.Importance4__c)==0 || integer.valueof(fbk.Importance4__c)>5))||
                (fbk.Level_Of_Satisfaction5__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction5__c)== 0 || integer.valueof(fbk.Level_Of_Satisfaction5__c)>5))||
                (fbk.Importance5__c!= null && (integer.valueof(fbk.Importance5__c)==0 || integer.valueof(fbk.Importance5__c)>5))||
                (fbk.Level_Of_Satisfaction6__c!= null &&( integer.valueof(fbk.Level_Of_Satisfaction6__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction6__c)>5))||
                (fbk.Importance6__c!= null && (integer.valueof(fbk.Importance6__c)==0 || integer.valueof(fbk.Importance6__c)>5))||
                (fbk.Level_Of_Satisfaction7__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction7__c)== 0 || integer.valueof(fbk.Level_Of_Satisfaction7__c)>5))||
                (fbk.Importance7__c!= null && (integer.valueof(fbk.Importance7__c)==0 || integer.valueof(fbk.Importance7__c)>5))||
                (fbk.Level_Of_Satisfaction8__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction8__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction8__c)>5))||
                (fbk.Importance8__c!= null && (integer.valueof(fbk.Importance8__c) == 0 || integer.valueof(fbk.Importance8__c)>5))||
                (fbk.Level_Of_Satisfaction9__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction9__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction9__c)>5))||
                (fbk.Importance9__c!= null && (integer.valueof(fbk.Importance9__c)==0 || integer.valueof(fbk.Importance9__c)>5)))||
                (fbk.Level_Of_Satisfaction10__c!= null && ( integer.valueof(fbk.Level_Of_Satisfaction10__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction10__c)>5))||
                (fbk.Importance10__c!= null && (integer.valueof(fbk.Importance10__c)==0 || integer.valueof(fbk.Importance10__c)>5))||
                (fbk.Level_Of_Satisfaction11__c!= null && ( integer.valueof(fbk.Level_Of_Satisfaction11__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction11__c)>5))||
                (fbk.Importance11__c!= null && (integer.valueof(fbk.Importance11__c)==0 || integer.valueof(fbk.Importance11__c)>5))||
                (fbk.Level_Of_Satisfaction12__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction12__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction12__c)>5))||
                (fbk.Importance12__c!= null && (integer.valueof(fbk.Importance12__c)==0 || integer.valueof(fbk.Importance12__c)>5))||
                (fbk.Level_Of_Satisfaction13__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction13__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction13__c)>5))|| 
                (fbk.Importance13__c!= null && (integer.valueof(fbk.Importance13__c)==0 || integer.valueof(fbk.Importance13__c)>5))||
                (fbk.Level_Of_Satisfaction14__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction14__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction14__c)>5))||
                (fbk.Importance14__c!= null && (integer.valueof(fbk.Importance14__c)==0 || integer.valueof(fbk.Importance14__c)>5))||
                (fbk.Level_Of_Satisfaction15__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction15__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction15__c)>5))||
                (fbk.Importance15__c!= null && (integer.valueof(fbk.Importance15__c)==0 || integer.valueof(fbk.Importance15__c)>5))||
                (fbk.Level_Of_Satisfaction16__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction16__c)>5))||
                (fbk.Importance16__c!= null && (integer.valueof(fbk.Importance16__c)==0 || integer.valueof(fbk.Importance16__c)>5))||
                (fbk.Level_Of_Satisfaction17__c!= null && (integer.valueof(fbk.Level_Of_Satisfaction17__c)==0 || integer.valueof(fbk.Level_Of_Satisfaction17__c)>5))||
                (fbk.Importance17__c!= null && (integer.valueof(fbk.Importance17__c)==0 || integer.valueof(fbk.Importance17__c)>5))||


                
                
                // (fbk.Consolidated__c != null && integer.valueof(fbk.Consolidated__c)>5 )||
                (fbk.Consolidated_score__c != null && integer.valueof(fbk.Consolidated_score__c) >5))
                {
                    fbk.adderror('Please select the Scale only between 1-5 ' );
                    }
            }
            
            else if(fbk.ATR_Survey_Group__c =='GE')
            {
                if((fbk.Metric_for_Reliability__c != null &&  integer.valueof(fbk.Metric_for_Reliability__c)>4) ||
                (fbk.Metric_for_Quality__c != null &&  integer.valueof(fbk.Metric_for_Quality__c)>4 )||
                (fbk.Warranty__c!= null && integer.valueof(fbk.Warranty__c)>4) ||
                (fbk.Metric_for_Delivery__c!= null && integer.valueof(fbk.Metric_for_Delivery__c)>4) ||
                (fbk.Metric_for_Responsiveness__c!= null && integer.valueof(fbk.Metric_for_Responsiveness__c)>4)||
                (fbk.Repair_Performance__c!= null &&  integer.valueof(fbk.Repair_Performance__c)>4 )||
                (fbk.Spares_Performance__c != null &&  integer.valueof(fbk.Spares_Performance__c)>4) ||
                (fbk.Recommend_HON__c != null &&  integer.valueof(fbk.Recommend_HON__c)>4) ||
                (fbk.Metric_for_Value__c != null &&  integer.valueof(fbk.Metric_for_Value__c)>4) ||
                (fbk.Cost__c != null &&  integer.valueof(fbk.Cost__c)>4 )||
                (fbk.Overall_Perception__c != null &&  integer.valueof(fbk.Overall_Perception__c)>4 )||
                (fbk.Communication__c!= null &&  integer.valueof(fbk.Communication__c)>4) ||
                (fbk.Documentation__c != null &&  integer.valueof(fbk.Documentation__c)>4 )||
                (fbk.Metric_for_Service_Support__c != null &&  integer.valueof(fbk.Metric_for_Service_Support__c)>4) ||
                (fbk.Flexibility__c != null &&  integer.valueof(fbk.Flexibility__c)>4 )||
                (fbk.Global_Technical_Ops_Support__c != null &&  integer.valueof(fbk.Global_Technical_Ops_Support__c)>4)||
                (fbk.Customer_Overall_Satisfaction_Metric__c != null &&  integer.valueof(fbk.Customer_Overall_Satisfaction_Metric__c)>4) ||
                
                
                 (fbk.Level_Of_Satisfaction1__c!= null && integer.valueof(fbk.Level_Of_Satisfaction1__c)>4)||
                (fbk.Importance1__c!= null && integer.valueof(fbk.Importance1__c)>5)||
                (fbk.Level_Of_Satisfaction2__c!= null && integer.valueof(fbk.Level_Of_Satisfaction2__c)>4)||
                (fbk.Importance2__c!= null && integer.valueof(fbk.Importance2__c)>5)||
                (fbk.Level_Of_Satisfaction3__c!= null && integer.valueof(fbk.Level_Of_Satisfaction3__c)>4)||
                (fbk.Importance3__c!= null && integer.valueof(fbk.Importance3__c)>5)||
                (fbk.Level_Of_Satisfaction4__c!= null && integer.valueof(fbk.Level_Of_Satisfaction4__c)>4)||
                (fbk.Importance4__c!= null && integer.valueof(fbk.Importance4__c)>5)||
                (fbk.Level_Of_Satisfaction5__c!= null && integer.valueof(fbk.Level_Of_Satisfaction5__c)>4)||
                (fbk.Importance5__c!= null && integer.valueof(fbk.Importance5__c)>5)||
                (fbk.Level_Of_Satisfaction6__c!= null && integer.valueof(fbk.Level_Of_Satisfaction6__c)>4)||
                (fbk.Importance6__c!= null && integer.valueof(fbk.Importance6__c)>5)||
                (fbk.Level_Of_Satisfaction7__c!= null && integer.valueof(fbk.Level_Of_Satisfaction7__c)>4)||
                (fbk.Importance7__c!= null && integer.valueof(fbk.Importance7__c)>5)||
                (fbk.Level_Of_Satisfaction8__c!= null && integer.valueof(fbk.Level_Of_Satisfaction8__c)>4)||
                (fbk.Importance8__c!= null && integer.valueof(fbk.Importance8__c)>5)||
                (fbk.Level_Of_Satisfaction9__c!= null && integer.valueof(fbk.Level_Of_Satisfaction9__c)>4)||
                (fbk.Importance9__c!= null && integer.valueof(fbk.Importance9__c)>5)||
                (fbk.Level_Of_Satisfaction10__c!= null && integer.valueof(fbk.Level_Of_Satisfaction10__c)>4)||
                (fbk.Importance10__c!= null && integer.valueof(fbk.Importance10__c)>5)||
                (fbk.Level_Of_Satisfaction11__c!= null && integer.valueof(fbk.Level_Of_Satisfaction11__c)>4)||
                (fbk.Importance11__c!= null && integer.valueof(fbk.Importance11__c)>5)||
                (fbk.Level_Of_Satisfaction12__c!= null && integer.valueof(fbk.Level_Of_Satisfaction12__c)>4)||
                (fbk.Importance12__c!= null && integer.valueof(fbk.Importance12__c)>5)||
                (fbk.Level_Of_Satisfaction13__c!= null && integer.valueof(fbk.Level_Of_Satisfaction13__c)>4)|| 
                (fbk.Importance13__c!= null && integer.valueof(fbk.Importance13__c)>5)||
                (fbk.Level_Of_Satisfaction14__c!= null && integer.valueof(fbk.Level_Of_Satisfaction14__c)>4)||
                (fbk.Importance14__c!= null && integer.valueof(fbk.Importance14__c)>5)||
                (fbk.Level_Of_Satisfaction15__c!= null && integer.valueof(fbk.Level_Of_Satisfaction15__c)>4)||
                (fbk.Importance15__c!= null && integer.valueof(fbk.Importance15__c)>5)||
                (fbk.Level_Of_Satisfaction16__c!= null && integer.valueof(fbk.Level_Of_Satisfaction16__c)>4)||
                (fbk.Importance16__c!= null && integer.valueof(fbk.Importance16__c)>5)||
                (fbk.Level_Of_Satisfaction17__c!= null && integer.valueof(fbk.Level_Of_Satisfaction17__c)>4)||
                (fbk.Importance17__c!= null && integer.valueof(fbk.Importance17__c)>5)||



                
                
                //(fbk.Consolidated__c != null &&  integer.valueof(fbk.Consolidated__c)>4 )||
                (fbk.Consolidated_score__c != null &&  integer.valueof(fbk.Consolidated_score__c) >4))
                {
                    fbk.adderror('Please select Scale only between 0-4' );
                    }
                
            }
        }      
}