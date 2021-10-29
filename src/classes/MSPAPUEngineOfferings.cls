/*
* This is a plain class that holds the details around the MSP for an Aircraft.
* This class will be used in the "CreateTaskForMSPAPUEngineOfferings" Batch job.
*/
public class MSPAPUEngineOfferings{
    public Id aircraft{get;set;} 
    public Integer mspAPUCount{get;set;}
    public Integer mspAPUGoldCount{get;set;}
    public Integer mspEnginesCount{get;set;}
    public Integer mspEnginesGoldCount{get;set;}
    public String mspAPUContract{get;set;}
    public String mspAPUGoldContract{get;set;} 
    public String mspEnginesContract{get;set;}
    public String mspEnginesGoldContract{get;set;} 
    public Integer MSPAPUCase{set;get{
        Integer caseNumber = 0;
        if(mspAPUCount != null && mspAPUCount>0 && mspAPUGoldCount != null && mspAPUGoldCount>0 && mspAPUGoldContract != null){
            caseNumber = 1;            
        }
        if(mspAPUCount != null && mspAPUCount==0 && mspAPUGoldCount != null && mspAPUGoldCount>0 && mspAPUGoldContract != null){
            caseNumber = 2;
        }
        if(mspAPUCount != null && mspAPUCount==1 && mspAPUGoldCount != null && mspAPUGoldCount==0){
            caseNumber = 3;
        }
        if(mspAPUCount != null && mspAPUCount==0 && mspAPUGoldCount != null && mspAPUGoldCount==0){
            caseNumber = 4;
        }
        if(mspAPUCount == null && mspAPUGoldCount != null && mspAPUGoldCount>0 && mspAPUGoldContract != null){
            caseNumber = 5;
        }
        if(mspAPUCount != null && mspAPUCount == 1 && mspAPUGoldCount == null && mspAPUContract != null){
            caseNumber = 6;
        }
        return caseNumber;
    }}
    
    public Integer MSPEnginesCase{set;get{
        Integer caseNumber = 0;
        if(mspEnginesCount != null && mspEnginesCount>0 && mspEnginesGoldCount != null && mspEnginesGoldCount>0 && mspEnginesGoldContract != null){
            caseNumber = 1;            
        }
        if(mspEnginesCount != null && mspEnginesCount==0 && mspEnginesGoldCount != null && mspEnginesGoldCount>0 && mspEnginesGoldContract != null){
            caseNumber = 2;
        }
        if(mspEnginesCount != null && mspEnginesCount==1 && mspEnginesGoldCount != null && mspEnginesGoldCount==0 && mspEnginesContract != null){
            caseNumber = 3;
        }
        if(mspEnginesCount != null && mspEnginesCount ==0 && mspEnginesGoldCount != null && mspEnginesGoldCount==0){
            caseNumber = 4;
        }
        if(mspEnginesCount == null && mspEnginesGoldCount != null && mspEnginesGoldCount>0 && mspEnginesGoldContract != null){
            caseNumber = 5;
        }
        if(mspEnginesCount != null && mspEnginesCount == 1 && mspEnginesGoldCount == null){
            caseNumber = 6;
        }
        return caseNumber;
    }}
}