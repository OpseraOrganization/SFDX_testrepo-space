public class BGAMob_submit {

    public string casenumber{get;set;}
    public string returnpage{get;set;}
    
    public BGAMob_submit(ApexPages.StandardController controller) 
    {
           
           casenumber=apexpages.currentpage().getParameters().get('casenum');
           if(casenumber!='' && casenumber!=null)
           casenumber=casenumber.substring(5,casenumber.length());
           returnpage=apexpages.currentpage().getParameters().get('returnpage');
             
    }

  public pagereference close()
  {
  system.debug('tttttttttttttttttttttttt');
    return page.BGAMob_TechnicalSupport;
  }

}