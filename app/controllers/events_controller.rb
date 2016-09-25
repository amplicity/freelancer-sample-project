class EventsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    date = Date.today.change(month: params[:month].to_i+1, year: params[:year].to_i)
    items = current_user.events.not_deleted
    render json: (items.where(from: date.beginning_of_month.beginning_of_day..date.end_of_month.end_of_day) +
        items.where(to: date.beginning_of_month.beginning_of_day..date.end_of_month.end_of_day) +
        items.where('"from" < ? AND "from" IS NOT NULL AND "to" >= ?', date.beginning_of_month.beginning_of_day, date.end_of_month.end_of_day)).uniq
  end

  def show
    render json: @event
  end

  def create
    new_event = Event.create(event_params)
    current_user.events << new_event
    render json: new_event
  end

  def update
    @event.update(event_params)
    render json: @event
  end

  def destroy
    render json: @event.update(is_deleted: true)
  end

  private
  def event_params
    params.require(:model).permit(:title, :from, :to, :description)
  end

  def set_project
    @event = Event.find(params[:id])
  end
end
