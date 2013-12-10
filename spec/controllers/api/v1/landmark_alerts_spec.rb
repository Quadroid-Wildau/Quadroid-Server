require 'spec_helper'

include Devise::TestHelpers

describe Api::V1::LandmarkAlertsController do

  let(:dummy_image) { Rack::Test::UploadedFile.new(Rails.root + 'spec/factories/landmark_images/example.png', 'image/png') }

  let(:token) { double(:accessible? => true) }

  before do
    controller.stub(:doorkeeper_token) { token }
  end

  before(:each) do
    request.env['ACCEPT'] = "application/vnd.quadroid-server-v1+json"
    @user = create(:user)
    sign_in :user, @user
    controller.stub(:current_user).and_return(@user)
  end

  def to_params(landmark)
    hash = { landmark_alert: {} }
    hash[:landmark_alert][:latitude] = landmark.latitude if landmark.latitude
    hash[:landmark_alert][:longitude] = landmark.longitude if landmark.longitude
    hash[:landmark_alert][:height] = landmark.height if landmark.height
    hash[:landmark_alert][:detection_date] = landmark.detection_date.to_i if landmark.detection_date
    hash
  end

  describe 'index action' do
    it 'should return empty landmarks array' do
      get :index, nil
      expect(response).to be_success
      result = JSON.parse(response.body)
      result['landmark_alerts'].count.should eq(0)
    end

    it 'should return all landmarks' do
      landmarks = create_list(:landmark_alert, 10)
      get :index, nil
      expect(response).to be_success
      result = JSON.parse(response.body)
      result['landmark_alerts'].count.should eq(landmarks.count)
      landmarks.each do |landmark|
        result['landmark_alerts'].find{ |v| v['id'] == landmark.id }.should_not be_nil
      end
    end

    it 'should include complete data per entry' do
      landmarks = create_list(:landmark_alert, 5)
      get :index, nil
      result = JSON.parse(response.body)
      result['landmark_alerts'].each do |e|
        (e['image_url'] =~ /missing\.png/).should_not be_nil
        e['latitude'].to_f.should > 0
        e['longitude'].to_f.should > 0
        e['height'].to_f.should > 0
        e['detection_date'].to_i.should > 0
      end
    end
  end

  describe 'show action' do
    it 'should return landmark' do
      landmark = create(:landmark_alert)
      get :show, id: landmark.id
      expect(response).to be_success
      result = JSON.parse(response.body)
      result['landmark_alert']['id'].should eq(landmark.id)
    end
    it 'should return not found (404/1)' do
      get :show, id: 1
      response.response_code.should == 404
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
      result['error']['message'].should_not be_blank
    end
  end

  describe 'create action' do
    it 'should return 400/1 for missing latitude' do
      landmark = build(:landmark_alert, latitude: nil)
      expect { post :create, to_params(landmark) }.to change(LandmarkAlert, :count).by(0)
      response.response_code.should == 400
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
      result['error']['messages']['latitude'].should_not be_blank
    end
    it 'should return 400/1 for missing longitude' do
      landmark = build(:landmark_alert, longitude: nil)
      expect { post :create, to_params(landmark) }.to change(LandmarkAlert, :count).by(0)
      response.response_code.should == 400
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
      result['error']['messages']['longitude'].should_not be_blank
    end
    it 'should return 400/1 for missing height' do
      landmark = build(:landmark_alert, height: nil)
      expect { post :create, to_params(landmark) }.to change(LandmarkAlert, :count).by(0)
      response.response_code.should == 400
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
      result['error']['messages']['height'].should_not be_blank
    end
    it 'should return 400/1 for missing detection_date' do
      landmark = build(:landmark_alert, detection_date: nil)
      expect { post :create, to_params(landmark) }.to change(LandmarkAlert, :count).by(0)
      response.response_code.should == 400
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
      result['error']['messages']['detection_date'].should_not be_blank
    end
    it 'should create landmark' do
      landmark = build(:landmark_alert)
      expect { post :create, to_params(landmark) }.to change(LandmarkAlert, :count).by(1)
      response.response_code.should == 200
      result = JSON.parse(response.body)
      result['landmark_alert']['latitude'].should eq(landmark.latitude)
      result['landmark_alert']['longitude'].should eq(landmark.longitude)
      result['landmark_alert']['height'].should eq(landmark.height)
      result['landmark_alert']['detection_date'].should eq(landmark.detection_date.to_i)
    end
    it 'should upload image' do
      landmark = build(:landmark_alert)
      expect {
        hash = to_params(landmark)
        hash[:landmark_alert].merge!({ image: dummy_image })
        post :create, hash
      }.to change(LandmarkAlert, :count).by(1)
      response.response_code.should == 200
      result = JSON.parse(response.body)
      landmark = LandmarkAlert.find_by_id(result['landmark_alert']['id'])
      landmark.should_not be_nil
      landmark.image.path.should_not be_nil
      File.exists?(Rails.root + landmark.image.path).should be_true
      landmark.destroy
    end
    it 'should create only for desktop client'
  end

  describe 'update action' do
    it 'should return 404/1 for not existing id' do
      landmark = build(:landmark_alert)
      expect { put :update, to_params(landmark).merge(id: 9999) }.to change(LandmarkAlert, :count).by(0)
      response.response_code.should == 404
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
    end
    it 'should update landmark data' do
      landmark = create(:landmark_alert)
      new_height = landmark.height + 200
      put :update, to_params(LandmarkAlert.new(height: new_height)).merge(id: landmark.id)
      response.response_code.should == 200
      result = JSON.parse(response.body)
      result['landmark_alert']['id'].should eq(landmark.id)
      result['landmark_alert']['height'].should eq(new_height)
      l = LandmarkAlert.find(landmark.id)
      l.height.should eq(new_height)
    end
    it 'should update only for desktop client'
  end

  describe 'destroy action' do
    it 'should return 404/1 for not existing id' do
      expect { delete :destroy, id: 9999 }.to change(LandmarkAlert, :count).by(0)
      response.response_code.should == 404
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
    end
    it 'should destroy landmark alert' do
      landmark = create(:landmark_alert)
      expect { delete :destroy, id: landmark.id }.to change(LandmarkAlert, :count).by(-1)
      response.response_code.should == 200
      result = JSON.parse(response.body)
      result['status']['deleted'].should be_true
    end
    it 'should delete only for desktop client'
  end

  describe 'push notification' do
    it 'should notify at create'
    it 'should notify at update'
    it 'should notify all app clients'
  end

end