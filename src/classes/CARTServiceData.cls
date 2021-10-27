public class CARTServiceData {
	public class bom_data {
		public String product_code;
		public Integer quantity;
		public String pci_code;
		public String item_type;
		public List<bom_data> children;
	}

	public Header header;
	public String cfg_data;
	public List<bom_data> bom_data;

	public class Header {
		public String config_id;
		public String cart_id;
	}

	
	public static CARTServiceData parse(String json) {
		return (CARTServiceData) System.JSON.deserialize(json, CARTServiceData.class);
	}
}