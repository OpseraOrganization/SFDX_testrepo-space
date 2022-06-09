global class SalesRoleAuditDataRetentionBatchMock implements WebServiceMock {
	
	global void doInvoke(
		Object stub,
		Object request,
		Map<String, Object> response,
		String endpoint,
		String soapAction,
		String requestName,
		String responseNS,
		String responseName,
		String responseType) {
			// start - specify the response you want to send
			nsnComCmdService.response res =new nsnComCmdService.response();
			res.response='Request received in CMD';
			res.salesHierarhyResponse = new list<nsnComCmdService.salesHierarchyResponse>();
		   
			nsnComCmdService.salesHierarchyResponse salesHRes= new nsnComCmdService.salesHierarchyResponse();
			salesHRes.executionStatus = 'OK';
			salesHRes.roleOwnerDetailsResponse = new list<nsnComCmdService.rodResponse>();
			
			nsnComCmdService.rodResponse roleResponse = new nsnComCmdService.rodResponse();
			roleResponse.executionStatus='OK';
			salesHRes.roleOwnerDetailsResponse.add(roleResponse);
			res.salesHierarhyResponse.add(salesHRes);
			
			nsnComCmdService.updateRoleOwnerDetailsResponse response_x = new nsnComCmdService.updateRoleOwnerDetailsResponse();
			response_x.return_x = res;
			//res.response ='[apex_schema_type_info=(http://nsn.com/cmd/service/, false, false),field_order_type_info=(response, salesHierarhyResponse), response=Request received in CMD,response_type_info=(response, http://nsn.com/cmd/service/, null, 0, 1, false),salesHierarhyResponse=(salesHierarchyResponse:[apex_schema_type_info=(http://nsn.com/cmd/service/, false, false),executionStatus=OK, executionStatus_type_info=(executionStatus, http://nsn.com/cmd/service/, null, 0, 1, false),field_order_type_info=(executionStatus, roleOwnerDetailsResponse),roleOwnerDetailsResponse=(rodResponse:[apex_schema_type_info=(http://nsn.com/cmd/service/, false, false),executionStatus=OK, executionStatus_type_info=(executionStatus, http://nsn.com/cmd/service/, null, 0, 1, false),field_order_type_info=(executionStatus)]),roleOwnerDetailsResponse_type_info=(roleOwnerDetailsResponse, http://nsn.com/cmd/service/, null, 0, -1, true)]),salesHierarhyResponse_type_info=(salesHierarhyResponse, http://nsn.com/cmd/service/, null, 0, -1, true)]'; 
			
			response.put('response_x', response_x); 
		}
}