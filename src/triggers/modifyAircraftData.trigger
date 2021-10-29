/**
*   Thsi Trigger is used to update some the fields in Fleet Assert object
 *  OWNED BY THE CRM SALES TEAM.
 */
trigger modifyAircraftData on Fleet_Asset_Detail__c (before insert, before update)
{
    String tmpId;
    Set<Id> airbaseid = new Set<Id>();

    try{
        for(Fleet_Asset_Detail__c arcrft : Trigger.new){
            System.debug('The Account is------>'+arcrft.Account_SBU__c);
            if(arcrft.AMSTAT_base_ICAO__c != null && arcrft.Account_SBU__c == 'BGA'){
                airbaseid.add(arcrft.AMSTAT_base_ICAO__c);
            }else if(arcrft.Aircraft_Base__c != null){
                airbaseid.add(arcrft.Aircraft_Base__c);
            }
        }
        Map<Id,Aircraft_Base__c> vals=new Map<Id,Aircraft_Base__c>([SELECT Country__c,State__c,Region__c, Base_City__c, Base_ICAO__c, Base_IATA__c FROM Aircraft_Base__c WHERE Id IN:airbaseid]);
        Id profileId=UserInfo.getProfileId();
        String profileName=[SELECT Id,Name FROM Profile WHERE Id=:profileId].Name;
        for (Fleet_Asset_Detail__c arcrft : Trigger.new){
            tmpId = arcrft.Id;
            if(arcrft.Tail_reg_num_without_hypen__c != null){
                arcrft.Tail_Number__c = arcrft.Tail_Number__c.toUpperCase()    ;
                //  arcrft.Tail_reg_num_without_hypen__c = arcrft.Tail_Number__c.replace('-','')  ;
            }
            /*
            * Code modified by varun nirala on 24/Aug/2010
            * 1) Aircraft_Make__c  replaced  to Make__c
            * 2) Aircraft_Model__c replaced  to Model__c
            *
            */

            arcrft.Name =
                    (   arcrft.Make__c                  ==  null? '<Make>'  : arcrft.Make__c                    )
                            +' '      + (   arcrft.Model__c                 ==  null? '<Model>' : arcrft.Model__c                   )
                            /*@siva commented tail number SFINTRF enhancement project requested by Ed Babcock*/
                            //+' T='    + (   arcrft.Tail_reg_num_without_hypen__c           ==  null? '<Tail>'  : arcrft.Tail_reg_num_without_hypen__c )
                            +' S='    + (   arcrft.Serial_Number__c       ==  null? '<Serial>': arcrft.Serial_Number__c         )
                    ;

            if(arcrft.Name.length() > 80){
                arcrft.Name = arcrft.Name.substring(0,80);
            }
            if(arcrft.AMSTAT_base_ICAO__c != null && arcrft.Account_SBU__c == 'BGA'){
                if(vals.get(arcrft.AMSTAT_base_ICAO__c).Country__c != null){
                    arcrft.Country1__c=vals.get(arcrft.AMSTAT_base_ICAO__c).Country__c;
                }
                if(vals.get(arcrft.AMSTAT_base_ICAO__c).State__c != null){
                    arcrft.States__c=vals.get(arcrft.AMSTAT_base_ICAO__c).State__c;
                }
                if(vals.get(arcrft.AMSTAT_base_ICAO__c).Region__c != null){
                    arcrft.Region1__c=vals.get(arcrft.AMSTAT_base_ICAO__c).Region__c;
                }
                if(vals.get(arcrft.AMSTAT_base_ICAO__c).Base_City__c != null){
                    arcrft.Base_City1__c = vals.get(arcrft.AMSTAT_base_ICAO__c).Base_City__c;
                }
                if(vals.get(arcrft.AMSTAT_base_ICAO__c).Base_IATA__c != null){
                    arcrft.Base_IATA1__c = vals.get(arcrft.AMSTAT_base_ICAO__c).Base_IATA__c;
                }
                if(vals.get(arcrft.AMSTAT_base_ICAO__c).Base_ICAO__c != null){
                    arcrft.Base_ICAO1__c = vals.get(arcrft.AMSTAT_base_ICAO__c).Base_ICAO__c;
                }
                arcrft.Aircraft_Base__c = arcrft.AMSTAT_base_ICAO__c;
            }
            else if(arcrft.Aircraft_Base__c != null){
                if(vals.get(arcrft.Aircraft_Base__c).Country__c != null){
                    arcrft.Country1__c=vals.get(arcrft.Aircraft_Base__c).Country__c;
                }
                if(vals.get(arcrft.Aircraft_Base__c).State__c != null){
                    arcrft.States__c=vals.get(arcrft.Aircraft_Base__c).State__c;
                }
                if(vals.get(arcrft.Aircraft_Base__c).Region__c != null){
                    arcrft.Region1__c=vals.get(arcrft.Aircraft_Base__c).Region__c;
                }
                if(vals.get(arcrft.Aircraft_Base__c).Base_City__c != null){
                    arcrft.Base_City1__c = vals.get(arcrft.Aircraft_Base__c).Base_City__c;
                }
                if(vals.get(arcrft.Aircraft_Base__c).Base_IATA__c != null){
                    arcrft.Base_IATA1__c = vals.get(arcrft.Aircraft_Base__c).Base_IATA__c;
                }
                if(vals.get(arcrft.Aircraft_Base__c).Base_ICAO__c != null){
                    arcrft.Base_ICAO1__c = vals.get(arcrft.Aircraft_Base__c).Base_ICAO__c;
                }
            }
            // if(arcrft.Aircraft_Base__c == null && (arcrft.Base_City1__c == '' || arcrft.Country1__c == '' || arcrft.Base_ICAO1__c == '' || arcrft.States__c == '')){
            if(arcrft.Aircraft_Base__c == null && arcrft.Admin__c == false ){
                arcrft.Country1__c= null;
                arcrft.Base_City1__c = null;
                arcrft.States__c= null;
                //arcrft.Admin__c = false;
                arcrft.Region1__c= null;
                arcrft.Base_IATA1__c = null;
                System.debug(arcrft+'profile Name >> '+profileName);
                //if(profileName != 'System Administrator' && profileName != 'Sales Developer')
                if(arcrft.Admin__c == false){
                    //System.Debug(arcrft+'111111111'+profileName);
                    arcrft.Base_City1__c = null;
                    arcrft.Country1__c= null;
                    arcrft.Base_ICAO1__c = null;
                    arcrft.States__c= null;
                }
            }
            /* if(arcrft.Aircraft_Base__c == null && (arcrft.Base_City1__c != '' || arcrft.Country1__c != '' || arcrft.Base_ICAO1__c != '' || arcrft.States__c != '')){
                 if(profileName == 'System Administrator'){
                     System.Debug(arcrft+'222222222'+profileName);
                     arcrft.Base_City1__c = arcrft.Base_City1__c;
                     arcrft.Country1__c = arcrft.Country1__c;
                     arcrft.Base_ICAO1__c = arcrft.Base_ICAO1__c;
                     arcrft.States__c= arcrft.States__c;
                 }
             }*/
        }

        List<BGA_Area_Contacts__c> BSA_Contacts = BGA_Area_Contacts__c.getAll().values();
      //  List<Inside_Sales__c> Inside_Sales = Inside_Sales__c.getall().values();
        for (Fleet_Asset_Detail__c arcrft : Trigger.new){
            System.debug('arcrft.Cntry1__c value:'+arcrft.Country1__c);
            System.debug('arcrft.State__c value:'+arcrft.States__c);
            arcrft.BGA_ASM__c = null;
            Boolean matchingfound = false;
            Map<String,String> matchingUser = new Map<String,String>();
            for(BGA_Area_Contacts__c var : BSA_Contacts){
                if(var.Aircraft_Code__c != null && var.Aircraft_Code__c.equalsIgnoreCase(arcrft.Base_ICAO__c)){
                    matchingUser.put('aircraftcode',var.SFDC_ID__c);
                }else if((var.State__c != null && var.State__c.equalsIgnoreCase(arcrft.States__c))
                        && (var.City__c != null && var.City__c.equalsIgnoreCase(arcrft.Base_City1__c)) &&
                        ((var.Country__c != null && var.Country__c.equalsIgnoreCase(arcrft.Country1__c)) ||
                                (var.Country__c != null && (arcrft.Country1__c== 'USA' || arcrft.Country1__c== 'UNITED STATES') && (var.Country__c.equalsIgnoreCase('USA') || var.Country__c.equalsIgnoreCase('UNITED STATES') || var.Country__c.equalsIgnoreCase('US') || var.Country__c.equalsIgnoreCase('Canada'))))){
                    matchingUser.put('statecitycontry',var.SFDC_ID__c);
                }else if((var.State__c != null && var.State__c.equalsIgnoreCase(arcrft.States__c)) &&
                        ((var.Country__c != null && var.Country__c.equalsIgnoreCase(arcrft.Country1__c)) ||
                                (var.Country__c != null && (arcrft.Cntry__c == 'USA' || arcrft.Country1__c== 'UNITED STATES') && (var.Country__c.equalsIgnoreCase('USA') || var.Country__c.equalsIgnoreCase('UNITED STATES') || var.Country__c.equalsIgnoreCase('US') || var.Country__c.equalsIgnoreCase('Canada'))))){
                    matchingUser.put('statecontry',var.SFDC_ID__c);
                }else if((var.Country__c != null && var.Country__c.equalsIgnoreCase(arcrft.Country1__c)) ||
                        (var.Country__c != null && (arcrft.Cntry__c == 'USA' || arcrft.Country1__c== 'UNITED STATES') && (var.Country__c.equalsIgnoreCase('USA') || var.Country__c.equalsIgnoreCase('UNITED STATES') || var.Country__c.equalsIgnoreCase('US') || var.Country__c.equalsIgnoreCase('Canada')))){
                    matchingUser.put('contry',var.SFDC_ID__c);
                }
                Boolean temp1 = false;
                if((var.State__c != null && var.State__c.equalsIgnoreCase(arcrft.States__c))){
                    temp1 = true;
                }

            }
            String sfdctId = null;
            if(matchingUser.get('aircraftcode') != null){
                sfdctId = matchingUser.get('aircraftcode');
            }else if(matchingUser.get('statecitycontry') != null){
                sfdctId = matchingUser.get('statecitycontry');
            }else if(matchingUser.get('statecontry') != null){
                sfdctId = matchingUser.get('statecontry');
            }else if(matchingUser.get('contry') != null){
                sfdctId = matchingUser.get('contry');
            }
            System.debug('BGA ASM >> '+arcrft.BGA_ASM__c );

            if(sfdctId != null && sfdctId.indexOf(';')>-1){
                arcrft.BGA_ASM__c = sfdctId.substring(0, sfdctId.indexOf(';'));
            }else{
                arcrft.BGA_ASM__c = sfdctId;
            }
            /* Check Country, Region and State and update inside sales value */
            /*for(Inside_Sales__c varis : Inside_Sales){
                if(varis.Country__c == arcrft.Cntry__c  && varis.Region__c == arcrft.Region__c && varis.State__c == arcrft.State__c){
                    arcrft.Inside_Sales__c = varis.SFDC_Id__c;
                }
            }*/
        }
    }
    catch(Exception e) {
        System.debug('Exception message:'+e.getMessage());
        System.debug('Exception Line#:'+e.getLineNumber());
        /*utilClass.createErrorLog
         (
         'modifyAircraftData',
         'modifyAircraftData',
         'errLoc - ' + errLoc + ' - ' + tmpId + ' - ' + e.getMessage()
         );   */

    }
}