({
    init: function (component, event) {

       var actions = [
           { label: 'Delete', name: 'delete'},
           { label: 'Edit', name: 'edit'}
       ];

       component.set("v.columns", [
           {label: "Candidate Name", fieldName: "linkName", type: "url",
               typeAttributes: {label: {fieldName: "Name"}, tooltip: {fieldName: "Name"}, target: "_blank"}},
           {label: "Qualification", fieldName: "Qualification__c", type: "text"},
           {label: "English Level", fieldName: "English_Level__c", type: "text"},
           {label: "Created Date", fieldName: "CreatedDate", type: "date"},

           {label: "Position", fieldName: "position", type: "url",
               typeAttributes: {label: {fieldName: "positionName"}, tooltip: {fieldName: "positionName"},
                                target: "_blank"}},

           {label: "Match to Position", type: "button",
               typeAttributes: {label: "Select Position", name: "select_position",
                   title: "Click to select a position"}},
           {type: 'action', typeAttributes: {rowActions: actions, menuAlignment: 'right'}}
       ]);

       var spinner = component.find("spinner");
       $A.util.removeClass(spinner, "slds-hide");

       var action = component.get("c.getAllCandidates");

       action.setCallback(this, function (response) {

           var state = response.getState();

           if(state === "SUCCESS") {

               var records = response.getReturnValue();

               records.forEach(function(record){
                   record.linkName = '/' + record.Id;
                   record.position = '/' + record.Position__c;

                   if(record.Position__r) {
                       record.positionName = record.Position__r.Name;
                       //record.buttonLabel = 'Change Position';

                   }else if(record.Position__r === undefined){
                       record.positionName = ' ';
                       //record.buttonLabel = 'Select Position';
                   }
               });

               component.set("v.filteredCandidates", records);
               $A.util.addClass(spinner, "slds-hide");

           }else if(state === "ERROR"){

               console.log('error in candidatesHelper.init');
           }

       });
       $A.enqueueAction(action);
   },

    nameFilter: function (component, event, helper) {
        var name = component.find("name").get("v.value");
        var level = component.find("english").get("v.value");
        var qualification = component.find("qualification").get("v.value");

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

            if (state === "SUCCESS") {
                //
                var records = response.getReturnValue();

                records.forEach(function(record){

                    record.linkName = '/' + record.Id;
                    record.position = '/' + record.Position__c;

                    if(record.Position__r) {
                        record.positionName = record.Position__r.Name;
                        record.hasPosition = true;

                    }else if(record.Position__r === undefined){
                        record.positionName = ' ';
                        record.hasPosition = false;
                    }
                });

                component.set("v.filteredCandidates", records);
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

    deleteRow: function (component, row) {

        var action = component.get("c.deleteCandidate");
        action.setParams({"candidate": row});

        action.setCallback(this, function (response) {
            var state = response.getState();

            if(state === "SUCCESS"){

                var rows = component.get("v.filteredCandidates");
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);

                component.set("v.filteredCandidates", rows);

                //$A.get('e.force:refreshView').fire();
                /////////////For refreshing of tab
                component.getEvent("refreshCandidates").fire();
                /////////////
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "info",
                    "title": "Success!",
                    "message": "Candidate deleted."
                });
                toastEvent.fire();

            }else if(state === "ERROR"){
                console.log('row is not deleted');
            }
        });
        $A.enqueueAction(action);
    },

    editRow: function(component, event, row){

        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": row.Id
        });
        editRecordEvent.fire();
    },

    allFiltersHelper: function (component, event) {
        var name = component.find("name").get("v.value");
        var level = component.find("english").get("v.value");
        var qualification = component.find("qualification").get("v.value");

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

            if(state === "SUCCESS") {
                //
                var records = response.getReturnValue();

                records.forEach(function(record){

                    record.linkName = '/' + record.Id;
                    record.position = '/' + record.Position__c;

                    if(record.Position__r) {
                        record.positionName = record.Position__r.Name;
                        record.hasPosition = true;

                    }else if(record.Position__r === undefined){
                        record.positionName = ' ';
                        record.hasPosition = false;
                    }
                });

                component.set("v.filteredCandidates", records);
                //
                component.find("dateFrom").set("v.value", "");
                component.find("dateTo").set("v.value", "");

                $A.util.addClass(spinner, "slds-hide");

            }else if (state === "ERROR"){
                console.log('Error in allFiltersHelper');
            }
        });
        $A.enqueueAction(action);
    },

    dateFilterHelper: function (component, event) {

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
                    record.position = '/' + record.Position__c;

                    if(record.Position__r) {
                        record.positionName = record.Position__r.Name;
                        record.hasPosition = true;

                    }else if(record.Position__r === undefined){
                        record.positionName = ' ';
                        record.hasPosition = false;
                    }
                });

                component.set("v.filteredCandidates", records);
                /////////

                component.find("name").set("v.value", "");
                component.find("english").set("v.value", "");
                component.find("qualification").set("v.value", "");

                $A.util.addClass(spinner, "slds-hide");
            }
            else if (state === "ERROR"){
                console.log("error in dateFilterHelper");
            }
        });
        $A.enqueueAction(action);
    },

    getEnglishValues: function (component, event) {

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

    getQualificationValues: function(component, event){

        var options = [];

        var action = component.get("c.getQualificationPicklist");
        action.setCallback(this, function (response) {

            var state = response.getState();

            if(state === "SUCCESS"){
                var arr = response.getReturnValue();

                arr.forEach(function (element) {
                    options.push({value: element, label: element});
                });

                component.set("v.qualificationPicklist", options);
            }
        });
        $A.enqueueAction(action);
    }
});