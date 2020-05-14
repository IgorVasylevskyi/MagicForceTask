({
    init: function(component, event){

        //document.body.setAttribute('style', 'overflow: hidden;');
        var actions = [
            { label: 'Delete', name: 'delete'},
            { label: 'Edit', name: 'edit'}
        ];

        component.set("v.columns", [

            {label: "Position Name", fieldName: "linkName", type: "url",
                typeAttributes: {label: {fieldName: "Name"}, tooltip: {fieldName: "Name"}, target: "_blank"}},

            {label: "Account", fieldName: "accountLink", type: "url", typeAttributes:
                    {label: {fieldName: "accountName"}, tooltip: {fieldName: "accountName"}, target: "_blank"}},

            {label: "Position Level", fieldName: "Position_Level__c", type: "text"},
            {label: "English Level", fieldName: "English_Level__c", type: "text"},
            {label: "Created Date", fieldName: "CreatedDate", type: "date"},
            {type: 'action', typeAttributes: {rowActions: actions, menuAlignment: 'right'}}
        ]);

        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");

        var action = component.get("c.getAllPositions");
        action.setCallback(this, function (response) {

            var records = response.getReturnValue();

            records.forEach(function(record){

                record.linkName = '/' + record.Id;

                if(record.Account__r) {
                    record.accountLink = '/' + record.Account__c;
                    record.accountName = record.Account__r.Name;
                }
            });

            component.set("v.filteredPositions", records);

            $A.util.addClass(spinner, "slds-hide");
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

                    if(record.Account__r) {
                        record.accountLink = '/' + record.Account__c;
                        record.accountName = record.Account__r.Name;
                    }
                });

                component.set("v.filteredPositions", records);
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
        var action = component.get("c.deletePosition");
        action.setParams({"position": row});

        action.setCallback(this, function (response) {
            var state = response.getState();

            if(state === "SUCCESS"){

                var rows = component.get("v.filteredPositions");
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);

                component.set("v.filteredPositions", rows);

                //$A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "info",
                    "title": "Success!",
                    "message": "Position deleted."
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

                    if(record.Account__r) {
                        record.accountLink = '/' + record.Account__c;
                        record.accountName = record.Account__r.Name;
                    }
                });

                component.set("v.filteredPositions", records);
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

                    if(record.Account__r) {
                        record.accountLink = '/' + record.Account__c;
                        record.accountName = record.Account__r.Name;
                    }
                });

                component.set("v.filteredPositions", records);
                ////////

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