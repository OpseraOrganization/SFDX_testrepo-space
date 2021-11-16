public class NOKIACPQ_BOMJson{
	public String transactionId;	//04aa390b-b89d-4afc-bfda-6eb7e7aaca0b
	public String type;	//bom
	public cls_data data;
	 Public class cls_data {
		public cls_header header;
		public cls_bom_data[] bom_data;
		public String cfg_data;	//base64data
	}
	Public class cls_header {
		public String config_id;	//
		public String cart_id;	//
		public String extension;	//
	}
	Public class cls_bom_data {
		public Integer pci_code;	//0
		public String product_code;	//MICROWAVE
		public Integer quantity;	//1
		public String item_type;	//Product
		public cls_children children;
	}
	Public class cls_children {
		public String pci_code;	//MSS-1
		public String position;	//
		public Integer quantity;	//1
		public String product_code;	//3DB19015CA
		public String status;	//
		public String statustitle;	//
		public String item_type;	//Indoor
	 Public cls_stations[] stations;
	}
	Public class cls_stations {
		public String pci_code;	//STATION-1
		public String product_code;	//XXXXX
		public Integer quantity;	//1
		public String item_type;	//station
		public cls_children[] children;
	}
	public static NOKIACPQ_BOMJson parse(String json){
		return (NOKIACPQ_BOMJson) System.JSON.deserialize(json, NOKIACPQ_BOMJson.class);
	}
}