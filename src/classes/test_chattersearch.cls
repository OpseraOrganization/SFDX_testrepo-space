@isTest(SeeAllData=true)
private class test_chattersearch{
   static testMethod void chattersearch(){
        
        //creating new profile and user                  
        Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        User userRec = new User(LastName = 'venkat',Username = 'venkat@test.com.one',Email = 'venkat@test55.com',Alias = 'venkat' ,CommunityNickname= 'venkat' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        insert userRec;
       
        //collabration group item
        CollaborationGroup cg=new CollaborationGroup();
        cg.name='test';
        cg.OwnerId=userRec.id;
        cg.CollaborationType='Public';
        cg.Description ='test type';
        insert cg;
         system.debug('TTTTTTTTTTTTTTT'+cg.name);
        system.assertEquals('test', cg.name);
        //Feed item record
        FeedItem fitem=new FeedItem();
        fItem.parentId=cg.id;
        fItem.linkUrl='google.com';
        fitem.type = 'LinkPost';
        fItem.title='View';
        fItem.body='test';                    
        insert fItem;
        
        //customer story record 
        CustomerStory__c cs=new CustomerStory__c();
        cs.Name='test';
        cs.Story_Type__c='Win';
        cs.Status__c='Backlog';
        cs.Sales_Reference__c='Yes';
        cs.Sharing_Restriction__c='Educational Use Only - Do Not Mention Customer Name';
        cs.Region1__c='APAC';
        cs.SBU__c='BGA';
        cs.Story_Owner__c=userRec.id;
        insert cs;
        
        //calling apex class 
        String sText ='ABX9043092058';
        String sText1 ='ABX9043222058';
        String sText2 ='ABX6743222058';  
        String userinput='test';
        String userinp='tet'; 
        Test.setCurrentPageReference(new PageReference('Page.ChatterGroupSearch')); 
        System.currentPageReference().getParameters().put('id',cs.id);
        chattersearch ch=new chattersearch();
        ch.setuserinput('test');
        chattersearch.cContact ccont = new chattersearch.cContact (cg);
        
        //List<chattersearch.cContact> testProduction = ch.contactList; 
        ch.contactsearch();
        //collabration group item
        CollaborationGroup cg1=new CollaborationGroup();
        cg1.name='newtestgroup';
        cg1.OwnerId=userRec.id;
        cg1.CollaborationType='Public';
        cg1.Description ='test type';        
        insert cg1;
       
        System.assertEquals(cg.name,userinput);   
        for(chattersearch.cContact cc:ch.contactList )
        {
        cc.selected=true;
        }     
        ch.getresults();
        ch.processSelected();
        ch.geterrormsg();
        ch.Cancel();
        ch.getItems();
        //ch.processSelected();
        Boolean selected=false;
        Boolean callwindow1;
        Boolean b;
        ch.errormsg= false;
        b= ch.errormsg;
        system.assertEquals(b, false);
        Boolean c;
        ch.callwindow1= true;
        c= ch.callwindow1;
        system.assertEquals(c,true);
        ch.getuserinput();
        ch.getuserinp();        
        ch.setuserinput(sText);
        String s= ch.getuserinp();
        ch.setuserinp(sText1);
        ch.selectAllCheckbox=true;
        String s1= ch.getuserinput();                     
   }
   }