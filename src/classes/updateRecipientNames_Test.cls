@isTest (SeeAllData = true)
private class updateRecipientNames_Test {
    
    static testMethod void testUpdateRecipientName_Method1(){
        
        test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        //acc.Customer_Status__c = 'Active';
        //acc.Strategic_Business_Unit__c = 'ATR';
        //acc.CBT__c = 'Airbus';
        //acc.Region_Name__c = 'Americas';
        //acc.Sub_Region_Name__c = 'Canada';
        //acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        //acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        //acc.Market_Name__c = 'Marine';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'G';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        //con.Primary_Email_Address__c = 'sumit13@nttdata.com';
        con.Email='sumit13i@nttdata.com';
        insert con;
        
        User usr = new User();
        usr.LastName='Test';
        usr.Alias = 'Test';
        usr.Email='standarduser@test.com';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.EmailEncodingKey='UTF-8';
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='sumit13@ntt.com';
        usr.SBG__c=Label.GH_Aero; 
        usr.SBU_User__c=Label.GH_D_S;
        usr.ProfileId = p.Id;
        insert usr;
        
        /***************************************************************************************/
        // rec.Gifts__c == true && rec.Gift_Recipient__c == false//
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
            if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }
        }
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_given_to_go');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        //rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == false//
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_provided_to_government');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_provided_to_government');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Frequency__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /***************************************************************************************/
        
        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Draft';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.SBG__c=Label.GH_Aero;
        or1.SBU__c=Label.GH_D_S;
        or1.Status__c='submitted';
        insert or1;
     
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        reqRec1.Approver_Name1__c=usr.id;
        reqRec1.City__c='GTK';
        reqRec1.Company__c='NTT Data';
        reqRec1.Country__c='INDIA';
        reqRec1.Country_where_Gift_is_provided__c='INDIA';
        reqRec1.Country_where_ME_is_provided__c='INDIA';
        reqRec1.GH_Request__c=or1.Id;
        reqRec1.Name_of_Recipient_Lookup__c=con.Id;
        reqRec1.Gift_Recipient__c=false;
        
        // Receiver GIFT
        reqRec1.Gifts__c=true;
        reqRec1.Gift_Currency_Code__c='USD';
        reqRec1.Gift_Gift_given_to_government_official__c=true;
        reqRec1.Gift_Gift_offered_to_spouse__c=true;
        reqRec1.Gift_Line_Manager_Informed__c=true;
        reqRec1.Gift_Occasion_Award_Placement__c=true;
        reqRec1.Gift_Occasion_Business_Meeting__c=true;
        reqRec1.Gift_Twelve_Months_Aggregate_Value__c=301;
        reqRec1.Gift_Value_of_gift__c=21;
        reqRec1.Gift_Needs_Approval__c=True;
        

        // Receiver MEAL
        reqRec1.Meals_Entertainment__c=true;
        //reqRec1.Meal_Score__c=11;
        reqRec1.ME_Frequency__c=true;
        reqRec1.ME_Needs_Approval__c=true;
        reqRec1.ME_Occasion_Award_Placement__c=True;
        reqRec1.ME_Occasion_Business_Meeting__c=True;
        reqRec1.Meals_Currency_Code__c='USD';
        reqRec1.Meals_Value_Per_Currency__c=21;    
        reqRec1.ME_Line_Manager_Informed__c=true;
        reqRec1.ME_Travel_offered_to_spouse__c=true;
        reqRec1.ME_Travel_provided_to_government_officia__c=true;   
        reqRec1.ME_Twelve_Months_Aggregate_Value__c=601;
        reqRec1.Name_of_Recipient__c='Sumivaths Gundlapalli';
        reqRec1.Status__c='Submitted';
        
        insert reqRec1;
         
        test.stopTest();
    }
    
    static testMethod void testUpdateRecipientName_Method2(){
        
        test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User usr = new User();
        usr.LastName='Test';
        usr.Alias = 'Test';
        usr.Email='standarduser@test.com';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.EmailEncodingKey='UTF-8';
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='sumit13@ntt.com';
        usr.SBG__c=Label.GH_Aero; 
        usr.SBU_User__c=Label.GH_D_S;
        usr.ProfileId = p.Id;
        insert usr;
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
        system.runAs(usr){
            Order_Request__c or1 = new Order_Request__c();
            or1.Entertainment_Cost__c=true;
            or1.Event_status__c='Pending';
            or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
            or1.SBG__c=Label.GH_Aero;
            or1.SBU__c=Label.GH_D_S;
            or1.Status__c='submitted';
            insert or1;
            
            GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
            reqRec1.Approver_Name1__c=usr.id;
            
            reqRec1.City__c='GTK';
            reqRec1.Company__c='NTT Data';
            reqRec1.Country__c='INDIA';
            reqRec1.Country_where_Gift_is_provided__c='INDIA';
            reqRec1.Country_where_ME_is_provided__c='INDIA';
            reqRec1.GH_Request__c=or1.Id;
            reqRec1.Name_of_Recipient__c='Sumivaths Gundlapalli';
            
            reqRec1.Gift_Recipient__c=true;
            
            // Provider GIFT
            reqRec1.Gifts__c=True;
            reqRec1.Pro_Gift_Currency_Code__c='USD';
            reqRec1.Pro_Gift_Embarrassing_If_Public__c=true;    
            reqRec1.Pro_Gift_Manager_Approved_Gift__c=true;    
            reqRec1.Pro_Gift_Offered_To_Spouse__c=true;    
            reqRec1.Pro_Gift_Solicited_By_You__c=true;    
            reqRec1.Pro_Gift_Value_Per_Currency__c=21;    
            reqRec1.Pro_Gift_Occasion_Award_Placement__c=true;
            reqRec1.Pro_Gift_Occasion_Business_Meeting__c=true;
            
            // Provider Meal
            reqRec1.Meals_Entertainment__c = true;
            reqRec1.Pro_Meals_Currency_Code__c='USD';    
            reqRec1.Pro_Meals_Value_Per_Currency__c=21;    
            reqRec1.Pro_ME_Embarrassing_If_Public__c=true;    
            reqRec1.Pro_ME_Manager_Approved__c=true;    
            reqRec1.Pro_ME_Offered_To_Spouse__c= true;    
            reqRec1.Pro_ME_Solicited_By_You__c=true;
            reqRec1.Pro_ME_Occasion_Award_Placement__c=true;
            reqRec1.Pro_ME_Occasion_Business_Meeting__c= true;        
            reqRec1.Status__c='Submitted';
            
            insert reqRec1;     
        }
        
        
         
        test.stopTest();
    }
    
    static testMethod void testUpdateRecipientName_Method3(){
        
        test.startTest();
        
		User usr = [ Select Id from User where Id = :UserInfo.getUserId()];		
		/***************************************************************************************/
        // rec.Gifts__c == true && rec.Gift_Recipient__c == false//
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
            if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }
        }
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_given_to_go');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        //rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == false//
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_provided_to_government');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_provided_to_government');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Frequency__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /***************************************************************************************/        
        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Pending';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.Status__c='Pending';
        insert or1;
        
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        reqRec1.GH_Request__c=or1.Id;
        reqRec1.Status__c='Submitted';
        
        reqRec1.Gift_Recipient__c=false;
        reqRec1.Gifts__c = true;
        reqRec1.Gift_Line_Manager_Informed__c = false;
        
        reqRec1.Meals_Entertainment__c = true;     
        reqRec1.ME_Line_Manager_Informed__c = false;   
        
        insert reqRec1;
         
        test.stopTest();
    }
    
    static testMethod void testUpdateRecipientName_Method4(){
        
        test.startTest();
        
        User usr = [ Select Id from User where Id = :UserInfo.getUserId()];
		/************************************************************************/
		// rec.Gifts__c == true && rec.Gift_Recipient__c == false
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
            if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }
        }
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_given_to_go');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /////////////////////////////////rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == false///////////////////////////////
		
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_provided_to_government');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_provided_to_government');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Frequency__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /************************************************************************/
        
        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Pending';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.Status__c='Pending';
        insert or1;
        
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        reqRec1.GH_Request__c=or1.Id;
        reqRec1.Status__c='Submitted';
        
        reqRec1.Gift_Recipient__c=false;
        reqRec1.Gifts__c = true;
        reqRec1.Gift_Line_Manager_Informed__c = true;
        reqRec1.ME_Line_Manager_Informed__c = true;
        
        reqRec1.Gift_Twelve_Months_Aggregate_Value__c= 700;
        
        reqRec1.Meals_Entertainment__c = true;     
        reqRec1.ME_Twelve_Months_Aggregate_Value__c = 700;   
        
        insert reqRec1;
         
        test.stopTest();
    }
    
    static testMethod void testUpdateRecipientName_Method5(){
        
        test.startTest();

        User usr = [ Select Id from User where Id = :UserInfo.getUserId()];
		/************************************************************************/
		// rec.Gifts__c == true && rec.Gift_Recipient__c == false
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
            if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }
        }
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_given_to_go');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /////////////////////////////////rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == false///////////////////////////////
		
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_provided_to_government');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_provided_to_government');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Frequency__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /************************************************************************/        
        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Pending';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.Status__c='Pending';
        insert or1;
        
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        reqRec1.GH_Request__c=or1.Id;
        reqRec1.Status__c='Submitted';
        
        reqRec1.Gift_Recipient__c=false;
        reqRec1.Gifts__c = true;
        reqRec1.Gift_Gift_given_to_government_official__c= true;
        reqRec1.Gift_Value_of_gift__c=21;
        
        reqRec1.Meals_Entertainment__c = true;     
        reqRec1.ME_Travel_provided_to_government_officia__c = true;   
        reqRec1.ME_Value_of_Meals_Entertainment__c=21;
        
        insert reqRec1;
         
        test.stopTest();
    }
    static testMethod void testUpdateRecipientName_Method6(){
        
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
        or1.Status__c='Pending';
        insert or1;
        
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        reqRec1.GH_Request__c=or1.Id;
        reqRec1.Status__c='Submitted';
        
        reqRec1.Gift_Recipient__c=true;
        reqRec1.Gifts__c = true;
        reqRec1.Gift_Value_of_gift__c= 151;
        
        reqRec1.Pro_Gift_Solicited_By_You__c = false;
        reqRec1.Pro_Gift_Embarrassing_If_Public__c = false; 
        reqRec1.Pro_Gift_Offered_To_Spouse__c = false;
        reqRec1.Pro_Gift_Manager_Approved_Gift__c = false;
        
        reqRec1.Meals_Entertainment__c = true;
        reqRec1.ME_Value_of_Meals_Entertainment__c=151;
        
        
        insert reqRec1;
         
        test.stopTest();
    }
    
    static testMethod void testUpdateRecipientName_Method7(){
        
        test.startTest();
        
		User usr = [ Select Id from User where Id = :UserInfo.getUserId()];
		
        /************************************************************************/
		// rec.Gifts__c == true && rec.Gift_Recipient__c == false
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
            if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }
        }
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_given_to_go');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /////////////////////////////////rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == false///////////////////////////////
		
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_provided_to_government');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_provided_to_government');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Frequency__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /************************************************************************/         
        Order_Request__c or1 = new Order_Request__c();
        or1.Entertainment_Cost__c=true;
        or1.Event_status__c='Pending';
        or1.Recipient_Name_List__c='Sumivaths Gundlapalli';
        or1.Status__c='Pending';
        insert or1;
        Account acc = new Account();
        acc.Name = 'Test Account';
        /*acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';*/
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'G';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        //con.Primary_Email_Address__c = 'sumit13@nttdata.com';
        con.Email='sumit13i@nttdata.com';
        insert con;
        
        GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
        reqRec1.GH_Request__c=or1.Id;
        reqRec1.Status__c='Approved';
        
        reqRec1.Gift_Recipient__c=false;
        reqRec1.Gifts__c = true;
        reqRec1.Gift_Value_of_gift__c= 151;
        
        reqRec1.Meals_Entertainment__c = true;     
        reqRec1.ME_Value_of_Meals_Entertainment__c=151;
        reqRec1.Name_of_Recipient_Lookup__c = con.Id;
        reqRec1.Gift_Score__c = 12;
        reqRec1.Meal_Score__c = 13;
        
        insert reqRec1;
        
        GH_Request_Recipient__c reqRec2 = new GH_Request_Recipient__c();
        reqRec2.GH_Request__c=or1.Id;
        reqRec2.Status__c='Approved';
        
        reqRec2.Gift_Recipient__c=false;
        reqRec2.Gifts__c = true;
        reqRec2.Gift_Value_of_gift__c= 151;
        
        reqRec2.Meals_Entertainment__c = true;     
        reqRec2.ME_Value_of_Meals_Entertainment__c=151;
        reqRec2.Name_of_Recipient_Lookup__c = con.Id;
        reqRec2.Gift_Score__c = 14;
        reqRec2.Meal_Score__c = 15;
        
        insert reqRec2;
        
        delete reqRec1;
         
        test.stopTest();
    }
   static testMethod void testUpdateRecipientName_Method8(){
        
       test.startTest();
       
       User usr = [ Select Id from User where Id = :UserInfo.getUserId()];
        /************************************************************************/
		// rec.Gifts__c == true && rec.Gift_Recipient__c == false
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
            if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }
        }
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_given_to_go');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /////////////////////////////////rec.Meals_Entertainment__c == true && rec.Gift_Recipient__c == false///////////////////////////////
		
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Business_Meeting__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_provided_to_government');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_provided_to_government');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Frequency__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Travel_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Travel_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Value_of_Meals_Entertainment__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Value_of_Meals_Entertainment__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('ME_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='ME_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /************************************************************************/ 
       
       Order_Request__c or1 = new Order_Request__c();
       or1.Is_Event_Request__c=true;
       or1.Status__c='Complete';
       or1.Event_status__c='Approved';
       or1.Event_Date__c= date.today();
       or1.Event_Type__c='Other';
       insert or1;
      	
       GH_Request_Recipient__c reqRec1 = new GH_Request_Recipient__c();
       reqRec1.GH_Request__c=or1.Id;
       reqRec1.Status__c='Draft';
       reqRec1.Gift_Recipient__c = false;
       reqRec1.Gifts__c=true;
       reqRec1.Gift_Line_Manager_Informed__c=true;
       reqRec1.Gift_Twelve_Months_Aggregate_Value__c=1;
       reqRec1.Gift_Gift_offered_to_spouse__c=true;
       
       reqRec1.Meals_Entertainment__c = true;
       reqRec1.ME_Line_Manager_Informed__c=true;
       reqRec1.ME_Twelve_Months_Aggregate_Value__c=1;
       
       reqRec1.ME_Travel_offered_to_spouse__c=true;
       
       insert reqRec1;
       
       test.stopTest();
    }
    static testMethod void testUpdateRecipientName_Method9(){
        
        test.startTest();
        
        User usr = [ Select Id from User where Id = :UserInfo.getUserId()];
		
        /************************************************************************/
		// rec.Gifts__c == true && rec.Gift_Recipient__c == false
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Business_Meeting__c');
            if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Business_Meeting__c');
                SC.No__c = 0;
                insert SC;
            }
        }
        System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Occasion_Award_Placement__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Occasion_Award_Placement__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_given_to_go');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_given_to_go');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Frequency__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Gift_offered_to_spouse__c');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Gift_offered_to_spouse__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='');
                SC.Yes__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_1');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_1');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_2');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_2');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_3');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_3');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Value_of_gift__c_4');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Value_of_gift__c_4');
                SC.No__c = 0;
                insert SC;
            }                
		}
		System.runAs(usr){
            GH_App_Scorecard__c SC =  GH_App_Scorecard__c.getValues('Gift_Line_Manager_Informed__c');
			if(SC == null){
                SC = new GH_App_Scorecard__c(Name='Gift_Line_Manager_Informed__c');
                SC.No__c = 0;
                insert SC;
            }                
		}
        /*************************************************************************************/
		        
        Order_Request__c or1 = new Order_Request__c();
        or1.Is_Event_Request__c=false;
        or1.Status__c='Complete';
        or1.Event_status__c='Approved';
        or1.Event_Date__c= date.today();
        or1.Event_Type__c='Other';
        insert or1;
        
       	GH_Request_Recipient__c reqRec2 = new GH_Request_Recipient__c();
        reqRec2.GH_Request__c=or1.Id;
        reqRec2.Status__c='Pending';
        reqRec2.Meals_Entertainment__c = false;
        reqRec2.Gift_Recipient__c=false;
        reqRec2.Gifts__c = true;
        insert reqRec2; 
        
        List<GH_Request_Recipient__c> reqList = new List<GH_Request_Recipient__c>();
        reqList.add(reqRec2);
        update reqList;
        
        update or1;
           
        //update reqRec2;
            
        test.stopTest();
    } 
}