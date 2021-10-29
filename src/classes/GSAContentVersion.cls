public class GSAContentVersion 
{  
    public boolean showmp4{get; set;}
    public boolean showwind{get; set;}
     public ContentVersion contentdet{get; set;}
    
    public boolean getShowmp4(){
      return showmp4;
    }
     public void setShowmp4(boolean showmp4)
          {
           this.showmp4= showmp4;
          }
    
    public boolean getShowwind(){
      return showwind;
    }
     public void setShowwind(boolean showwind)
          {
           this.showwind= showwind;
          }
   public GSAContentVersion (){
      try{
           String id = ApexPages.currentPage().getParameters().get('videoid');
           contentdet = [select id, Title, Description, FileType,Owner.Name,VersionNumber,Brightcove_Path__c from ContentVersion  Where IsLatest = true and ContentDocumentId  =: id ];
            if(contentdet.FileType == 'MP4' || contentdet.FileType == 'mp4')
            {
              System.debug('Line 1'+contentdet.FileType); 
            showmp4 = true;
            showwind = false;
            }
            else if(contentdet.FileType <> 'UNKNOWN')
            {
              System.debug('Line 2'+contentdet.FileType); 
            showwind = true;
            showmp4 = false;
            }
       }
       catch(Exception e)
       {  
       System.debug(e);   
       }
      }   
    public String encode
    {
        get 
        {
            String strDownloadId = contentdet.id;
            String strPath = null;
            
            strDownloadId = strDownloadId.substring(0,strDownloadId.length()-3);
                        System.Debug('strDownloadId MODIFIED'+strDownloadId); 
                        
          String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
          if (userAgent.contains('iPhone') || userAgent.contains('iPad') )
          {
          strPath  = contentdet.Brightcove_Path__c ;
          }
          else
          {
          strPath  = 'https://c.na13.content.force.com/sfc/servlet.shepherd/version/download/' +strDownloadId + '?asPdf=false&operationContext=CHATTER';
          }
System.Debug('strPath'+strPath); 
           return strPath  ;
        }
    }
      
}