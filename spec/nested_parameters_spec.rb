require 'spec_helper'

describe Sinatra::FilteringParameters do

  def expect_with(parameters, keys, &block)
    mock_route '/', :allow => keys, &block
    post '/', parameters
  end

  it "permitted nested parameters" do
    parameters = {
      :book => {
        :title => "Romeo and Juliet",
        :authors => [{
          :name => "William Shakespeare",
          :born => "1564-04-26"
        }, {
          :name => "Christopher Marlowe"
        }],
        :details => {
          :pages => 200,
          :genre => "Tragedy"
        }
      },
      :magazine => "Mjallo!"
    }
    keys = {
      :book => [
        :title,
        :authors => :name,
        :details => :pages
      ]
    }
    expect_with parameters, keys do
      params[:book][:title].should == 'Romeo and Juliet'
      params[:book][:authors][0][:name].should == 'William Shakespeare'
      params[:book][:authors][1][:name].should == 'Christopher Marlowe'
      params[:book][:details][:pages].should == '200'
      params[:book][:details][:genre].should be_nil
      params[:book][:authors][1][:born].should be_nil
      params[:magazine].should be_nil
    end
  end

  it "nested arrays with strings" do
    parameters = {
      :book => {
        :genres => ["Tragedy"]
      }
    }
    keys = {
      :book => :genres
    }
    expect_with parameters, keys do
      params[:book][:genres].should == ['Tragedy']
    end
  end

  it "permit may specify symbols or strings" do
    parameters = {
      :book => {
        :title => "Romeo and Juliet",
        :author => "William Shakespeare"
      },
      :magazine => "Shakespeare Today"
    }
    keys = [{
      :book => [
        "title",
        :author
      ]},
      "magazine"
    ]
    expect_with parameters, keys do
      params[:book][:title].should == 'Romeo and Juliet'
      params[:book][:author].should == 'William Shakespeare'
      params[:magazine].should == 'Shakespeare Today'
    end
  end

  it "nested array with strings that should be hashes" do
    parameters = {
      :book => {
        :genres => ["Tragedy"]
      }
    }
    keys = {
      :book => [
        :genres => :type
      ]
    }
    expect_with parameters, keys do
      params.should be_empty
    end
  end

  it "nested array with strings that should be hashes and additional values" do
    parameters = {
      :book => {
        :title => "Romeo and Juliet",
        :genres => ["Tragedy"]
      }
    }
    keys = [
      :book => [
        :title,
        :genres => :type
      ]
    ]
    expect_with parameters, keys do
      params[:book][:title].should == 'Romeo and Juliet'
    end
  end

  it "nested string that should be a hash" do
    parameters = {
      :book => {
        :genre => "Tragedy"
      }
    }
    keys = [
      :book => [
        :genres => :type
       ]
    ]
    expect_with parameters, keys do
      params.should be_empty
    end
  end

  it "fields_for_style_nested_params" do
    parameters = {
      :book => {
        :authors_attributes => {
          :'0' => { :name => 'William Shakespeare', :age_of_death => '52' },
          :'1' => { :name => 'Unattributed Assistant' }
        }
      }
    }
    keys = [
      :book => [
        :authors_attributes => :name
      ]
    ]
    expect_with parameters, keys do
      params[:book][:authors_attributes]['0'][:name].should == 'William Shakespeare'
      params[:book][:authors_attributes]['1'][:name].should == 'Unattributed Assistant'
    end
  end

  it "fields_for_style_nested_params with negative numbers" do
    parameters = {
      :book => {
        :authors_attributes => {
          :'-1' => { :name => 'William Shakespeare', :age_of_death => '52' },
          :'-2' => { :name => 'Unattributed Assistant' }
        }
      }
    }
    keys = [
      :book => [
        :authors_attributes => :name
      ]
    ]
    expect_with parameters, keys do
      params[:book][:authors_attributes]['-1'][:name].should == 'William Shakespeare'
      params[:book][:authors_attributes]['-2'][:name].should == 'Unattributed Assistant'
    end
  end

  it "nested array with nil values should be filtred" do
    parameters = {
      :book => {
        :genre => "Tragedy",
        :revisor => nil
      }
    }
    keys = [
      :book => [
        :genre,
        :revisor
      ]
    ]
    expect_with parameters, keys do
      params[:book][:genre].should == "Tragedy"
      params[:book][:revisor].should be_nil
    end
  end
end
