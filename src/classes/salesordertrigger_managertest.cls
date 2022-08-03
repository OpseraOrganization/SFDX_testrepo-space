/**
* Class Name: salesordertrigger_managertest
* Description: This class is used for to test apex class salesordertrigger_manager.
*/
@istest
public class salesordertrigger_managertest {
	
	static testmethod void createso(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.RunAs(userCreation){
			
			Account[] acc = TestDataFactory.createAccount(1);
			database.insert(acc);
			
			Opportunity opp1 = TestDataFactory.OpportunityCreation(1,acc[0])[0];
			opp1.StageName='Create Offer (Bid)';
			opp1.Phase_Status__c = 'Offer in Progress';
			database.insert(opp1);
			
			Apttus_Proposal__Proposal__c cq2 = TestDataFactory.createCQ(1,acc[0],opp1)[0];
			cq2.NokiaCPQ_Proposal_Id__c= 'cq1235';
			
			Test.startTest(); 
			Apttus_Proposal__Proposal__c[] cq = new Apttus_Proposal__Proposal__c[]{};
			cq.add(cq2);
	database.insert(cq);
			
			Apttus_Proposal__Proposal__c[] CQ_ins = [select id, NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c];
			system.debug('CQ_ins: '+CQ_ins);
			
			Sales_Order_Reporting__c so_inr =TestDataFactory.createSalesOrder(1,CQ_ins[0],acc[0])[0];
			so_inr.PO_Amount__c = 1000;
			so_inr.CurrencyIsoCode = 'INR';
			so_inr.ALU_Order_Number__c= '1000010';
			
			Sales_Order_Reporting__c[] so_rep = new  Sales_Order_Reporting__c[]{};
			so_rep.add(so_inr);
			
			database.saveresult[] so_sav = database.insert(so_rep);
			
			Sales_order__c so1 = new Sales_order__c();
			so1.ALU_Order_Number__c = '1000010';
			so1.SO_Task__c= 'c';
			
			Sales_order__c so2 = new Sales_order__c();
			so2.ALU_Order_Number__c = '1000011';
			so2.SO_Task__c= 'c';
			
	
			Sales_order__c[] so = new Sales_order__c[]{};
			so.add(so1);
			so.add(so2);
			database.upsert(so);
			
	 Sales_order__c so1_upd = [select Id,PO_Amount__c, ALU_Order_Number__c, SO_Task__c from Sales_order__c where ALU_Order_Number__c = '1000010'];
			system.debug('so1_upd: '+ so1_upd);
			system.debug('so_rep_1000010: '+ [select Id,PO_Amount__c, ALU_Order_Number__c, SO_Task__c from Sales_Order_Reporting__c where ALU_Order_Number__c = '1000010']);
			so1_upd.PO_Amount__c = 100;
			database.upsert(so1_upd);
			
			so1_upd.SO_Task__c = 'D';
			Sales_order__c[] so_upd_list = new Sales_order__c[]{};
	so_upd_list.add(so1_upd);
			so_upd_list.add(so2);
			database.upsert(so_upd_list);
			
			 list<Sales_order__c> lstSO = [select Id,ALU_Order_Number__c, SO_Task__c from Sales_order__c LIMIT 1 ];
			lstSO[0].ALU_Order_Number__c = '1000010';
			lstSO[0].SO_Task__c= 'a';
			lstSO[0]. Order__c = 'test2';
			update lstSO;
	Test.stopTest(); 
			
	 
		}
	}
}