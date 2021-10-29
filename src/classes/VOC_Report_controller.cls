public with sharing class VOC_Report_controller{
    public List<Voice_of_Customer__c> voc;
    public List<Voice_of_Customer__c> vocMainList{get;set;}
    public VOC_Report_controller() {
    system.debug('!!!!!!!!!!!!!!!!!!VOC_Report_controller!!!!!!!!!!!!!!!!!!!!!!!!!'+voc);
        voc = new List<Voice_of_Customer__c>();
    }        
     
    Public void generateExcel(List<Voice_of_Customer__c> vocList) {
    system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+vocList);
        For(Voice_of_Customer__c v: VOCList) {
            voc.add(v);    
        }    
    }
    
    public VOC_Report_controller(List<Voice_of_Customer__c> vocList) {
    system.debug('!!!!!!!!!!!!!!!!!!VOC_Report_controller!!!!!!!!!!!!!!!!!!!!!!!!!'+vocList);
        voc = vocList;
    }
    
    Public void Generatepage() {
        
        vocMainList = new List<Voice_of_Customer__c>();
        for(Voice_of_Customer__c v:voc) {
            vocMainList.add(v);    
        }
    }
}