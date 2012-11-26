require 'spec_helper'

describe Sinatra::FilteringParameters do

  def post_with_filter(args)
    mock_app do
      register Sinatra::FilteringParameters
      post('/', allow: args[:allow]){ params.to_json }
    end
    post '/', args[:pass_params]
  end

  it "permitted nested parameters" do
    post_with_filter(
      :pass_params => {
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
      },
      :allow => [
        :book => [
          :title,
          :authors => :name,
          :details => :pages
        ]
      ]
    )
    result_should_be_equal({
      "book" => {
        "title" => "Romeo and Juliet",
        "authors" => [{
          "name" => "William Shakespeare"
        },{
          "name" => "Christopher Marlowe"
        }],
        "details" => {
          "pages" => "200"
        }
      }
    })
  end
  it "nested arrays with strings" do
    post_with_filter(
      :pass_params => {
        :book => {
          :genres => ["Tragedy"]
        }
      },
      :allow => [
        :book => :genres
      ]
    )
    result_should_be_equal({
      "book" => {
        "genres" => ["Tragedy"]
      }
    })
  end

  it "permit may specify symbols or strings" do
    post_with_filter(
      :pass_params => {
        :book => {
          :title => "Romeo and Juliet",
          :author => "William Shakespeare"
        },
        :magazine => "Shakespeare Today"
      },
      :allow => [{
        :book => [
          "title",
          :author
        ]},
        "magazine"
      ]
    )
    result_should_be_equal({
      "book" => {
        "title" => "Romeo and Juliet",
        "author" => "William Shakespeare",
      },
      "magazine" => "Shakespeare Today"
    })
  end

  it "nested array with strings that should be hashes" do
    post_with_filter(
      :pass_params => {
        :book => {
          :genres => ["Tragedy"]
        }
      },
      :allow => [
        :book => [
          :genres => :type
        ]
      ]
    )
    result_should_be_equal({})
  end

  it "nested array with strings that should be hashes and additional values" do
    post_with_filter(
      :pass_params => {
        :book => {
          :title => "Romeo and Juliet",
          :genres => ["Tragedy"]
        }
      },
      :allow => [
        :book => [
          :title,
          :genres => :type
        ]
      ]
    )
    result_should_be_equal({
      "book" => {
        "title" => "Romeo and Juliet"
      }
    })
  end

  it "nested string that should be a hash" do
    post_with_filter(
      :pass_params => {
        :book => {
          :genre => "Tragedy"
        }
      },
      :allow => [
        :book => [
          :genres => :type
         ]
      ]
    )
    result_should_be_equal({})
  end

  it "fields_for_style_nested_params" do
    post_with_filter(
      :pass_params => {
        :book => {
          :authors_attributes => {
            :'0' => { :name => 'William Shakespeare', :age_of_death => '52' },
            :'1' => { :name => 'Unattributed Assistant' }
          }
        }
      },
      :allow => [
        :book => [
          :authors_attributes => :name
        ]
      ]
    )
    result_should_be_equal({
      "book" => {
        "authors_attributes" => {
          "0" => { "name" => "William Shakespeare" },
          "1" => { "name" => "Unattributed Assistant" }
        }
      }
    })
  end

  it "fields_for_style_nested_params with negative numbers" do
    post_with_filter(
      :pass_params => {
        :book => {
          :authors_attributes => {
            :'-1' => { :name => 'William Shakespeare', :age_of_death => '52' },
            :'-2' => { :name => 'Unattributed Assistant' }
          }
        }
      },
      :allow => [
        :book => [
          :authors_attributes => :name
        ]
      ]
    )
    result_should_be_equal({
      "book" => {
        "authors_attributes" => {
          "-1" => { "name" => "William Shakespeare" },
          "-2" => { "name" => "Unattributed Assistant" }
        }
      }
    })
  end

end
