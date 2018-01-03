require './spec/spec_helper.rb'

describe "XMP with EXIFR::JPEG" do
  before do
    XMP::Silencer.silently { @img = EXIFR::JPEG.new('spec/fixtures/multiple-app1.jpg') }
  end

  it "should parse image" do
    xmp = XMP.parse(@img)
    expect(xmp).to be_instance_of(XMP)
    expect(xmp.namespaces.sort).to match %w{dc iX pdf photoshop rdf tiff x xap xapRights}
  end
end
