public with sharing class skillsClass_edit {

   //variable declaration
     List<Skill_DataBase__c> skills=new  List<Skill_DataBase__c>();
     List<Skill_DataBase__c> skills2=new  List<Skill_DataBase__c>();
     List<Skill_DataBase__c> skills3=new  List<Skill_DataBase__c>();
     List<Skill_DataBase__c> skills4=new  List<Skill_DataBase__c>();
     List<String> str= new List<String>();
     List<String> str2= new List<String>();
     List<String> str3= new List<String>();
     List<String> str4= new List<String>();
     String value1,value3,value2,value4,value5,value6;
     Skills2__c  SkillsRec=new Skills2__c ();
     Skills2__c skillrecd = new Skills2__c();
     string  ContactId,skillid, multiprdtvalue,multivalue;
     List<string> StringArray= new List<string>();
     Skills2__c contacts;
     String[] values2;
     List <String> multivalues= new  List <String> ();
     public Boolean valuesel { get; set; }
     public Boolean valuesupport { get; set; }
     public Boolean valuesel1 { get; set; }
     public Boolean valuesel2 { get; set; }
     public Boolean valueExp { get; set; }
     public Boolean valueSkill { get; set; }
     public Boolean viewSupp { get; set; }
     public Boolean showAircraftType { get; set; }
     public Boolean viewOthers { get; set; }
     public Boolean valmultisel { get; set; }
     public Boolean valuemultisel { get; set; }
     public Boolean showsave { get; set; }
     public Boolean pickval { get; set; }
     public Boolean isSaveAndNew{get;set;}
     public Boolean isSelectSkillType {get;set;}
     
     integer skillrecdsize=0;
     List<SelectOption> optionsitems = new List<SelectOption>();  
     List<SelectOption> optionsitems2 = new List<SelectOption>();  
     List<SelectOption> optionsitems3 = new List<SelectOption>(); 
     List<SelectOption> optionsitems4 = new List<SelectOption>();
     List<UserRole> usrRole= new  List<UserRole>();
        Integer flagProfile=0;
        Id CurrentUser,profileId; 
        
        
        
      public void renderDetails() {
    
      flagProfile=0;
      CurrentUser=Userinfo.getUserId();
     
     
     list<AdminProfiles__c> rtype=AdminProfiles__c.getall().values();//get the values from profiles in custom settings
      
    profileId=Userinfo.getProfileId(); 
       System.debug('herrrrrrr'+profileId);
       System.debug('+++++++++'+rtype);
          for(integer i=0;i<rtype.size();i++){
          if(rtype[i].name__c==profileId){
          flagProfile=1;
          }
          }
        
    /*********** Commented as per request INC000010001033 : Everyone should be able to edit skills *********/
    
    /*if(CurrentUser!=skillrecd.OwnerId  && flagProfile==0 ){
     //PageReference p=new PageReference('/apex/NoAccess');
    //p.setRedirect(true);
    //return p;
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You are not having the permission to Edit the record')); 
    showsave=false;
   }
    else{ */
    showsave=true;
    //} 
    }
       
        
  //Controller 
   public skillsClass_edit(ApexPages.StandardController controller) {
   isSaveAndNew = false;
   isSelectSkillType = true;
     skillid = System.currentPageReference().getParameters().get('Id');
     skillrecd = [select OwnerId,skill_Type__c,id,Skill_Value__c,Aircraft_Type__c,Aircraft_Type__r.name,product_types__c,product_type__c,Catalog_Product_Groups__c,Catalog_Product_Group__c,Supported_Products__c,Supported_Product__c,Expertise__c,Primary_Secondary__c,Contact__c,Skill_Value_Comments__c 
                  from skills2__c where id = :skillid ];
     skillrecdsize=1;  
  ContactId = skillrecd.Contact__c;
  value1 =skillrecd.skill_Type__c;
  skillrecd.Catalog_Product_Group__c=skillrecd.Catalog_Product_Groups__c;
  skillrecd.Product_Type__c=skillrecd.product_types__c;
  if(value1!='Supported Product' && value1!='COE Product Type' && value1!='Site' && value1 != 'Aircraft Type'){
    multivalue=skillrecd.Skill_Value__c;
    if(multivalue!=null){
                    if(multivalue.contains(',')){
                      multivalues=multivalue.split(',');
                     }
                                      else{
                   StringArray.add(skillrecd.Skill_Value__c);
                   multivalues= StringArray;
                   }
    }
  
  }
  
  
  if(value1 != 'Supported Product' && value1 != 'Aircraft Type')
  {
  value2=skillrecd.SKILL_VALUE__C;
   valuesel=true;
   
      if(value1=='COE Product Type' || value1=='Site'){
          valmultisel=false;
          viewOthers=true;
      }
      else{
       valmultisel=true;
       viewOthers=false;
        }    
  }
  else
  { 
  if(value1 == 'Supported Product'){
      value2=skillrecd.product_type__c;
      value3=skillrecd.Catalog_Product_Group__c;
      value4=skillrecd.Supported_Product__c;
      valuesel=true;
          
         valuesel1=true;
         valuesel2=true;
         valuesupport =true;
         viewSupp=true;
     }
    if(value1 == 'Aircraft Type'){
    //value5=skillrecd.Aircraft_Type__c;
    //value6=skillrecd.Aircraft_Type__r.name;
    showAircraftType=true;
    }
  }
  
   valueExp=true;
   pickval=true;
    skills2=[select value2__C,SKILL_VALUE__C,VALUE1__C from Skill_DataBase__c where SKILL_TYPE__C=:value1];
      skills3=[select value3__C,value1__C,value2__C from Skill_DataBase__c where value1__C=:value2];
         skills4=[select value3__C,value1__C,value2__C from Skill_DataBase__c where value1__C=:value2  and value2__c = :value3];
         
         
     //skills=[select Master_Skill_Type__c from Skill_DataBase__c where Master_Skill_Type__c!=null order by Master_Skill_Type__c];
     skills=[select Master_Skill_Type__c,Mobile_App_Products_Description__c from Skill_DataBase__c where Master_Skill_Type__c Not in ('Aircraft Type A-C','Aircraft Type D-I','Aircraft Type J-P','Aircraft Type Q-Z',Null)order by Master_Skill_Type__c];
      
      str= new List<String>();   
       optionsitems = new List<SelectOption>();  
    
        Integer skillsSize=skills.size();
        for(integer i=0;i<skillsSize;i++){
          integer flag=0;
                 for(integer j=0;j<str.size();j++){
                   if(str[j]==skills[i].Master_Skill_Type__c){
                   flag=1;
                   }
                 }
                 if(flag==0 && skills[i].Master_Skill_Type__c!=null){
                 str.add(skills[i].Master_Skill_Type__c);  
                 }  
       } 
              
        for(integer k=0;k<str.size();k++){     
        optionsitems.add(new SelectOption(str[k],str[k]));
        }    
         
       optionsitems2 = new List<SelectOption>();  
      optionsitems2.add(new SelectOption('None','None'));     
       str2= new List<String>();     
       Integer items2Size=skills2.size();
        for(integer i=0;i<items2Size;i++){
          integer flag=0;
                 for(integer j=0;j<str2.size();j++){
                   if(str2[j]==skills2[i].SKILL_VALUE__C && value1!='Supported Product'){
                   flag=1;
                   }
                   if(str2[j]==skills2[i].VALUE1__C && value1=='Supported Product'){
                   flag=1;
                   }
                 }
                 if(flag==0)
                 {
                 if(value1!='Supported Product' && skills2[i].SKILL_VALUE__C!=null ){
                 str2.add(skills2[i].SKILL_VALUE__C);   
                 }else{
                 if(skills2[i].VALUE1__C !=null){
                 str2.add(skills2[i].VALUE1__C);   
                 }             
                 }
                 } 
       }                 
        for(integer k=0;k<str2.size();k++){        
        optionsitems2.add(new SelectOption(str2[k],str2[k]));
        }    
        
         optionsitems3 = new List<SelectOption>();  
         optionsitems3.add(new SelectOption('None','None'));            
       str3= new List<String>();
            for(integer i=0;i<skills3.size();i++){
          integer flag=0;
                 for(integer j=0;j<str3.size();j++){
                   if(str3[j]==skills3[i].value2__C){
                   flag=1;
                   }
                 }
                 if(flag==0  &&  skills3[i].value2__C!=null){
                 str3.add(skills3[i].value2__C);    
                 }
       }                 
        for(integer k=0;k<str3.size();k++){        
       optionsitems3.add(new SelectOption(str3[k],str3[k]));
        }
        
          optionsitems4 = new List<SelectOption>();  
       optionsitems4.add(new SelectOption('None','None'));            
       str4= new List<String>();
         for(integer i=0;i<skills4.size();i++){
          integer flag=0;
                 for(integer j=0;j<str4.size();j++){
                   if(str4[j]==skills4[i].value3__C){
                   flag=1;
                   }
                 }
                 if(flag==0   &&   skills4[i].value3__C!=null){
                 str4.add(skills4[i].value3__C);   
                 } 
       }                 
        for(integer k=0;k<str4.size();k++){        
        optionsitems4.add(new SelectOption(str4[k],str4[k]));
        }
}

 //set method for Skills
      public void setSkillsRec(Skills2__c SkillsRec) {
        this.SkillsRec = SkillsRec;
    }

    //Getting the Skils Object    
    public Skills2__c getSkillsRec(){
    return SkillsRec;
    }
 
 
  //set method for Skills
      public void setskillrecd(Skills2__c skillrecd) {
        this.skillrecd = skillrecd;
    }

    //Getting the Skils Object    
    public Skills2__c getskillrecd(){
    return skillrecd;
    }
 
 
 public void ViewDetailsExp(){
 skillrecdsize=0;
 valueExp=true;
 pickval=true;
 }
 
public void SaveSkills(){
 List <String> newArray= new  List <String> ();
  if(value2=='None'){
  value2=null;
  }
if( multivalues!=null)
   {
   if(multivalues.size()==1&& multivalues[0]=='None') {
   multivalues=newArray;
   }
   }
   if(value3=='None'){
   value3=null;
   }
   if(value4=='None'){
   value4=null;
   }
   /*if(value5=='None'){
   value5=null;
   }
  */
if(value1=='Supported Product' && skillrecd.Expertise__c==null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Expertise value is empty. Please Enter Expertise'));   
}
else{
  multiprdtvalue ='';
     
    skillrecd.Contact__c=ContactId;
      skillrecd.skill_Type__c = value1;
    if(value1 == 'Supported Product')
    {
    skillrecd.skill_value__c='';
    skillrecd.product_type__c=value2;
    skillrecd.Catalog_Product_Group__c=value3;
    skillrecd.Supported_Product__c=value4;
    System.debug('skillrecd in save ==== '+skillrecd);
    skillrecd.Supported_Products__c=skillrecd.Supported_Products__c;
    }else if(value1 == 'Aircraft Type'){
    List<Platform__c> sps=[Select Id,name from Platform__c where Id=:skillrecd.Aircraft_Type__c];
       if(sps!=null && sps.size()>0){
           value5=sps[0].name;  
           system.debug('Test***********:'+sps[0].name);     
       }else{
           SkillsRec.skill_value__c='';        
       }  
    }
    else
    {
    if(value1=='COE Product Type' || value1=='Site')
    {
    skillrecd.skill_value__c = value2;
    skillrecd.product_type__c='';
    skillrecd.Catalog_Product_Group__c='';
    skillrecd.Supported_Product__c='';
    skillrecd.Primary_Secondary__c='None';
    }
    else {
    
     if(multivalues.size()>0){
            for(integer i=0;i<multivalues.size();i++)
            {
             multiprdtvalue = multiprdtvalue + multivalues[i];
             multiprdtvalue = multiprdtvalue +',';
            }
            if(multiprdtvalue!=''){
     multiprdtvalue = multiprdtvalue.substring(0,multiprdtvalue.length()-1);
     }
     skillrecd.skill_value__c=multiprdtvalue;
     }   
     skillrecd.product_type__c='';
     skillrecd.Catalog_Product_Group__c='';
     skillrecd.Supported_Product__c='';
     skillrecd.Primary_Secondary__c='';
    }
    }
        try {
        system.debug('****@@@@@@'+value5);
        if(value1 == 'Aircraft Type'){
        skillrecd.skill_value__c = value5;
        }
        upsert skillrecd;
        if(!isSaveAndNew )
        {
            valueSkill=true;  
            showAircraftType = false;   
            valueExp = false;
            isSelectSkillType = false; 
            viewOthers = false;
            valmultisel = false;
            viewSupp = false;
        }
        skillsRec=[Select Id,name,contact__c,Aircraft_Type__c,Contact_Name__c,product_type__c,product_types__c,Catalog_Product_Group__c,Catalog_Product_Groups__c,Supported_Product__c,Supported_Products__c,Expertise__c,Primary_Secondary__c,Skill_Type__c,Skill_value__c
        from skills2__c where Id=:skillrecd.Id];
        }catch(Exception e){
            String errMsg = e.getDmlMessage(0);
            String finalerrorMsg = 'Same Skills already Exist for this Contact or Employee.';
            if(errMsg.contains('duplicate')){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getDmlMessage(0))); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,finalerrorMsg));
            }
        }
    }
    pickval=false;
 }
 
 
 public PageReference AddNewSkills(){
 
 pagereference p= new pagereference('/apex/skills?retURL='+ContactId);
 p.setredirect(true);
 return p;
 }
 
 
    public List<SelectOption> getItems() {  
      return optionsitems;
    }
  
 public void ViewDetails(){ 
 skillrecdsize=0;
   skills2=[select value2__C,SKILL_VALUE__C,VALUE1__C from Skill_DataBase__c where SKILL_TYPE__C=:value1 Order by SKILL_VALUE__C];
if(value1=='Supported Product'   ||  value1=='COE Product Type' || value1=='Site' || value1 == 'Aircraft Type'){
    valuesel=true;
    valmultisel=false;
         if(value1=='Supported Product'){
           showAircraftType=false;
           viewSupp=true;
           viewOthers=false;}
         if(value1=='COE Product Type' || value1=='Site'){
           viewSupp=false;
           viewOthers=true;}
         if(value1 == 'Aircraft Type'){
            showAircraftType=true;
            viewSupp=false;
            viewOthers=false;
         }
    }   
   
   if(value1!='Supported Product'  && value1!='COE Product Type' && value1!='Site' && value1!='Aircraft Type'){
   valmultiSel=true;
   valuesel=false;
   viewSupp=false;
   viewOthers=false;
   showAircraftType=false;
   }
    
   valuesel1=false;
   valuesel2=false;
   valueExp=false;
   pickval=false;
   valueSkill=false;
   
  optionsitems2 = new List<SelectOption>();  
      optionsitems2.add(new SelectOption('None','None'));     
       str2= new List<String>();     
       Integer items2Size=skills2.size();
        for(integer i=0;i<items2Size;i++){
          integer flag=0;
                 for(integer j=0;j<str2.size();j++){
                   if(str2[j]==skills2[i].SKILL_VALUE__C && value1!='Supported Product'){
                   flag=1;
                   }
                   if(str2[j]==skills2[i].VALUE1__C && value1=='Supported Product'){
                   flag=1;
                   }
                 }
                 if(flag==0)
                 {
                 if(value1!='Supported Product'  && skills2[i].SKILL_VALUE__C!=null ){
                 str2.add(skills2[i].SKILL_VALUE__C);   
                 }else{
                 if(skills2[i].VALUE1__C!=null){
                 str2.add(skills2[i].VALUE1__C);
                 }
                 }
                 } 
       }                 
        for(integer k=0;k<str2.size();k++){        
        optionsitems2.add(new SelectOption(str2[k],str2[k]));
        }
        
        value2=null;
 }
 
 
 public PageReference Cancel(){
 pagereference p= new pagereference('/'+ContactId);
 p.setredirect(true);
 return p;
 }

 
  public List<SelectOption> getItems2() {
       return optionsitems2;
    }
 
     public List<SelectOption> getItems3() {
             return optionsitems3;
    }
    
   public List<SelectOption> getItems4() {
   return optionsitems4;
    }
  public void ViewDetails3(){ 
  skillrecdsize=0;
   if(value1!='Supported Product')
   {
    valuesel1=false;
    valuesel2=false;
     valueExp=true;
     pickval=true;
   }
   else
   {
   skills3=[select value3__C,value1__C,value2__C from Skill_DataBase__c where value1__C=:value2];
   valuesel1=true;
   valuesel2=false;
   }
    optionsitems3 = new List<SelectOption>();  
      optionsitems3.add(new SelectOption('None','None'));            
       str3= new List<String>();
            for(integer i=0;i<skills3.size();i++){
          integer flag=0;
                 for(integer j=0;j<str3.size();j++){
                   if(str3[j]==skills3[i].value2__C){
                   flag=1;
                   }
                 }
                 if(flag==0  &&  skills3[i].value2__C!=null){
                 str3.add(skills3[i].value2__C); 
                 }   
       }                 
        for(integer k=0;k<str3.size();k++){        
       optionsitems3.add(new SelectOption(str3[k],str3[k]));
        } 
 }
  public void ViewDetails4(){ 
  skillrecdsize=0;
   skills4=[select value3__C,value1__C,value2__C from Skill_DataBase__c where value1__C=:value2  and value2__c = :value3];
   valuesel2=true;
   
     optionsitems4 = new List<SelectOption>();  
       optionsitems4.add(new SelectOption('None','None'));            
       str4= new List<String>();
         for(integer i=0;i<skills4.size();i++){
          integer flag=0;
                 for(integer j=0;j<str4.size();j++){
                   if(str4[j]==skills4[i].value3__C){
                   flag=1;
                   }
                 }
                 if(flag==0   &&  skills4[i].value3__C!=null){
                 str4.add(skills4[i].value3__C);  
                 }  
       }                 
        for(integer k=0;k<str4.size();k++){        
        optionsitems4.add(new SelectOption(str4[k],str4[k]));
        }
 }
 
  public String[] getmultivalues() {
        return multivalues;
    }
 
    public void setmultivalues(String[] multivalues) {
        this.multivalues = multivalues;
    }
 
 
 
   public String getvalue3() {
        return value3;
    }
 
    public void setvalue3(String value3) {
        this.value3 = value3;
    }
   
     public String getvalue1() {
        return value1;
    }
 
    public void setvalue1(String value1) {
        this.value1 = value1;
    }
 
    public String getvalue2() {
        return value2;
    }
 
    public void setvalue2(String value2) {
        this.value2 = value2;
    }
     public String getvalue4() {
        return value4;
    }
 
    public void setvalue4(String value4) {
        this.value4 = value4;
    }
    public PageReference getCPGPT(){
       valueExp=true;
       valuesel2=true;
       System.debug('skillrecd ======= '+skillrecd);
              
       List<Supported_Products__c> sps=[Select Id,name,Product_Type__c ,Catalog_Product_Group__c from Supported_Products__c where Id=:skillrecd.Supported_Products__c];
       if(sps!=null && sps.size()>0){
           skillrecd.Catalog_Product_Group__c=sps[0].Catalog_Product_Group__c;
           skillrecd.Product_Type__c=sps[0].Product_Type__c;
       }else{
           skillrecd.Catalog_Product_Group__c='';
           skillrecd.Product_Type__c='';    
       }
       
       return null;
   } 
   public PageReference getPlatform(){
       valueExp=true;
       valuesel2=false;
       return null;
   } 
   
   //Method to Save and redirecting to create another Aircraft Type
   public void saveAndNewMethod()
   {
        isSaveAndNew = true;
        SaveSkills();
        skillrecd = new Skills2__c();
        SkillsRec=new Skills2__c ();
        showAircraftType = true;
        value1 = value1;
        ViewDetails();
        isSaveAndNew = false;
   }
}