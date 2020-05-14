public with sharing class PositionsApexController {
    
    @AuraEnabled
    public static List<Position__c> getAllFilters(String name, String level, String qualification){
        
        Boolean levelExist = Boolean.valueOf((level != null) && (level != '--Any--') && (level != ''));
        Boolean qualificationExist = Boolean.valueOf(
                (qualification != null) && (qualification != '--Any--') && (qualification != ''));
        
        
        if(name == '' && levelExist == false && qualificationExist == false){
            return getAllPositions();
        }
        
        if(name == '' && levelExist == true && qualificationExist == false) {
            return getByEnglish(level);
        }
        
        if(name != '' && levelExist == false && qualificationExist == false){
            return getByName(name);
        }
        
        if(name == '' && levelExist == false && qualificationExist == true){
            return getByQualification(qualification);
        }
        
        if(name == '' && levelExist == true && qualificationExist == true){
            
            return getByLevelAndQualification(level, qualification);
        }
        
        if(name != '' && levelExist == true && qualificationExist == false){
        
            return getByNameAndLevel(name, level);
        }
        
        if(name != '' && levelExist == false && qualificationExist == true){
            
            return getByNameAndQualification(name, qualification);
        }
    
        System.debug('getAllFilters');
    
        List<Position__c> positions = new List<Position__c>();
        
        if (name != '' && levelExist == true && qualificationExist == true) {
         
            String queryString = name + '%';
            positions =  [
                    SELECT
                            Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                    FROM
                            Position__c
                    WHERE
                    Name LIKE :queryString
                    AND English_Level__c = :level
                    AND Position_Level__c = :qualification
                    AND IsDeleted = FALSE
            ];
        }
        
        return positions;
    }
    
    @AuraEnabled
    public static List<Position__c> getByDate(String dateFrom, String dateTo){
        
        Boolean dateFromExist = Boolean.valueOf((dateFrom != '') && (dateFrom != null));
        Boolean dateToExist = Boolean.valueOf((dateTo != '') && (dateTo != null));
    
        if(dateFromExist == false && dateToExist == false){
            
            return getAllPositions();
        }
        
        if(dateFromExist == true && dateToExist == false){
            Date queryDateFrom = Date.valueOf(dateFrom);
            return [
                    SELECT
                            Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                    FROM
                            Position__c
                    WHERE
                    CreatedDate >= :queryDateFrom
                    AND IsDeleted = FALSE
            ];
        }
        
        if(dateFromExist == false && dateToExist == true){
            
            Date queryDateTo = Date.valueOf(dateTo).addDays(1);
            
            return [
                    SELECT
                            Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                    FROM
                            Position__c
                    WHERE
                    CreatedDate <= :queryDateTo
                    AND IsDeleted = FALSE
            ];
        }
        
        List<Position__c> positions = new List<Position__c>();
        
        if(dateFromExist == true && dateToExist == true) {
    
            Date queryDateFrom = Date.valueOf(dateFrom);
            Date queryDateTo = Date.valueOf(dateTo).addDays(1);
    
            positions = [
                          SELECT
                                  Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                          FROM
                                  Position__c
                          WHERE
                          CreatedDate >= :queryDateFrom
                          AND CreatedDate <= :queryDateTo
                          AND IsDeleted = FALSE
            ];
        }
        return positions;
    }
    
    @AuraEnabled
    public static List<Position__c> getAllPositions(){
        
        return [
                SELECT
                        Name, Account__c, Account__r.Name, Position_Level__c, English_Level__c, CreatedDate
                FROM
                        Position__c
                WHERE
                        IsDeleted = FALSE
        ];
    }
    
    @AuraEnabled
    public static List<Position__c> getByName(String name){
        
        String queryString = name + '*';
        
        if(name == ''){
            
            return getAllPositions();
        }
        
        if(name.length() == 1){
            AuraHandledException e = new AuraHandledException('Please type at least two characters');
            e.setMessage('Please type at least two characters');
            throw e;
            //throw new AuraHandledException('Please type at least two characters');
        }
        
        System.debug('getByName');
        
        List<List<SObject>> objects = [FIND :queryString IN NAME FIELDS RETURNING
                Position__c(Name, Account__c, Account__r.Name, Position_level__c, English_level__c, CreatedDate)];
        
        List<Position__c> positions = objects[0];
        
        return positions;
    }
    
    static List<Position__c> getByEnglish(String level){
        System.debug('getByEnglish');
        return [
                SELECT
                        Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                FROM
                        Position__c
                WHERE
                English_Level__c = :level
                AND IsDeleted = FALSE];
    }
    
    static List<Position__c> getByQualification(String qualification){
        System.debug('getByQualification');
        return [
                SELECT
                        Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                FROM
                        Position__c
                WHERE
                Position_Level__c = :qualification
                AND IsDeleted = FALSE];
    }
    
    static List<Position__c> getByNameAndLevel(String name, String level){
        System.debug('getByNameAndLevel');
        String queryString = name + '%';
        
        return [
                SELECT
                        Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                FROM
                        Position__c
                WHERE
                Name LIKE :queryString
                AND English_Level__c = :level
                AND IsDeleted = FALSE
        ];
    }
    
    static List<Position__c> getByNameAndQualification(String name, String qualification){
    
        String queryString = name + '%';
    
        return [
                SELECT
                        Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                FROM
                        Position__c
                WHERE
                Name LIKE :queryString
                AND Position_Level__c = :qualification
                AND IsDeleted = FALSE
        ];
    }
    
    static List<Position__c> getByLevelAndQualification(String level, String qualification){
        System.debug('getByLevelAndQualification');
    
        return [
                SELECT
                        Name, Account__c, Account__r.Name, English_Level__c, Position_Level__c, CreatedDate
                FROM
                        Position__c
                WHERE
                English_Level__c = :level
                AND Position_Level__c = :qualification
                AND IsDeleted = FALSE];
    }
    
    @AuraEnabled
    public static Position__c deletePosition(Position__c position){
        
        delete position;
        
        return position;
    }
    
    @AuraEnabled
    public static List<String> getEnglishPicklist(){
    
        List<String> optionList = new List<String>();
        optionList.add('--Any--');
        
        Schema.DescribeFieldResult fieldResult = Position__c.English_level__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pe : picklistEntries){
            optionList.add(pe.getLabel());
        }
        
        return optionList;
    }
    
    @AuraEnabled
    public static List<String> getQualificationPicklist(){
    
        List<String> optionList = new List<String>();
        optionList.add('--Any--');
    
        Schema.DescribeFieldResult fieldResult = Position__c.Position_level__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pe : picklistEntries){
            optionList.add(pe.getLabel());
        }
        
        return optionList;
    }
}