require 'spec_helper'

describe 'server' do
  describe 'version' do
    it 'should be string' do
      expect(zbx.server.version).to be_kind_of(String)
    end

    it 'should be 5.0.x, 5.2.x, 5.4.x, 6.0.x, 6.2.x, or 6.4.x' do
      expect(zbx.server.version).to match(/[56]\.[024]\.\d+/)
    end
  end
end
