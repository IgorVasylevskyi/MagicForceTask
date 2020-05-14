@IsTest
public class UtilityTest {
    
    public static List<Position__c> insertPositions(Integer quantity) {
        
        Schema.DescribeFieldResult posFieldResult = Position__c.Position_Level__c.getDescribe();
        List<Schema.PicklistEntry> posPicklistEntries = posFieldResult.getPicklistValues();
        
        Schema.DescribeFieldResult engFieldResult = Position__c.English_Level__c.getDescribe();
        List<Schema.PicklistEntry> engPicklistEntries = engFieldResult.getPicklistValues();
        
        String positionLevel = posPicklistEntries[0].getLabel();
        String englishLevel = engPicklistEntries[0].getLabel();
        
        
        Account acc = new Account(Name = 'Test acc');
        insert acc;
        
        List<Position__c> positions = new List<Position__c>();
        
        for (Integer i = 0; i < quantity; i++) {
            Position__c position = new Position__c(Name = 'Test position ' + i,
                    English_Level__c = englishLevel,
                    Position_Level__c = positionLevel, Account__c = acc.Id);
            
            positions.add(position);
        }
        insert positions;
        
        return positions;
    }
    
    public static List<Position__c> insertPositions2(Integer quantity) {
        
        Schema.DescribeFieldResult posFieldResult = Position__c.Position_Level__c.getDescribe();
        List<Schema.PicklistEntry> posPicklistEntries = posFieldResult.getPicklistValues();
        
        Schema.DescribeFieldResult engFieldResult = Position__c.English_Level__c.getDescribe();
        List<Schema.PicklistEntry> engPicklistEntries = engFieldResult.getPicklistValues();
        
        String positionLevel = posPicklistEntries[1].getLabel();
        String englishLevel = engPicklistEntries[1].getLabel();
        
        Account acc = new Account(Name = 'Test acc');
        insert acc;
        
        List<Position__c> positions = new List<Position__c>();
        
        for (Integer i = 0; i < quantity; i++) {
            Position__c position = new Position__c(Name = 'Test2 position ' + i,
                    English_Level__c = englishLevel,
                    Position_Level__c = positionLevel, Account__c = acc.Id);
            
            positions.add(position);
        }
        insert positions;
        
        return positions;
    }
    
    public static List<Candidate__c> insertCandidates(Integer quantity) {
        
        Schema.DescribeFieldResult qualFieldResult = Candidate__c.Qualification__c.getDescribe();
        List<Schema.PicklistEntry> qualPicklistEntries = qualFieldResult.getPicklistValues();
        
        Schema.DescribeFieldResult EngFieldResult = Candidate__c.English_Level__c.getDescribe();
        List<Schema.PicklistEntry> engPicklistEntries = EngFieldResult.getPicklistValues();
        
        String qualification = qualPicklistEntries[0].getLabel();
        String englishLevel = engPicklistEntries[0].getLabel();
        
        List<Candidate__c> candidates = new List<Candidate__c>();
        
        for (Integer i = 0; i < quantity; i++) {
            Candidate__c candidate = new Candidate__c(Name = 'Test candidate ' + i,
                    English_Level__c = englishLevel,
                    Qualification__c = qualification,
                    Email__c = 'test@gmail.com');
            
            candidates.add(candidate);
        }
        insert candidates;
        
        return candidates;
    }
    
    public static List<Candidate__c> insertCandidates2(Integer quantity) {
        
        Schema.DescribeFieldResult qualFieldResult = Candidate__c.Qualification__c.getDescribe();
        List<Schema.PicklistEntry> qualPicklistEntries = qualFieldResult.getPicklistValues();
        
        Schema.DescribeFieldResult EngFieldResult = Candidate__c.English_Level__c.getDescribe();
        List<Schema.PicklistEntry> engPicklistEntries = EngFieldResult.getPicklistValues();
        
        String qualification = qualPicklistEntries[1].getLabel();
        String englishLevel = engPicklistEntries[1].getLabel();
        
        List<Candidate__c> candidates = new List<Candidate__c>();
        
        for (Integer i = 0; i < quantity; i++) {
            Candidate__c candidate = new Candidate__c(Name = 'Test2 candidate ' + i,
                    English_Level__c = englishLevel,
                    Qualification__c = qualification,
                    Email__c = 'test@gmail.com');
            
            candidates.add(candidate);
        }
        insert candidates;
        
        return candidates;
    }
    
    public static List<Interview__c> insertInterviews(Integer quantity) {
        
        List<Position__c> positions = insertPositions(quantity);
        List<Candidate__c> candidates = insertCandidates(quantity);
        
        List<Interview__c> interviews = new List<Interview__c>();
        
        for (Integer i = 0; i < quantity; i++) {
            
            Interview__c interview = new Interview__c(Candidate__c = candidates[i].Id,
                    Position__c = positions[i].Id,
                    Interview_Time__c = Datetime.now());
            
            interviews.add(interview);
        }
        
        insert interviews;
        
        return interviews;
    }
    
    public static Account insertAccountWitContacts(Integer contactsQuantity){
        
        Account acc = new Account(Name = 'Test account');
        insert acc;
        
        List<Contact> contacts = new List<Contact>();
        
        for(Integer i = 0; i < contactsQuantity; i++){
            
            Contact con = new Contact(FirstName = 'Test first ' + i,
                    LastName = 'Test Last ' + i,
                    AccountId = acc.Id);
            
            contacts.add(con);
        }
        insert contacts;
        
        return acc;
    }
    
    public static Contact insertContact(){
        
        Contact con = new Contact(FirstName = 'First', LastName = 'Last');
        
        insert con;
        
        return con;
    }
}