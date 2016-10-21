require 'current_astronauts/version'

require 'httparty'

module CurrentAstronauts
  class Astronauts
    attr_reader :data

    def initialize
      if ENV['OPEN_NOTIFY_URL']
        @url = ENV['OPEN_NOTIFY_URL']
      else
        @url = 'http://api.open-notify.org/astros.json'
      end
      @data = nil
    end

    # Let's go get some data
    def fetch
      response = HTTParty.get(@url)
      if response.success?
        @data = response.parsed_response
      end
      response.code
    end

    # Fetch succeeded and data message is 'success'
    def success?
      stat = false
      if @data and @data['message'] == 'success'
        stat = true
      end
      return stat
    end

    # How many astronauts in space?
    def num
      success? ? @data['number'] : nil
    end

    # List of astronauts and their craft, as an array of hashes
    def people
      success? ? @data['people'] : nil
    end

    # Print a formatted list of astronauts and their craft
    def print
      unless success?
        return nil
      end
      nlen = "Name".length
      clen = "Craft".length
      @data['people'].each do |p|
        nlen = p['name'].length > nlen ? p['name'].length : nlen
        clen = p['craft'].length > clen ? p['craft'].length : clen
      end

      print_header(nlen, clen)
      @data['people'].each do |p|
        print_line(nlen, p['name'], clen, p['craft'])
      end
    end

    private

    # print header with appropriate spacing
    def print_header(nlen, clen)
      print_line(nlen, "Name", clen, "Craft")
      puts "%-#{nlen}s-|-%-#{clen}s-" % ["-" * nlen, "-" * clen]
    end

    # print individual lines with appropriate spacing
    def print_line(nlen, n, clen, c)
      puts "%-#{nlen}s | %-#{clen}s " % [n, c]
    end
  end
end
