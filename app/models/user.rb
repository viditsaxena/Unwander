class User < ActiveRecord::Base
  has_secure_password

# ------------Twilio Code
  validates :email,  presence: true, format: { with: /\A.+@.+$\Z/ }, uniqueness: true
  validates :name, presence: true
  validates :country_code, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates_length_of :password, in: 6..20, on: :create

  has_many :itineraries
  has_many :reservations, through: :itineraries

  # before_create :generate_token
  after_create :save_join_phone_number!
#------------------ send an SMS to the user when an itinerary is requested.
  def send_message_via_sms(message)
  @app_number = ENV['TWILIO_NUMBER']
  @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
  sms_message = @client.account.messages.create(
    from: @app_number,
    to: self.phone_number,
    body: message,
    )
  end

  def check_for_reservations_pending
    if pending_reservation
      pending_reservation.notify_host(true)
    end
  end

  def pending_reservation
    self.reservations.where(status: "pending").last
  end

  def pending_reservations
    self.reservations.where(status: "pending")
  end


  private

  # def generate_token
  #   self.token = SecureRandom.urlsafe_base64(nil, false)
  # end

  # No reason to save phone number without the area_code, it's what twilio & ActiveRecord expect
  def save_join_phone_number!
    self.update!(phone_number: "#{self.area_code}#{self.phone_number}")
  end

end
