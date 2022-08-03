/****************************************
* Name : HWS_ComponentToProductJSON
* Author : TCS
* Description : This class is for JSON mapping
* ReqNo : 
* TestClass : HWS_ComponentToProductJSON_Test
****************************************/
public class HWS_ComponentToProductJSON{
	public String ID{get;set;}	//46256.29608.0.19503
	public String Type{get;set;}	//NSN Other Electromechanical Component
	public String SuperType{get;set;}	//NSN Standard HW Component
	public String Name{get;set;}	//6900314
	public String Revision{get;set;}	//
	public String Originated{get;set;}	//2002-03-12T20:38:34Z
	public String Description{get;set;}	//TOOL 2.0mm WITH PLASTIC HANDLE
	public DateTime Modified{get;set;}	//2015-08-25T10:09:11Z
	public String Owner{get;set;}	//hbathula
	public String Policy{get;set;}  //NSN Standard HW Component
	public String Current{get;set;}	//Obsolete
	public String CurrentActualDate{get;set;}	//2009-12-11T12:49:29Z
	public cls_CurrentScheduledDate CurrentScheduledDate{get;set;}
	public String Vault{get;set;}	//eService Production
	public String NSNCode{get;set;}	//6900314
	public boolean PMDSOR_DeletedAtSource{get;set;}
	public String PMDSOR_InsertDateTime{get;set;}	//2020-06-24T08:20:15.2922385Z
	public String PMDSOR_UpdateDateTime{get;set;}	//2020-06-24T08:20:15.2922385Z
	public List<cls_MainAttributes> MainAttributes;
	public Map<String, String> mainatt = new Map<String, String>();
	class cls_CurrentScheduledDate {
	}
	public class cls_MainAttributes {
		public Integer ID{get;set;}	//15578228
		public String Name{get;set;}	//Approved Date
		public String Value{get;set;}	//
	}
	public static HWS_ComponentToProductJSON parse(String json){
		return (HWS_ComponentToProductJSON) System.JSON.deserialize(json, HWS_ComponentToProductJSON.class);
	}
}