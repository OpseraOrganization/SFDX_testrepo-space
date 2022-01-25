public without sharing class HWS_WrapLSPInstructions {
	
	public String ParentCaseId;
	public List<SupplierNodes> SupplierNodes;
	public List<DeliveryAddress> DeliveryAddress;
	public List<ChildCases> ChildCases;
	
	public class ChildCases {
		public String SRMServiceItemID;
		public String LogisticNode;
		public String LogisticNodeName;
		public String ReturnAddressNode;
	}
	public class SupplierNodes {
		public String LogisticNode;
		public String LogisticNodeName;
		public String ReferralInstruction;
	}
	
	public class DeliveryAddress {
		public String ReturnAddressNode;
		public String AddressLine3;
		public String AddressLine2;
		public String State;
		public String DeliveryNote;
		public String Country;
		public String PostalCode;
		public String Region;
		public String Street;
		public String City;
		public String AddressType;
		public String Name;
	}
}