/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : CSWISearch_Test 
* Description           : Customer Specific Work Instruction Community  
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* OCT-27-2014      1.1            NTTData               SR# INC000006645221- Code coverage to include the Instruction fields and SFDC Contract ID
***********************************************************************************************************/
@isTest(seealldata=true)
private class CSWISearch_Test {

    static testMethod void CSWISearchTest1() 
    {
    
        test.starttest();
        
        id userid = [select id from user limit 1].id;
        id accountid = [select id from Account limit 1].id;
        Customer_Specific_Work_Instruction__c cswirec= new Customer_Specific_Work_Instruction__c();
        cswirec.Contract_ID__c= 'Test';
        cswirec.Account__c=accountid;
        cswirec.Customer_Code__c ='test111';
        //contract cont=new contract(name='test',Accountid=accountid);
        //insert cont;
        //cswirec.Contractt_id__c='800c00000006Ss2';
        insert cswirec;
     
     //id cont = [select id from contract limit 1].id;
                     
        
        Customer_Specific_Work_Instruction__c cswi= new Customer_Specific_Work_Instruction__c();
        ApexPages.StandardController con = new ApexPages.StandardController(cswi);
        CSWISearch cswi1= new CSWISearch(con);
        PageReference pageRef = Page.CSWISearch;
        Test.setCurrentPage(pageRef);
        //cswi1.WorkInstructions=[Select Id,Customer_Code__c,Contractt_Id__c,Account__c,Contract_Id__c from Customer_Specific_Work_Instruction__c where Id ='a4hc0000000Ch6b'];
        cswi1.Keywords = 'test';      
        cswi1.keyword1='test';
        cswi1.strCondition='';
        cswi1.ViewData();
        cswi1.objCuslist =[Select Id,Name,Customer_Name__c,Active__c,Customer_Code__c,Contractt_ID__c,Contractt_ID__r.name,Contract_Number__c from Customer_Specific_Work_Instruction__c where Active__c=True and Customer_Name__c like 'test%' limit 2];
        system.debug('objlisttttttttt'+cswi1.objCuslist);
        //Customer_Specific_Work_Instruction__c objVOC= new Customer_Specific_Work_Instruction__c();
        //cswi1.objVOC=cswirec.id;
        cswi1.objCuslist1 =[Select Id,Name,Customer_Name__c,Active__c,Customer_Code__c,Contractt_ID__c,Contractt_ID__r.name,Contract_Number__c from Customer_Specific_Work_Instruction__c where Active__c=True and Customer_Name__c like 'test%' limit 2];
        
        /*
        cswi1.sortExpression='sortExp'; 
        //cswi1.con=cswi.id;
        cswi1.sortExp='name';  
        //cswi1.getcon();         
        string temp =  cswi1.sortdirection;
        */
        //cswi1.ViewData();
        //cswi1.CSWISearch();
        //cswi1.con='cswi1';
        //cswi1.Contractt_ID__c=cont.id;
        
        cswi1.searchform();        
        cswi1.backMethod();
        cswi1.previous();
        cswi1.next();  
        cswi1.sortExp='ASC'; 
        cswi1.SortExpression=cswi1.sortExp;
        cswi1.SortDirection='ASC';
        cswi1.getSortDirection();
        cswi1.ViewData();
        system.debug('keywordsssssssss1st'+cswi1.Keywords);
        system.debug('keywords1111111st'+cswi1.keyword1);
        system.debug('STRRR Condition1111'+cswi1.strCondition);

        cswi1.strCondition = null;
        cswi1.Keywords = null;      
        cswi1.keyword1 ='test';
        cswi1.ViewData();
        
        cswi1.searchform();
        cswi1.backMethod();
        cswi1.previous();
        cswi1.next();
        cswi1.hasNext=true;
        cswi1.hasPrevious=false;
        
        cswi1.sortExp='';  
        cswi1.sortExpression=cswi1.sortExp;    
        cswi1.SortDirection='';
        cswi1.getSortDirection();
        cswi1.ViewData();
        system.debug('keywordsssssssss2st'+cswi1.Keywords);
        system.debug('keywords1112ndd'+cswi1.keyword1);
        system.debug('STRRR Condition2222'+cswi1.strCondition);
        
        cswi1.strCondition = null;
        cswi1.Keywords = '';      
        cswi1.keyword1='test';
        
        cswi1.searchform();
        cswi1.backMethod();
        cswi1.previous();
        cswi1.next();
        cswi1.hasNext=true;
        cswi1.hasPrevious=true;
        cswi1.ViewData();
        system.debug('keywordsssssssss3rd'+cswi1.Keywords);
        system.debug('keywords113rd'+cswi1.keyword1);
        system.debug('STRRR Condition3333'+cswi1.strCondition);
        
        cswi1.WorkInstructions=[Select Id,Name,Customer_Name__c,Active__c,Customer_Code__c,Contractt_ID__c,Contractt_ID__r.name,Contract_Number__c from Customer_Specific_Work_Instruction__c where Active__c=True and Customer_Name__c like 'test%' limit 2];
        system.debug('cswi1 Work instructionnn'+cswi1.WorkInstructions);
        test.stoptest();
    }
    
