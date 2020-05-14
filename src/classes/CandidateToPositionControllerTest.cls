@IsTest
private class CandidateToPositionControllerTest {
    
    
    @IsTest
    static void getPositionsTest() {
        
        Integer quantity = 5;
        
        UtilityTest.insertPositions(quantity);
        
        Test.startTest();
        List<Position__c> positions = CandidateToPositionApexController.getPositions();
        Test.stopTest();
        
        System.assertEquals(quantity, positions.size());
    }
    
    @IsTest
    static void matchCandidateToPositionTest(){
        
        Integer quantity = 1;
        
        Position__c position = UtilityTest.insertPositions(quantity)[0];
        Candidate__c candidate = UtilityTest.insertCandidates(quantity)[0];
        
        Test.startTest();
        
        CandidateToPositionApexController.matchCandidateToPosition(candidate, position);
        
        List<Interview__c> interviews = [SELECT Name FROM Interview__c];
        
        Test.stopTest();
        
        System.assertEquals(quantity, interviews.size());
    }
}