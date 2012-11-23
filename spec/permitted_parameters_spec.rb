require 'spec_helper'
require 'sinatra/filtering_parameters'
require 'json'

describe Sinatra::FilteringParameters do
  let(:pass_params) { { :a => 1, :b => 2, :c => 3 } }

  before do
    result =  Proc.new { params.to_json }
    mock_app do
      register Sinatra::FilteringParameters
      post '/sample/:name', &result
      post '/symbol/:name', allow: :name, &result
      post '/string/:name', allow: 'name', &result
      post '/array/:name', allow: [:name, :a], &result
      post '/empty_string/:name', allow: '', &result
      post '/empty_array/:name', allow: [], &result
    end
  end

  describe 'permitted parameters nothing' do
    it "when success" do
      post '/sample/foo', pass_params
      last_response.should be_ok
      last_response.body.should ==
        {"a"=>"1", "b"=>"2", "c"=>"3", "splat"=>[], "captures"=>["foo"], "name"=>"foo"}.to_json
    end
  end
  describe 'permitted parameters specified in' do
    it 'symbol' do
      post '/symbol/foo', pass_params
      last_response.should be_ok
      last_response.body.should ==
        {"splat"=>[], "captures"=>["foo"], "name"=>"foo"}.to_json
    end
    it "string" do
      post '/string/foo', pass_params
      last_response.should be_ok
      last_response.body.should ==
        {"splat"=>[], "captures"=>["foo"], "name"=>"foo"}.to_json
    end
    it "array" do
      post '/array/foo', pass_params
      last_response.should be_ok
      last_response.body.should ==
        {"splat"=>[], "captures"=>["foo"], "name"=>"foo", "a"=>"1"}.to_json
    end
    context "empty" do
      it "string" do
        post '/empty_string/foo', pass_params
        last_response.should be_ok
        last_response.body.should ==
          {"splat"=>[], "captures"=>["foo"]}.to_json
      end
      it "array" do
        post '/empty_array/foo', pass_params
        last_response.should be_ok
        last_response.body.should ==
          {"splat"=>[], "captures"=>["foo"]}.to_json
      end
    end
  end

end
