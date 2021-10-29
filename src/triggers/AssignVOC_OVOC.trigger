trigger AssignVOC_OVOC on Voice_of_Customer__c (before insert,before update, after insert, after update) {

    if(trigger.IsBefore) {
    /*
        string prevoc = '';
        string preovoc = '';    
        // Assigning VOC/OVOC record number to VOC records
        VOC_OVOC_Record_Number__c VVR = [select id,name,VOC__c,OVOC__c from VOC_OVOC_Record_Number__c where name =:'Reference record' limit 1];
        integer vocrec = integer.valueOf(VVR.VOC__c);
        integer ovocrec = integer.valueOf(VVR.OVOC__c);
        for(Voice_of_Customer__c vc:trigger.new) {
            if(vc.recordtypeid == Label.VOC_RecType_Id && vc.Status__c == 'Submitted' && (vc.VOC__c == 'VOC-DRAFT' || vc.VOC__c == '' || vc.VOC__c == null)) {
                vocrec++;
                if (vocrec >= 0 && vocrec<=9) {
                    prevoc = '000';
                }
                else if (vocrec >= 10 && vocrec<=99) {
                    prevoc = '00';    
                }
                else if (vocrec >= 100 && vocrec<=999) {
                    prevoc = '0';    
                }

                else {
                    prevoc = '';
                } 
                    vc.VOC__c = 'VOC-'+prevoc+vocrec; 
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+vocrec);           
            }  
            else if(vc.recordtypeid == Label.OVOC_RecType_Id && vc.Status__c == 'Submitted' && (vc.VOC__c == 'OVOC-DRAFT' || vc.VOC__c == '' || vc.VOC__c == null)) {
            system.debug('################################'+ovocrec);
                ovocrec++;
                system.debug('#################Later###############'+ovocrec);
                if (ovocrec >= 0 && ovocrec <= 9) {
                    preovoc = '000';
                    system.debug('#################prevoc ###############'+prevoc );
                }
                else if (ovocrec >= 10 && ovocrec<=99) {
                    preovoc = '00';    
                }
                else if (ovocrec >= 100 && ovocrec<=999) {
                    preovoc = '0';    
                }
                else {
                    preovoc = '';
                     system.debug('################################Inside Else'+preovoc);
                } 
                system.debug('################################'+preovoc);
                vc.VOC__c = 'OVOC-'+preovoc+ovocrec;
                 system.debug('################################'+ovocrec);   
                 system.debug('################################'+vc.VOC__c);  
            }
        }  
        system.debug('################################ string.valueOf(ovocrec) '+string.valueOf(ovocrec));
        VVR.VOC__c = string.valueOf(vocrec);
        VVR.OVOC__c = string.valueOf(ovocrec);
        system.debug('################################ VVR.OVOC__c '+VVR.OVOC__c);  
        update VVR;
        
        */
        /*for(Voice_of_Customer__c vc:trigger.new) {
            if(vc.Status__c == 'Submitted' && vc.ownerid != vc.OVOC_Queue_Id__c ) {            
                 vc.ownerid = vc.OVOC_Queue_Id__c;
            }
        }*/
        for(Voice_of_Customer__c vc:trigger.new) {
            if(vc.recordtypeid == Label.VOC_RecType_Id && vc.Status__c == 'Submitted') {
                if(vc.Name != null) {
                    vc.VOC__c = 'VOC-'+ vc.Name.replace('VOC-','');
                }
            }
            else if(vc.recordtypeid == Label.OVOC_RecType_Id && vc.Status__c == 'Submitted') {
                if(vc.Name != null) {
                    vc.VOC__c = 'OVOC-'+ vc.Name.replace('VOC-','');
                }
            }
        }
        
    }  
    
    
    if(trigger.isafter) {
        list<Voice_of_Customer__Share> vocsharelist = new List<Voice_of_Customer__Share>();
        list<Voice_of_Customer__c> updateList = new list<Voice_of_Customer__c>();  
        for(Voice_of_Customer__c vc:trigger.new) {
            if(vc.Status__c == 'Submitted' && vc.Sensitive__c == true) {
                Voice_of_Customer__Share vocshare= new Voice_of_Customer__Share();
                vocshare.ParentId = vc.id;
                vocshare.UserOrGroupId = vc.createdbyid;
                vocshare.AccessLevel = 'Read';              
                vocshare.RowCause = Schema.Voice_of_Customer__Share.RowCause.Manual; 
                try {
                   Database.SaveResult sr = Database.insert(vocshare,false);
                }
                catch (exception e) {
                    system.debug('Error in trigger AssignVOC_OVOC '+e);
                }
                // vocsharelist.add(vocshare);         
            }
       }  
           
        
        List<string>queueIdlist = new list<string>();
        for(Voice_of_Customer__c vc:trigger.new) {
            string vocownerd = vc.OwnerId;
            string t1 = vocownerd.substring(0,15);
            queueIdlist.add(t1);
        }
        List<Feeditem> insertfeedlist = new List<Feeditem>();
        if(trigger.isinsert) {            
         /*   List<VOC_Group_Queue_Map__c> ChatterGrpQueueList = [select Id,Name,groupid__c,Queue_Id__c from VOC_Group_Queue_Map__c where Queue_Id__c in: queueIdlist];
            // Newly added starts
            List<VOC_Product_Family_Chatter__c> PrdFamilyChatterList = [Select Id,Name,Chatter_Group_ID__c,Chatter_Group_Name__c from VOC_Product_Family_Chatter__c];
            // Newly added ends
            for(VOC_Group_Queue_Map__c vcs: ChatterGrpQueueList) {
                for(Voice_of_Customer__c vc:trigger.new) {
                    //Voice_of_Customer__c oldvoc = Trigger.oldMap.get(vc.id);
                    if(vc.Status__c == 'Submitted' && vc.Sensitive__c == true ) {
                        FeedItem fitem=new FeedItem();
                        fitem.parentId = vcs.groupid__c;
                        fitem.linkUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + vc.Id;
                        fitem.title = vc.VOC__c;
                        insertfeedList.add(fitem);
                    }
                }
            }
            // Newly added starts
            List<string> productfamilyList = new List<string>();
            List<String> newList = new List<String>();
            for(Voice_of_Customer__c vc:trigger.new) {
                if(vc.Status__c == 'Submitted' && vc.Product_Family__c != null) {
                    String[] tmpString = vc.Product_Family__c.split(';');
                    For(String s : tmpString) {
                        productfamilyList.add(s);
                    }   
                }  
            }
            for(VOC_Product_Family_Chatter__c pfc: PrdFamilyChatterList) {
                system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'+pfc.Chatter_Group_Name__c);
                for(Voice_of_Customer__c vc:trigger.new) {
                    for(string strpf: productfamilyList) {
                    system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'+strpf);
                        if(vc.Status__c == 'Submitted' && pfc.Name == strpf) {
                            FeedItem fitem=new FeedItem();
                            fitem.parentId = pfc.Chatter_Group_ID__c;
                            fitem.linkUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + vc.Id;
                            fitem.title = vc.VOC__c;
                            insertfeedList.add(fitem);   
                        }  
                    }  
                }    
            }
            // Newly added ends
          */ 
            
        }        
        if(trigger.isupdate) {
            List<VOC_Group_Queue_Map__c> ChatterGrpQueueList = [select Id,Name,groupid__c,Queue_Id__c from VOC_Group_Queue_Map__c where Queue_Id__c in: queueIdlist];
            // Newly added starts
            List<VOC_Product_Family_Chatter__c> PrdFamilyChatterList = [Select Id,Name,Chatter_Group_ID__c,Chatter_Group_Name__c from VOC_Product_Family_Chatter__c];
            // Newly added ends
            for(VOC_Group_Queue_Map__c vcs: ChatterGrpQueueList) {
                for(Voice_of_Customer__c vc:trigger.new) {
                    Voice_of_Customer__c oldvoc = Trigger.oldMap.get(vc.id);
                    if(vc.Status__c == 'Submitted' && vc.Sensitive__c == true ) { //&& oldvoc.Status__c == 'Draft'
                        FeedItem fitem=new FeedItem();
                        fitem.parentId = vcs.groupid__c;
                        fitem.linkUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + vc.Id;
                        fitem.title = vc.VOC__c;
                        insertfeedList.add(fitem);
                    }
                }
            }
            // Newly added starts
            List<string> productfamilyList = new List<string>();
            List<String> newList = new List<String>();
            for(Voice_of_Customer__c vc:trigger.new) {
                if(vc.Status__c == 'Submitted' && vc.Product_Family__c != null) {
                    String[] tmpString = vc.Product_Family__c.split(';');
                    For(String s : tmpString) {
                        productfamilyList.add(s);
                    }   
                }  
            }
            for(VOC_Product_Family_Chatter__c pfc: PrdFamilyChatterList) {
                system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'+pfc.Chatter_Group_Name__c);
                for(Voice_of_Customer__c vc:trigger.new) {
                    Voice_of_Customer__c oldvoc = Trigger.oldMap.get(vc.id);
                    for(string strpf: productfamilyList) {
                    system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'+strpf);
                        if(vc.Status__c == 'Submitted' && pfc.Name == strpf) { // && oldvoc.Status__c == 'Draft'
                            FeedItem fitem=new FeedItem();
                            fitem.parentId = pfc.Chatter_Group_ID__c;
                            fitem.linkUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + vc.Id;
                            fitem.title = vc.VOC__c;
                            insertfeedList.add(fitem);   
                        }  
                    }  
                }    
            }
            // Newly added ends
            id UID = userinfo.getuserId();
                User u = [select id,contactId from user where id=:UID limit 1];
                if(u.contactid != null) {
                    id conId = u.ContactId;
                    for(Voice_of_Customer__c vc:trigger.new) {
                        if(vc.Status__c == 'Submitted') {                           
                            string emailid = userinfo.getUserEmail();
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                            String[] toAddresses = new String[] {emailid}; 
                            mail.setWhatId(vc.Id);
                            mail.setToAddresses(toAddresses); 
                            mail.setTemplateId(Label.OVOC_Template_ID);
                            mail.setTargetObjectId(conId);
                            mail.setOrgWideEmailAddressId(Label.OVOC_Org_Wide_ID);
                            mail.saveAsActivity = false;
                            try {
                                Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
                            }
                            catch (exception e) {
                                system.debug('Error is in expression '+e);
                            }
                        }
                    }
                }
            }

        if(insertfeedList.size() >0) {
            insert insertfeedList; 
            system.debug('========================================'+insertfeedList);
        }  
        
    }   
    

}