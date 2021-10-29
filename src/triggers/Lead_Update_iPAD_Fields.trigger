trigger Lead_Update_iPAD_Fields on Lead (before insert) 
{
    enum iPADUsed {Yes , No}
    class iPADLeadSourceAndRecType{
        public String iPADLeadSource;
        public String recType;
        iPADLeadSourceAndRecType(String pIPADLeadSource,String pRecType){   
            this.iPADLeadSource = pIPADLeadSource;
            this.recType        = pRecType;
        }
    }
try{    
    //---------------------------------------------------------------
    // Map for iPAD lead source and related record type
    // If you want to map new ipad lead source and record type 
    // ( and assign accordingly), then just add new key pair value;
    //---------------------------------------------------------------
    
    final   Map<String,iPADLeadSourceAndRecType> iPadLeadSourceAndRecordTypeMap 
            =  
            new Map<String,iPADLeadSourceAndRecType>
                                    {
                                        // For QA
                                       // 'BA' => new iPADLeadSourceAndRecType('iPad Lead - BA','012T00000000hGg')
                                        //For Prod
                                        'BA' => new iPADLeadSourceAndRecType('iPad Lead - BA','01230000000bH5N')
                                    };
    
    for(Lead ld : Trigger.new)
    {
                //---------------------------------------------------------------
                // Assign record type if lead is coming from iPAD   
                //---------------------------------------------------------------
                    

                if(ld.IPAD_Lead_Source__c != null)
                {
                    //---------------------------------------------------------------
                    // Set Lead record type as 'BGA lead record type' if iPAD lead is for BA
                    //---------------------------------------------------------------
                    
                    for(String keyVal : iPadLeadSourceAndRecordTypeMap.keySet())
                    {
                            if( iPadLeadSourceAndRecordTypeMap.get(keyVal).iPADLeadSource 
                                == 
                                ld.IPAD_Lead_Source__c
                              )
                            {
                                ld.RecordTypeId = iPadLeadSourceAndRecordTypeMap.get(keyVal).recType;
                            }
                    }
                }
                
                //---------------------------------------------------------------
                // Set default iPad Used in Lead Conversation? field values
                //---------------------------------------------------------------
                
                if(ld.iPad_Used_in_Lead_Conversation__c == null )       
                {   
                            if (ld.IPAD_Lead_Source__c == null)
                            {
                                   // ld.iPad_Used_in_Lead_Conversation__c = iPADUsed.No.name();
                            }
                            else 
                            {
                                    ld.iPad_Used_in_Lead_Conversation__c = iPADUsed.Yes.name();
                            }
                }
                
    }
}
catch(Exception e)
{
    System.debug('Error inside trigger : (Lead_Update_iPAD_Fields) : '+ e.getMessage());
}
}