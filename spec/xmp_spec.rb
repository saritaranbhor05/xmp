# encoding: UTF-8
require './spec/spec_helper.rb'

describe XMP do
  describe "with xmp.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp.xml')) }

    it "should return all namespace names" do
      expect(@xmp.namespaces.sort).to match %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}.sort
    end

    it "should return standalone attribute" do
      expect(@xmp.dc.title).to eq(['Tytuł zdjęcia'])
      expect(@xmp.dc.subject).to eq(['Słowa kluczowe i numery startowe.'])
      expect(@xmp.photoshop.SupplementalCategories).to eq(['Nazwa imprezy'])
    end

    it "should return standalone attribute hash" do
      expect(@xmp.Iptc4xmpCore.CreatorContactInfo).to eq({'CiAdrCtry' => 'Germany', 'CiAdrCity' => 'Berlin'})
    end

    it "should return embedded attribute" do
      expect(@xmp.Iptc4xmpCore.Location).to eq('Miejsce')
      expect(@xmp.photoshop.Category).to eq('Kategoria')
    end

    it "should raise NoMethodError on unknown attribute" do
      expect { @xmp.photoshop.UnknownAttribute }.to raise_error(NoMethodError)
    end

    describe "namespace 'tiff'" do
      before { @namespace = @xmp.tiff }

      it "should return all attribute names" do
        expect(@namespace.attributes).to include(*%w{Make Model ImageWidth ImageLength XResolution YResolution ResolutionUnit})
      end
    end

    describe "namespace 'photoshop'" do
      before { @namespace = @xmp.photoshop }

      it "should return all attribute names" do
        expect(@namespace.attributes).to include(*%w{LegacyIPTCDigest Category SupplementalCategories})
      end
    end
  end

  describe "with xmp2.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp2.xml')) }

    it "should return all namespace names" do
      expect(@xmp.namespaces.sort).to match %w{dc iX pdf photoshop rdf tiff x xap xapRights}.sort
    end

    it "should return standalone attribute" do
      expect(@xmp.dc.creator).to eq(['BenjaminStorrier'])
      expect(@xmp.dc.subject).to eq(['SAMPLEkeyworddataFromIview'])
    end

    it "should return embedded attribute" do
      expect(@xmp.photoshop.Headline).to eq('DeniseTestImage')
      expect(@xmp.photoshop.Credit).to eq('Remco')
    end
  end

  # metadata after lightroom -> preview (resize)
  # this one has only standalone attributes
  describe "with xmp3.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp3.xml')) }

    it "should return attributes" do
      expect(@xmp.Iptc4xmpCore.Location).to eq('Phạm Đình Hồ')
      expect(@xmp.photoshop.City).to eq('Hanoi')
      expect(@xmp.aux.Lens).to eq('EF24-105mm f/4L IS USM')
    end

    it "should return standalone attribute hash" do
      expect(@xmp.Iptc4xmpCore.CreatorContactInfo).to eq({'CiAdrCtry' => 'Germany', 'CiAdrCity' => 'Berlin'})
    end

  end

  # metadata after lightroom
  describe "with xmp4.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp4.xml')) }

    it "should return dc:format" do
      expect(@xmp.dc.format).to eq('image/jpeg')
    end

    it "should return standalone attribute hash" do
      expect(@xmp.Iptc4xmpCore.CreatorContactInfo).to eq({'CiAdrCtry' => 'Germany', 'CiAdrCity' => 'Berlin'})
    end


  end
end
