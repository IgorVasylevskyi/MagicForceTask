public with sharing class CandidateToPositionApexController {

    @AuraEnabled
    public static List<Position__c> getPositions(){
    
        return [
                SELECT
                        Name, English_Level__c, Position_Level__c
                FROM
                        Position__c
                WHERE
                IsDeleted = FALSE
        ];
    }
    
    @AuraEnabled
    public static Candidate__c matchCandidateToPosition(Candidate__c candidate, Position__c position){
        
        candidate.Position__c = position.Id;
        
        update candidate;
        
        ///Creating of interview Interview Here
        Interview__c interview = new Interview__c(Candidate__c = candidate.Id, Position__c = position.Id);
        
        insert interview;
        
        return candidate;
    }
}