    static testMethod void CSWISearchTest3() 
    {
        try

        {   
            test.starttest();
            
            id userid = [select id from user limit 1].id;
            id accountid = [select id from Account limit 1].id;
            Customer_Specific_Work_Instruction__c cswirec= new Customer_Specific_Work_Instruction__c();
            cswirec.Contract_ID__c= 'Test';
            cswirec.Account__c=accountid;
            cswirec.Customer_Code__c ='12345';
            
            insert cswirec;
            
            Customer_Specific_Work_Instruction__c cswirec1= new Customer_Specific_Work_Instruction__c();
            cswirec1.Contract_ID__c= 'Test';
            cswirec1.Account__c=accountid;
            cswirec1.Customer_Code__c ='123450';
            
            insert cswirec1;
            
            cswirec.Customer_Code__c = '123450';
            update cswirec;
        
            test.stoptest();
        }
        catch(Exception e)
            {

            Boolean expectedExceptionThrown =  e.getMessage().contains('Duplicate Customer Code  found!') ? true : false;

            System.AssertEquals(expectedExceptionThrown, true);

            } 
    }    
    static testMethod void CSWISearchTest()
    {
        test.starttest();
        id userid = [select id from user limit 1].id;
        id accountid = [select id from Account limit 1].id;
         Customer_Specific_Work_Instruction__c cswirec= new Customer_Specific_Work_Instruction__c();
        cswirec.Contract_ID__c= 'Test';
        cswirec.Account__c=accountid;
        cswirec.Customer_Code__c ='test111';
        cswirec.Customer_Name__c ='test account';
        //cswirec.Contractt_id__c='800c00000006Ss2';
        insert cswirec;
        system.debug('Contract Nameeeeee'+cswirec.Contractt_id__r.name);
        
        Customer_Specific_Work_Instruction__c cswi = new Customer_Specific_Work_Instruction__c();
        ApexPages.StandardController con = new ApexPages.StandardController(cswi);
        CSWISearch cswi2= new CSWISearch(con);
        PageReference pageRef = Page.CSWISearch;
        Test.setCurrentPage(pageRef);
        cswi2.Keywords = null;
        cswi2.SearchRecord.Customer_Code__c = '00104';
              
        cswi2.keyword1='test';
        cswi2.strCondition = '';
        cswi2.sortExpression='sortExp'; 
        cswi2.sortExp='DSC';           
        string temp =  cswi2.sortdirection;
        cswi2.ViewData();
        cswi2.getSortDirection();
        cswi2.setSortDirection('DSC');
        system.debug('Keywordssssssss'+cswi2.Keywords );
        system.debug('Keywordsssssssss111111111'+cswi2.Keyword1 );
        system.debug('strconditionnnnnnnnn'+cswi2.strCondition);
       cswi2.searchform();
        cswi2.backMethod();
        cswi2.previous();
        cswi2.next();
       test.stoptest();  
    }
}