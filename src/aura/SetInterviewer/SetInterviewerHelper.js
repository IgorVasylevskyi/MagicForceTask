({
    init: function (component, event) {

        component.set("v.columns", [
            {label : "Interviewer Name", fieldName: "Name", type: "text"},

            {label: "Match to Position", type: "button", initialWidth: 180,
                typeAttributes: {label: "Choose Position", name: "set_interviewer", title: "Click for matching"}}
        ]);

        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");

        var interview = component.get("v.interview");
        var accountId = interview.Position__r.Account__c;


        var action = component.get("c.getContactsForAccount");

        action.setParams({
            "accountId": accountId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if(state === "SUCCESS"){

                component.set("v.data", response.getReturnValue());

                $A.util.addClass(spinner, "slds-hide");
            }
            else if(state === "ERROR"){
                console.log('error in setInterviewerHelper');
            }
        });
        $A.enqueueAction(action);
    },

    setInterviewerAction: function(component, event, row){

        var interview = component.get("v.interview");
        var contact = row;

        var action = component.get("c.setInterviewer");

        action.setParams({
            "interview": interview,
            "con": contact
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (state === "SUCCESS"){

                var evt = component.getEvent("interviewerSelected");
                evt.fire();
            }
            else if (state === "ERROR"){
                console.log("error in setInterviewerHelper");
            }
        });
        $A.enqueueAction(action);
    }
});