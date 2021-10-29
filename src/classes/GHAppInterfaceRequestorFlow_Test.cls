@isTest(seealldata = true)
public class GHAppInterfaceRequestorFlow_Test{
    public static testmethod void authenticationTest() {
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '{"id":"https://test.salesforce.com/id/00DS0000003KbiiMAC/005S0000004XclIIAS","issued_at":"1425995829962","token_type":"Bearer","instance_url":"https://cs1.salesforce.com","signature":"0q31xDmPhKd9yGsD08mzukrWSrWAVjeAnoMeUdEfgcc=","access_token":"00DS0000003Kbii!ARMAQOU226_uWf9JKRVXjxzUs_dHg8y.G6PIHFrktN5Ot30Lhjj.dMzOa1JQmEgw4dltjhSAdrnGAyEZjN.amMfgCj2_iNbI"}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        GHAppInstanceDetails__c ghPMTInstanceDetails = GHAppInstanceDetails__c.getValues('PMT');
        GHAppInterfaceRequestorFlow.getAuthenticate(ghPMTInstanceDetails);
        
    }
    
    
    public static testmethod void updateEventRecipientTest() {
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '{"id":"https://test.salesforce.com/id/00DS0000003KbiiMAC/005S0000004XclIIAS","issued_at":"1425995829962","token_type":"Bearer","instance_url":"https://cs1.salesforce.com","signature":"0q31xDmPhKd9yGsD08mzukrWSrWAVjeAnoMeUdEfgcc=","access_token":"00DS0000003Kbii!ARMAQOU226_uWf9JKRVXjxzUs_dHg8y.G6PIHFrktN5Ot30Lhjj.dMzOa1JQmEgw4dltjhSAdrnGAyEZjN.amMfgCj2_iNbI"}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        GHAppInstanceDetails__c ghPMTInstanceDetails = GHAppInstanceDetails__c.getValues('PMT');
        GHAppInterfaceRequestorFlow.getAuthenticate(ghPMTInstanceDetails);
        //GHAppInterfaceRequestorFlow.updateEventRecipient(ghPMTInstanceDetails,'a4kc00000002Q5l','Approved');
        //GHAppInterfaceRequestorFlow.getGHRequests(ghPMTInstanceDetails);
        //GHAppInterfaceRequestorFlow.updateGHRecipient(ghPMTInstanceDetails,'a4kc00000002Q5l','Approved');
        //GHAppInterface.getCurrentAggregatevalues('a@b.com');
        GHAppInterfaceRequestorFlow.getAggregatevalues(ghPMTInstanceDetails,'a@b.com');
        GHAppInterfaceRequestorFlow.getCurrentAggregatevalues('a@b.com');
        
        
        Order_Request__c oReq = new Order_Request__c();
        oReq.Additional_Comments__c='Xtra Comment';
        oReq.Business_Justification__c='Test Justification';
        oReq.Date__c= date.today();
        oReq.Name_of_Recipient__c= 'Sumivaths Gundlapalli';
        oReq.Recipient_Name_List__c = 'Sumivaths Gundlapalli';
        oReq.Status__c = 'Pending';
        //oReq.OwnerId=usr.Id;
        
        Attachment atcm = new Attachment();
        
        
        //GHAppInterfaceRequestorFlow.getGHRequestAttachments(ghPMTInstanceDetails,oReq.Id,oReq.Id);
        
    }
    
}