@isTest
global class GetAgreementURLMockImpl implements WebServiceMock {
    public static String indicatorVar;
   global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
        
         if(indicatorVar == 'first'){
         system.debug('======first');
            dto12ApiEchosign.DocumentInfoList docInfoList = new dto12ApiEchosign.DocumentInfoList();  
                   docInfoList.errorCode='200';
            docInfoList.errorMessage= 'success';
            dto12ApiEchosign.ArrayOfDocumentInfo  arryDocu= new dto12ApiEchosign.ArrayOfDocumentInfo();
            dto12ApiEchosign.DocumentInfo  docInfo=new dto12ApiEchosign.DocumentInfo();
            docInfo.documentKey='test';
            docInfo.documentKey='test';
            docInfo.latestDocumentKey='test';
            //docInfo.expiration='test';
            docInfo.locale='test';
            docInfo.message='test';
            docInfo.name='test';
            list<dto12ApiEchosign.DocumentInfo> DocumentInfo1=new list<dto12ApiEchosign.DocumentInfo>();
            DocumentInfo1.add(docInfo);
            arryDocu.DocumentInfo=DocumentInfo1;
            docInfoList.documentInfos=arryDocu;
             apiEchosign.getDocumentInfosByExternalIdResponse_element response_x1 = new apiEchosign.getDocumentInfosByExternalIdResponse_element();
             system.debug('-----docInfoList'+docInfoList);
            
            system.debug('---if--docInfoList'+docInfoList);
            response_x1.documentInfoList = docInfoList;
          
              Map<String, apiEchosign.getDocumentInfosByExternalIdResponse_element> response_map_x = new Map<String, apiEchosign.getDocumentInfosByExternalIdResponse_element>(); 
            response_map_x.put('response_x',response_x1);
            response.put('response_x', response_x1); 
        
        }
        else if(indicatorVar == 'second'){
            dto9ApiEchosign.SigningUrlResult docInfoList1 = new dto9ApiEchosign.SigningUrlResult();  
                docInfoList1.errorCode='200';
                docInfoList1.errorMessage= 'success';
            dto9ApiEchosign.ArrayOfSigningUrl  arryDocu1= new dto9ApiEchosign.ArrayOfSigningUrl();
            dto9ApiEchosign.SigningUrl  docInfo1=new dto9ApiEchosign.SigningUrl();
                docInfo1.email = 't@g.com';
                docInfo1.esignUrl = 'test';
                docInfo1.simpleEsignUrl = 'test';
            list<dto9ApiEchosign.SigningUrl> DocumentInfo11=new list<dto9ApiEchosign.SigningUrl>();
            DocumentInfo11.add(docInfo1);
            arryDocu1.SigningUrl = DocumentInfo11;
            docInfoList1.signingUrls=arryDocu1;
             apiEchosign.getSigningUrlResponse_element response_x11 = new apiEchosign.getSigningUrlResponse_element();
                     
            response_x11.getSigningUrlResult = docInfoList1;
           Map<String, apiEchosign.getSigningUrlResponse_element> response_map_x1 = new Map<String, apiEchosign.getSigningUrlResponse_element>();
            response_map_x1.put('response_x',response_x11);
            response.put('response_x', response_x11);  
        }
   }
}