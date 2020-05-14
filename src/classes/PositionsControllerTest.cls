@IsTest
private class PositionsControllerTest {
    
    @IsTest
    static void allFiltersTest(){
    
        Schema.DescribeFieldResult posFieldResult = Position__c.Position_Level__c.getDescribe();
        List<Schema.PicklistEntry> positionEntries = posFieldResult.getPicklistValues();
    
        Schema.DescribeFieldResult engFieldResult = Position__c.English_Level__c.getDescribe();
        List<Schema.PicklistEntry> englishEntries = engFieldResult.getPicklistValues();
        
        Integer quantity = 5;
        String empty = '';
        String name = 'Test';
        String level = englishEntries[0].getLabel();
        String qualification = positionEntries[0].getLabel();
        
        UtilityTest.insertPositions(quantity);
        UtilityTest.insertPositions2(quantity);
        
        Test.startTest();
        
        List<Position__c> allPositions = PositionsApexController.getAllFilters(empty, empty, empty);
        //sosl below always return 0 records
        List<Position__c> namePos = PositionsApexController.getAllFilters(name, empty, empty);
        //
        List<Position__c> levelPos = PositionsApexController.getAllFilters(empty, level, empty);
        List<Position__c> qualPos = PositionsApexController.getAllFilters(empty, empty, qualification);
        List<Position__c> levelQualPos = PositionsApexController.getAllFilters(empty, level, qualification);
        List<Position__c> nameLevelPos = PositionsApexController.getAllFilters(name, level, empty);
        List<Position__c> nameQualPos = PositionsApexController.getAllFilters(name, empty, qualification);
        List<Position__c> nameLevelQualPos = PositionsApexController.getAllFilters(name, level, qualification);
        
        Test.stopTest();
        
        System.assertEquals((quantity + quantity), allPositions.size());
        System.assertEquals(0, namePos.size());
        System.assertEquals(quantity, levelPos.size());
        System.assertEquals(quantity, qualPos.size());
        System.assertEquals(quantity, levelQualPos.size());
        System.assertEquals(quantity, nameLevelPos.size());
        System.assertEquals(quantity, nameQualPos.size());
        System.assertEquals(quantity, nameLevelQualPos.size());
    }
    
    @IsTest
    static void getByNameTest(){
        Integer quantity = 5;
        String emptyName = '';
        String oneLetter = 'a';
        String goodLength = 'Test position 0';
    
        /*String[] soslResult = new String[1];
        soslResult[0] = 'Test';
        Test.setFixedSearchResults(soslResult);*/
        
        UtilityTest.insertPositions(quantity);
        
        Test.startTest();
        
        List<Position__c> allPositions = PositionsApexController.getByName(emptyName);
        List<Position__c> onePosition = PositionsApexController.getByName(goodLength);
        
        //////////
        try {
            PositionsApexController.getByName(oneLetter);
        }catch (AuraHandledException e){
            System.assert(e.getMessage().contains('Please type at least two characters'));
        }
        //////////
        Test.stopTest();
        
        System.assertEquals(quantity, allPositions.size());
        System.assertEquals(0, onePosition.size());
    }
    
    @IsTest
    static void  getByDateTest(){
        
        Integer quantity = 2;
        
        String noDate = '';
        Datetime yesterday = Datetime.now().addDays(-1);
        Datetime tomorrow = Datetime.now().addDays(1);
        String today = String.valueOf(Datetime.now());
        
        List<Position__c> yesterdayPositions =  UtilityTest.insertPositions(quantity);
        List<Position__c> tomorrowPositions =  UtilityTest.insertPositions(quantity);
        
        for(Position__c p: yesterdayPositions){
            Test.setCreatedDate(p.Id, yesterday);
        }
        for (Position__c p: tomorrowPositions){
            Test.setCreatedDate(p.Id, tomorrow);
        }
        
        Test.startTest();
        
        List<Position__c> positions1 = PositionsApexController.getByDate(noDate, noDate);
        List<Position__c> positions2 = PositionsApexController.getByDate(today, noDate);
        List<Position__c> positions3 = PositionsApexController.getByDate(noDate, today);
        List<Position__c> positions4 = PositionsApexController.getByDate(today, today);
        
        Test.stopTest();
    
        System.assertEquals((quantity + quantity), positions1.size());
        System.assertEquals(quantity, positions2.size());
        System.assertEquals(quantity, positions3.size());
        System.assertEquals(0, positions4.size());
    }
    
    @IsTest
    static void deletePositionTest(){
        
        Integer quantity = 5;
        
        List<Position__c> positions = UtilityTest.insertPositions(quantity);
        Position__c positionToDelete = positions[0];
        
        Test.startTest();
        
        PositionsApexController.deletePosition(positionToDelete);
        List<Position__c> positionsAfterDelete = [SELECT Name FROM Position__c];
        
        Test.stopTest();
        
        System.assertEquals((quantity - 1), positionsAfterDelete.size());
    }
    
    @IsTest
    static void getEnglishPicklistTest(){
    
        Schema.DescribeFieldResult fieldResult = Position__c.English_Level__c.getDescribe();
        Integer picklistEntries = fieldResult.getPicklistValues().size();
        
        Integer result = PositionsApexController.getEnglishPicklist().size();
        
        System.assertEquals((picklistEntries + 1), result);
    }
    
    @IsTest
    static void getQualificationPicklistTest(){
        
        Schema.DescribeFieldResult fieldResult = Position__c.Position_Level__c.getDescribe();
        Integer picklistEntries = fieldResult.getPicklistValues().size();
        
        Integer result = PositionsApexController.getQualificationPicklist().size();
        
        System.assertEquals((picklistEntries + 1), result);
    }
}