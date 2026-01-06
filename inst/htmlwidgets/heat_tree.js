HTMLWidgets.widget({

  name: 'heat_tree',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {
        HeatTree.heatTree(`#${el.id}`, {});
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
