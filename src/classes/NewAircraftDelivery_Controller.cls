global class NewAircraftDelivery_Controller {
    
    //Account details
    public boolean AccountNotFound{get;set;}
    public string streetAddLine1{get;set;}
    public string streetAddLine2{get;set;}
    public string city{get;set;}
    public string zipCode{get;set;}
    public string primaryEmailAdd{get;set;}
    public string AccPrimaryPhonenumber{get;set;}
    public string submittedBy{get;set;}
    public string tempAccountID{get;set;}
    public string tempAccountName{get;set;}
 // Variable Declarations for Tech Pubs Section....By TCS Team......//
    public  Case_Extension__c cc{get;set;}    
    public String Techcontactname{get;set;}
    public String TechshipAdd{get;set;}
    public String EmailAdd{get;set;}
    public String PhoneNum{get;set;}
// Variable Declarations for Tech Pubs Section....By TCS Team......//
  //Inputtext variables
    public string tempServiceRepID{get;set;}
    public string tempServiceRepName{get;set;}
    //Variable declaration for additional information....By TCS Team......//
    public string tempOtherContact1Id{get;set;}
    public string tempOtherContactName{get;set;}
    public string tempOtherContact2Id{get;set;}
    public string tempOtherContact2Name{get;set;}
    public string tempOtherContact1Email{get;set;}
    public string tempOtherContact2Email{get;set;}
    public string tempPlatformID{get;set;}
    public string tempPlatformName{get;set;}
    public string tempPrimMaintProviderID{get;set;}
    public string tempPrimMaintProviderName{get;set;}
    public string tempChiefPilotName{get;set;}
    public string tempChiefPilotID{get;set;}
    public string tempAviationManagerID{get;set;}
    public string tempAviationManagerName{get;set;}
    public string tempDirOfMaintenanceID{get;set;}
    public string tempDirOfMaintenanceName{get;set;}
    public string tempFSEMechanicalID{get;set;}
    public string tempFSEMechanicalName{get;set;} 
    public string tempFSEAvionicsID{get;set;}
    public string tempFSEAvionicsName{get;set;}
    public string tempCustSuppManagerID{get;set;}
    public string tempCustSuppManagerName{get;set;}
    public string tempAfterMarketSalesManagerID{get;set;}
    public string tempAfterMarketSalesManagerName{get;set;}
    //Fleet,Case record ids
    public id fleetAssetRecordId {get;set;}
    public id newCaseDeliveryID{get;set;}
    public id caseAircraftDeliveryID{get;set;}
    //OEM, Model and Make
    public string oem{get;set;}
    public string aircraftModel{get;set;}
    public string aircraftMake{get;set;}    
    public string platformName {get;set;}
    public string selectedAccType{get;set;}
    public List<selectOption> acctTypes;
    public List<selectOption> getacctTypes(){
        acctTypes = new List<selectOption>();
        for(Account_Types__c type: Account_Types__c.getAll().values())
        {
            acctTypes.add(new SelectOption(type.Name,type.type__c));
        }
        return acctTypes;
    }
    //End Account details
    //Platform details
    public id platformid{get;set;}
    //Platform details
    private List<Task> newTaskList;
    public boolean displaySuccess{get;set;}     
    public Fleet_Asset_Detail__c fleetAssetDetail;
    ApexPages.StandardController scontroller; 
    boolean rollBackReq = true;
    public NewAircraftDelivery_Controller(ApexPages.StandardController controller) {
        cc  = new Case_Extension__c();
        displaySuccess = false;                   
        this.fleetAssetDetail = (Fleet_Asset_Detail__c)controller.getRecord();
        scontroller = controller;
        newTaskList = new  List<Task>();
    }
            
    public pagereference saveAAS(){
        Savepoint sp = Database.setSavepoint();
        try{
             set<string> Usrid=new set<string>{tempFSEMechanicalID,tempFSEAvionicsID};
             Map<string,id> mapUsrEmail = new Map<string,id>();
             Map<id,id> mapContID = New Map<id,id>();
               system.debug('###Usrid:'+Usrid.size());
            if(Usrid.size()>0)
            {
                system.debug('@@Usrid:'+Usrid);
                for(User usr : [Select id,Email from user where id IN: Usrid])
                {
                    system.debug('$$Is MAP');
                    mapUsrEmail.put(usr.Email,usr.id);
                    system.debug('Is MAP:'+mapUsrEmail);
                }
            }
    
            system.debug('Get KEY:'+mapUsrEmail.Keyset());
            if(mapUsrEmail.size()>0)
            {
            for(contact cnt : [select id,Primary_Email_Address__c from contact where Primary_Email_Address__c IN: mapUsrEmail.Keyset()])
                {
                    System.debug('Contact tempFSEMechanicalId:'+mapUsrEmail.get(cnt.Primary_Email_Address__c));
                    mapContID.put(mapUsrEmail.get(cnt.Primary_Email_Address__c),cnt.id);
                    System.debug('mapContID:'+mapContID);
                }
            }   
    
    
            if(tempAccountID != null && tempAccountID != '')
                AccountNotFound = false;
            else
                AccountNotFound = true;
            //Initialize
           Case caseCustomerMaster = new Case();
           //Initialization of case extension object
           Case_Extension__c cc1 = new Case_Extension__c();
            //Create a case with 'New Aircraft Delivery' recordtype 
            Case caseNewAircraftDelivery   = new Case();
            if(tempPlatformID != null && tempPlatformID != ''){
             System.debug('tempPlatformID ***'+tempPlatformID );
             platform__c platfromDetails = [select id, name, OEM_Name__r.name, Make__c, Model__c from Platform__c where id =: tempPlatformID];
              
                System.debug('platfromDetails ***'+platfromDetails );
                oem = platfromDetails.OEM_Name__r.name;
                aircraftModel = platfromDetails.Model__c;
                aircraftMake = platfromDetails.Make__c;    
                platformName = platfromDetails.name;
            }  
            //Create Fleat Asset Aircraft record if user select existing account by unchecking the 'Not Found?' check box
            if(AccountNotFound == false){
                System.debug('AccountNotFound ***'+AccountNotFound );
                //Close the case if Account is existing one.
                caseNewAircraftDelivery.Status = 'Closed';
                caseNewAircraftDelivery.RecordTypeId = Label.New_Aircraft_Delivery_RT_ID;
               //Added by Dhivya for SR INC000008898435
                caseNewAircraftDelivery.Platform__c=tempPlatformID;
                            
                caseNewAircraftDelivery.origin = 'Web';
                caseNewAircraftDelivery.Subject = 'New Aircarft Notification: Fleet Asset Aircraft creation';
                caseNewAircraftDelivery.Description = 'Hi, \n\n A new request from New Aircraft Notification form has been created.\n\nPlease find the details for the creation of New Account.\n\nAccount Name - ' + tempAccountName + '\n AccountType - '+ selectedAccType +'\n Street Address Line 1 - ' + streetAddLine1+'\n Street Address Line 2 - '+ streetAddLine2 + '\n Country - ' + fleetAssetDetail.Cntry__c + '\n City - '+ city +'\n State - ' + fleetAssetDetail.State__c + '\nZip Code - ' + zipCode + '\nPrimary Email Address - ' + primaryEmailAdd + '\nAccount Primary Phone Number - ' + AccPrimaryPhonenumber + '\nAircraft Delivery Date - ' + fleetAssetDetail.Aircraft_Delivery_Date__c +'\nPlatform Name - ' + tempPlatformName +'\nAircraft Serial Number - '+ fleetAssetDetail.Serial_Number__c +'\nTail Number - '+ fleetAssetDetail.Tail_Number__c +'\nOEM - '+ oem +'\n  Aircraft Model - '+ aircraftModel +'\nAircraft Make - '+ aircraftMake +'\nCompletion Facility - '+ fleetAssetDetail.Completion_Facility__c +'\nEffective Warranty Date - '+ fleetAssetDetail.Effective_Warranty_Date__c +'\nMSP Selected - '+ fleetAssetDetail.MSP_Selected__c +'\nExpected Duration of EIS Support - '+ fleetAssetDetail.Expected_Duration_of_EIS_Support__c +'\nA/C Hours - '+ fleetAssetDetail.A_C_Hours__c +'\nOperational Base - '+ fleetAssetDetail.Operational_Based_City_Country__c +'\nA/C Cycles - '+ fleetAssetDetail.A_C_Cycles__c +'\nAPU S/N - '+ fleetAssetDetail.APU_S_N__c +'\nAPU Hours - '+ fleetAssetDetail.APU_Hours__c +'\nAPU Model Number- '+ fleetAssetDetail.APU_Model_Number__c+'\nFMS Equipment - '+ fleetAssetDetail.FMS_Equipment__c +'\nDatalink Equipment - '+ fleetAssetDetail.Datalink_Equipment__c + '\nSatellite Equipment - '+ fleetAssetDetail.Satellite_Equipment__c +'\nDatalink Service Provider - '+ fleetAssetDetail.Datalink_Service_Provider__c +'\nVoice Service Provider - '+ fleetAssetDetail.Voice_Service_Provider__c +'\nAvionics - '+ fleetAssetDetail.Avionics__c +'\nAPU Aircraft - '+ fleetAssetDetail.APU_Aircraft__c +'\nModel Number - '+ fleetAssetDetail.Model_Number__c +'\nWheels Brakes - '+ fleetAssetDetail.Wheels_Brakes__c +'\nWheels Brakes Comments - '+ fleetAssetDetail.Wheels_Brakes_Comments__c +'\nEntry into Service Representative - '+ tempServiceRepName +'\nPrimary Maint. Provider -  '+ tempPrimMaintProviderName +'\nChief Pilot - '+ tempChiefPilotName +'\nAviation Manager - '+ tempAviationManagerName +'\nDirector of Maintenance - '+ tempDirOfMaintenanceName +'\nFSE Mechanical - '+ tempFSEMechanicalName +'\nFSE Avionics - '+ tempFSEAvionicsName +'\n Customer Support Manager(CSM) - '+ tempCustSuppManagerName +'\nArea Sales Manager(ASM) - '+ tempAfterMarketSalesManagerName +'\nSignificant Customer Delivery Issues - '+ fleetAssetDetail.Significant_Customer_Delivery_Issues__c +'\n Comments - '+ fleetAssetDetail.Comments__c + '\n Tech Pub Contact Name -' + Techcontactname + '\n TechPub Shipping Address-' +TechshipAdd+ '\n TechPub Email Address-'+EmailAdd+ '\n TechPub Phone Number-'+PhoneNum+'\n\nThank you.';
           
           /***Description:Description field information added to the case extension field as per requirement ..........By TCS Team......//
           *@Author: TCS-GTO Team
           **/
               System.debug('caseNewAircraftDelivery***'+caseNewAircraftDelivery );
               if(tempAccountID != null && tempAccountID != '') caseNewAircraftDelivery.AccountId = tempAccountID;
               if(streetAddLine1 != null && streetAddLine1 != '')caseNewAircraftDelivery.Address_Line_1__c = streetAddLine1;
               if(streetAddLine2 != null && streetAddLine2 != '')caseNewAircraftDelivery.Address_Line_2__c = streetAddLine2;
               if(fleetAssetDetail.Cntry__c != null && fleetAssetDetail.Cntry__c != '')caseNewAircraftDelivery.Country__c = fleetAssetDetail.Cntry__c;
               if(city != null && city != '')caseNewAircraftDelivery.City_Name__c = city;
                if(fleetAssetDetail.State__c != null && fleetAssetDetail.State__c != '')caseNewAircraftDelivery.State_Code__c = fleetAssetDetail.State__c;
                //not writeable caseNewAircraftDelivery.Primary_Email_Address__c = primaryEmailAdd;
                if(AccPrimaryPhonenumber != null && AccPrimaryPhonenumber != '')caseNewAircraftDelivery.Account_Primary_Phone_Number__c =AccPrimaryPhonenumber;
                if(fleetAssetDetail.Aircraft_Delivery_Date__c != null)cc1.Aircraft_Delivery_Date__c = fleetAssetDetail.Aircraft_Delivery_Date__c ;
                if(fleetAssetDetail.Serial_Number__c != null && fleetAssetDetail.Serial_Number__c != '')caseNewAircraftDelivery.Aircraft_Serial_Number__c = fleetAssetDetail.Serial_Number__c ;
                if(fleetAssetDetail.Tail_Number__c != null && fleetAssetDetail.Tail_Number__c != '')caseNewAircraftDelivery.Aircraft_Tail_Number__c =fleetAssetDetail.Tail_Number__c;
                if(oem != null && oem != '')caseNewAircraftDelivery.OEM_N__c = oem;
                if(aircraftMake != null && aircraftMake != '')caseNewAircraftDelivery.CSM_Aircraft_Make__c =aircraftMake;
                if(aircraftModel != null && aircraftModel != '')caseNewAircraftDelivery.Aircraft_Type_Model__c = aircraftModel;
                if(fleetAssetDetail.Completion_Facility__c != null && fleetAssetDetail.Completion_Facility__c != '')cc1.Completion_Facility__c =fleetAssetDetail.Completion_Facility__c;
                if(fleetAssetDetail.Effective_Warranty_Date__c != null)cc1.Effective_Warranty_Date__c = fleetAssetDetail.Effective_Warranty_Date__c;
                if(fleetAssetDetail.MSP_Selected__c != null && fleetAssetDetail.MSP_Selected__c != '')cc1.MSP_Selected__c = fleetAssetDetail.MSP_Selected__c;
                if(fleetAssetDetail.Expected_Duration_of_EIS_Support__c != null )cc1.Expected_Duration_of_EIS_Support__c = fleetAssetDetail.Expected_Duration_of_EIS_Support__c;
                if(fleetAssetDetail.A_C_Hours__c != null && fleetAssetDetail.A_C_Hours__c != '')cc1.A_C_Hours__c = fleetAssetDetail.A_C_Hours__c;
                if(fleetAssetDetail.A_C_Cycles__c != null && fleetAssetDetail.A_C_Cycles__c != '')cc1.A_C_Cycles__c = fleetAssetDetail.A_C_Cycles__c;
                if(fleetAssetDetail.APU_S_N__c != null && fleetAssetDetail.APU_S_N__c != '')cc1.APU_S_N__c = fleetAssetDetail.APU_S_N__c;
                if(fleetAssetDetail.APU_Hours__c != null && fleetAssetDetail.APU_Hours__c != '')cc1.APU_Hours__c =fleetAssetDetail.APU_Hours__c;
                if(fleetAssetDetail.FMS_Equipment__c != null && fleetAssetDetail.FMS_Equipment__c != '')cc1.FMS_Equipment__c = fleetAssetDetail.FMS_Equipment__c;
                if(fleetAssetDetail.Datalink_Equipment__c != null && fleetAssetDetail.Datalink_Equipment__c != '')cc1.Datalink_Equipment__c =fleetAssetDetail.Datalink_Equipment__c;
                if(fleetAssetDetail.Satellite_Equipment__c != null && fleetAssetDetail.Satellite_Equipment__c != '')cc1.Satellite_Equipment__c = fleetAssetDetail.Satellite_Equipment__c;
                if(fleetAssetDetail.Datalink_Service_Provider__c != null && fleetAssetDetail.Datalink_Service_Provider__c != '')cc1.Datalink_Service_Provider__c = fleetAssetDetail.Datalink_Service_Provider__c;
                if(fleetAssetDetail.Voice_Service_Provider__c != null && fleetAssetDetail.Voice_Service_Provider__c != '')cc1.Voice_Service_Provider__c = fleetAssetDetail.Voice_Service_Provider__c;
                if(fleetAssetDetail.Avionics__c != null && fleetAssetDetail.Avionics__c != '')cc1.Avionics__c = fleetAssetDetail.Avionics__c;
                if(fleetAssetDetail.APU_Aircraft__c != null && fleetAssetDetail.APU_Aircraft__c != '')cc1.APU_Aircraft__c = fleetAssetDetail.APU_Aircraft__c;
                if(fleetAssetDetail.Model_Number__c != null && fleetAssetDetail.Model_Number__c != '')cc1.Model_Number__c = fleetAssetDetail.Model_Number__c;
                if(fleetAssetDetail.Wheels_Brakes__c != null && fleetAssetDetail.Wheels_Brakes__c != '')cc1.Wheels_Brakes__c = fleetAssetDetail.Wheels_Brakes__c ;
                if(fleetAssetDetail.Wheels_Brakes_Comments__c != null && fleetAssetDetail.Wheels_Brakes_Comments__c != '')cc1.Wheels_Brakes_Comments__c =fleetAssetDetail.Wheels_Brakes_Comments__c;
                if(tempServiceRepID != null && tempServiceRepID != '')cc1.Entry_Into_Service_Representative__c = tempServiceRepID;
                 if(tempOtherContact1Id != null && tempOtherContact1Id != '')cc1.Other_Contact1__c = tempOtherContact1Id;
                if(tempOtherContact2Id != null && tempOtherContact2Id != '')cc1.other_Contact_2__c = tempOtherContact2Id;
                System.debug('cc1***'+cc1);
                if(tempPrimMaintProviderID!= null && tempPrimMaintProviderID!= ''){
                System.debug('tempPrimMaintProviderID***'+tempPrimMaintProviderID);
                cc1.Primary_Maint_Provider__c = tempPrimMaintProviderID;
                }
                 System.debug('cc1 after if***'+cc1);
                if(tempChiefPilotID != null && tempChiefPilotID != '')cc1.Chief_Pilot__c = tempChiefPilotID;
                if(tempAviationManagerID != null && tempAviationManagerID != '')cc1.Aviation_Manager__c = tempAviationManagerID;
                if(tempDirOfMaintenanceID != null && tempDirOfMaintenanceID != '')cc1.Director_of_Maintenance__c = tempDirOfMaintenanceID;
                System.debug('tempFSEMechanicalId***'+tempFSEMechanicalId);
                System.debug('cc1.FSE_Mechanical__c***'+cc1.FSE_Mechanical__c);
                if(tempFSEMechanicalId != null && tempFSEMechanicalId != '')cc1.FSE_Mechanical__c = mapContID.get(tempFSEMechanicalId);
                System.debug('tempFSEMechanicalId@@@'+tempFSEMechanicalId);
                //System.debug('tempFSEMech CNT'+cntId);
                System.debug('cc1.FSE_Mechanical__c@@@'+cc1.FSE_Mechanical__c);
                if(tempFSEAvionicsId != null && tempFSEAvionicsId != '')cc1.FSE_Avionics__c =mapContID.get(tempFSEAvionicsId);
                System.debug('cc1.FSE_Avionics__c @@@'+cc1.FSE_Avionics__c);
                if(tempCustSuppManagerId != null && tempCustSuppManagerId != '')cc1.Customer_Support_Manager_CSM__c = tempCustSuppManagerId;
                if(tempAfterMarketSalesManagerId != null && tempAfterMarketSalesManagerId != '')cc1.Area_Sales_Manager__c = tempAfterMarketSalesManagerId;
                if(fleetAssetDetail.Significant_Customer_Delivery_Issues__c != null && fleetAssetDetail.Significant_Customer_Delivery_Issues__c != '')cc1.Significant_Customer_Delivery_Issues__c = 'fleetAssetDetail.Significant_Customer_Delivery_Issues__c';
                if(fleetAssetDetail.Comments__c != null && fleetAssetDetail.Comments__c != '')caseNewAircraftDelivery.Comments__c = fleetAssetDetail.Comments__c ;
                //..........Description field information added to the case extension field as per requirement ..........By TCS Team......//
                caseNewAircraftDelivery.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
                caseNewAircraftDelivery.Government_Compliance_SM_M_Content__c = 'Undetermined';
                caseNewAircraftDelivery.Classification__c = 'New Aircraft Delivery';
                caseNewAircraftDelivery.New_Account_Name__c = tempAccountID;
                If(cc.Country__c!=fleetAssetDetail.Cntry__c)cc1.Country__c = cc.Country__c;
                 if(cc.City__c != city) cc1.City__c = cc.City__c;
                 if(cc.State__c!=fleetAssetDetail.State__c)cc1.State__c = cc.State__c;
                   cc1.Sub_Region__c= cc.Sub_Region__c;
                   cc1.Region__c = cc.Region__c;
             
               insert caseNewAircraftDelivery;
               system.debug('**caseNewAircraftDelivery'+ caseNewAircraftDelivery);
               if(caseNewAircraftDelivery.ID !=null)
                cc1.Case_object__c = caseNewAircraftDelivery.ID;
                System.debug('CASE EXTEN Fields:'+cc1);
                 insert cc1;
                /**Description:Created an Activity and assigning it to CSM when a case is getting created.......By TCS Team......
                 *@author: TCS-GTO Team
                **/
                // createTask(tempAccountID,'Customer Service Manager',tempAccountName,caseNewAircraftDelivery.ID);
                // createTask(tempAccountID,'Area Sales Manager',tempAccountName,caseNewAircraftDelivery.ID);
                if(newTaskList.size()>0){
                    insert newTaskList;
                    system.debug('**newTaskList'+ newTaskList);
                    newTaskList.clear();    
                }
               caseAircraftDeliveryID = caseNewAircraftDelivery.id;
         /** Created an Activity and assigning it to CSM when a case is getting created.......By TCS Team......**/      
                
            }else{ //Create a case to Customer Master Team so that new Account can be created 
                tempAccountID = '0013000000bFxtr';
                System.debug('Inside Else caseNewAircraftDelivery ***'+caseNewAircraftDelivery );caseNewAircraftDelivery.Status = 'New';caseCustomerMaster.Origin = 'Email-SFDC_CustomerMaster';caseCustomerMaster.RecordTypeId = Label.Customer_Master_Data_Record_Type;caseCustomerMaster.OwnerId = Label.Customer_Master_Data_Team;
                caseCustomerMaster.Status = 'Open';
                caseCustomerMaster.Subject = 'Customer Registration: Account Association Request';
                
                System.debug('Inside Else caseNewAircraftDelivery1 ***'+caseNewAircraftDelivery );
    /***Description:Description field information added to the case extension field as per requirement ..........By TCS Team......//
           *@Author: TCS-GTO Team
           **/  
                 if(tempAccountID != null && tempAccountID != '')caseCustomerMaster.AccountId = tempAccountID;
                //not writeable caseCustomerMaster.Account_Type__c = selectedAccType
                if(streetAddLine1 != null && streetAddLine1 != '')caseCustomerMaster.Address_Line_1__c = streetAddLine1;
                if(streetAddLine2 != null && streetAddLine2 != '')caseCustomerMaster.Address_Line_2__c = streetAddLine2;
                if(fleetAssetDetail.Cntry__c != null && fleetAssetDetail.Cntry__c != '')caseCustomerMaster.Country__c = fleetAssetDetail.Cntry__c;
                if(city != null && city != '')caseCustomerMaster.City_Name__c = city;
                if(fleetAssetDetail.State__c != null && fleetAssetDetail.State__c != '')caseCustomerMaster.State_Code__c =fleetAssetDetail.State__c;
                System.debug('Inside Else caseNewAircraftDelivery 2 ***'+caseNewAircraftDelivery );
                //not writeable caseCustomerMaster.Primary_Email_Address__c = primaryEmailAdd;
                if(AccPrimaryPhonenumber != null && AccPrimaryPhonenumber != '')caseCustomerMaster.Account_Primary_Phone_Number__c = AccPrimaryPhonenumber;
                if(fleetAssetDetail.Aircraft_Delivery_Date__c != null )cc1.Aircraft_Delivery_Date__c = fleetAssetDetail.Aircraft_Delivery_Date__c ;
                if(fleetAssetDetail.Serial_Number__c != null && fleetAssetDetail.Serial_Number__c != '')caseCustomerMaster.Aircraft_Serial_Number__c = fleetAssetDetail.Serial_Number__c ;
                if(fleetAssetDetail.Tail_Number__c != null && fleetAssetDetail.Tail_Number__c != '')caseCustomerMaster.Aircraft_Tail_Number__c = fleetAssetDetail.Tail_Number__c;
                System.debug('Inside Else caseNewAircraftDelivery 3 ***'+caseNewAircraftDelivery );
                if(oem != null && oem != '')caseCustomerMaster.OEM_N__c = oem;
                if(aircraftMake != null && aircraftMake != '')caseCustomerMaster.CSM_Aircraft_Make__c =aircraftMake;
                if(aircraftModel != null && aircraftModel != '')caseCustomerMaster.Aircraft_Type_Model__c = aircraftModel;
                if(fleetAssetDetail.Completion_Facility__c != null && fleetAssetDetail.Completion_Facility__c != '')cc1.Completion_Facility__c = fleetAssetDetail.Completion_Facility__c;
                System.debug('Inside Else caseNewAircraftDelivery 4 ***'+caseNewAircraftDelivery );
                if(fleetAssetDetail.Effective_Warranty_Date__c != null )cc1.Effective_Warranty_Date__c = fleetAssetDetail.Effective_Warranty_Date__c;
                if(fleetAssetDetail.MSP_Selected__c != null && fleetAssetDetail.MSP_Selected__c != '')cc1.MSP_Selected__c = fleetAssetDetail.MSP_Selected__c;
                if(fleetAssetDetail.Expected_Duration_of_EIS_Support__c != null )cc1.Expected_Duration_of_EIS_Support__c = fleetAssetDetail.Expected_Duration_of_EIS_Support__c;
                if(fleetAssetDetail.A_C_Hours__c != null && fleetAssetDetail.A_C_Hours__c != '')cc1.A_C_Hours__c = fleetAssetDetail.A_C_Hours__c;
                if(fleetAssetDetail.A_C_Cycles__c != null && fleetAssetDetail.A_C_Cycles__c != '')cc1.A_C_Cycles__c = fleetAssetDetail.A_C_Cycles__c;
                if(fleetAssetDetail.APU_S_N__c != null && fleetAssetDetail.APU_S_N__c != '')cc1.APU_S_N__c = fleetAssetDetail.APU_S_N__c;
                if(fleetAssetDetail.APU_Hours__c != null && fleetAssetDetail.APU_Hours__c != '')cc1.APU_Hours__c = fleetAssetDetail.APU_Hours__c;
                if(fleetAssetDetail.FMS_Equipment__c != null && fleetAssetDetail.FMS_Equipment__c != '')cc1.FMS_Equipment__c = fleetAssetDetail.FMS_Equipment__c;
                if(fleetAssetDetail.Datalink_Equipment__c != null && fleetAssetDetail.Datalink_Equipment__c != '')cc1 .Datalink_Equipment__c =fleetAssetDetail.Datalink_Equipment__c;
                System.debug('Inside Else caseNewAircraftDelivery 5 ***'+caseNewAircraftDelivery );
                if(fleetAssetDetail.Satellite_Equipment__c != null && fleetAssetDetail.Satellite_Equipment__c != '')cc1.Satellite_Equipment__c = fleetAssetDetail.Satellite_Equipment__c;
                if(fleetAssetDetail.Datalink_Service_Provider__c != null && fleetAssetDetail.Datalink_Service_Provider__c != '')cc1.Datalink_Service_Provider__c = fleetAssetDetail.Datalink_Service_Provider__c;
                if(fleetAssetDetail.Voice_Service_Provider__c != null && fleetAssetDetail.Voice_Service_Provider__c != '')cc1.Voice_Service_Provider__c = fleetAssetDetail.Voice_Service_Provider__c;
                if(fleetAssetDetail.Avionics__c != null && fleetAssetDetail.Avionics__c != '')cc1.Avionics__c = fleetAssetDetail.Avionics__c;
                if(fleetAssetDetail.APU_Aircraft__c != null && fleetAssetDetail.APU_Aircraft__c != '')cc1.APU_Aircraft__c = fleetAssetDetail.APU_Aircraft__c;
                if(fleetAssetDetail.Model_Number__c != null && fleetAssetDetail.Model_Number__c != '')cc1.Model_Number__c = fleetAssetDetail.Model_Number__c;
                if(fleetAssetDetail.Wheels_Brakes__c != null && fleetAssetDetail.Wheels_Brakes__c != '')cc1.Wheels_Brakes__c = fleetAssetDetail.Wheels_Brakes__c ;
                if(fleetAssetDetail.Wheels_Brakes_Comments__c != null && fleetAssetDetail.Wheels_Brakes_Comments__c != '')cc1.Wheels_Brakes_Comments__c = fleetAssetDetail.Wheels_Brakes_Comments__c;
                if(tempServiceRepID != null && tempServiceRepID != '')cc1.Entry_Into_Service_Representative__c = tempServiceRepID;
                if(tempOtherContact1Id != null && tempOtherContact1Id != '')cc1.Other_Contact1__c = tempOtherContact1Id;
                if(tempOtherContact2Id != null && tempOtherContact2Id != '')cc1.other_Contact_2__c = tempOtherContact2Id;
                System.debug('Inside Else caseNewAircraftDelivery 6 ***'+caseNewAircraftDelivery );
                if(tempPrimMaintProviderID != null && tempPrimMaintProviderID != '')cc1.Primary_Maint_Provider__c = tempPrimMaintProviderID;
                if(tempChiefPilotID != null && tempChiefPilotID != '')cc1.Chief_Pilot__c = tempChiefPilotID;
                if(tempAviationManagerID != null && tempAviationManagerID != '')cc1.Aviation_Manager__c = tempAviationManagerID;
                if(tempDirOfMaintenanceID != null && tempDirOfMaintenanceID != '')cc1.Director_of_Maintenance__c = tempDirOfMaintenanceID;
                if(tempFSEMechanicalID != null && tempFSEMechanicalID != '')cc1.FSE_Mechanical__c = tempFSEMechanicalID;
                if(tempFSEAvionicsID != null && tempFSEAvionicsID != '')cc1.FSE_Avionics__c = tempFSEAvionicsID;
                if(tempCustSuppManagerID != null && tempCustSuppManagerID != '')cc1.Customer_Support_Manager_CSM__c = tempCustSuppManagerID;
                if(tempAfterMarketSalesManagerID != null && tempAfterMarketSalesManagerID != '') cc1.Area_Sales_Manager__c = tempAfterMarketSalesManagerID;
                System.debug('Inside Else caseNewAircraftDelivery 7 ***'+caseNewAircraftDelivery );
                if(fleetAssetDetail.Significant_Customer_Delivery_Issues__c != null && fleetAssetDetail.Significant_Customer_Delivery_Issues__c != '')cc1.Significant_Customer_Delivery_Issues__c = fleetAssetDetail.Significant_Customer_Delivery_Issues__c;
                if(fleetAssetDetail.Comments__c != null && fleetAssetDetail.Comments__c != '')
                caseCustomerMaster.Comments__c = fleetAssetDetail.Comments__c ;
                System.debug('Inside Else caseNewAircraftDelivery 8 ***'+caseNewAircraftDelivery );
                caseCustomerMaster.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';caseCustomerMaster.Government_Compliance_SM_M_Content__c = 'Undetermined';
                caseCustomerMaster.Classification__c = 'New Aircraft Delivery';caseCustomerMaster.New_Account_Name__c = '0013000000bFxtr';
                caseCustomerMaster.Description = 'Hi, \n\n A new request from New Aircraft Notification form has been created.\n\nPlease find the details for the creation of New Account.\n\nAccount Name - ' + tempAccountName + '\n AccountType - '+ selectedAccType +'\n Street Address Line 1 - ' + streetAddLine1+'\n Street Address Line 2 - '+ streetAddLine2 + '\n Country - ' + fleetAssetDetail.Cntry__c + '\n City - '+ city +'\n State - ' + fleetAssetDetail.State__c + '\nZip Code - ' + zipCode + '\nPrimary Email Address - ' + primaryEmailAdd + '\nAccount Primary Phone Number - ' + AccPrimaryPhonenumber + '\nAircraft Delivery Date - ' + fleetAssetDetail.Aircraft_Delivery_Date__c +'\nPlatform Name - ' + tempPlatformName +'\nAircraft Serial Number - '+ fleetAssetDetail.Serial_Number__c +'\nTail Number - '+ fleetAssetDetail.Tail_Number__c +'\nOEM - '+ oem +'\n  Aircraft Model - '+ aircraftModel +'\nAircraft Make - '+ aircraftMake +'\nCompletion Facility - '+ fleetAssetDetail.Completion_Facility__c +'\nEffective Warranty Date - '+ fleetAssetDetail.Effective_Warranty_Date__c +'\nMSP Selected - '+ fleetAssetDetail.MSP_Selected__c +'\nExpected Duration of EIS Support - '+ fleetAssetDetail.Expected_Duration_of_EIS_Support__c +'\nA/C Hours - '+ fleetAssetDetail.A_C_Hours__c +'\nOperational Base - '+ fleetAssetDetail.Operational_Based_City_Country__c +'\nA/C Cycles - '+ fleetAssetDetail.A_C_Cycles__c +'\nAPU S/N - '+ fleetAssetDetail.APU_S_N__c +'\nAPU Hours - '+ fleetAssetDetail.APU_Hours__c +'\nFMS Equipment - '+ fleetAssetDetail.FMS_Equipment__c +'\nDatalink Equipment - '+ fleetAssetDetail.Datalink_Equipment__c + '\nSatellite Equipment - '+ fleetAssetDetail.Satellite_Equipment__c +'\nDatalink Service Provider - '+ fleetAssetDetail.Datalink_Service_Provider__c +'\nVoice Service Provider - '+ fleetAssetDetail.Voice_Service_Provider__c +'\nAvionics - '+ fleetAssetDetail.Avionics__c +'\nAPU Aircraft - '+ fleetAssetDetail.APU_Aircraft__c +'\nModel Number - '+ fleetAssetDetail.Model_Number__c +'\nWheels Brakes - '+ fleetAssetDetail.Wheels_Brakes__c +'\nWheels Brakes Comments - '+ fleetAssetDetail.Wheels_Brakes_Comments__c +'\nEntry into Service Representative - '+ tempServiceRepName +'\nPrimary Maint. Provider -  '+ tempPrimMaintProviderName +'\nChief Pilot - '+ tempChiefPilotName +'\nAviation Manager - '+ tempAviationManagerName +'\nDirector of Maintenance - '+ tempDirOfMaintenanceName +'\nFSE Mechanical - '+ tempFSEMechanicalName +'\nFSE Avionics - '+ tempFSEAvionicsName +'\n Customer Support Manager(CSM) - '+ tempCustSuppManagerName +'\nArea Sales Manager(ASM) - '+ tempAfterMarketSalesManagerName +'\nSignificant Customer Delivery Issues - '+ fleetAssetDetail.Significant_Customer_Delivery_Issues__c +'\n Comments - '+ fleetAssetDetail.Comments__c + '\n Tech Pub Contact Name -' + Techcontactname + '\n TechPub Shipping Address-' +TechshipAdd+ '\n TechPub Email Address-'+EmailAdd+ '\n TechPub Phone Number-'+PhoneNum+'\n\nThank you.';
                caseCustomerMaster.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
                caseCustomerMaster.Government_Compliance_SM_M_Content__c = 'Undetermined';
                caseCustomerMaster.Classification__c = 'New Aircraft Delivery';
                System.debug('Inside Else caseNewAircraftDelivery 8 ***'+caseNewAircraftDelivery );
                If(cc.Country__c!=fleetAssetDetail.Cntry__c) cc1.Country__c = cc.Country__c;
                 if(cc.City__c != city) cc1.City__c = cc.City__c;
                 if(cc.State__c!=fleetAssetDetail.State__c)cc1.State__c = cc.State__c;
                   cc1.Sub_Region__c= cc.Sub_Region__c;
                   cc1.Region__c = cc.Region__c;
                System.debug('Inside Else before Insert caseNewAircraftDelivery ***'+caseNewAircraftDelivery );    
                insert caseCustomerMaster;
                system.debug('**After insert caseCustomerMaster'+ caseCustomerMaster);
                cc1.Case_object__c = caseCustomerMaster.ID;
                try{
                insert cc1;
                }
                catch(Exception ex){
                Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, ex.getMessage()));
                }    
                system.debug('**After insert cc1'+ cc1);
                Case Trainingcase = new Case();
                Trainingcase.Origin = 'WEB';
                Trainingcase.RecordTypeId = Label.Training_RecordType_Id;
                Trainingcase.OwnerId = Label.Training_Team;
                Trainingcase.Status = 'NEW';
                Trainingcase.Contactid = Label.Training_Contact_Id;
                Trainingcase.Subject_Picklist__c = 'AIRCRAFT DELIVERY';
                Trainingcase.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                Trainingcase.Government_Compliance_SM_M_Content__c = 'NO';
                system.debug('**Before insert Trainingcase'+ Trainingcase);
                try{
                insert Trainingcase;
                }
                catch(Exception ex){
                Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, ex.getMessage()));
                }    
                system.debug('**After insert Trainingcase'+ Trainingcase);
                caseCustomerMaster.Classification__c = 'New Aircraft Delivery';
                try{
                update caseCustomerMaster;
                }
                catch(Exception ex){
     
                Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, ex.getMessage()));
                }                                        
                system.debug('case--->' + caseCustomerMaster.id);
                //Aircraft Delivery case update  with parent master case.
                caseNewAircraftDelivery.Status = 'New';
                caseNewAircraftDelivery.RecordTypeId = Label.New_Aircraft_Delivery_RT_ID;
                                        
                caseNewAircraftDelivery.origin = 'Web';
                caseNewAircraftDelivery.Subject = 'New Aircarft Notification: Fleet Asset Aircraft creation';
                caseNewAircraftDelivery.Description = 'Hi, \n\n A new request from New Aircraft Notification form has been created.\n\nPlease find the details for the creation of New Account.\n\nAccount Name - ' + tempAccountName + '\n AccountType - '+ selectedAccType +'\n Street Address Line 1 - ' + streetAddLine1+'\n Street Address Line 2 - '+ streetAddLine2 + '\n Country - ' + fleetAssetDetail.Cntry__c + '\n City - '+ city +'\n State - ' + fleetAssetDetail.State__c + '\nZip Code - ' + zipCode + '\nPrimary Email Address - ' + primaryEmailAdd + '\nAccount Primary Phone Number - ' + AccPrimaryPhonenumber + '\nAircraft Delivery Date - ' + fleetAssetDetail.Aircraft_Delivery_Date__c +'\nPlatform Name - ' + tempPlatformName +'\nAircraft Serial Number - '+ fleetAssetDetail.Serial_Number__c +'\nTail Number - '+ fleetAssetDetail.Tail_Number__c +'\nOEM - '+ oem +'\n  Aircraft Model - '+ aircraftModel +'\nAircraft Make - '+ aircraftMake +'\nCompletion Facility - '+ fleetAssetDetail.Completion_Facility__c +'\nEffective Warranty Date - '+ fleetAssetDetail.Effective_Warranty_Date__c +'\nMSP Selected - '+ fleetAssetDetail.MSP_Selected__c +'\nExpected Duration of EIS Support - '+ fleetAssetDetail.Expected_Duration_of_EIS_Support__c +'\nA/C Hours - '+ fleetAssetDetail.A_C_Hours__c +'\nOperational Base - '+ fleetAssetDetail.Operational_Based_City_Country__c +'\nA/C Cycles - '+ fleetAssetDetail.A_C_Cycles__c +'\nAPU S/N - '+ fleetAssetDetail.APU_S_N__c +'\nAPU Hours - '+ fleetAssetDetail.APU_Hours__c +'\nFMS Equipment - '+ fleetAssetDetail.FMS_Equipment__c +'\nDatalink Equipment - '+ fleetAssetDetail.Datalink_Equipment__c + '\nSatellite Equipment - '+ fleetAssetDetail.Satellite_Equipment__c +'\nDatalink Service Provider - '+ fleetAssetDetail.Datalink_Service_Provider__c +'\nVoice Service Provider - '+ fleetAssetDetail.Voice_Service_Provider__c +'\nAvionics - '+ fleetAssetDetail.Avionics__c +'\nAPU Aircraft - '+ fleetAssetDetail.APU_Aircraft__c +'\nModel Number - '+ fleetAssetDetail.Model_Number__c +'\nWheels Brakes - '+ fleetAssetDetail.Wheels_Brakes__c +'\nWheels Brakes Comments - '+ fleetAssetDetail.Wheels_Brakes_Comments__c +'\nEntry into Service Representative - '+ tempServiceRepName +'\nPrimary Maint. Provider -  '+ tempPrimMaintProviderName +'\nChief Pilot - '+ tempChiefPilotName +'\nAviation Manager - '+ tempAviationManagerName +'\nDirector of Maintenance - '+ tempDirOfMaintenanceName +'\nFSE Mechanical - '+ tempFSEMechanicalName +'\nFSE Avionics - '+ tempFSEAvionicsName +'\n Customer Support Manager(CSM) - '+ tempCustSuppManagerName +'\nArea Sales Manager(ASM) - '+ tempAfterMarketSalesManagerName +'\nSignificant Customer Delivery Issues - '+ fleetAssetDetail.Significant_Customer_Delivery_Issues__c +'\n Comments - '+ fleetAssetDetail.Comments__c + '\n Tech Pub Contact Name -' + Techcontactname + '\n TechPub Shipping Address-' +TechshipAdd+ '\n TechPub Email Address-'+EmailAdd+ '\n TechPub Phone Number-'+PhoneNum+'\n\nThank you.';
                Account acc = new account(name=tempAccountName);
                caseNewAircraftDelivery.AccountId = acc.Id;
    /***Description:Description field information added to the case extension field as per requirement ..........By TCS Team......//
           *@Author: TCS-GTO Team
           **/ 
                if(tempAccountID != null && tempAccountID != '')caseNewAircraftDelivery.AccountId = tempAccountID;
                //not writeable caseNewAircraftDelivery.Account_Type__c = selectedAccType
                if(streetAddLine1 != null && streetAddLine1 != '')caseNewAircraftDelivery.Address_Line_1__c = streetAddLine1;
                if(streetAddLine2 != null && streetAddLine2 != '')caseNewAircraftDelivery.Address_Line_2__c = streetAddLine2;
                if(fleetAssetDetail.Cntry__c != null && fleetAssetDetail.Cntry__c != '')caseNewAircraftDelivery.Country__c = fleetAssetDetail.Cntry__c;
                if(city != null && city != '')caseNewAircraftDelivery.City_Name__c = city;
                if(fleetAssetDetail.State__c != null && fleetAssetDetail.State__c != '')caseNewAircraftDelivery.State_Code__c = fleetAssetDetail.State__c;
                if(AccPrimaryPhonenumber != null && AccPrimaryPhonenumber != '')
                //not writeable caseNewAircraftDelivery.Primary_Email_Address__c = primaryEmailAdd;
                caseNewAircraftDelivery.Account_Primary_Phone_Number__c = AccPrimaryPhonenumber;
                if(fleetAssetDetail.Aircraft_Delivery_Date__c != null )cc1.Aircraft_Delivery_Date__c = fleetAssetDetail.Aircraft_Delivery_Date__c ;
                if(fleetAssetDetail.Serial_Number__c != null && fleetAssetDetail.Serial_Number__c != '')caseNewAircraftDelivery.Aircraft_Serial_Number__c = fleetAssetDetail.Serial_Number__c;
                if(fleetAssetDetail.Tail_Number__c != null && fleetAssetDetail.Tail_Number__c != '')caseNewAircraftDelivery.Aircraft_Tail_Number__c = fleetAssetDetail.Tail_Number__c;
                if(oem != null && oem != '')caseNewAircraftDelivery.OEM_N__c = oem;
                if(aircraftMake != null && aircraftMake != '')caseNewAircraftDelivery.CSM_Aircraft_Make__c =aircraftMake;
                if(aircraftModel != null && aircraftModel != '')caseNewAircraftDelivery.Aircraft_Type_Model__c = aircraftModel;
                if(fleetAssetDetail.Completion_Facility__c != null && fleetAssetDetail.Completion_Facility__c != '')cc1.Completion_Facility__c = fleetAssetDetail.Completion_Facility__c;
                if(fleetAssetDetail.Effective_Warranty_Date__c != null )cc1.Effective_Warranty_Date__c = fleetAssetDetail.Effective_Warranty_Date__c;
                if(fleetAssetDetail.MSP_Selected__c != null && fleetAssetDetail.MSP_Selected__c != '')cc1.MSP_Selected__c = 'fleetAssetDetail.MSP_Selected__c';
                if(fleetAssetDetail.Expected_Duration_of_EIS_Support__c != null )cc1.Expected_Duration_of_EIS_Support__c = fleetAssetDetail.Expected_Duration_of_EIS_Support__c;
                if(fleetAssetDetail.A_C_Hours__c != null && fleetAssetDetail.A_C_Hours__c != '')cc1.A_C_Hours__c = fleetAssetDetail.A_C_Hours__c;
                if(fleetAssetDetail.A_C_Cycles__c != null && fleetAssetDetail.A_C_Cycles__c != '')cc1.A_C_Cycles__c = fleetAssetDetail.A_C_Cycles__c;
                if(fleetAssetDetail.APU_S_N__c != null && fleetAssetDetail.APU_S_N__c != '')cc1.APU_S_N__c = fleetAssetDetail.APU_S_N__c;
                if(fleetAssetDetail.APU_Hours__c != null && fleetAssetDetail.APU_Hours__c != '')cc1.APU_Hours__c = fleetAssetDetail.APU_Hours__c;
                if(fleetAssetDetail.FMS_Equipment__c != null && fleetAssetDetail.FMS_Equipment__c != '')cc1.FMS_Equipment__c = fleetAssetDetail.FMS_Equipment__c;
                if(fleetAssetDetail.Datalink_Equipment__c != null && fleetAssetDetail.Datalink_Equipment__c != '')cc1.Datalink_Equipment__c =fleetAssetDetail.Datalink_Equipment__c;
                if(fleetAssetDetail.Satellite_Equipment__c != null && fleetAssetDetail.Satellite_Equipment__c != '')cc1.Satellite_Equipment__c = fleetAssetDetail.Satellite_Equipment__c;
                if(fleetAssetDetail.Datalink_Service_Provider__c != null && fleetAssetDetail.Datalink_Service_Provider__c != '')cc1.Datalink_Service_Provider__c = fleetAssetDetail.Datalink_Service_Provider__c;
                if(fleetAssetDetail.Voice_Service_Provider__c != null && fleetAssetDetail.Voice_Service_Provider__c != '')cc1.Voice_Service_Provider__c = fleetAssetDetail.Voice_Service_Provider__c;
                if(fleetAssetDetail.Avionics__c != null && fleetAssetDetail.Avionics__c != '')cc1.Avionics__c = fleetAssetDetail.Avionics__c;
                if(fleetAssetDetail.APU_Aircraft__c != null && fleetAssetDetail.APU_Aircraft__c != '')cc1.APU_Aircraft__c = fleetAssetDetail.APU_Aircraft__c;
                if(fleetAssetDetail.Model_Number__c != null && fleetAssetDetail.Model_Number__c != '')cc1.Model_Number__c = fleetAssetDetail.Model_Number__c;
                if(fleetAssetDetail.Wheels_Brakes__c != null && fleetAssetDetail.Wheels_Brakes__c != '')cc1.Wheels_Brakes__c = fleetAssetDetail.Wheels_Brakes__c ;
                if(fleetAssetDetail.Wheels_Brakes_Comments__c != null && fleetAssetDetail.Wheels_Brakes_Comments__c != '')cc1.Wheels_Brakes_Comments__c = fleetAssetDetail.Wheels_Brakes_Comments__c;
                if(tempServiceRepID != null && tempServiceRepID != '')cc1.Entry_Into_Service_Representative__c = tempServiceRepID;
                if(tempOtherContact1Id != null && tempOtherContact1Id != '')cc1.Other_Contact1__c = tempOtherContact1Id;
                if(tempOtherContact2Id != null && tempOtherContact2Id != '')cc1.other_Contact_2__c = tempOtherContact2Id;
                if(tempPrimMaintProviderID != null && tempPrimMaintProviderID != '')cc1.Primary_Maint_Provider__c = tempPrimMaintProviderID;
                if(tempChiefPilotID != null && tempChiefPilotID != '')cc1.Chief_Pilot__c = tempChiefPilotID;
                if(tempAviationManagerID != null && tempAviationManagerID != '')cc1.Aviation_Manager__c = tempAviationManagerID;
                if(tempDirOfMaintenanceID != null && tempDirOfMaintenanceID != '')cc1.Director_of_Maintenance__c = tempDirOfMaintenanceID;
                if(tempFSEMechanicalID != null && tempFSEMechanicalID != '')cc1.FSE_Mechanical__c = tempFSEMechanicalID;
                if(tempFSEAvionicsID != null && tempFSEAvionicsID != '')cc1.FSE_Avionics__c = tempFSEAvionicsID;
                if(tempCustSuppManagerID != null && tempCustSuppManagerID != '')cc1.Customer_Support_Manager_CSM__c = tempCustSuppManagerID;
                if(tempAfterMarketSalesManagerID != null && tempAfterMarketSalesManagerID != '')cc1.Area_Sales_Manager__c = tempAfterMarketSalesManagerID;
                if(fleetAssetDetail.Significant_Customer_Delivery_Issues__c != null && fleetAssetDetail.Significant_Customer_Delivery_Issues__c != '')cc1.Significant_Customer_Delivery_Issues__c = fleetAssetDetail.Significant_Customer_Delivery_Issues__c;
                if(fleetAssetDetail.Comments__c != null && fleetAssetDetail.Comments__c != '')
                caseNewAircraftDelivery.Comments__c = fleetAssetDetail.Comments__c ;
                caseNewAircraftDelivery.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
                caseNewAircraftDelivery.Government_Compliance_SM_M_Content__c = 'Undetermined';
                caseNewAircraftDelivery.Classification__c = 'New Aircraft Delivery';
                caseNewAircraftDelivery.New_Account_Name__c = tempAccountID;
                caseNewAircraftDelivery.ownerid = Label.Customer_Master_Data_Team;
                If(cc.Country__c!=fleetAssetDetail.Cntry__c) cc1.Country__c = cc.Country__c;
                
                 if(cc.City__c != city)cc1.City__c = cc.City__c;
                 if(cc.State__c!=fleetAssetDetail.State__c)cc1.State__c = cc.State__c;
                   cc1.Sub_Region__c= cc.Sub_Region__c;
                   cc1.Region__c = cc.Region__c;
                
                //Update the New Aircraft Delivery case with parent ID(Customer Master Case)
                if(caseCustomerMaster.Id != null) caseNewAircraftDelivery.parentId = caseCustomerMaster.Id;
                
                insert caseNewAircraftDelivery; caseAircraftDeliveryID = caseNewAircraftDelivery.id;
                //cc1.Case_object__c = caseNewAircraftDelivery.ID;
                cc1.Retention_Hold_Reason__c = 'NADN Case Extention for New Account Senario';
                upsert cc1;
            }
            /* Create Fleet Asset Aircraft Start*/
            if(tempAccountID != null && tempAccountID != '') fleetAssetDetail.Account__c = tempAccountID; 
            if(tempServiceRepID!= null && tempServiceRepID != '')fleetAssetDetail.Entry_Into_Service_Representative__c = tempServiceRepID;
            if(tempPlatformID != null && tempPlatformID != '')fleetAssetDetail.Platform_Name__c = tempPlatformID;
            if(tempChiefPilotID != null && tempChiefPilotID != '')fleetAssetDetail.Chief_Pilot__c = tempChiefPilotID;
            if(tempAviationManagerID != null && tempAviationManagerID != '') fleetAssetDetail.Aviation_Manager__c = tempAviationManagerID;
            if(tempPrimMaintProviderID != null && tempPrimMaintProviderID != '')fleetAssetDetail.Primary_Maint_Provider__c = tempPrimMaintProviderID;
            if(tempDirOfMaintenanceID != null && tempDirOfMaintenanceID != '')fleetAssetDetail.Director_of_Maintenance__c = tempDirOfMaintenanceID;
            if(tempFSEMechanicalID != null && tempFSEMechanicalID != '')fleetAssetDetail.FSE_Mechanical__c = mapContID.get(tempFSEMechanicalId);
            if(tempFSEAvionicsID != null && tempFSEAvionicsID != '')fleetAssetDetail.FSE_Avionics__c = mapContID.get(tempFSEAvionicsID);
            if(tempCustSuppManagerID != null && tempCustSuppManagerID != '')fleetAssetDetail.Customer_Support_Manager_CSM__c = tempCustSuppManagerID;            
            if(tempAfterMarketSalesManagerID != null && tempAfterMarketSalesManagerID != '') fleetAssetDetail.Area_Sales_Manager__c = tempAfterMarketSalesManagerID;
               
            fleetAssetDetail.New_Alert_Identification__c = true;
            fleetAssetDetail.Submitted_by__c = userinfo.getuserId();
            fleetAssetDetail.Submission_Date__c = datetime.now();
            System.debug('caseAircraftDeliveryID**'+caseAircraftDeliveryID );
            
            if(caseAircraftDeliveryID != null)
                fleetAssetDetail.Case_Associated__c = caseAircraftDeliveryID;
            try{  
                  insert fleetAssetDetail;
            }catch(Exception ex){
            
                if(ex.getMessage().contains('DUPLICATE_VALUE'))
                {      
                    Integer result=0;
                     String existingFleetId;
                    if(ex.getMessage().contains('duplicates value on record with id: a1O'))
                        result = ex.getMessage().indexOf('a1O');
                    if(result>0)    
                        existingFleetId=ex.getMessage().substring(result,result+15);
                              
                    if(existingFleetId !=null && existingFleetId.length()>0)
                        fleetAssetRecordId = existingFleetId;
                        newCaseDeliveryID =caseAircraftDeliveryID;
                       // if(caseNewAircraftDelivery.ID!=null) //new 
                       // sendNotification(caseAircraftDeliveryID);
                        rollBackReq = false;
                        system.debug('rollBackReq-->' + rollBackReq);        
                //Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Record is already exists for combination of account/Fleet Asset Aircraft Number/Serial Number '));
                }
                else
                    Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, ex.getMessage()));
            }
            system.debug('fleetAssetDetail-->' + fleetAssetDetail.id);
            if(fleetAssetDetail.id!=null)
            fleetAssetRecordId = fleetAssetDetail.id;
            /* Create Fleet Asset Aircraft End*/
            if(fleetAssetDetail.id != null && caseAircraftDeliveryID != null){
                caseNewAircraftDelivery.Fleet_Asset_Aircraft_Number__c = fleetAssetRecordId;
                system.debug('caseAircraftDeliveryID--->' + caseAircraftDeliveryID);
                caseNewAircraftDelivery.id = caseAircraftDeliveryID;
                update caseNewAircraftDelivery;
                //displaySuccess = true;
                    
            }
            system.debug('Inside try-->' );           
        }catch(Exception ex){
            if(rollBackReq){
                Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING, ex.getMessage()));
                system.debug('rollBackReq-->' + rollBackReq);
                Database.RollBack(sp);  
            }          
            //Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
        }
        return null;
    } 
    @RemoteAction
    global static List<string> getMakeAndModel(string platformId)
    {   List<string> listMakeModel = null;
        system.debug('--->' + platformId);
        if(platformId != null && platformId != ''){ 
            Platform__c platform = [select make__c,model__c, OEM_Name__r.name  from Platform__c where id=:platformId];
            if(platform != null){
                listMakeModel = new List<string>(); 
                if(platform.make__c != null) listMakeModel.add(platform.make__c);
                else
                    listMakeModel.add('');
                    
                if(platform.model__c != null)  listMakeModel.add(platform.model__c); 
                else
                    listMakeModel.add('');   
                if(platform.OEM_Name__r.name != null){     
                    listMakeModel.add(platform.OEM_Name__r.name); 
                }
                else
                    listMakeModel.add('');    
            }
        }
        system.debug('---->' + listMakeModel);
        return listMakeModel;
    }
    @RemoteAction
    global static List<string> getAccountAddress(string accountId)
    {   List<string> listAccountAddress = null;
        if(accountId != null && accountId != ''){ 
            Account accountAddDetails = [select Name,Type, Report_Address_Line_1__c, Report_Address_Line_2__c, Report_City_Name__c,Report_Country_Name__c,Report_Postal_Code__c,Report_State_Code__c,phone, Strategic_Business_Unit__c, Region_Name__c, Sub_Region_Name__c from Account where id=:accountId];
            system.debug('-->'+ accountAddDetails );
            if(accountAddDetails != null){
                listAccountAddress = new List<string>();   
                if(accountAddDetails.Name != null) listAccountAddress.add(accountAddDetails.Name);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Report_Address_Line_1__c != null) listAccountAddress.add(accountAddDetails.Report_Address_Line_1__c);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Report_Address_Line_2__c != null) listAccountAddress.add(accountAddDetails.Report_Address_Line_2__c);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Report_City_Name__c!= null) listAccountAddress.add(accountAddDetails.Report_City_Name__c);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Report_Country_Name__c!= null) listAccountAddress.add(accountAddDetails.Report_Country_Name__c);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Report_Postal_Code__c!= null)  listAccountAddress.add(accountAddDetails.Report_Postal_Code__c);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.phone!= null)  listAccountAddress.add(accountAddDetails.phone);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.type!= null)listAccountAddress.add(accountAddDetails.type);
                else
                    listAccountAddress.add('');
                //if(accountAddDetails.Email!= null)
                //    listAccountAddress.add(accountAddDetails.type);
                //else
                    listAccountAddress.add('');
                if(accountAddDetails.Report_State_Code__c!= null) listAccountAddress.add(accountAddDetails.Report_State_Code__c);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Region_Name__c != null) listAccountAddress.add(accountAddDetails.Region_Name__c );
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Sub_Region_Name__c != null) listAccountAddress.add(accountAddDetails.Sub_Region_Name__c);
                else
                    listAccountAddress.add('');
                if(accountAddDetails.Strategic_Business_Unit__c != null) listAccountAddress.add(accountAddDetails.Strategic_Business_Unit__c);
                else
                    listAccountAddress.add('');
            }
        }
        system.debug('11-->'+listAccountAddress);
        return listAccountAddress;
    }  
    /** Created remote Action for auto populating CSM,ASM,FSE Avionics & FSE Mechanical....**/
    
    //****************Auto complete feature for Contact ********************//
    @RemoteAction
    public static List<Contact> searchContacts(String searchTerm) {
        System.debug('Contact-->'+searchTerm );
        List<Contact> contacts = Database.query('Select Id, Name,Email from Contact where name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        return contacts;
    }
    //****************Auto complete feature for Contact ********************//
    //****************Auto complete feature for Account ********************//
    public string selectedAccount{get;set;}
    @RemoteAction
    public static List<Account> searchAccounts(String searchTerm) {
        System.debug('Account-->'+searchTerm );
        List<Account> accounts = Database.query('Select Id, Name from Account where name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        System.debug('Account-->'+accounts );
        return accounts;
    }
    //****************Auto complete feature for Account ********************//
    //****************Auto complete feature for Platform ********************//
    public string selectedPlatfrom{get;set;}
    @RemoteAction
    public static List<Platform__c> searchPlatforms(String searchTerm){   
         System.debug('Platform-->'+searchTerm );       
         List<Platform__c> platforms = Database.query('Select Id, Name from Platform__c where Active__c = True and name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');       
         System.debug('platforms -->'+ platforms );      
         return platforms;   
    }
    //****************Auto complete feature for Platform ********************//
     @RemoteAction
     Static public Fleet_Asset_Detail__c FleetAssetupdate(String Fleetid)
    {
    Fleet_Asset_Detail__c fsd;
       system.debug('inside caseownerupdate---->'+Fleetid);
       Try{
        fsd=[select id from Fleet_Asset_Detail__c where id=:Fleetid];
       fsd.Fleet_Asset_Notification__c = true;
       update fsd;
       }catch(Exception ex){
            
            Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.warning, ex.getMessage()));
             RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
                tlog.Status__c = 'failed';
                tlog.Description__c = 'Aircraft Delivery Notification:'+ex;
                tlog.Case_Num__c = 'Fleet Asset Aircraft ID'+fsd.id;
                tlog.Sales_Order_Num__c = 'User Name:'+userinfo.getUserName();
                insert tlog;
        }
       return fsd;
    }
    @RemoteAction
     Static public Case caseUpdate(String caseId)
    {
    Case case1;
       system.debug('inside caseownerupdate---->'+caseId);
       Try{
        case1=[select id from Case where id=:caseId];      
       update case1;
       }catch(Exception ex){            
            Apexpages.addmessage(new ApexPages.Message(ApexPages.severity.warning, ex.getMessage()));
        }
       return case1;
    }
      /**
      * Method Name: getFleetDetails
      * Description:Created remote Action for auto populating CSM,ASM,FSE Avionics & FSE Mechanical....By TCS Team......
      * @author: TCS-GTO Team
      **/
    @RemoteAction
   global static Map<String,User> getFleetDetails(string tempAccountID)
     {
        System.debug('Getting Fleet info:'+tempAccountID);
         Map<String,User> accountTeamMap = new Map<String,User>();
         
           system.debug('--->Check if calling' + tempAccountID);
           if(tempAccountID != null && tempAccountID != '' ){  
            List<AccountTeamMember> accountTeamList = [SELECT ID,TeamMemberRole,UserId FROM AccountTeamMember WHERE AccountId =: tempAccountID] ;
             System.debug('**accountTeamList'+accountTeamList);
             List<ID> userIds = new List<ID>();
             for(AccountTeamMember ATM : accountTeamList){
                userIds.add(ATM.UserId);
             }
            Map<Id,User>  userMap=new Map<Id,User>([SELECT Id,Name FROM User where id IN: userIds]);
        
        for(AccountTeamMember ATM : accountTeamList){           
            accountTeamMap.put(ATM.TeamMemberRole,userMap.get(ATM.UserId));
           }
      }
      System.debug('**accountTeamMap'+accountTeamMap);
       return accountTeamMap;
      }
   /**
    * Method Name: searchDetails
    * Description:Auto complete feature for CSM,ASM,etc ********************By TCS Team......
    * author: TCS-GTO Team
    **/
  @RemoteAction
  public static List<Fleet_Asset_Detail__c> searchDetails(String searchTerm){   
    List<Fleet_Asset_Detail__c> details1 = Database.query( 'Select Customer_Support_Manager_CSM__r.name, Area_Sales_Manager__r.name, FSE_Avionics__r.name,FSE_Mechanical__r.name from Fleet_Asset_Detail__c where State__c   Like \' %' + String.escapeSingleQuotes(searchTerm) +'%\' ');
    /** 
      * Method Name: createTask
      * Description : This method used to create Task  
      * Owner:GTO TCS Team
     **/ 
   /** private void createTask(String tempAccountID1,String TeamMemberRoleDesc,String tempAccountName1,String caseNewAircraftDeliveryID){
         System.debug('***'+tempAccountID1+':'+TeamMemberRoleDesc+':'+tempAccountName1+':'+caseNewAircraftDeliveryID );
        AccountTeamMember[] user1;
        if(tempAccountID1 !=null){
            user1 = [SELECT UserId FROM AccountTeamMember WHERE AccountId =: tempAccountID1 AND  TeamMemberRole =: TeamMemberRoleDesc limit 1];
            System.debug('user1 ***'+user1 );
        }
        if(user1.size()>0 && user1[0].UserId != null){
        Task newTask = new Task();
            newTask.RecordTypeId = Label.Task_Record_Type;
            newTask.OwnerId = user1[0].UserId ;
            //newTask.WhoId = user1[0].UserId ;
            
            newTask.Type = 'Customer Communication';
            newTask.ActivityDate = date.today().addDays(7);
            newTask.Subject = 'New Aircraft Delivery Notification '+ tempAccountName1 ;
            newTask.Description = 'Contact customer regarding new aircraft delivery';
            newTask.WhatId = caseNewAircraftDeliveryID;
            newTaskList.add(newTask); 
            System.debug('newTask***'+newTask);
    }      
    }  **/ 
    return details1;
  }
    /** 
      * Method Name: sendNotification
      * Description : This method used to search for sending email/notification  
      * Owner:GTO TCS Team
      * 
    **/ 
    @RemoteAction
     public static void sendNotification(String existingFleetId){ 
         try{
         System.debug('existingFleetId**'+existingFleetId);
         List <Attachment > attList = new List < Attachment > ();
         string emailTemplateId = Label.NADN_notification_for_ASM_CSM_FSE_s;
         
         if (existingFleetId!= null) {
            attList = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId = : existingFleetId];
            system.debug('attlist' + attList.size());
            }
             List <Messaging.EmailFileAttachment> efaList = new List <Messaging.EmailFileAttachment> ();
            if (attList.size() > 0 && attList != null) {
              for (Attachment att: attList) {
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(att.Name);efa.setBody(att.body);efa.setContentType(att.ContentType);efa.setInline(false);
                        efaList.add(efa);
     }
     system.debug('efaList1' + efaList.size());
    }
         List <Messaging.SingleEMailMessage > mails = new List < Messaging.SingleEMailMessage > (); // for contacts 
         if(existingFleetId !=null && existingFleetId.length()>0){
             Fleet_Asset_Detail__c existingFleet =[select id,Platform_Name__c from Fleet_Asset_Detail__c where Id=:existingFleetId];
             if(existingFleet!=null){
                 for (Contact con: [select id, Aircraft_Alert_for_Platforms__c from Contact where Aircraft_Notifications__c = true and Contact_Is_Employee__c = true and Email != '']) {
                     if (con.Aircraft_Alert_for_Platforms__c == 'All' && con.Aircraft_Alert_for_Platforms__c != 'None') {
                         Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                         mail.setTemplateID(emailTemplateId);                    
                         mail.setWhatId(existingFleet.Id);
                        //if(con.id==tempFSEMechanicalID ||con.id==tempFSEAvionicsID || con.id== tempCustSuppManagerID || con.id==tempAfterMarketSalesManagerID)
                         mail.setTargetObjectId(con.id);
                         mail.setSaveAsActivity(false); 
                         if(efaList.size()>0)
                         mail.setFileAttachments(efaList);                       
                         mails.add(mail);
                         system.debug('Id'+con.id);
                         system.debug('mails***'+mails);

                     }
                     else if (con.Aircraft_Alert_for_Platforms__c != 'None' && con.Aircraft_Alert_for_Platforms__c != null) {       
                         if (con.Aircraft_Alert_for_Platforms__c.contains(existingFleet.Platform_Name__c)) {
                             Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                             mail.setTemplateID(emailTemplateId);                    
                             mail.setWhatId(existingFleet.Id);
                             //if(con.id==tempFSEMechanicalID ||con.id==tempFSEAvionicsID || con.id== tempCustSuppManagerID || con.id==tempAfterMarketSalesManagerID)
                             mail.setTargetObjectId(con.id);        
                             mail.setSaveAsActivity(false); 
                             if(efaList.size()>0)
                             mail.setFileAttachments(efaList);                           
                             mails.add(mail);
                         }
                     }
                 }
             }
         }
         if(mails.size()>0)        
         Messaging.sendEmail(mails);
         system.debug('mails***'+mails);
         }catch(exception e){
             System.debug('exception**'+e.getMessage());
             //rollBackReq = false;
         } 
     }  
    
}