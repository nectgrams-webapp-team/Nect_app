# frozen_string_literal: true

class SiteAdmins::EventHistoriesController < SiteAdmins::BaseController
    # Below here are the functions pertaining to events in the about page
    def index
        @event_history = EventHistory.all
        @new_event_history = EventHistory.new
    end

    def create
        @event_history = EventHistory.new(event_history_params)
        if @event_history.save
            redirect_to request.referrer, notice: "New Event Added!"
        else
            redirect_to request.referrer, notice: "Event history has missing parameters!"
        end
    end

    def update
        @event_history = EventHistory.find(params[:id])
        if @event_history.update(event_history_params)
            redirect_to request.referrer, notice: "Event Successfully Updated!"
        else
            redirect_to request.referrer, notice: "Event history has failed to update!"
        end
    end

    def destroy
        @event_history = EventHistory.find(params[:id])
        @event_history.destroy
        redirect_to request.referrer, notice: "Event Successfully Deleted!"
    end

    private

    def event_history_params
        params.require(:event_history).permit(:event_title, :event_text, :date_of_event)
    end
end
