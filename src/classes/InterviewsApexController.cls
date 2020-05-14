public with sharing class InterviewsApexController {

    @AuraEnabled
    public static List<Interview__c> getInterviews(){
        
        return [
                SELECT
                        Name, Position__c, Position__r.Account__c, Position__r.Name, Candidate__c,
                        Candidate__r.Name,Candidate__r.Email__c, Passed__c, Interview_Time__c,
                        Contact__c, Contact__r.Name, Offer_Confirmed__c, CreatedDate
                FROM
                        Interview__c
                WHERE
                IsDeleted = FALSE
        ];
    }
    
    @AuraEnabled
    public static Interview__c setTime(Interview__c interview, String interviewTime){
        
        if(interviewTime == ''){
            
            interview.Interview_Time__c = null;
            update interview;
            
            return interview;
        }
        
        Datetime resultTime = Datetime.valueOf(interviewTime.replace('T', ' '));
        interview.Interview_Time__c = resultTime;
        
        update interview;
        
        return interview;
    }
    
    @AuraEnabled
    public static Interview__c setResult(Interview__c interview, String interviewResult,
                                            String englishResult, String hardSkills, String softSkills){
        
        if(interviewResult == ''){
            
            interview.Passed__c = null;
            interview.English_Result__c = englishResult;
            interview.Technical_Skills__c = hardSkills;
            interview.Communication_Skills__c = softSkills;
            
            update interview;
            
            return interview;
        }
        
        if(interviewResult == 'Passed'){
    
            Boolean isPassed = true;
            
            String email = interview.Candidate__r.Email__c;
            String name = interview.Candidate__r.Name;
            String interviewerName = interview.Contact__r.Name;
            
            sendEmail(isPassed, email, name, interview.Name, interviewerName);
        }
    
        if(interviewResult == 'Failed'){
            
            Boolean isPassed = false;
            
            String email = interview.Candidate__r.Email__c;
            String name = interview.Candidate__r.Name;
            String interviewerName = interview.Contact__r.Name;
        
            sendEmail(isPassed, email, name, interview.Name, interviewerName);
        }
        
      
        interview.Passed__c = interviewResult;
        interview.English_Result__c = englishResult;
        interview.Technical_Skills__c = hardSkills;
        interview.Communication_Skills__c = softSkills;
        
        update interview;
        
        return interview;
    }
    
    @AuraEnabled
    public static List<String> getEnglishPicklist(){
        
        List<String> optionList = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Interview__c.English_Result__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pe : picklistEntries){
            optionList.add(pe.getLabel());
        }
        
        return optionList;
    }
    
    @AuraEnabled
    public static List<Interview__c> getNameFilters(String positionName, String candidateName){
        
        String positionQueryName = positionName + '%';
        String candidateQueryName = candidateName + '%';
        
        if(positionName == '' && candidateName == ''){
            
            return getInterviews();
        }
        
        if(positionName != '' && candidateName == ''){
    
            return [
                    SELECT
                            Name, Position__c, Position__r.Account__c, Position__r.Name, Candidate__c,
                            Candidate__r.Name,Candidate__r.Email__c, Passed__c, Interview_Time__c,
                            Contact__c, Contact__r.Name, Offer_Confirmed__c, CreatedDate
                    FROM
                            Interview__c
                    WHERE
                    Position__r.Name LIKE :positionQueryName
                    AND IsDeleted = FALSE
            ];
        }
    
        if(positionName == '' && candidateName != ''){
        
            return [
                    SELECT
                            Name, Position__c, Position__r.Account__c, Position__r.Name, Candidate__c,
                            Candidate__r.Name,Candidate__r.Email__c, Passed__c, Interview_Time__c,
                            Contact__c, Contact__r.Name, Offer_Confirmed__c, CreatedDate
                    FROM
                            Interview__c
                    WHERE
                    Candidate__r.Name LIKE :candidateQueryName
                    AND IsDeleted = FALSE
            ];
        }
    
        
        
        return [
                SELECT
                        Name, Position__c, Position__r.Account__c, Position__r.Name, Candidate__c,
                        Candidate__r.Name,Candidate__r.Email__c, Passed__c, Interview_Time__c,
                        Contact__c, Contact__r.Name, Offer_Confirmed__c, CreatedDate
                FROM
                        Interview__c
                WHERE
                Candidate__r.Name LIKE :candidateQueryName
                AND Position__r.Name LIKE :positionQueryName
                AND IsDeleted = FALSE
        ];
    }
    
    @AuraEnabled
    public  static List<Interview__c> getByDate(String dateFrom, String dateTo){
        
        Boolean dateFromExist = Boolean.valueOf((dateFrom != '') && (dateFrom != null));
        Boolean dateToExist = Boolean.valueOf((dateTo != '') && (dateTo != null));
    
        if(dateFromExist == false && dateToExist == false){
        
            return getInterviews();
        }
    
        if(dateFromExist == true && dateToExist == false){
            
            Date queryDateFrom = Date.valueOf(dateFrom);
            return [
                    SELECT
                            Name, Position__c, Position__r.Account__c, Position__r.Name, Candidate__c,
                            Candidate__r.Name,Candidate__r.Email__c, Passed__c, Interview_Time__c,
                            Contact__c, Contact__r.Name, Offer_Confirmed__c, CreatedDate
                    FROM
                            Interview__c
                    WHERE
                    Interview_Time__c >= :queryDateFrom
                    AND IsDeleted = FALSE
            ];
        }
    
        if(dateFromExist == false && dateToExist == true){
    
            Date queryDateTo = Date.valueOf(dateTo).addDays(1);
        
            return [
                    SELECT
                            Name, Position__c, Position__r.Account__c, Position__r.Name, Candidate__c,
                            Candidate__r.Name,Candidate__r.Email__c, Passed__c, Interview_Time__c,
                            Contact__c, Contact__r.Name, Offer_Confirmed__c, CreatedDate
                    FROM
                            Interview__c
                    WHERE
                    Interview_Time__c <= :queryDateTo
                    AND IsDeleted = FALSE
            ];
        }
    
        List<Interview__c> interviews = new List<Interview__c>();
    
        if(dateFromExist == true && dateToExist == true) {
    
            Date queryDateFrom = Date.valueOf(dateFrom);
            Date queryDateTo = Date.valueOf(dateTo).addDays(1);
        
            interviews = [
                    SELECT
                            Name, Position__c, Position__r.Account__c, Position__r.Name, Candidate__c,
                            Candidate__r.Name,Candidate__r.Email__c, Passed__c, Interview_Time__c,
                            Contact__c, Contact__r.Name, Offer_Confirmed__c, CreatedDate
                    FROM
                            Interview__c
                    WHERE
                    Interview_Time__c >= :queryDateFrom
                    AND Interview_Time__c <= :queryDateTo
                    AND IsDeleted = FALSE
            ];
        }
        return interviews;
    }
    
    @AuraEnabled
    public static Interview__c deleteInterview(Interview__c interview){
        
        delete interview;
        
        return interview;
    }
    
    public static void sendEmail(Boolean isPassed, String email, String name, String interviewName, String interviewerName){
        
        String subject = '';
        String body = '';
        
        if(isPassed == true){
            subject = 'Please confirm the offer based on the ' + interviewName + ' interview.';
            body = 'Dear ' + name + ', you have successfully passed the interview.' +
                    ' Please confirm if you accept the offer by answer on this email.';
        }
        else if(isPassed == false){
            subject = 'Result of ' + interviewerName + ' interview.';
            body = 'Dear ' + name + ', your knowledge are not enough yet';
        }
        
 
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        //Create new email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        System.debug('email: ' + email);
        //Set who receive email
        List<String> sendTo = new List<String>();
        sendTo.add(email);
        mail.setToAddresses(sendTo);
    
        //Set who the email is sent from
        // change it with your mail address.
        mail.setReplyTo('recruiting_service@2p3fi11pqc4pxgc8ust5oiiy5jwtutu0rwh8gbvlki5h8ebwl0' +
                '.3x-4xccouaw.eu29.apex.salesforce.com');
        mail.setSenderDisplayName(interviewerName);
        
        //Set email contents
        mail.setSubject(subject);
        mail.setHtmlBody(body);
    
        //Add your email to the master list
        mails.add(mail);
    
        //Send all emails in the master list
        Messaging.sendEmail(mails);
    }
}