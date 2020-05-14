public with sharing class SetInterviewerApexController {
    
    @AuraEnabled
    public static List<Contact> getContactsForAccount(String accountId) {
        
        return [
                SELECT
                        Id, Name
                FROM
                        Contact
                WHERE
                AccountId = :accountId
                AND IsDeleted = FALSE
        ];
    }
    
    @AuraEnabled
    public static Interview__c setInterviewer(Interview__c interview, Contact con) {
        
        interview.Contact__c = con.Id;
        update interview;
        
        return interview;
    }
}