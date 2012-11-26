require 'spec_helper'

describe Sinatra::FilteringParameters do

  def post_with_filter(args)
    mock_app do
      register Sinatra::FilteringParameters
      if args[:allow].nil?
        post('/sample/:name'){ params.to_json }
      else
        post('/sample/:name', allow: args[:allow]){ params.to_json }
      end
    end
    post '/sample/foo', args[:pass_params]
  end

  describe 'permitted parameters nothing' do
    it "when success" do
      post_with_filter(
        :pass_params  =>  { :a => 1, :b => 2, :c => 3 }
      )
      result_should_be_equal({ "a"=>"1", "b"=>"2", "c"=>"3", "splat"=>[], "captures"=>["foo"], "name"=>"foo" })
    end
  end

  describe 'permitted parameters specified in' do
    it 'symbol' do
      post_with_filter(
        :pass_params  =>  { :a => 1, :b => 2, :c => 3 },
        :allow        =>  :name
      )
      result_should_be_equal({ "splat"=>[], "captures"=>["foo"], "name"=>"foo" })
    end
    it "string" do
      post_with_filter(
        :pass_params  =>  { :a => 1, :b => 2, :c => 3 },
        :allow        =>  'name'
      )
      result_should_be_equal({ "splat"=>[], "captures"=>["foo"], "name"=>"foo" })
    end
    it "array" do
      post_with_filter(
        :pass_params  =>  { :a => 1, :b => 2, :c => 3 },
        :allow        =>  [:name, :a]
      )
      result_should_be_equal({ "splat"=>[], "captures"=>["foo"], "name"=>"foo", "a"=>"1" })
    end
    context "empty" do
      it "string" do
        post_with_filter(
          :pass_params  =>  { :a => 1, :b => 2, :c => 3 },
          :allow        =>  ''
        )
        result_should_be_equal({ "splat"=>[], "captures"=>["foo"] })
      end
      it "array" do
        post_with_filter(
          :pass_params  =>  { :a => 1, :b => 2, :c => 3 },
          :allow        =>  []
        )
        result_should_be_equal({ "splat"=>[], "captures"=>["foo"] })
      end
    end
  end

end
