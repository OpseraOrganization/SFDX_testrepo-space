@isTest
public class EinsteinDiscoverySchedulerTest implements HttpCalloutMock {

	static testmethod void testEinsteinDiscoveryScheduler() {
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EinsteinDiscoverySchedulerTest());
		String jobId = System.schedule('testEinsteinDiscoveryScheduler','0 30 * * * ?',new EinsteinDiscoveryScheduler());
		Test.stopTest();
	}

	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		if (req.getEndpoint().endsWith('predictiondefinitions')) {
			res.setBody('{"nextPageUrl" : null, "predictionDefinitions" : [  {"countOfActiveModels" : 7, "countOfModels" : 7, "createdBy" : {"id" : "00558000001UQbzAAG", "name" : "Bandhan Baral", "profilePhotoUrl" : "https://nokia--qcrm--c.documentforce.com/profilephoto/729410000004srh/T"}, "createdDate" : "2020-05-19T13:35:18.000Z", "id" : "1OR3h000000bmIFGAY", "label" : "Opportunity LTW Scoring CRM", "lastModifiedBy" : {"id" : "0053h000004sIYzAAM", "name" : "Upendra Kumar", "profilePhotoUrl" : "https://nokia--qcrm--c.documentforce.com/profilephoto/005/T"}, "lastModifiedDate" : "2021-12-09T08:43:28.000Z", "mappedOutcomeField" : "Opportunity.IsWon", "modelsUrl" : "/services/data/v53.0/smartdatadiscovery/predictiondefinitions/1OR3h000000bmIFGAY/models", "name" : "Opportunity_Scoring_CRMe0d7d2d9", "outcome" : {"goal" : "Maximize", "label" : "Won", "name" : "Won"}, "predictionType" : "Classification", "pushbackField" : {"label" : "Likelihood to Win % (Einstein)", "name" : "Opportunity.Likelyhood_to_Win__c"}, "url" : "/services/data/v53.0/smartdatadiscovery/predictiondefinitions/1OR3h000000bmIFGAY"}], "totalSize" : 1, "url" : "/services/data/v53.0/smartdatadiscovery/predictiondefinitions?pageSize=25"}');
			res.setStatusCode(200);
		} else {
			res.setBody('{"useTerminalStateFilter":true,"url":"/services/data/v53.0/smartdatadiscovery/predict-jobs/1OS09000000Gmb7GAC","totalRecords":235,"subscribedEntity":"Opportunity","status":"NotStarted","processedRecords":0,"predictionDefinition":{"id":"1OR090000008TAhGAM"},"name":"Daily_L2W_Score8","lastModifiedDate":"2021-11-11T12:29:35.000Z","lastModifiedBy":{"profilePhotoUrl":"https://everythingspring21--c.documentforce.com/profilephoto/005/T","name":"James Kenny","id":"00509000003kQDUAA2"},"label":"Daily L2W Score","id":"1OS09000000Gmb7GAC","filters":[],"failedRecords":0,"createdDate":"2021-11-11T12:29:35.000Z"},"batchSize":2000}');
			res.setStatusCode(201);
		}
		return res;
	}
}