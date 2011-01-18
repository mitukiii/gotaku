class Gotaku
  module Util
    extend self

    MASK = 128

    def decode(bulk)
      data = bulk.unpack('c' * bulk.length)
      span = ' '.unpack('U*')
      ret = true

      data = data.map do |d|
        if ret
          char = d ^ MASK
          if d == span
            d = MASK
          elsif (char > 0x7f && char < 0xa0) || (char > 0xdf && char <= 0xff)
            ret = false
          end
        else
          ret = true
        end
        d ^ MASK
      end

      data.pack('c' * data.length)
    end
  end
end
