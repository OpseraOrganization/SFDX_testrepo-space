public class ScheduleInvalidSubject implements Schedulable{
	  public void execute(SchedulableContext SC)
	   { 
		MetadataAPIUtility uti = new MetadataAPIUtility();
		uti.createcustomlabel();
	   }
}