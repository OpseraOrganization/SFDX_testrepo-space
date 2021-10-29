@RestResource(urlMapping = '/documentId/*')
global with sharing class AERO_Attachment {
    
    @HTTPGet
    global static void doGet(){
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        string requestURI = req.requestURI;
        String contentDocId = requestURI.substring(requestURI.lastIndexOf('/')+1);
        system.debug('contentDocId***' +contentDocId);
        AERO_Result result = getAllAttachmentIds(contentDocId);
        
        if(json.serialize(result) != '[]'){
            res.responseBody = Blob.valueOf(json.serialize(result));
        }
        
    }
    
    public static AERO_Result getAllAttachmentIds(String contentDocId){
        AERO_Result result = new AERO_Result();
        if(String.isBlank(contentDocId)){
            result.handleError(400, 'No document Id provided', 'Please provide document Id');
            return result;
        }
        List<ContentVersion> contVersion = [SELECT Id,Title,FileExtension FROM ContentVersion WHERE ContentDocumentId = :contentDocId];
        if(contVersion.size()<1){
            result.handleError(404, 'No document found for given Id', 'Please provide valid document Id');
            return result;
        }
        result.Data = contVersion;
        return result;
    }
}