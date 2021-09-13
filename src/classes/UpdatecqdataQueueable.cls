/*******************************
Class Name: UpdatecqdataQueueable
Created by: HCL
Created Date: 7th Jan 2021
Description: This class will handle the logic to update cqdata
*******************************/
public class UpdatecqdataQueueable implements Queueable{
	List<Sales_Order_Reporting__c> salesorderlist = new List<Sales_Order_Reporting__c>();
	public UpdatecqdataQueueable(List<Sales_Order_Reporting__c> salesOrderRecords){
		salesorderlist = salesOrderRecords;
	}
	public void execute(QueueableContext context) {
		system.debug('salesorderlist: '+salesorderlist);
		set<id> cqidset = new set<id>();
		try{
			for(Sales_Order_Reporting__c so_rec : salesorderlist){
				
				system.debug('so_rec_cq: '+ so_rec.Contracted_Quote__c);
				if(so_rec.Contracted_Quote__c <> null ){
					cqidset.add(so_rec.Contracted_Quote__c);
				}
			}
			if(cqidset.size() > 0){
				// Map<Id,AggregateResult> results = new Map<Id,AggregateResult>([select Contracted_Quote__c Id,count(Id) SO_Count,sum(PO_Amount__c) from Sales_Order_Reporting__c where Contracted_Quote__c in : cqidset group by Contracted_Quote__c]);
				AggregateResult[] aggres_list = [select count(id) SO_Count,Contracted_Quote__c,sum(PO_Amt_number__c) PO_Amount, min(createddate) mincreateddate from Sales_Order_Reporting__c where Contracted_Quote__c in : cqidset group by Contracted_Quote__c];
				map<Id,Apttus_Proposal__Proposal__c> cqmap = new map<Id,Apttus_Proposal__Proposal__c>([select Id, CQ_No_of_Sales_Orders__c,CQ_FSO_Received__c,Quote_Type__c from Apttus_Proposal__Proposal__c where id in : cqidset]);
				List<Apttus_Proposal__Proposal__c> cq_soupd_list = new Apttus_Proposal__Proposal__c[]{};
					system.debug('aggres_list: '+aggres_list);
				system.debug('cqmap: '+cqmap);
				
				for(AggregateResult aggresult : aggres_list){
					
					Apttus_Proposal__Proposal__c cq_soupd = new Apttus_Proposal__Proposal__c();
					cq_soupd.id = (id)aggresult.get('Contracted_Quote__c');
					Datetime fso_rcd_dt = (datetime)aggresult.get('mincreateddate');
					
					if((integer)aggresult.get('SO_Count') == 1){
						cq_soupd.CQ_FSO_Received__c = true;
						cq_soupd.CQ_First_Sales_Order_Received_Date__c = system.today();
						cq_soupd.CQ_No_of_Sales_Orders__c = 1;
						cq_soupd.CQ_Total_Sales_Order_PO_Amount__c = (decimal)aggresult.get('PO_Amount');
						
						if(cqmap.get((id)aggresult.get('Contracted_Quote__c')).Quote_Type__c == 'CQ')
						{
							cq_soupd.Apttus_Proposal__Approval_Stage__c = GlobalConstants.Approvalstage_won;
						}
						
						if(cqmap.get((id)aggresult.get('Contracted_Quote__c')).Quote_Type__c == 'Direct CPQ')
						{
							cq_soupd.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_ACCEPTED;
							cq_soupd.Quote_Status__c=GlobalConstants.Direct_Quote_StatusClosed;
							
						}
						system.debug('Inside if');
						
					}
					
					// check if all the multiple salesorders are inserted and CQ doesnt have a salesorder before
					else if((integer)aggresult.get('SO_Count') > 1 && (cqmap.get((id)aggresult.get('Contracted_Quote__c')).CQ_FSO_Received__c == false)){
						
						cq_soupd.CQ_FSO_Received__c = true;
						cq_soupd.CQ_First_Sales_Order_Received_Date__c = date.newinstance(fso_rcd_dt.year(), fso_rcd_dt.month(), fso_rcd_dt.day());
						cq_soupd.CQ_No_of_Sales_Orders__c = (integer)aggresult.get('SO_Count');
						cq_soupd.CQ_Total_Sales_Order_PO_Amount__c = (decimal)aggresult.get('PO_Amount');
						if(cqmap.get((id)aggresult.get('Contracted_Quote__c')).Quote_Type__c == 'CQ')
						{
							cq_soupd.Apttus_Proposal__Approval_Stage__c = GlobalConstants.Approvalstage_won;
						}
						
						if(cqmap.get((id)aggresult.get('Contracted_Quote__c')).Quote_Type__c == 'Direct CPQ')
						{
							cq_soupd.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_ACCEPTED;
							cq_soupd.Quote_Status__c=GlobalConstants.Direct_Quote_StatusClosed;
							
						}
						system.debug('Inside else if');
					}
					
					//check if salesorder created is not first SO for the CQ
					else if((integer)aggresult.get('SO_Count') > 1 && cqmap.get((id)aggresult.get('Contracted_Quote__c')).CQ_FSO_Received__c == true){
						
						cq_soupd.CQ_No_of_Sales_Orders__c = (integer)aggresult.get('SO_Count');
						cq_soupd.CQ_Total_Sales_Order_PO_Amount__c = (decimal)aggresult.get('PO_Amount');
						system.debug('Inside else if2');
					}
					
					cq_soupd_list.add(cq_soupd);
					system.debug('cq_soupd '+ cq_soupd);   
				}
				update(cq_soupd_list); 
				system.debug('cq_soupd_list' + cq_soupd_list);
				system.debug('aggres_list' + aggres_list);
			}
		}
		catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_salesorderreporting_trigger_helper, GlobalConstants.M_updatecqdata);
		}	
	}
}