public without sharing class skils_testpage {
    public string skillval{get;set;} 
    public skils_testpage(ApexPages.StandardController controller) {
    lSelectedSkills= New List<Skills2__c>();
        PBT_Flag=false;
        MSGflag=false;
    }
    public string test{get;set;}
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
    public PageReference P;
    public List<Contact> empregion=New List<Contact>();
    public transient List<string> empregion1= new List<string>();
    public transient List<string> empregion2= new List<string>();
    public transient List<string> empregion3= new List<string>();
    public void mymethod(){           
        lSkills=[Select ID,Skill_Value__c,Skill_Type__c from Skills2__c  ];        
        Set<String> sSkillsType = New Set<String>();
        Set<String> sSkillsValue = New Set<String>();        
        for(Skills2__c S1:lSkills){
            sSkillsType.add(S1.Skill_Type__c);        
        }          
        lSkillType.addAll(sSkillsType);       
    }    
    public String[] getCountries() {
        return SkillType;
    }        
    public void setCountries(String[] countries) {
        this.SkillType= SkillType;
    }     
    public void skillvalue_selector(){                     
        if(Type=='Area Covered US' || Type=='Areas Covered Canada' ) {
            lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Type__c=:Type];
        } else {
            lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Value__c=:Type];
        }        
        lSkillvalue=New List<String>();       
        Set<String> sSkillsValue= New Set<String>();       
        for(Skills2__c S1:lSkills){        
            if(Type=='Area Covered US' || Type=='Areas Covered Canada' ) {
                sSkillsValue.add(S1.Skill_Value__c);
            } else {
                sSkillsValue.add(S1.Skill_Value_Comments__c);
            }
        }           
        lSkillvalue.addAll(sSkillsValue);
    }    
    public List<SelectOption> getSkillValue1() {          
        skillvalue_selector();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        for(String S: lSkillvalue){
            String s1=String.Valueof(S);
            options.add(new SelectOption(s1,s1));
        }   
        return options;
    } 
    public String[] getSkillValues() {
        return SkillValue;
    }           
    public void setSkillValues(String[] countries) {
        this.SkillValue= SkillValue;
    }       
    public PageReference getSelectedSkills(){    
        if(Type=='Area Covered US' || Type=='Areas Covered Canada') {
           lSelectedSkills=[Select ID,Name,Contact_Name__c,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c where Skill_Value__c=:Value  ];
        } else {
           lSelectedSkills=[Select ID,Name,Contact_Name__c,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c where Skill_Value_Comments__c=:Value  ];
        }        
        if(lSelectedSkills.size()>0) {
           PBT_Flag=true;
           MSGflag=false;
           String URL='/apex/BGAMob_TechSearchRes';
           P=New PageReference (URL);
        }
        else { 
           MSGflag=true;
           P=null;
        }
        return P;       
    }   
    
    public  List<Contact>getEmployregion(){
    empregion = [Select Name,Mobile_App_Role__c,Employee_Region__c from Contact where Mobile_App_Role__c= 'Technical Support Engineer – Avionics' OR Mobile_App_Role__c='Technical Support Engineer' OR Mobile_App_Role__c='Technical Support Engineer – Mechanical' OR Mobile_App_Role__c='Technical Support Engineers (TSEs)'];
           for(Contact c:empregion )
            {
                if(c.Employee_Region__c =='Americas')
                {
                  empregion1.add(c.Name);
                }
                else if(c.Employee_Region__c =='Europe/MiddleEast/Africa/India')
                {
                empregion2.add(c.Name);
                }
                else if(c.Employee_Region__c =='Asia/Pacific Rim')
                {
                 empregion3.add(c.Name);
                }
            }
            return empregion;
        }
   @RemoteAction
    Static public List<string> getFSECountryvalues() {
        List<Skills2__c> skills=new  List<Skills2__c>();
        List<String> skillsnew=new  List<String>();
        set<string>tempstring= new set<string>();
        skills=[SELECT Skill_Value__c FROM Skills2__c WHERE Skill_Value__c !='Georgia' and  Skill_Type__c IN ('Areas Covered Intl A-K','Areas Covered Intl L-Z') order by Skill_Value__c ];
        for(Skills2__c s:skills)
        tempstring.add(s.Skill_Value__c);
        skillsnew.addAll(tempstring);
        skillsnew.sort();
        return skillsnew;    
    } 
    @RemoteAction
    Static public List<string> getStatevalues(String Type) {                              
        if(Type=='Area Covered US' || Type=='Areas Covered Canada'){
            lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Type__c=:Type order by Skill_Value__c ];
        } else {
            lSkills=[Select ID,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c Where Skill_Value__c=:Type order by Skill_Value_Comments__c];
        }       
        lSkillvalue=New List<String>();
        Set<String> sSkillsValue= New Set<String>();
        
        for(Skills2__c S1:lSkills){
            if(Type=='Area Covered US' || Type=='Areas Covered Canada'){
                sSkillsValue.add(S1.Skill_Value__c);
            } else {
                sSkillsValue.add(S1.Skill_Value_Comments__c);
            }
        }   
        lSkillvalue.addAll(sSkillsValue);      
        lSkillvalue.sort();
        return lSkillvalue;   
    }
    @RemoteAction
    Static public List<List<AggregateResult >> getResultValue(String Type,String State) {
        List<List<AggregateResult >>  lSelectedSkillsnew = new List<List<AggregateResult >>();
        List<AggregateResult > lstavionics = new List<AggregateResult >();
        List<AggregateResult > lstmechanical = new List<AggregateResult >();
        List<AggregateResult > lstall = new List<AggregateResult >();
        if(Type=='Area Covered US' || Type=='Areas Covered Canada') {
            if(State != '--None--')
            {
                lstall =[Select Id, contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Type__c=:Type and Skill_Value__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (:Label.BGAMob_MechanicalFSE,:Label.BGAMob_MechanicalTSE,:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE,:Label.BgaMob_ATS,:Label.BgaMob_ATS) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c order by contact__r.BGAMob_Contact_Alt_Name__c];
                lstavionics =[Select Id, contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Type__c=:Type and Skill_Value__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
                lstmechanical =[Select Id, contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Type__c=:Type and Skill_Value__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (: Label.BGAMob_MechanicalFSE ,: Label.BGAMob_MechanicalTSE)group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
            } else {
                lstall =[Select Id,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (:Label.BGAMob_MechanicalFSE,:Label.BGAMob_MechanicalTSE,:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE,:Label.BgaMob_ATS,:Label.BgaMob_ATS) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c order by contact__r.BGAMob_Contact_Alt_Name__c];
                lstavionics =[Select Id,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
                lstmechanical =[Select Id,contact__r.Mobile_App_Role__c,contact__r.Id contactid,Skill_Value_Comments__c,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Type__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (: Label.BGAMob_MechanicalFSE ,: Label.BGAMob_MechanicalTSE) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
            }
        } else {
        
            if(State != '--None--')
            {
                lstall =[Select Id,contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,contact__r.Id contactid,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Value__c=:Type and  Skill_Value_Comments__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (:Label.BGAMob_MechanicalFSE,:Label.BGAMob_MechanicalTSE,:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE,:Label.BgaMob_ATS,:Label.BgaMob_ATS ) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c order by contact__r.BGAMob_Contact_Alt_Name__c];
                lstavionics =[Select Id,contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,contact__r.Id contactid,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Value__c=:Type and  Skill_Value_Comments__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in(:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
                lstmechanical =[Select Id,contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,contact__r.Id contactid,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Value__c=:Type and  Skill_Value_Comments__c=:State and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (: Label.BGAMob_MechanicalFSE ,: Label.BGAMob_MechanicalTSE) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
            }
            else
            {
                lstall =[Select Id,contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,contact__r.Id contactid,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Value__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (:Label.BGAMob_MechanicalFSE,:Label.BGAMob_MechanicalTSE,:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE,:Label.BgaMob_ATS,:Label.BgaMob_ATS ) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c order by contact__r.BGAMob_Contact_Alt_Name__c];
                lstavionics =[Select Id,contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,contact__r.Id contactid,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Value__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in (:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
                lstmechanical =[Select Id,contact__r.Mobile_App_Role__c,Skill_Value_Comments__c,contact__r.Id contactid,contact__r.BGAMob_Contact_Alt_Name__c from Skills2__c where Skill_Value__c=:Type and contact__r.Mobile_Directory_App__c = true and contact__r.Mobile_App_Role__c in(: Label.BGAMob_MechanicalFSE ,: Label.BGAMob_MechanicalTSE) group by contact__r.Mobile_App_Role__c,Id,contact__r.Id,contact__r.BGAMob_Contact_Alt_Name__c,Skill_Value_Comments__c];
            }
        
        }   
        lSelectedSkillsnew.add(lstavionics);
        lSelectedSkillsnew.add(lstmechanical);
        lSelectedSkillsnew.add(lstall);
        system.debug('lstavionics---'+lstavionics.size());
        system.debug('lstmechanical---'+lstmechanical.size());
        system.debug('lstall---'+lstall.size());
        system.debug('lSelectedSkillsnew---'+lSelectedSkillsnew.size());
        return lSelectedSkillsnew; 
    } 
    //Direct Access App V6.0 changes
    @RemoteAction
    Static public List<List<contact >> getEscalateValue(String Type) {
        List<List<contact >>  lSelectedSkillsnew = new List<List<contact >>();
        List<contact > lstavionics = new List<contact >();
        List<contact > lstmechanical = new List<contact >();
        List<contact > lstall = new List<contact >();
        if(Type=='Europe/MiddleEast/Africa/India') 
        {
            string type1='EMEAI';
            lstall =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1 )  and Escalation_Job_Title__c = 'Escalation Level 1'  order by name];
            lstavionics =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1)  and Escalation_Job_Title__c = 'Escalation Level 1'  order by name];
            lstmechanical =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1)  and Escalation_Job_Title__c = 'Escalation Level 1'  order by name];           
        } 
        else if(Type == 'Americas')
        {
            string type1='Americas';
            lstall =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1) and  Escalation_Job_Title__c = 'Escalation Level 1' order by name];
            lstavionics =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1) and  Escalation_Job_Title__c = 'Escalation Level 1'  order by name];
            lstmechanical =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1) and  Escalation_Job_Title__c = 'Escalation Level 1' order by name];           
        }
        else if(Type == 'Asia/Pacific Rim')
        {
            string type1='APAC';
            lstall =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1) and  Escalation_Job_Title__c = 'Escalation Level 1'  order by name];
            lstavionics =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1) and  Escalation_Job_Title__c = 'Escalation Level 1'  order by name];
            lstmechanical =[Select Id,name,Escalation_Job_Title__c ,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Role__c,Mobile_Directory_App__c from contact where (Employee_Region__c=:Type or Employee_Region__c=:Type1) and  Escalation_Job_Title__c = 'Escalation Level 1'  order by name];           
        } 
        lSelectedSkillsnew.add(lstavionics);
        lSelectedSkillsnew.add(lstmechanical);
        lSelectedSkillsnew.add(lstall);
        return lSelectedSkillsnew; 
    }
    //Direct Access App V6.0 Changes end    
    @RemoteAction
    Static public list<Skills2__c>getContact(String strId,String strConId)
    {
        list<Skills2__c> skc= new list<Skills2__c>();
        string test='';
        skc=[select id,name,Contact__r.BGAMob_Contact_Alt_Name__c,Contact__r.Mobile_App_Contact_Number__c,Contact__r.Mobile_App_Contact_Number_Ext__c,Contact__r.Phone_5__c,Contact__r.Email,Contact__r.Mobile_App_Role__c,Skill_Value_Comments__c from Skills2__c where Id=:strId and  Contact__c=:strConId];
       system.debug('@@@'+skc);
        return skc;
        
    }
    
    //Ended for javascript remoting
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
         system.debug('@@@'+skills);
        for(integer i=0;i<skillsSize;i++) {
            integer flag=0;
            system.debug('@@@'+skillsSize);
            for(integer j=0;j<str.size();j++) {
                if(str[j]==skills[i].Skill_Value__c ){
                    flag=1;
                }
            }
            if(flag==0 && skills[i].Skill_Value__c !=null) {
                str.add(skills[i].Skill_Value__c );   
            } 
        }         
        for(integer k=0;k<str.size();k++) {     
            options.add(new SelectOption(str[k],str[k]));
        }
         system.debug('options'+options);
        return options;
        
    }
   
    //Direct Access app V6.0 changes start
    @RemoteAction
    Static public list<Direct_Access_App_Toll_Free_No__c>getatstollfreeno(String name,string country)
    {
        list<Direct_Access_App_Toll_Free_No__c> apptollfreeno= new list<Direct_Access_App_Toll_Free_No__c>();
        string type=name;
        string countryname=country;
        
        if(type == 'ATS')
        {
        countryname='ATS '+country;
        apptollfreeno=[select id,Aero_Name__c,ATS_Name__c,Country__c,GeoLocation__c,New_DID__c,New_Toll_Free__c,VDN__c from Direct_Access_App_Toll_Free_No__c where ATS_Name__c != null and ATS_Name__c =:countryname limit 1];        
        system.debug('venkat1111---->'+apptollfreeno);
        }
        else if(type == 'AERO')
        {
            countryname='Aero '+country;
            apptollfreeno=[select id,Aero_Name__c,ATS_Name__c,Country__c,GeoLocation__c,New_DID__c,New_Toll_Free__c,VDN__c from Direct_Access_App_Toll_Free_No__c where Aero_Name__c != null and Aero_Name__c =:countryname limit 1];        
        }
        return apptollfreeno;
    }
    //Direct Access app V6.0 changes end    
}