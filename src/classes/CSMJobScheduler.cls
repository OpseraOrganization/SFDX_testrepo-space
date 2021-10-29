global class CSMJobScheduler
{
global void CSMJobScheduler() {}
public static void start()
{
System.debug('*************Inside start method of the AOPJobScheduler class');
//Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
System.schedule('CSM EmailReminder', ' 0 0 9 * * ?', new CSM_Scheduler());
}
}