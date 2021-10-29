public with sharing class utilClass 
{
   /* 
    public static string createAircraft
    (
        string pOwnerAccount,
        string pAirName,
        string pMake,
        string pModel,
        string pTail,
        string pSerialNbr 
    )
    {
        string retstr;
        
        integer errLoc =0;
        
        try
        {   
            errLoc = 10;
            
            Fleet_Asset_Detail__c createAir = new Fleet_Asset_Detail__c();
            
            createAir.Account__c            = pOwnerAccount;
            createAir.Name                  = pAirName;
            //createAir.Aircraft_Make__c    = pMake;
            //createAir.Aircraft_Model__c   = pModel;
            createAir.TAIL_NUMBER__C  = pTail;
            createAir.SERIAL_NUMBER__C  = pSerialNbr;
            
            List<Platform__c> airPlat = [ Select  Id From Platform__c 
                        Where   OEM_NAME__C = :pMake 
                        And     MODEL__C = :pModel 
                    ];
            
            if(airPlat != null && airPlat.size() > 0)
            {
                createAir.Platform_Name__c  = airPlat[0].Id;
            }
            
            
            errLoc = 20;                        
            insert createAir;
                        
                            if(createAir.Id!= null)
                            {
                                errLoc = 30;                                
                                retstr = createAir.Id;
                            }
                            else
                            {
                                errLoc = 40;                                
                                retstr = null;
                            }
                        errLoc = 50;            
            return retstr;
        
        }
        catch(DmlException e)
        {
                        createErrorLog
                                     (
                                     'utilClass',
                                     'createAircraft',
                                     'ERRLOC:'+errLoc+' - '+e.getMessage()
                                     );
                        retstr = null;
                        return retstr;
                        
        }
        
    }
    
    public static string createOppAircraft
                                        (
                                            string pOppId,
                                            string pAirId
                                        )
                                        {
                                            string retstr;
                                            integer errLoc =0;
                                            try
                                            {
                                                            errLoc =10;
                                                            
                                                            Opportunity_Fleet_Asset_Detail__c oppAircraft = new Opportunity_Fleet_Asset_Detail__c();
                                                            
                                                            oppAircraft.Fleet_Asset_Detail__c = pAirId;
                                                            oppAircraft.Opportunity__c = pOppId;
                                                            
                                                            List<Fleet_Asset_Detail__c> objAir = [select AIRCRAFT_REG_TAIL__c,Aircraft_Serial__c from Fleet_Asset_Detail__c where Id= :pAirId ];
                                                            
                                                            for(integer i=0;i<objAir.size();i++)
                                                            {
                                                                
                                                                oppAircraft.Tail_Number__c = objAir[0].AIRCRAFT_REG_TAIL__c;
                                                                oppAircraft.Aircraft_Serial_No__c = objAir[0].Aircraft_Serial__c;
                                                                
                                                            }
                                                            
                                                            errLoc =20;
                                                            insert oppAircraft;
                                                            
                                                            errLoc =30;
                                                            if(oppAircraft.Id!= null)
                                                            {
                                                                    errLoc =40;
                                                                    retstr = oppAircraft.Id;
                                                            }
                                                            else
                                                            {
                                                                    errLoc =50;
                                                                    retstr = null;
                                                            }
                                                            
                                                            
                                                            Opportunity opp = new Opportunity(Id=pOppId);

                                                            for(integer i=0;i<objAir.size();i++)
                                                            {
                                                                opp.Aircraft_Reg_Tail__c = objAir[0].AIRCRAFT_REG_TAIL__c;
                                                                opp.Aircraft_Serial__c   = objAir[0].Aircraft_Serial__c;
                                                            }
                                                            
                                                             update opp;
                                                            
                                                            errLoc =60; 
                                                            return retstr;
                                            }
                                            catch(DmlException e)
                                            {
                                                createErrorLog
                                                             (
                                                             'utilClass',
                                                             'createOppAircraft',
                                                             'ERRLOC:'+errLoc+' - '+e.getMessage()
                                                             );     
                                                                
                                                retstr = null;
                                                return retstr;
                        
                                            }

                                            
                                            
                                        }
    */
 /*   public static string createOppProduct
                                        (
                                                string  pDescription ,
                                                string  pOpportunityId ,
                                                string  pPriceBookEntryId ,
                                                integer pQuantity ,
                                                date    pServiceDate ,
                                                double  pUnitPrice  
                                        )
    {
        string retstr;
        integer errLoc =0;
        
        try
        {   
                            errLoc =10;
                            OpportunityLineItem  createOppProd = new OpportunityLineItem();
                        
                            createOppProd.Description       = pDescription      ; 
                            createOppProd.OpportunityId     = pOpportunityId    ; 
                            createOppProd.PriceBookEntryId  = pPriceBookEntryId ;
                            createOppProd.Quantity          = pQuantity         ;
                            createOppProd.ServiceDate       = pServiceDate      ;
                            createOppProd.UnitPrice         = pUnitPrice        ; 
                            
                            errLoc =20;
                        
                            insert createOppProd;
                            
                            errLoc =30;
                            
                            if(createOppProd.Id!= null)
                            {
                                errLoc =40; 
                                retstr = createOppProd.Id;
                            }
                            else
                            {
                                errLoc =50;
                                retstr = null;
                            }
            errLoc =60;
            return retstr;
        
        }
        catch(DmlException e)
        {
                                                createErrorLog
                                                             (
                                                             'utilClass',
                                                             'createOppProduct',
                                                             e.getMessage()
                                                             );         
            
                        retstr = null;
                        return retstr;
                        
        }
        
    }*/

    
        public static void createErrorLog
                                        (
                                                string  pTableName      ,
                                                string  pCodeObjectName ,
                                                string  pErrorMsg 
                                        )
    {
        

        
    }
    
    
}