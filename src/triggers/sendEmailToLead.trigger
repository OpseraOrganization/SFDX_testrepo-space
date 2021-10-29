trigger sendEmailToLead on Lead (before insert, before update) 
{
    
    integer errLoc = 0;
    System.debug('Start Code');
    string tmpLdId;
    string keywordStr;
    string vAsmName;
    string vGeneralMailId = label.GeneralMailId ;//'0D2T00000004Ctf' ;
    string vFolderId = label.FolderId ; //'00lT0000000k2bQ';
    
    string vBrocEmailTemp = label.BrocEmailTemp ; //'00XT0000000fGUO';
    string vThxEmailTemplate = label.ThxEmailTemplate ; //'00XT0000000fGUJ';
    string vEmailTempFolderId = label.EmailTempFolderId ; //'00lT0000000k28n';
    
    
    try 
    {
                for (Lead ld : Trigger.new)
                if(ld.isconverted == False && (Trigger.new.size() == 1) && (ld.recordtypeid == label.BGA_Honeywell_Prospect || ld.recordtypeid == label.BGA_Honeywell_Prospect_Convert))
                {
                     ////System.assert(ld.Id ==null);
                     
                    errLoc =10; 
                    tmpLdId = ld.Id;
                    String vEmailBdy = '';
                    String vEmailSubject='';
                            /****************************************************************************
                            SEND BROCHURES CODE STARTS HERE
                            ****************************************************************************/
                    
                    if(
                               ld.Follow_Up_action_requested__c != null
                            && ld.Follow_Up_action_requested__c.contains('Send a brochure')
                            && ld.Email != null
                            && ld.Email.length() > 0
                      )
                    {       
                            errLoc =20;
                            System.Debug('INSIDE:SEND BROCHURES CODE STARTS HERE');
                            
                            if(ld.brochures_sent__c == null)
                            {
                                System.debug('Lead ld.brochures_sent__c'+ld.brochures_sent__c);
                                ld.brochures_sent__c = ';';
                            }
                            errLoc =30;
                            List<EmailTemplate> objEmailTemplate = [select Id,Name,Subject,body from EmailTemplate WHERE Id=:vBrocEmailTemp AND FolderId = :vEmailTempFolderId];
                            
                            vEmailBdy = '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{    font-family:Arial, Helvetica, sans-serif;   color:#333; font-size:100%;}</style><table class=tableborder width=100%>    <tr>        <td class=fontlabel>            ';
                            
                            errLoc =40;
                            if(objEmailTemplate.size() > 0)
                            for(integer i=0;i<objEmailTemplate.size();i++)
                            {
                                vEmailBdy       = vEmailBdy + (objEmailTemplate[0].body+'<br><br>').replace ('\n','<br>');
                                vEmailSubject   = objEmailTemplate[0].Subject;
                            }
                            //else
                            //{
                            //  vEmailBdy = vEmailBdy + 'We have attached brochures for your reference. Let us know if we can provide additional assistance to you.<br><br>';
                            //  vEmailBdy = vEmailBdy + 'Best Regards,<br><br>';  
                            //}
                            
                            //vEmailBdy = vEmailBdy + 'Thank you for visiting our booth at the 2009 NBAA Convention.&nbsp;';  
                            //vEmailBdy = vEmailBdy + 'We hope that you enjoyed your visit and were able to find aviation at its best in our booth.&nbsp;';  
                            //vEmailBdy = vEmailBdy + 'We have attached brochures for your reference.&nbsp;';  
                            //vEmailBdy = vEmailBdy + 'We will contact you to follow up on any questions you may still have and discuss the possible next steps.<br><br>';  

                            //vEmailBdy = vEmailBdy + 'I hope that your attendance at the show was informative and again let us know if we can provide additional assistance to you.<br><br>';
                            //vEmailBdy = vEmailBdy + 'Best Regards,<br><br>';
                            errLoc =50;
                                    List<User> objUser ;
                                    
                                    System.Debug('INSIDE:Send Letter - Use ASM Signature'); 
                                                        
                                    if(ld.BGA_ASM__c != null)
                                    {
                                                // WHEN ASM SELECTED
                                                errLoc =60;
                                                vAsmName = ld.BGA_ASM__c.replace('  ',' ') ;
                                                
                                                objUser = [select Id, Name,Email,Phone,Extension,Fax,MobilePhone   from User where Name  = :vAsmName ];
                                                
                                                  if(   
                                                        objUser != null
                                                        && objUser.size() > 0
                                                    )
                                                    {
                                                        errLoc =70;
                                                        vEmailBdy = vEmailBdy + '' + objUser[0].Name + '' +'<br>';
                                                            
                                                            vEmailBdy = vEmailBdy +'Email: <a href=\'mailto:'+objUser[0].Email+'\'>'+ objUser[0].Email +'</a><br>';
                                                            
                                                            if(objUser[0].Phone!=null)
                                                            {
                                                                    //System.Debug('when phone avilable'); 
                                                                    errLoc =80; 
                                                                    vEmailBdy = vEmailBdy + 'Phone: '+objUser[0].Phone;
                                                                    
                                                                    if(objUser[0].Extension!=null)
                                                                    {
                                                                        vEmailBdy = vEmailBdy + '    Extn: '+objUser[0].Extension;
                                                                        //System.Debug('when extn avilable'); 
                                                                    }
                                                                    
                                                                    vEmailBdy = vEmailBdy + '<br>';
                                                            }
                                                            
                                                            errLoc =90;
                                                            
                                                            if(objUser[0].MobilePhone !=null)
                                                            {
                                                                vEmailBdy = vEmailBdy + 'Mobile: ' + objUser[0].MobilePhone+'<br>'; 
                                                                //System.Debug('when mobile avilable'); 
                                                            }
                                                            
                                                            errLoc =100;

                                                            if(objUser[0].Fax!=null)
                                                            {
                                                                vEmailBdy = vEmailBdy + 'Fax: ' + objUser[0].Fax+'<br>';
                                                                //System.Debug('when fax avilable');    
                                                            }
                                                            
                                                            
                                                            
                                                        }   
                                    }
                                    else
                                    {
                                            errLoc =110;
                                            vEmailBdy = vEmailBdy + 'Mike Beazley<br>';
                                            vEmailBdy = vEmailBdy + 'Vice President<br>';
                                            vEmailBdy = vEmailBdy + 'Global Aftermarket Sales';
                                        
                                    }
                                                        
                                    vEmailBdy = vEmailBdy +'<br><br>        </td>   </tr></table>';
                                                        
                        
                            

                            /****************************************************************************
                            SET THE VARIABLES FOR SENDING EMAILS
                            ****************************************************************************/
                            errLoc =120;
                            string serviceList = '';
                            string[] listKeywords = new string[200] ;
                            integer startIDX=0;
                            /****************************************************************************
                            SEND BROCHURES FOR DISPLAY SERVICES
                            ****************************************************************************/
                                            if(ld.Displays__c != null )
                                            {
                                                try
                                                {
                                                    errLoc =130;
                                                    System.Debug('commStr:START FOR DISPLAY');
                                                    serviceList = serviceList + 'DISPLAYS';
                                                    string displayStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Displays__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                                                                
                                                    system.debug('ttttttttt'+ displayStr);
                                                    string[] displayVal =   displayStr.split(';');
                                                    system.debug('vvvvvvvvv'+ displayVal);
                                                    errLoc =140;
                                                    for(integer i=0;i<displayVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=displayVal[i];
                                                        startIDX++;
                                                    }
                                                    errLoc =150;
                                                    ld.brochures_sent__c = ld.brochures_sent__c + displayStr;
                                                    system.debug('ooooooo'+ ld.brochures_sent__c);                                        
                                                    
                                                    
                                                }
                                                catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'DISPLAY',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                                  }
                                            }
                                            
                                            system.debug('ccccccccccccccc'+ listKeywords);
                            /****************************************************************************
                            SEND BROCHURES FOR Comm SERVICES
                            ****************************************************************************/
                                            if(ld.Comm__c != null)
                                            {
                                                try
                                                {
                                                    System.Debug('commStr:START FOR COMM');
                                                    errLoc =160;
                                                    string commStr = sendEmail.preapreKeywords
                                                                                    (
                                                                                        ld.Comm__c,
                                                                                        ld.brochures_sent__c
                                                                                    );
                                                                                                                            
                                                    string[] commVal =  commStr.split(';');
                                                    errLoc =170;
                                                    for(integer i=0;i<commVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=commVal[i];
                                                        startIDX++;
                                                    }
                                                    errLoc =180;
                                                    ld.brochures_sent__c = ld.brochures_sent__c + commStr;                                      
                                                    errLoc =190;
                                                    serviceList = serviceList + ';COMM';
                                                }
                                                catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'COMM',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                                  }

                                            }
                
                            /****************************************************************************
                            SEND BROCHURES FOR Nav SERVICES
                            ****************************************************************************/
                                            if(ld.Nav__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR NAV');       
                                            errLoc =200;                                        
                                            string navStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Nav__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =210;                                    
                                            string[] navVal = navStr.split(';');

                                                    for(integer i=0;i<navVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=navVal[i];
                                                        startIDX++;
                                                    }
                                            errLoc =220;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + navStr;
                                            
                                            serviceList = serviceList + ';NAV';
                                            
                                            }
                                            catch(Exception e)
                                                                {
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'COMM',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                                }

                                            }
                                    
                            /****************************************************************************
                            SEND BROCHURES FOR Safety SERVICES
                            ****************************************************************************/
                                            if(ld.Safety__c != null)
                                            {
                                            try
                                            {

                                            System.Debug('commStr:START FOR SAFETY');
                                            errLoc =230;    
                                            string safetyStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Safety__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =240;                                    
                                            string[] safetyVal = safetyStr.split(';');

                                                    for(integer i=0;i<safetyVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=safetyVal[i];
                                                        startIDX++;
                                                    }
                                            errLoc =250;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + safetyStr;
                                            
                                            serviceList = serviceList + ';SAFETY';                                  
                                            
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'SAFETY',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                            }

                                            }
                
                            /****************************************************************************
                            SEND BROCHURES FOR Mech SERVICES
                            ****************************************************************************/
                                            if(ld.Mech__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR MECH');          
                                            errLoc =260;                                    
                                            string mechStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Mech__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =270;                                    
                                            string[] mechVal = mechStr.split(';');

                                                    for(integer i=0;i<mechVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=mechVal[i];
                                                        startIDX++;
                                                    }

                                            errLoc =280;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + mechStr;                                          
                                            
                                            serviceList = serviceList + ';MECH';
                                                    
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'MECH',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                              }     
                                            
                                            }
                
                            /****************************************************************************
                            SEND BROCHURES FOR Cabin SERVICES
                            ****************************************************************************/
                                            if(ld.Cabin__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR CABIN'); 
                                            errLoc =290;                                        
                                            string cabinStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Cabin__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =300;                                    
                                            string[] cabinVal = cabinStr.split(';');

                                                    for(integer i=0;i<cabinVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=cabinVal[i];
                                                        startIDX++;
                                                    }
                                            errLoc =310;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + cabinStr;                                         
                                            
                                            serviceList = serviceList + ';CABIN';
                                                        
                                            }
                                            catch(Exception e)
                                                            {
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'CABIN',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                            }

                                            }
                
                
                            /****************************************************************************
                            SEND BROCHURES FOR Services SERVICES
                            ****************************************************************************/
                                            if(ld.Services__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR SERVICES');  
                                            errLoc =320;                                            
                                            string servicesStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Services__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =330;                                    
                                            string[] servicesVal = servicesStr.split(';');

                                                    for(integer i=0;i<servicesVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=servicesVal[i];
                                                        startIDX++;
                                                    }

                                            errLoc =340;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + servicesStr;                                          
                                            
                                            serviceList = serviceList + ';SERVICES';
                                                        
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'SERVICES',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                              }

                                            }
                                            
                            /****************************************************************************
                            SEND BROCHURES FOR Air Data SERVICES
                            ****************************************************************************/
                                            if(ld.Air_Data__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR Air Data');
                                            errLoc =350;                                                
                                            string airDataStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Air_Data__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =360;                                    
                                            string[] airDataVal = airDataStr.split(';');

                                                    for(integer i=0;i<airDataVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=airDataVal[i];
                                                        startIDX++;
                                                    }

                                            errLoc =370;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + airDataStr;                                           
                                            
                                            serviceList = serviceList + ';AIR DATA';
                                                    
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'AIR DATA',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                              }     
                                            
                                            }
                                            
                                            system.debug('aaaaaaaaaaaa'+ listKeywords);
                            /****************************************************************************
                            SEND BROCHURES FOR WEATHER SERVICES
                            ****************************************************************************/
                                            if(ld.Weather__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR Weather');   
                                            errLoc =380;                                            
                                            string weatherStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Weather__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =390;                                    
                                            string[] weatherVal = weatherStr.split(';');

                                                    for(integer i=0;i<weatherVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=weatherVal[i];
                                                        startIDX++;
                                                    }
                                            
                                            errLoc =390;
                                            
                                            serviceList = serviceList + ';WEATHER';
                                                                                
                                            ld.brochures_sent__c = ld.brochures_sent__c + weatherStr;                                           
                                                    
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'WEATHER',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                              }     
                                            
                                            }
                            
                            /****************************************************************************
                            SEND BROCHURES FOR Lighting AND WEATHER SERVICES
                            ****************************************************************************/
                                            if(ld.Lighting__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR Lighting');  
                                            errLoc =400;                                            
                                            string LightingStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Lighting__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =410;
                                            string[] LightingVal = LightingStr.split(';');

                                                    for(integer i=0;i<LightingVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=LightingVal[i];
                                                        startIDX++;
                                                    }

                                            errLoc =420;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + LightingStr;                                          
                                            
                                            serviceList = serviceList + ';LIGHTING';
                                                    
                                                                        
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'LIGHTING',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                              }     
                                            
                                            }
                            /****************************************************************************
                            SEND BROCHURES FOR GA SERVICES
                            ****************************************************************************/
                                            if(ld.GA__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR GA');
                                            errLoc =430;                                                
                                            string GAStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.GA__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =440;                                    
                                            string[] GAVal = GAStr.split(';');

                                                    for(integer i=0;i<GAVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=GAVal[i];
                                                        startIDX++;
                                                    }

                                            errLoc =450;                                    
                                            ld.brochures_sent__c = ld.brochures_sent__c + GAStr;                                            
                                            
                                            serviceList = serviceList + ';GA';
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'GA',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                                }       
                                            
                                            }
                            /****************************************************************************
                            SEND Send_Aircraft_Specific_Brochures
                            ****************************************************************************/
                                            if(ld.Send_Aircraft_Specific_Brochures__c != null)
                                            {
                                            try
                                            {
                                            System.Debug('INSIDE:START FOR Send_Aircraft_Specific_Brochures');
                                            errLoc =460;                                                
                                            string AirSpecBroStr = sendEmail.preapreKeywords
                                                                                (
                                                                                    ld.Send_Aircraft_Specific_Brochures__c,
                                                                                    ld.brochures_sent__c
                                                                                );
                                            errLoc =470;                                    
                                            string[] AirSpecBroVal = AirSpecBroStr.split(';');

                                                    for(integer i=0;i<AirSpecBroVal.size();i++)
                                                    {
                                                        listKeywords[startIDX]=AirSpecBroVal[i];
                                                        startIDX++;
                                                    }

                                            errLoc =480;
                                                                                
                                            ld.brochures_sent__c = ld.brochures_sent__c + AirSpecBroStr;                                            
                                            
                                            serviceList = serviceList + ';AIRCRAFT SPECIFIC BROCHURES';
                                            }
                                            catch(Exception e){
                                                                    utilClass.createErrorLog
                                                                         (
                                                                         'sendEmailToLead',
                                                                         'AIRCRAFT SPECIFIC BROCHURES',
                                                                          ld.Id+' ERRORLOC - '+errloc+' - '+ e.getMessage()
                                                                         );         
                                                              }     
                                            
                                            }  
                                            system.debug('test'+ listKeywords);                                                                                         
                            /****************************************************************************
                            SEND EMAIL FOR ALL IN THE LAST
                            ****************************************************************************/
                                                    if(
                                                            serviceList.length() > 2
                                                         && objEmailTemplate.size() > 0
                                                        )
                                                    {
                                                        errLoc =490;
                                                        sendEmail.SendEmailNotification
                                                                            (
                                                                            ld.Email,
                                                                            listKeywords,
                                                                            vEmailSubject, 
                                                                            vEmailBdy,
                                                                            null,
                                                                            null,
                                                                            vFolderId,
                                                                            serviceList,
                                                                            vGeneralMailId // use general email id                                                                          
                                                                            );
                                                    }
                                            
                                            //ld.brochures_sent__c =    ld.brochures_sent__c    +
                                            //                              ';';
                                                                 
                                                                 
                                                                 
                    }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            /****************************************************************************
                            SEND BROCHURES CODE ENDS HERE
                            ****************************************************************************/
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            errLoc =500;
                            
                            
                            vEmailBdy =             '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{    font-family:Arial, Helvetica, sans-serif;   color:#333; font-size:100%;}</style>';
                            vEmailBdy = vEmailBdy + '<table class=tableborder width=100%>   <tr>        <td class=fontlabel>            ';
                            
                            
                            List<EmailTemplate> objThxEmailTemplate = [select Id,Name,Subject,body from EmailTemplate WHERE Id=:vThxEmailTemplate AND FolderId = :vEmailTempFolderId];
                            
                            vEmailBdy = '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{    font-family:Arial, Helvetica, sans-serif;   color:#333; font-size:100%;}</style><table class=tableborder width=100%>    <tr>        <td class=fontlabel>            ';
                            
                            errLoc =510;
                            for(integer i=0;i<objThxEmailTemplate.size();i++)
                            {
                                errLoc =510;
                                vEmailBdy       = vEmailBdy + (objThxEmailTemplate[0].body+'<br><br>').replace ('\n','<br>');
                                vEmailSubject   = objThxEmailTemplate[0].Subject;
                            }
                            
                            
                            //vEmailBdy = vEmailBdy + 'Thank you for visiting our booth at the 2009 NBAA Convention.&nbsp;';  
                            //vEmailBdy = vEmailBdy + 'We hope that you enjoyed your visit and were able to find aviation at its best in our booth.&nbsp;';  
                            //vEmailBdy = vEmailBdy + 'Please contact us if you need additional information or have any questions that we can answer for you.&nbsp;';
                            //vEmailBdy = vEmailBdy + '<br><br>I hope that your attendance at the show was enjoyable and informative and again let us know if we can provide additional assistance to you.&nbsp;';
                            //vEmailBdy = vEmailBdy + '<br><br>Best Regards,<br><br>';
                    
                            /****************************************************************************
                             Send Letter - Use General Signature
                            ****************************************************************************/
                    if  (
                           ld.Thank_you_for_stopping_by_letter__c != null
                        && ld.Thank_you_for_stopping_by_letter__c.contains('Send Letter - Use General Signature')
                        && ld.thanksforstopbyemailSent__c <> true
                        && ld.Email != null
                        && ld.Email.length() > 0
                        && objThxEmailTemplate.size() > 0
                        )
                    {
                        errLoc =520;
                        System.Debug('INSIDE:Send Letter - Use General Signature');
                        vEmailBdy = vEmailBdy + 'Mike Beazley<br>';
                        vEmailBdy = vEmailBdy + 'Vice President<br>';
                        vEmailBdy = vEmailBdy + 'Global Aftermarket Sales<br><br><br>';

                        
                        vEmailBdy = vEmailBdy + '</td>  </tr></table>';
                        
                        sendEmail.SendEmailNotification
                                                    (
                                                    ld.Email,
                                                    null,
                                                    vEmailSubject,
                                                    vEmailBdy,
                                                    null,
                                                    null,
                                                    '',
                                                    null,
                                                    vGeneralMailId // use general email id                                                  
                                                    );
                        System.Debug('emil sent....');
                        ld.thanksforstopbyemailSent__c = true;
                        System.Debug('thanksforstopbyemailSent__c:'+ld.thanksforstopbyemailSent__c);
                    }

                    /****************************************************************************
                    Send Letter - Use ASM Signature
                    ****************************************************************************/
                    

                    if (
                           ld.Thank_you_for_stopping_by_letter__c != null
                        && ld.Thank_you_for_stopping_by_letter__c.contains('Send Letter - Use ASM Signature')
                        && ld.thanksforstopbyemailSent__c <> true
                        && ld.Email != null
                        && ld.Email.length() > 0
                        && objThxEmailTemplate.size() > 0
                        )
                    {               
                                    errLoc =530;
                                    List<User> objUser ;
                                    System.Debug('INSIDE:Send Letter - Use ASM Signature');                     
                                    if(ld.BGA_ASM__c != null)
                                    {
                                        // WHEN ASM SELECTED
                                        errLoc =540;
                                                vAsmName = ld.BGA_ASM__c.replace('  ',' ') ;
                                                 objUser = [select Id, Name,Email,Phone,Extension,Fax,MobilePhone   from User where Name  = :vAsmName ];
                                                 System.Debug('when asm selected');
                                                 ////System.assert(objUser== null);
                                                  if(   objUser != null
                                                        && objUser.size() > 0
                                                    )
                                                    {
                                                        errLoc =550;
                                                        ld.OwnerId = objUser[0].Id;
                                                    } 
                                    }
                                    else
                                    {
                                        // WHEN ASM NOT SELECTED
                                                errLoc =560;
                                                vAsmName = UserInfo.getUserId();
                                                objUser  = [select Name,Email,Phone,Extension,Fax,MobilePhone   from User where ID  = :vAsmName ];
                                                System.Debug('when asm not selected'); 
                                                ////System.assert(objUser== null);
                                    }
                                                        
                                                        
                                                        if(objUser.size() > 0)
                                                        {
                                                            errLoc =570;
                                                            vEmailBdy = vEmailBdy + '' + objUser[0].Name + '' +'<br>';
                                                            
                                                            vEmailBdy = vEmailBdy +'Email: <a href=\'mailto:'+objUser[0].Email+'\'>'+ objUser[0].Email +'</a><br>';
                                                            
                                                            if(objUser[0].Phone!=null)
                                                            {
                                                                    //System.Debug('when phone avilable'); 
                                                                    errLoc =580;    
                                                                    vEmailBdy = vEmailBdy + 'Phone: '+objUser[0].Phone;
                                                                    
                                                                    if(objUser[0].Extension!=null)
                                                                    {
                                                                        vEmailBdy = vEmailBdy + '    Extn: '+objUser[0].Extension;
                                                                        //System.Debug('when extn avilable'); 
                                                                    }
                                                                    
                                                                    vEmailBdy = vEmailBdy + '<br>';
                                                            }

                                                            if(objUser[0].MobilePhone !=null)
                                                            {
                                                                errLoc =600;
                                                                vEmailBdy = vEmailBdy + 'Mobile: ' + objUser[0].MobilePhone+'<br>'; 
                                                                //System.Debug('when mobile avilable'); 
                                                            }

                                                            if(objUser[0].Fax!=null)
                                                            {
                                                                errLoc =590;
                                                                vEmailBdy = vEmailBdy + 'Fax: ' + objUser[0].Fax+'<br>';
                                                                //System.Debug('when fax avilable');    
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        else
                                                        {
                                                            errLoc =610;
                                                            vEmailBdy = vEmailBdy +'Global Aftermarket Sales';
                                                            //System.Debug('when else condition'); 
                                                        }
                                                        
                                                        vEmailBdy = vEmailBdy +'<br><br>        </td>   </tr></table>';
                                                        
                                    /****************************************************************************
                                     WHEN ASM SELECTED
                                    ****************************************************************************/
                        
                                    if(ld.BGA_ASM__c != null)
                                    {
                                                        
                                    //System.Debug('INSIDE:WHEN ASM SELECTED'); 
                                    errLoc =620;                                                    
                                                        sendEmail.SendEmailNotification
                                                                (
                                                                ld.Email,
                                                                null,
                                                                vEmailSubject,
                                                                 vEmailBdy,
                                                                null,
                                                                null,
                                                                '',
                                                                null,
                                                                vGeneralMailId // use general email id                                                  
                                                                );
                                    //System.Debug('WHEN ASM SELECTED...email sent'); 
                                                        
                                    }
                                    
                                    /****************************************************************************
                                     WHEN ASM NOT SELECTED
                                    ****************************************************************************/
                                    
                                    else
                                    {               
                                            
                                                        // WHEN ASM NOT SELECTED
                                        //System.Debug('INSIDE:WHEN ASM NOT SELECTED'); 
                                        errLoc =630;                                                    
                                                        sendEmail.SendEmailNotification
                                                                    (
                                                                     ld.Email,
                                                                     null,
                                                                     vEmailSubject,
                                                                     vEmailBdy,
                                                                     null,
                                                                     null,
                                                                     '',
                                                                     null,
                                                                     null
                                                                     );
                                        //System.Debug('WHEN ASM SELECTED...email not sent');                                                                    
                                    }                   
                                
                                    ld.thanksforstopbyemailSent__c = true;
                                            
                    
                    }
                }

                
    }
     catch (Exception e) 
     {
        // Your MyException handling code here
                                                        utilClass.createErrorLog
                                                             (
                                                             'sendEmailToLead',
                                                             'sendEmailToLead',
                                                              tmpLdId+' ERRORLOC - '+errloc+' - '+e.getMessage()
                                                             );         
     }
     
}