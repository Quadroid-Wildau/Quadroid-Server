require 'spec_helper'

describe 'Landmark alerts API' do

  let(:url) { "/landmark_alerts" }

  def stub_paperclip(model)
    model.any_instance.stub(:save_attached_files).and_return(true)
    model.any_instance.stub(:delete_attached_files).and_return(true)
    Paperclip::Attachment.any_instance.stub(:post_process).and_return(true)
  end

  before(:each) do
    stub_paperclip(LandmarkAlert)
  end

  describe 'index action' do
    it 'should return empty landmarks array' do
      get url
      expect(response).to be_success
      result = JSON.parse(response.body)
      result['landmark_alerts'].count.should eq(0)
    end

    it 'should return all landmarks' do
      landmarks = create_list(:landmark_alert, 10)
      get url
      expect(response).to be_success
      result = JSON.parse(response.body)
      result['landmark_alerts'].count.should eq(landmarks.count)
      landmarks.each do |landmark|
        result['landmark_alerts'].find{ |v| v['id'] == landmark.id }.should_not be_nil
      end
    end

    it 'should include complete data per entry' do
      landmarks = create_list(:landmark_alert, 5)
      get url
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
      get "#{url}/#{landmark.id}"
      expect(response).to be_success
      result = JSON.parse(response.body)
      result['landmark_alert']['id'].should eq(landmark.id)
    end
    it 'should return not found (404/1)' do
      get "#{url}/1"
      response.response_code.should == 404
      result = JSON.parse(response.body)
      result['error']['code'].should eq(1)
      result['error']['message'].should_not be_blank
    end
  end

  describe 'create action' do

    # post :photo, :file => Rack::Test::UploadedFile.new(path, mime_type) # text/jpg

  end

  describe 'update action' do

  end

  describe 'destroy action' do

  end


  # it 'xxx' do
  #   FactoryGirl.create_list(:message, 10)

  #   get '/api/v1/messages'

  #   expect(response).to be_success            # test for the 200 status-code
  #   json = JSON.parse(response.body)
  #   expect(json['messages'].length).to eq(10) # check to make sure the right amount of messages are returned
  # end

end