wallsome.App = (function($, public_) {

  public_.Models.Project = Backbone.Model.extend({
    currentMilestone: function() {
      if (!this.currentMilestoneModel) {
        var Milestone = wallsome.App.Models.Milestone.extend({
          url: this.attributes.accountName + "/projects/" + this.attributes.id + "/milestones/current"
        })
        this.currentMilestoneModel = new Milestone({});
      }
      return this.currentMilestoneModel;
    }
  });

  return public_;

})(jQuery, wallsome.App);
