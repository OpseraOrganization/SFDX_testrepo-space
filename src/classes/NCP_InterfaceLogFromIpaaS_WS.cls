global with sharing class NCP_InterfaceLogFromIpaaS_WS 
{
	webservice static void CreateInterfaceLogFromIpaaS(String jobId) 
	{
		system.debug('JobID: ' + jobId);
		ID asyncJobID = System.enqueueJob(new NCP_InterfaceLogFromIpaaS(jobId));
		system.debug('JOB ID: ' + asyncJobID);
	}
}