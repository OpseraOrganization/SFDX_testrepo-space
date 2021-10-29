/*********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_Echosign
* Description           : Test Class for Echosign classes
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 20-Oct-2012      0.01           NTTData     Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_Echosign
{
    static testMethod void TestMthd_Echosign()
    {
       
       UpdateSigner objUpdateSigner = new UpdateSigner();
       objUpdateSigner.addNewAddress();
       
       dto16ApiEchosign objdto16ApiEchosign = new dto16ApiEchosign();
         new dto16ApiEchosign.EmbeddedWidgetCreationResult();
       
       dto17ApiEchosign objdto17ApiEchosign = new dto17ApiEchosign();
         new dto17ApiEchosign.ReplaceSignerResult();
         new dto17ApiEchosign.DelegateSigningResult();
         new dto17ApiEchosign.DelegateSigningOptions();
         new dto17ApiEchosign.ReplaceSignerOptions();
       
        dto10ApiEchosign objdto10ApiEchosign = new dto10ApiEchosign();
        new dto10ApiEchosign.ArrayOfWidgetItem();
        new dto10ApiEchosign.GetWidgetsForUserResult();
        new dto10ApiEchosign.WidgetItem();
        
        dto11ApiEchosign objdto11ApiEchosign = new dto11ApiEchosign();
        new dto11ApiEchosign.ArrayOfParticipantRole();
        new dto11ApiEchosign.ArrayOfParticipantInfo();
        new dto11ApiEchosign.ParticipantInfo();
        new dto11ApiEchosign.ArrayOfSecurityOption();
        new dto11ApiEchosign.ArrayOfDocumentHistoryEvent();
        new dto11ApiEchosign.DocumentHistoryEvent();
        
        dto12ApiEchosign objdto12ApiEchosign = new dto12ApiEchosign();
        new dto12ApiEchosign.DocumentInfoList();
        new dto12ApiEchosign.ArrayOfDocumentInfo();
        new dto12ApiEchosign.DocumentInfo();
        
        dto7ApiEchosign objdto7ApiEchosign = new dto7ApiEchosign();
        new dto7ApiEchosign.CreateAccountResult();
        new dto7ApiEchosign.AccountCreationInfo();
        
        dto8ApiEchosign objdto8ApiEchosign = new dto8ApiEchosign();
        new dto8ApiEchosign.EmbeddedWidgetCreationResult();
        new dto8ApiEchosign.WidgetCompletionInfo();
        new dto8ApiEchosign.UrlWidgetCreationResult();
        dto8ApiEchosign.WidgetCreationInfo widgetInfo = new dto8ApiEchosign.WidgetCreationInfo();
        new dto8ApiEchosign.GetFormDataResult();
        dto8ApiEchosign.WidgetPersonalizationInfo personalizationInfo = new dto8ApiEchosign.WidgetPersonalizationInfo();
        
        dto9ApiEchosign objdto9ApiEchosign = new dto9ApiEchosign();
        new dto9ApiEchosign.AuditTrailResult();
        new dto9ApiEchosign.LibraryDocumentCreationResult();
        new dto9ApiEchosign.LibraryDocumentCreationInfo();
        new dto9ApiEchosign.ArrayOfNextParticipantInfo();
        new dto9ApiEchosign.SigningUrl();
        new dto9ApiEchosign.MergeFieldInfo();
        new dto9ApiEchosign.ArrayOfDocumentLibraryItem();
        new dto9ApiEchosign.NextParticipantInfo();
        new dto9ApiEchosign.MergeField();
        new dto9ApiEchosign.GetLibraryDocumentsForUserResult();
        new dto9ApiEchosign.SigningUrlResult();
        new dto9ApiEchosign.DocumentLibraryItem();
        new dto9ApiEchosign.ArrayOfSigningUrl();
        new dto9ApiEchosign.InitiateInteractiveSendDocumentResult();
        new dto9ApiEchosign.UserCredentials();
        new dto9ApiEchosign.ArrayOfMergeField();        
        
        dtoApiEchosign objdtoApiEchosignn= new dtoApiEchosign();
        new dtoApiEchosign.Pong();
        new dtoApiEchosign.CallbackInfo();
        new dtoApiEchosign.ArrayOfDocumentPageImages();
        new dtoApiEchosign.ArrayOfUserInfo();
        new dtoApiEchosign.UserCreationInfo();
        new dtoApiEchosign.CancelDocumentResult();
        new dtoApiEchosign.GetMegaSignDocumentResult();
        dtoApiEchosign.SenderInfo senderInfo = new dtoApiEchosign.SenderInfo();
        new dtoApiEchosign.ArrayOfFileInfo();
        new dtoApiEchosign.GetUsersInAccountResult();
        new dtoApiEchosign.SendReminderResult();
        new dtoApiEchosign.UserVerificationInfo();
        new dtoApiEchosign.DocumentUrlResult();
        new dtoApiEchosign.FileInfo();
        new dtoApiEchosign.DocumentListItem();
        new dtoApiEchosign.SendDocumentMegaSignResult();
        new dtoApiEchosign.FormCreationResult();
        new dtoApiEchosign.ArrayOfDocumentListItem();
        new dtoApiEchosign.FormCreationInfo();
        new dtoApiEchosign.ExternalId();
        new dtoApiEchosign.DocumentCreationInfo();
        new dtoApiEchosign.ArrayOfDocumentKey();
        new dtoApiEchosign.SecurityOptions();
        new dtoApiEchosign.DocumentImageList();
        new dtoApiEchosign.DisplayUserInfo();
        new dtoApiEchosign.DocumentPageImages();
        new dtoApiEchosign.UserInfo();
        new dtoApiEchosign.RemoveDocumentResult();
        new dtoApiEchosign.DocumentKey();
        new dtoApiEchosign.GetDocumentsForUserResult();
        
        
        apiEchosign objapiEchosign = new apiEchosign();
        new apiEchosign.getDocumentByVersion_element();
        new apiEchosign.getImagesByVersionResponse_element();
        new apiEchosign.removeDocument_element();
        new apiEchosign.getDocumentsForUserResponse_element();
        new apiEchosign.getLatestImages_element();
        new apiEchosign.getLatestDocumentUrlResponse_element();
        new apiEchosign.createPersonalEmbeddedWidgetResponse_element();
        new apiEchosign.testPing_element();
        new apiEchosign.getMyDocuments_element();
        new apiEchosign.getSigningUrlResponse_element();
        new apiEchosign.createPersonalEmbeddedWidget_element();
        new apiEchosign.getLatestDocumentResponse_element();
        new apiEchosign.getDocumentInfoResponse_element();
        new apiEchosign.cancelDocument_element();
        new apiEchosign.getFormData_element();
        new apiEchosign.getMegaSignDocument_element();
        new apiEchosign.getAuditTrailResponse_element();
        new apiEchosign.initiateInteractiveSendDocumentResponse_element();
        new apiEchosign.getMyDocumentsResponse_element();
        new apiEchosign.createLibraryDocument_element();
        new apiEchosign.testEchoFileResponse_element();
        new apiEchosign.cancelDocumentResponse_element();
        new apiEchosign.personalizeEmbeddedWidgetResponse_element();
        new apiEchosign.initiateInteractiveSendDocument_element();
        new apiEchosign.getLatestImagesResponse_element();
        new apiEchosign.createUser_element();
        new apiEchosign.getSigningUrl_element();
        new apiEchosign.ArrayOfString();
        new apiEchosign.sendDocumentMegaSign_element();
        new apiEchosign.createUserResponse_element();
        new apiEchosign.getDocumentsForUser_element();
        new apiEchosign.getAuditTrail_element();
        new apiEchosign.getDocumentByVersionResponse_element();
        new apiEchosign.testPingResponse_element();
        new apiEchosign.createLibraryDocumentResponse_element();
        new apiEchosign.sendDocumentResponse_element();
        new apiEchosign.getLatestDocumentUrl_element();
        new apiEchosign.getDocumentUrlByVersion_element();
        new apiEchosign.getDocumentInfosByExternalId_element();
        new apiEchosign.createEmbeddedWidgetResponse_element();
        new apiEchosign.sendReminder_element();
        new apiEchosign.createPersonalUrlWidget_element();
        new apiEchosign.personalizeUrlWidgetResponse_element();
        new apiEchosign.verifyUserResponse_element();
        new apiEchosign.getWidgetsForUser_element();
        new apiEchosign.sendReminderResponse_element();
        new apiEchosign.getMegaSignDocumentResponse_element();
        new apiEchosign.createFormResponse_element();
        new apiEchosign.removeDocumentResponse_element();
        new apiEchosign.getLibraryDocumentsForUserResponse_element();
        new apiEchosign.getUsersInAccount_element();
        new apiEchosign.createUrlWidget_element();
        new apiEchosign.createAccount_element();
        new apiEchosign.getLatestDocument_element();
        new apiEchosign.getMyWidgets_element();
        new apiEchosign.createForm_element();
        new apiEchosign.getMyWidgetsResponse_element();
        new apiEchosign.getLibraryDocumentsForUser_element();
        new apiEchosign.personalizeEmbeddedWidget_element();
        new apiEchosign.createAccountResponse_element();
        new apiEchosign.createPersonalUrlWidgetResponse_element();
        new apiEchosign.getUsersInAccountResponse_element();
        new apiEchosign.getDocumentUrlByVersionResponse_element();
        new apiEchosign.getDocumentInfo_element();
        new apiEchosign.getWidgetsForUserResponse_element();
        new apiEchosign.verifyUser_element();
        new apiEchosign.getDocumentInfosByExternalIdResponse_element();
        new apiEchosign.createUrlWidgetResponse_element();
        new apiEchosign.createEmbeddedWidget_element();
        new apiEchosign.getMyLibraryDocuments_element();
        new apiEchosign.sendDocument_element();
        new apiEchosign.personalizeUrlWidget_element();
        new apiEchosign.sendDocumentMegaSignResponse_element();
        new apiEchosign.getFormDataResponse_element();
        new apiEchosign.testEchoFile_element();
        new apiEchosign.getImagesByVersion_element();
        new apiEchosign.getMyLibraryDocumentsResponse_element();
        
        delegateSigningapiEchosign objdelegateSigningapiEchosign = new delegateSigningapiEchosign();
        new delegateSigningapiEchosign.delegateSigning_element();
        new delegateSigningapiEchosign.delegateSigningResponse_element();
        
        
        apiEchosign.EchoSignDocumentService12HttpPort objEchoDoc = new apiEchosign.EchoSignDocumentService12HttpPort();
          If(!Test.isRunningTest()){
            objEchoDoc.personalizeEmbeddedWidget(Label.echosign_Api_Key,'widgetJavascript',personalizationInfo);
        }
        dtoApiEchosign.FormCreationInfo formInfo = new dtoApiEchosign.FormCreationInfo();
        
        If(!Test.isRunningTest())
        {
            objEchoDoc.createForm(Label.echosign_Api_Key,senderInfo,formInfo);
        }    
        If(!Test.isRunningTest())
        {
            dto8ApiEchosign.EmbeddedWidgetCreationResult objEmbed = objEchoDoc.createEmbeddedWidget(Label.echosign_Api_Key,senderInfo,widgetInfo);
        }
       
        /*dto10ApiEchosign.GetWidgetsForUserResult objWidget = objEchoDoc.getMyWidgets(Label.echosign_Api_Key);
        
        objEchoDoc.getLatestDocument(Label.echosign_Api_Key,'P8T2UL5H77XN6E');
        
        dtoApiEchosign.ExternalId externalId = new dtoApiEchosign.ExternalId();
        
        objEchoDoc.getDocumentInfosByExternalId(Label.echosign_Api_Key,'','',externalId);
        
          If(!Test.isRunningTest())
          {
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://api.echosign',
              'getLatestDocument',
              'http://api.echosign',
              'getLatestDocumentResponse',
              'apiEchosign.getLatestDocumentResponse_element'}
            );}
            response_x = response_map_x.get('response_x');
            return response_x.pdf; 
        }*/
        
        
        
//        new apiEchosign.getMyLibraryDocumentsResponse_element();

  
    }
    
    @isTest static void testEchoString4() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new WebserviceMock_EchoSign ());
        //apiEchosign.EchoSignDocumentService12HttpPort stub= new apiEchosign.EchoSignDocumentService12HttpPort();
        delegateSigningapiEchosign stub = new delegateSigningapiEchosign();
        dto17ApiEchosign.DelegateSigningOptions delegateSigningOptions= new dto17ApiEchosign.DelegateSigningOptions();
        delegateSigningOptions.message='Delegate Signer';
        delegateSigningOptions.newSignerEmail='newsignerEmail';
        dto9ApiEchosign.UserCredentials user= new dto9ApiEchosign.UserCredentials();
        user.email= 'siva.nannapaneni@honeywell.com';//'sample@echo.com';
        //user.email= UserInfo.getUserEmail(); 
        dto17ApiEchosign.DelegateSigningResult output = stub.delegateSigning('apiKey',user,'documentKey',delegateSigningOptions);    
     }
}