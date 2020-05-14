({
    init: function (component, event) {

       component.set("v.columns", [
           {label : "Position Name", fieldName: "Name", type: "text"},
           {label: "Qualification", fieldName: "Position_Level__c", type: "text"},
           {label: "English Level", fieldName: "English_Level__c", type: "text"},
           {label: "Match to Position", type: "button",
               typeAttributes: {label: "Choose Position", name: "select_position", title: "Click for matching"}}
       ]);

       var spinner = component.find("spinner");
       $A.util.removeClass(spinner, "slds-hide");

       var action = component.get("c.getPositions");

       action.setCallback(this, function (response) {
          var state = response.getState();

          if(state === "SUCCESS"){

              component.set("v.data", response.getReturnValue());

              $A.util.addClass(spinner, "slds-hide");
          }
          else if(state === "ERROR"){
              console.log('error in matchCandidateToPositionHelper');
          }
       });
       $A.enqueueAction(action);
   },

    selectPosition: function (component, event, row) {


        var candidate = component.get("v.candidate");

        var position = row;

        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");

        var action = component.get("c.matchCandidateToPosition");
        action.setParams({

            "candidate": candidate,
            "position": position
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            if (state === "SUCCESS"){

                var evt = component.getEvent("positionSelected");
                evt.fire();

                var appEvent = $A.get("e.c:refreshInterviewAppEvent");
                appEvent.fire();

                $A.util.addClass(spinner, "slds-hide");
            }
            else if (state === "ERROR"){
                console.log("error in matchCandidateToPositionHelper");
            }
        });
        $A.enqueueAction(action);
    }
});