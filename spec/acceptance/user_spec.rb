require 'spec_helper'

describe 'user' do
  before :all do
    @usergroup = gen_name 'usergroup'
    @usergroupid = {
      usrgrpid: zbx.usergroups.create(name: @usergroup),
    }
    @roleid = "1"
    puts "USERGROUPID: #{@usergroupid}"

    @mediatype = gen_name 'mediatype'
    @mediatypeid = zbx.mediatypes.create(
      name: @mediatype,
      type: 0,
      smtp_server: '127.0.0.1',
      smtp_email: 'zabbix@test.com',
      smtp_helo: 'test.com'
    )
  end

  def media
    {
      mediatypeid: @mediatypeid,
      sendto: ['test@test.com'],
      active: 0,
      period: '1-7,00:00-24:00',
      severity: '56'
    }
  end

  context 'when not exists' do
    describe 'create' do
      it 'should return integer id' do
        user = gen_name 'user'
        passwd = gen_name 'passwd'
        params = {
          alias: user,
          name: user,
          surname: user,
          passwd: passwd,
          usrgrps: [@usergroupid]
        }
        if Gem::Version.new(zbx.client.api_version) >= MIN_ROLE_VERSION
          params[:roleid] = @roleid
        end
        userid = zbx.users.create(**params)
        expect(userid).to be_kind_of(Integer)
      end
    end

    describe 'get_id' do
      it 'should return nil' do
        expect(zbx.users.get_id(alias: 'name_____')).to be_nil
      end
    end
  end

  context 'when exists' do
    before :all do
      @user = gen_name 'user'
      @passwd = gen_name 'passwd'
      params = {
        alias: @user,
        name: @user,
        surname: @user,
        passwd: @passwd,
        usrgrps: [@usergroupid],
      }
      if Gem::Version.new(zbx.client.api_version) >= MIN_ROLE_VERSION
        params[:roleid] = @roleid
      end
      @userid = zbx.users.create(**params)
    end

    describe 'create_or_update' do
      it 'should return id' do
        params = {
            alias: @user,
            name: @user,
            surname: @user,
            passwd: @passwd,
            usrgrps: [@usergroupid],
        }
        if Gem::Version.new(zbx.client.api_version) >= MIN_ROLE_VERSION
          params[:roleid] = @roleid
        end
        expect(
          zbx.users.create_or_update(**params)
        ).to eq @userid
      end
    end

    describe 'get_full_data' do
      it 'should return string name' do
        expect(zbx.users.get_full_data(alias: @user)[0]['name']).to be_kind_of(String)
      end
    end

    describe 'update' do
      it 'should return id' do
        expect(zbx.users.update(userid: @userid, name: gen_name('user'))).to eq @userid
      end
    end

    describe 'update by adding media' do
      it 'should return id' do
        expect(
          zbx.users.add_medias(
            userids: [@userid],
            media: [media]
          )
        ).to be_kind_of(Integer)
      end
    end

    describe 'update_medias' do
      it 'should return the user id' do
        # Call twice to ensure update_medias first successfully creates the media, then updates it
        2.times do
          returned_userid = zbx.users.update_medias(
            userids: [@userid],
            media: [media]
          )

          expect(returned_userid).to eq @userid
        end
      end
    end

    describe 'delete' do
      it 'should return id' do
        expect(zbx.users.delete(@userid)).to eq @userid
      end
    end
  end
end
