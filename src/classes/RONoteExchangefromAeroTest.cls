// This is the test class for RONoteExchangefromAero

@isTest
public class RONoteExchangefromAeroTest
{
    testMethod static void WrapperDataMethod(){
        RONoteExchangefromAero.AeroExchange roe = new RONoteExchangefromAero.AeroExchange();
        test.startTest();
        RONoteExchangefromAero.AexNoteResponse(roe);
        test.stopTest();
    }
    
    testMethod static void NoteMethod(){
        RONoteExchangefromAero.AeroExchange aex = new RONoteExchangefromAero.AeroExchange();
        
        RONoteExchangefromAero.AEX_NotesExchangeWithDocAttach noteExchangewAttachlist=new RONoteExchangefromAero.AEX_NotesExchangeWithDocAttach();
        List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader> AEX_NotesExchangeWithDocAttachHeaderlist=new List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader>();
        List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails> AEXNotesExchangeWithDocAttachDetailslst=new  List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails>();
        
        RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader ron = new RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader();
        List<RONoteExchangefromAero.CommunicationArea> CommArealist=new List<RONoteExchangefromAero.CommunicationArea>();
        List<RONoteExchangefromAero.CommunicationArea> CommArealist1=new List<RONoteExchangefromAero.CommunicationArea>();
        List<RONoteExchangefromAero.MessageSender> MessageSenderList=new List<RONoteExchangefromAero.MessageSender>();
        
        List<RONoteExchangefromAero.RequestAttachments> RequestAttachmentsList = new List<RONoteExchangefromAero.RequestAttachments>();
        RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails roa = new RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails();
        RONoteExchangefromAero.MessageSender rms = new RONoteExchangefromAero.MessageSender();
        RONoteExchangefromAero.CommunicationArea rmc = new RONoteExchangefromAero.CommunicationArea();
        RONoteExchangefromAero.RequestAttachments att = new RONoteExchangefromAero.RequestAttachments();
  //   noteExchangewAttachlist=aex.AEX_NotesExchangeWithDocAttach;
       
   // system.debug('AEX_NotesExchangeWithDocAttachHeaderlist==' +AEX_NotesExchangeWithDocAttachHeaderlist.size());
        rmc.CustomerCode = 'CustomerCode' ;
        rmc.SupplierCageCode = 'SupplierCageCode';
        rmc.MessageSeqID = 'MessageSeqID' ;
        rmc.CreationDateTime = string.valueOf(system.now()) ;
        CommArealist.add(rmc);
       //system.debug('size debug==' +ron.AEX_NotesExchangeWithDocAttachHeader.size());
		//ron = RONoteExchangefromAero.CommunicationArea; 
        
        rms.ID = '111';
        rms.Name = 'test';
        rms.CompanyCode= 'test aero';
        rms.Email = 'sample@test.com';
        rms.Telephone = '1234567898';
        rms.Fax = '1234567898';
        //  ron = rms.MessageSender;
        MessageSenderList.add(rms);
        
        
        String Attbody = EncodingUtil.base64Encode(Blob.valueof('Testing XML Attachments'));
        att.FileReference = Attbody ;
        att.FileName = 'TestFileName' ;
        att.FileType = 'application/pdf';
        RequestAttachmentsList.add(att);
        
        
        
        ron.CommunicationArea = CommArealist;
        ron.MessageSender = MessageSenderList;
        roa.ServiceOrderNumber = '12345678';
        roa.attachment = RequestAttachmentsList;
      
       AEXNotesExchangeWithDocAttachDetailslst.add(roa);
        AEX_NotesExchangeWithDocAttachHeaderlist.add(ron);
        noteExchangewAttachlist.AEX_NotesExchangeWithDocAttachHeader = AEX_NotesExchangeWithDocAttachHeaderlist;
        noteExchangewAttachlist.AEX_NotesExchangeWithDocAttachDetails = AEXNotesExchangeWithDocAttachDetailslst;
        aex.AEX_NotesExchangeWithDocAttach = noteExchangewAttachlist;
        system.debug('size debug==' +AEX_NotesExchangeWithDocAttachHeaderlist.size());
        system.debug('size debug11==' +noteExchangewAttachlist.AEX_NotesExchangeWithDocAttachHeader);
        //AEX_NotesExchangeWithDocAttachHeaderlist.add(MessageSenderList);
        /*MSID = msg.ID;
            MSName = msg.Name;
            MSCompanyCode = msg.CompanyCode;
            MSEmail = msg.Email;
            MSTelephone = msg.Telephone;
            MSFax = msg.Fax;*/
        for(RONoteExchangefromAero.CommunicationArea cm : CommArealist)
        {
            cm.CustomerCode = 'CustomerCode' ;
            cm.SupplierCageCode = 'SupplierCageCode';
            cm.MessageSeqID = 'MessageSeqID' ;
            cm.CreationDateTime = string.valueOf(system.now()) ;
            CommArealist1.add(cm);
        }
        
         List<case> updateCase = new List<case>();
         set<ID> csID = new set<ID>();
         String shortText = 'EDI Outbound Notes_Req Shipping Info';
         List<Z_Task__c> orglist = new List<Z_Task__c>();
         list<account> accs = new list <account>();
         list<case> cse = new list <case>();
         Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
         account acc = new account ();
         acc.name = 'test1';
         acc.EMAIL__c = 'test@gmail.com';
         accs.add(acc);
         
         Z_Task__c zst = new Z_Task__c();
         zst.type__c = 'Z146';
        //zst.RelatedTo__c = cse[0].id; 
         zst.status__c = 'closed';
         orglist.add(zst);
         insert zst;
         system.debug(orglist);

      
        //RONoteExchangefromAero.AEX_NotesExchangeWithDocAttach = AEX_NotesExchangeWithDocAttachHeaderlist;
       /* for(RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails ro :AEXNotesExchangeWithDocAttachDetailslst)
        {
          noteExchangewAttachlist = ro;  
        }*/
       // noteExchangewAttachlist.add(AEXNotesExchangeWithDocAttachDetailslst);
        test.startTest();
        RONoteExchangefromAero.AexNoteResponse(aex);
        test.stopTest();
        
    } 


}