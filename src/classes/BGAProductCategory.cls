/*******************************************************************************
Name                  : BGAProductCategory
Created By            : NTTDATA
Project/Incident      : INC000006652469
Created Date          : 22 October 2014
Description           : To Display List of Product Line Category items into Direct Access App. 
Modify date           : 10 October 2015(To display list of TSE names)          
*******************************************************************************/
public without sharing class BGAProductCategory 
{   
    List<Account_Address__c> lSelectedacc= New List<Account_Address__c>();
    public list<Account_Address__c> objAccounts {get;set;}  
    public BGAProductCategory (ApexPages.StandardController controller) {          
    } 
    @RemoteAction 
    public  static List<Skill_DataBase__c> getProduct(string prod) 
    {
        Map<String, BGAMobile_Product_Category_List__c> mechprod= BGAMobile_Product_Category_List__c.getAll();
        List<Skill_DataBase__c> skilldata=[SELECT Id,Master_Skill_Type__c,Mobile_App_Products_Description__c,Product_Ext__c,Mobile_App_Products_Image_Url__c,Name,Skill_Type__c,Skill_Value__c,Value1__c,Value2__c,Value3__c FROM Skill_DataBase__c WHERE Skill_Type__c = 'Mobile App Products'  order by Skill_Value__c ];
        List<Skill_DataBase__c> lfinalprod=new List<Skill_DataBase__c>();
        List<Skill_DataBase__c> temp= new List<Skill_DataBase__c>();
        
        for(Skill_DataBase__c mechsett: skilldata) {                
            if(prod == 'all')
            {
                if(mechsett.skill_value__c!='Mechanical Other' && mechsett.skill_value__c!='Avionics Other')
                    lfinalprod.add(mechsett);  
                else
                     temp.add(mechsett);
            }
            else if(prod == 'Mechanical' && mechsett.Value1__c == 'Mechanical')
            {                          
                 if(mechsett.skill_value__c!='Mechanical Other')
                     lfinalprod.add(mechsett);
                 else
                     temp.add(mechsett);                    
            }
            else if(prod == 'Avionics' && mechsett.Value1__c == 'Avionics')
            {
                 if(mechsett.skill_value__c!='Avionics Other')
                     lfinalprod.add(mechsett);
                 else
                     temp.add(mechsett);    
            }
                       
        }   
        if(temp!=null && temp.size()>0){
            lfinalprod.addAll(temp);            
        }
        return lfinalprod;  
        return null;    
    }
    //Direct Access App V6.0 Changes Start
    @RemoteAction 
    public  static List<List<AggregateResult >> getTSElist(string prod) 
    {
        List<List<AggregateResult >>  lSelectedSkillsnew = new List<List<AggregateResult >>();
        List<AggregateResult > lstavionics = new List<AggregateResult >();
        List<AggregateResult > lstmechanical = new List<AggregateResult >();
        List<AggregateResult > lstall = new List<AggregateResult >();
        system.debug('prod value ----'+prod);
        if(prod == 'all')
        {        
        lstall =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where  Mobile_Directory_App__c = true and ((Mobile_App_Role__c =: Label.BGAMob_MechanicalFSE) or (Mobile_App_Role__c =: Label.BGAMob_MechanicalTSE) or (Mobile_App_Role__c =: Label.BGAMob_ElectricalFSE) or (Mobile_App_Role__c =: Label.BGAMob_AvionicsTSE) or (Mobile_App_Role__c =: Label.BgaMob_ATS) or (Mobile_App_Role__c =: Label.BgaMob_ATS)) group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];
        lstavionics =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where  Mobile_Directory_App__c = true and Mobile_App_Role__c in (:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE) group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];
         lstmechanical =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where Mobile_Directory_App__c = true and Mobile_App_Role__c in (: Label.BGAMob_MechanicalFSE ,: Label.BGAMob_MechanicalTSE)group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];                     
        }
        else if(prod == 'Avionics' )
        {       
        lstall =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where  Mobile_Directory_App__c = true and ((Mobile_App_Role__c =: Label.BGAMob_MechanicalFSE) or (Mobile_App_Role__c =: Label.BGAMob_MechanicalTSE) or (Mobile_App_Role__c =: Label.BGAMob_ElectricalFSE) or (Mobile_App_Role__c =: Label.BGAMob_AvionicsTSE) or (Mobile_App_Role__c =: Label.BgaMob_ATS) or (Mobile_App_Role__c =: Label.BgaMob_ATS)) group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];
        lstavionics =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where  Mobile_Directory_App__c = true and Mobile_App_Role__c in (:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE) group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];
        lstmechanical =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where Mobile_Directory_App__c = true and Mobile_App_Role__c in (: Label.BGAMob_MechanicalFSE ,: Label.BGAMob_MechanicalTSE)group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];                     
        }
        else if(prod == 'Mechanical' )
        {
        lstall =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where  Mobile_Directory_App__c = true and ((Mobile_App_Role__c =: Label.BGAMob_MechanicalFSE) or (Mobile_App_Role__c =: Label.BGAMob_MechanicalTSE) or (Mobile_App_Role__c =: Label.BGAMob_ElectricalFSE) or (Mobile_App_Role__c =: Label.BGAMob_AvionicsTSE) or (Mobile_App_Role__c =: Label.BgaMob_ATS) or (Mobile_App_Role__c =: Label.BgaMob_ATS)) group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];
        lstavionics =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where  Mobile_Directory_App__c = true and Mobile_App_Role__c in (:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE) group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];
        lstmechanical =[Select Id,Mobile_App_Role__c,BGAMob_Contact_Name__c from contact where Mobile_Directory_App__c = true and Mobile_App_Role__c in (: Label.BGAMob_MechanicalFSE ,: Label.BGAMob_MechanicalTSE)group by Mobile_App_Role__c,Id,BGAMob_Contact_Name__c order by BGAMob_Contact_Name__c];                     
        }            
        lSelectedSkillsnew.add(lstavionics);
        lSelectedSkillsnew.add(lstmechanical);
        lSelectedSkillsnew.add(lstall);     
        return lSelectedSkillsnew;    
    }
    @RemoteAction 
    public  static List<Direct_Access_App_Toll_Free_No__c > getTollfreeno(string prod) 
    {
        List<Direct_Access_App_Toll_Free_No__c > lsttollfreeno = new List<Direct_Access_App_Toll_Free_No__c >();
        system.debug('prod value ----'+prod);
        if(prod == 'Techinical')
        {        
        lsttollfreeno =[Select Id,Aero_Name__c,Aero_Country_Name__c,ATS_Country_Name__c,ATS_Name__c,Country__c,New_DID__c,New_Toll_Free__c,VDN__c from Direct_Access_App_Toll_Free_No__c where  ATS_Name__c != null order by ATS_Name__c ];       
        }
        else if(prod == 'Non Techinical' )
        {
        lsttollfreeno =[Select Id,Aero_Name__c,Aero_Country_Name__c,ATS_Country_Name__c,ATS_Name__c,Country__c,New_DID__c,New_Toll_Free__c,VDN__c from Direct_Access_App_Toll_Free_No__c where  Aero_Name__c != null order by Aero_Name__c ];                
        }
        lsttollfreeno.sort();
        return lsttollfreeno;    
    }
    @RemoteAction 
    public  static List<Direct_Access_App_Toll_Free_No__c > getTollfreenodetails(string id,string prod) 
    {
        List<Direct_Access_App_Toll_Free_No__c > lsttollfreeno = new List<Direct_Access_App_Toll_Free_No__c >();
        system.debug('prod value ----'+prod);
        lsttollfreeno =[Select Id,Aero_Name__c,ATS_Name__c,Country__c,New_DID__c,New_Toll_Free__c,VDN__c from Direct_Access_App_Toll_Free_No__c where  id =: id ];      
        return lsttollfreeno;    
    }
    @RemoteAction        
    public  static List<Skills2__c> getcontactlst(string indata) 
    {
        system.debug('indata'+indata);
        List<Skills2__c> conlst=New List<Skills2__c>();
        List<Skills2__c> skilllst=New List<Skills2__c>();
        List<Skill_DataBase__c> skilldata=[SELECT Id,Master_Skill_Type__c,Product_Ext__c,Mobile_App_Contact_Number__c,Mobile_App_Products_Description__c,Mobile_App_Products_Image_Url__c,Name,Skill_Type__c,Skill_Value__c,Value1__c,Value2__c,Value3__c FROM Skill_DataBase__c WHERE id =: indata limit 1];
        string skillname=skilldata[0].Skill_Value__c;
        if(skillname != '')
        {
            // modified on Jan 18 2017 added Contact__r.Mobile_Directory_App__c = true
            
            skilllst=[select id,name,Skill_Value_Comments__c,Contact__c,Skill_Value__c,Contact_Name__c,Contact_Mobile_App_Role__c from Skills2__c where Skill_Value__c=:skillname AND Contact__r.Mobile_Directory_App__c = true];
        }
        for(Skills2__c skilllst1: skilllst) {           
                conlst.add(skilllst1);             
        }  
        return conlst;      
    }
    @RemoteAction
    Static public List<contact> getContactdetails(String strid) {
        list<contact> cont= new list<contact>();
        //List<Skills2__c> skilllst=New List<Skills2__c>();
        Skills2__c skilllst=[select id,name,Skill_Value_Comments__c,Contact__c,Skill_Value__c,Contact_Name__c,Contact_Mobile_App_Role__c from Skills2__c where Contact_Name__c =:strid limit 1];
        set<id> conid=new set<id>();
        conid.add(skilllst.Contact__c);
        system.debug('conid----->'+conid);
        if(conid != null)
        {
        cont=[select id,name,Mobile_App_Role__c,Employee_Region__c,Mobile_App_Contact_Number__c,Phone_1__c,Phone_1_Ext__c,Mobile_App_Contact_Number_Ext__c,Phone_5__c,Email from contact where id=:conid limit 1];        
        }
        return cont;
    }
    @RemoteAction
    Static public List<contact> getEscalationContact() {
        list<contact> cont= new list<contact>();
        cont=[select id,name,Mobile_App_Role__c,Employee_Region__c,Mobile_App_Contact_Number__c,Phone_1__c,Phone_1_Ext__c,Mobile_App_Contact_Number_Ext__c,Phone_5__c,Email from contact where Escalation_Job_Title__c =:'Escalation Level 3' ];
        return cont;
    }   
    //Direct Acccess app V6.0 Changes end
    @RemoteAction
    Static public List<contact> getContact(String strid) {
        list<contact> cont= new list<contact>();
        cont=[select id,name,Mobile_App_Role__c,Direct_Access_App_Escalation_Role__c,Employee_Region__c,Mobile_App_Contact_Number__c,Phone_1__c,Phone_1_Ext__c,Mobile_App_Contact_Number_Ext__c,Phone_5__c,Email from contact where Id=:strId ];
        return cont;
    }
    @RemoteAction
    Static public list<contact>getContact1(String strConId1,String strConId)
    {
        list<contact> con= new list<contact>();
        string test='';
        con=[select id,name,BGAMob_Contact_Alt_Name__c,BGAMob_Contact_Name__c,Mobile_App_Contact_Number__c,Mobile_App_Contact_Number_Ext__c,Phone_5__c,Email,Mobile_App_Role__c from contact where Id=:strConId];
        return con;
    }
    @RemoteAction
    Static public List<contact> getContactlist1(String skillvalue,String Type) {
        List<contact> lstall1=[select id,name,Mobile_App_Role__c,Mobile_App_Contact_Number__c,Mobile_App_Contact_Number_Ext__c,Phone_1__c,Phone_1_Ext__c,BGAMob_Contact_Alt_Name__c from contact where id IN (Select Contact__c from Skills2__c where Skill_Value__c=:skillvalue  and contact__r.Mobile_App_Role__c in (:Label.BGAMob_MechanicalFSE,:Label.BGAMob_MechanicalTSE,:Label.BGAMob_ElectricalFSE,:Label.BGAMob_AvionicsTSE,:Label.BgaMob_ATS,:Label.BgaMob_ATS))];
        List<contact> lstall=new List<contact>();
        system.debug('skill type--->'+Type);
        system.debug('skill type--->'+lstall1);
        if(lstall1.size()>0)
        {
            for(contact con: lstall1) {
                if(Type=='all') {
                    lstall.add(con);  
                }
                else if(Type=='Mechanical')
                {
                    system.debug('inside mechanical');
                    if(con.Mobile_App_Role__c == Label.BGAMob_MechanicalTSE) 
                    lstall.add(con);  
                }
                else if(Type=='Avionics')
                {
                    system.debug('inside mechanical');
                    if(con.Mobile_App_Role__c == Label.BGAMob_AvionicsTSE) 
                    lstall.add(con);  
                }
            }
        }
        lstall.sort();
        return lstall ;
        //return null;
    }   
    @RemoteAction        
    public  static List<Skill_DataBase__c> getProductdeatils(string indata) 
    {
        system.debug('indata'+indata);
        List<Skill_DataBase__c> lfinalprod1=New List<Skill_DataBase__c>();
        List<Skill_DataBase__c> skilldata=[SELECT Id,Master_Skill_Type__c,Product_Ext__c,Mobile_App_Contact_Number__c,Mobile_App_Products_Description__c,Mobile_App_Products_Image_Url__c,Name,Skill_Type__c,Skill_Value__c,Value1__c,Value2__c,Value3__c FROM Skill_DataBase__c WHERE id =: indata];
        for(Skill_DataBase__c mechsett: skilldata) {
            system.debug('indata'+indata);
            if(mechsett.id == indata) 
            {           
                system.debug('mechsett'+mechsett);
                lfinalprod1.add(mechsett);
            }               
        }  
        return lfinalprod1;      
    } 
     @RemoteAction        
    public  static List<contact> getcontactlist(string indata) 
    {
        List<contact> lstcontact=New List<contact>();
        String contactlst;
        List<String> conlist=new List<String>(); 
        Map<String, BGAMobile_Product_Category_List__c> mechprod= BGAMobile_Product_Category_List__c.getAll();
        for(BGAMobile_Product_Category_List__c mechsett: mechprod.values()) {
            system.debug('indata'+indata);
            if(mechsett.Contacts__c == indata) 
            {           
                system.debug('mechsett'+mechsett);
                contactlst=mechsett.Contacts__c;
                conlist=contactlst.split(',');               
            }               
        }
        if(conlist != null)
        {
             lstcontact=[select id,name,email from contact where id IN:conlist ];
        }  
        return lstcontact;      
    }                  
    public String phoneGapUrl {
        get {
            String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
            if (userAgent.contains('android'))
                return 'CordovaAndroid.js';
            else
                return 'CordovaIOS.js';
        }
    }   
}