public class DirectAccessUtility {
    
    public static String getUrlDecoded(String valueToDecode){
        if(String.isNotBlank(valueToDecode)){
            valueToDecode = EncodingUtil.urlDecode(valueToDecode,'UTF-8');
        }
        return valueToDecode;
    }
    
    public class supportInformation{
        public String email;
        public String phone;
        
        public supportInformation(String email, String phone){
            this.email = email;
            this.phone = phone;
        }
    }
    
    public class TechnicalExpertWrapper{
        public Skill_DataBase__c skillData;
        public List<Skills2__c> skillList;
        
        public TechnicalExpertWrapper(Skill_DataBase__c skillData){
            this.skillData = skillData;
            skillList = new List<Skills2__c>();
        }
    }

}