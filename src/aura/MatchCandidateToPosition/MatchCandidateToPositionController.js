({
    doInit: function (component, event, helper) {

        helper.init(component, event);
    },

    handleRowAction: function (component, event, helper) {

        var action = event.getParam('action');
        var row = event.getParam('row');

        if(action.name === 'select_position'){
            helper.selectPosition(component, event, row);

        }
    }
});