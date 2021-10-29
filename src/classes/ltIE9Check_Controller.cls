public class ltIE9Check_Controller {
  public String userAgent; 
  
  public ltIE9Check_Controller() {
  userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');//MSIE 8.0
  }
  
    public boolean getIE8Fix(){
        if( userAgent.contains('MSIE') && !userAgent.contains('9.0') )return true;
    return false;
    }
    
}