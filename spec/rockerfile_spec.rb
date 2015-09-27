require 'spec_helper'

describe Rockerfile do
  it 'has a version number' do
    expect(Rockerfile::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
