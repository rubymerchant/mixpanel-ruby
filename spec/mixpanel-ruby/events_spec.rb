require 'spec_helper'
require 'mixpanel-ruby/events.rb'
require 'mixpanel-ruby/version.rb'
require 'time'

describe Mixpanel::Events do
  before(:each) do
    @time_now = Time.parse('Jun 6 1972, 16:23:04')
    Time.stub!(:now).and_return(@time_now)

    @log = []
    @events = Mixpanel::Events.new('TEST TOKEN') do |type, message|
      @log << [ type, JSON.load(message['data']), message['api_key'] ]
    end
  end

  it 'should send a well formed track/ message' do
    @events.track('TEST ID', 'Test Event', {
        'Circumstances' => 'During a test'
    })
    @log.should eq([[ :event, {
        'event' => 'Test Event',
        'properties' => {
            'Circumstances' => 'During a test',
            'distinct_id' => 'TEST ID',
            'mp_lib' => 'ruby',
            '$lib_version' => Mixpanel::VERSION,
            'token' => 'TEST TOKEN',
            'time' => @time_now.to_i
        }
    }, nil]])
  end

  it 'should send a well formed import/ message' do
    @events.import('API_KEY', 'TEST ID', 'Test Event', {
        'Circumstances' => 'During a test'
    })
    @log.should eq([[ :import, {
        'event' => 'Test Event',
        'properties' => {
            'Circumstances' => 'During a test',
            'distinct_id' => 'TEST ID',
            'mp_lib' => 'ruby',
            '$lib_version' => Mixpanel::VERSION,
            'token' => 'TEST TOKEN',
            'time' => @time_now.to_i
        }
    }, 'API_KEY']])
  end
end

