@isTest

public class Test_CommentList{
        static testMethod void testCommentlist(){
        Test.startTest();
        //make test data
        Contact foo = new Contact(FirstName = 'Foo', LastName='Bar',Primary_Email_Address__c='sindhuja.velmurugan@sample.com',Phone_3__c='3333333',Phone_1__c='4444444');
        
        insert foo;
        
        Case c = new Case(Subject = 'Test case', ContactId=foo.id //No_FCR_Reason__c ='Not Trained'For Ticket INC000009687923
                         );
        Insert c;
        
        CaseComment cmt1 = new CaseComment(
            ParentId = c.id,
            IsPublished = false,
            CommentBody = 'A private comment from a user.'
        );
        CaseComment cmt2 = new CaseComment(
            ParentId = c.id,
            IsPublished = true,
            CommentBody = 'Recipients: Foo Bar A public comment from a client.'
        );
        Insert cmt1;
        Insert cmt2;
        
        cmt2.IsPublished = true; 
        update cmt2;
        
        Attachment attch = new Attachment();
        attch.body = Blob.valueOf('Unit Test Attachment Body');
        attch.Name = 'test.txt';
        attch.ParentId = c.id;
        
        insert attch;
        
       
                
        //load page
        System.currentPageReference().getParameters().put('id', c.id);
        CommentList cl = new commentlist(new ApexPages.StandardController(c));
        List<CommentList.CaseCommentExt> cmtItems = cl.getFilteredCommentItems();
        System.assert(cl.getCaseId() == c.id);
        
        System.assertEquals(true, cl.publicFilter);
        System.assertEquals(true, cl.privateFilter);
        System.assertEquals(true, cl.statusFilter);
        System.assertEquals(2, cmtItems.size());
        System.assertEquals('max-height: 1000px;', cl.getTableHeight());
        
        
        cl.publicFilter = false;
        cmtItems = cl.getFilteredCommentItems();
        System.assertEquals(1, cmtItems.size());
        System.assert(cmtItems[0].cmt.CommentBody == cmt1.CommentBody);
        System.assert(cmtItems[0].cmt.IsPublished == cmt1.IsPublished);
        
        cl.publicFilter = true;
        cl.privateFilter = false;
        cl.refreshPage();
        cmtItems = cl.getFilteredCommentItems();
        System.assertEquals(1, cmtItems.size());
        System.assert(cmtItems[0].cmt.CommentBody == cmt2.CommentBody);
        System.assert(cmtItems[0].cmt.IsPublished == cmt2.IsPublished);
        
        
     
        //check new page buttons
        System.assert(cl.getNewPrivateComment() != null);
        System.assert(cl.getNewPublicCommentURL() != null);
        System.assert(cl.getListURL() != null);
        
        //check public/private toggle
        cmtItems[0].togglePublic();
        CaseComment cmt1a = [Select IsPublished from CaseComment where id = :cmt1.id][0];
        System.assert(cmt1a.IsPublished = true);
        Test.stopTest();
    }
}