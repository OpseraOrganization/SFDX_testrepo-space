/*******************************************************************************
Name         : skillsClass
Company Name : NTT Data 
Modification History
Date            Version No.     Modified by     Brief Description of Modification
31-Jul-2017     1.1             NTTDATA         INC000012196463 - to uncomment ContactID Map on Skill Creation               
*******************************************************************************/
public  class skillsClass {

   //variable declaration
     List<String> Expertise = new List<String>();
     List<String> Description = new List<String>();   
     List<Skill_DataBase__c> skills=new  List<Skill_DataBase__c>();
     List<Skill_DataBase__c> skills2=new  List<Skill_DataBase__c>();
     List<Skill_DataBase__c> skills3=new  List<Skill_DataBase__c>();
      List<Skill_DataBase__c> skills4=new  List<Skill_DataBase__c>();
     List<String> str= new List<String>();
     List<String> str2= new List<String>();
     List<String> str3= new List<String>();
     List<String> str4= new List<String>();
     String value1,value3,value2,value4, multiprdtvalue;
     Skills2__c  SkillsRec=new Skills2__c ();
     string  ContactId;
     string  SupportedProductId;
     Skills2__c contacts;
     //string[] multivalues;
     List<String> multivalues=new List<String>();
     public Boolean valuesel { get; set; }
     public Boolean valuesel1 { get; set; }
     public Boolean valuesel2 { get; set; }
     public Boolean valueExp { get; set; }
     public Boolean valueSkill { get; set; }
     public Boolean valmultisel { get; set; }
     public Boolean viewSupp{ get; set; }
     public Boolean viewSave{ get; set; }
     public Boolean viewothers { get; set; }
     public Boolean hideSection { get; set; }
     public Boolean showcontact { get; set; }
     public Boolean showsupportedproduct { get; set; }
     public Boolean showAircraftType { get; set; }
     public Boolean showproducttype { get; set; }
     public Boolean showcatalogproductgroup { get; set; }
     public Boolean catdescr{get;set;}
     public Boolean isSaveAndNew{get;set;}
     
     List<SelectOption> optionsitems = new List<SelectOption>();  
     List<SelectOption> optionsitems2 = new List<SelectOption>();  
     List<SelectOption> optionsitems3 = new List<SelectOption>();  
     List<SelectOption> optionsitems4 = new List<SelectOption>();
     list<SkillId__c> rtype;
     integer flagskill=0;
     String match,match1,listView;
     //Controller
     public skillsClass(ApexPages.StandardController controller) {
      showcontact=false;
      isSaveAndNew = false;
      showsupportedproduct = false;
      
      //showsupportedproduct=false;
      hideSection=true;
      this.contacts= (Skills2__c)controller.getRecord();
      ContactId = System.currentPageReference().getParameters().get('retURL');  
      
      
      rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      match='/'+rtype[0].Id__C+'/o';
      match1=rtype[0].Id__C+'?';
      listView=ContactId.substring(1,5); 
      
      System.debug('&&&&&&&&&&&&&&&&listView'+listView);
      System.debug('&&&&&&&&&&&&&&&&listView'+match1);
      
      
     // if(ContactId=='/a1a/o')
      if(ContactId==match    ||    match1== listView ){
       showcontact=true;
       //showsupportedproduct=true;       
      } else
      {
          if(   ContactId.substring(1,4) !=rtype[0].Id__C  &&    ContactId.substring(1,4) !='003'){
            System.debug('&&&&&&&&&&&&&&&&loop1');
          flagskill=1;
          //showcontact=true;
          showsupportedproduct=true; 
          showAircraftType=true;
          showproducttype=true;
          showcatalogproductgroup=true;
          }
          else{
              System.debug('&&&&&&&&&&&&&&&&loop2');
              if(ContactId.substring(1,5) == (rtype[0].Id__C+'/') && !(ContactId.contains('save_new'))   ){
                 System.debug('&&&&&&&&&&&&&&&&loop2');
                 flagskill=1;
                 //showcontact=true;
                 showsupportedproduct=true; 
                 showAircraftType=true;
                 showproducttype=true;
                 showcatalogproductgroup=true;
              }
              else{
                     System.debug('&&&&&&&&&&&&&&&&loop3');
              ContactId=ContactId.substring(1,ContactId.length());
              ContactId=ContactId.substring(0,15); 
              }
          }
      } 
       value1 = System.currentPageReference().getParameters().get('value1');  
      if(value1 != null && value1 != '')
      {
          showsupportedproduct=false; 
          showAircraftType=true;
          showproducttype=false;
          showcatalogproductgroup=false;
      }
      //skills=[select Master_Skill_Type__c,Mobile_App_Products_Description__c from Skill_DataBase__c where Master_Skill_Type__c!=null order by Master_Skill_Type__c];
        skills=[select Master_Skill_Type__c,Mobile_App_Products_Description__c from Skill_DataBase__c where Master_Skill_Type__c Not in ('Aircraft Type A-C','Aircraft Type D-I','Aircraft Type J-P','Aircraft Type Q-Z',Null)order by Master_Skill_Type__c];
     // skills=[select SKILL_TYPE__C from Skill_DataBase__c order by SKILL_TYPE__C];
     
      str= new List<String>();   
       optionsitems = new List<SelectOption>();  
        optionsitems.add(new SelectOption('None','None'));    
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

     }
  
