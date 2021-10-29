trigger APTS_Asset_Change on Apttus_Config2__AssetLineItem__c (after insert, after update, after delete) {
    Set<ID> accountIdsToRecalculate = new Set<ID>();
    if (Trigger.isUpdate || Trigger.isInsert) {
         for (Apttus_Config2__AssetLineItem__c asset : Trigger.new) {
                if (asset.Apttus_Config2__ShipToAccountId__c != null && 
                    asset.APTS_ISV_Impact__c == 'Yes'
                    )
                   {
                       accountIdsToRecalculate.add(asset.Apttus_Config2__ShipToAccountId__c);
                   }
         }
    } else {
         for (Apttus_Config2__AssetLineItem__c asset : Trigger.old) {
             if (asset.Apttus_Config2__ShipToAccountId__c != null && asset.APTS_ISV_Impact__c == 'Yes') {
                 accountIdsToRecalculate.add(asset.Apttus_Config2__ShipToAccountId__c);
             }
         }
    }
    if (accountIdsToRecalculate.size() > 0) {
        List<Account> UpdatedAccount = New List<Account>(); 
        List<Account> Acclst = [Select id,(Select Apttus_Config2__NetPrice__c,Apttus_Config2__ShipToAccountId__c,Apttus_Config2__AssetStatus__c,APTS_ISV_Impact__c  From Apttus_Config2__AssetLineItemsShipTo__r  
                                        Where APTS_ISV_Impact__c = 'Yes' 
                                         and Apttus_Config2__AssetStatus__c != 'Cancelled'
                                         and Apttus_Config2__AssetStatus__c != 'Suspended'
                                         and Apttus_Config2__AssetStatus__c != 'Superseded'
                                         and Apttus_Config2__NetPrice__c != null) from Account where ID IN : accountIdsToRecalculate];
        For(Account A :Acclst)
        {                                 
           Decimal netPrice = 0.00;                              
        for (Apttus_Config2__AssetLineItem__c Al :A.Apttus_Config2__AssetLineItemsShipTo__r  ) 
          { 
            netPrice = netPrice + Al.Apttus_Config2__NetPrice__c;
            
           
          }
         A.APTS_Aviaso_ISV__c = netPrice;
         UpdatedAccount.Add(A);
        }
        IF(UpdatedAccount.Size()>0)
        {
        update UpdatedAccount;
        }
    }
}