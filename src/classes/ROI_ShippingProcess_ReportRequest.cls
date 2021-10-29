/*********************************************************************************
Name         : ROI_ShippingProcess_ReportRequest
Created By   : Harikishore V
Company Name : NTT Data
Project      : <ROI> 
Created Date : 01-March-2016
Usages       : Inserting/Sending ROI Order Information records based on SAP input.           
**********************************************************************************/
global class ROI_ShippingProcess_ReportRequest{
    global class SAPDataToSFDC{
        webservice String WORK_STREAM;  
        webservice String EMAIL_TYPE;   
        webservice String START_DATE;
        webservice String END_DATE;
    }
    global class ResponseToSAP{
        webservice String MESSAGE;
        webservice String STATUS;
        webservice List<SourceInspectionDetails> SourceInspectionDetailsList;
    }
    global class SourceInspectionDetails{
        webservice String CASE_NUMBER;  
        webservice String DELIVERY_NUMBER;   
        webservice String CUSTOMER_EMAIL_ID;
        webservice String DELIVERY_CREATEDBY;
        webservice String DELIVERY_CREATED_ON;   
        webservice String DELIVERY_PERSON_EMAIL_ID; 
        webservice String TYPE_OF_SOURCE_INSPECTION;
        webservice String CUSTOMER_NUMBER;
        webservice String CUSTOMER_NAME;
        webservice String DISTRIBUTION_CHANNEL;
        webservice String SALES_ORDER_NUMBER;
        webservice String CONTRACTOR;
        webservice String REQUESTED_BY;
        webservice String CAGE_CODE;
        webservice String CONTRACT_NUMBER;
        webservice String PURCHASE_ORDER_NUMBER;
        webservice String PART_NUMBER;
        webservice String SHIPMENT_NUMBER;
        webservice String SERIAL_NUMBER;
        webservice String PLANT_CODE;
        webservice String CLIN;
        webservice String REQUESTED_BY_TELEPHONE;
        webservice String PART_DESCRIPTION;
        webservice String ADDRESS_LOCATION_BLDG_NUMBER;
        webservice String DELIVERY_CREATION_TIME;
        webservice String CONTRACTOR_PROCEDURE_PERFORM_GSI;
        webservice String DATETIME_PRODUCT_AVAILABLE;
        webservice String EXAMINATION_TYPE_REQUESTED;
        webservice String NUMBER_PRESENTED;
        webservice String HEADER_INFO;
        webservice String MESSAGE;
        webservice String STATUS;
    }
    webservice static ResponseToSAP sendROIOrders(SAPDataToSFDC casenum){
        List<ROI_Order_Information__c> ROISIOrdersList = new List<ROI_Order_Information__c>();
        ResponseToSAP res = new ResponseToSAP();
        List<SourceInspectionDetails> ROISIlist = new List<SourceInspectionDetails>();
        Date startDate = stringToDate(casenum.START_DATE);
        Date endDate = stringToDate(casenum.END_DATE);
        system.debug('---->Date Range: '+startDate+' : '+endDate);
        // Inserting ROI Order Information record to capture Input from SAP
        ROI_Order_Information__c ROIOrders = new ROI_Order_Information__c();
        ROIOrders.Start_Date__c = startDate;
        ROIOrders.End_Date__c = endDate;
        ROIOrders.Request_XML__c = string.valueOf(casenum);
        if(casenum.WORK_STREAM!=null && casenum.EMAIL_TYPE!=null && casenum.START_DATE!=null && casenum.END_DATE!=null){
            ROISIOrdersList  =  [SELECT Case_Number__c,Delivery_Number__c,Customer_Email_ID__c,Delivery_Created_By__c,Delivery_Created_On__c,Delivery_Person_s_Email_ID__c,Type_of_Source_Inspection__c,Customer_Number__c,Customer_Name__c,Distribution_Channel__c,Sales_Order_Number__c,Contractor__c,Requested_By__c,Cage_Code__c,Contract_Number__c,
                                Purchase_Order_Number__c,Part_Number__c,Shipment_Number__c,Serial_Number__c,Plant_Code__c,CLIN__c,Interface_Status__c,Error_Message__c,Email_Type__c,Work_Stream__c,Requested_by_Telephone__c,Part_Description__c,Address_Location_Bldg_Number__c,Time__c,Contractor_s_Procedure_to_Perform_GSI__c,Number_Presented__c,
                                Date_Time_Product_Available_for_Inspecti__c,Examination_Type_Requested__c,Header_Info__c from ROI_Order_Information__c where Work_Stream__c=:casenum.WORK_STREAM and Email_Type__c=:casenum.EMAIL_TYPE and Delivery_Created_On__c>=:startDate and Delivery_Created_On__c<=:endDate];
            if(ROISIOrdersList.size()>0){
                for(ROI_Order_Information__c roi:ROISIOrdersList){
                    SourceInspectionDetails si = new SourceInspectionDetails();
                    si.CASE_NUMBER = roi.Case_Number__c;
                    si.DELIVERY_NUMBER = roi.Delivery_Number__c;
                    si.CUSTOMER_EMAIL_ID = roi.Customer_Email_ID__c;
                    si.DELIVERY_CREATEDBY = roi.Delivery_Created_By__c;
                    si.DELIVERY_CREATED_ON = string.valueOf(roi.Delivery_Created_On__c);
                    si.DELIVERY_PERSON_EMAIL_ID = roi.Delivery_Person_s_Email_ID__c;
                    si.TYPE_OF_SOURCE_INSPECTION = roi.Type_of_Source_Inspection__c;
                    si.CUSTOMER_NUMBER = roi.Customer_Number__c;
                    si.CUSTOMER_NAME = roi.Customer_Name__c;
                    si.DISTRIBUTION_CHANNEL = roi.Distribution_Channel__c;
                    si.SALES_ORDER_NUMBER = roi.Sales_Order_Number__c;
                    si.CONTRACTOR = roi.Contractor__c;
                    si.REQUESTED_BY = roi.Requested_By__c;
                    si.CONTRACT_NUMBER = roi.Contract_Number__c;
                    si.CAGE_CODE = roi.Cage_Code__c;
                    si.PURCHASE_ORDER_NUMBER = roi.Purchase_Order_Number__c;
                    si.PART_NUMBER = roi.Part_Number__c;
                    si.SHIPMENT_NUMBER = roi.Shipment_Number__c;
                    si.SERIAL_NUMBER = roi.Serial_Number__c;
                    si.PLANT_CODE = roi.Plant_Code__c;
                    si.CLIN = roi.CLIN__c;
                    si.REQUESTED_BY_TELEPHONE = roi.Requested_by_Telephone__c;
                    si.PART_DESCRIPTION = roi.Part_Description__c;
                    si.ADDRESS_LOCATION_BLDG_NUMBER = roi.Address_Location_Bldg_Number__c;
                    si.DELIVERY_CREATION_TIME = roi.Time__c;
                    si.CONTRACTOR_PROCEDURE_PERFORM_GSI = roi.Contractor_s_Procedure_to_Perform_GSI__c;
                    si.DATETIME_PRODUCT_AVAILABLE = roi.Date_Time_Product_Available_for_Inspecti__c;
                    si.EXAMINATION_TYPE_REQUESTED = roi.Examination_Type_Requested__c;
                    si.NUMBER_PRESENTED = string.valueOf(roi.Number_Presented__c);
                    si.HEADER_INFO = roi.Header_Info__c;
                    si.MESSAGE = roi.Error_Message__c;
                    si.STATUS = roi.Interface_Status__c;
                    ROISIlist.add(si);
                }
                if(ROISIlist.size()>0){
                    res.STATUS = 'Success';
                    res.MESSAGE = 'Successfully Shipping Process Source Inspection details Sent';
                    res.SourceInspectionDetailsList = ROISIlist;
                }
            }
            else{
                res.STATUS = 'Failed';
                res.MESSAGE = 'No details found for the given Input';
                res.SourceInspectionDetailsList = null;
            }
            ROIOrders.Interface_Status__c = res.STATUS;
            ROIOrders.Error_Message__c = res.MESSAGE;
        }else{
            res.STATUS = 'Failed';
            res.MESSAGE = 'Invalid Data. Provide valid WorkStream, EmailType, StartDate add ENDDate';
            res.SourceInspectionDetailsList = null;
            ROIOrders.Interface_Status__c = res.STATUS;
            ROIOrders.Error_Message__c = res.MESSAGE;
        }
        insert ROIOrders;
        return res;
    }
    public static Date stringToDate(string dateString){
        Date sfdcdate = date.valueOf(dateString);
        system.debug('---->: '+sfdcdate);
        return sfdcdate;
    }
}