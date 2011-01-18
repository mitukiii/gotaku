class Gotaku
  class Question
    LENGTH = 256
    FORMAT = 'a116a28a28a28a28a28'

    def self.parse(bulk)
      new do
        @data = (bulk ? Util.decode(bulk).unpack(FORMAT) : [])
        @data = @data.map {|l| l.toutf8.strip}
        @message = @data.first
        @choices = @data[1..-1]
      end
    end

    attr_reader :message, :choices

    def initialize(&block)
      instance_eval(&block) if block_given?
    end
  end
end
