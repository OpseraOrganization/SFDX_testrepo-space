/**
 * Name       :    GDMFSL_FlowHandlerDeactivateSRTest
 * Purpose    :    Test class for GDMFSL_FlowHandlerDeactivateSR.
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2020-Aug-26    Created
 **/
@IsTest
public class GDMFSL_FlowHandlerDeactivateSRTest {

    @TestSetup
    static void testData() {

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours  Inserted : ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('Flow Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted : ' + st);

        Schema.Location theLocation = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        insert theLocation;
        System.debug('location Inserted : ' + theLocation);

        Schema.Address theAddress = GDMFSL_DataFactory.createAddress('169 SpruceTree Lane', 'Ballwin', 'Missouri', '63021',
                'United States', theLocation.Id);

        insert theAddress;
        System.debug('address Inserted : ' + theAddress);

        User testUser = GDMFSL_DataFactory.createTestUser();
        insert testUser;
        System.debug('User Inserted : ' + testUser);

        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testUser.Id, theLocation.Id);
        insert sr;
        System.debug('ServiceResource Inserted : ' + sr);

        Account acct = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        insert acct;

        ServiceAppointment serviceAppointment = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'Scheduled');
        insert serviceAppointment;

        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(sr.Id, st.Id);
        insert serviceTerritoryMember;

        AssignedResource assignedResource = GDMFSL_DataFactory.createAssignedResource(serviceAppointment.Id, sr.Id);
        insert assignedResource;
    }

    @IsTest
    static void testGetServiceAppointments() {

        List<AssignedResource> lstAssignedResource = new List<AssignedResource>([SELECT Id, ServiceAppointmentId FROM AssignedResource]);

        List<List<AssignedResource>> collectionAssignedResource = new List<List<AssignedResource>>();
        collectionAssignedResource.add(lstAssignedResource);

        List<List<ServiceAppointment>> lstFetchedSA = GDMFSL_FlowHandlerDeactivateSR.getServiceAppointments(collectionAssignedResource);

        System.assert(lstFetchedSA.size() > 0, 'getServiceAppointments() did not return anything');
        System.assertEquals(1, lstFetchedSA[0].size(), 'getServiceAppointments() did not return any records');
        System.assertEquals(lstAssignedResource[0].ServiceAppointmentId, lstFetchedSA[0][0].Id, 'getServiceAppointments() did not return the right record');

    }

    @IsTest
    static void testgetSAIDs() {

        List<AssignedResource> lstAssignedResources = new List<AssignedResource>([SELECT Id, ServiceAppointmentId FROM AssignedResource]);

        Set<Id> servApptIds = new Set<Id>();

        for (AssignedResource thisAR : lstAssignedResources){
            if (thisAR.ServiceAppointmentId != null){
                servApptIds.add(thisAR.ServiceAppointmentId);
            }
        }

        List<List<AssignedResource>> aResParam = new List<List<AssignedResource>>();
        aResParam.add(lstAssignedResources);

        Set<Id> foundSAIds = GDMFSL_FlowHandlerDeactivateSR.getSAIDs(aResParam);

        System.assertEquals(servApptIds.size(), foundSAIds.size(), 'getSAIDs() did not return the right number of ServiceAppointments');

        for (Id thisFoundId : foundSAIds){
            if (!servApptIds.contains(thisFoundId)){
                System.assert(false, 'getSAIDs() returned the wrong Ids');
            }
        }
    }

}