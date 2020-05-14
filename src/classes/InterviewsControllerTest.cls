@IsTest
private class InterviewsControllerTest {
    
    @IsTest
    static void getInterviewsTest() {
        
        Integer quantity = 5;
        
        UtilityTest.insertInterviews(quantity);
        
        Test.startTest();
        List<Interview__c> interviews = InterviewsApexController.getInterviews();
        Test.stopTest();
        
        System.assertEquals(quantity, interviews.size());
    }
    
    @IsTest
    static void setTimeTest(){
        
        Integer quantity = 2;
        String empty = '';
        Datetime now = Datetime.now();
        String nowTime = String.valueOf(now);
        
        List<Interview__c> interviews = UtilityTest.insertInterviews(quantity);
        Interview__c interview1 = interviews[0];
        Interview__c interview2 = interviews[1];
        
        Test.startTest();
        Interview__c result1 = InterviewsApexController.setTime(interview1, empty);
        Interview__c result2 = InterviewsApexController.setTime(interview2, nowTime);
        Test.stopTest();
        
        System.assertEquals(null, String.valueOf(result1.Interview_Time__c));
        System.assertEquals(nowTime, String.valueOf(result2.Interview_Time__c));
    }
    
    @IsTest
    static void setResultTest(){
    
        Schema.DescribeFieldResult englishResultPicklist = Interview__c.English_Result__c.getDescribe();
        List<Schema.PicklistEntry> englishEntries = englishResultPicklist.getPicklistValues();
        
        String emptyResult = '';
        String interviewResult = 'Passed';
        String interviewResult2 = 'Failed';
        String englishResult = englishEntries[0].getLabel();
        String hardSkills = 'Good';
        String softSkills = 'Normal';
        
        List<Interview__c> interviews = UtilityTest.insertInterviews(3);
        
        Candidate__c candidate = [SELECT Name, Email__c FROM Candidate__c WHERE Id = :interviews[0].Candidate__c][0];
        
        for (Interview__c i: interviews){
            i.Candidate__r = candidate;
        }
        System.debug('int.size: ' + interviews.size());
        System.debug('int1: ' + interviews[0]);
        System.debug('int email: ' + interviews[0].Candidate__r.Email__c);
        System.debug('candidate: ' + interviews[0].Candidate__r);
        
        Test.startTest();
        InterviewsApexController.setResult(interviews[0], emptyResult, englishResult, hardSkills, softSkills);
        InterviewsApexController.setResult(interviews[1], interviewResult, englishResult, hardSkills, softSkills);
        InterviewsApexController.setResult(interviews[2], interviewResult2, englishResult, hardSkills, softSkills);
        
        List<Interview__c> queriedInterviews1 = [SELECT Name FROM Interview__c WHERE Passed__c = :emptyResult];
        List<Interview__c> queriedInterviews2 = [SELECT Name FROM Interview__c WHERE Passed__c = :interviewResult];
        List<Interview__c> queriedInterviews3 = [SELECT Name FROM Interview__c WHERE Passed__c = :interviewResult2];
        Test.stopTest();
        
        System.assertEquals(1, queriedInterviews1.size());
        System.assertEquals(1, queriedInterviews2.size());
        System.assertEquals(1, queriedInterviews3.size());
        
        
    }
    
    @IsTest
    static void getEnglishPicklistTest(){
    
        Schema.DescribeFieldResult fieldResult = Interview__c.English_Result__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        Test.startTest();
        List<String> picklist = InterviewsApexController.getEnglishPicklist();
        Test.stopTest();
        
        System.assertEquals(picklistEntries.size(), picklist.size());
    }
    
    @IsTest
    static void getNameFiltersTest(){
        
        Integer quantity = 4;
        String empty = '';
        
        List<Interview__c> interviews = UtilityTest.insertInterviews(quantity);
    
        Candidate__c candidate = [SELECT Name FROM Candidate__c WHERE Id = :interviews[0].Candidate__c][0];
        Position__c position = [SELECT Name FROM Position__c WHERE Id = :interviews[0].Position__c][0];
    
        String positionName = 'Test position';
        String candidateName = 'Test candidate';
    
        for (Interview__c i: interviews){
            i.Candidate__r = candidate;
            i.Position__r = position;
        }
        
        Test.startTest();
        List<Interview__c> interviews1 = InterviewsApexController.getNameFilters(empty, empty);
        List<Interview__c> interviews2 = InterviewsApexController.getNameFilters(positionName, empty);
        List<Interview__c> interviews3 = InterviewsApexController.getNameFilters(empty, candidateName);
        List<Interview__c> interviews4 = InterviewsApexController.getNameFilters(positionName, candidateName);
        Test.stopTest();
        
        System.assertEquals(quantity, interviews1.size());
        System.assertEquals(quantity, interviews2.size());
        System.assertEquals(quantity, interviews3.size());
        System.assertEquals(quantity, interviews4.size());
    }
    
    @IsTest
    static void getByDateTest(){
    
        Integer quantity = 2;
    
        String noDate = '';
        String yesterday =  String.valueOf(Datetime.now().addDays(-1));
        String tomorrow = String.valueOf(Datetime.now().addDays(1));
        
        List<Interview__c> interviews = UtilityTest.insertInterviews(quantity);
    
    
        Test.startTest();
        List<Interview__c> interviews1 = InterviewsApexController.getByDate(noDate, noDate);
        List<Interview__c> interviews2 = InterviewsApexController.getByDate(noDate, tomorrow);
        List<Interview__c> interviews3 = InterviewsApexController.getByDate(tomorrow, noDate);
        List<Interview__c> interviews4 = InterviewsApexController.getByDate(yesterday, tomorrow);
        Test.stopTest();
    
        System.assertEquals(quantity, interviews1.size());
        System.assertEquals(quantity, interviews2.size());
        System.assertEquals(0, interviews3.size());
        System.assertEquals(quantity, interviews4.size());
    }
    
    @IsTest
    static void deleteInterviewTest(){
    
        Integer quantity = 5;
    
        List<Interview__c> interviews = UtilityTest.insertInterviews(quantity);
        Interview__c interviewToDelete = interviews[0];
    
        Test.startTest();
    
        InterviewsApexController.deleteInterview(interviewToDelete);
        List<Interview__c> interviewsAfterDelete = [SELECT Name FROM Interview__c];
    
        Test.stopTest();
    
        System.assertEquals((quantity - 1), interviewsAfterDelete.size());
    }
}