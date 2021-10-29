/*****************************************************
Name         : CaseEscalationForHolds
Test Class	 : CaseEscalationForHolds_Test
Created By   : Divija S
Created Date : 11-02-2021
Usages       : This Class is used to send escalation emails automatically based on escalation levels.  
*****************************************************/
public class CaseEscalationForHolds {
   public static Map<id, list<String>> Toaddrmap = new Map<id, list<String>>();
   public static Map<Id, Integer> Nodays = new Map<Id, Integer>();
   public static Map<Id, String> Automation = new Map<Id, String>();
   public static Map<id, String> MaxLevel = new Map<id, String>();
   public static list<Task> tsklst = new list<Task>();
   public static list<String> emailaddrlst = new list<String>();
   public static void setEscalationLevel(list<case> newcaslst, Map<ID,Case> newMap, Map<ID,Case> oldMap){
       String EscalatedLevel;
       for(Case cs: newcaslst){
           String Casrectype = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.recordtypeid).getname();
		   System.debug('Casrectype'+Casrectype);
           String oldsubstatus = oldMap.get(cs.id).Sub_Status__c;
           String oldescalatedto = oldMap.get(cs.id).VN_Name__c;
           String CasCom = oldMap.get(cs.id).Case_Comments__c;
           String EscLevel = oldMap.get(cs.id).Escalation_Level__c; 
           System.debug('oldsubstatus::'+oldsubstatus);
           System.debug('EscLevel::'+EscLevel);
           System.debug('cs.Escalated__c::'+cs.Escalated__c);
           map<String, String> Subreasonmap = new map<String, String>();
           Map<String, String> Idowneridmap = new Map<String, String>();
       /*if((cs.Status == 'On Hold') && cs.Escalated__c == true && (cs.Sub_Status__c == oldsubstatus) && cs.Due_Date__c == System.today()){
           if(EscLevel == 'Escalation 1'){
               cs.Escalation_Level__c = 'Escalation 2';
               cs.Email_Subject_Value__c = 'ESCALATION 2';
              // if(cs.Case_Comments__c == null)
               	//	cs.Case_Comments__c = CasCom;
           }
           else if(EscLevel == 'Escalation 2'){
               cs.Escalation_Level__c = 'Escalation 3';
               cs.Email_Subject_Value__c = 'ESCALATION 3';
           }
           else if(EscLevel == 'Escalation 3'){
               cs.Escalation_Level__c = 'Escalation 4';
               cs.Email_Subject_Value__c = 'ESCALATION 4';
           }
          /* else if(EscLevel == 'Escalation 4'){
               cs.Escalated__c = True;
           }
       }
       else */
           if((cs.Status == 'On Hold') && (cs.Sub_Status__c != oldsubstatus) && String.isNotBlank(cs.Case_Comments__c)){
           if(cs.Escalated__c == true){
               cs.Escalated__c = false;
           }
           System.debug('enterd first escalation');
           cs.Escalation_Level__c = 'Escalation 1';
           //cs.Email_Subject_Value__c = 'ACTION REQUIRED';
           cs.Max_Escalation_Level_Reach__c = '';
           Id escalatedtoid;
           Map<Id, Id> escaaltedtoMap = new Map<Id, Id>();
           escaaltedtoMap = getescalatedtoval(newMap.values());
           System.debug('escaaltedtoMap::'+escaaltedtoMap);
           escalatedtoid = escaaltedtoMap.get(cs.Id);
           System.debug('escalatedtoid::'+escalatedtoid);
           System.debug('cs.VN_Name__c::'+cs.VN_Name__c);
           System.debug('Automation=='+Automation);
            if(escalatedtoid != null){
           			cs.VN_Name__c = escaaltedtoMap.get(cs.id);
               }
           if(Automation.get(cs.id) == 'yes'){
               cs.Pega_Reason_for_Hold__c = 'Yes';
           }
           else{
               cs.Pega_Reason_for_Hold__c = 'No';
           }
           if(String.isBlank(Automation.get(cs.id))){
               cs.Escalation_Level__c = '';
               cs.Escalated_On__c = null;
               cs.Escalated__c = false;
           }
	    }
       }
   }
    //public static id getescalatedtoval(String Esclevel, String HonPlant, String rectype, String Reason, String Substatus, Id Casid){
    public static Map<id, id> getescalatedtoval(list<Case> caslsts){
        list<Escalations_and_Holds__c> sde = new list<Escalations_and_Holds__c>();
        list<SharePoint_Site_Data__c> ssdq = new list<SharePoint_Site_Data__c>();
        Map<String, list<SharePoint_Site_Data__c>> ssdmap = new Map<String, list<SharePoint_Site_Data__c>>();
        String escalatedtoval;
        Map<Id, Id> retval = new Map<Id, Id>();
        Map<String,String> HonPlant = new Map<String,String>();
        Map<String,String> rectype = new Map<String,String>();
        Map<String,String> Reason = new Map<String,String>();
        Map<String,String> Substatus = new Map<String,String>();
        Map<String,String> Ownrid = new Map<String,String>();
        Map<String,String> Acct = new Map<String,String>();
        Map<String,String> Maxesc = new Map<String,String>();
        Map<String,String> altmbrlst = new Map<String,String>();
        list<String> idlist = new list<String>();
        list<User> uss = new list<User>();
        for(Case cas: caslsts){
            if(cas.Hon_Plant_Code_del__c != null)
                HonPlant.put(cas.id, cas.Hon_Plant_Code_del__c);
            if(cas.Status == 'On Hold'){
                Substatus.put(cas.id, cas.Sub_Status__c);
            	Reason.put(cas.id, cas.Reason_for_hold__c);
            }
            Ownrid.put(cas.id, cas.OwnerId);
            Acct.put(cas.id, cas.AccountId);
            Maxesc.put(cas.id, cas.Max_Escalation_Level_Reach__c);
            rectype.put(cas.id, Schema.SObjectType.Case.getRecordTypeInfosById().get(cas.recordtypeid).getname());
        }
        //System.debug('Esclevel::'+Esclevel);
        System.debug('rectype::'+rectype);
        System.debug('Reason::'+Reason);
        System.debug('Substatus::'+Substatus);
        System.debug('Maxesc::'+Maxesc);
        //Case cs = [Select id, Hon_Plant_Code_del__c, Reason_for_hold__c, Sub_Status__c, OwnerId];
        sde = [Select Case_Type__c, Automate__c, Lev2_Followup_Calendar_Days__c, Lev3_Followup_Calendar_Days__c,
                     Lev4_Followup_Calendar_Days__c, Level_1_POC__c, Level_1_Source__c, Level_2_POC__c, Level_2_Source__c,
                     Level_3_POC__c, Level_3_Source__c, Level_4_POC__c, Level_4_Source__c, Reason_for_Hold__c, Sub_Status__c,
                     Template_Name__c from Escalations_and_Holds__c where (Automate__c = 'yes' AND Sub_Status__c IN: Substatus.values() AND
                                                                                    Reason_for_Hold__c IN: Reason.values()
                                                                                    AND Case_Type__c IN: rectype.values())];
        	   System.debug('sde::'+sde);
        /*alt = [Select id, Name, Alt_Member__c, Alt_Member_Email__c from ALT_Leadership__c];
        	   System.debug('alt::'+alt);
        for(ALT_Leadership__c altt: alt){
            altmbrlst.add(altt.Alt_Member_Email__c);
        }*/
        if(!(sde.isempty())){ 
        GROUP grp = [Select (Select UserOrGroupId from groupMembers) FROM group where name = 'Alt Leadership'];
        System.debug('grp::'+grp);
        for(GroupMember gpm: grp.groupMembers){
            idlist.add(gpm.UserOrGroupId);
        }
        uss = [Select email from User where id IN: idlist];
        for(User usr: uss){
            emailaddrlst.add(usr.email);
        }
        	String query;
            list<String> honplantvals = new list<String>();
            for(Escalations_and_Holds__c esh: sde){
             if(esh.Level_1_Source__c != null && esh.Level_1_Source__c.containsIgnoreCase('sharepoint')){
                   honplantvals =  HonPlant.values();
                   System.debug('honplantvals::'+honplantvals);
                   query = 'Select Site_Code__c, Record_Type__c, Level_1_ISC_Help_Mailbox__c, Level_2_Mailbox_Manager__c,Level_3_Site_Leader__c, Level_4_Op_VP_and_C_PS_VP__c, OpEx_Leader__c, Past_Due_Contact__c,PRO_Contact__c, Quality_Contact__c, Quality_Director__c, Site_Leader__c,Site_Quality_Leader__c, TAT_Contact__c, VP_Quality_Team__c from SharePoint_Site_Data__c where Site_Code__c IN: honplantvals';
                  }
            }
            if(honplantvals.size()>0){
            	ssdq = database.query(query);
            System.debug('ssdq::'+ssdq);
            for(SharePoint_Site_Data__c sdc: ssdq){
               list<SharePoint_Site_Data__c> sdclsth = new list<SharePoint_Site_Data__c>();
                if(ssdmap.keySet().contains(sdc.Site_Code__c)){
                   sdclsth = ssdmap.get(sdc.Site_Code__c);
                   sdclsth.add(sdc);
                   System.debug('sdclsth::'+sdclsth);
                }
                else{
                  sdclsth.add(sdc);
                  System.debug('sdclsth::'+sdclsth);
                }
               ssdmap.put(sdc.Site_Code__c, sdclsth);
            }
            }
            System.debug('ssdmap::'+ssdmap);
            		for(Case cs: caslsts){
                        System.debug('cs::'+cs);
                       for(Escalations_and_Holds__c eshs: sde){
                           System.debug('eshs::'+eshs);
                           if(eshs.Sub_Status__c == cs.Sub_Status__c && eshs.Reason_for_Hold__c == cs.Reason_for_hold__c && eshs.Case_Type__c == rectype.get(cs.id)){
                           list<String> Toaddr = new list<String>();
                           list<SharePoint_Site_Data__c> ssd = new list<SharePoint_Site_Data__c>();
        				   list<SharePoint_Site_Data__c> ssd2 = new list<SharePoint_Site_Data__c>();
        				   list<SharePoint_Site_Data__c> ssd3 = new list<SharePoint_Site_Data__c>();
        				   if(eshs.Level_1_Source__c != null && eshs.Level_1_Source__c.containsIgnoreCase('sharepoint')){
                           if(!(ssdmap.isempty())){
                       for(SharePoint_Site_Data__c ssdc: ssdmap.get(cs.Hon_Plant_Code_del__c)){
                       if(ssdc.Record_Type__c == 'Repair & Overhaul'){
                           ssd2.add(ssdc);
                       }
                       else{
                           ssd3.add(ssdc);    
                       }
                       }
                       if(rectype.get(cs.id) == 'Repair & Overhaul')
                          ssd = ssd2;        
                       else
                          ssd = ssd3;
                       System.debug('ssd::'+ssd);
                       if(!(ssd.isempty())){
                       if(cs.Escalation_Level__c == 'Escalation 1'){
                       System.debug('Entered Level 1');
                       //System.debug('ssd[0].Level_1_ISC_Help_Mailbox__c::'+ssd[0].Level_1_ISC_Help_Mailbox__c);
                       if(ssd[0].Level_1_ISC_Help_Mailbox__c != null && eshs.Level_1_POC__c != null && eshs.Level_1_POC__c == 'ISC Mailbox per site'){
                           System.debug('Entered if cond.');
                       if(ssd[0].Level_1_ISC_Help_Mailbox__c.contains(';')){
                           //escalatedtoval = ssd[0].Level_1_ISC_Help_Mailbox__c.split(';');
                       String[] str2 = ssd[0].Level_1_ISC_Help_Mailbox__c.split(';');
                           System.debug('str2::'+str2);
                           for(String st: str2){
                               Toaddr.add(st);
                               escalatedtoval =st;
                               System.debug('escalatedtoval::'+escalatedtoval);
                           }
                           Toaddrmap.put(cs.Id, Toaddr);
                       }else{
                       	   escalatedtoval = ssd[0].Level_1_ISC_Help_Mailbox__c;
                           Toaddr.add(escalatedtoval);
                           Toaddrmap.put(cs.Id, Toaddr);
                           System.debug('escalatedtoval::'+escalatedtoval);
                       }
                       }
                       else if(String.isNotBlank(eshs.Level_1_POC__c)){
                           if(eshs.Level_1_POC__c == 'Quality Contact'){
                               System.debug('Entered If here!');
                               System.debug('ssd[0].Quality_Contact__c::'+ssd[0].Quality_Contact__c);
                           if(ssd[0].Quality_Contact__c.contains(';')){
                               System.debug('entering...');
                           //escalatedtoval = ssd[0].Level_1_ISC_Help_Mailbox__c.split(';');
                       	   String[] str2 = ssd[0].Quality_Contact__c.split(';');
                               System.debug('str2::'+str2);
                           for(String st: str2){
                               Toaddr.add(st);
                               escalatedtoval =st;
                               system.debug('Toaddrhere:'+Toaddr);
                               System.debug('escalatedtoval::'+escalatedtoval);
                           }
                           Toaddrmap.put(cs.Id, Toaddr);
                       }else{
                           System.debug('Entered Else here!');
                       escalatedtoval = ssd[0].Quality_Contact__c;
                       Toaddr.add(ssd[0].Quality_Contact__c);
                       Toaddrmap.put(cs.Id, Toaddr);
                       }
                       }
                       }
                       Contact ct = new Contact();
                       try{
                       ct = [Select id, email from Contact where email =: escalatedtoval];
                       System.debug('ct:::'+ct);
                       if(ct != null){
                               retval.put(cs.Id, ct.Id);
                           }
                       }
                       catch(Exception E){
                       	createtaskforerror(cs.id, Ownrid.get(cs.id), 'No Contact or Duplicate Contacts found');
                       }
                       if(Integer.valueOf(eshs.Lev2_Followup_Calendar_Days__c) != null){
                           Integer ndays = Integer.valueOf(eshs.Lev2_Followup_Calendar_Days__c);
                           Nodays.put(cs.Id, ndays);
                        }
                      }
                   else if(cs.Escalation_Level__c == 'Escalation 2'){
                       list<String> toad = new list<String>();
                       if(String.isNotBlank(ssd[0].Level_2_Mailbox_Manager__c) && eshs.Level_2_POC__c == 'Mailbox Manager'){
                       if(ssd[0].Level_2_Mailbox_Manager__c.contains(';')){
                       toad = ssd[0].Level_2_Mailbox_Manager__c.split(';');
                           System.debug('toad--->'+toad);
                       }
                       else{
                       toad.add(ssd[0].Level_2_Mailbox_Manager__c);
                       }
                       if(toad != null){
                           System.debug('Toaddr--->'+Toaddr);
                           for(String Toadr: toad){
                               System.debug('emailaddrlst'+emailaddrlst);
                               if(emailaddrlst.contains(Toadr)){
                                   System.debug('Inside If here');
                                   if(ssd[0].Level_1_ISC_Help_Mailbox__c.contains(';'))
                                        Toaddr = ssd[0].Level_1_ISC_Help_Mailbox__c.split(';');
                                   else
                                   		Toaddr.add(ssd[0].Level_1_ISC_Help_Mailbox__c);
                                   Toaddrmap.put(cs.id, Toaddr);
                                   MaxLevel.put(cs.id, 'Escalation 1');
                                }
                               else{
                                   Toaddr.add(Toadr);
                               	   Toaddrmap.put(cs.id, Toaddr);
                               }
                           }
                       }
                           System.debug('Toaddr:::'+Toaddr);
                           System.debug('Toaddrmap::'+Toaddrmap);
                       }
                       else if(String.isNotBlank(eshs.Level_2_POC__c)){
                           if(eshs.Level_2_POC__c == 'Site Quality Leader' || eshs.Level_2_POC__c == 'Site Quality Team Leader'){
                               if(ssd[0].Site_Quality_Leader__c.contains(';')){
                       			toad = ssd[0].Site_Quality_Leader__c.split(';');
	                       }
                      	  else{
                       		toad.add(ssd[0].Site_Quality_Leader__c);
                       	  }
                         }
                         if(toad != null){
                           System.debug('Toaddr--->'+Toaddr);
                           for(String Toadr: toad){
                               System.debug('emailaddrlst'+emailaddrlst);
                               if(emailaddrlst.contains(Toadr)){
                                   System.debug('Inside If here');
                                   if(ssd[0].Quality_Contact__c.contains(';')){
                                        Toaddr = ssd[0].Quality_Contact__c.split(';');
                                   		Toaddrmap.put(cs.Id, Toaddr);
                                   }
                                   else{
                                   		Toaddr.add(ssd[0].Quality_Contact__c);
                                   		Toaddrmap.put(cs.Id, Toaddr);
                                   }
                                   MaxLevel.put(cs.id, 'Escalation 1');
                                }
                               else{
                                   Toaddr.add(Toadr);
                               	   Toaddrmap.put(cs.Id, Toaddr);
                               }
                           }
                       }
                       }
                       if(Integer.valueOf(eshs.Lev3_Followup_Calendar_Days__c) != null){
                        	Integer ndays = Integer.valueOf(eshs.Lev3_Followup_Calendar_Days__c);
                            Nodays.put(cs.id, ndays);
                        }
                       //retval = Toaddr;
                   }
                   else if(cs.Escalation_Level__c == 'Escalation 3'){
                       list<String> toad = new list<String>();
                       if(String.isNotBlank(ssd[0].Level_3_Site_Leader__c) && eshs.Level_3_POC__c == 'Site Leader'){
                       if(ssd[0].Level_3_Site_Leader__c.contains(';')){
                       toad = ssd[0].Level_3_Site_Leader__c.split(';');
                           System.debug('toad--->'+toad);
                       }
                       else{
                       toad.add(ssd[0].Level_3_Site_Leader__c);
                       }
                       if(toad != null){
                           System.debug('Toaddr--->'+Toaddr);
                           for(String Toadr: toad){
                               System.debug('emailaddrlst'+emailaddrlst);
                               if(emailaddrlst.contains(Toadr) && Maxesc.get(cs.id) == null){
                                   System.debug('Inside If here');
                                   if(ssd[0].Level_2_Mailbox_Manager__c.contains(';')){
                                        Toaddr = ssd[0].Level_2_Mailbox_Manager__c.split(';');
                                   		Toaddrmap.put(cs.id, Toaddr);
                                   }
                                   else{
                                   		Toaddr.add(ssd[0].Level_2_Mailbox_Manager__c);
                                   		Toaddrmap.put(cs.id, Toaddr);
                                   }
                                   MaxLevel.put(cs.id, 'Escalation 2');
                                }
                               else if(Maxesc.get(cs.id) == 'Escalation 1'){
                                   System.debug('emailaddrlst'+emailaddrlst);
                                   if(ssd[0].Level_1_ISC_Help_Mailbox__c.contains(';')){
                                        Toaddr = ssd[0].Level_1_ISC_Help_Mailbox__c.split(';');
                                   		Toaddrmap.put(cs.id, Toaddr);
                                   }
                                   else{
                                   		Toaddr.add(ssd[0].Level_1_ISC_Help_Mailbox__c);
                                   		Toaddrmap.put(cs.id, Toaddr);
                                   }
                                   MaxLevel.put(cs.id, 'Escalation 1');
                               }
                               else{
                                   Toaddr.add(Toadr);
                               		Toaddrmap.put(cs.id, Toaddr);
                               }
                           	  }
                       }
                       }
                       else if(String.isNotBlank(eshs.Level_3_POC__c)){
                           if(eshs.Level_3_POC__c == 'Quality Director'){
                               if(ssd[0].Quality_Director__c.contains(';')){
                       			toad = ssd[0].Quality_Director__c.split(';');
                       			}
                       			else{
                       				toad.add(ssd[0].Quality_Director__c);
                       			}
                           if(toad != null){
                           System.debug('Toaddr--->'+Toaddr);
                           for(String Toadr: toad){
                               System.debug('emailaddrlst'+emailaddrlst);
                               if(emailaddrlst.contains(Toadr) && Maxesc.get(cs.id) == null){
                                   System.debug('Inside If here');
                                   if(ssd[0].Site_Quality_Leader__c.contains(';')){
                                        Toaddr = ssd[0].Site_Quality_Leader__c.split(';');
                                   		Toaddrmap.put(cs.Id, Toaddr);
                                   }
                                   else{
                                   		Toaddr.add(ssd[0].Site_Quality_Leader__c);
                                   		Toaddrmap.put(cs.Id, Toaddr);
                               		}
                                   MaxLevel.put(cs.Id, 'Escalation 2');
                                }
                               else if(Maxesc.get(cs.id) == 'Escalation 1'){
                                   System.debug('emailaddrlst'+emailaddrlst);
                                   if(ssd[0].Quality_Contact__c.contains(';')){
                                        Toaddr = ssd[0].Quality_Contact__c.split(';');
                                   		Toaddrmap.put(cs.Id, Toaddr);
                                   }
                                   else{
                                   		Toaddr.add(ssd[0].Quality_Contact__c);
                                   		Toaddrmap.put(cs.Id, Toaddr);
                                   }
                                   MaxLevel.put(cs.id, 'Escalation 1');
                               }
                               else{
                                   Toaddr.add(Toadr);
                                   Toaddrmap.put(cs.Id, Toaddr);
                               }
                           	  }
                       		}
                           }
                       }
                       if(Integer.valueOf(eshs.Lev4_Followup_Calendar_Days__c) != null){
                            Integer Ndays = Integer.valueOf(eshs.Lev4_Followup_Calendar_Days__c);
                        	Nodays.put(cs.Id, Ndays);
                        }
                       //retval = Toaddr;
                   }
                    else if(cs.Escalation_Level__c == 'Escalation 4'){
                       list<String> toad = new list<String>();
                       if(String.isNotBlank(ssd[0].Level_4_Op_VP_and_C_PS_VP__c) && eshs.Level_4_POC__c == 'Op VP and C&PS VP'){
                       if(ssd[0].Level_4_Op_VP_and_C_PS_VP__c.contains(';')){
                       toad = ssd[0].Level_4_Op_VP_and_C_PS_VP__c.split(';');
                       }
                       else{
                       toad.add(ssd[0].Level_4_Op_VP_and_C_PS_VP__c);
                       }
                           if(toad != null){
                           System.debug('Toaddr--->'+Toaddr);
                           for(String Toadr: toad){
                               System.debug('emailaddrlst'+emailaddrlst);
                               if(emailaddrlst.contains(Toadr) && Maxesc.get(cs.id) == null){
                                   System.debug('Inside If here');
                                   if(ssd[0].Level_3_Site_Leader__c.contains(';'))
                                        Toaddr = ssd[0].Level_3_Site_Leader__c.split(';');
                                   else
                                   		Toaddr.add(ssd[0].Level_3_Site_Leader__c);
                                   Toaddrmap.put(cs.Id, Toaddr);
                                   MaxLevel.put(cs.Id,'Escalation 3');
                                }
                               else if(Maxesc.get(cs.id) == 'Escalation 2'){
                                   System.debug('emailaddrlst'+emailaddrlst);
                                   if(ssd[0].Level_2_Mailbox_Manager__c.contains(';'))
                                        Toaddr = ssd[0].Level_2_Mailbox_Manager__c.split(';');
                                   else
                                   		Toaddr.add(ssd[0].Level_2_Mailbox_Manager__c);
                                   Toaddrmap.put(cs.Id, Toaddr);
                                   MaxLevel.put(cs.Id,'Escalation 2');
                               }
                               else if(Maxesc.get(cs.id) == 'Escalation 1'){
                                   System.debug('emailaddrlst'+emailaddrlst);
                                   if(ssd[0].Level_1_ISC_Help_Mailbox__c.contains(';'))
                                        Toaddr = ssd[0].Level_1_ISC_Help_Mailbox__c.split(';');
                                   else
                                   		Toaddr.add(ssd[0].Level_1_ISC_Help_Mailbox__c);
                                   Toaddrmap.put(cs.Id, Toaddr);
                                   MaxLevel.put(cs.Id,'Escalation 1');
                               }
                               else{
                                   Toaddr.add(Toadr);
                                   Toaddrmap.put(cs.Id, Toaddr);
                               }
                           	  }
                       }
                       }
                       else if(String.isNotBlank(eshs.Level_4_POC__c)){
                           if(eshs.Level_4_POC__c == 'VP Quality team'){
                               if(ssd[0].VP_Quality_Team__c.contains(';')){
                       			toad = ssd[0].VP_Quality_Team__c.split(';');
                       			}
                       			else{
                       				toad.add(ssd[0].VP_Quality_Team__c);
                       			}
                           if(toad != null){
                           System.debug('Toaddr--->'+Toaddr);
                           for(String Toadr: toad){
                               System.debug('emailaddrlst'+emailaddrlst);
                               if(emailaddrlst.contains(Toadr) && Maxesc.get(cs.id) == null){
                                   System.debug('Inside If here');
                                   if(ssd[0].Quality_Director__c.contains(';'))
                                        Toaddr = ssd[0].Quality_Director__c.split(';');
                                   else
                                   		Toaddr.add(ssd[0].Quality_Director__c);
                                   Toaddrmap.put(cs.id, Toaddr);
                                   MaxLevel.put(cs.id,'Escalation 3');
                                }
                               else if(Maxesc.get(cs.id) == 'Escalation 2'){
                                   System.debug('emailaddrlst'+emailaddrlst);
                                   if(ssd[0].Site_Quality_Leader__c.contains(';'))
                                        Toaddr = ssd[0].Site_Quality_Leader__c.split(';');
                                   else
                                   		Toaddr.add(ssd[0].Site_Quality_Leader__c);
                                   Toaddrmap.put(cs.Id, Toaddr);
                                   MaxLevel.put(cs.id, 'Escalation 2');
                               }
                               else if(Maxesc.get(cs.id) == 'Escalation 1'){
                                   System.debug('emailaddrlst'+emailaddrlst);
                                   if(ssd[0].Quality_Contact__c.contains(';'))
                                        Toaddr = ssd[0].Quality_Contact__c.split(';');
                                   else
                                   		Toaddr.add(ssd[0].Quality_Contact__c);
                                   Toaddrmap.put(cs.Id, Toaddr);
                                   MaxLevel.put(cs.Id,'Escalation 1');
                               }
                               else{
                                   Toaddr.add(Toadr);
                                   Toaddrmap.put(cs.Id, Toaddr);
                               }
                           	  }
                       		}
                           }
                       }
                       //retval = Toaddr
                   }
                   }
                   }
               }
        		else if(!(sde.isempty())){
                    System.debug('entered else');
                    list<String> errormsgs = new list<String>();
                    User usr = new User();
                    User usr1 = new User();
                    User usr2 = new User();
                    User usr3 = new User();
                    Account Acc = new Account();
                    try{
                    Acc = [Select id, name, Business_Focal__c, Business_Escalation__c, Business_Escalation__r.User_Primary_Manager_EID__c, Business_Escalation__r.User_Primary_Manager_Name__c
                                   from Account where id =: Acct.get(cs.id)];
                    }
                    catch(Exception E){
                        createtaskforerror(cs.id, Ownrid.get(cs.id), 'Issue with Case Account. Data Missing'+E.getMessage());
                    }
                    if(cs.Escalation_Level__c == 'Escalation 1' || cs.Escalation_Level__c == 'Escalation 2' || cs.Escalation_Level__c == 'Escalation 3' || cs.Escalation_Level__c == 'Escalation 4'){
                    if(Ownrid.get(cs.id).startsWith('00G')){
                		cs.adderror('Case Owner Cannot be Queue. It should be User for auto escalations');
            		}
                    else
                    	usr = [Select id, email, EmployeeNumber, Manager.email, ManagerId, Name from User where id =: Ownrid.get(cs.id)];
                    if(usr.ManagerId != null)
                    	usr1 = [Select id, Manager.email, EmployeeNumber, ManagerId, Name from User where Id =: usr.ManagerId];
                    if(usr1 != null && usr1.ManagerId != null)
                    	usr2 = [Select id, Manager.email, ManagerId, EmployeeNumber, Name from User where Id =: usr1.ManagerId];
                    if(usr2 != null && usr2.ManagerId != null)
                        usr3 = [Select id, Manager.email, ManagerId, EmployeeNumber, Name from User where Id =: usr2.ManagerId];
                    }
                       if(cs.Escalation_Level__c == 'Escalation 1' && String.isNotBlank(eshs.Level_1_POC__c)){
                        if((eshs.Level_1_Source__c == 'SFDC Account Business Focal') && (eshs.Level_1_POC__c == 'BUSINESS FOCAL')){
                            if(Acc != null && Acc.Business_Focal__c != null){
								retval.put(cs.id,Acc.Business_Focal__c); 
                                System.debug('escalatedtoval::'+retval);
                            }
                        }
                        else if(eshs.Level_1_Source__c == 'SFDC Case Owner') {
                            if(eshs.Level_1_POC__c == 'ASSIGNED CSR'|| eshs.Level_1_POC__c == 'CSR Name'){
                                 try{
                                     Contact ct = new Contact();
                                      ct = [Select id, email from Contact where Employee_Number__c =: usr.EmployeeNumber];
                                 	  retval.put(cs.id,ct.id);
                                }
                                catch(Exception E){
                                    createtaskforerror(cs.id, Ownrid.get(cs.id), 'Duplicate Contacts found');
                       		}
                            }
                            else{
                                try{
                                Contact Ct = [Select id, email, Name from Contact where Name =: eshs.Level_1_POC__c];
                                       retval.put(cs.id, ct.id);
                                }
                                catch(Exception E){
                                    createtaskforerror(cs.id, Ownrid.get(cs.id), 'No COntact or Duplicate Contacts found');
                       		     }
                            }
                        }
                        else if(eshs.Level_1_Source__c == 'SFDC Escalated To (Contact)' || eshs.Level_1_Source__c == 'SFDC Case Escalated To (Contact)' || sde[0].Level_1_POC__c != null){
                            System.debug('sde[0].Level_1_POC__c::'+eshs.Level_1_POC__c);
                            try{
                            	Contact ct = [Select id, Name, email from Contact where ((Name =: eshs.Level_1_POC__c) OR (email =: eshs.Level_1_POC__c))];
                                retval.put(cs.id,ct.id);
                                }
                                catch(Exception E){
                           				createtaskforerror(cs.id, Ownrid.get(cs.id), 'No Contact or Duplicate Contacts found');
                                }
                        }
                        //retval = Id.valueOf(escalatedtoval);
                       Contact ctc = new Contact();
                       try{
                        if(retval != null)
                        	ctc = [Select id, email from Contact where id =: retval.get(cs.id)];
                            System.debug('ctc:::'+ctc);
                       }
                       catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'Contact Not found');
                       }
                        if(ctc.Email != null){
                       	Toaddr.add(ctc.Email);
                        Toaddrmap.put(cs.id, Toaddr);
                        }
                       if(Integer.valueOf(eshs.Lev2_Followup_Calendar_Days__c) != null){
                       Integer ndays = Integer.valueOf(eshs.Lev2_Followup_Calendar_Days__c);
                       Nodays.put(cs.id, ndays); 
                       }
                    }
                    else if(cs.Escalation_Level__c == 'Escalation 2'){
                        list<String> strids = new list<String>();
        				list<String> stridesc1 = new list<String>();
        				if(eshs.Level_2_POC__c == 'BUSINESS FOCAL ESCALATION'){
                            strids.add(acc.Business_Escalation__c);
                            stridesc1.add(Acc.Business_Focal__c);
                        }
                        else if(eshs.Level_2_POC__c == 'T1 LEADER' || eshs.Level_2_POC__c == 'CSR Name'){
                            try{
                            System.debug('usr.Manager.email::'+usr.Manager.email);
                            Contact ct = [Select id, email from Contact where Employee_Number__c =: usr1.EmployeeNumber];  
                            strids.add(ct.id);
                            Contact ctesc1 = [Select id, email from Contact where Employee_Number__c =: usr.EmployeeNumber];
                            stridesc1.add(ctesc1.id);
							System.debug('strids::'+strids);
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'No CaseOwner Manger for Escalation 2 or issue with contacts');
                            }
                          }
                        else if(((eshs.Level_2_Source__c == 'SFDC Escalation Table') && (eshs.Level_2_POC__c != Null))|| eshs.Level_2_POC__c != Null){
                            System.debug('level 2 poc::'+eshs.Level_2_POC__c);
                            try{
                            Contact ct = [Select id, email from Contact where email =: eshs.Level_2_POC__c or Name =: eshs.Level_2_POC__c]; 
                            Contact ctesc1 = [Select id, email from Contact where email =: eshs.Level_1_POC__c or Name =: eshs.Level_1_POC__c];
                            	strids.add(ct.id);
                            	stridesc1.add(ctesc1.id);
                            }
                            Catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'No Contact or duplicate contacts');
                            }
                        }
                        addtoaddress(strids, stridesc1, cs.id, cs);
                        if(Integer.valueOf(eshs.Lev3_Followup_Calendar_Days__c) != null){
                            Integer ndays = Integer.valueOf(eshs.Lev3_Followup_Calendar_Days__c);
                        	Nodays.put(cs.id,ndays);
                        }
                    }
                    else if(cs.Escalation_Level__c == 'Escalation 3'){
                        list<String> strids = new list<String>();
        				list<String> stridesc1 = new list<String>();
        				list<String> stridesc2 = new list<String>();
        				System.debug('Maxesc::'+Maxesc);
						if(eshs.Level_3_POC__c == 'BUSINESS FOCAL ESCALATION MANAGER'){
                            System.debug('Account User Manager'+acc.Business_Escalation__r.User_Primary_Manager_EID__c);
                            try{
                            Contact ct =[Select id, email, name from Contact where Employee_Number__c =: acc.Business_Escalation__r.User_Primary_Manager_EID__c];  
                            strids.add(ct.id);
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'No CaseOwner Manger Employee Id exists for Escalation 3 or duplicate contacts');
                           }
                            stridesc2.add(Acc.Business_Escalation__c);
                            stridesc1.add(Acc.Business_Focal__c);
                        }
                        else if(eshs.Level_3_POC__c == 'T2 LEADER'){
                            try{
                            System.debug('usr1.Manager.email::'+usr1.Manager.email);
                            Contact ct = [Select id, email from Contact where Employee_Number__c =: usr2.EmployeeNumber];  
                            strids.add(ct.id);
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'No CaseOwner Manger for Escalation 3 or duplicate contacts');
                            }
                            try{
                            Contact ctesc2 = [Select id, email from Contact where Employee_Number__c =: usr1.EmployeeNumber];  
                            stridesc2.add(ctesc2.id);
                            Contact ctesc1 = [Select id, email from Contact where Employee_Number__c =: usr.EmployeeNumber];
                            stridesc1.add(ctesc1.id);
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'Issue with Contact for Escalation 2 or Escalation 1');
                            }
                        }
                        else if(((eshs.Level_3_Source__c == 'SFDC Escalation Table' || eshs.Level_3_Source__c == 'sfdc level 2 contact manager') && (eshs.Level_3_POC__c != Null))|| (eshs.Level_3_POC__c != Null)){
                           System.debug('level 3 poc::'+eshs.Level_3_POC__c);
                            Contact ctesc1 = new Contact();
                            Contact ctesc2 = new Contact();
                            Contact ctesc = new Contact();
                            try{
                            ctesc = [Select id, email from Contact where email =: eshs.Level_3_POC__c or Name =: eshs.Level_3_POC__c]; 
                            ctesc1 = [Select id, email from Contact where email =: eshs.Level_1_POC__c or Name =: eshs.Level_1_POC__c];
                            ctesc2 = [Select id, email from Contact where email =: eshs.Level_2_POC__c or Name =: eshs.Level_2_POC__c];
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'Issue with Contact at escalation 3');
                            }
                            strids.add(ctesc.id);
                            stridesc2.add(ctesc2.id);
                            stridesc1.add(ctesc1.id);
                        }
                        if(Maxesc.get(cs.id) == null){
                        addtoaddress(strids, stridesc2, cs.id, cs);
                        }
                        else if(Maxesc.get(cs.id) == 'Escalation 1'){
                            addtoaddress(strids, stridesc1, cs.id, cs);
                        }
                        if(Integer.valueOf(eshs.Lev4_Followup_Calendar_Days__c) != null){
                            Integer Ndays = Integer.valueOf(eshs.Lev4_Followup_Calendar_Days__c);
                        	Nodays.put(cs.id, Ndays);
                        }
                    }
                    else if(cs.Escalation_Level__c == 'Escalation 4'){
                        list<String> strids = new list<String>();
        				list<String> stridesc1 = new list<String>();
        				list<String> stridesc2 = new list<String>();
        				list<String> stridesc3 = new list<String>();
                         Contact cts = new Contact();
                        try{
                         if(acc.Business_Escalation__r.User_Primary_Manager_EID__c != null)
                         	cts = [Select id, User_Primary_Manager_EID__c from Contact where Employee_Number__c=: acc.Business_Escalation__r.User_Primary_Manager_EID__c];
                        	System.debug('cts.User_Primary_Manager_EID__c'+cts.User_Primary_Manager_EID__c);
                        }
                        catch(Exception E){
                            createtaskforerror(cs.id, Ownrid.get(cs.id), 'No Contact or duplicate contacts found');
                        }
                        if(eshs.Level_4_POC__c == 'T3 VP'){
                            System.debug('Contact USer Manger::'+cts.User_Primary_Manager_EID__c);
                            try{
                            Contact ct = [Select id, email, name from Contact where Employee_Number__c =: cts.User_Primary_Manager_EID__c];  
                            strids.add(ct.id);
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'duplicate contacts found or No User Primary Manager for Escalation 4');
                           }
                            stridesc3.add(cts.id);
                            stridesc2.add(Acc.Business_Escalation__c);
                            stridesc1.add(Acc.Business_Focal__c);
                        }
                        else if(eshs.Level_4_POC__c == 'T3 LEADER'){
                           try{
                            System.debug('usr.Manager.email::'+usr2.Manager.email);
                            Contact ct = [Select id, email from Contact where Employee_Number__c =: usr3.EmployeeNumber];  
                            strids.add(ct.id);
                            Contact ctesc3 = [Select id, email from Contact where Employee_Number__c =: usr2.EmployeeNumber];  
                            stridesc3.add(ctesc3.id);
                            Contact ctesc2 = [Select id, email from Contact where Employee_Number__c =: usr1.EmployeeNumber];  
                            stridesc2.add(ctesc2.id);
                            Contact ctesc1 = [Select id, email from Contact where Employee_Number__c =: usr.EmployeeNumber];
                            stridesc1.add(ctesc1.id);
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'No CaseOwner Manger for Escalation 4 or duplicate contacts');
                            }
                        }
                        else if(((eshs.Level_4_Source__c == 'SFDC Escalation Table'|| eshs.Level_4_Source__c == 'sfdc level 3 contact manager') && (eshs.Level_4_POC__c != Null)) || (eshs.Level_4_POC__c != Null)){
                           System.debug('level 4 poc::'+eshs.Level_4_POC__c);
                            try{
                            Contact ct = [Select id, email from Contact where email =: eshs.Level_4_POC__c or Name =: eshs.Level_4_POC__c]; 
                            Contact ctesc3 = [Select id, email from Contact where email =: eshs.Level_3_POC__c or Name =: eshs.Level_3_POC__c]; 
                            Contact ctesc1 = [Select id, email from Contact where email =: eshs.Level_1_POC__c or Name =: eshs.Level_1_POC__c];
                            Contact ctesc2 = [Select id, email from Contact where email =: eshs.Level_2_POC__c or Name =: eshs.Level_2_POC__c];
                            strids.add(ct.id);
                            stridesc3.add(ctesc3.id);
                            stridesc2.add(ctesc2.id);
                            stridesc1.add(ctesc1.id);
                            }
                            catch(Exception E){
                                createtaskforerror(cs.id, Ownrid.get(cs.id), 'Issue with Contacts at escalation 4');
                            }
                        }
                        if(Maxesc.get(cs.id) == null){
                        addtoaddress(strids, stridesc3, cs.id, cs);
                        }
                        else if(Maxesc.get(cs.id) == 'Escalation 2'){
                         addtoaddress(strids, stridesc2, cs.id, cs);   
                        }
                        else if(Maxesc.get(cs.id) == 'Escalation 1'){
                          addtoaddress(strids, stridesc1, cs.id, cs); 
                        }
                    }
              }//else condition
            }//end of if condition
            if(eshs.Automate__c != null)
            	Automation.put(cs.id, eshs.Automate__c);             
          }//end of esh for loop
          }//end of case for loop
        }//end of checking sde not being empty
        return retval;
    }
    public static void addtoaddress(list<String> stridss, list<String> prevstrids, String CasId, Case newcasMap){
        list<String> Toaddr = new list<String>();
        list<Contact> ct = new list<Contact>();
        list<Contact> prevct = new list<Contact>();
        list<String> toadds = new list<String>(); 
        String Ownrid;
        String Esclvl;
        String Maxesc;
        System.debug('Maxesc:'+Maxesc);
        //for(Case css: newcasMap){
            if(newcasMap.id == CasId){
                Ownrid = newcasMap.OwnerId;
                Esclvl = newcasMap.Escalation_Level__c;
                Maxesc = newcasMap.Max_Escalation_Level_Reach__c;
            }
        //}
        System.debug('stridss::'+stridss);
        try{
        if(stridss.size()>0 && stridss!= (null)){
      		System.debug('stridss::'+stridss);
        	ct = [Select id, Name, email from Contact where ((Id IN: stridss) OR (email IN: stridss)) limit 2];
        }
        System.debug('ct::'+ct);
        prevct = [Select email from Contact where Id In: prevstrids];
        System.debug('prevct::'+prevct);
    	}
        catch(exception E){
            createtaskforerror(Casid, Ownrid, 'No Contacts or Duplicate Contacts found');
        }
             try{
             if((ct != null) && (ct.size()<=1)|| (stridss.size() == ct.size())){
                for(Contact ctt: ct){
                toadds.add(ctt.email);
               }
                 System.debug('toadds::'+toadds);
                 for(String toad: toadds){
                     System.debug('emailaddrlst::'+emailaddrlst);
                     if(emailaddrlst.contains(toad) && Maxesc == null){
                         Toaddr.add(prevct[0].email);
                         Toaddrmap.put(CasId, Toaddr);
                         if(Esclvl == 'Escalation 4')
                         	MaxLevel.put(casid,'Escalation 3');
                         else if(Esclvl == 'Escalation 3')
                            MaxLevel.put(casid,'Escalation 2');
                         else if(Esclvl == 'Escalation 2')
                            MaxLevel.put(casid,'Escalation 1');
                      }
                     else if(Maxesc == 'Escalation 2' || Maxesc == 'Escalation 1'){
                          	 Toaddr.add(prevct[0].email);
                         	 Toaddrmap.put(CasId, Toaddr);
                             MaxLevel.put(CasId, Maxesc);
                     }
                     else{
                        Toaddr.add(toad);
                        Toaddrmap.put(CasId, Toaddr);
                     }
                     System.debug('MaxLevel::'+MaxLevel);
                     System.debug('Toaddrmap::'+Toaddrmap);
                 }
				}
             }
             catch(Exception E){
             if(ct.size()>1){
                createtaskforerror(Casid, Ownrid, 'Duplicate Contacts found');
             }
             }
    }
    public static void createtaskforerror(Id Casid, String Ownrid,String errmsg){
        //Case cas = [Select id, OwnerId from Case where id =: Casid limit 1];
        String recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Task').getRecordTypeId();
        Task tsk = new Task();
        tsk.RecordtypeID = recTypeId;
        tsk.Subject = 'Escalation Error Message';
		tsk.WhatId = Casid;
        tsk.OwnerId = Ownrid;
        tsk.Status = 'Open';
        tsk.Description__c = errmsg;
        if(Ownrid.startsWith('005'))
        	tsklst.add(tsk);
        System.debug('tsklst:::'+tsklst);
        }
    public static void createcasecomment(list<case> newcaslst, Map<ID,Case> oldMap){
        list<CaseComment> ccmlst = new list<CaseComment>();
        list<Case> cslst = new list<Case>();
        String Casid;
        String CasOwnrid;
        for(Case cs: newcaslst){
            Casid = cs.id;
            CasOwnrid =  cs.OwnerId;
            String oldnotes = oldMap.get(cs.id).Case_Comments__c;
               System.debug('oldnotes::'+oldnotes);	
               System.debug('cs.Case_Comments__c::'+cs.Case_Comments__c);
               if((cs.Status == 'On Hold') && (cs.Case_Comments__c!= '' || String.isNotBlank(cs.Case_Comments__c))&& (cs.Case_Comments__c != oldnotes)){
               CaseComment ccm = new CaseComment();
           		ccm.CommentBody = cs.Case_Comments__c;
           		ccm.IsPublished = false;
           		ccm.ParentId = cs.id;
           	   ccmlst.add(ccm);
              /* Case Css = new Case(id= cs.id);
               css.Case_Comments__c = '';
               cslst.add(css);*/
           }
           system.debug('ccmlst::'+ccmlst);
       }
       try{
       if(ccmlst.size()>0){
           insert ccmlst;
       }
      /* if(cslst.size()>0){
           update cslst;
       }*/
       }
       catch(Exception e){
           system.debug('An unexpected error while inserting Case Comment---' + e.getMessage());
           createtaskforerror(Casid, CasOwnrid, 'An unexpected error while inserting Case Comment---' + e.getMessage());
       }
    }
    //@future
    public static void sendescalatedemail(list<case> newcaslst, Map<Id, Case> oldMap){
        if(checkrecursiveforesc.runOnce())
    	{
    	//Toaddr = new list<String>();Map<id, list<String>> Toaddrmap = new Map<id, list<String>>();
        list<case> caslst = new list<case>();
        User Usrr = new User();
        Account act = new Account();
        Contact cnt = new Contact();
        Case Casv = new Case();
        Set<id> Casid = new Set<id>();
        Map<id, String> reasonmap = new Map<id, String>();
        Map<ID,ID> eMapIDs = new Map<ID,ID>();
        String Contid;
        String CasOwnrid;
        String CasOwnrname;
        String EscalatedLevel;
        String Accidd;
        String SubEsclevel;
        String accnam;
        Map<Id, String> escalatedcont = new Map<Id, String>();
        String esccont;
        String Stts;
        String casvals;
        Boolean escaltd;
        Map<String,String> Actnam = new Map<String,String>();
        Map<String,String> Usrnam = new Map<String,String>();
        Map<id, EmailMessage> emailMsgmap = new Map<id, EmailMessage>();
        String eml;
        Map<String,String> escnt = new Map<String,String>();
        Map<String,String> Conteml = new Map<String,String>();
        list<EmailMessage> emmsglst = new list<EmailMessage>();
        Map<ID, List<Messaging.Emailfileattachment>> caseAttListMap = new Map<ID, List<Messaging.Emailfileattachment>>();
      	list<Case> newcalst = new list<case>();
        for(Case cs: newcaslst){
           Casid.add(cs.id);
            System.debug('Casid::'+Casid);
           CasOwnrid = cs.OwnerId;
            System.debug('CasOwnrid'+CasOwnrid);
           Contid = cs.ContactId;
           Accidd = cs.AccountId;
           Stts = cs.Status;
           escaltd = cs.Escalated__c;	
           System.debug('escaltd::'+escaltd);
            System.debug('Stts::'+Stts);
            if(stts == 'On Hold' && escaltd == false && cs.Escalation_Level__c != null && cs.Escalation_Level__c != 'Escalation 1')
                newcalst.add(cs);
            System.debug('newcalst::'+newcalst);
            if(cs.VN_Name__c != null){
           		escalatedcont.put(cs.id, cs.VN_Name__c);
            }
            else if(Stts == 'On Hold' && escaltd == false  && cs.Escalation_Level__c != null)
               cs.addError('Please enter value for Escalated To (Contact)');
           String escalatedconts = escalatedcont.get(cs.id);
           CasOwnrname = 'select FirstName, LastName, email from User where id =: CasOwnrid';
           accnam = 'select name from Account where id =: Accidd';
           esccont = 'select id, name, email from Contact where id =: escalatedconts';
           casvals = 'select id from Case where id =: cs.id';
           EscalatedLevel = cs.Escalation_Level__c;
           System.debug('EscalatedLevel::'+EscalatedLevel);
           /* if(EscalatedLevel == 'Escalation 1'){
                SubEsclevel = 'First Request';
            }else if(EscalatedLevel == 'Escalation 2'){
                SubEsclevel = 'Second Request';
            }else if(EscalatedLevel == 'Escalation 3'){
                SubEsclevel = 'Third Request';
            }else if(EscalatedLevel == 'Escalation 4'){
                SubEsclevel = 'Fourth Request';
            }*/
        // end of first for loop
        //if((Stts == 'On Hold') && escaltd == false){
            System.debug('Entered in here!');
           //Casv = database.query(casvals);
        try{
        	Usrr = database.query(CasOwnrname);
        }
        catch(Exception E){
            System.debug('Error message at case owner:'+E.getMessage());
            /*User uss = [Select id, email from User where EmployeeNumber = 'E288072' limit 1];
            createtaskforerror(Casid, uss.id, 'Issue with Case Owner'+'--'+Casid); */   
        }
            System.debug('Usrr'+Usrr);
        if(Accidd != null)
       	 	act = database.query(accnam);
        if(escalatedcont != null && escalatedcont.get(cs.id) != null)
        	cnt = database.query(esccont);
        Actnam.put(cs.id, act.name);
        Usrnam.put(cs.id,Usrr.FirstName+ ' ' +Usrr.LastName);
        //eml = Usrr.Email;
        escnt.put(cs.id,cnt.name);
        Conteml.put(cs.id,cnt.Email);
        }
        System.debug('Usrnam::'+Usrnam);
        if(newcalst.size()>0)
        	getescalatedtoval(newcalst);
        System.debug('Nodays::'+Nodays);
        System.debug('Toaddr::'+Toaddrmap);
        System.debug('Automation::'+Automation);
        list<contentDocumentLink> filst = new list<contentDocumentLink>();
        List<id> ContentDocumentids = new List<id>();
        filst = [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid IN: Casid];
        //}
        /*List<EmailMessage> emlst= [SELECT Id, FromAddress, ToAddress, MessageDate, Subject, Incoming, TextBody, CreatedBy.Name   
            							 from EmailMessage where ParentId =: Casid order by MessageDate DESC];
               System.debug('emlst:'+emlst);	
               String htmbod;
               for(EmailMessage htmb: emlst){
                   		htmbod+= ' ***************************\n \n From: ' + htmb.FromAddress
                            	 + '\n To: ' + htmb.ToAddress 
                            	 + '\n Subject: ' + htmb.Subject 
                            	 + '\n \n' + htmb.TextBody;&& Automation == 'yes'
               }
               System.debug('htmbod::'+htmbod);*/
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        for(Case cs: newcaslst){
           if((cs.Status == 'On Hold') && (cs.Escalated__c == false) && (cs.Reason_for_hold__c != null) && (cs.Escalation_Level__c != 'Escalation 1') && cs.Pega_Reason_for_Hold__c == 'yes'){
               //Integer NODays;
               System.debug('cs.Escalation_Level__c==>'+cs.Escalation_Level__c);
               reasonmap.put(cs.id, cs.Reason_for_hold__c);
               String csownid = cs.OwnerId;
               System.debug('csownid::'+csownid);
               if(csownid.startsWith('00G')){
                cs.adderror('Case Owner Cannot be Queue. It should be User for auto escalations');
            	}
               if(Toaddrmap != null){
            	if((Toaddrmap.get(cs.id) != null) && (Toaddrmap.get(cs.id).size()==0) && (EscalatedLevel == 'Escalation 1'))
            	Toaddrmap.get(cs.id).add(Conteml.get(cs.id));
        	   }
               System.debug('Toaddrmap::'+Toaddrmap);
               String tempnam;
               Map<Id, String> tempnammap = new Map<Id, String>();
               if(cs.Escalation_Level__c == 'Escalation 1'){
                   tempnam = 'Manual_Escalation_1_HIA_Template';
                   tempnammap.put(cs.id, tempnam);
               }
               else if(cs.Escalation_Level__c == 'Escalation 2'){
                   tempnam = 'Manual_Escalation_2_HIA_Template';
                   tempnammap.put(cs.id, tempnam);
               }
               else if(cs.Escalation_Level__c == 'Escalation 3'){
                   tempnam = 'Manual_Escalation_3_HIA_Template';
                   tempnammap.put(cs.id, tempnam);
               }
               else if(cs.Escalation_Level__c == 'Escalation 4'){
                   tempnam = 'Manual_Escalation_4_HIA_Template';
                   tempnammap.put(cs.id, tempnam);
               }
               System.debug('tempnam::'+tempnam);
               System.debug('tempnammap::'+tempnammap);
               String Casrectype = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.recordtypeid).getname();
               String oldsubstatus = oldMap.get(cs.id).Sub_Status__c;
               System.debug('Casrectype::'+Casrectype);
               Case css = new Case(id = cs.id);
               css.Escalated__c = True;
               if(Nodays != null && Nodays.get(cs.id) != null)
               		css.Due_Date__c = System.today()+ Nodays.get(cs.id);
               else
                   css.Due_Date__c = System.today();
               css.Escalated_On__c = System.today();
               if(cs.Max_Escalation_Level_Reach__c == null)
               		css.Max_Escalation_Level_Reach__c = MaxLevel.get(cs.id);
               if(cs.Escalation_Level__c == 'Escalation 4'){
                   css.Due_Date__c = System.today()+1;
                  // css.Escalated_On__c = null;
                  // css.Escalation_Level__c = '';
               }
               System.debug('Toaddr::'+Toaddrmap.get(cs.id));
               if(Toaddrmap != null && Toaddrmap.get(cs.id) != null && Toaddrmap.get(cs.id).size()>0){
               System.debug('cs.To_addresses__c::'+cs.To_addresses__c);
               for(String toadd: Toaddrmap.get(cs.id)){
                  System.debug('toadd::'+toadd);
                if(cs.Sub_Status__c != oldsubstatus){
                   if(css.To_addresses__c != null)
                		css.To_addresses__c = css.To_addresses__c +';'+toadd;
                   else
                        css.To_addresses__c = toadd;
                }
            	else if(cs.To_addresses__c != null){
                    System.debug('entered here');
                    System.debug('css.To_addresses__c::'+css.To_addresses__c);
                    if(css.To_addresses__c != null)
                		css.To_addresses__c = css.To_addresses__c +';'+toadd;
                    else
                        css.To_addresses__c = cs.To_addresses__c +';'+toadd;
                }
                else{
                    System.debug('entered hereeee');
                    css.To_addresses__c = toadd;      
            	}
               }
               System.debug('css.To_addresses__c::'+css.To_addresses__c);
               if((cs.Sub_Status__c == oldsubstatus) && cs.To_addresses__c != null && cs.To_addresses__c.contains(';')){
                   System.debug('Entered If!');
                  String[] str2 = cs.To_addresses__c.split(';');
                  for(String st: str2){
                      Toaddrmap.get(cs.id).add(st);
                  }
               }
               else if((cs.Sub_Status__c == oldsubstatus) && (cs.To_addresses__c != null)){
                   System.debug('Entered else!');
                   Toaddrmap.get(cs.id).add(cs.To_addresses__c); 
               }
               }
               caslst.add(css);
               System.debug('caslst::'+caslst);
			   EmailTemplate temp;
               try{
               temp = [select id,Body,Subject from EmailTemplate where DeveloperName=: tempnammap.get(cs.id) LIMIT 1];
               }
               catch(Exception E){
                  createtaskforerror(cs.id, csownid, 'An unexpected error on Template---' + e.getMessage()); 
               }
               System.debug('temp::'+temp);
               String emailBody;
               String emailSubject;
               if(temp != null){
               emailBody = temp.Body;
               emailSubject = temp.Subject;
               }
               //emailSubject = emailSubject.Replace('{!Case.Email_Subject_Value__c}', cs.Email_Subject_Value__c);
               emailSubject = emailSubject.Replace('{!Case.Sub_Status__c}', cs.Sub_Status__c);
               emailSubject = emailSubject.Replace('{!Case.Reason_for_hold__c}', cs.Reason_for_hold__c);
               emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', cs.Case_Ref_ID__c);
               emailSubject = emailSubject.Replace('{!Case.CaseNumber}', cs.CaseNumber);
               //emailBody = emailBody.replaceAll('\n', '<br/>');
               emailBody = emailBody.Replace('{!Case.CaseNumber}', cs.CaseNumber);
               emailBody = emailBody.Replace('{!Case.OwnerFullName}', Usrnam.get(cs.id));
			   if(Actnam!=null)
                  emailBody = emailBody.Replace('{!Case.Account_Name__c}', Actnam.get(cs.id));
               else
                  emailBody = emailBody.Replace('{!Case.Account}', 'N/A' ); 
               if(cs.VN_Name__c != null)
                  emailBody = emailBody.Replace('{!Case.VN_Name__c}', escnt.get(cs.id));
               else
                  emailBody = emailBody.Replace('{!Case.VN_Name__c}', '');
               if(cs.Customer_Sold_To__c != null)
                  emailBody = emailBody.Replace('{!Case.Customer_Sold_To__c}', cs.Customer_Sold_To__c);
               else
                  emailBody = emailBody.Replace('{!Case.Customer_Sold_To__c}', 'N/A');
               if (cs.Sales_Order_Number__c != null)
                  emailBody = emailBody.Replace('{!Case.Sales_Order_Number__c}', cs.Sales_Order_Number__c);
               else
                  emailBody = emailBody.Replace('{!Case.Sales_Order_Number__c}','N/A');
               if(cs.Quote_Number__c != null)
               	  emailBody = emailBody.Replace('{!Case.Quote_Number__c}', cs.Quote_Number__c);
               else
                  emailBody = emailBody.Replace('{!Case.Quote_Number__c}', 'N/A');
               if(cs.Repair_Notification_Number__c != null)
               	  emailBody = emailBody.Replace('{!Case.Repair_Notification_Number__c}', cs.Repair_Notification_Number__c);
               else
                   emailBody = emailBody.Replace('{!Case.Repair_Notification_Number__c}', 'N/A');
               if(cs.Customer_PO_RO_WONumber__c != null)
               	   emailBody = emailBody.Replace('{!Case.Customer_PO_RO_WONumber__c}', cs.Customer_PO_RO_WONumber__c);
               else
                   emailBody = emailBody.Replace('{!Case.Customer_PO_RO_WONumber__c}', 'N/A');
               if(cs.Contract_Number__c != null)
               	   emailBody = emailBody.Replace('{!Case.Contract_Number__c}', cs.Contract_Number__c);
               else
                   emailBody = emailBody.Replace('{!Case.Contract_Number__c}','N/A');
               if(cs.Product_Number__r.Name != null)
              	   emailBody = emailBody.Replace('{!Case.Product_Number__c}', cs.Product_Number__r.Name);
               else
                   emailBody = emailBody.Replace('{!Case.Product_Number__c}', 'N/A');
               if(cs.Part_Number__c!= null)
              	   emailBody = emailBody.Replace('{!Case.Part_Number__c}', cs.Part_Number__c);
               else
                   emailBody = emailBody.Replace('{!Case.Part_Number__c}', 'N/A');
               emailBody = emailBody.Replace('{!Case.Reason_for_hold__c}', cs.Reason_for_hold__c);
               if(cs.Case_Comments__c != null)
               	   emailBody = emailBody.Replace('{!Case.Case_Comments__c}', cs.Case_Comments__c);
               else
                   emailBody = emailBody.Replace('{!Case.Case_Comments__c}', 'N/A');
              /* String emlmsgBody = emailBody;
               if(htmbod != null)
               		emailBody += +'\n \n'+htmbod;*/
              /* List<EmailMessage> emlst= [SELECT Id, FromAddress, ToAddress, MessageDate, Subject, Incoming, TextBody, CreatedBy.Name   
            							 from EmailMessage where ParentId =: cs.Id order by MessageDate DESC];
               System.debug('emlst:'+emlst);	
               String htmbod;
               		for(EmailMessage htmb: emlst){
                   		htmbod+= htmb.HtmlBody + '<br/>';
               		}
               System.debug('htmbod::'+htmbod);*/
               /* if(htmbod != null)
                	emailBody = emailBody.Replace('{!Case.Email_Thread}', htmbod);
               	else
                    emailBody = emailBody.Replace('{!Case.Email_Thread}', '');*/
               //emailmessage.htmlbody; emailbody.append
               //forwarding last email
               Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
               List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
               EmailMessage emailMsg = new EmailMessage();
               OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where Address = 'yourresponse@honeywell.com' limit 1];
               if(!(filst.isempty())){
        		for(contentDocumentLink cdl: filst){
           			 ContentDocumentids.add(cdl.ContentDocumentid);
        	     }
                 list<ContentVersion> ctvrsnlst = new list<ContentVersion>();
                 System.debug('reasonmap.get(cs.id)'+reasonmap.get(cs.id));
                 //String reasonmapval = reasonmap.get(cs.id)+ '%';
                 ctvrsnlst = [SELECT title, PathOnClient, FileType, versiondata FROM contentversion 
				              WHERE ContentDocumentId IN :ContentDocumentids AND title LIKE: reasonmap.get(cs.id)+ '%'];
                 System.debug('ctvrsnlst::'+ctvrsnlst);
                 if(!(ctvrsnlst.isempty())){
                 for (ContentVersion cversion : ctvrsnlst)
				 {
			  		blob flebody = cversion.versiondata;
			  		system.debug('body : '+flebody+'-----------'+cversion.title);
			  		Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    String Parentstrng = cversion.title;
                    System.debug('Parentstrng::'+Parentstrng);
                    string[] splitted = Parentstrng.split('\\-');
                    System.debug('splitted::'+splitted);
			  		efa.setFileName(splitted[1]);
			  		efa.setBody(flebody);
			  		fileAttachments.add(efa); 
			 	 }
                 }
                caseAttListMap.put(cs.id, fileAttachments);
        		}
               System.debug('Toaddr::'+Toaddrmap.get(cs.id));
               if((Toaddrmap != null) && (Toaddrmap.get(cs.id) != null) && Toaddrmap.get(cs.id).size()>0){
                   mail.setToAddresses(Toaddrmap.get(cs.id));
               }
               else{
                  createtaskforerror(cs.id, cs.OwnerId, 'No data found for To-address');
               }
                        //mail.setSubject(emailSubject);
                        mail.setBccSender(false);
               			mail.setTemplateId(temp.id);
               			if(caseAttListMap != null && caseAttListMap.get(cs.ID)!= null)
               				mail.setFileAttachments(caseAttListMap.get(cs.ID));
               			//mail.
                        //mail.setPlainTextBody(emailBody);
               			//mail.setHtmlBody(temp.Body);
               			//mail.setTreatBodiesAsTemplate(true);
               			mail.setOrgWideEmailAddressId(owa.id);
               			mail.setTargetObjectId(escalatedcont.get(cs.id));
                        mail.setSaveAsActivity(false);
               			mail.setWhatId(cs.id);
                        msgList.add(mail);
               			// Created an EmailMessage and copy all details from above.
               			//emailMsg.FromAddress = eml;
               			emailMsg.FromAddress ='yourresponse@honeywell.com';
               			if((Toaddrmap != null) && (Toaddrmap.get(cs.id) != null) && Toaddrmap.get(cs.id).size()>0){
                            for(String toa: Toaddrmap.get(cs.id)){
                                if(emailMsg.ToAddress != null)
               						emailMsg.ToAddress= emailMsg.ToAddress+';'+toa;
                                else
                                    emailMsg.ToAddress= toa;
                            }
               			}
                        emailMsg.Subject= emailSubject;
               			emailMsg.TextBody= emailBody;
                        //emailMsg.TextBody=emlmsgBody;
                        emailMsg.ParentId = cs.id; //Attach with the case
                        emailMsg.MessageDate = system.now();
                        emailMsg.Status = '0';
               			emailMsgmap.put(cs.id, emailMsg);
               			if((Toaddrmap != null) && (Toaddrmap.get(cs.id) != null) && Toaddrmap.get(cs.id).size()>0)
                        	emmsglst.add(emailMsg);
               System.debug('msgList::'+msgList);
               System.debug('emmsglst::'+emmsglst);
               //System.debug('emmsglst.parentid'+emmsglst[0].ParentId);
           }
        }
        Messaging.SendEmailResult[] results;
            try{
                if(!msgList.isEmpty() && msgList!=null){
                    results= Messaging.sendEmail(msgList);
                }
            }
            catch (Exception e){
                system.debug('An unexpected error for Escalated autoforward email---' + e.getMessage());
                //createtaskforerror(cs.id, csownid, 'An unexpected error for Escalated autoforward email---' + e.getMessage());
            }
        if(caslst.size()>0){
            database.update(caslst, true);
        }
        if(emmsglst.size()>0){
            database.insert(emmsglst, true);
        }
        if(newcalst.size()>0 && tsklst.size()>0){
            System.debug('Inserted new error task');
            database.insert(tsklst, true);
        }
        if(emmsglst != null){
        for(EmailMessage emll : emmsglst){
                if(emll.id!=null){
                    eMapIDs.put(emll.ParentID,emll.ID);
                }
        }
        system.debug('eMapIDs==>' +eMapIDs);
        List<Attachment> attchList = new List<Attachment>();
        //List<Attachment> attchList2 = new List<Attachment>();
        List<Messaging.Emailfileattachment> emflst = new List<Messaging.Emailfileattachment>();
        Map<Id, List<Messaging.Emailfileattachment>> attchList2 = new Map<Id, List<Messaging.Emailfileattachment>>();
        Attachment attch;
        if(!eMapIDs.isEMpty()){
            for(String cs: Casid){
            	emflst = caseAttListMap.get(cs);
                //attchList2.put(eMapIDs.get(cs), emflst);
            //attchList2 = [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN: Casid];
            if(emflst != null){
            for(Messaging.Emailfileattachment att : emflst) 
            {
                if(emailMsgmap.containsKey(cs))
                {
                    system.debug('entered attachment loop');
                    system.debug('att.ParentID==>' +cs);
                    attch= new Attachment();
                    attch.Name = att.FileName;
                    attch.Body = att.body;
                    attch.ParentID = eMapIDs.get(cs);
                    attchList.add(attch);
                }
            }
        }
        }
        }
        system.debug('attchList==' +attchList);
        try{
            insert attchList;
        }
        catch(exception e){
            system.debug('atachment not inserted==>' + e.getMessage());
        }
        }
        }
    }
    @future
    public static void sendescalatedemailFirstEscalation(Id casid){
        list<case> caslst = new list<case>();
        Boolean truval = false;
        User Usrr = new User();
        Account act = new Account();
        Contact cnt = new Contact();
        Case cs = new Case();
        cs = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where id=: casid];
        System.debug('cs::'+cs);
        Map<ID,ID> eMapIDs = new Map<ID,ID>();
        string CasOwnrid;
        String CasOwnrname;
        Map<Id, String> escalatedcont = new Map<Id, String>();
        String esccont;
        Map<id, EmailMessage> emailMsgmap = new Map<id, EmailMessage>();
        String eml;
        list<EmailMessage> emmsglst = new list<EmailMessage>();
        Map<ID, List<Messaging.Emailfileattachment>> caseAttListMap = new Map<ID, List<Messaging.Emailfileattachment>>();
      	list<Case> newcalst = new list<case>();
        CasOwnrid = cs.OwnerId;
            System.debug('CasOwnrid'+CasOwnrid);
            System.debug('Stts::'+cs.Status);
        	System.debug('cs.Escalated__c :'+cs.Escalated__c);
        	System.debug('cs.Escalation_Level__c:'+cs.Escalation_Level__c);
            if(cs.Status == 'On Hold' && cs.Escalation_Level__c != null && cs.Pega_Reason_for_Hold__c == 'yes')
                newcalst.add(cs);
            System.debug('newcalst::'+newcalst);
        	System.debug('cs.VN_Name__c::'+cs.VN_Name__c);
            if(cs.VN_Name__c != null){
           		escalatedcont.put(cs.id, cs.VN_Name__c);
            }
           String escalatedconts = escalatedcont.get(cs.id);
           try{
        	Usrr = [select FirstName, LastName, email from User where id =: CasOwnrid];
           }
           catch(Exception E){
            System.debug('Error message at case owner:'+E.getMessage());
        	}
            System.debug('Usrr'+Usrr);
        if(cs.Accountid != null)
       	 	act = [select name from Account where id =: cs.Accountid];
        if(cs.VN_Name__c != null)
        	cnt = [select id, name, email from Contact where id =: cs.VN_Name__c];
        String Usrnam = Usrr.FirstName+ ' ' +Usrr.LastName;
         System.debug('Usrnam::'+Usrnam);
        if(newcalst.size()>0)
        	getescalatedtoval(newcalst);
        System.debug('Nodays::'+Nodays.get(cs.id));
        System.debug('Toaddr::'+Toaddrmap.get(cs.id));
        System.debug('Automation::'+Automation.get(cs.id));
        Integer Nodayss = Nodays.get(cs.id);
        list<String> Toaddrr = Toaddrmap.get(cs.id);
        String Automationn = Automation.get(cs.id);
        list<contentDocumentLink> filst = new list<contentDocumentLink>();
        List<id> ContentDocumentids = new List<id>();
        filst = [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid =: cs.id];
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        if((cs.Status == 'On Hold') && (cs.Reason_for_hold__c != null) && cs.Pega_Reason_for_Hold__c == 'yes'){
               System.debug('cs.Escalation_Level__c==>'+cs.Escalation_Level__c);
               String csownid = cs.OwnerId;
               System.debug('csownid::'+csownid);
               /*if(csownid.startsWith('00G')){
                cs.adderror('Case Owner Cannot be Queue. It should be User for auto escalations');
            	}*/
               if(Toaddrr == null && (cs.Escalation_Level__c == 'Escalation 1')){
            	Toaddrr.add(cnt.email);
        	   }
               System.debug('Toaddr::'+Toaddrr);
               String tempnam;
               //Map<Id, String> tempnammap = new Map<Id, String>();
               if(cs.Escalation_Level__c == 'Escalation 1'){
                   tempnam = 'Manual_Escalation_1_HIA_Template';
                   //tempnammap.put(cs.id, tempnam);
               }
               System.debug('tempnam::'+tempnam);
               String Casrectype = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.recordtypeid).getname();
               //String oldsubstatus = oldMap.get(cs.id).Sub_Status__c;
               System.debug('Casrectype::'+Casrectype);
               Case css = new Case(id = cs.id);
               css.Escalated__c = True;
               if(Nodayss != null)
               		css.Due_Date__c = System.today()+ Nodayss;
               else
                   css.Due_Date__c = System.today();
               css.Escalated_On__c = System.today();
              /* if(cs.Max_Escalation_Level_Reach__c == null)
               		css.Max_Escalation_Level_Reach__c = MaxLevel.get(cs.id);*/
               System.debug('Toaddr::'+Toaddrr);
               if(Toaddrr != null){
               System.debug('cs.To_addresses__c::'+cs.To_addresses__c);
               for(String toadd: Toaddrr){
                  System.debug('toadd::'+toadd);
                   if(css.To_addresses__c != null)
                		css.To_addresses__c = css.To_addresses__c +';'+toadd;
                   else
                        css.To_addresses__c = toadd;
               System.debug('css.To_addresses__c::'+css.To_addresses__c);
               caslst.add(css);
               System.debug('caslst::'+caslst);
			   EmailTemplate temp;
               try{
               temp = [select id,Body,Subject from EmailTemplate where DeveloperName=: tempnam LIMIT 1];
               }
               catch(Exception E){
                  createtaskforerror(cs.id, csownid, 'An unexpected error on Template---' + e.getMessage()); 
                  System.debug('Error message::'+e.getMessage());
               }
               System.debug('temp::'+temp);
               String emailBody;
               String emailSubject;
               if(temp != null){
               emailBody = temp.Body;
               emailSubject = temp.Subject;
               }
               //emailSubject = emailSubject.Replace('{!Case.Email_Subject_Value__c}', cs.Email_Subject_Value__c);
               emailSubject = emailSubject.Replace('{!Case.Sub_Status__c}', cs.Sub_Status__c);
               emailSubject = emailSubject.Replace('{!Case.Reason_for_hold__c}', cs.Reason_for_hold__c);
               emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', cs.Case_Ref_ID__c);
               emailSubject = emailSubject.Replace('{!Case.CaseNumber}', cs.CaseNumber);
               //emailBody = emailBody.replaceAll('\n', '<br/>');
               emailBody = emailBody.Replace('{!Case.CaseNumber}', cs.CaseNumber);
               emailBody = emailBody.Replace('{!Case.OwnerFullName}', Usrnam);
			   if(act.name!=null)
                  emailBody = emailBody.Replace('{!Case.Account_Name__c}', Act.name);
               else
                  emailBody = emailBody.Replace('{!Case.Account}', 'N/A' ); 
               if(cs.VN_Name__c != null)
                  emailBody = emailBody.Replace('{!Case.VN_Name__c}', cs.VN_Name__c);
               else
                  emailBody = emailBody.Replace('{!Case.VN_Name__c}', '');
               if(cs.Customer_Sold_To__c != null)
                  emailBody = emailBody.Replace('{!Case.Customer_Sold_To__c}', cs.Customer_Sold_To__c);
               else
                  emailBody = emailBody.Replace('{!Case.Customer_Sold_To__c}', 'N/A');
               if (cs.Sales_Order_Number__c != null)
                  emailBody = emailBody.Replace('{!Case.Sales_Order_Number__c}', cs.Sales_Order_Number__c);
               else
                  emailBody = emailBody.Replace('{!Case.Sales_Order_Number__c}','N/A');
               if(cs.Quote_Number__c != null)
               	  emailBody = emailBody.Replace('{!Case.Quote_Number__c}', cs.Quote_Number__c);
               else
                  emailBody = emailBody.Replace('{!Case.Quote_Number__c}', 'N/A');
               if(cs.Repair_Notification_Number__c != null)
               	  emailBody = emailBody.Replace('{!Case.Repair_Notification_Number__c}', cs.Repair_Notification_Number__c);
               else
                   emailBody = emailBody.Replace('{!Case.Repair_Notification_Number__c}', 'N/A');
               if(cs.Customer_PO_RO_WONumber__c != null)
               	   emailBody = emailBody.Replace('{!Case.Customer_PO_RO_WONumber__c}', cs.Customer_PO_RO_WONumber__c);
               else
                   emailBody = emailBody.Replace('{!Case.Customer_PO_RO_WONumber__c}', 'N/A');
               if(cs.Contract_Number__c != null)
               	   emailBody = emailBody.Replace('{!Case.Contract_Number__c}', cs.Contract_Number__c);
               else
                   emailBody = emailBody.Replace('{!Case.Contract_Number__c}','N/A');
               if(cs.Product_Number__r.Name != null)
              	   emailBody = emailBody.Replace('{!Case.Product_Number__c}', cs.Product_Number__r.Name);
               else
                   emailBody = emailBody.Replace('{!Case.Product_Number__c}', 'N/A');
               if(cs.Part_Number__c!= null)
              	   emailBody = emailBody.Replace('{!Case.Part_Number__c}', cs.Part_Number__c);
               else
                   emailBody = emailBody.Replace('{!Case.Part_Number__c}', 'N/A');
               emailBody = emailBody.Replace('{!Case.Reason_for_hold__c}', cs.Reason_for_hold__c);
               if(cs.Case_Comments__c != null)
               	   emailBody = emailBody.Replace('{!Case.Case_Comments__c}', cs.Case_Comments__c);
               else
                   emailBody = emailBody.Replace('{!Case.Case_Comments__c}', 'N/A');
               Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
               List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
               EmailMessage emailMsg = new EmailMessage();
               OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where Address = 'yourresponse@honeywell.com' limit 1];
               if(!(filst.isempty())){
        		for(contentDocumentLink cdl: filst){
           			 ContentDocumentids.add(cdl.ContentDocumentid);
        	     }
                 list<ContentVersion> ctvrsnlst = new list<ContentVersion>();
                 //String reasonmapval = reasonmap.get(cs.id)+ '%';
                 ctvrsnlst = [SELECT title, PathOnClient, FileType, versiondata FROM contentversion 
				              WHERE ContentDocumentId IN :ContentDocumentids AND title LIKE: cs.Reason_for_hold__c+ '%'];
                 System.debug('ctvrsnlst::'+ctvrsnlst);
                 if(!(ctvrsnlst.isempty())){
                 for (ContentVersion cversion : ctvrsnlst)
				 {
			  		blob flebody = cversion.versiondata;
			  		system.debug('body : '+flebody+'-----------'+cversion.title);
			  		Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    String Parentstrng = cversion.title;
                    System.debug('Parentstrng::'+Parentstrng);
                    string[] splitted = Parentstrng.split('\\-');
                    System.debug('splitted::'+splitted);
			  		efa.setFileName(splitted[1]);
			  		efa.setBody(flebody);
			  		fileAttachments.add(efa); 
			 	 }
                 }
                caseAttListMap.put(cs.id, fileAttachments);
        		}
               System.debug('Toaddr::'+Toaddrr);
               if(Toaddrr != null){
                   mail.setToAddresses(Toaddrr);
               }
               else{
                  createtaskforerror(cs.id, cs.OwnerId, 'No data found for To-address');
               }
                        //mail.setSubject(emailSubject);
                        mail.setBccSender(false);
               			mail.setTemplateId(temp.id);
               			if(caseAttListMap != null && caseAttListMap.get(cs.ID)!= null)
               				mail.setFileAttachments(caseAttListMap.get(cs.ID));
               			mail.setOrgWideEmailAddressId(owa.id);
               			mail.setTargetObjectId(cnt.id);
                        mail.setSaveAsActivity(false);
               			mail.setWhatId(cs.id);
                        msgList.add(mail);
               			// Created an EmailMessage and copy all details from above.
               			//emailMsg.FromAddress = eml;
               			emailMsg.FromAddress ='yourresponse@honeywell.com';
               			if(Toaddrr != null){
                            for(String toa: Toaddrr){
                                if(emailMsg.ToAddress != null)
               						emailMsg.ToAddress= emailMsg.ToAddress+';'+toa;
                                else
                                    emailMsg.ToAddress= toa;
                            }
               			}
                        emailMsg.Subject= emailSubject;
               			emailMsg.TextBody= emailBody;
                        emailMsg.ParentId = cs.id; //Attach with the case
                        emailMsg.MessageDate = system.now();
                        emailMsg.Status = '0';
               			emailMsgmap.put(cs.id, emailMsg);
               			if(Toaddrr != null)
                        	emmsglst.add(emailMsg);
               System.debug('msgList::'+msgList);
               System.debug('emmsglst::'+emmsglst);
           }
           Messaging.SendEmailResult[] results;
            try{
                if(!msgList.isEmpty() && msgList!=null){
                    results= Messaging.sendEmail(msgList);
                }
            }
            catch (Exception e){
                system.debug('An unexpected error for Escalated autoforward email---' + e.getMessage());
                //createtaskforerror(cs.id, csownid, 'An unexpected error for Escalated autoforward email---' + e.getMessage());
            }
        if(caslst.size()>0){
            database.update(caslst, true);
        }
        if(emmsglst.size()>0){
            database.insert(emmsglst, true);
        }
        if(newcalst.size()>0 && tsklst.size()>0){
            System.debug('Inserted new error task');
            database.insert(tsklst, true);
        }
        if(emmsglst != null){
        for(EmailMessage emll : emmsglst){
                if(emll.id!=null){
                    eMapIDs.put(emll.ParentID,emll.ID);
                }
        }
        system.debug('eMapIDs==>' +eMapIDs);
        List<Attachment> attchList = new List<Attachment>();
        List<Messaging.Emailfileattachment> emflst = new List<Messaging.Emailfileattachment>();
        Map<Id, List<Messaging.Emailfileattachment>> attchList2 = new Map<Id, List<Messaging.Emailfileattachment>>();
        Attachment attch;
        if(!eMapIDs.isEMpty()){
            //for(String cs: Casid){
            	emflst = caseAttListMap.get(cs.id);
                //attchList2.put(eMapIDs.get(cs), emflst);
            //attchList2 = [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN: Casid];
            if(emflst != null){
            for(Messaging.Emailfileattachment att : emflst) 
            {
                if(emailMsgmap.containsKey(cs.id))
                {
                    system.debug('entered attachment loop');
                    system.debug('att.ParentID==>' +cs.id);
                    attch= new Attachment();
                    attch.Name = att.FileName;
                    attch.Body = att.body;
                    attch.ParentID = eMapIDs.get(cs.id);
                    attchList.add(attch);
                }
            }
        }
        }
        system.debug('attchList==' +attchList);
        try{
            insert attchList;
        }
        catch(exception e){
            system.debug('atachment not inserted==>' + e.getMessage());
        }
        }
		} 
		}
    }
}