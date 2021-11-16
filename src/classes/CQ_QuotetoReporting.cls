/*Description:Class for CQ_ProposalTriggerHandler for Contracted Quote Record Type
*******************************/
public class CQ_QuotetoReporting  {
	
	/*Method Name: CQ_Report_Insert
*Description: This method is used to create CQ_report on CQ quote creation
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static void CQ_Report_Insert(map<id,Apttus_Proposal__Proposal__c> Insert_CQMap){
		try{		   
			set<id> cq_reportid_set = new set<id>();
			map<id,id> new_transfer = new map<id,id>();
			list<Apttus_Proposal__Proposal__c> CQ_lookupList = new  list<Apttus_Proposal__Proposal__c>();
			list<Apttus_Proposal__Proposal__c> CQ_lookup = new  list<Apttus_Proposal__Proposal__c>();
			list<Surround_CQ_Reporting__c> report_list = new list<Surround_CQ_Reporting__c>();
			map<String,Surround_CQ_Reporting__c> QuoteReporting_map=new map<String,Surround_CQ_Reporting__c>();
			Map<string, string> CQtoCqreportmap=GetDynamic_fields();
			
			if(!Insert_CQMap.isempty())
				report_list.addAll(CQ_ReportFieldmapping(Insert_CQMap.values(),CQtoCqreportmap,QuoteReporting_map));
			
			If(!report_list.isempty()){				
				database.SaveResult[] dbsave = database.insert(report_list);
				
				if(!GlobalConstants.IS_CQREPORTINGINSERT_FIRSTRUN){
					for(database.SaveResult newrep :dbsave)
						cq_reportid_set.add(newrep.id);
					
					if(!cq_reportid_set.isempty())					
						CQ_lookupList =[select id,CQ_Reporting_Link__c from Apttus_Proposal__Proposal__c where id in :Insert_CQMap.keySet()];  
					
					for(Surround_CQ_Reporting__c new_Surr : [select id,CQ_Quote_Proposal__c from Surround_CQ_Reporting__c where id in:cq_reportid_set])
						new_transfer.put(new_Surr.CQ_Quote_Proposal__c,new_Surr.id);
					
					for(Apttus_Proposal__Proposal__c new_update:CQ_lookupList ){
						if(new_transfer.containskey(new_update.Id))
							new_update.CQ_Reporting_Link__c=new_transfer.get(new_update.Id);
						CQ_lookup.add(new_update);
					}
									   
					if(!CQ_lookup.isempty()){
						system.debug('@@@@@@');
						database.update(CQ_lookup,false);					   
					}
						
					GlobalConstants.IS_CQREPORTINGINSERT_FIRSTRUN=TRUE;
				}
			}
		}catch(Exception ex){
			system.debug('#####'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CQ_QuotetoReporting, GlobalConstants.CQ_QuotetoReporting_CQ_Report_Insert);			
		}
	}
	/*Method Name: CQ_Report_Update
*Description: This method is used to update CQ_report on CQ quote updation
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/	
	public static void CQ_Report_Update(list<Apttus_Proposal__Proposal__c> Update_CQ){
		try{
			
			set<string> entityID = new set<string>();
			list<Surround_CQ_Reporting__c> report_list_upd = new list<Surround_CQ_Reporting__c>();
			List<Surround_CQ_Reporting__c> SurCQ_Querylist=new list<Surround_CQ_Reporting__c>();
			map<String,Surround_CQ_Reporting__c> QuoteReporting_map=new map<String,Surround_CQ_Reporting__c>();
			Map<string, string> CQtoCqreportmap=GetDynamic_fields();
			string CqReportingFields=' ';
			if(CQtoCqreportmap<>null){
				for(string Field:CQtoCqreportmap.values())
					CqReportingFields +=','+Field;
			}
			for(Apttus_Proposal__Proposal__c CQ_Update :Update_CQ)
				entityID.add(CQ_Update.NokiaCPQ_Proposal_Id__c);
			
			String Query=' Select Id '+CqReportingFields+' from Surround_CQ_Reporting__c where CQ_Number__C in : entityID ';		  
			SurCQ_Querylist=Database.query(Query);
			
			for(Surround_CQ_Reporting__c Quotereport:SurCQ_Querylist)
				QuoteReporting_map.put(Quotereport.CQ_Number__C,Quotereport);
			
			if(!Update_CQ.isempty()&&!QuoteReporting_map.isempty())
				report_list_upd.addAll(CQ_ReportFieldmapping(Update_CQ,CQtoCqreportmap,QuoteReporting_map));
			
			If(!report_list_upd.isempty()){
				system.debug('Globalconstants.REC_Count--->'+Globalconstants.REC_Count+'--->update---->'+report_list_upd[0].CQ_Quote_Path_Status__c);
				database.update(report_list_upd);
			}
			
			
		}catch(Exception ex){
			system.debug('excptn--->>>'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CQ_QuotetoReporting, GlobalConstants.CQ_QuotetoReporting_CQ_Report_Update);			
		}
	}
	  /*Method Name: CQ_Report_Delete
*Description: This method is used to delete CQ_report on CQ quote updation
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/   
	public static void CQ_Report_Delete(list<Apttus_Proposal__Proposal__c> Delete_CQ_list){
		try{
			set<string> entityID = new set<string>();
			for(Apttus_Proposal__Proposal__c CQ_Delete :Delete_CQ_list)
				entityID.add(CQ_Delete.NokiaCPQ_Proposal_Id__c);		   
			
			list<Surround_CQ_Reporting__c> report_list_remove =[select id from Surround_CQ_Reporting__c where CQ_Number__C IN : entityID];
			
			If(!report_list_remove.isempty())
				database.delete(report_list_remove,false);
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_QuotetoReporting, GlobalConstants.CQ_QuotetoReporting_CQ_Report_Update);			
		}		
	}
	/*Method Name: CQ_Report_Fieldmapping
*Description: This method is used to map fields from Quote/Proposal to CQ_Reporting 
*Parameters:  Quote/Proposal sObject, CQ_Reporting sObject
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/	
	public static list<Surround_CQ_Reporting__c> CQ_ReportFieldmapping(list<Apttus_Proposal__Proposal__c> CQ_Quotes,Map<string, string> CQtoCqreportmap,map<String,Surround_CQ_Reporting__c> QuoteReporting_map)
	{
		list<Surround_CQ_Reporting__c> CQreportinglist= new list<Surround_CQ_Reporting__c>();
		try{
			if(!CQtoCqreportmap.isempty()&&!CQ_Quotes.isempty())
			{ 
				for(Apttus_Proposal__Proposal__c Quote:CQ_Quotes){
					Surround_CQ_Reporting__c CqRep= (!QuoteReporting_map.isempty())&&QuoteReporting_map.containskey(Quote.NokiaCPQ_Proposal_Id__c) ?QuoteReporting_map.get(Quote.NokiaCPQ_Proposal_Id__c):new Surround_CQ_Reporting__c();
					for(String CQ_FieldApI:CQtoCqreportmap.keyset()){
						string CqRepField=CQtoCqreportmap.get(CQ_FieldApI);
						 if(CQ_FieldApI=='CQ_Quote_Path_Status__c')
						{
					   system.debug('Before_Quote.get(CQ_FieldApI)--->'+Quote.get(CQ_FieldApI));
					   system.debug('Before_CqRep.get(CqRepField)--->'+CqRep.get(CqRepField));

						}
						if(Quote.get(CQ_FieldApI)<>CqRep.get(CqRepField))CqRep.put(CqRepField,Quote.get(CQ_FieldApI));
						if(CQ_FieldApI=='CQ_Quote_Path_Status__c')
						{
							system.debug('After_Quote.get(CQ_FieldApI)--->'+Quote.get(CQ_FieldApI));
					   system.debug('After_CqRep.get(CqRepField)--->'+CqRep.get(CqRepField));

						}
					}
					CQreportinglist.add(CqRep);
				}
			}
		}
		catch(Exception ex){
			system.debug('map##'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CQ_QuotetoReporting, GlobalConstants.CQ_QuotetoReporting_CQ_Report_Fieldmapping);
		}
		return CQreportinglist;  
	}
	
	/*Method Name: GetDynamic_fields
*Description: This method is used to map fields from Quote/Proposal to CQ_Reporting 
*Parameters:  Quote/Proposal sObject, CQ_Reporting sObject
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static map<string,string> GetDynamic_fields(){
		Map<string, string> CQtoCqreportmap=new Map<string, string>();
		try{
			list<string> QuoteFields=GetObjectFields(GlobalConstants.QUOTE_PROPOSAL_OBJECT);
			list<string> QuoteReportingFields=GetObjectFields(GlobalConstants.Surround_CQ_Reporting);
			
			for(CQ_Fieldmapping__c Field:CQ_Fieldmapping__c.getall().values())
				if(Field.IsCQ_toQuoteReporting__c&&QuoteFields.contains(Field.Field__c)&&QuoteReportingFields.contains(Field.Field_to_Map__c))
				CQtoCqreportmap.Put(Field.Field__c,Field.Field_to_Map__c	);
			system.debug('CQtoCqreportmap'+CQtoCqreportmap);
		}
		catch(Exception ex){
			//system.debug('map##'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CQ_QuotetoReporting, GlobalConstants.GETDYNAMIC_FIELDS);
		}
		
		return CQtoCqreportmap;
	}
	
	/*Method Name: GetObjectFields
*Description: This method is used to map fields from Quote/Proposal to CQ_Reporting 
*Parameters:  Quote/Proposal sObject, CQ_Reporting sObject
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static list<string> GetObjectFields(String ObjectName){
		list<string> selectFields = new list<string>();
		try{
			Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
			
			if (fMap != null){
				for (Schema.SObjectField ft : fMap.values()){ 
					Schema.DescribeFieldResult fd = ft.getDescribe(); 
					selectFields.add(fd.getName());
				}
			}
		}
		catch(Exception ex){
			//system.debug('map##'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CQ_QuotetoReporting, GlobalConstants.GETSOBJECTFIELDS);
		}
		return selectFields;
	}
}