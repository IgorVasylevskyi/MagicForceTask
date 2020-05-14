({
    doInit: function (component, event, helper) {

        helper.init(component, event);
        helper.getEnglishValues(component, event);
        helper.getQualificationValues(component, event);
    },

    handleRowAction: function(component, event, helper){
        var action = event.getParam('action');
        var row = event.getParam('row');

        if(action.name === 'delete'){
            helper.deleteRow(component, row);
        }
        else if(action.name === 'edit'){
            helper.editRow(component, event, row);
        }
    },
    
    createRecord: function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Position__c",
            "navigationLocation": 'LOOKUP',

            "panelOnDestroyCallback": function(event) {
                //$A.get('e.force:refreshView').fire();
                /////////////For refreshing of tab
                component.getEvent("refreshPositions").fire();
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

    nameIsEmpty: function(component, event){
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

                      if(record.Account__r) {
                          record.accountLink = '/' + record.Account__c;
                          record.accountName = record.Account__r.Name;
                      }
                  });

                  component.set("v.filteredPositions", records);
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
    }
});