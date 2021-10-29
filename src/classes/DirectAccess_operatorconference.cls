public class DirectAccess_operatorconference{

public Summary[] Summaries { get; set; }


public DirectAccess_operatorconference(){

 list<Aggregateresult> operatorconference = [select DAY_IN_MONTH(Start_Date__c) date,calendar_year(Start_Date__c) year,calendar_month(Start_Date__c) month,Location__c location,Website__c website from Event__c where Start_Date__c >= today and type__C = 'BGA Events' GROUP BY calendar_month(Start_Date__c),Location__c,Website__c,calendar_year(Start_Date__c),DAY_IN_MONTH(Start_Date__c) order by calendar_year(Start_Date__c),calendar_month(Start_Date__c),DAY_IN_MONTH(Start_Date__c) asc];
 //Website__c != null and Active__c = true
 Summaries = new List<Summary>();
        for (AggregateResult ar : operatorconference ) {
            Summaries.add(new Summary(ar));
        }

}

// wrapper class to hold aggregate data
    public class Summary {
    
        public Integer dates { get; set; }
        public Integer months { get; set; }
        public Integer years { get; set; }
        public string location { get; set; }
        public String website { get; set; }
        public Date eventDate{get;set;}

        public Summary(AggregateResult ar) {
            dates = (Integer) ar.get('date');
            months = (Integer) ar.get('month');
            years = (Integer) ar.get('year');
            location = (String) ar.get('location');
            website = (String) ar.get('website');
            eventDate = Date.newInstance(years, months, dates);
        }
    }
    
    public String phoneGapUrl {
            get {
                String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
                if(!test.isRunningTest()){
                if (userAgent.contains('android')  )
                    return 'CordovaAndroid.js';
                else
                    return 'CordovaIOS.js';
                } 
                else 
                    return 'testclass';
                // iOS-specific checks that you could make.  Above, we assume it's iOS if it's not Android.
                //if (userAgent.contains('iPhone')
                //    || userAgent.contains('iPod')
                //    || userAgent.contains('iPad')
                //    || userAgent.contains('i386')
                //    || userAgent.contains('x86_64'))
                //    return 'phonegap-1.2.0-ios.js';
            }
    }


}