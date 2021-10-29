@isTest(seeAllData = true)
public class GHAPPOperations_Test {
    public static testMethod void GHAPPOperations_Method1(){
      test.startTest();
        
        User usr = [ Select Id from User where Id = :UserInfo.getUserId() ];
        /*******************************************************************/
        ///////////////////rec.Gifts__c == true && rec.Gift_Recipient__c == true////////////////////////////////
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Solicited_By_You__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Solicited_By_You__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Offered_To_Spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Offered_To_Spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Manager_Approved_Gift__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Manager_Approved_Gift__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Value_of_Gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Value_of_Gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Value_of_Gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_Gift_Value_of_Gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_Gift_Value_of_Gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
        ///////////rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == true/////////////////////
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Solicited_By_You__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Solicited_By_You__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Offered_To_Spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Offered_To_Spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Manager_Approved__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Manager_Approved__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Value_of_Meal_Entertainment__c1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Value_of_Meal_Entertainment__c2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Value_of_Meal_Entertainment__c3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Pro_ME_Value_of_Meal_Entertainment__c4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Pro_ME_Value_of_Meal_Entertainment__c4');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /*******************************************************************/
        
        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Pending';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.SBG__c=Label.GH_Aero;
        or1.SBU__c=Label.GH_D_S;
        or1.Status__c='Pending';
        insert or1;
        
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        reqRec1.GH_Request__c=or1.Id;
        reqRec1.Gifts__c = true;
        reqRec1.Meals_Entertainment__c= true;
        reqRec1.Gift_Recipient__c = true;
        
        reqRec1.Pro_Gift_Occasion_Business_Meeting__c=false;
        reqRec1.Pro_Gift_Occasion_Award_Placement__c = true;
        reqRec1.Pro_Gift_Solicited_By_You__c = true;
        reqRec1.Pro_Gift_Offered_To_Spouse__c = true;
        reqRec1.Pro_Gift_Manager_Approved_Gift__c = false;
        reqRec1.Pro_Gift_Value_of_Gift__c =10;
        
        reqRec1.Pro_ME_Occasion_Business_Meeting__c = false;
        reqRec1.Pro_ME_Occasion_Award_Placement__c = true;
        reqRec1.Pro_ME_Solicited_By_You__c = true;
        reqRec1.Pro_ME_Offered_To_Spouse__c = true;
        reqRec1.Pro_ME_Manager_Approved__c = false;
        reqRec1.Pro_ME_Value_of_Meal_Entertainment__c = 10;
        
        reqRec1.Status__c='Submitted';
        
        insert reqRec1;
        
        GHAPPOperations.calculateScore(reqRec1);
        
        test.stopTest();
    }
}