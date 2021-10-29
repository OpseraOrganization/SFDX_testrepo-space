@IsTest
private with sharing class apiEchosign_Test
{
    private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof apiEchosign.createEmbeddedWidget_element)
                response.put('response_x', new apiEchosign.createEmbeddedWidgetResponse_element());
            else if(request instanceof apiEchosign.getMyWidgets_element)
                response.put('response_x', new apiEchosign.getMyWidgetsResponse_element());
            else if(request instanceof apiEchosign.getLatestDocument_element)
                response.put('response_x', new apiEchosign.getLatestDocumentResponse_element());
                else if(request instanceof apiEchosign.getDocumentInfosByExternalId_element)
                response.put('response_x', new apiEchosign.getDocumentInfosByExternalIdResponse_element());
                else if(request instanceof apiEchosign.cancelDocument_element)
                response.put('response_x', new apiEchosign.cancelDocumentResponse_element());
                else if(request instanceof apiEchosign.sendDocument_element)
                response.put('response_x', new apiEchosign.sendDocumentResponse_element());
                else if(request instanceof apiEchosign.verifyUser_element)
                response.put('response_x', new apiEchosign.verifyUserResponse_element());
                else if(request instanceof apiEchosign.getDocumentUrlByVersion_element)
                response.put('response_x', new apiEchosign.getDocumentUrlByVersionResponse_element());
                else if(request instanceof apiEchosign.testEchoFile_element)
                response.put('response_x', new apiEchosign.testEchoFileResponse_element());
                else if(request instanceof apiEchosign.sendReminder_element)
                response.put('response_x', new apiEchosign.sendReminderResponse_element());
                else if(request instanceof apiEchosign.getMyDocuments_element)
                response.put('response_x', new apiEchosign.getMyDocumentsResponse_element());
                else if(request instanceof apiEchosign.getSigningUrl_element)
                response.put('response_x', new apiEchosign.getSigningUrlResponse_element());
                else if(request instanceof apiEchosign.createLibraryDocument_element)
                response.put('response_x', new apiEchosign.createLibraryDocumentResponse_element());
                else if(request instanceof apiEchosign.getLibraryDocumentsForUser_element)
                response.put('response_x', new apiEchosign.getLibraryDocumentsForUserResponse_element());
                else if(request instanceof apiEchosign.getLatestImages_element)
                response.put('response_x', new apiEchosign.getLatestImagesResponse_element());
                else if(request instanceof apiEchosign.getMegaSignDocument_element)
                response.put('response_x', new apiEchosign.getMegaSignDocumentResponse_element());
                else if(request instanceof apiEchosign.getFormData_element)
                response.put('response_x', new apiEchosign.getFormDataResponse_element());
                else if(request instanceof apiEchosign.createUser_element)
                response.put('response_x', new apiEchosign.createUserResponse_element());
                else if(request instanceof apiEchosign.personalizeUrlWidget_element)
                response.put('response_x', new apiEchosign.personalizeUrlWidgetResponse_element());
                else if(request instanceof apiEchosign.sendDocumentMegaSign_element)
                response.put('response_x', new apiEchosign.sendDocumentMegaSignResponse_element());
                else if(request instanceof apiEchosign.createAccount_element)
                response.put('response_x', new apiEchosign.createAccountResponse_element());
                else if(request instanceof apiEchosign.getUsersInAccount_element)
                response.put('response_x', new apiEchosign.getUsersInAccountResponse_element());
                else if(request instanceof apiEchosign.getImagesByVersion_element)
                response.put('response_x', new apiEchosign.getImagesByVersionResponse_element());
                else if(request instanceof apiEchosign.getWidgetsForUser_element)
                response.put('response_x', new apiEchosign.getWidgetsForUserResponse_element());
                else if(request instanceof apiEchosign.testPing_element)
                response.put('response_x', new apiEchosign.testPingResponse_element());
                else if(request instanceof apiEchosign.getLatestDocumentUrl_element)
                response.put('response_x', new apiEchosign.getLatestDocumentUrlResponse_element());
                else if(request instanceof apiEchosign.createPersonalUrlWidget_element)
                response.put('response_x', new apiEchosign.createPersonalUrlWidgetResponse_element());
                else if(request instanceof apiEchosign.createPersonalEmbeddedWidget_element)
                response.put('response_x', new apiEchosign.createPersonalEmbeddedWidgetResponse_element());
                else if(request instanceof apiEchosign.getMyLibraryDocuments_element)
                response.put('response_x', new apiEchosign.getMyLibraryDocumentsResponse_element());
                else if(request instanceof apiEchosign.createUrlWidget_element)
                response.put('response_x', new apiEchosign.createUrlWidgetResponse_element());
                else if(request instanceof apiEchosign.getDocumentByVersion_element)
                response.put('response_x', new apiEchosign.getDocumentByVersionResponse_element());
                else if(request instanceof apiEchosign.personalizeEmbeddedWidget_element)
                response.put('response_x', new apiEchosign.personalizeEmbeddedWidgetResponse_element());
                else if(request instanceof apiEchosign.createForm_element)
                response.put('response_x', new apiEchosign.createFormResponse_element());
                else if(request instanceof apiEchosign.getDocumentInfo_element)
                response.put('response_x', new apiEchosign.getDocumentInfoResponse_element());
                else if(request instanceof apiEchosign.initiateInteractiveSendDocument_element)
                response.put('response_x', new apiEchosign.initiateInteractiveSendDocumentResponse_element());
                else if(request instanceof apiEchosign.removeDocument_element)
                response.put('response_x', new apiEchosign.removeDocumentResponse_element());
                else if(request instanceof apiEchosign.getAuditTrail_element)
                response.put('response_x', new apiEchosign.getAuditTrailResponse_element());
            return;
        }
    }
    @IsTest
     private static void coverMethods()
    {
     System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
     apiEchosign apiEchosign = new apiEchosign();
     apiEchosign.EchoSignDocumentService12HttpPort EchoSignDocumentService12HttpPort = new apiEchosign.EchoSignDocumentService12HttpPort();
        EchoSignDocumentService12HttpPort.createEmbeddedWidget(null,null,null);
        EchoSignDocumentService12HttpPort.getMyWidgets(null);
        EchoSignDocumentService12HttpPort.getLatestDocument(null,null);
        EchoSignDocumentService12HttpPort.getDocumentInfosByExternalId(null,null,null,null);
        EchoSignDocumentService12HttpPort.cancelDocument(null,null,null,null);
        EchoSignDocumentService12HttpPort.sendDocument(null,null,null);
        EchoSignDocumentService12HttpPort.getDocumentUrlByVersion(null,null);
        EchoSignDocumentService12HttpPort.verifyUser(null,null,null);
        EchoSignDocumentService12HttpPort.getDocumentUrlByVersion(null,null);
        EchoSignDocumentService12HttpPort.testEchoFile(null,null);
        EchoSignDocumentService12HttpPort.getMyDocuments(null);
        EchoSignDocumentService12HttpPort.sendReminder(null,null,null);
        EchoSignDocumentService12HttpPort.getSigningUrl(null,null);
        EchoSignDocumentService12HttpPort.createLibraryDocument(null,null,null);
        EchoSignDocumentService12HttpPort.getLibraryDocumentsForUser(null,null);
        EchoSignDocumentService12HttpPort.getMegaSignDocument(null,null);
        EchoSignDocumentService12HttpPort.getFormData(null,null);
        EchoSignDocumentService12HttpPort.createUser(null,null);
        EchoSignDocumentService12HttpPort.personalizeUrlWidget(null,null,null);
        EchoSignDocumentService12HttpPort.sendDocumentMegaSign(null,null,null);
        EchoSignDocumentService12HttpPort.createAccount(null,null,null);
        EchoSignDocumentService12HttpPort.getUsersInAccount(null);
        EchoSignDocumentService12HttpPort.getImagesByVersion(null,null);
        EchoSignDocumentService12HttpPort.getWidgetsForUser(null,null);
        EchoSignDocumentService12HttpPort.testPing(null);
        EchoSignDocumentService12HttpPort.getLatestDocumentUrl(null,null);
        EchoSignDocumentService12HttpPort.createPersonalUrlWidget(null,null,null,null);
        EchoSignDocumentService12HttpPort.createPersonalEmbeddedWidget(null,null,null,null);
        EchoSignDocumentService12HttpPort.getMyLibraryDocuments(null);
        EchoSignDocumentService12HttpPort.createUrlWidget(null,null,null);
        EchoSignDocumentService12HttpPort.getDocumentByVersion(null,null);
        EchoSignDocumentService12HttpPort.personalizeEmbeddedWidget(null,null,null);
        EchoSignDocumentService12HttpPort.createForm(null,null,null);
        EchoSignDocumentService12HttpPort.getDocumentInfo(null,null);
        EchoSignDocumentService12HttpPort.initiateInteractiveSendDocument(null,null,null,null,null);
        EchoSignDocumentService12HttpPort.removeDocument(null,null);
        EchoSignDocumentService12HttpPort.getAuditTrail(null,null);
        //EchoSignDocumentService12HttpPort.getDocumentsForUser(null,null);
        EchoSignDocumentService12HttpPort.getLatestImages(null,null);
    }
}