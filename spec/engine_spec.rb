require "spec_helper"

describe DockerRocker::Engine do

  it "creates Dockerfile from docker-rocker" do
    actual = described_class.new.render("spec/Rockerfile-1.7.2")
    expected = File.read("spec/Dockerfile").strip

    expect(expected).to eq(actual)
  end

end
