public without sharing class BGACSM {


     public String getSkillValue() {
            return null;
        }

    public BGACSM(ApexPages.StandardController controller) {
    
    lSelectedSkills= New List<Skills2__c>();
        PBT_Flag=false;
        MSGflag=false;

    }

    public static List<Skills2__c> lSkills= New List<Skills2__c>();
    public List<Skills2__c> lSelectedSkills{get;set;}
    public List<Skills2__c> lAvionicsSkills{get;set;}
    
    public Boolean PBT_Flag{get;set;}
    Public Boolean MSGflag{get;set;}
    public String Value{get;set;}
    public String Type{get;set;}
    public String Comment{get;set;}
    
    public String[] SkillType= new String[]{};
    public String[] SkillValue= new String[]{};
    public String[] SkillComment=new String[]{};
    
    public List<String> lSkillType= New List<String>();
    public static List<String> lSkillvalue=New List<String>();
    
 
    
    public BGACSM(){
        lSelectedSkills= New List<Skills2__c>();
        PBT_Flag=false;
    }
     
    public List<SelectOption> getSkillType() {
             List<Skills2__c> skills=new  List<Skills2__c>();
             List<String> str = new List<String>();
            //mymethod();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--None--','--None--'));
            options.add(new SelectOption('Area Covered US','USA'));
            options.add(new SelectOption('Areas Covered Canada','CANADA'));
            
            skills=[SELECT Skill_Value__c FROM Skills2__c WHERE Skill_Type__c IN ('Areas Covered Intl A-K','Areas Covered Intl L-Z') order by Skill_Value__c ];
              
                  str= new List<String>();   
      
       // options.add(new SelectOption('None','None'));    
        Integer skillsSize=skills.size();
        for(integer i=0;i<skillsSize;i++){
          integer flag=0;
                 for(integer j=0;j<str.size();j++){
                   if(str[j]==skills[i].Skill_Value__c ){
                   flag=1;
                   }
                 }
                 if(flag==0 && skills[i].Skill_Value__c !=null){
                 str.add(skills[i].Skill_Value__c );   
                 } 
       } 
              
        for(integer k=0;k<str.size();k++){     
        options.add(new SelectOption(str[k],str[k]));
        }
          //  options.add(new SelectOption('Areas Covered Intl A-K','India'));
          /*for(String S: lSkillType){
                String s1=String.Valueof(S);
                options.add(new SelectOption(s1,s1)); 
            } */
            
            return options;
        } 
    
     public String[] getCountries() {
            return SkillType;
        }
            
        public void setCountries(String[] countries) {
            this.SkillType= SkillType;
        }
     
     public void skillvalue_selector(){
                
             //System.debug('<<<<<<Type>>>>>>'+Type);        
             if(Type=='Area Covered US' || Type=='Areas Covered Canada' ){
             lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Type__c=:Type];
             }else {
             lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Value__c=:Type];
             }
                               
             lSkillvalue=New List<String>();
             
             Set<String> sSkillsValue= New Set<String>();
            
             for(Skills2__c S1:lSkills){
             
                 if(Type=='Area Covered US' || Type=='Areas Covered Canada' ){
                 sSkillsValue.add(S1.Skill_Value__c);
                 }else{
                 sSkillsValue.add(S1.Skill_Value_Comments__c);
                 }
                 
             
             }   
                         
             lSkillvalue.addAll(sSkillsValue);
             
             //system.debug('<<<<>>>>>'+lSkillvalue);
 
     }
  
  @RemoteAction
  Static public List<string> getStatevalues(String Type){
                
             //System.debug('<<<<<<Type>>>>>>'+Type);        
             if(Type=='Area Covered US' || Type=='Areas Covered Canada'){
             lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Type__c=:Type order by Skill_Value__c ];
             }else {
             lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Value__c=:Type order by Skill_Value_Comments__c];
             }
                               
             lSkillvalue=New List<String>();
             
             Set<String> sSkillsValue= New Set<String>();
             Set<String> excludedValues = new Set<String>{'Delaware,Maryland,New Jersey,Pennsylvania,Virginia','Canada',''}; 
             for(Skills2__c S1:lSkills){
             
                 if(Type=='Area Covered US' || Type=='Areas Covered Canada'){
                     if(!excludedValues.contains(S1.Skill_Value__c))
                        sSkillsValue.add(S1.Skill_Value__c);
                 }else{
                     sSkillsValue.add(S1.Skill_Value_Comments__c);
                 }
                 
             
             }   
                 lSkillvalue.addAll(sSkillsValue);      
            lSkillvalue.sort();
             
            // system.debug('<<<<>>>>>'+lSkillvalue);
     
     return lSkillvalue;
     
     }
     
  @RemoteAction
    Static public List<AggregateResult > getResultValue(String Type,String State)
   {
   
    List<AggregateResult > listCSM= new List<AggregateResult >();
    //System.debug('State Value--->'+State);
    
    //System.debug('Type Value--->'+Type);
      if(Type =='Area Covered US' || Type =='Areas Covered Canada'){
      if(State != '--None--')
      {
      listCSM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c,Contact__r.Phone_5__c,Contact__r.Email  from Skills2__c where Skill_Value__c=:State and Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      system.debug('@@@'+listCSM);
      }else
      {
      listCSM=[Select Id, Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
      }else{
       
      if(State != '--None--')
      {
       listCSM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value_Comments__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
      else
      {
         listCSM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c, contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c,Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value__c=:Type and (Skill_Type__c='Areas Covered Intl L-Z' or Skill_Type__c='Areas Covered Intl A-K')  and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
       
      
   }   
   //lSelectedSkillsnew.add(listCSM);
   //system.debug('-------lenin---listCSM------'+listCSM);
  
   return listCSM; } 
   
     @RemoteAction
    Static public List<DirectAccessInformation__c > getPhoneValue(String Type,String State)
   {
   
    //List<DirectAccessInformation__c> listTechSupport= new List<AggregateResult >();
    System.debug('State Value--->'+State);
     List<DirectAccessInformation__c> list1 = [select Name,PhoneNo__c from DirectAccessInformation__c where Name=:Type];
    //System.debug('Type Value--->'+Type);
      /*if(Type =='Area Covered US' || Type =='Areas Covered Canada'){
      if(State != '--None--')
      {
      listCSM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c,Contact__r.Phone_5__c,Contact__r.Email  from Skills2__c where Skill_Value__c=:State and Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      system.debug('@@@'+listCSM);
      }else
      {
      listCSM=[Select Id, Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
      }else{
       
      if(State != '--None--')
      {
       listCSM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value_Comments__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
      else
      {
         listCSM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c, contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c,Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value__c=:Type and (Skill_Type__c='Areas Covered Intl L-Z' or Skill_Type__c='Areas Covered Intl A-K')  and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Phone_5__c,Contact__r.Email,contact__r.Mobile_App_Contact_Number__c order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
       
      
   }   
   //lSelectedSkillsnew.add(listCSM);
   //system.debug('-------lenin---listCSM------'+listCSM);
  */
   return list1; } 
   @RemoteAction
   /**Getting ASM Contacts ***/
   
    Static public List<AggregateResult > getResValue(String Type,String State)
   {
   
    List<AggregateResult > listASM= new List<AggregateResult >();
    //System.debug('State Value--->'+State);
      if(Type=='Area Covered US' || Type=='Areas Covered Canada'){
      if(State != '--None--')
      {
      listASM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value__c=:State and Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c];
      }else
      {
      listASM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c];
     //system.debug('%%%%%%'+listASM.size());
      }
       }else{
       
      if(State != '--None--')
      {
       listASM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value_Comments__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
      else
      {
         listASM=[Select Id,Skill_Value__c,contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value__c=:Type and (Skill_Type__c='Areas Covered Intl L-Z' or Skill_Type__c='Areas Covered Intl A-K') and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM and contact__r.Sales_and_Support_Market__c excludes ('Commercial Helicopters') group by contact__r.Mobile_App_Contact_Number__c,contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c];
      }
       
      
   }   
   
  
   return listASM; } 
   
   
   @RemoteAction
    Static public List<AggregateResult > gethelisupport(String Type,String State)
   {
   
    List<AggregateResult > listheli= new List<AggregateResult >();
    //System.debug('State Value--->'+State);
    
    //System.debug('Type Value--->'+Type);
      if(Type =='Area Covered US' || Type =='Areas Covered Canada'){
      if(State != '--None--')
      {
      listheli=[Select Id,Skill_Value__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value__c=:State and Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Sales_and_Support_Market__c includes ('Commercial Helicopters')  group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c]; //contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM and
      }else
      {
      listheli=[Select Id, Skill_Value__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Sales_and_Support_Market__c includes ('Commercial Helicopters')  group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c]; //and contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM 
      }
      }else{
       
      if(State != '--None--')
      {
       listheli=[Select Id,Skill_Value__c,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value_Comments__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Sales_and_Support_Market__c includes ('Commercial Helicopters')  group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c]; //contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM and
      }
      else
      {
         listheli=[Select Id,Skill_Value__c, contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email from Skills2__c where Skill_Value__c=:Type and (Skill_Type__c='Areas Covered Intl L-Z' or Skill_Type__c='Areas Covered Intl A-K')  and contact__r.Mobile_Directory_App__c = true and contact__r.Sales_and_Support_Market__c includes ('Commercial Helicopters')  group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c,Skill_Value__c, Contact__r.Name, Contact__r.Phone_5__c,Contact__r.Email order by contact__r.BGAMob_Contact_Alt_Name__c]; //contact__r.Mobile_App_Role__c =: Label.BGAMob_CustomerSupportCSM and contact__r.Mobile_App_Role__c =: Label.BGAMob_BusinessSupportASM and
      }
       
      
   }   
   
   return listheli; } 
   
     
    @RemoteAction
   Static public list<Skills2__c>getCSM(String strId,String strConId)
   {
   list<Skills2__c> skc= new list<Skills2__c>();
   //Contact objSkill = [select Name,Id,Phone_5__c,BGAMob_Contact_Alt_Name__c,Email,Mobile_App_Role__c  from Contact where id=:strId];
  skc=[select id,name,Contact__r.BGAMob_Contact_Alt_Name__c,Contact__r.Mobile_App_Contact_Number__c,Contact__r.Phone_5__c,Contact__r.Email,Contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,Skill_Value__c from Skills2__c where Id=:strId and  Contact__c=:strConId];
  system.debug('@@@'+skc);
   return skc;
   }
   
   @RemoteAction
   Static public list<Skills2__c>getASM(String strId,String strConId)
   {
   list<Skills2__c> skc= new list<Skills2__c>();
   //Contact objSkill = [select Name,Id,Phone_5__c,Email,Mobile_App_Role__c,BGAMob_Contact_Alt_Name__c  from Contact where id=:strId];
  skc=[select id,name,Contact__r.Name, Contact__r.BGAMob_Contact_Alt_Name__c,Contact__r.Phone_5__c,Contact__r.Email,Contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,Skill_Value__c from Skills2__c where Id=:strId and  Contact__c=:strConId];
   return skc;
   }
 
 @RemoteAction
    Static public List<String> getASMCountryvalues() {
         List<Skills2__c> skills=new  List<Skills2__c>();
         List<String> skillsnew=new  List<String>();
         set<string>tempstring= new set<string>();
        Set<String> excludedValues = new Set<String>{'Australia,China,Czech Republic,France,India',''};
        //modified the select statement/added Not IN:For Regional Support Numbers 
        skills=[SELECT Skill_Value__c FROM Skills2__c WHERE Skill_Type__c IN ('Areas Covered Intl A-K','Areas Covered Intl L-Z') and Skill_Value__c Not IN('Korea,North') and (NOT Skill_Value__c like '%,%') and Skill_Value__c !=null order by Skill_Value__c  ];
      //skills = SELECT Skill_Value__c FROM Skills2__c WHERE Skill_Type__c IN ('Areas Covered Intl A-K','Areas Covered Intl L-Z') and Skill_Value__c Not IN('Korea, South','Korea, Republic Of') order by Skill_Value__c
        system.debug('countrylist'+skills);
        for(Skills2__c s:skills){
            if((!excludedValues.contains(s.Skill_Value__c))) 
            
                tempstring.add(s.Skill_Value__c);
        }
         
      
      skillsnew.addAll(tempstring);
      skillsnew.sort();
      return skillsnew;
    
    }
  
}