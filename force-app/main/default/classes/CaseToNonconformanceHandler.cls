public class CaseToNonconformanceHandler {
    public static void caseToNonconformanceCreation(List<Case> newCaseList){
        
        List<SQX_Nonconformance__c> listOfSQX_Nonconformance = new List<SQX_Nonconformance__c>();
        List<Case> countNoOfRecord = [Select id from Case];
        List<Case> casesToUpdate = new List<Case>();
        
        //get all user related to case_Admin Permission
        List<PermissionSetAssignment> newAssignUsers = [SELECT AssigneeId, PermissionSet.Name FROM PermissionSetAssignment where PermissionSet.Name = 'Case_Admin'];
        //store record id in Set
        Set<Id> adminUserIds = new Set<Id>();
        for(PermissionSetAssignment assign : newAssignUsers) {
            adminUserIds.add(assign.AssigneeId);
        }
        
        for(Case currentCase : newCaseList){
            //check if Type is Problem and only Case_admin user can create and Update record
            if(currentCase.Type == 'Problem' && currentCase.SQX_NC_Reference__c == null && adminUserIds.contains(UserInfo.getUserId())){
                SQX_Nonconformance__c newCreationOfNC = new SQX_Nonconformance__c();
                newCreationOfNC.Priority__c = currentCase.Priority;
                newCreationOfNC.Title__c = currentCase.Subject;
                newCreationOfNC.Description__c = currentCase.Description;
                newCreationOfNC.QMS_Reference_Number__c = String.ValueOf(countNoOfRecord.size());
                listOfSQX_Nonconformance.add(newCreationOfNC);  
            }
        }
        //create a Nonconformance record
        if(!listOfSQX_Nonconformance.isEmpty()){
            insert listOfSQX_Nonconformance;
        }
        // Only the users with Case Admin permission set must be able to escalate a case
        for(Case currentCase : newCaseList){
            if (currentCase.IsEscalated){
                if(!adminUserIds.contains(UserInfo.getUserId())) {
                    currentCase.addError('You should not Escalate the case');
                }
            } 
                
    		
        }
        
        for(Case newList : newCaseList){
            if (!listOfSQX_Nonconformance.isEmpty()) {
            	casesToUpdate.add(new Case(Id = newList.Id, SQX_NC_Reference__c=  listOfSQX_Nonconformance[0].Id));
            }
        }
        
        if(!casesToUpdate.isEmpty()){
            update casesToUpdate;
        }
          
    }
}