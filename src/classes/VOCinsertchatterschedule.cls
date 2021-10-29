global class VOCinsertchatterschedule implements Schedulable
{
/** public static void createEvery15MinuteScheduledJobs()
 {
        insertchatterschedule adr = new insertchatterschedule(); 
        string sch = '0 0 * * * ?';
        system.schedule('job1',sch,adr);
        string sch1 = '0 15 * * * ?';
        system.schedule('job2',sch1,adr);
        string sch2 = '0 30 * * * ?';
        system.schedule('job3',sch2,adr);
        string sch3 = '0 45 * * * ?';
        system.schedule('job4',sch3,adr);
 }**/
  
    global void execute(SchedulableContext SC) 
    {
       list<Voice_of_Customer__c>  vocupdatelist = new list<Voice_of_Customer__c>();
       list<FeedItem>filist=new list<FeedItem>();   
       list<Voice_of_Customer__c>  voclist = new list<Voice_of_Customer__c>();
       voclist=[select id,Sensitive__c,OEM__c,SBU__c,SBU1__c,createdById,ownerid,selectedgroup__c,createdBy.Name,
                Title__c,Product_Family__c from Voice_of_Customer__c where Chatter_Created__c!=true];
       for(Voice_of_Customer__c voc: voclist) 
       {
       system.debug('voc.id**************'+voc.id);
       system.debug('voc.Product_Family__c**************'+voc.Product_Family__c);
       system.debug('voc.SBU__c**************'+voc.SBU__c);
       system.debug('voc.SBU__c**************'+voc.SBU__c);
       system.debug('voc.Sensitive__c**************'+voc.Sensitive__c);
          
        if(voc.Sensitive__c== true)
           {
            try{
           //system.debug('sssssssssssssssssssssssssssss'+selectedgroup);
            if(voc.selectedgroup__c!=null && voc.selectedgroup__c!='')
            {
           // system.debug('aaaaaaaaaaaaaaaaaaaaa'+a);
            FeedItem fitem = new FeedItem();
             fitem.type = 'LinkPost';
             fitem.ParentId =voc.selectedgroup__c;
             fitem.LinkUrl = '/' + voc.id; //This is the url to take the user to the activity
             fitem.Title = 'View';  //This is the title that displays for the LinkUrl
            
          
          
           //Get the user by checking the userMap we created earlier
             String my='';
             if(voc.Product_Family__c!=null)
              my = voc.Product_Family__c;
             if(my.contains('Wheels & Brakes'))
               my=my.replace('Wheels & Brakes', 'WheelsAndBrakes');
             if(my.contains('Safety & Info Mgmt'))
               my=my.replace('Safety & Info Mgmt', 'SafetyAndInfoMgmt');
             if(my.contains('Navigation Systems & Sensors'))
               my=my.replace('Navigation Systems & Sensors', 'NavSystemsAndSensors');
             string my1 = my.replaceAll( '\\s+', '');
             System.debug('space :' +my1);
             String[] prodfamily = my1.split('\\;');
             string test='';
             for(integer i=0; i<prodfamily.size();i++)
                test=+' #'+prodfamily[i];
            
            
             String OEM2='';
             if(voc.OEM__c!=null) 
               OEM2 =voc.OEM__c;
             if(OEM2=='Other - AT&R')
                OEM2='OtherATR';
             if(OEM2=='Other - BGA')
               OEM2='OtherBGA';
             if(OEM2=='Other- D&S')
               OEM2='OtherDS';
             if(OEM2=='Pan-Aero')
               OEM2='PanAero';
             string OEM1 = OEM2.replaceAll( '\\s+', '');
             System.debug('space : ' +OEM1);
             
             
             String SBU ='';
             if(voc.SBU__c!=null) 
               SBU =voc.SBU__c;
             system.debug('sbu**********'+test);
             if(SBU=='Commercial(AT&R & B&GA)')
              SBU='Commercial';
             if(SBU=='D&S')
              SBU='DS';
             if(SBU=='AT&R')
              SBU='ATR';
             if(SBU=='B&GA')
              SBU='BGA';
             string SBU1 = SBU.replaceAll( '\\s+', '');
             System.debug('space : ' +SBU1);
            // String SBU2 = voc.SBU1__c;
            
             fitem.Body = ('New VOC Record created by ') +voc.createdBy.Name +'\n Title: '+voc.Title__c+'\n #'+SBU1+''+ test+' #'+OEM1;
             filist.add(fitem);
             //insert fitem ;
             system.debug('fitem.id*********************'+fitem.id);
            }
           }
           catch(exception e){}
           }
          else if(voc.Sensitive__c!=true)
           {
             // Commented code for deployment error because of Chatter group Archieved
             /*FeedItem fitem = new FeedItem();
             fitem.type = 'LinkPost';
             fitem.ParentId =label.Voc_Public_Group;
             fitem.LinkUrl = '/' + voc.id; //This is the url to take the user to the activity
             fitem.Title = 'View';  //This is the title that displays for the LinkUrl*/
             // End for Commented code for deployment error because of Chatter group Archieved
            
           //Get the user by checking the userMap we created earlier
             String my='';
             if(voc.Product_Family__c!=null)
              my = voc.Product_Family__c;
              if(my.contains('Wheels & Brakes'))
               my=my.replace('Wheels & Brakes', 'WheelsAndBrakes');
             if(my.contains('Safety & Info Mgmt'))
               my=my.replace('Safety & Info Mgmt', 'SafetyAndInfoMgmt');
             if(my.contains('Navigation Systems & Sensors'))
               my=my.replace('Navigation Systems & Sensors', 'NavSystemsAndSensors');
             system.debug(my);
             string my1 = my.replaceAll( '\\s+', '');
             String[] prodfamily = my1.split('\\;');
             system.debug('prodfamily**********'+prodfamily);
             string test='';
             for(integer i=0; i<prodfamily.size();i++)
                test=test+' #'+prodfamily[i];
             System.debug('space :' +test);
             
             
            String OEM2='';
            if(voc.OEM__c!=null) 
               OEM2 =voc.OEM__c;
             if(OEM2=='Other - AT&R')
                OEM2='OtherATR';
             if(OEM2=='Other - BGA')
               OEM2='OtherBGA';
             if(OEM2=='Other- D&S')
               OEM2='OtherDS';
             if(OEM2=='Pan-Aero')
               OEM2='PanAero';
             system.debug(OEM2);
             string OEM1 = OEM2.replaceAll( '\\s+', '');
             System.debug('space : ' +OEM1);
             
             
             String SBU ='';
             if(voc.SBU__c!=null) 
               SBU =voc.SBU__c;
             if(SBU=='Commercial(AT&R & B&GA)')
              SBU='Commercial';
             if(SBU=='D&S')
              SBU='DS';
             if(SBU=='Pan-Aero')
               SBU='PanAero';
             if(SBU=='AT&R')
              SBU='ATR';
             if(SBU=='B&GA')
              SBU='BGA';
             system.debug('SBU is'+SBU);
             string SBU1 = SBU.replaceAll( '\\s+', '');
             System.debug('space : ' +SBU1);
             //String SBU2 = voc.SBU1__c;
             
             // Commented code for deployment error because of Chatter group Archieved
             /*fitem.Body = ('New VOC Record created by ') +voc.createdBy.Name +'\n Title: '+voc.Title__c+'\n Tags: #'+SBU1+''+ test+' #'+OEM1;
             filist.add(fitem);
             //insert fitem ;
              system.debug('aaaaaa********'+fitem.ParentId);
             
             system.debug('fitem.id##################'+fitem.id);*/
             // End for Commented code for deployment error because of Chatter group Archieved
           }
           voc.Chatter_Created__c=true;
           vocupdatelist.add(voc);
       }
       insert filist;
       update vocupdatelist;
       
     }
}