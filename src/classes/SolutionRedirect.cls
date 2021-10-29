public class SolutionRedirect {

    public SolutionRedirect(ApexPages.StandardController controller) {

    }
 public PageReference checkprofile()
         {
         Id prfid = UserInfo.getProfileId();
         Profile prf = [select name from Profile where id= :prfid ];
         String prfname= prf.name;
         if(prfname=='Training – AERO Administrators' || prfname== 'Training – CAE Administrators'  )
         {
         Id id1 = [select Id from RecordType where Name = 'Solution Training'].ID;
          Pagereference p = new Pagereference('/501/e?retURL=%2F501%2Fo&RecordType='+id1+'&ent=Solution&nooverride=1');
             p.setredirect(true);
             return p;
         }
        /* else if 
         (prfname.contains('Services'))
         {
         Id id1 = [select Id from RecordType where Name = 'GDC Flight Ops Solution'].ID;
          Pagereference p = new Pagereference('/501/e?retURL=%2F501%2Fo&RecordType='+id1+'&ent=Solution&nooverride=1');
             p.setredirect(true);
             return p;
         } */

         else
         {
          Pagereference p = new Pagereference('/apex/Solution_VF');
             p.setredirect(true);
             return p;
         }
         }
}