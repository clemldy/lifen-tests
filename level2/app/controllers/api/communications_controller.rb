class Api::CommunicationsController < ApplicationController

  def create
    communication = Communication.new(communication_params)
    communication.save
  end

  def index
    @communications = Communication.all.includes(:practitioner)
  end

  def communication_params
    params.require(:communication).permit(:practitioner_id, :sent_at)
  end

end
