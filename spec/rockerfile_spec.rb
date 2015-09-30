require 'spec_helper'

describe Rockerfile do
  it 'has a version number' do
    expect(Rockerfile::VERSION).not_to be nil
  end
end
