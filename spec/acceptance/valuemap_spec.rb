require 'spec_helper'

describe 'valuemap' do
  before :all do
    @valuemap = gen_name 'valuemap'
    @hostgroup = gen_name 'hostgroup'
    @hostgroupid = zbx.hostgroups.create(name: @hostgroup)
    @template = gen_name 'template'
    @templateid = zbx.templates.create(
      host: @template,
      groups: [groupid: @hostgroupid]
    )
  end

  context 'when not exists' do
    describe 'create' do
      it 'should return an integer id' do
        params = {
          name: @valuemap,
          mappings: [
            'newvalue' => 'test',
            'value' => 'test'
          ]
        }
        if Gem::Version.new(zbx.client.api_version) >= VALUEMAP_HOSTID_REQUIRED_VERSION
          params[:hostid] = @templateid
        end

        valuemapid = zbx.valuemaps.create_or_update(**params)
        expect(valuemapid).to be_kind_of(Integer)
      end
    end
  end

  context 'when exists' do
    before do
      @params = {
        name: @valuemap,
        mappings: [
          'newvalue' => 'test',
          'value' => 'test'
        ]
      }
      if Gem::Version.new(zbx.client.api_version) >= VALUEMAP_HOSTID_REQUIRED_VERSION
        @params[:hostid] = @templateid
      end
      @valuemapid = zbx.valuemaps.create_or_update(**@params)
    end

    describe 'create_or_update' do
      it 'should return id' do
        expect(
          zbx.valuemaps.create_or_update(**@params)
        ).to eq @valuemapid
      end

      it 'should return id' do
        expect(@valuemapid).to eq @valuemapid
      end
    end
  end
end
