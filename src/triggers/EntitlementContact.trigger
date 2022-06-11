trigger EntitlementContact on EntitlementContact (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
		new CH_EntitlementContactTriggerHandler().run();
}