public without sharing class CH_CustomPrintableViewWrapper {
	public String parentObject;
	public String parentName;
	public Case currentCaseRecord; // Nokisc-36679
	public Date startDate; //Nokiasc-36679
	public Map<Date, List<childWrapper>> allChildDateSetMap;
	public List<childWrapper> childWrapperList;
	public class childWrapper implements Comparable{
		public String childOjectName;
		public String childOjectLabel;
		public String referenceField;
		public DateTime recentDate;
		public childWrapper(String childOjectName, String childOjectLabel, String referenceField, DateTime recentDate) {
			this.childOjectName = childOjectName;
			this.childOjectLabel = childOjectLabel;
			this.referenceField = referenceField;
			this.recentDate = recentDate;
		}
		
		public Integer compareTo(Object compareTo) {
			childWrapper cw = (childWrapper) compareTo;
			if (cw.recentDate < this.recentDate) return -1;
			if (cw.recentDate > this.recentDate) return +1;
			return 0; 
		}
	}
}