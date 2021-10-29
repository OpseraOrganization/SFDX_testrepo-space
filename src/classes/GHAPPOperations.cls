/*******************************************************************************
AERO
Name         : GHAPPOperations
Created By   : Sumit Gupta
Company Name : NTT Data
Project      : Gift and Hospitality 
Created Date : 02-Feb-2015
Description  : This class is to calculate scores for the respective requests.
   
*******************************************************************************/

public class GHAPPOperations{
    public static List<integer> calculateScore(GH_Request_Recipient__c rec){
        List<integer> giftMealValues = new List<integer>();
        integer GiftScore = 0;
        integer MealScore = 0;
        integer ProGiftScore = 0;
        integer ProMealScore = 0;
        //system.debug('rec---->' + rec);
        /********************************************Score For Gift Recipient**************************************/
        if(rec.Gifts__c == true && rec.Gift_Recipient__c == false) {
            system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@@@@@@@@@@@@@ '+rec.Status__c);
            // Will the gift occasion be before/during/after a business meeting?
            if (rec.Gift_Occasion_Business_Meeting__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
                GiftScore = integer.valueOf(SC.No__c);
                system.debug('Score: Gift_Occasion_Business_Meeting__c == false');
            }
            
            //Will the gift occasion be impending order award/placement?
            if(rec.Gift_Occasion_Award_Placement__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
                GiftScore += integer.valueOf(SC.Yes__c);
                system.debug('Score: Gift_Occasion_Award_Placement__c == true');
            }
            
            //Will the gift be given to a government official or person affiliated with the public sector (including employee of a state owned or state controlled business)?
            if(rec.Gift_Gift_given_to_government_official__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
                GiftScore += integer.valueOf(SC.Yes__c);
                system.debug('Score: Gift_Gift_given_to_government_official__c == true');
            }
                        
            //Will total value of gifts provided to this recipient exceed $300 / year?            
            if(rec.Gift_Frequency__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
                GiftScore += integer.valueOf(SC.Yes__c);
                system.debug('Score: Gift_Frequency__c == true');
            }
            
            //Will the gift be offered to spouse, life partner, relatives, or guests?
            if(rec.Gift_Gift_offered_to_spouse__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
                GiftScore += integer.valueOf(SC.Yes__c);
                system.debug('Score: Gift_Gift_offered_to_spouse__c == true');
            }
                        
            //What is the value of gift (per person)?
            if(rec.Gift_Value_of_gift__c >= 1 && rec.Gift_Value_of_gift__c <= 150) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
                GiftScore += integer.valueOf(SC.No__c);
                system.debug('Score: Gift_Value_of_gift__c >= 1 && rec.Gift_Value_of_gift__c <= 150');
            }
            else if(rec.Gift_Value_of_gift__c >= 151 && rec.Gift_Value_of_gift__c <= 250) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
                GiftScore += integer.valueOf(SC.No__c);
                system.debug('Score: Gift_Value_of_gift__c >= 151 && rec.Gift_Value_of_gift__c <= 250');
            }
            else if(rec.Gift_Value_of_gift__c >= 251 && rec.Gift_Value_of_gift__c <= 400) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
                GiftScore += integer.valueOf(SC.No__c);
                system.debug('Score: Gift_Value_of_gift__c >= 251 && rec.Gift_Value_of_gift__c <= 400');
            }
            else if(rec.Gift_Value_of_gift__c >= 401) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
                GiftScore += integer.valueOf(SC.No__c);
                system.debug('Score: Gift_Value_of_gift__c >= 401');
            }
            
            //Has the Line Manager of the recipient been informed?
            if (rec.Gift_Line_Manager_Informed__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
                GiftScore += integer.valueOf(SC.No__c);
                system.debug('Score: Gift_Line_Manager_Informed__c == false');
            }  
            rec.Gift_Score__c = GiftScore;
            system.debug('GiftScore>>>>>>>' + GiftScore);
            
        }   
        
        /********************************************Score For Gift Provider**************************************/
        if(rec.Gifts__c == true && rec.Gift_Recipient__c == true) {    
            // if  Occasion:  a) before / during / after a business meeting
            if(rec.Pro_Gift_Occasion_Business_Meeting__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Occasion_Business_Meeting__c'); 
                system.debug('rec.Pro_Gift_Occasion_Business_Meeting__c == false --->'+ integer.valueOf(SC.No__c));
                ProGiftScore += integer.valueOf(SC.No__c); 
                system.debug('rec.Pro_Gift_Occasion_Business_Meeting__c == false'); 
            }
            //impending order award / placement
            if(rec.Pro_Gift_Occasion_Award_Placement__c == true){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Occasion_Award_Placement__c');  
                ProGiftScore += integer.valueOf(SC.Yes__c);  
                system.debug('rec.Pro_Gift_Occasion_Award_Placement__c == true');   
            }
            
            //Was this gift solicited by you?
            if(rec.Pro_Gift_Solicited_By_You__c == true){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Solicited_By_You__c');  
                ProGiftScore += integer.valueOf(SC.Yes__c);
                system.debug('Was this gift solicited by you? = true');     
            }
            
            //Would accepting this gift be embarrasing to the company if it were made public?
            /*if(rec.Pro_Gift_Embarrassing_If_Public__c == true){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Embarrassing_If_Public__c');  
                ProGiftScore += integer.valueOf(SC.Yes__c);
                
            }
            else if(rec.Pro_Gift_Embarrassing_If_Public__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Embarrassing_If_Public__c');  
                ProGiftScore += integer.valueOf(SC.No__c);
                                             
            }*/
            //Gift offered to your spouse, life partner, relatives, or guests?? 
            if(rec.Pro_Gift_Offered_To_Spouse__c == true){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Offered_To_Spouse__c');  
                ProGiftScore += integer.valueOf(SC.Yes__c);
                system.debug('Pro_Gift_Offered_To_Spouse__c == true');
            }
            
            // Has your manager approved the gift receipt
            if(rec.Pro_Gift_Manager_Approved_Gift__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Manager_Approved_Gift__c');  
                ProGiftScore += integer.valueOf(SC.No__c); 
                system.debug('Pro_Gift_Manager_Approved_Gift__c == false');                             
            }
            //Value of gift (please provide approximate value)
            if(rec.Pro_Gift_Value_of_Gift__c >0 && rec.Pro_Gift_Value_of_Gift__c <=148){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_1');  
                ProGiftScore += integer.valueOf(SC.No__c); 
                system.debug('value of gift (please provide approximate value > 0 or < 148');                               
            }
            else if(rec.Pro_Gift_Value_of_Gift__c >148 && rec.Pro_Gift_Value_of_Gift__c <=250){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_2');  
                ProGiftScore += integer.valueOf(SC.No__c);    
            }
            else if(rec.Pro_Gift_Value_of_Gift__c >250 && rec.Pro_Gift_Value_of_Gift__c <=400){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_3');  
                ProGiftScore += integer.valueOf(SC.No__c);    
            }
            else if(rec.Pro_Gift_Value_of_Gift__c >400){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_4');  
                ProGiftScore += integer.valueOf(SC.No__c);  
                system.debug('Pro_Gift_Value_of_Gift__c >400');                             
            }
            rec.Gift_Score__c = ProGiftScore;
            system.debug('ProGiftScore>>>>>>>' + ProGiftScore);
            // to check if the Score limit crosses the threshold value
            
            
        }
                    
        /*********************************************Score For Meal**********************************************/
        if(rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == false) {
            system.debug('Score For Meal');
            //Will the meal/entertainment occasion be before/during/after a business meeting?
            if (rec.ME_Occasion_Business_Meeting__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Business_Meeting__c');
                MealScore += integer.valueOf(SC.No__c);
            }
            
            //Will the meal/entertainment occasion be impending order award/placement?
            if(rec.ME_Occasion_Award_Placement__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Award_Placement__c');
                MealScore += integer.valueOf(SC.Yes__c);
            }
                        
            //Will the Meal / entertainment / travel be provided to a government official or person affiliated with the public sector (including employee of a state owned or state controlled business)?
            if(rec.ME_Travel_provided_to_government_officia__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_provided_to_government');
                MealScore += integer.valueOf(SC.Yes__c);
            }
                        
            //Will total value of gifts provided to this recipient exceed $300 / year?
            if(rec.ME_Frequency__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Frequency__c');
                MealScore += integer.valueOf(SC.Yes__c);
            }
                        
            //Will the Meal / entertainment / travel be offered to spouse, life partner, relatives, or guests?
            if(rec.ME_Travel_offered_to_spouse__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_offered_to_spouse__c');
                MealScore += integer.valueOf(SC.Yes__c);
            }
                        
            //What is the value of meal/entertainment(per person)?
            if(rec.ME_Value_of_Meals_Entertainment__c >= 1 && rec.ME_Value_of_Meals_Entertainment__c <= 150) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_1');
                MealScore += integer.valueOf(SC.No__c);
            }
            else if(rec.ME_Value_of_Meals_Entertainment__c >= 151 && rec.ME_Value_of_Meals_Entertainment__c <= 250) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_2');
                MealScore += integer.valueOf(SC.No__c);
            }
            else if(rec.ME_Value_of_Meals_Entertainment__c >= 251 && rec.ME_Value_of_Meals_Entertainment__c <= 400) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_3');
                MealScore += integer.valueOf(SC.No__c);
            }
            else if(rec.ME_Value_of_Meals_Entertainment__c >= 401) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_4');
                MealScore += integer.valueOf(SC.No__c);
            }
            
            //Has the Line Manager of the recipient been informed?
            if (rec.ME_Line_Manager_Informed__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Line_Manager_Informed__c');
                MealScore += integer.valueOf(SC.No__c);
            }
            rec.Meal_Score__c = MealScore;
            
        }    
            /****************************************Provider Meal/Entertainment Score Logic*********************************************/
        if(rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == true) {
            system.debug('Provider Meal/Entertainment Score Logic');
            //Occasion: before / during / after a business meeting
            if (rec.Pro_ME_Occasion_Business_Meeting__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Occasion_Business_Meeting__c');
                ProMealScore += integer.valueOf(SC.No__c);
            }
            //   impending order award / placement
            if(rec.Pro_ME_Occasion_Award_Placement__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Occasion_Award_Placement__c');
                ProMealScore += integer.valueOf(SC.Yes__c);
            }
            
            // Was Meal Solicited By You
            if(rec.Pro_ME_Solicited_By_You__c == true){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Solicited_By_You__c');
                ProMealScore += integer.valueOf(SC.Yes__c);    
            }
            
            // Would accepting this Meal be embarrasing to the company if it were made public?
            /*if(rec.Pro_ME_Embarrassing_If_Public__c == true){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Embarrassing_If_Public__c');
                ProMealScore += integer.valueOf(SC.Yes__c);    
            }
            else if(rec.Pro_ME_Embarrassing_If_Public__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Embarrassing_If_Public__c');
                ProMealScore += integer.valueOf(SC.No__c);    
            }*/
            //   Meal / entertainment / travel offered to spouse, life partner, relatives, or guests
            if(rec.Pro_ME_Offered_To_Spouse__c == true) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Offered_To_Spouse__c');
                ProMealScore += integer.valueOf(SC.Yes__c);
            }
            
            //    Line Manager of the invitee is informed
            if (rec.Pro_ME_Manager_Approved__c == false){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Manager_Approved__c');
                ProMealScore += integer.valueOf(SC.No__c);
            }
            
            //    Value of meal / entertainment / travel (per person) 
            if(rec.Pro_ME_Value_of_Meal_Entertainment__c >0 && rec.Pro_ME_Value_of_Meal_Entertainment__c <= 150) {
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c1');
                ProMealScore += integer.valueOf(SC.No__c);
            }
            else if (rec.Pro_ME_Value_of_Meal_Entertainment__c >150 && rec.Pro_ME_Value_of_Meal_Entertainment__c <= 250){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c2');
                ProMealScore += integer.valueOf(SC.No__c);
            } 
            else if (rec.Pro_ME_Value_of_Meal_Entertainment__c >250 && rec.Pro_ME_Value_of_Meal_Entertainment__c <= 400){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c3');
                ProMealScore += integer.valueOf(SC.No__c);
            } 
            else if (rec.Pro_ME_Value_of_Meal_Entertainment__c >400){
                GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c4');
                ProMealScore += integer.valueOf(SC.No__c);
            } 
            rec.Meal_Score__c = ProMealScore;
            system.debug('ProMealScore>>>>>>'+ ProMealScore);
            
        }
        
        giftMealValues.add(Integer.valueOf(rec.Gift_Score__c));
        giftMealValues.add(Integer.valueOf(rec.Meal_Score__c));
        return giftMealValues;
    }
}