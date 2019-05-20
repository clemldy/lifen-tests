require "json"
require "awesome_print"
require 'date'

class DailyTurnOver
  PRICE                  = 0.10
  NEXT_PAGE_PRICE        = 0.07
  COLOR_PRICE            = 0.18
  EXPRESS_DELIVERY_PRICE = 0.60

  def initialize
    @data          = JSON.parse(File.read('data.json'))
    @practitioners = @data["practitioners"]
  end

  def call
    results = create_output_json(@data)
    File.open("output.json","w") do |f|
       f.write(results.to_json)
    end
  end

  def communication_price(communication)
    total_price = page_price(communication) + color_price(communication) + express_delivery_price(communication)
  end

  def page_price(communication)
    if communication["pages_number"] > 1
      cost = PRICE  + (communication["pages_number"]-1) * NEXT_PAGE_PRICE
    else
      cost = PRICE
    end
  end

  def color_price(communication)
    if communication["color"] == true
      cost = COLOR_PRICE
    else
      cost = 0.0
    end
  end

  def express_delivery_price(communication)
    practitioner = @practitioners.find{|pract| pract["id"] == communication["practitioner_id"] }
    if practitioner["express_delivery"] == true
      cost = EXPRESS_DELIVERY_PRICE
    else
      cost = 0.0
    end
  end

  def create_output_json(data)
    sales = []
    data["communications"].each do |communication|
      hash = Hash.new
      date = DateTime.parse(communication["sent_at"]).strftime("%F")
      if sale = sales&.find{ |sale| sale["sent_on"] == date }
        sale["total"] += communication_price(communication)
      else
        hash["sent_on"] = date
        hash["total"]   = communication_price(communication)
        sales << hash
      end
    end
    sales.each { |hash| hash["total"] = hash["total"].round(2)}
    { 'totals' => sales }
  end

end
