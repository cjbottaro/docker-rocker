require "spec_helper"

describe Rockerfile::Engine do

  it "creates Dockerfile from Rockerfile" do
    actual = described_class.new.render("spec/Rockerfile-1.7.2")
    expected = File.read("spec/Dockerfile").strip

    expect(expected).to eq(actual)
  end

end
