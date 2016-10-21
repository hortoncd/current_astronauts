require_relative 'spec_helper.rb'
require_relative '../lib/current_astronauts'

include CurrentAstronauts

# data['message'] other than 'success'
def stub_message_fail
  @response_fail = File.open(File.join('fixtures', 'astros-fail.json'), 'r').read
  stub_request(:get, /api.open-notify.org\/astros.json/).to_return(:body => @response_fail, :status => 200, :headers => {'Content-Type'=>'application/json'})
end

# 404
def stub_message_not_found
  stub_request(:get, /api.open-notify.org\/astros.json/).to_return(:body => "", :status => 404, :headers => {'Content-Type'=>'application/json'})
end

# 503
def stub_message_error
  stub_request(:get, /api.open-notify.org\/astros.json/).to_return(:body => "", :status => 503, :headers => {'Content-Type'=>'application/json'})
end

describe Astronauts do
  before :each do
    ENV['OPEN_NOTIFY_URL'] = nil
    @astronauts = Astronauts.new
    @response = File.open(File.join('fixtures', 'astros.json'), 'r').read
    @response_json = JSON.parse(@response)
    stub_request(:get, /api.open-notify.org\/astros.json/).to_return(:body => @response, :status => 200, :headers => {'Content-Type'=>'application/json'})
  end

  it 'is an Astronauts object' do
    expect(@astronauts).to be_kind_of(Astronauts)
  end

  it 'data is nil until fetched' do
    expect(@astronauts.data).to be(nil)
  end

  it 'fetches data from the api' do
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.data).to be_kind_of(Hash)
    expect(@astronauts.data).to eq(@response_json)
  end

  # Set URL via ENV and verify response is correct
  it 'fetches data from the api using ENV for URL' do
    ENV['OPEN_NOTIFY_URL'] = "http://api2.open-notify.org/astros2.json"

    # Re-set for the ENV setup rather than default
    @response = File.open(File.join('fixtures', 'astros2.json'), 'r').read
    @response_json = JSON.parse(@response)
    stub_request(:get, /api2.open-notify.org\/astros2.json/).to_return(:body => @response, :status => 200, :headers => {'Content-Type'=>'application/json'})
    @astronauts = Astronauts.new

    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.data).to be_kind_of(Hash)
    expect(@astronauts.data).to eq(@response_json)

    # Unset ENV var for rest of tests
    ENV['OPEN_NOTIFY_URL'] = nil
  end

  # Haven't seen the errors from the API, but just make sure our basic error handling is working
  it 'sets error code when 404 from the api' do
    stub_message_not_found
    expect(@astronauts.fetch).to eq(404)
    expect(@astronauts.data).to be(nil)
  end

  # Haven't seen the errors from the API, but just make sure our basic error handling is working
  it 'sets error code when 503 from the api' do
    stub_message_error
    expect(@astronauts.fetch).to eq(503)
    expect(@astronauts.data).to be(nil)
  end

  it 'returns true for success? when message == success' do
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.success?).to eq(true)
  end

  it 'returns false for success? before data is fetched' do
    expect(@astronauts.success?).to eq(false)
  end

  it 'returns false for success? when message is other than success' do
    stub_message_fail
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.success?).to eq(false)
  end

  it 'returns the number of astronauts currently in space' do
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.num).to eq(@response_json['number'])
  end

  it 'returns nil for number of astronauts currently in space when not success?' do
    stub_message_fail
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.num).to eq(nil)
  end

  it 'returns the list of astronauts and craft currently in space' do
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.people).to eq(@response_json['people'])
  end

  it 'returns nil for list of astronauts currently in space when not success?' do
    stub_message_fail
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.people).to eq(nil)
  end

  it 'prints out the list of astronauts and craft currently in space' do
    @stdout = File.open(File.join('fixtures', 'print_output.txt'), 'r').read
    expect(@astronauts.fetch).to eq(200)
    expect { @astronauts.print }.to output(@stdout).to_stdout
  end

  it 'refuses to print for failed fetch' do
    stub_message_fail
    expect(@astronauts.fetch).to eq(200)
    expect(@astronauts.print).to eq(nil)
  end
end
