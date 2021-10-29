@isTest(seealldata=true)
Public class CaseCreationSitecoretoSFDCTest{
    static testmethod void testmethod31(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'NavDB Accounts';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Type of Product: Mechanical';
        cs.SUBJECT = 'MyAerospace Technical Training Services Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
   static testmethod void testmethod21(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'NavDB Accounts';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Type of Product: Mechanical';
        cs.SUBJECT = 'MyAerospace BendixKing Warranty Credit Request';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }    
    
   static testmethod void testmethod22(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = con.Primary_Email_Address__c;
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Orders';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Address Updates';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        cs.SALES_ORDER_NUM='123456';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }  
    
    static testmethod void testmethod23(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = con.Primary_Email_Address__c;
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Orders';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Request Copy of Invoice';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        cs.SALES_ORDER_NUM='123456';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }                  
  
  static testmethod void testmethod24(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Orders';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Request Copy of Invoice';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        cs.SALES_ORDER_NUM='123456';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }  
    
    static testmethod void testmethod25(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Orders';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Address Updates';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        cs.SALES_ORDER_NUM='123456';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }  
     
    static testmethod void testmethod32(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='harikishore.vutukuri@honeywell.com' limit 1]; 
        cs.EmailAddress = 'harikishore.vutukuri@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Pilot'+'\''+'s Corner Avionics';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Type of Product: Services';
        cs.SUBJECT = 'MyAerospace Technical Training Services Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    static testmethod void testmethod33(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Web Portal Registration';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Technical Training Services Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'ADAHRS';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    static testmethod void testmethod1(){
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='harikishore.vutukuri@honeywell.com' limit 1]; 
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        cs.EmailAddress = con.Primary_Email_Address__c;
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Warranty Credit Request';
        cs.status = 'Open';
        cs.TYPE = 'Orders';
        CaseCreationSitecoretoSFDC.Attachmentlist at = new CaseCreationSitecoretoSFDC.Attachmentlist();
        List<CaseCreationSitecoretoSFDC.Attachmentlist> attlist= new List<CaseCreationSitecoretoSFDC.Attachmentlist>(); 
        at.AttBody = 'test';
        at.AttFileName = 'Testattachment';
        at.AttContentType = 'pdf';
        attlist.add(at);
        cs.Attachments = attlist;
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod2(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'WEB Support';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Training / Assistance';
        List<CaseCreationSitecoretoSFDC.PARTPRODUCTDETAILS> PARTPROD= new List<CaseCreationSitecoretoSFDC.PARTPRODUCTDETAILS>();       
        CaseCreationSitecoretoSFDC.PARTPRODUCTDETAILS pt = new CaseCreationSitecoretoSFDC.PARTPRODUCTDETAILS();
        pt.PartNumber = '123';
        pt.CageCode = '64';
        pt.SerialNumberShipped = '865';
        pt.AdditionalLineInfo = 'test';
        pt.Quantity = '423.13';
        pt.NetPrice = '534.35';
        pt.CaselineitemNumber = '123';
        pt.ProductName ='test';
        pt.ProductNumber ='123';
        pt.CaseNumber='123';
        pt.Discount='23';
        pt.DateNeeded = string.valueOf(system.now());
        PARTPROD.add(pt);
        cs.PARTPRODUCT = PARTPROD;
        
        List<CaseCreationSitecoretoSFDC.Attachmentlist> attlist= new List<CaseCreationSitecoretoSFDC.Attachmentlist>();       
        CaseCreationSitecoretoSFDC.Attachmentlist at = new CaseCreationSitecoretoSFDC.Attachmentlist();
        at.AttBody = 'test';
        at.AttFileName = 'Testattachment';
        at.AttContentType = 'pdf';
        attlist.add(at);
        cs.Attachments = attlist;
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod3(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Training';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Technical Training Services Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod4(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Tech Pubs';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Technical Pubs General Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod5(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Technical Issue';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Technical Issue (Product Specific)';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod6(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'General';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Product Stewardship Other';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod7(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Orders';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace Sending Payment';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        cs.CUSTOMER_PO_RO_WO_NUM = '121';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }    

    Static testmethod void testmethodupdate7(){
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        Case cas = new case();
        cas.SuppliedEmail = 'nandini.nanjappan@honeywell.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Contactid = con.id;
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'open';
        cas.Description = 'Test';
        cas.Subject = 'MyAerospace Submit a Paper PO';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId  = label.Order_RecordType;
        cas.Sales_Order_Number__c ='123456';
        Test.starttest();
        insert cas;
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        case cas1= [select id,contactid,Customer_PO_RO_WONumber__c,recordtypeid from case  where Customer_PO_RO_WONumber__c =: cas.Customer_PO_RO_WONumber__c  and isclosed = false and recordtypeid =: label.Order_RecordType limit 1]; 
        cs.CUSTOMER_PO_RO_WO_NUM = cas1.Customer_PO_RO_WONumber__c;
        cs.EmailAddress = con.Primary_Email_Address__c;
        cs.SUBJECT = 'MyAerospace Submit a Paper PO';
        Task tk = new task();
        tk.OwnerId = Label.aero_default_user_id;
        tk.WhoId = con.id;
        tk.WhatId = cas1.id;
        tk.subject = 'Test';
        tk.RecordTypeId = Label.R_O_Activity_Label;
        tk.Priority= 'normal';
        tk.Description = 'Test task';
        tk.Status = 'open';
        insert tk;
        Test.stoptest();
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }  
    
    static testmethod void testmethod8(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'MSP Contract';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace General MSP Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod9(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'HAPP MPP Contracts';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace MPP Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod10(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'Global Customer Committee';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace GCC General Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod11(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'EGPWS';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Test';
        cs.SUBJECT = 'MyAerospace GCC General Inquiry';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    Static testmethod void testmethod12(){
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='harikishore.vutukuri@honeywell.com' limit 1]; 
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        //case cas1= [select id,contactid,Customer_PO_RO_WONumber__c,recordtypeid from case  where Customer_PO_RO_WONumber__c =: cas.Customer_PO_RO_WONumber__c  and isclosed = false and recordtypeid =: label.Order_RecordType limit 1]; 
        cs.EmailAddress = con.Primary_Email_Address__c;
        cs.SUBJECT = 'MyAerospace Sending Payment';
        cs.status = 'Open';
        cs.TYPE = 'Orders';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
        
        CaseCreationSitecoretoSFDC.CaseData cs1 =  new CaseCreationSitecoretoSFDC.CaseData();
        cs1.EmailAddress = con.Primary_Email_Address__c;
        cs1.SUBJECT = 'MyAerospace Address Updates';
        cs1.status = 'Open';
        cs1.TYPE = 'Orders';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore1 = CaseCreationSitecoretoSFDC.createCase(cs1);
    }
    
    static testmethod void testmethod13(){
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='harikishore.vutukuri@honeywell.com' limit 1]; 
        CaseCreationSitecoretoSFDC.CaseData cs11 =  new CaseCreationSitecoretoSFDC.CaseData();
        cs11.EmailAddress = 'test@test.com';
        cs11.SUBJECT = 'MyAerospace Address Updates';
        cs11.status = 'Open';
        cs11.TYPE = 'Orders';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore11 = CaseCreationSitecoretoSFDC.createCase(cs11);
    
    }

    static testmethod void testmethod15(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nandini.nanjappan@honeywell.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'orders';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Type of Product: Bendix King';
        cs.SUBJECT = 'MyAerospace Sending Payment';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
    
    static testmethod void testmethod16(){
        CaseCreationSitecoretoSFDC.CaseData cs =  new CaseCreationSitecoretoSFDC.CaseData();
        Contact con= [select id,accountid,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email='Sofiya.peermohamed@honeywell.com' limit 1]; 
        cs.EmailAddress = 'nand123@gmail.com';
        cs.AdditionalWebFormInfo = 'test';
        cs.Origin = 'web';
        cs.Contactid = con.id;
        cs.Priority = 'normal';
        cs.TYPE = 'orders';
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.Status = 'open';
        cs.DESCRIPTION = 'Type of Product: Electrical';
        cs.SUBJECT = 'MyAerospace Sending Payment';
        cs.InvoiceNumber = '123';
        cs.Aircrafttype = 'aircrafttest';
        cs.AircraftSerialNumber = '356';
        cs.ProductType = 'test';
        cs.IntendedUse = 'test1';
        cs.EndUseforthisPartAssembly = 'test2';
        cs.changetype = 'Expedite';
        cs.PartNumber = '313';
        cs.AircraftTailNumber = '12323';
        //cs.DateofFailure = date.today();
        cs.ReasonForRemoval = 'test';
        cs.HoneywellInvoiceNumber = '655';
        cs.ExternalRef = '432';
        CaseCreationSitecoretoSFDC.CaseDataSFDCtoSitecore casetositecore = CaseCreationSitecoretoSFDC.createCase(cs);
    }
}