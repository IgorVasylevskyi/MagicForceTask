public with sharing class CandidatesApexController {
    
    @AuraEnabled
    public static List<Candidate__c> getAllFilters(String name, String level, String qualification){
        
        Boolean levelExist = Boolean.valueOf((level != null) && (level != '--Any--') && (level != ''));
        Boolean qualificationExist = Boolean.valueOf(
                (qualification != null) && (qualification != '--Any--') && (qualification != ''));
        
        
        if(name == '' && levelExist == false && qualificationExist == false){
            return getAllCandidates();
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
        
        List<Candidate__c> candidates = new List<Candidate__c>();
        
        if (name != '' && levelExist == true && qualificationExist == true) {
            
            String queryString = name + '%';
            candidates =  [
                    SELECT
                            Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                    FROM
                            Candidate__c
                    WHERE
                    Name LIKE :queryString
                    AND English_Level__c = :level
                    AND Qualification__c = :qualification
                    AND IsDeleted = FALSE
            ];
        }
        
        return candidates;
    }
    
    @AuraEnabled
    public static List<Candidate__c> getAllCandidates(){
        
        return [
                SELECT
                        Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                FROM
                        Candidate__c
                WHERE
                IsDeleted = FALSE
        ];
    }
    
    @AuraEnabled
    public static List<Candidate__c> getByName(String name){
        
        String queryString = name + '*';
        
        if(name == ''){
            
            return getAllCandidates();
        }
        
        if(name.length() == 1){
            AuraHandledException e = new AuraHandledException('Please type at least two characters');
            e.setMessage('Please type at least two characters');
            throw e;
            //throw new AuraHandledException('Please type at least two characters');
        }
        
        List<List<SObject>> objects = [FIND :queryString IN NAME FIELDS RETURNING
                Candidate__c(Name, English_level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate)];
        
        List<Candidate__c> candidates = objects[0];
        
        return candidates;
    }
    
    static List<Candidate__c> getByEnglish(String level){
        System.debug('getByEnglish');
        return [
                SELECT
                        Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                FROM
                        Candidate__c
                WHERE
                English_Level__c = :level
                AND IsDeleted = FALSE];
    }
    
    static List<Candidate__c> getByQualification(String qualification){
        System.debug('getByQualification');
        return [
                SELECT
                        Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                FROM
                        Candidate__c
                WHERE
                Qualification__c = :qualification
                AND IsDeleted = FALSE];
    }
    
    static List<Candidate__c> getByNameAndLevel(String name, String level){
        System.debug('getByNameAndLevel');
        String queryString = name + '%';
        
        return [
                SELECT
                        Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                FROM
                        Candidate__c
                WHERE
                Name LIKE :queryString
                AND English_Level__c = :level
                AND IsDeleted = FALSE
        ];
    }
    
    static List<Candidate__c> getByNameAndQualification(String name, String qualification){
        System.debug('getByNameAndQualification');
        
        String queryString = name + '%';
        
        return [
                SELECT
                        Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                FROM
                        Candidate__c
                WHERE
                Name LIKE :queryString
                AND Qualification__c = :qualification
                AND IsDeleted = FALSE
        ];
    }
    
    static List<Candidate__c> getByLevelAndQualification(String level, String qualification){
        System.debug('getByLevelAndQualification');
        
        return [
                SELECT
                        Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                FROM
                        Candidate__c
                WHERE
                English_Level__c = :level
                AND Qualification__c = :qualification
                AND IsDeleted = FALSE];
    }
    
    @AuraEnabled
    public static List<Candidate__c> getByDate(String dateFrom, String dateTo){
        
        Boolean dateFromExist = Boolean.valueOf((dateFrom != '') && (dateFrom != null));
        Boolean dateToExist = Boolean.valueOf((dateTo != '') && (dateTo != null));
        
        if(dateFromExist == false && dateToExist == false){
            
            return getAllCandidates();
        }
        
        if(dateFromExist == true && dateToExist == false){
            Date queryDateFrom = Date.valueOf(dateFrom);
            return [
                    SELECT
                            Name, English_Level__c, Qualification__c, Position__c, Position__r.Name,  CreatedDate
                    FROM
                            Candidate__c
                    WHERE
                    CreatedDate >= :queryDateFrom
                    AND IsDeleted = FALSE
            ];
        }
        
        if(dateFromExist == false && dateToExist == true){
            
            Date queryDateTo = Date.valueOf(dateTo).addDays(1);
            
            return [
                    SELECT
                            Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                    FROM
                            Candidate__c
                    WHERE
                    CreatedDate <= :queryDateTo
                    AND IsDeleted = FALSE
            ];
        }
        
        List<Candidate__c> candidates = new List<Candidate__c>();
        
        if(dateFromExist == true && dateToExist == true) {
            
            Date queryDateFrom = Date.valueOf(dateFrom);
            Date queryDateTo = Date.valueOf(dateTo).addDays(1);
    
            candidates = [
                    SELECT
                            Name, English_Level__c, Qualification__c, Position__c, Position__r.Name, CreatedDate
                    FROM
                            Candidate__c
                    WHERE
                    CreatedDate >= :queryDateFrom
                    AND CreatedDate <= :queryDateTo
                    AND IsDeleted = FALSE
            ];
        }
        return candidates;
    }
    
    @AuraEnabled
    public static Candidate__c deleteCandidate(Candidate__c candidate){
        
        delete candidate;
        
        return candidate;
    }
    
    @AuraEnabled
    public static List<String> getEnglishPicklist(){
        
        List<String> optionList = new List<String>();
        optionList.add('--Any--');
        
        Schema.DescribeFieldResult fieldResult = Candidate__c.English_Level__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pe : picklistEntries){
            optionList.add(pe.getLabel());
        }
        
        return optionList;
    }
    
    @AuraEnabled
    public static List<String> getQualificationPicklist(){
        System.debug('getQualificationPicklist');
        
        List<String> optionList = new List<String>();
        optionList.add('--Any--');
        
        Schema.DescribeFieldResult fieldResult = Candidate__c.Qualification__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pe : picklistEntries){
            optionList.add(pe.getLabel());
        }
        
        return optionList;
    }
}