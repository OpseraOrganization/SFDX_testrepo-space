public class CARTServiceConfigData {

	public Data data;
	
	public class Data{
		public String ZID;
		public String ZNAME;
		public Inst INST;
	}

	public class Inst {
		public InstData data;
	}
	
	public class InstData{
		public String NR;
		public Characteristics CSTICS; 
	}
	
	public class Characteristics{
		public List<Cstic> CSTIC;
	}
	
	public class Cstic{
		public CsticData data;
	}
	
	public class CsticData{
		public String AUTHOR;
		public String CHARC;
		public String CHARC_TXT;
		public String VALUE;
		public String VALUE_TXT;
		
	}
	
	public static CARTServiceConfigData parse(String json) {
		return (CARTServiceConfigData) System.JSON.deserialize(json, CARTServiceConfigData.class);
	}
}