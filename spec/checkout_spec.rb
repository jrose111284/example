require 'checkout'
require 'item'

describe Checkout do

  subject(:checkout) { described_class.new(item) }

  let(:item) { double(:item) }

  let (:products) do
    {
      001 => 9.25,
      002 => 45.00,
      003 => 19.95
    }
  end

  before do
    allow(item).to receive(:has_product?).with(001).and_return(true)
    allow(item).to receive(:has_product?).with(002).and_return(true)
    allow(item).to receive(:has_product?).with(003).and_return(true)
  end

  it "it initialize with a empty order" do
    expect(checkout.order).to be_empty
  end

  it "can scan a barcode" do
    expect(checkout.scan(001)).to eq([9.25])
  end

  it "can scan all barcodes" do
    checkout_scan
    expect(checkout.order).to eq([9.25, 45.0, 19.95])
  end

  it "doesnt allow items to be added that are not there" do
    allow(item).to receive(:has_product?).with(404).and_return(false)
    expect { checkout.scan(404)}.to raise_error "404 is not in products"
  end

  it "calculates the total of order with out promotion rule" do
    non_promotional
    total = 54.25
    expect(checkout.total).to eq(total)
  end

end
