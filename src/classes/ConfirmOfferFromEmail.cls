global with sharing class ConfirmOfferFromEmail implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                            Messaging.InboundEnvelope envelope){
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        String emailText = email.plainTextBody;
        String emailAddress = email.fromAddress;
        
        String subject = email.subject;
        Integer i = subject.indexOf('I-');
        String interviewName = subject.substring(i, i+5);
        
        Interview__c interview = [SELECT Name, Offer_Confirmed__c FROM Interview__c
                                    WHERE Candidate__r.Email__c = :emailAddress
                                    AND Name = :interviewName
                                    AND IsDeleted = FALSE LIMIT 1];
        
        interview.Offer_Confirmed__c = true;
        update interview;
        
        result.success = true;
        
        return result;
    }
}

