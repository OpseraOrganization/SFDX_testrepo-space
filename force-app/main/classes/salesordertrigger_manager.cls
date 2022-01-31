public class salesordertrigger_manager {
	
	//============================================================================================= 
	// Method Name: checkALUOrderNumber
	// Purpose: This method method will check if Nokia Order number is starting with 1 or 4. If not, error is thrown
	// Author: Rakesh Dandae
	// ============================================================================================
	//  
	public static void checkALUOrderNumber(list<Sales_Order__c> salesOrderList){
		
		for(Sales_Order__c so : salesOrderList){
			Integer FirstNumber;
			String aon = so.ALU_Order_Number__c;
			if(aon<>null){
	FirstNumber = aon.charAt(0);
	system.debug('@@@@@@@@@@@@FirstNumber'+FirstNumber);
	if(FirstNumber!=49&&FirstNumber!=52){
		so.addError('Invalid ALU Order Number, upsert failed.');
	}
			}
			
			
		}
		
	}
	
	
	
	//============================================================================================= 
	// Method Name: upsertsoreporting
	// Purpose: Update Salesorder reporting if there are any changes for SO
	// Author: Rakesh Dandae
	// ============================================================================================
	
	public static void upsertsoreporting(List<sales_order__c> newsolist, map<Id,sales_order__c> oldsomap){
		
		system.debug(' entered updatesoreporting');
		Database.SaveResult[] result_upd;
		Database.SaveResult[] result_ins;
		Database.DeleteResult[] result_del;
		List<string> so_number = new List<string>();
		List<Sales_Order_Reporting__c> sorep_updlist = new List<Sales_Order_Reporting__c>();
		List<Sales_Order_Reporting__c> sorep_dellist = new List<Sales_Order_Reporting__c>();
		List<Sales_Order_Reporting__c> sorep_inslist = new List<Sales_Order_Reporting__c>();
		map<string, Sales_Order_Reporting__c> sorep_map = new  map<string, Sales_Order_Reporting__c>();
		
		try{
			for(sales_order__c so : newsolist){
	
	so_number.add(so.ALU_Order_Number__c);
			}
			
			for(Sales_Order_Reporting__c sorep : [select id, ALU_Order_Number__c, order__c from Sales_Order_Reporting__c where ALU_Order_Number__c in : so_number])
			{
	
	sorep_map.put(sorep.alu_order_number__c, sorep);
	
			}
			
			for(sales_order__c so : newsolist){
	
	Sales_Order_Reporting__c so_rep = new Sales_Order_Reporting__c();
	system.debug('sorep_map'+ sorep_map);
	system.debug('so'+ so);
	//check if this SO is available in Sales Order Reporting object. IF available update, else insert
	if(sorep_map.get(so.ALU_Order_Number__c) <> null){
		if(so.Order__c <> oldsomap.get(so.id).order__c && so.Order__c <> null){
			so_rep.ALU_Order_Number__c = so.alu_order_number__c;
			so_rep.Order__c = so.Order__c;
			so_rep.Order_Created__c = so.Order_Created__c;
			so_rep.Order_Received__c = so.Order_Received__c;
			so_rep.CurrencyIsoCode = so.CurrencyIsoCode;
			so_rep.Customer_PO__c = so.Customer_PO__c;
			so_rep.Network_Number__c = so.Network_Number__c;
			so_rep.PO_Amount__c = so.PO_Amount__c;
			so_rep.Project_Number__c = so.Project_Number__c;
			so_rep.SO_Task__c = so.SO_Task__c;
			so_rep.PO_Amt_number__c = so.PO_Amount__c;
			
			sorep_inslist.add(so_rep);
			
		// so_rep.id = (id) sorep_map.get(so.ALU_Order_Number__c).get('id');
			sorep_dellist.add(new Sales_Order_Reporting__c(id = (id) sorep_map.get(so.ALU_Order_Number__c).get('id')));
			
		} else{
		//Check if the SO Task is 'D', if yes, delete record from Salesorder reporting, else update.
		if(so.SO_Task__c != 'D' ){
			so_rep.ALU_Order_Number__c = so.alu_order_number__c;
			so_rep.Order__c = so.Order__c;
			so_rep.Order_Created__c = so.Order_Created__c;
			so_rep.Order_Received__c = so.Order_Received__c;
			so_rep.CurrencyIsoCode = so.CurrencyIsoCode;
			so_rep.Customer_PO__c = so.Customer_PO__c;
			so_rep.Network_Number__c = so.Network_Number__c;
			so_rep.PO_Amount__c = so.PO_Amount__c;
			so_rep.Project_Number__c = so.Project_Number__c;
			so_rep.SO_Task__c = so.SO_Task__c;
			so_rep.id = (id) sorep_map.get(so.ALU_Order_Number__c).get('id');
			so_rep.PO_Amt_number__c = so.PO_Amount__c;
			
			sorep_updlist.add(so_rep);
		} else if(so.SO_Task__c == 'D' ){
			so_rep.id = (id) sorep_map.get(so.ALU_Order_Number__c).get('id');
			sorep_dellist.add(so_rep);
		} 
		
		}
	} else if(so.SO_Task__c != 'D'){
		so_rep.ALU_Order_Number__c = so.alu_order_number__c;
		so_rep.Order__c = so.Order__c;
		so_rep.Order_Created__c = so.Order_Created__c;
		so_rep.Order_Received__c = so.Order_Received__c;
		so_rep.CurrencyIsoCode = so.CurrencyIsoCode;
		so_rep.Customer_PO__c = so.Customer_PO__c;
		so_rep.Network_Number__c = so.Network_Number__c;
		so_rep.PO_Amount__c = so.PO_Amount__c;
		so_rep.Project_Number__c = so.Project_Number__c;
		so_rep.SO_Task__c = so.SO_Task__c;
		so_rep.PO_Amt_number__c = so.PO_Amount__c;
		
		sorep_inslist.add(so_rep);
	}
	
			}
		} catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_salesordertrigger_manager, GlobalConstants.M_upsertsoreporting);
		}
		
		if(sorep_updlist.size() > 0){
			try{
	result_upd = database.update(sorep_updlist,false);
			} catch(exception ex){
	ExceptionHandler.addException(ex, GlobalConstants.CL_salesordertrigger_manager, GlobalConstants.M_upsertsoreporting);
			}
			String op_type = 'update';
			ilogupsert(result_upd, sorep_updlist,op_type);
			system.debug('result_upd:' + result_upd);
		}
		
		
		
		if(sorep_dellist.size() > 0){
			result_del = database.delete(sorep_dellist,false);
			ilogdelete(result_del, sorep_dellist);
			system.debug('result_del' + result_del);
		}
		
		if(sorep_inslist.size() > 0){
			result_ins = database.insert(sorep_inslist,false);
			String op_type = 'insert';
			ilogupsert(result_ins, sorep_inslist,op_type);
			system.debug('result_ins' + result_ins);
		}
		
	}
	
	
	//============================================================================================= 
	// Method Name: ilogdelete
	// Purpose: Interface Logs for record deleteion
	// Author: Rakesh Dandae
	// ============================================================================================
	
	public static void ilogdelete (Database.DeleteResult[] drList, Sales_Order_Reporting__c[] processedrec){
		
		List<Interface_Log__c> iLogList = new  List<Interface_Log__c>();
		integer count = 0;
		for(Database.DeleteResult dr : drList){
			if(!dr.isSuccess()){
	for(Database.Error err : dr.getErrors()){
		
		Interface_Log__c  iLog_del = new Interface_Log__c(Name = dr.getId(), 
					  Interface_Type__c = 'Sales Order Sync', 
					  Message_Type__c = 'Inbound',
					  Operation_type__c = 'Delete', 
					  Status__c = 'Failure');
		
		iLog_del.interface_request_sent__c = dr.getId();
		iLog_del.Comment__c = err.getMessage();
		
		iLogList.add(iLog_del);
	}
	
			} else{
	Interface_Log__c iLog = new  Interface_Log__c(Name = dr.getId(), 
				 Interface_Type__c = 'Sales Order Sync', 
				 Message_Type__c = 'Inbound',
				 Operation_type__c = 'Delete', 
				 Status__c = 'Success',
				 Comment__c = 'Success');
	
	ilog.interface_request_sent__c = dr.getId() + '\n'+
		'Nokia Order Number:'+	processedrec[count].ALU_Order_Number__c + '\n'+
		'CurrencyIsoCode:' + processedrec[count].CurrencyIsoCode + '\n'+
		'Customer_PO__c:'+ processedrec[count].Customer_PO__c + '\n'+
		'Network_Number__c:'+ processedrec[count].Network_Number__c + '\n'+
		'Order_Created__c:'+ processedrec[count].Order_Created__c + '\n'+
		'Order_Received__c:'+ processedrec[count].Order_Received__c + '\n'+
		'Order__c:'+ processedrec[count].Order__c + '\n'+
		'PO_Amount__c:'+ processedrec[count].PO_Amount__c + '\n'+
		'Project_Number__c:'+ processedrec[count].Project_Number__c + '\n'+
		'SO_Task__c:'+ processedrec[count].SO_Task__c;
	iLogList.add(iLog);
	count = count + 1;
			}
		}
		if(!iLogList.isEmpty()){
			
			try{
				Database.executeBatch(new SalesOrderInterfacelogupsert(iLogList));
	//insert iLogList;		
	
			}catch(DMLException dex){
	System.Debug('##Error occured while creating Interface Log or Interface Detail Log');
			} 
		}
	}
	
	//============================================================================================= 
	// Method Name: ilogupsert
	// Purpose: Interface Logs for record update and insert
	// Author: Rakesh Dandae
	// ============================================================================================
	
	public static void ilogupsert (Database.saveResult[] drList, Sales_Order_Reporting__c[] processedrec, string ops_type){
		
		List<Interface_Log__c> iLogList = new  List<Interface_Log__c>();
		integer count = 0;
		for(Database.saveResult dr : drList){
			if(!dr.isSuccess()){
	for(Database.Error err : dr.getErrors()){
		
		Interface_Log__c  iLog_del = new Interface_Log__c(Name = dr.getId(), 
					  Interface_Type__c = 'Sales Order Sync', 
					  Message_Type__c = 'Inbound',
					  Operation_type__c = ops_type, 
					  Status__c = 'Failure');
		
		iLog_del.interface_request_sent__c = dr.getId() + '\n'+
			'Nokia Order Number:'+	processedrec[count].ALU_Order_Number__c + '\n'+
			'CurrencyIsoCode:' + processedrec[count].CurrencyIsoCode + '\n'+
			'Customer_PO__c:'+ processedrec[count].Customer_PO__c + '\n'+
			'Network_Number__c:'+ processedrec[count].Network_Number__c + '\n'+
			'Order_Created__c:'+ processedrec[count].Order_Created__c + '\n'+
			'Order_Received__c:'+ processedrec[count].Order_Received__c + '\n'+
			'Order__c:'+ processedrec[count].Order__c + '\n'+
			'PO_Amount__c:'+ processedrec[count].PO_Amount__c + '\n'+
			'Project_Number__c:'+ processedrec[count].Project_Number__c + '\n'+
			'SO_Task__c:'+ processedrec[count].SO_Task__c;
		iLog_del.Comment__c = err.getMessage();
		
		iLogList.add(iLog_del);
	}
	
			} else{
	Interface_Log__c iLog = new  Interface_Log__c(Name = dr.getId(), 
				 Interface_Type__c = 'Sales Order Sync', 
				 Message_Type__c = 'Inbound',
				 Operation_type__c = ops_type , 
				 Status__c = 'Success',
				 Comment__c = 'Success');
	
	ilog.interface_request_sent__c = dr.getId() + '\n'+
		'Nokia Order Number:'+	processedrec[count].ALU_Order_Number__c + '\n'+
		'CurrencyIsoCode:' + processedrec[count].CurrencyIsoCode + '\n'+
		'Customer_PO__c:'+ processedrec[count].Customer_PO__c + '\n'+
		'Network_Number__c:'+ processedrec[count].Network_Number__c + '\n'+
		'Order_Created__c:'+ processedrec[count].Order_Created__c + '\n'+
		'Order_Received__c:'+ processedrec[count].Order_Received__c + '\n'+
		'Order__c:'+ processedrec[count].Order__c + '\n'+
		'PO_Amount__c:'+ processedrec[count].PO_Amount__c + '\n'+
		'Project_Number__c:'+ processedrec[count].Project_Number__c + '\n'+
		'SO_Task__c:'+ processedrec[count].SO_Task__c;
	iLogList.add(iLog);
	count = count + 1;
			}
		}
		if(!iLogList.isEmpty()){
			
			try{
				Database.executeBatch(new SalesOrderInterfacelogupsert(iLogList));
	//insert iLogList;		
	
			}catch(DMLException dex){
	System.Debug('##Error occured while creating Interface Log or Interface Detail Log');
			} 
		}   
	}
	
}