# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe "Daily Turn Over", type: :model do
  let(:data)          { JSON.parse(File.read('data.json')) }
  let(:output)        { JSON.parse(File.read('output.json')) }
  let(:output_false)  { JSON.parse(File.read('output_false.json')) }
  let(:practitioners) {data["practitioners"]}
  let(:communication) {data["communications"].first}
  let(:communication_with_only_several_pages) {data["communications"].last}


  it 'should calculate the color price' do
    expect(DailyTurnOver.new.color_price(communication)).to eq(DailyTurnOver.const_get("COLOR_PRICE"))
  end

  it 'should not have color price' do
    expect(DailyTurnOver.new.color_price(communication_with_only_several_pages)).to eq(0.0)
  end

  it 'should calculate express delivery price' do
    expect(DailyTurnOver.new.express_delivery_price(communication)).to eq(DailyTurnOver.const_get("EXPRESS_DELIVERY_PRICE"))
  end

  it 'should not have express delivery price' do
    expect(DailyTurnOver.new.express_delivery_price(communication_with_only_several_pages)).to eq(0.0)
  end

  it 'should calculate one page price' do
    expect(DailyTurnOver.new.page_price(communication)).to eq(DailyTurnOver.const_get("PRICE"))
  end

  it 'should calculate several pages price' do
    expect(DailyTurnOver.new.page_price(communication_with_only_several_pages)).to eq(DailyTurnOver.const_get("PRICE") + (communication_with_only_several_pages["pages_number"]-1) * DailyTurnOver.const_get("NEXT_PAGE_PRICE"))
  end

  it 'should calculate total communication price' do
    expect(DailyTurnOver.new.communication_price(communication)).to eq(DailyTurnOver.const_get("PRICE") + DailyTurnOver.const_get("COLOR_PRICE") + DailyTurnOver.const_get("EXPRESS_DELIVERY_PRICE"))
  end

  it 'should create the output json' do
    expect(DailyTurnOver.new.create_output_json(data)).to eq(output)
  end

end
