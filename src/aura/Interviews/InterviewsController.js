({
    doInit: function (component, event, helper) {

        helper.init(component, event);
        helper.getEnglishValues(component, event);
    },

    runCandidateFilter: function(component, event, helper){
        var nameFilter = component.find("candidateName");
        var name = nameFilter.get("v.value");

        if (event.which === 13) {

            if (name.length !== 1) {

                helper.nameFilter(component, event);
                nameFilter.setCustomValidity("");

            }else if(name.length === 1){
                nameFilter.setCustomValidity("Type at least 2 characters...");
            }
            nameFilter.reportValidity();
        }
    },

    runPositionFilter: function(component, event, helper){
        var nameFilter = component.find("positionName");
        var name = nameFilter.get("v.value");

        if (event.which === 13) {

            if (name.length !== 1) {

                helper.nameFilter(component, event);
                nameFilter.setCustomValidity("");

            }else if(name.length === 1){
                nameFilter.setCustomValidity("Type at least 2 characters...");
            }
            nameFilter.reportValidity();
        }
    },

    positionNameIsEmpty: function(component, event, helper){

        var positionName = component.find("positionName").get("v.value");

        if(positionName.length === 0) {
            helper.nameFilter(component, event);
        }

    },

    candidateNameIsEmpty: function(component, event, helper){

        var candidateName = component.find("candidateName").get("v.value");

        if(candidateName.length === 0) {
            helper.nameFilter(component, event);
        }

    },

    dateFilter: function(component, event, helper){

        helper.dateFilterHelper(component, event);
    },

    handleRowAction: function (component, event, helper) {

        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set("v.interview", row);

        if(action.name === 'delete'){

            helper.deleteInterview(component, event, row);
        }
        if(action.name === 'edit'){
            helper.editRow(component, event, row);
        }
        if(action.name === 'set_interviewer'){

            component.set("v.isInterviewerModalOpen", true);

            //disable scrolling of background
            document.body.style.overflow = "hidden";
        }
        if(action.name === 'set_time'){

            component.set("v.isTimeModalOpen", true);

            //disable scrolling of background
            document.body.style.overflow = "hidden";
        }
        else if(action.name === 'set_result'){

            component.set("v.isResultModalOpen", true);

            //disable scrolling of background
            document.body.style.overflow = "hidden";
        }
    },

    saveDateTime: function (component, event, helper) {

        helper.setTime(component, event);
    },

    saveResult: function(component, event, helper){

        helper.setResult(component, event);
    },

    closeTimeModal: function (component, event, helper) {

        component.set("v.isTimeModalOpen", false);

        //enable scrolling of background
        document.body.style.overflow = "auto";
    },

    closeResultModal: function (component, event, helper) {

        component.set("v.isResultModalOpen", false);

        //enable scrolling of background
        document.body.style.overflow = "auto";
    },

    closeInterviewerModal: function (component, event, helper) {

        component.set("v.isInterviewerModalOpen", false);

        //enable scrolling of background
        document.body.style.overflow = "auto";
    },

    interviewerSelected: function (component, event, helper) {

        component.set("v.isInterviewerModalOpen", false);

        /////////////
        component.getEvent("refreshInterviews").fire();
        /////////////
        //$A.get('e.force:refreshView').fire();

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Interviewer selected."
        });
        toastEvent.fire();
    },

    getResult: function (component, event, helper) {

        component.set("v.resultRadio", event.getSource().get("v.value"));
    }
});