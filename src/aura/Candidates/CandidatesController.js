({
    doInit: function (component, event, helper) {

        helper.init(component, event);
        helper.getEnglishValues(component, event);
        helper.getQualificationValues(component, event);
    },
    
    handleRowAction: function (component, event, helper) {

        var action = event.getParam('action');
        var row = event.getParam('row');

        if(action.name === 'delete'){

            helper.deleteRow(component, row);
        }
        else if(action.name === 'edit'){

            helper.editRow(component, event, row);
        }
        else if(action.name === 'select_position'){

            component.set("v.candidate", row);
            component.set("v.isModalOpen", true);
        }
    },

    createRecord: function (component, event, helper) {

        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Candidate__c",
            "navigationLocation": 'LOOKUP',

            "panelOnDestroyCallback": function(event) {
                //$A.get('e.force:refreshView').fire();
                /////////////For refreshing of tab
                component.getEvent("refreshCandidates").fire();
                /////////////
            }
        });
        createRecordEvent.fire();
    },

    runNameFilter: function (component, event, helper) {
        var nameFilter = component.find("name");
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

    nameIsEmpty: function(component, event, helper){
        var name = component.find("name").get("v.value");
        var level = component.find("english").get("v.value");
        var qualification = component.find("qualification").get("v.value");

        if(name.length === 0){
            console.log('empty name');

            var spinner = component.find("spinner");
            $A.util.removeClass(spinner, "slds-hide");

            var action = component.get("c.getAllFilters");

            action.setParams({
                "name": name,
                "level": level,
                "qualification": qualification
            });
            action.setCallback(this, function (response) {

                var state = response.getState();

                if(state === "SUCCESS"){
                    /////
                    var records = response.getReturnValue();

                    records.forEach(function(record){

                        record.linkName = '/' + record.Id;
                        record.position = '/' + record.Position__c;

                        if(record.Position__r) {
                            record.positionName = record.Position__r.Name;

                        }else if(record.Position__r === undefined){
                            record.positionName = ' ';
                        }
                    });

                    component.set("v.filteredCandidates", records);
                    ////

                    component.find("dateFrom").set("v.value", "");
                    component.find("dateTo").set("v.value", "");

                    $A.util.addClass(spinner, "slds-hide");
                }
                else if(state === "ERROR"){
                    console.log('error in nameIsEmpty');
                }

            });
            $A.enqueueAction(action);
        }
    },

    allFilters: function (component, event, helper) {

        helper.allFiltersHelper(component, event);
    },

    dateFilter: function (component, event, helper) {

        helper.dateFilterHelper(component, event);
    },

    openModal: function(component, event, helper) {

        component.set("v.isModalOpen", true);
    },

    closeModal: function(component, event, helper) {

        component.set("v.isModalOpen", false);
    },

    positionSelected: function (component, event, helper) {

        component.set("v.isModalOpen", false);

        //$A.get('e.force:refreshView').fire();
        /////////////For refreshing of tab
        component.getEvent("refreshCandidates").fire();
        /////////////

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Position selected."
        });
        toastEvent.fire();
    }
});