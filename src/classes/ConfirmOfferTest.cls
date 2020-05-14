@IsTest
private class ConfirmOfferTest {
    @IsTest(SeeAllData = true)
    static void handleInboundEmailTest() {
        
        Interview__c interview = [SELECT Name, Candidate__c, Candidate__r.Email__c, Offer_Confirmed__c
                                    FROM Interview__c WHERE Offer_Confirmed__c = FALSE LIMIT 1];
        Candidate__c candidate = [SELECT Name, Email__c FROM Candidate__c
                                    WHERE Id = :interview.Candidate__c LIMIT 1];
        
        System.debug('int: ' + interview);
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        email.subject = interview.Name;
        email.fromAddress = candidate.Email__c;
        email.plainTextBody = 'email plain text body';
        
        ConfirmOfferFromEmail testInbound = new ConfirmOfferFromEmail();
        testInbound.handleInboundEmail(email, envelope);
    
        Interview__c result = [SELECT Name, Offer_Confirmed__c FROM Interview__c
                                WHERE Candidate__c = :candidate.Id][0];
       
        System.assertEquals(true, result.Offer_Confirmed__c);
    }
}