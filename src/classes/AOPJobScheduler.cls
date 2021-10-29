global class AOPJobScheduler
{
global void AOPJobScheduler() {}
public static void start(integer yr)
{
System.debug('*************Inside start method of the AOPJobScheduler class');
//Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
System.schedule('AOP Update', '0 0 0-23 * * ?', new oppschedule(yr));
}
}