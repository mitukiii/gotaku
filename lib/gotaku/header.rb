class Gotaku
  class Header
    LENGTH = 256
    FORMAT = 'a16vvva12a8a214'
    DEFAULT = ['noname', 0, 0, 0, 'noname', '5TAKUQDT', 0]

    def self.parse(bulk)
      new do
        @data = bulk ? bulk.unpack(FORMAT) : QUESTION
        @type, @pass, @size, @skip, @file, @code, @fill = @data
        @type, @file, @code = [@type, @file, @code].map {|l| l.toutf8.strip}
      end
    end

    attr_reader :type, :pass, :size, :skip, :file, :code, :fill

    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def verify?
      @code == '5TAKUQDT' || @code == '5TAKUQDX'
    end
  end
end
