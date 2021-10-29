public with sharing class VOCSearchDesktop {
    public String Keywords{get;set;}
    public boolean showresult{get;set;}
    public Voice_of_Customer__c SearchRecord{get;set;}
    public List<Voice_of_Customer__c> objCuslist  {get;set;}
    public List<Voice_of_Customer__c> objCuslist1  {get;set;}
    
    public VOCSearchDesktop(ApexPages.StandardController controller) 
    {
        if(SearchRecord==null)
            SearchRecord=new Voice_of_Customer__c();
    }
    
    public List<SelectOption> getoem()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =  Voice_of_Customer__c.OEM__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       options.add(new selectoption('','--None--')) ;     
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    
    
   public pagereference searchform()
    {
        system.debug('test methode');
        String strQuery = '';
        
       
        
        List<string> resultstring=new List<string>();
        DateTime stdt = SearchRecord.StartDateval__c;
        DateTime eddt =SearchRecord.EndDate__c;
        system.debug('WWWWWWWWWWWWWWWWWW'+SearchRecord.StartDateval__c);
        system.debug('xxxxxxxxxxxxxxxxxx'+SearchRecord.EndDate__c );
        TimeZone tz1 = UserInfo.getTimeZone();
        string tz=string.valueof(tz1);
        string ed= String.valueOf(SearchRecord.EndDate__c);
        string sd= String.valueOf(SearchRecord.StartDateval__c);
       
        
        system.debug('StartDate*************'+sd); 
        system.debug('EndDate**************'+ed);    
      
        
        String strCondition = '';
        if (SearchRecord.Sensitive__c!= true)
        strCondition +='(Sensitive__c=false or Sensitive__c=true)';
        if (SearchRecord.Sensitive__c== true)
        strCondition +='(Sensitive__c=true)';
        if (SearchRecord.Competitor__c!= true)
        strCondition +=' and (Competitor__c=false or Competitor__c=true)';
        if (SearchRecord.Competitor__c== true)
        strCondition +=' and (Competitor__c=true)';
        if (SearchRecord.StartDateval__c!= null && SearchRecord.EndDate__c== null)
        strCondition += ' and  Date_of_VOC__c >='+ sd;
        
        if (SearchRecord.StartDateval__c== null && SearchRecord.EndDate__c!= null)
       strCondition += ' and  Date_of_VOC__c <='+ ed;
         
        if (SearchRecord.StartDateval__c!= null && SearchRecord.EndDate__c!= null)
       strCondition += ' and  (Date_of_VOC__c >='+sd+ ' and ' + 'Date_of_VOC__c <='+ed+ ')';
       
       if (SearchRecord.Disposition__c != null && strCondition == '')
        strCondition += 'Disposition__c =\''+ SearchRecord.Disposition__c+ '\'';
        else if (SearchRecord.Disposition__c != null && strCondition != '')
        strCondition += ' and  Disposition__c = \''+ SearchRecord.Disposition__c + '\'';

        if (SearchRecord.VOC_Type__c != null && strCondition == '')
        strCondition += 'VOC_Type__c =\''+ SearchRecord.VOC_Type__c+ '\'';
        else if (SearchRecord.VOC_Type__c != null && strCondition != '')
        strCondition += ' and  VOC_Type__c = \''+ SearchRecord.VOC_Type__c + '\'';

        if (SearchRecord.Source__c != null && strCondition == '')
        strCondition += 'Source__c =\''+ SearchRecord.Source__c+ '\'';
        else if (SearchRecord.Source__c != null && strCondition != '')
        strCondition += ' and  Source__c =\''+ SearchRecord.Source__c+ '\'';

        if (SearchRecord.Honeywell__c != null && strCondition == '')
        {
        strCondition += 'createdById  =\''+ SearchRecord.Honeywell__c+ '\'';
        system.debug('check honeywell lead'+strCondition);
        }
        else if (SearchRecord.Honeywell__c != null && strCondition != '')
        {
        strCondition += ' and  createdById   =\''+ SearchRecord.Honeywell__c+ '\'';
        system.debug('check honeywell lead'+strCondition);
        }

        //checking account 
        if (SearchRecord.VOC_Account__c != null && strCondition == '')
        strCondition += 'VOC_Account__c=\''+ SearchRecord.VOC_Account__c+ '\'';
        else if (SearchRecord.VOC_Account__c!= null && strCondition != '')
        strCondition += ' and  VOC_Account__c=\''+ SearchRecord.VOC_Account__c+ '\'';


        if (SearchRecord.SBU__c!= null && strCondition == '')
        strCondition += 'SBU__c=\''+ SearchRecord.SBU__c+ '\'';
        else if (SearchRecord.SBU__c!= null && strCondition != '')
        strCondition += ' and SBU__c=\''+ SearchRecord.SBU__c+ '\'';

      /**  if(SearchRecord.OEM__c!= null && strCondition == '')
        {
            system.debug('test oem result'+SearchRecord.OEM__c);
            String strProd1 = SearchRecord.OEM__c;
            strProd1  = strProd1.replace('[','');
            strProd1  = strProd1.replace(']','');
            strProd1  = strProd1.replace(',','\',\'');
            system.debug('test result of OEM'+strProd1  );
            strCondition += strProd1; 
        }**/
        
        if (SearchRecord.OEM__c!= null && strCondition == '')
        {
            system.debug('test oem result'+SearchRecord.OEM__c);
            String strProd1 = SearchRecord.OEM__c;
            strProd1  = strProd1.replace('[','');
            strProd1  = strProd1.replace(']','');
            strProd1  = strProd1.replace(',','\',\'');
            system.debug('test result of OEM'+strProd1  );
            if(strProd1.trim() != null && strProd1.trim() != '')
            strCondition += 'OEM__c in (\''+ strProd1+ '\')';
        }
        else if (SearchRecord.OEM__c!= null && strCondition != '')
        {
            system.debug('test oem result'+SearchRecord.OEM__c);
            String strProd1 = SearchRecord.OEM__c;
            strProd1  = strProd1.replace('[','');
            strProd1  = strProd1.replace(']','');
            strProd1  = strProd1.replace(',','\',\'');
            system.debug('test result of OEM'+strProd1  );
            if(strProd1.trim() != null && strProd1.trim() != '')
            strCondition += ' and OEM__c in (\''+ strProd1+ '\')';
        }

        if(SearchRecord.Product_Family__c!= null && strCondition == '')
        {
            system.debug('test result'+SearchRecord.Product_Family__c);
            String strProd = SearchRecord.Product_Family__c;
            strProd  = strProd.replace('[','');
            strProd  = strProd.replace(']','');
            strProd  = strProd.replace(',','\',\'');
            system.debug('test result strProd'+strProd);
            if(strProd.trim() != null && strProd.trim() != '')
            strCondition += ' Product_Family__c in (\''+ strProd + '\')';
        }
        else if (SearchRecord.Product_Family__c!= null && strCondition != '')
        {
            system.debug('test result'+SearchRecord.Product_Family__c);
            String strProd = SearchRecord.Product_Family__c;
            strProd  = strProd.replace('[','');
            strProd  = strProd.replace(']','');
            strProd  = strProd.replace(',','\',\'');
            system.debug('test result strProd'+strProd);
            if(strProd.trim() != null && strProd.trim() != '')
            strCondition += ' and Product_Family__c in (\''+ strProd + '\')';
        }
      
        if (SearchRecord.Platform__c!= null && strCondition == '')
        strCondition += 'Platform__c=\''+ SearchRecord.Platform__c+ '\'';
        else if (SearchRecord.Platform__c!= null && strCondition != '')
        strCondition += ' and  Platform__c=\''+ SearchRecord.Platform__c+ '\'';

       

        /*if (SearchRecord.Competitor__c!= null && strCondition == '')
        strCondition += 'Competitor__c='+ SearchRecord.Competitor__c;
        else if (SearchRecord.Competitor__c!= null && strCondition != '')
        strCondition += ' and  Competitor__c='+ SearchRecord.Competitor__c;*/

        if (SearchRecord.Other_Hoenywell_Attendees__c!= null && strCondition == '')
        strCondition += 'Other_Hoenywell_Attendees__c=\''+ SearchRecord.Other_Hoenywell_Attendees__c+ '\'';
        else if (SearchRecord.Other_Hoenywell_Attendees__c!= null && strCondition != '')
        strCondition += ' and Other_Hoenywell_Attendees__c=\''+ SearchRecord.Other_Hoenywell_Attendees__c+ '\'';

        System.debug('Strcondition----------'+strCondition );
        
        if(strCondition != Null)
        strQuery = 'SELECT Id,Title__c,Date_of_VOC__c,Product_Family__c,Platform__r.name,SBU__c,oem__c,VOC_Account__c,Voc_link__C ,name,Key_Takeaways1__c,VOC_Account__r.name,Key_Action_Items__c,Created_By_Name__c,createdByID,Owner.name from Voice_of_Customer__c where '+strCondition+' ORDER BY Date_of_VOC__c DESC, name DESC limit 500 ';
        else
        strQuery  = 'SELECT Id,Title__c,Date_of_VOC__c,name,Product_Family__c,Platform__r.name,SBU__c,oem__c,Voc_link__C ,VOC_Account__c,Key_Takeaways1__c,VOC_Account__r.name,Key_Action_Items__c,Created_By_Name__c,createdByID,Owner.name from Voice_of_Customer__c ORDER BY Date_of_VOC__c DESC, name DESC limit 500 ';

        System.debug('strQuery ------------->'+strQuery );
        objCuslist  = new List<Voice_of_Customer__c>();
        objCuslist  =  Database.Query(strQuery);
        system.debug('test objCuslist'+objCuslist);
        objCuslist1   = new List<Voice_of_Customer__c>();
        Voice_of_Customer__c objVOC ;
       /* System.debug( 'Keywords-------->'+Keywords);
        System.debug( 'Keywords-------->'+Keywords.indexOf('and')); 
        System.debug( 'Keywords-------->'+Keywords.indexOf('or')); 
        System.debug( 'Keywords-------->'+Keywords.indexOf('not')); **/
        List<String> arlKeywordsand = new List<String>();
        List<String> arlKeywordsor  = new List<String>();
        List<String> arlKeywordsnot = new List<String>();

        String strKeywd = '';
        //added this to check and or condition
         /** list<string>temp=new list<string>();
          string orstring='';
          string andstring='';
          temp=Keywords.split(' ', -2);
          
          for(string s:temp)
          {
            if(orstring!='')
              orstring=orstring+' or '+s;
            else
               orstring=s;
            if(andstring!='')
              andstring=andstring+' and '+s;
            else
               andstring=s;
              
          }
         if(orstring!='' && andstring!='')
         keywords='('+orstring+') or ('+andstring+')';
         system.debug('keywords***********'+keywords);**/
        for(Integer inCnt = 0;inCnt < objCuslist.Size(); inCnt ++ )
        {
            objVOC = objCuslist[inCnt];
            if((null != objVOC.Key_Takeaways1__c &&  objVOC.Key_Takeaways1__c.toLowercase().contains(Keywords.toLowercase())) 
                || (null != objVOC.Title__c &&  objVOC.Title__c.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.Name!=null && objVOC.name.toLowercase().contains(Keywords.toLowercase())) 
                || (objVOC.Key_Action_Items__c!=null && objVOC.Key_Action_Items__c.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.Created_By_Name__c!=null && objVOC.Created_By_Name__c.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.VOC_Account__c!=null && objVOC.VOC_Account__r.name.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.Platform__c!=null && objVOC.Platform__r.name.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.Product_Family__c!=null && objVOC.Product_Family__c.toLowercase().contains(Keywords.toLowercase()))
                || (objVOC.oem__c!=null && objVOC.oem__c.toLowercase().contains(Keywords.toLowercase())))
            {
                objCuslist1.add(objVOC);
            }
        }
        System.debug( 'objCuslist1-------->'+objCuslist1.size()); 
 
        objCuslist = objCuslist1;
        if(objCuslist.size()>0)
            showresult=true;
           
        return null;
    }
   public pageReference DetailPage()
   {
     String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm();
     PageReference pageRef = new PageReference(fullRecordURL+'/'+apexpages.currentpage().getparameters().get('vocid'));
     return pageRef;
   }

}