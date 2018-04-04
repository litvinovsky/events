class EventsController < ApplicationController
  def create
    Event.create(name: params["event"])
  end
end
