class ReservationsController < ApplicationController

  skip_before_filter  :verify_authenticity_token, only: [:accept_or_reject, :connect_guest_to_host_sms, :connect_guest_to_host_voice]
  before_action :set_twilio_params, only: [:connect_guest_to_host_sms, :connect_guest_to_host_voice]
  before_filter :authenticate_user, only: [:index]



  # GET /reservations
  def index
    @reservations = current_user.reservations.all
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @itinerary = Itinerary.find(params[:reservation][:itinerary_id])
    # byebug
    @reservation = @itinerary.reservations.new(reservation_params)

    # @reservation.save!

  # byebug
      if @reservation.save!
        flash[:notice] = "Sending your reservation request now."
        @reservation.host.check_for_reservations_pending
        redirect_to '/itineraries'
      else
        # render :index
        flash[:danger] = @reservation.errors
      end

  end

  # webhook for twilio incoming message from host
  def accept_or_reject
    incoming = Sanitize.clean(params[:From]).gsub(/^\+\d/, '')
    sms_input = params[:Body].downcase
    begin
      @host = User.find_by(phone_number: incoming)
      @reservation = @host.pending_reservation

      if sms_input == "accept" || sms_input == "yes"
        @reservation.confirm!
      else
        @reservation.reject!
      end

      @host.check_for_reservations_pending


      sms_reponse = "You have successfully #{@reservation.status} the reservation."
      respond(sms_reponse)
    rescue
      sms_reponse = "Sorry, it looks like you don't have any reservations to respond to."
      respond(sms_reponse)
    end
  end

  # webhook for twilio to anonymously connect the two parties
  def connect_guest_to_host_sms
     # Guest -> Host
     if @reservation.guest.phone_number == @incoming_phone
       @outgoing_number = @reservation.host.phone_number

     # Host -> Guest
     elsif @reservation.host.phone_number == @incoming_phone
       @outgoing_number = @reservation.guest.phone_number
     end

     response = Twilio::TwiML::Response.new do |r|
       r.Message @message, :to => @outgoing_number
     end
     render text: response.text
  end

  # webhook for twilio -> TwiML for voice calls
  def connect_guest_to_host_voice
    # Guest -> Host
    if @reservation.guest.phone_number == @incoming_phone
      @outgoing_number = @reservation.host.phone_number

    # Host -> Guest
    elsif @reservation.host.phone_number == @incoming_phone
      @outgoing_number = @reservation.guest.phone_number
    end
    response = Twilio::TwiML::Response.new do |r|
      # r.Play "http://vocaroo.com/i/s0IbTwjpFpZn"
      r.Dial @outgoing_number
    end
    render text: response.text
  end

  private
    # Send an SMS back to the Subscriber
  def respond(message)
      response = Twilio::TwiML::Response.new do |r|
      r.Message message
    end
      render text: response.text
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def reservation_params
      params.require(:reservation).permit(:name, :guest_phone, :message, :itinerary_id)
  end

    # Load up Twilio parameters
  def set_twilio_params
      @incoming_phone = Sanitize.clean(params[:From]).gsub(/^\+\d/, '')
      @message = params[:Body]
      anonymous_phone_number = params[:To]

      @reservation = Reservation.where(phone_number: anonymous_phone_number).first
  end



end
