@isTest
public class SapExternalSystemPlatformUpdate_test
{ 
  
    static testmethod void SapExternalSystemPlatformUpdatetest()
    {
    list<Platform__c> lstplat = new list<Platform__c>();
        test.starttest();
        Platform__c plat=new Platform__c();
        plat.Name='Test Platform';
        plat.Model__c='Test Model';
        plat.Make__c='test make';
        lstplat.add(plat);
        Platform__c plat1=new Platform__c();
        plat1.Name='Test Platform1';
        plat1.Model__c='Test Model1';
        plat1.Make__c='test make1';
        lstplat.add(plat1);
        
        Insert lstplat;
        
        Platform_cross_ref__c pcr=new Platform_cross_ref__c();
        pcr.Name='test pcr';
        pcr.Cross_Ref_Type__c='test cross';
        pcr.Platform_Parent__c=plat.Id;
        pcr.External_System_Name__c='SAP';
        Insert pcr;
         pcr.Platform_Parent__c=plat1.Id;
        pcr.External_System_Name__c='SAP';
        update pcr;
         pcr.Platform_Parent__c=plat.Id;
        pcr.External_System_Name__c =' ';
        update pcr;
        
        test.stoptest();
    }
}