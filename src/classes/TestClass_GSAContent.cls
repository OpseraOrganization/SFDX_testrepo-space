/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_GSAContent
* Description           : Test Class to test the functionality of GSA Content Form.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 26-Mar-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_GSAContent
{
  
    static testMethod void Test_GSAContentMthd()
    {  
    PageReference objPageRef  = Page.GSASFDCVideo;  
     
        ContentVersion  objCont = new ContentVersion();
        ContentVersion  objContnew = new ContentVersion();
        String Title = 'Test Video';
        String Description ='Test Video'; 
        String FileType = 'MP4'; 
        String BrightcovePath = 'NA';
        objCont.Title = Title;
        objCont.Description = Description;
//        objCont.FileType = FileType;
       // objCont.VersionNumber  = '1';
        objCont.PathOnClient= 'New.mp4';
        objCont.VersionData=blob.valueof('New.mp4');
insert objCont;


ContentVersion  objContVal = new ContentVersion();
objContVal  = [select id, ContentDocumentId ,Title, Description, FileType,Owner.Name,VersionNumber,Brightcove_Path__c from ContentVersion  Where IsLatest = true and Id =: objCont.id ];
 objPageRef.getParameters().put('videoid', objContVal.ContentDocumentId );
 objPageRef.getHeaders().put('User-Agent','iPhone' );

  Test.setCurrentPage(objPageRef);
 GSAContentVersion  objGSACont = new GSAContentVersion();
       
  System.debug('objContVal'+objContVal);
    if(objContVal.FileType == 'MP4' || objContVal.FileType == 'mp4')
            {
            objGSACont.setShowmp4(true); 
             objGSACont.setShowwind(false); 
            }
            else
            {
              objGSACont.setShowmp4(false); 
             objGSACont.setShowwind(true); 
            }
            objGSACont.getShowmp4();
             objGSACont.getShowwind();
           String strencode =  objGSACont.encode;   
           objPageRef.getHeaders().put('User-Agent','Testing' );

  Test.setCurrentPage(objPageRef);
 objGSACont = new GSAContentVersion();
 strencode =  objGSACont.encode; 
        
          objContnew.Title = 'Test Video2';
        objContnew.Description = 'Test Video2';
//        objCont.FileType = FileType;
       // objCont.VersionNumber  = '1';
        objContnew.PathOnClient= 'New12.mpg';
        objContnew.VersionData=blob.valueof('New12.mpg');
insert objContnew;    
        objContVal = new ContentVersion();
objContVal  = [select id, ContentDocumentId ,Title, Description, FileType,Owner.Name,VersionNumber,Brightcove_Path__c from ContentVersion  Where IsLatest = true and Id =: objContnew.id ];
 objPageRef.getParameters().put('videoid', objContVal.ContentDocumentId );
 objPageRef.getHeaders().put('User-Agent','iPhone' );

  Test.setCurrentPage(objPageRef);
 objGSACont = new GSAContentVersion();
       
  System.debug('objContVal'+objContVal);
    if(objContVal.FileType == 'MP4' || objContVal.FileType == 'mp4')
            {
            objGSACont.setShowmp4(true); 
             objGSACont.setShowwind(false); 
            }
            else
            {
              objGSACont.setShowmp4(false); 
             objGSACont.setShowwind(true); 
            }
            objGSACont.getShowmp4();
             objGSACont.getShowwind();
           strencode =  objGSACont.encode;   
           objPageRef.getHeaders().put('User-Agent','Testing' );

  Test.setCurrentPage(objPageRef);
 objGSACont = new GSAContentVersion();
 strencode =  objGSACont.encode; 
    }
    
 }