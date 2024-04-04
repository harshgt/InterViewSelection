@isTest
private class CaseToNonconformanceHandlerTest {
    @isTest
    static void testCaseCreationAndEscalation() {
        
        PermissionSetAssignment  caseAdminProfile = [SELECT AssigneeId, PermissionSet.Name FROM PermissionSetAssignment where PermissionSet.Name = 'Case_Admin' LIMIT 1];
        User userWithProfile = [SELECT ProfileId FROM User WHERE Id =:caseAdminProfile.AssigneeId LIMIT 1];
		Id caseAdminProfileId = userWithProfile.ProfileId;

        
        User caseAdminUser = new User(
        ProfileId = caseAdminProfileId,
        FirstName = 'Test',
        LastName = 'User',
        Email = 'test.user@example.com',
        Username = 'test.user@example.com' + System.currentTimeMillis(),
        Alias = 'tuser',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        TimeZoneSidKey = 'America/Los_Angeles'
    	);
    	insert caseAdminUser;
        
        		SQX_Nonconformance__c newCreationOfNC = new SQX_Nonconformance__c();
                newCreationOfNC.Priority__c = 'Low';
                newCreationOfNC.Title__c = 'Title test';
                newCreationOfNC.Description__c = 'Test Des';
                newCreationOfNC.QMS_Reference_Number__c = '2';
        		insert newCreationOfNC;

        
        Case cs = new case();
        cs.Description = 'Your Des';
        cs.Origin = 'Phone';
        cs.Reason = 'Calling';
        cs.Type = 'Problem';
        cs.Priority = 'Low';
        insert cs;
        
        
        
        
        
        
         // Run as Case_Admin user
        System.runAs(caseAdminUser) {
            Test.startTest();
            CaseToNonconformanceHandler.caseToNonconformanceCreation(new List<Case>{cs});
            Test.stopTest();
        }
        
        
        }
    
    
     @isTest
    static void testCaseCreationAndNonconformanceCreationByStandardUser() {
        //  Standard User
        String profileName = 'Standard User';
        Id standardUserProfileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;

          User standardUser = new User(
            ProfileId = standardUserProfileId,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test.user@example.com',
            Username = 'test.user@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert standardUser;
        
        
        Case cs3 = new case();
        cs3.Description = 'Your Des';
        cs3.Origin = 'Phone';
        cs3.Reason = 'Calling';
        cs3.Type = 'Problem';
        cs3.Priority = 'Low';
        insert cs3;
        
        Case cs4 = new case();
        cs4.Description = 'Your Des';
        cs4.Origin = 'Phone';
        cs4.Reason = 'Calling';
        cs4.Type = 'Problem';
        cs4.Priority = 'Low';
        insert cs4;
        
        
      
        System.runAs(standardUser) {
            Test.startTest();
            CaseToNonconformanceHandler.caseToNonconformanceCreation(new List<Case>{cs3,cs4});
            Test.stopTest();
        }
        }

        
        
        
        
        
    
}