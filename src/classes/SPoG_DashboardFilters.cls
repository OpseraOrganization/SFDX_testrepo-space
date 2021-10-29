/********************************************************
* @Description : Apex Class to retrieve the Dashboard Filter Data Information
* . 
* ******************************************************/
public with Sharing class SPoG_DashboardFilters {
	/**************************************************************
     * @Description: Method to get All Dashboard Filter Data 
     * ***********************************************************/
    public String loadFilters(){
        FiltersData filters = new FiltersData();
        List<Option> options = new List<Option>();
        Schema.DescribeFieldResult regiondescribe   = Account.GCE_CSS__c.getDescribe();
		List<Schema.PicklistEntry> regionentries    = regiondescribe.getPicklistValues();
        Schema.DescribeFieldResult typedescribe     = Account.GCE_CSS_Type__c.getDescribe();
		List<Schema.PicklistEntry> typeentries  	= typedescribe.getPicklistValues();
        Schema.DescribeFieldResult segmentdescribe  = Account.GCE_Customer_Segment__c.getDescribe();
		List<Schema.PicklistEntry> segmententries   = segmentdescribe.getPicklistValues();
        for(Schema.PicklistEntry each_entry : regionentries){
            if(each_entry.isActive()){
                options.add(new Option(each_entry.getLabel().toUpperCase(),each_entry.getValue()));
            }
        }
        filters.regioninfo = options;
        options = new List<Option>();
        for(Schema.PicklistEntry each_entry : typeentries){
            if(each_entry.isActive()){
                options.add(new Option(each_entry.getLabel().toUpperCase(),each_entry.getValue()));
            }
        }
        filters.typeinfo = options;
        options = new List<Option>();
        for(Schema.PicklistEntry each_entry : segmententries){
            if(each_entry.isActive()){
                options.add(new Option(each_entry.getLabel().toUpperCase(),each_entry.getValue()));
            }
        }
        filters.segmentinfo = options;
        options = new List<Option>();
        for(Account each_acc : [Select Id,Name from Account where Customer_Status__c = 'Active' Order By Name ASC LIMIT 25]){
            options.add(new Option(each_acc.Name.toUpperCase(),each_acc.Name));
        }
        filters.accountinfo = options;
        options = new List<Option>();
        String query = ' Select GCE_CSS_Assignment__c Id,GCE_CSS_Assignment__r.Name Name from Account where GCE_CSS_Assignment__c!=null GROUP BY GCE_CSS_Assignment__c,GCE_CSS_Assignment__r.Name ORDER BY GCE_CSS_Assignment__r.Name ASC LIMIT 30 ';
        for(AggregateResult each_con : DataBase.query(query)){
            options.add(new Option(((String)each_con.get('Name')).toUpperCase(),(String)each_con.get('Id')));
        }
        filters.assignmentinfo = options;
        return JSON.serialize(filters);
    }
    /**************************************************************
     * @Description: Method to get Dynamic Dashboard Filter Data 
     * ***********************************************************/
    public String getDynamicFiltersData(String searchString, List<String> selData, String filterType){
        DynamicFiltersData filterdata = new DynamicFiltersData();
        try{
            List<Option> options = new List<Option>();
            if(filterType=='Contact'){
                String query = ' Select GCE_CSS_Assignment__c Id,GCE_CSS_Assignment__r.Name Name from Account where ( GCE_CSS_Assignment__c!=null AND Customer_Status__c =\'Active\' ) ';
                if(String.isNotEmpty(searchString)){
                    query += ' AND ( GCE_CSS_Assignment__r.Name LIKE \''+searchString+'%\' ) ';
                }
                query += ' GROUP BY GCE_CSS_Assignment__c,GCE_CSS_Assignment__r.Name ORDER BY GCE_CSS_Assignment__r.Name ASC LIMIT 30 ';
                for(AggregateResult each_con : DataBase.query(query)){
                    options.add(new Option(((String)each_con.get('Name')).toUpperCase(),(String)each_con.get('Id')));
                }
            }else if(filterType=='Account'){
                String query = 'Select Id,Name FROM Account where  Customer_Status__c =\'Active\' ';
                if(String.isNotEmpty(searchString)){
                    query += ' AND ( ';
                    query += ' Name LIKE \''+searchString+'%\'';
                    if(selData != null && selData.size()>0){
                        query += ' OR ID IN :selData ';
                    }
                    query += ' ) ';
                }else{
                    if(selData != null && selData.size()>0){
                        query += ' OR ID IN :selData ';
                    }
                }
                query += ' Order By Name ASC LIMIT 50 ';
                for(Account each_acc : DataBase.query(query)){
                    options.add(new Option(each_acc.Name.toUpperCase(),each_acc.Name));
                }
            }
            filterdata.options   = options;
            filterdata.isSuccess = True;
            filterdata.message   = 'Success';
            filterdata.count = options.size();
        }catch(Exception ex){
            System.debug('===>>'+ex.getMessage());
        }
        return JSON.serialize(filterdata);
    }
    public class DynamicFiltersData{
        public List<Option> options = new List<Option>();
        public Boolean isSuccess = false;
        public String message = '';
        public Integer count = 0;
    }
    public class FiltersData{
        public List<Option> accountinfo = new List<Option>();
        public List<Option> assignmentinfo = new List<Option>();
        public List<Option> segmentinfo = new List<Option>();
        public List<Option> regioninfo = new List<Option>();
        public List<Option> typeinfo = new List<Option>();
    }
    public class Option{
        public String label;
        public String value;
        public Option(String label,String value){
            this.label = label;
            this.value = value;
        }
    }
}