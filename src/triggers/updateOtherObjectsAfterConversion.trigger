/** * File Name: UpdateLeadInitiatorName
* Description :Trigger to update lead creator
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
23-Jan-2015     1.1             NTTDATA         INC000008227994 ATR RMU TOOL owner assignment 
*/
trigger updateOtherObjectsAfterConversion on Lead (after insert, after update) 
{
    integer errLoc =0;
    string priceBook2Id = null;
    OpportunityLineItem[] oppProductUpdate = null;
    //Code added for SR# INC000008227994 ATR RMU TOOL Start
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>(); 
    map<id,id> mapAccId = new map<id,id>();
    String strOwnerName ='';
    List<String> toAddresses=new List<String>();
    for (Lead ld : Trigger.new) {
        if( Trigger.isInsert && Userinfo.getUserId()==label.ATR_API_User_id)
            mapAccId.put(ld.id,ld.Account__c);
    }
    
    Map<Id,Account> mapacctteam = new  MaP<Id,Account>();
    if(mapAccId.size()>0)
        mapacctteam = new  MaP<Id,Account>([select id,(SELECT TeamMemberRole,UserId,user.email,user.name FROM AccountTeamMembers where TeamMemberRole='Customer Business Manager (CBM)' ) from account where id in :mapAccId.values()]);
    
    //Code added for SR# INC000008227994 ATR RMU TOOL End
    for (Lead ld : Trigger.new) {
        if(Trigger.new.size() == 1 && (ld.recordtypeid == label.BGA_Honeywell_Prospect || ld.recordtypeid == label.BGA_Honeywell_Prospect_Convert))
        {
            try
            {   
            
                    /**************************************************************************
                    Getting Pricebook from BGA AM 2008(Query will return the newly created pricebook)
                    **************************************************************************/
                    //List<Pricebook2> activePriceBook = [Select Id from Pricebook2 Where IsActive = true Order by CreatedDate Desc LIMIT 1];
                    /**************************************************************************
                     Getting Pricebook form BGA AM 2011 (Query will return the pricebook from BGA AM 2011                       
                    **************************************************************************/
                    List<Pricebook2> activePriceBook = [Select Id from Pricebook2 Where IsActive = true and name like 'BGA AM 2011' LIMIT 1];
                    
                    if(activePriceBook.size() > 0)
                    {priceBook2Id = activePriceBook[0].Id;}
        
        
    
                                            /**************************************************************************
                                            IS CONVERTED IF CLAUSE STARTS
                                            **************************************************************************/
                        if(ld.IsConverted)
                        {   
                                            /**************************************************************************
                                            Update Converted Account Fields
                                            **************************************************************************/
                                            errLoc = 10;    
                                            if(
                                                    ld.ConvertedAccountId != null
                                                &&  ld.ConvertedAccountId != Trigger.old[0].ConvertedAccountId
                                              )
                                              {
                                                System.Debug('Start Account...');
                                              }
                                        
                                            /**************************************************************************
                                            Update Converted Contact Fields
                                            **************************************************************************/
                                            errLoc = 20;
                                              
                                            if(
                                                    ld.ConvertedContactId != null
                                                &&  ld.ConvertedContactId != Trigger.old[0].ConvertedContactId
                                              )
                                              {
                                                System.Debug('Start Contact...');
                                                
                                                Contact Con = new Contact(Id=ld.ConvertedContactId);
                                                
                                                if(ld.Title != null)
                                                {
                                                        Con.Title = ld.Title ;
                                                        
                                                        if(ld.Title.length() > 50)
                                                        {
                                                            Con.Job_Title__c =  (ld.Title).substring(0,50) ;
                                                            
                                                        }
                                                        else
                                                        {
                                                            Con.Job_Title__c =  ld.Title;
                                                        }
                                                }
                                                
                                                update Con;
                                            
                                              }
                                            errLoc = 30;
                                            /**************************************************************************
                                            Update Converted Opportunity Fields
                                            **************************************************************************/
                                              
                                            if(
                                                    ld.ConvertedOpportunityId != null
                                                &&  ld.ConvertedOpportunityId != Trigger.old[0].ConvertedOpportunityId
                                              )
                                              {
                                                System.Debug('Start Opportunity...');
                                            
                                                Opportunity Opp = new Opportunity(Id=ld.ConvertedOpportunityId);
                                                
                                                Opp.Opportunity_Notes__c        = ld.Description;
                                                Opp.Type                        = ld.Opportunity_Type__c;
                                                Opp.Regional_Sales_Manager__c   = ld.Regional_Sales_Manager__c;
                                                Opp.Aircraft_Ref__c             = ld.Aircraft__c;
                                                
                                                if(priceBook2Id != null)
                                                {
                                                    Opp.Pricebook2Id                = priceBook2Id;
                                                }
                                                
                                                update Opp;
                                            
                                              }
                                                errLoc = 40;
                                                //-**************************************************************************
                                                //Create Aircraft Entry
                                                //-**************************************************************************/
    
                                                        /**************************************************************************
                                                        Create Opportunity Product Entries
                                                        **************************************************************************/
                                                        if(ld.ConvertedOpportunityId  != null)
                                                        {       
                                                            errLoc = 120;           
                                                            string allSelectedProducts =        
                                                                                                (ld.Displays__c ==  null    ?   '': ld.Displays__c  +   ';')
                                                                                        +       (ld.Comm__c     ==  null    ?   '': ld.Comm__c      +   ';')
                                                                                        +       (ld.Nav__c      ==  null    ?   '': ld.Nav__c       +   ';')
                                                                                        +       (ld.Safety__c   ==  null    ?   '': ld.Safety__c    +   ';')
                                                                                        +       (ld.Mech__c     ==  null    ?   '': ld.Mech__c      +   ';')
                                                                                        +       (ld.Cabin__c    ==  null    ?   '': ld.Cabin__c     +   ';')
                                                                                        +       (ld.Services__c ==  null    ?   '': ld.Services__c  +   ';')
                                                                                        +       (ld.Air_Data__c ==  null    ?   '': ld.Air_Data__c  +   ';')
                                                                                        +       (ld.Weather__c  ==  null    ?   '': ld.Weather__c   +   ';')
                                                                                        +       (ld.Lighting__c ==  null    ?   '': ld.Lighting__c  +   ';')
                                                                                        +       (ld.GA__c       ==  null    ?   '': ld.GA__c        +   ';')
                                                                                        +       (ld.Send_Aircraft_Specific_Brochures__c == null ?   ''   :   ld.Send_Aircraft_Specific_Brochures__c )
                                                                                        ;
                                                            errLoc = 130;
                                                                        if(allSelectedProducts.length() > 0 )
                                                                        {   
                                                                            errLoc = 140;                   
                                                                            string[] arProdVals = allSelectedProducts.split(';');
                                                                                    
                                                                            integer  cntFoundPrd=0; 
                                                                                    /**************************************************************************
                                                                                    ADD SELECTED LEAD PRODUCTES TO OPPORTUNITY NOTES            
                                                                                    **************************************************************************/
                                                                                    if(allSelectedProducts.replace(';', '').length() > 0)
                                                                                    {
                                                                                        Opportunity Opp_notes = new Opportunity(Id=ld.ConvertedOpportunityId);
                                                                                        Opp_notes.Opportunity_Notes__c = (ld.Description == null?'':ld.Description+'\n\n' ) 
                                                                                                                        + '=========================================\n' 
                                                                                                                        + 'Services\\Products requested:'
                                                                                                                        + '\n------------------------\n' 
                                                                                                                        + allSelectedProducts.replace(';;',';').replace(';', '\n')
                                                                                                                        + '\n=========================================';
                                                                                        update Opp_notes;
                                                                                    }
                                                                                    /**************************************************************************
                                                                                    **************************************************************************/
                                                                        }
                                                                        
                                                                // START: Populate  Opportunity Product using Lead Products
                                                                // Using price book priceBook2Id
                                                                                                                                
                                                                //Get all the products from lead product
                                                                if(priceBook2Id != null)
                                                                {
                                                                        List<Lead_Products__c> ldProd =  [  Select Product__c 
                                                                                                            From   Lead_Products__c 
                                                                                                            Where  Lead__c = :ld.Id
                                                                                                            Limit 10
                                                                                                          ];
                                                                                                          
                                                                        if(ldProd.size() > 0)
                                                                        {
                                                                                    List<string> prodIdList  = new string[]{};
                                                                                    for (Lead_Products__c ldPrd : ldProd)
                                                                                    {
                                                                                        prodIdList.add(ldPrd.Product__c);
                                                                                    }
                                                                                    
                                                                                    
                                                                                    List<PricebookEntry> priceBookEntry =  [
                                                                                                                            Select Id,Product2.Name,UnitPrice 
                                                                                                                            From  PricebookEntry 
                                                                                                                            Where Product2Id in :prodIdList
                                                                                                                            And   Pricebook2Id = :priceBook2Id 
                                                                                                                            and IsActive = true 
                                                                                                                            ]
                                                                                                                            ;                                                               
                                                                                        
                                                                                        if(priceBookEntry!= null && priceBookEntry.size()  > 0 )
                                                                                        {
                                                                                            oppProductUpdate = new OpportunityLineItem[priceBookEntry.size()];
                                                                                        }
                                                                                         
                                                                                        //Loop Around each lead product and insert into opportunity product. 
                                                                                        for(integer lpCnt=0;lpCnt<priceBookEntry.size();lpCnt++)
                                                                                        {
                                                                                            oppProductUpdate[lpCnt] = new OpportunityLineItem();
                                                                                            
                                                                                            oppProductUpdate[lpCnt].PricebookEntryId = priceBookEntry[lpCnt].Id;
                                                                                            oppProductUpdate[lpCnt].OpportunityId    = ld.ConvertedOpportunityId;
                                                                                            oppProductUpdate[lpCnt].Quantity         = 1;
                                                                                            oppProductUpdate[lpCnt].UnitPrice        = priceBookEntry[lpCnt].UnitPrice;
                                                                                        }
                                                                                         
                                                                                        if(oppProductUpdate!= null && oppProductUpdate.size() > 0)
                                                                                        { 
                                                                                            insert oppProductUpdate;
                                                                                        }        
                                                                        }
                                                                }
                                                                    
                                                            // END: Populate Opportunity Product using Lead Products            
                                                        }   
                                              
                        }
                          
                                            /**************************************************************************
                                            IS CONVERTED IF CLAUSE ENDS
                                            **************************************************************************/
                         
                          
                        
                        
                        
            }    
            catch(Exception e)
            {
                                                                utilClass.createErrorLog
                                                                     (
                                                                     'updateOtherObjectsAfterConversion',
                                                                     'updateOtherObjectsAfterConversion',
                                                                     ld.Id + ' - ERRLOC:' + errLoc + ' - ' + e.getMessage()
                                                                     );         
                throw e;
            }
        }
        //Code added for SR# INC000008227994 ATR RMU TOOL Start
        
        if( Trigger.isInsert && Userinfo.getUserId()==label.ATR_API_User_id)
        {
                List<AccountTeamMember> lstAccTM = new List<AccountTeamMember>();
                lstAccTM = mapacctteam.get(mapAccId.get(ld.id)).AccountTeamMembers;                 
                if(lstAccTM.size()>0){
                    strOwnerName = lstAccTM[0].user.name;
                    for(AccountTeamMember atm: lstAccTM ){
                        if(atm.TeamMemberRole=='Customer Business Manager (CBM)')
                             toAddresses.add(atm.user.Email);  
                    }                                       
                    
                }else
                {
                    strOwnerName = 'Carrie Kendrick';
                    toAddresses.add(label.ATR_Default_Owner_emailid);  
                }
                // Comment this while moving to Prod
                /*toAddresses.add('anusuya.murugiah@nttdata.com');
                toAddresses.add('Adam.Olshansky@Honeywell.com');
                */
                // Comment this while moving to Prod
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String subject='Lead assigned to you, Please review';
                String body='<style>.fontlabel{'+
                'font-family:Arial, Helvetica, sans-serif;'+
                'color:#333;'+
                'font-size:74%;'+
                '}'+
                '.fontlabelred'+
                '{'+
                '    font-family:Arial, Helvetica, sans-serif;'+
                '    color:red;'+
                '    font-size:74%;'+
                '}'+
                '.fontlabelblue'+
                '{'+
                '    font-family:Arial, Helvetica, sans-serif;'+
                '    color:blue;'+
                '    font-size:74%;'+
                '}'+
                '.tablewithbottomborder'+
                '{'+
                 '   border-bottom:3px solid #e39321;'+
                '}'+
                '.tablewiththreesideborder'+
               ' {'+
                  '  border-top:1px solid #e39321;'+
                  '  border-bottom:1px solid #e39321;'+
                  '  font-family:Arial, Helvetica, sans-serif;'+
                 '   color:#333;'+
                '    font-size:100%;'+
               ' }'+
               ' </style>'+
               ' <table  width=100%>'+
                   ' <tr>'+
                        '<td class=fontlabel>'+
                            'Dear '+ strOwnerName +', <br><br>'+
                            'Lead is assigned to you, please review.'+
                            '<br><br>'+                
                                '<table width=100% class="tablewiththreesideborder" cellspacing=0 cellpadding=0>'+
                               ' <tr> <td height=25 colspan=2 ><br></td></tr>'+                
                               ' <tr> <td height=25 colspan=2 bgcolor="#eeeeee"><b>Lead Details</b></td></tr>'+
                               ' <tr> <td height=30><b>Lead Number</b> </td>'+                                                              
                              '  <td> <a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ld.Id+'>'+ld.Lead_Number__c+'</a></td> </tr>'+
                              ' <tr> <td height=30><b>Name</b> </td>'+                                                              
                              '  <td> '+ld.FirstName+' '+ld.LastName+'</td> </tr>'+                
                             '   </table> '+           
                            '<br><br>'+                
                            'Thank you,<br>Honeywell Flight Support Services'+                
                            '<br><br></td></tr></table>';        
                body=body+'</table></body></html>';       
                message.setSubject(subject);
                message.setHtmlBody(body);                
                if(toAddresses.size()>0)
                    message.setToAddresses(toAddresses);                
                message.setBccSender(false);
                message.setUseSignature(false);
                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                message.setSaveAsActivity(false); 
                
                bulkEmails.add(message);  
        }
        //Code added for SR# INC000008227994 ATR RMU TOOL End
    }
    //Code added for SR# INC000008227994 ATR RMU TOOL Start
    if(!(Test.isRunningTest()))
    {
        Messaging.reserveSingleEmailCapacity(trigger.size);
        Messaging.sendEmail(bulkEmails);    
    } 
    //Code added for SR# INC000008227994 ATR RMU TOOL End

}