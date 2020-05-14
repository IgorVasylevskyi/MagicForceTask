@IsTest
private class SetInterviewerTest {
    
    @IsTest
    static void getContactsForAccountTest() {
        
        Integer contactsQuantity = 5;
        
        Account acc = UtilityTest.insertAccountWitContacts(contactsQuantity);
        
        Test.startTest();
        List<Contact> contacts = SetInterviewerApexController.getContactsForAccount(acc.Id);
        Test.stopTest();
        
        System.assertEquals(contactsQuantity, contacts.size());
    }
    
    @IsTest
    static void setInterviewerTest(){
        
        Interview__c interview = UtilityTest.insertInterviews(1)[0];
        Contact con = UtilityTest.insertContact();
        
        Test.startTest();
        SetInterviewerApexController.setInterviewer(interview, con);
        
        Interview__c result = [SELECT Name, Contact__c FROM Interview__c WHERE Contact__c = :con.Id LIMIT 1];
        Test.stopTest();
        
        System.assertEquals(con.Id, result.Contact__c);
    }
}