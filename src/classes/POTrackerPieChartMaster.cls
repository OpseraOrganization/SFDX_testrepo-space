public virtual class POTrackerPieChartMaster extends POTracker{
    
    public class PieWedgeData {
        public String name { get; set; }
         public String chartLabel { get; set; }
        public Integer data { get; set; }
        public PieWedgeData(String name, Integer data) {
            this.name = name + ' ' + data;
            this.data = data;
            this.chartLabel = name;
        }
        
        public PieWedgeData(String name, Integer data,String chartLabel) {
            this.name = addNextLine(name) + '\n' + data;
            this.data = data;
            this.chartLabel = chartLabel;
            
        }

        public PieWedgeData(String name, Integer data,String chartLabel,Integer total) {
            this.name = addNextLine(name) + '\n' + getPercentageText(total,data) + ' [' + data+']';
            this.data = data;
            this.chartLabel = chartLabel;
            
        }
        
        String getPercentageText(Integer total,Integer inputVal){
            
            if(total == 0){
                return '(0%)';
            }
            
            Decimal d   = Decimal.valueof(inputVal);
            return  '('+ (d.Divide(total,3)*100).round()+'%'+')'; 
        } 
              String addNextLine(String str){
				      	String retStr = '';	
				      	try{
						      	if(str == null || str == '')
							      	return retStr;
				      	
						      	if(str.length() > 15){
							      		String[] arr= str.split(' ');
							      		for(Integer i=0;i<arr.size();i++){
							      			if(i<arr.size()-1)
								      			retStr = retStr + arr[i]+' ';
							      			else
								      			retStr = retStr+'\n'+arr[i]; 
							      		}
							   return retStr;
				      	}
				      	}catch(Exception e){
				      		return str;
				      	}
				      	return str;
     		 }
        }
        
           public class RMUConfigTable {
            public String region { get; set; }
            public Integer cnt { get; set; }
            public RMUConfigTable(){
                cnt     = 0;
                region  = '';
            }
            
            public RMUConfigTable(String pregion,Integer pcnt){
                this.region = pregion;
                this.cnt = pcnt;
            }
       }   
       
       public static testMethod void testIt(){
       		RMUConfigTable a= new RMUConfigTable();
       }


        
}