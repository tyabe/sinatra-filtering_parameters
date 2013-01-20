require 'spec_helper'

describe Sinatra::FilteringParameters do

  describe 'support matching parameters' do
    it 'for splat' do
      mock_route '/say/*/to/*' do
        params[:splat].should == ['hello','world']
      end
      get '/say/hello/to/world'
    end

    it 'for captures' do
      mock_route %r{/hello/([\w]+)} do
        params[:captures].should == ['world']
      end
      get '/hello/world'
    end
  end

  context 'do not specify ilter' do
    it "does not remove anything from the parameter" do
      mock_route '/pages/:id' do
        params[:id].should == '1'
        params[:foo].should == 'foo'
        params[:bar].should == 'bar'
        params[:baz].should == 'baz'
        params[:captures].should == ['1']
        params[:splat].should == []
      end
      post '/pages/1', :foo => 'foo', :bar => 'bar', :baz => 'baz'
    end
  end

  context 'will be only parameters that allowed in' do
    def should_with(filter={})
      mock_route '/pages', filter do
        params.delete('foo').should == 'foo'
        params.each { |param| param.should == nil }
      end
      post '/pages', :foo => 'foo', :bar => 'bar', :baz => 'baz'
    end

    it('symbol'){ should_with :allow => :foo }
    it("string"){ should_with :allow => 'foo' }
    it("array") { should_with :allow => [:foo] }
  end

  context 'parameter will be empty when specify in' do
    def should_with(filter={})
      mock_route '/pages', filter do
        params.each { |param| param.should == nil }
      end
      post '/pages', :foo => 'foo', :bar => 'bar', :baz => 'baz'
    end

    it("blank string"){ should_with :allow => '' }
    it("empty array") { should_with :allow => [] }
    it("empty hash")  { should_with :allow => {} }
    it("nil")         { should_with :allow => nil }
  end

end
