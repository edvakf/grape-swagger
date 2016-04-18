require 'spec_helper'

describe 'respect X-Forwarded-Host over Host header' do
  include_context "the api entities"

  before :all do
    module TheApi
      class EmptyApi < Grape::API
        format :json

        add_swagger_documentation
      end
    end
  end

  def app
    TheApi::EmptyApi
  end

  subject do
    header 'Host', 'dummy.example.com'
    header 'X-Forwarded-Host', 'real.example.com'
    get '/swagger_doc'
    JSON.parse(last_response.body)
  end

  specify do
    expect(subject['host']).to eq 'real.example.com'
  end
end
