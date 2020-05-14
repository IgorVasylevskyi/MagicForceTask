({
    doInit: function (component, event, helper) {

        helper.init(component, event);
    },
    
    handleRowAction: function(component, event, helper){

        var action = event.getParam('action');
        var row = event.getParam('row');

        if(action.name === 'set_interviewer'){

            helper.setInterviewerAction(component, event, row);
        }
    },

    closeInterviewerModal: function (component, event, helper) {

        var closeEvent = component.getEvent("closeInterviewerModal");

        closeEvent.fire();
    }
});