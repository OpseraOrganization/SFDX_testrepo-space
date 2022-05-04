public with sharing class QTC_ShowSalesOrder_Wrapper {

	public QTC_ShowSalesOrder_Wrapper(){}

	public class N0_Z_EFI_SENDORDER {
		public IZEFI005 IZEFI005;
		public ZEFI006 ZEFI006;

		public N0_Z_EFI_SENDORDER(){}
	}
	
	public class IZEFI005 {
		public List<Item> item;

		public IZEFI005(){}
	}
	
	public class ZEFI006{
		//SAP Header Parameters
		public String MANDT{get; set;}
		public String VBELN{get; set;}
		public String AUART{get; set;}
		public String AUDAT{get; set;}
		public String KUNAG{get; set;}
		public String KUNNR{get; set;}
		public String ZZCONTNR{get; set;}
		public String ZZCONTTYP{get; set;}
		public String WAERK{get; set;}
		public String KURSK{get; set;}
		public String VKORG{get; set;}
		public String ZMESSAGE{get; set;}
		public String ZZPPNAME{get; set;}
		public String ZZWESNR{get; set;}

		public ZEFI006(){}
		
		//what is the need of this constructer?
		/*
		public void ZEFI006(){
			defaultCurrency = WAERK;
			pricingpool = ZZPPNAME;
			soldTo = KUNNR;
			documentDate = AUDAT;
		}
		*/
	}
	
	public class Item{
		
		//SAP line Parameters
		public String MANDT {get; set;}
		public String VBELN {get; set;}
		public String POSNR {get; set;}
		public String MATNR {get; set;}
		public String KWMENG {get; set;}
		public String ARKTX {get; set;}
		public String BSTNK {get; set;}
		public String POSAR {get; set;}
		public String UEPOS {get; set;}
		public String KSCHL {get; set;}
		public String KBETR_SPM {get; set;}
		public String ECODE {get; set;}
		public String KBETR {get; set;}
		public String MEINS {get; set;}
		public String ERDAT {get; set;}
		public String SMENG {get; set;}
		public String POSEX {get; set;}
		public String KDMAT {get; set;}
		public String SPART {get; set;}
		public String GSBER {get; set;}
		public String NETWR {get; set;}
		public String WAERK {get; set;}
		public String WERKS {get; set;}
		public String STLNR {get; set;}
		public String NETPR {get; set;}
		public String KPEIN {get; set;}
		public String KMEIN {get; set;}
		public String PRCTR {get; set;}
		public String PS_PSP_PNR {get; set;}
		public String AUFNR {get; set;}
		public String PARVW {get; set;}
		public String KUNNR {get; set;}
		public String LAND1 {get; set;}
		public String LZONE {get; set;}
		public String ZMESSAGE {get; set;}
		public String FIELD1 {get; set;}
		public String FIELD2 {get; set;}

		public Item(){}
	}
}