({
    init: function (component, event) {

        var actions = [
            { label: 'Delete', name: 'delete'},
            { label: 'Edit', name: 'edit'}
        ];

        component.set("v.columns", [
            {label: "Interview Name", fieldName: "linkName", type: "url", initialWidth: 70,
                typeAttributes: {label: {fieldName: "Name"}, tooltip: {fieldName: "Name"}, target: "_blank"}},

            {label: "Candidate", fieldName: "candidate", type: "url",
                typeAttributes: {label: {fieldName: "candidateName"}, tooltip: {fieldName: "candidateName"},
                    target: "_blank"}},

            {label: "Position", fieldName: "position", type: "url",
                typeAttributes: {label: {fieldName: "positionName"}, tooltip: {fieldName: "positionName"},
                    target: "_blank"}},

            {label: "Interviewer", fieldName: "interviewer", type: "url",
                typeAttributes: {label: {fieldName: "interviewerName"}, tooltip: {fieldName: "interviewerName"},
                    target: "_blank"}},

            {label: "Date/Time of Interview", fieldName: "Interview_Time__c", type: "date",
                typeAttributes: {
                    day: 'numeric',
                    month: 'short',
                    year: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                    hour12: false}},

            {label: "Passed/Failed", initialWidth: 70, cellAttributes:
                    {iconName: {fieldName: "iconName"}, iconPosition: "right"}},

            {label: "Offer confirmed", fieldName: "Offer_Confirmed__c", initialWidth: 80, type: "boolean"},

            /*{label: "Created Date", fieldName: "CreatedDate", type: "date"},*/

            {label: "Set Interviewer", type: "button", initialWidth: 150,
                typeAttributes: {label: "Set Interviewer", name: "set_interviewer",
                    title: "Click to set Interviewer", variant: "brand-outline"}},

            {label: "Set Interview Time", type: "button",
                typeAttributes: {label: "Set Time", name: "set_time", initialWidth: 70,
                title: "Click to set Interview Time", variant: "brand-outline"}},

            {label: "Set Interview Result", type: "button", initialWidth: 120,
                typeAttributes: {label: "Set Result", name: "set_result",
                    title: "Click to set Interview Result", variant: "brand"}},

            {type: 'action', typeAttributes: {rowActions: actions, menuAlignment: 'right'}}
        ]);

        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");

        var action = component.get("c.getInterviews");

        action.setCallback(this, function (response) {

            var state = response.getState();

            if(state === "SUCCESS"){

                var records = response.getReturnValue();

                records.forEach(function(record){
                    record.linkName = '/' + record.Id;
                    record.candidate = '/' + record.Candidate__c;
                    record.position = '/' + record.Position__c;


                    record.candidateName = record.Candidate__r.Name;
                    record.positionName = record.Position__r.Name;

                    if(record.Contact__r) {
                        record.interviewer = '/' + record.Contact__c;
                        record.interviewerName = record.Contact__r.Name;
                    }
                    if(record.Passed__c === 'Passed'){
                        record.iconName = 'utility:check';
                    }
                    else if (record.Passed__c === 'Failed'){
                        record.iconName = 'utility:close';
                    }

                });

                component.set("v.filteredInterviews", records);
                $A.util.addClass(spinner, "slds-hide");

            }
            else if(state === "ERROR"){
                console.log('error in InterviewsHelper.init');
            }
        });
        $A.enqueueAction(action);
    },

    nameFilter: function (component, event){

        var positionName = component.find("positionName").get("v.value");
        var candidateName = component.find("candidateName").get("v.value");

        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");

        var action = component.get("c.getNameFilters");
        action.setParams({
            "positionName": positionName,
            "candidateName": candidateName
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (state === "SUCCESS") {
                //
                var records = response.getReturnValue();

                records.forEach(function(record){
                    record.linkName = '/' + record.Id;
                    record.candidate = '/' + record.Candidate__c;
                    record.position = '/' + record.Position__c;


                    record.candidateName = record.Candidate__r.Name;
                    record.positionName = record.Position__r.Name;

                    if(record.Contact__r) {
                        record.interviewer = '/' + record.Contact__c;
                        record.interviewerName = record.Contact__r.Name;
                    }
                    if(record.Passed__c === 'Passed'){
                        record.iconName = 'utility:check';
                    }
                    else if (record.Passed__c === 'Failed'){
                        record.iconName = 'utility:close';
                    }

                });

                component.set("v.filteredInterviews", records);
                //

                component.find("dateFrom").set("v.value", "");
                component.find("dateTo").set("v.value", "");

                $A.util.addClass(spinner, "slds-hide");
                console.log('nameFilter method success');

            }else if (state === "ERROR"){
                console.log('nameFilter method error');
            }
        });
        $A.enqueueAction(action);
    },

    dateFilterHelper: function(component, event){

        var dateFrom = component.find("dateFrom").get("v.value");
        var dateTo = component.find("dateTo").get("v.value");

        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");

        var action = component.get("c.getByDate");

        action.setParams({
            "dateFrom": dateFrom,
            "dateTo": dateTo
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if(state === "SUCCESS"){
                /////////
                var records = response.getReturnValue();

                records.forEach(function(record){
                    record.linkName = '/' + record.Id;
                    record.candidate = '/' + record.Candidate__c;
                    record.position = '/' + record.Position__c;


                    record.candidateName = record.Candidate__r.Name;
                    record.positionName = record.Position__r.Name;

                    if(record.Contact__r) {
                        record.interviewer = '/' + record.Contact__c;
                        record.interviewerName = record.Contact__r.Name;
                    }
                    if(record.Passed__c === 'Passed'){
                        record.iconName = 'utility:check';
                    }
                    else if (record.Passed__c === 'Failed'){
                        record.iconName = 'utility:close';
                    }

                });

                component.set("v.filteredInterviews", records);
                ////////

                component.find("positionName").set("v.value", "");
                component.find("candidateName").set("v.value", "");

                $A.util.addClass(spinner, "slds-hide");
            }
            else if (state === "ERROR"){
                console.log("error in dateFilterHelper");
            }
        });
        $A.enqueueAction(action);
    },

    setTime: function (component, event) {

        var interview = component.get("v.interview");
        var interviewTime = component.find("interviewTime").get("v.value");

        var action = component.get("c.setTime");

        action.setParams({
            "interview": interview,
            "interviewTime": interviewTime
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (state === "SUCCESS"){

                component.set("v.isTimeModalOpen", false);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Interview time was successfully set."
                });
                toastEvent.fire();

                //$A.get('e.force:refreshView').fire();
                /////////////
                component.getEvent("refreshInterviews").fire();
                /////////////

                //enable scrolling of background
                document.body.style.overflow = "auto";
            }
            else if (state === "ERROR"){
                console.log('error in InterviewsHelper.setTime');
            }
        });
        $A.enqueueAction(action);
    },

    setResult: function (component, event) {

        var interview = component.get("v.interview");
        var interviewResult = component.get("v.resultRadio");
        var englishResult = component.find("english").get("v.value");
        var hardSkills = component.find("hardSkills").get("v.value");
        var softSkills = component.find("softSkills").get("v.value");

        var action = component.get("c.setResult");

        action.setParams({
            "interview": interview,
            "interviewResult": interviewResult,
            "englishResult": englishResult,
            "hardSkills": hardSkills,
            "softSkills": softSkills
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (state === "SUCCESS"){

                component.set("v.isResultModalOpen", false);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Interview Result was successfully set."
                });
                toastEvent.fire();

                //$A.get('e.force:refreshView').fire();
                /////////////
                component.getEvent("refreshInterviews").fire();
                /////////////

                //enable scrolling of background
                document.body.style.overflow = "auto";
            }
            else if (state === "ERROR"){
                console.log('error in InterviewsHelper.setResult');
                //enable scrolling of background
                document.body.style.overflow = "auto";
            }
        });
        $A.enqueueAction(action);
    },

    getEnglishValues: function(component, event){

        var options = [];

        var action = component.get("c.getEnglishPicklist");
        action.setCallback(this, function (response) {

            var state = response.getState();

            if(state === "SUCCESS"){
                var arr = response.getReturnValue();

                arr.forEach(function (element) {
                    options.push({value: element, label: element});
                });

                component.set("v.englishPicklist", options);
            }
        });
        $A.enqueueAction(action);
    },

    deleteInterview: function (component, event, row) {

        var action = component.get("c.deleteInterview");
        action.setParams({"interview": row});

        action.setCallback(this, function (response) {
            var state = response.getState();

            if(state === "SUCCESS"){

                var rows = component.get("v.filteredInterviews");
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);

                component.set("v.filteredInterviews", rows);

                //$A.get('e.force:refreshView').fire();
                /////////////
                component.getEvent("refreshInterviews").fire();
                /////////////

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "info",
                    "title": "Success!",
                    "message": "Interview deleted."
                });
                toastEvent.fire();

            }else if(state === "ERROR"){
                console.log('row is not deleted');
            }
        });
        $A.enqueueAction(action);
    },

    editRow: function (component, event, row) {

        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": row.Id
        });
        editRecordEvent.fire();
    }
});