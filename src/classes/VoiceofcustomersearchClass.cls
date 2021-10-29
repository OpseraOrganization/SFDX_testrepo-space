public with sharing class VoiceofcustomersearchClass
{
    public String Keywords{get;set;}
    public list<attachment> attach{get;set;}
    public string temp{get;set;}
    public boolean showaccount{get;set;}
    public Date StartDate{get;set;}
    public boolean daterange{get;set;}
    public string creatorname{get;set;}
    public string ownername{get;set;}
    public boolean showresult{get;set;}
    public Date EndDate{get;set;}
    public List<Voice_of_Customer__c> objCuslist  {get;set;}
    public List<Voice_of_Customer__c> objCuslist1  {get;set;}
    public boolean showdetail{get;set;}
    public Voice_of_Customer__c ExceptionRecord{get;set;}
    
    public VoiceofcustomersearchClass(ApexPages.StandardController controller)
    {
        if(ExceptionRecord==null)
            ExceptionRecord=new Voice_of_Customer__c();
            system.debug('keyword#################'+Keywords);
            //ExceptionRecord= (Voice_of_Customer__c)controller.getRecord();
    }
    public String Var01 { get; set; }
    public VoiceofcustomersearchClass() 
    {
       searchform();
    }    
    public pagereference clearform()
    {
    String hostname = ApexPages.currentPage().getHeaders().get('Host');
        String domain = 'https://' + hostname + '/apex/VOCSearchPage';
       
        pagereference pag= new pagereference(domain);
        pag.setRedirect(true);
        return pag;
    } 
    public void detailpage()
    {
        temp=apexpages.currentpage().getparameters().get('vocid');
        system.debug('tttttttttttttttttttttttttttttttttttt'+temp);
        showdetail=true;
        ExceptionRecord= [select Title__c,Honeywell__c,RecordtypeId,name,Date_of_VOC__c,Source__c,VOC_Type__c,StartDateval__c,VOC_Account__r.Name,SBU__c,OEM__c,Product_Name__c,Key_Action_Items__c,
                          OwnerId,createdbyid,Owner_Name__c ,Created_By_Name__c,Action_Tracking__c,Disposition__c,Platform__r.Name,Product_Family__c,Competitor__c,Sensitive__c,
                          Enddate__c,Other_Hoenywell_Attendees__c,Key_Takeaways1__c from Voice_of_Customer__c where id =:temp];
           /**if(ExceptionRecord.CreatedById!=null){
            user u=[select name from user where id=:ExceptionRecord.CreatedById];
             if(u.name!=null)
               creatorname=u.name;
               }**/
            /** system.debug('ExceptionRecord.ownerid$$$$$$$$$$$$$$$$$$'+ExceptionRecord.ownerid);
            if(ExceptionRecord.ownerid!=null){
            list<user>u1=new list<user>();
            u1=[select name from user where id=:ExceptionRecord.ownerid];
            if(u1.size()>0)
                ownername=u1[0].name;
            else{
            Group g1=[select name  from Group where id=:ExceptionRecord.ownerid and type='Queue'];
             if(g1.name!=null)
               ownername=g1.name;
             }}**/
        attach=new list<attachment>();
        attach=[select id,parentid,Name from attachment where parentid=:temp];  
    }
    public pagereference redirect()
    {
        if(showdetail==true){
          showdetail=false;
          return null;}
       else if(showresult==true){
          showresult=false;
          return null;}
        return page.vocstartpage;
    } 
    public pagereference searchform()
    {
        system.debug('test methode');
        String strQuery = '';
        
       // String DateStr ;
        //String EndDate ;
        if (ExceptionRecord.StartDateval__c!= null && ExceptionRecord.EndDate__c!= null && ExceptionRecord.EndDate__c<ExceptionRecord.StartDateval__c){
            system.debug('WWWWWWWWWWWWWWWWWW'+ExceptionRecord.StartDateval__c);
            system.debug('xxxxxxxxxxxxxxxxxx'+ExceptionRecord.EndDate__c );
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Correct The Date Range'));
            daterange=true;
        }
        List<string> resultstring=new List<string>();
        DateTime stdt = ExceptionRecord.StartDateval__c;
        DateTime eddt =ExceptionRecord.EndDate__c;
       
        TimeZone tz1 = UserInfo.getTimeZone();
        string tz=string.valueof(tz1);
        string ed= String.valueOf(ExceptionRecord.EndDate__c);
         string sd= String.valueOf(ExceptionRecord.StartDateval__c);
        system.debug('test time zone'+temp);
        /*StartDate=date.newinstance(stdt.year(),stdt.month(),stdt.day()); 
        EndDate=date.newinstance(eddt.year(), eddt.month(), eddt.day());
        system.debug('yyyyyyyyyyyyyyyyyyyyyy'+stdt.day());
        system.debug('sssssssssssssssssssss'+stdt.month());
        String x=StartDate.format();
         string sd,ed;
        if(stdt.month()>9 && stdt.day()>9)
          sd= stdt.year()+'-'+stdt.month()+'-'+stdt.day();
        else if(stdt.month()>9 && stdt.day()<9)
         sd= stdt.year()+'-'+stdt.month()+'-0'+stdt.day();
        else if(stdt.month()<9 && stdt.day()>9)
         sd= stdt.year()+'-0'+stdt.month()+'-'+stdt.day();
        else if(stdt.month()<9 && stdt.day()<9)
         sd= stdt.year()+'-0'+stdt.month()+'-o'+stdt.day();
      
      if(eddt.month()>9 && eddt.day()>9)
        ed= eddt.year()+'-'+eddt.month()+'-'+eddt.day();
        else if(eddt.month()>9 && eddt.day()<9)
         ed= eddt.year()+'-'+eddt.month()+'-0'+eddt.day();
        else if(eddt.month()<9 && eddt.day()>9)
         ed= eddt.year()+'-0'+eddt.month()+'-'+eddt.day();
        else if(eddt.month()<9 && eddt.day()<9)
         ed= eddt.year()+'-0'+eddt.month()+'-o'+eddt.day();**/
       
       // string ed= eddt.year()+'-'+eddt.month()+'-'+eddt.day();
        /*system.debug('xxxxxxxxxxxxxxxxx'+x);
        string y=EndDate.format();
        string x1=x.substring(x.length()-4,x.length());
        string x2=x.substring(0,2);*/
       // string x1=x.replace('/','-');
        //string y1=y.replace('/','-');
        system.debug('StartDate*************'+sd); 
        system.debug('EndDate**************'+ed);    
      /* if(stdt != null /**&& (tz=='America/Phoenix' || tz=='America/Los_Angeles')**)
        {
            DateTime stdt1=stdt; 
            system.debug('startdate'+stdt1);
            DateStr = stdt1 .format('yyyy-MM-dd');                                 
        }
        
        if(eddt != null /**&& tz=='America/Phoenix'**)
        {            
            DateTime stdt2=eddt;            
            system.debug('enddate'+stdt2);
            EndDate = stdt2.format('yyyy-MM-dd');                     
        }
        
        if(stdt != null && eddt != null/** && tz=='America/Phoenix'**)
        {
              DateTime stdt1=stdt; 
               DateTime stdt2=eddt;             
            //system.debug('enddate'+stdt2);
            DateStr = stdt1.format('yyyy-MM-dd');                                 
            EndDate = stdt2.format('yyyy-MM-dd'); 
            system.debug('datestr'+DateStr);            
            system.debug('EndDate'+EndDate);            
        }**/
        
       /** if (stdt != null && tz!='America/Phoenix')
        DateStr = stdt .format('yyyy-MM-dd'); 
        
        if (eddt != null && tz!='America/Phoenix')
        EndDate = eddt .format('yyyy-MM-dd'); 
        System.debug( 'DateStr-------->'+DateStr); **/
        
        String strCondition = '';
       // strCondition +='Sensitive__c=false';
        if (ExceptionRecord.StartDateval__c!= null && ExceptionRecord.EndDate__c== null)
        strCondition += 'Date_of_VOC__c >='+ sd;
        
        if (ExceptionRecord.StartDateval__c== null && ExceptionRecord.EndDate__c!= null)
       strCondition += 'Date_of_VOC__c <='+ ed;
         
        if (ExceptionRecord.StartDateval__c!= null && ExceptionRecord.EndDate__c!= null)
       strCondition += '(Date_of_VOC__c >='+sd+ ' and ' + 'Date_of_VOC__c <='+ed+ ')';
       

        if (ExceptionRecord.VOC_Type__c != null && strCondition == '')
        strCondition += 'VOC_Type__c =\''+ ExceptionRecord.VOC_Type__c+ '\'';
        else if (ExceptionRecord.VOC_Type__c != null && strCondition != '')
        strCondition += ' and  VOC_Type__c = \''+ ExceptionRecord.VOC_Type__c + '\'';

        if (ExceptionRecord.Source__c != null && strCondition == '')
        strCondition += 'Source__c =\''+ ExceptionRecord.Source__c+ '\'';
        else if (ExceptionRecord.Source__c != null && strCondition != '')
        strCondition += ' and  Source__c =\''+ ExceptionRecord.Source__c+ '\'';

        if (ExceptionRecord.Honeywell__c != null && strCondition == '')
        {
        strCondition += 'createdById  =\''+ ExceptionRecord.Honeywell__c+ '\'';
        system.debug('check honeywell lead'+strCondition);
        }
        else if (ExceptionRecord.Honeywell__c != null && strCondition != '')
        {
        strCondition += ' and  createdById   =\''+ ExceptionRecord.Honeywell__c+ '\'';
        system.debug('check honeywell lead'+strCondition);
        }

        //checking account 
        if (ExceptionRecord.VOC_Account__c != null && strCondition == '')
        strCondition += 'VOC_Account__c=\''+ ExceptionRecord.VOC_Account__c+ '\'';
        else if (ExceptionRecord.VOC_Account__c!= null && strCondition != '')
        strCondition += ' and  VOC_Account__c=\''+ ExceptionRecord.VOC_Account__c+ '\'';


        if (ExceptionRecord.SBU__c!= null && strCondition == '')
        strCondition += 'SBU__c=\''+ ExceptionRecord.SBU__c+ '\'';
        else if (ExceptionRecord.SBU__c!= null && strCondition != '')
        strCondition += ' and SBU__c=\''+ ExceptionRecord.SBU__c+ '\'';

     /**   if(ExceptionRecord.OEM__c!= null && strCondition == '')
        {
            system.debug('test oem result'+ExceptionRecord.OEM__c);
            String strProd1 = ExceptionRecord.OEM__c;
            strProd1  = strProd1.replace('[','');
            strProd1  = strProd1.replace(']','');
            strProd1  = strProd1.replace(',','\',\'');
            system.debug('test result of OEM'+strProd1  );
            strCondition += strProd1; 
        }**/
        
        if (ExceptionRecord.OEM__c!= null && strCondition == '')
        {
            system.debug('test oem result'+ExceptionRecord.OEM__c);
            String strProd1 = ExceptionRecord.OEM__c;
            strProd1  = strProd1.replace('[','');
            strProd1  = strProd1.replace(']','');
            strProd1  = strProd1.replace(',','\',\'');
            system.debug('test result of OEM'+strProd1  );
            if(strProd1.trim() != null && strProd1.trim() != '')
            strCondition += 'OEM__c in (\''+ strProd1+ '\')';
        }
        else if (ExceptionRecord.OEM__c!= null && strCondition != '')
        {
            system.debug('test oem result'+ExceptionRecord.OEM__c);
            String strProd1 = ExceptionRecord.OEM__c;
            strProd1  = strProd1.replace('[','');
            strProd1  = strProd1.replace(']','');
            strProd1  = strProd1.replace(',','\',\'');
            system.debug('test result of OEM'+strProd1  );
            if(strProd1.trim() != null && strProd1.trim() != '')
            strCondition += ' and OEM__c in (\''+ strProd1+ '\')';
        }

        if(ExceptionRecord.Product_Family__c!= null && strCondition == '')
        {
            system.debug('test result'+ExceptionRecord.Product_Family__c);
            String strProd = ExceptionRecord.Product_Family__c;
            strProd  = strProd.replace('[','');
            strProd  = strProd.replace(']','');
            strProd  = strProd.replace(',','\',\'');
            system.debug('test result strProd'+strProd);
            if(strProd.trim() != null && strProd.trim() != '')
            strCondition += ' Product_Family__c in (\''+ strProd + '\')';
        }
        else if (ExceptionRecord.Product_Family__c!= null && strCondition != '')
        {
            system.debug('test result'+ExceptionRecord.Product_Family__c);
            String strProd = ExceptionRecord.Product_Family__c;
            strProd  = strProd.replace('[','');
            strProd  = strProd.replace(']','');
            strProd  = strProd.replace(',','\',\'');
            system.debug('test result strProd'+strProd);
            if(strProd.trim() != null && strProd.trim() != '')
            strCondition += ' and Product_Family__c in (\''+ strProd + '\')';
        }
      
        if (ExceptionRecord.Platform__c!= null && strCondition == '')
        strCondition += 'Platform__c=\''+ ExceptionRecord.Platform__c+ '\'';
        else if (ExceptionRecord.Platform__c!= null && strCondition != '')
        strCondition += ' and  Platform__c=\''+ ExceptionRecord.Platform__c+ '\'';

        /*if (ExceptionRecord.Product_Family__c!= null && strCondition == '')
        strCondition += 'Product_Family__c=\''+ ExceptionRecord.Product_Family__c+ '\'';
        else if (ExceptionRecord.Product_Family__c!= null && strCondition != '')
        strCondition += ' and  Product_Family__c=\''+ ExceptionRecord.Product_Family__c+ '\'';
        */

       /* if (ExceptionRecord.Competitor__c!= null && strCondition == '')
        strCondition += 'Competitor__c='+ ExceptionRecord.Competitor__c;
        else if (ExceptionRecord.Competitor__c!= null && strCondition != '')
        strCondition += ' and  Competitor__c='+ ExceptionRecord.Competitor__c;*/

        if (ExceptionRecord.Other_Hoenywell_Attendees__c!= null && strCondition == '')
        strCondition += 'Other_Hoenywell_Attendees__c=\''+ ExceptionRecord.Other_Hoenywell_Attendees__c+ '\'';
        else if (ExceptionRecord.Other_Hoenywell_Attendees__c!= null && strCondition != '')
        strCondition += ' and Other_Hoenywell_Attendees__c=\''+ ExceptionRecord.Other_Hoenywell_Attendees__c+ '\'';

        System.debug('Strcondition----------'+strCondition );
        
        if(strCondition != '')
        strQuery = 'SELECT Id,Title__c,Date_of_VOC__c,name,Key_Takeaways1__c,Created_By_Name__c,Key_Action_Items__c,createdByID,Owner.name from Voice_of_Customer__c where '+strCondition+' and Sensitive__c=false ORDER BY Date_of_VOC__c DESC,Name DESC limit 500 ';
        else
        strQuery  = 'SELECT Id,Title__c,Date_of_VOC__c,name,Key_Takeaways1__c,Created_By_Name__c,Key_Action_Items__c,createdByID,Owner.name from Voice_of_Customer__c where Sensitive__c=false ORDER BY Date_of_VOC__c DESC,Name DESC limit 500 ';

        System.debug('strQuery ------------->'+strQuery );
        objCuslist  = new List<Voice_of_Customer__c>();
        objCuslist  =  Database.Query(strQuery);
        system.debug('test objCuslist'+objCuslist);
        objCuslist1   = new List<Voice_of_Customer__c>();
        Voice_of_Customer__c objVOC ;
        
        //System.debug( 'Keywords-------->'+Keywords);
        //System.debug( 'Keywords-------->'+Keywords.indexOf('and')); 
        //System.debug( 'Keywords-------->'+Keywords.indexOf('or')); 
        //System.debug( 'Keywords-------->'+Keywords.indexOf('not')); 
        List<String> arlKeywordsand = new List<String>();
        List<String> arlKeywordsor  = new List<String>();
        List<String> arlKeywordsnot = new List<String>();

        String strKeywd = '';
    //if(Keywords!=''){
        //Integer intOrIndx = Keywords.indexOf('or');
        //Integer intAndIndx = Keywords.indexOf('and');
        //Integer intNotIndx = Keywords.indexOf('not');

        for(Integer inCnt = 0;inCnt < objCuslist.Size(); inCnt ++ )
        {
            objVOC = objCuslist[inCnt];
            system.debug('objVOC.Created_By_Name__c**********'+objVOC.Created_By_Name__c);
            if((null != objVOC.Key_Takeaways1__c &&  objVOC.Key_Takeaways1__c.toLowercase().contains(Keywords.toLowercase())) || (null != objVOC.Title__c &&  objVOC.Title__c.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.Name!=null && objVOC.name.toLowercase().contains(Keywords.toLowercase())) || (objVOC.Key_Action_Items__c!=null && objVOC.Key_Action_Items__c.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.Created_By_Name__c!=null && objVOC.Created_By_Name__c.toLowercase().contains(Keywords.toLowercase())))
            {
                objCuslist1.add(objVOC);
            }
        }
        System.debug( 'objCuslist1-------->'+objCuslist1.size()); 
 
        objCuslist = objCuslist1;
        if(objCuslist.size()>0)
            showresult=true;
            //pagereference pag= new pagereference('/apex/vocsearchresultpage?keytakeway='+Keywords+'sd='+ExceptionRecord.StartDateval__c);
            //pag.setRedirect(true);
            //return pag;
        return null;
    }
  
    public List<SelectOption> getproductfamily()
    {
        List<SelectOption> options = new List<SelectOption>();            
        Schema.DescribeFieldResult fieldResult =
        Voice_of_Customer__c.Product_Family__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    /** public List<SelectOption> getoem()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
       Voice_of_Customer__c.oem__c.getDescribe();//done for field change
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    } **/
     
    public void checkforaccount()
    {
        system.debug('ccccccccccccccccccccccccccccc'+ExceptionRecord.Source__c);      
        if(ExceptionRecord.Source__c=='Customer')
            showaccount=true;
        else
            showaccount=false;
            system.debug('ExceptionRecord.Source__c*********'+showaccount);
    }  
}