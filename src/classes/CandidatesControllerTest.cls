@IsTest
private class CandidatesControllerTest {
    
    @IsTest
    static void allFiltersTest(){
        
        Schema.DescribeFieldResult qualFieldResult = Candidate__c.Qualification__c.getDescribe();
        List<Schema.PicklistEntry> positionEntries = qualFieldResult.getPicklistValues();
        
        Schema.DescribeFieldResult engFieldResult = Candidate__c.English_Level__c.getDescribe();
        List<Schema.PicklistEntry> englishEntries = engFieldResult.getPicklistValues();
        
        Integer quantity = 5;
        String empty = '';
        String name = 'Test';
        String level = englishEntries[0].getLabel();
        String qualification = positionEntries[0].getLabel();
        
        UtilityTest.insertCandidates(quantity);
        UtilityTest.insertCandidates2(quantity);
        
        Test.startTest();
        
        List<Candidate__c> allCandidates = CandidatesApexController.getAllFilters(empty, empty, empty);
        //sosl below always return 0 records
        List<Candidate__c> nameCan = CandidatesApexController.getAllFilters(name, empty, empty);
        //
        List<Candidate__c> levelCan = CandidatesApexController.getAllFilters(empty, level, empty);
        List<Candidate__c> qualCan = CandidatesApexController.getAllFilters(empty, empty, qualification);
        List<Candidate__c> levelQualCan = CandidatesApexController.getAllFilters(empty, level, qualification);
        List<Candidate__c> nameLevelCan = CandidatesApexController.getAllFilters(name, level, empty);
        List<Candidate__c> nameQualCan = CandidatesApexController.getAllFilters(name, empty, qualification);
        List<Candidate__c> nameLevelQualCan = CandidatesApexController.getAllFilters(name, level, qualification);
        
        Test.stopTest();
        
        System.assertEquals((quantity + quantity), allCandidates.size());
        System.assertEquals(0, nameCan.size());
        System.assertEquals(quantity, levelCan.size());
        System.assertEquals(quantity, qualCan.size());
        System.assertEquals(quantity, levelQualCan.size());
        System.assertEquals(quantity, nameLevelCan.size());
        System.assertEquals(quantity, nameQualCan.size());
        System.assertEquals(quantity, nameLevelQualCan.size());
    }
    
    @IsTest
    static void getByNameTest(){
        Integer quantity = 5;
        String emptyName = '';
        String oneLetter = 'a';
        String goodLength = 'Test candidate 0';
        
        /*String[] soslResult = new String[1];
        soslResult[0] = 'Test';
        Test.setFixedSearchResults(soslResult);*/
        
        UtilityTest.insertCandidates(quantity);
        
        Test.startTest();
        
        List<Candidate__c> allCandidates = CandidatesApexController.getByName(emptyName);
        List<Candidate__c> oneCandidate = CandidatesApexController.getByName(goodLength);
        
        //////////
        try {
            CandidatesApexController.getByName(oneLetter);
        }catch (AuraHandledException e){
            System.assert(e.getMessage().contains('Please type at least two characters'));
        }
        //////////
        Test.stopTest();
        
        System.assertEquals(quantity, allCandidates.size());
        System.assertEquals(0, oneCandidate.size());
    }
    
    @IsTest
    static void  getByDateTest(){
        
        Integer quantity = 2;
        
        String noDate = '';
        Datetime yesterday = Datetime.now().addDays(-1);
        Datetime tomorrow = Datetime.now().addDays(1);
        String today = String.valueOf(Datetime.now());
        
        List<Candidate__c> yesterdayCandidates =  UtilityTest.insertCandidates(quantity);
        List<Candidate__c> tomorrowCandidates =  UtilityTest.insertCandidates(quantity);
        
        for(Candidate__c c: yesterdayCandidates){
            Test.setCreatedDate(c.Id, yesterday);
        }
        for (Candidate__c c: tomorrowCandidates){
            Test.setCreatedDate(c.Id, tomorrow);
        }
        
        Test.startTest();
        
        List<Candidate__c> candidates1 = CandidatesApexController.getByDate(noDate, noDate);
        List<Candidate__c> candidates2 = CandidatesApexController.getByDate(today, noDate);
        List<Candidate__c> candidates3 = CandidatesApexController.getByDate(noDate, today);
        List<Candidate__c> candidates4 = CandidatesApexController.getByDate(today, today);
        
        Test.stopTest();
        
        System.assertEquals((quantity + quantity), candidates1.size());
        System.assertEquals(quantity, candidates2.size());
        System.assertEquals(quantity, candidates3.size());
        System.assertEquals(0, candidates4.size());
    }
    
    @IsTest
    static void deleteCandidateTest(){
        
        Integer quantity = 5;
        
        List<Candidate__c> positions = UtilityTest.insertCandidates(quantity);
        Candidate__c candidateToDelete = positions[0];
        
        Test.startTest();
        
        CandidatesApexController.deleteCandidate(candidateToDelete);
        List<Candidate__c> candidatesAfterDelete = [SELECT Name FROM Candidate__c];
        
        Test.stopTest();
        
        System.assertEquals((quantity - 1), candidatesAfterDelete.size());
    }
    
    @IsTest
    static void getEnglishPicklistTest(){
        
        Schema.DescribeFieldResult fieldResult = Candidate__c.English_Level__c.getDescribe();
        Integer picklistEntries = fieldResult.getPicklistValues().size();
        
        Integer result = CandidatesApexController.getEnglishPicklist().size();
        
        System.assertEquals((picklistEntries + 1), result);
    }
    
    @IsTest
    static void getQualificationPicklistTest(){
        
        Schema.DescribeFieldResult fieldResult = Candidate__c.Qualification__c.getDescribe();
        Integer picklistEntries = fieldResult.getPicklistValues().size();
        
        Integer result = CandidatesApexController.getQualificationPicklist().size();
        
        System.assertEquals((picklistEntries + 1), result);
    }
}