    //set method for Skills
      public void setSkillsRec(Skills2__c SkillsRec) {
        this.SkillsRec = SkillsRec;
    }

    //Getting the Skils Object    
    public Skills2__c getSkillsRec(){
    return SkillsRec;    
    }
 
 public void ViewDetailsExp(){
 system.debug('value1----->'+value1);
 system.debug('value2----->'+value2);
 if(value1 != 'Mobile App Products')
 {
 valueExp=true;
 catdescr=false;
 }
 else if(value1 == 'Mobile App Products')
 {
     valueExp=false;
     catdescr=true;
 }
 if(value1!='None'){
 viewSave=true;
 }
 }
 
public void SaveSkills(){
 //String[] newArray;
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
if(value1=='Supported Product' && SkillsRec.Expertise__c==null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Expertise value is empty. Please Enter Expertise'));   
}
else{

  multiprdtvalue ='';
   viewSave=false;
  hideSection=false;
 // if(ContactId!='/a1a/o')
    rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      match='/'+rtype[0].Id__C+'/o';
      
     // if(ContactId=='/a1a/o')
     
      //if(ContactId!=match   && match1!= listView   && flagskill!=1  )
     /* {
      system.debug('CON$$$$$$$$$$$$$'+ContactId);
          if(ContactId.contains('http')){
              SkillsRec.Contact__c=ContactId.subString(ContactId.lastIndexOf('/'),ContactId.length());
          }else{
              SkillsRec.Contact__c=ContactId;
          }
      }*/
      system.debug('CON$$$$$$$$$$$$$'+ContactId);
      if(ContactId.contains('http')){      
      ContactId=ContactId.subString((ContactId.lastIndexOf('/')+1),ContactId.length());
      }else if(ContactId=='/a1R/o'){
      ContactId=SkillsRec.Contact__c;
      }
      system.debug('CON$$$$$$$$$$$$$NTTtest'+ContactId);
      // Modified code for uncomment ContactID mapping for INC000012196463
      if(ContactId!=null && ContactId.startsWith('003')){
          system.debug('====ContactId Inside if: '+ContactId);
          SkillsRec.Contact__c=ContactId;
      }
      // End code for uncomment ContactID mapping for INC000012196463
      SkillsRec.skill_Type__c = value1;
    if(value1 == 'Supported Product')
    {
    SkillsRec.product_type__c=value2;
    SkillsRec.Catalog_Product_Group__c=value3;
    SkillsRec.Supported_Product__c=value4;
    }
    else
    {

    if(value1=='COE Product Type' || value1=='Site'){
    SkillsRec.skill_value__c = value2;
    }
    else if(value1=='Aircraft Type'){
   // SkillsRec.skill_value__c = SkillsRec.Aircraft_Type__r.name;
    
    List<Platform__c> sps=[Select Id,name from Platform__c where Id=:getSkillsRec().Aircraft_Type__c];
       if(sps!=null && sps.size()>0){
           SkillsRec.skill_value__c=sps[0].name;       
       }else{
           SkillsRec.skill_value__c='';         
       }  
    }
    else {
        if(multivalues.size()>0){
                for(integer i=0;i<multivalues.size();i++)
                {
                 multiprdtvalue = multiprdtvalue + multivalues[i];
                 multiprdtvalue = multiprdtvalue +',';
                }
         multiprdtvalue = multiprdtvalue.substring(0,multiprdtvalue.length()-1);    
        }
         SkillsRec.skill_value__c=multiprdtvalue;
    }
    }
   Contact ct = new Contact ();
////if(ContactId!=match   && match1!= listView   && flagskill!=1  )

System.debug('hereeeeeeeeeee'+skillsRec.contact__c);

try{
ct = [select Contact_Is_Employee__c from contact where id = :skillsRec.contact__c];
}
catch(exception e)
{}
//System.debug('hereeeeeeeeeee'+ct.Contact_Is_Employee__c);
     if(ct.Contact_Is_Employee__c == false)
     {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'The selected Contact is not a Honeywell Employee. You can associate skills only for Contact who is a Honeywell Employee.'));   
     }
    else
    {
        try {
        system.debug('***************'+SkillsRec.id);
        if(SkillsRec.id==null){
        insert SkillsRec;
        }
        
        skillsRec=[Select Id,name,contact__c,Aircraft_Type__c ,Contact_Name__c,product_type__c,Catalog_Product_Group__c,Supported_Product__c,Supported_Products__c,Catalog_Product_Groups__c,Product_Types__c, Expertise__c,Primary_Secondary__c,Skill_Type__c,Skill_value__c,Skill_Value_Comments__c 
        from skills2__c where Id=:SkillsRec.Id];
        ContactId=skillsRec.contact__c;
        SupportedProductId=skillsRec.Supported_Products__c;
       
        if(!isSaveAndNew )
        {
            valueSkill=true;       
        }
        }catch(Exception e){
            String errMsg = e.getDmlMessage(0);
            String finalerrorMsg = 'Same Skills already Exist for this Contact or Employee.';
            if(errMsg.contains('duplicate')){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getDmlMessage(0))); 
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,finalerrorMsg));
           }
           if(errMsg.contains('cannot specify Id in an insert call')){
               //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,finalerrorMsg));
           }
        }
    }
}
}
 
 
 public PageReference AddNewSkills(){
 
 pagereference p= new pagereference('/apex/skills?retURL='+ContactId);
 p.setredirect(true);
 return p;
 }
 
 public PageReference Cancel(){
 if(ContactId.contains('http')){
 ContactId=ContactId.subString((ContactId.lastIndexOf('/')+1),ContactId.length());
 }
 pagereference p= new pagereference('/'+ContactId);
 p.setredirect(true);
 return p;
 }
  
 
    public List<SelectOption> getItems() {  
        return optionsitems;
    }
  
 public void ViewDetails(){ 
 ViewSave=false;
  skills2=[select value2__C,SKILL_VALUE__C,VALUE1__C,Mobile_App_Products_Description__c from Skill_DataBase__c where SKILL_TYPE__C=:value1 ORDER BY SKILL_VALUE__C];
  if(value1=='Supported Product'   ||  value1=='COE Product Type' || value1=='Site' || value1=='Aircraft Type'){
    valuesel=true;
    valmultisel=false;
     if(value1=='Aircraft Type'){
           viewSupp=true;
           showAircraftType=true;
           showproducttype=false;
           showcatalogproductgroup=false;
           showsupportedproduct=false;
           viewOthers=false;}
         if(value1=='Supported Product'){
           viewSupp=true;
           showsupportedproduct=true;
           showproducttype=true;
           showcatalogproductgroup=true;
           showAircraftType=false;
           viewOthers=false;}
         if(value1=='COE Product Type' || value1=='Site'){
           viewSupp=false;
           showsupportedproduct=false;
           showproducttype=false;
           showcatalogproductgroup=false;
           showAircraftType=false;
           viewOthers=true;}
    }   
   
   if(value1!='Supported Product'  && value1!='COE Product Type' && value1!='Site' && value1!='Aircraft Type'){
   valmultiSel=true;
   valuesel=false;
   viewSupp=false;
   showsupportedproduct=false;
   showAircraftType=false;
   showproducttype=false;
   showcatalogproductgroup=false;
   viewOthers=false;
   }
    
   valuesel1=false;
   valuesel2=false;
   valueExp=false;
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
    system.debug('value---->'+value1);
    if(value1!='Supported Product' || value1!='Mobile App Products')
    {
        valuesel1=false;
        valuesel2=false;
        valueExp=true;
        viewSave=true;
    }
    else
    {
        skills3=[select value3__C,value1__C,value2__C,Mobile_App_Products_Description__c from Skill_DataBase__c where value1__C=:value2];
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
            if(flag==0   &&  skills3[i].value2__C!=null){
            str3.add(skills3[i].value2__C);    
            }
        }                 
        for(integer k=0;k<str3.size();k++){        
        optionsitems3.add(new SelectOption(str3[k],str3[k]));
        }
 }
 
  public void ViewDetails4(){ 
   skills4=[select value3__C,value1__C,value2__C,Mobile_App_Products_Description__c from Skill_DataBase__c where value1__C=:value2  and value2__c = :value3];
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
       viewSave=true;
       valuesel2=true;
       System.debug('Skills2__c getSkillsRec() ======= '+getSkillsRec());
       System.debug('Skills2__c getSkillsRec() ======= '+getSkillsRec().Supported_Products__c);
       SkillsRec=getSkillsRec();
       
       List<Supported_Products__c> sps=[Select Id,name,Product_Type__c ,Catalog_Product_Group__c from Supported_Products__c where Id=:getSkillsRec().Supported_Products__c];
       if(sps!=null && sps.size()>0){
           SkillsRec.Catalog_Product_Group__c=sps[0].Catalog_Product_Group__c;
           SkillsRec.Product_Type__c=sps[0].Product_Type__c;
       }else{
           SkillsRec.Catalog_Product_Group__c='';
           SkillsRec.Product_Type__c='';    
       }
       
       return null;
   } 
   
   public PageReference getPlatform(){
       valueExp=true;
       viewSave=true;
       valuesel2=false;
      
       /*
       System.debug('Skills2__c getSkillsRec() ======= '+getSkillsRec());
       System.debug('Skills2__c getSkillsRec() ======= '+getSkillsRec().Aircraft_Type__c);
       SkillsRec=getSkillsRec();    
       List<Platform__c> sps=[Select Id,name from Platform__c where Id=:getSkillsRec().Aircraft_Type__c];
       if(sps!=null && sps.size()>0){
           SkillsRec.skill_value__c=sps[0].Id;       
       }else{
           SkillsRec.skill_value__c='';         
       }  
       */   
       return null;
   } 
   
   //Method to Save and redirecting to create another Aircraft Type
   public void saveAndNewMethod()
   {
        isSaveAndNew = true;
        SaveSkills();
        SkillsRec=new Skills2__c ();
        showAircraftType = true;
        value1 = value1;
        hideSection=true;
        ViewDetails();
        isSaveAndNew = false;
   }
  
}