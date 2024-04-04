trigger CaseCreationWithNonconformance on Case (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            CaseToNonconformanceHandler.caseToNonconformanceCreation(trigger.new);
        }
    }
}