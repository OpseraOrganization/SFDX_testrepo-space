@isTest
public class CH_CA_WorkgroupScheduleDataFactory {
	public static final string WORKGROUPNAME = 'TESTWorkgroup';
	public static final string TEST_QUEUE_LABEL = 'GS_IAES_R_Cloud_GDCE_EUR_LAT-Customers';
	static public void createWorkgroup(){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		// Create workgroup
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'TestWorkgroup';
		insert workgroup;
	}
	static public void createWorkgroupMember(){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name='TestWorkgroup'];
		//Create Workgroup member
		CH_Workgroup_Member__c workgroupMember = new CH_Workgroup_Member__c ();
		workgroupMember.CH_Queue__c = 'GS_IAES_R_Cloud_GDCE_EUR_LAT-Customers';
		workgroupMember.CH_Role__c = 'Queue';
		workgroupMember.CH_Workgroup__c = workgroup.Id;
		Insert workgroupMember;
	}
	static public void createWorkgroupSchedule(String workgroupScheduleName){
		createWorkgroup();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name='TestWorkgroup'];
		//Create Workgroup Schedule
		CH_Workgroup_Schedule__c workgroupSchedule = new CH_Workgroup_Schedule__c();
		workgroupSchedule.Name=workgroupScheduleName;
		workgroupSchedule.CH_Workgroup__c = workgroup.Id;
		workgroupSchedule.CH_Time_Zone__c = 'UTC';
		workgroupSchedule.CH_Start_DateTime__c= DateTime.now().addDays(-15);	   
		workgroupSchedule.CH_End_DateTime__c= DateTime.now().addDays(15);
		workgroupSchedule.CH_Active__c=false;
		Insert workgroupSchedule;
	}
	static public void createWGSTimeslotAssociation(String workgroupScheduleName){
		createWorkgroupMember();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name='TestWorkgroup'];
		CH_Workgroup_Schedule__c workgroupSchedule=[SELECT Id FROM CH_Workgroup_Schedule__c WHERE Name=:workgroupScheduleName AND CH_Workgroup__c = :workgroup.Id];
		CH_Workgroup_Member__c workgroupMember=[SELECT Id FROM CH_Workgroup_Member__c WHERE CH_Queue__c = 'GS_IAES_R_Cloud_GDCE_EUR_LAT-Customers' AND CH_Role__c = 'Queue' AND CH_Workgroup__c = :workgroup.Id];
		//Create workgroup Schedule timeslot
		List<CH_Workgroup_Schedule_Timeslot__c> workGroupScheduleTimeslotList = new List<CH_Workgroup_Schedule_Timeslot__c>();
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot1.CH_Day__c='Monday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot1);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot2 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot2.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot2.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot2.CH_Day__c='Tuesday';
		workGroupScheduleTimeslot2.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot2.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot2);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot3 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot3.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot3.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot3.CH_Day__c='Wednesday';
		workGroupScheduleTimeslot3.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot3.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot3);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot4 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot4.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot4.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot4.CH_Day__c='Thursday';
		workGroupScheduleTimeslot4.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot4.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot4);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot5 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot5.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot5.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot5.CH_Day__c='Friday';
		workGroupScheduleTimeslot5.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot5.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot5);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot6 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot6.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot6.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot6.CH_Day__c='Saturday';
		workGroupScheduleTimeslot6.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot6.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot6);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot7 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot7.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot7.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot7.CH_Day__c='Sunday';
		workGroupScheduleTimeslot7.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot7.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot7);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot8 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot8.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot8.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot8.CH_Day__c='Monday';
		workGroupScheduleTimeslot8.CH_Start_Time__c=Time.newInstance(3, 30, 0, 0);
		workGroupScheduleTimeslot8.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot8);
		Insert workGroupScheduleTimeslotList;
		//Create Workgroup member timeslot association record
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemTimeslotAssnList = new List<CH_Workgroup_Member_Timeslot_Association__c>();
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn1=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn1.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn1.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot1.Id;
		workgroupMemTimeslotAssn1.CH_Schedule_Type__c='Primary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn1);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn2=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn2.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn2.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot2.Id;
		workgroupMemTimeslotAssn2.CH_Schedule_Type__c='Secondary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn2);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn3=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn3.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn3.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot3.Id;
		workgroupMemTimeslotAssn3.CH_Schedule_Type__c='Tertiary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn3);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn4=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn4.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn4.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot4.Id;
		workgroupMemTimeslotAssn4.CH_Schedule_Type__c='Primary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn4);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn5=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn5.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn5.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot5.Id;
		workgroupMemTimeslotAssn5.CH_Schedule_Type__c='Secondary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn5);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn6=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn6.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn6.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot6.Id;
		workgroupMemTimeslotAssn6.CH_Schedule_Type__c='Tertiary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn6);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn7=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn7.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn7.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot7.Id;
		workgroupMemTimeslotAssn7.CH_Schedule_Type__c='Primary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn7);
		Insert workgroupMemTimeslotAssnList;
	}
	static public void createWGSTimeslotAlone(String workgroupScheduleName){
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name='TestWorkgroup'];
		CH_Workgroup_Schedule__c workgroupSchedule=[SELECT Id FROM CH_Workgroup_Schedule__c WHERE Name=:workgroupScheduleName AND CH_Workgroup__c = :workgroup.Id];
		 //Create workgroup Schedule timeslot
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot1.CH_Day__c='Monday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		Insert workGroupScheduleTimeslot1;
	}
	static public void createWGSTimeslotTwoOverlapping(String workgroupScheduleName){
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name='TestWorkgroup'];
		CH_Workgroup_Schedule__c workgroupSchedule=[SELECT Id FROM CH_Workgroup_Schedule__c WHERE Name=:workgroupScheduleName AND CH_Workgroup__c = :workgroup.Id];
		 //Create workgroup Schedule timeslot
		List<CH_Workgroup_Schedule_Timeslot__c> workGroupScheduleTimeslotList = new List<CH_Workgroup_Schedule_Timeslot__c>();
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot1.CH_Day__c='Monday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(11, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot1);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot2 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot2.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot2.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot2.CH_Day__c='Monday';
		workGroupScheduleTimeslot2.CH_Start_Time__c=Time.newInstance(11, 0, 0, 0);
		workGroupScheduleTimeslot2.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot2);
		Insert workGroupScheduleTimeslotList;
	}
	static public void createWGSTimeslotAssociationAlone(String workgroupScheduleName){
		createWorkgroupMember();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name='TestWorkgroup'];
		CH_Workgroup_Schedule__c workgroupSchedule=[SELECT Id FROM CH_Workgroup_Schedule__c WHERE Name=:workgroupScheduleName AND CH_Workgroup__c = :workgroup.Id];
		CH_Workgroup_Member__c workgroupMember=[SELECT Id FROM CH_Workgroup_Member__c WHERE CH_Queue__c = 'GS_IAES_R_Cloud_GDCE_EUR_LAT-Customers' AND CH_Role__c = 'Queue' AND CH_Workgroup__c = :workgroup.Id];
		//Create workgroup Schedule timeslot
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot1.CH_Day__c='Monday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		Insert workGroupScheduleTimeslot1;
		//Create Workgroup member timeslot association record
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn1=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn1.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn1.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot1.Id;
		workgroupMemTimeslotAssn1.CH_Schedule_Type__c='Primary';
		Insert workgroupMemTimeslotAssn1;
	}
	static public void createWGSTimeslotAssociationTwoOverlapping(String workgroupScheduleName){
		createWorkgroupMember();
		CH_Workgroup__c workgroup=[SELECT Id FROM CH_Workgroup__c WHERE Name='TestWorkgroup'];
		CH_Workgroup_Schedule__c workgroupSchedule=[SELECT Id FROM CH_Workgroup_Schedule__c WHERE Name=:workgroupScheduleName AND CH_Workgroup__c = :workgroup.Id];
		CH_Workgroup_Member__c workgroupMember=[SELECT Id FROM CH_Workgroup_Member__c WHERE CH_Queue__c = 'GS_IAES_R_Cloud_GDCE_EUR_LAT-Customers' AND CH_Role__c = 'Queue' AND CH_Workgroup__c = :workgroup.Id];
		//Create workgroup Schedule timeslot
		List<CH_Workgroup_Schedule_Timeslot__c> workGroupScheduleTimeslotList = new List<CH_Workgroup_Schedule_Timeslot__c>();
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot1.CH_Day__c='Monday;Tuesday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(1, 0, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot1);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot2 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot2.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot2.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot2.CH_Day__c='Monday;Tuesday';
		workGroupScheduleTimeslot2.CH_Start_Time__c=Time.newInstance(0, 30, 0, 0);
		workGroupScheduleTimeslot2.CH_End_Time__c=Time.newInstance(1, 30, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot2);
		Insert workGroupScheduleTimeslotList;
		//Create Workgroup member timeslot association record
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemTimeslotAssnList = new List<CH_Workgroup_Member_Timeslot_Association__c>();
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn1=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn1.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn1.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot1.Id;
		workgroupMemTimeslotAssn1.CH_Schedule_Type__c='Primary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn1);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn2=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn2.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn2.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot2.Id;
		workgroupMemTimeslotAssn2.CH_Schedule_Type__c='Secondary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn2);
		Insert workgroupMemTimeslotAssnList;
	}
	static public void createWorkgroups(){
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		// Create workgroup
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'TestWorkgroup';
		insert workgroup;
		//Create Workgroup member
		CH_Workgroup_Member__c workgroupMember = new CH_Workgroup_Member__c ();
		workgroupMember.CH_Queue__c = 'GS_IAES_R_Cloud_GDCE_EUR_LAT-Customers';
		workgroupMember.CH_Role__c = 'Queue';
		workgroupMember.CH_Workgroup__c = workgroup.Id;
		Insert workgroupMember;
		//Create Workgroup Schedule
		CH_Workgroup_Schedule__c workgroupSchedule = new CH_Workgroup_Schedule__c();
		workgroupSchedule.Name='TestworkgroupSchedule';
		workgroupSchedule.CH_Workgroup__c = workgroup.Id;
		workgroupSchedule.CH_Time_Zone__c = 'UTC';
		workgroupSchedule.CH_Start_DateTime__c= DateTime.now().addDays(-15);	   
		workgroupSchedule.CH_End_DateTime__c= DateTime.now().addDays(15);
		workgroupSchedule.CH_Active__c=false;
		Insert workgroupSchedule;
		//Create workgroup Schedule timeslot
		List<CH_Workgroup_Schedule_Timeslot__c> workGroupScheduleTimeslotList = new List<CH_Workgroup_Schedule_Timeslot__c>();
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot1 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot1.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot1.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot1.CH_Day__c='Monday';
		workGroupScheduleTimeslot1.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot1.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot1);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot2 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot2.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot2.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot2.CH_Day__c='Tuesday';
		workGroupScheduleTimeslot2.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot2.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot2);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot3 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot3.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot3.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot3.CH_Day__c='Wednesday';
		workGroupScheduleTimeslot3.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot3.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot3);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot4 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot4.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot4.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot4.CH_Day__c='Thursday';
		workGroupScheduleTimeslot4.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot4.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot4);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot5 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot5.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot5.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot5.CH_Day__c='Friday';
		workGroupScheduleTimeslot5.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot5.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot5);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot6 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot6.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot6.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot6.CH_Day__c='Saturday';
		workGroupScheduleTimeslot6.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot6.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot6);
		CH_Workgroup_Schedule_Timeslot__c workGroupScheduleTimeslot7 = new CH_Workgroup_Schedule_Timeslot__c();
		workGroupScheduleTimeslot7.CH_Workgroup_Id__c=workgroup.Id;
		workGroupScheduleTimeslot7.CH_Workgroup_Schedule__c=workgroupSchedule.Id;
		workGroupScheduleTimeslot7.CH_Day__c='Sunday';
		workGroupScheduleTimeslot7.CH_Start_Time__c=Time.newInstance(0, 0, 0, 0);
		workGroupScheduleTimeslot7.CH_End_Time__c=Time.newInstance(23, 59, 0, 0);
		workGroupScheduleTimeslotList.add(workGroupScheduleTimeslot7);
		Insert workGroupScheduleTimeslotList;
		//Create Workgroup member timeslot association record
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemTimeslotAssnList = new List<CH_Workgroup_Member_Timeslot_Association__c>();
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn1=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn1.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn1.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot1.Id;
		workgroupMemTimeslotAssn1.CH_Schedule_Type__c='Primary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn1);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn2=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn2.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn2.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot2.Id;
		workgroupMemTimeslotAssn2.CH_Schedule_Type__c='Secondary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn2);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn3=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn3.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn3.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot3.Id;
		workgroupMemTimeslotAssn3.CH_Schedule_Type__c='Tertiary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn3);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn4=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn4.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn4.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot4.Id;
		workgroupMemTimeslotAssn4.CH_Schedule_Type__c='Primary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn4);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn5=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn5.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn5.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot5.Id;
		workgroupMemTimeslotAssn5.CH_Schedule_Type__c='Secondary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn5);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn6=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn6.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn6.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot6.Id;
		workgroupMemTimeslotAssn6.CH_Schedule_Type__c='Tertiary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn6);
		CH_Workgroup_Member_Timeslot_Association__c workgroupMemTimeslotAssn7=new CH_Workgroup_Member_Timeslot_Association__c();
		workgroupMemTimeslotAssn7.CH_Workgroup_Member__c=workgroupMember.Id;
		workgroupMemTimeslotAssn7.CH_Workgroup_Schedule_Timeslot__c=workGroupScheduleTimeslot7.Id;
		workgroupMemTimeslotAssn7.CH_Schedule_Type__c='Primary';
		workgroupMemTimeslotAssnList.add(workgroupMemTimeslotAssn7);
		Insert workgroupMemTimeslotAssnList;
	}
}