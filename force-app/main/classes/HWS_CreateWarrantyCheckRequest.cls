Public without sharing Class HWS_CreateWarrantyCheckRequest
{
	Public String createSRRequest(HWS_CheckWarranty_SVC.FlowInput objInput)
	 {
		String jsonPayload = JSON.serialize(objInput,true);
		return jsonPayload;
		
	}
	Public String createSRequest(HWS_CheckWarranty_SVC.ChildDetails objInput)
	 {
		String jsonPayload1 = JSON.serialize(objInput,true);
		return jsonPayload1;
	}
}