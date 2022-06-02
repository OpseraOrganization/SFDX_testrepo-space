/****************************************
 * Class Name : DSCCREStaging
 * Created Date: 16 july 2018
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : create DStaging and interface log record based on input Json request
			  
 *****************************************/
@RestResource(urlMapping='/DSCCREStaging/*')
global with sharing class DSCCREStaging
{
	/* insert ccre record */
	@HttpPost
	global static void creatDSStaging()
	{
	  //  createDSStagingHelper.UpsertCCREDSStaging();
	}
}