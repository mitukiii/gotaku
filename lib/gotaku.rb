require 'kconv'
require 'builder'
require 'gotaku/header'
require 'gotaku/question'
require 'gotaku/util'

class Gotaku
  MAX_ENTRY = 8

  def self.parse(arg)
    new do
      if arg.is_a? File
        @path, @file = arg.path, arg
      elsif File.exists?(arg)
        @path, @file = arg, open(arg)
      else
        raise Errno::ENOENT
      end
    end
  end

  attr_reader :path

  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def headers
    return @headers if @headers

    @headers = []
    MAX_ENTRY.times do |i|
      @file.seek(i * Header::LENGTH, IO::SEEK_SET)
      buffer = @file.read(Header::LENGTH)
      @headers << Header.parse(buffer)
    end

    @headers
  end

  def list
    return @list if @list

    @list = []
    headers.each do |h|
      h.size.times do |i|
        @list << h.skip * Header::LENGTH + Question::LENGTH * i
      end
    end

    @list
  end

  def questions
    return @questions if @questions

    @questions = []
    list.each do |l|
      @file.seek(l, IO::SEEK_SET)
      buffer = @file.read(Question::LENGTH)
      @questions << Question.parse(buffer)
    end

    @questions
  end

  def verify?
    headers.all?(&:verify?)
  end

  def to_xml(options = {})
    xml = Builder::XmlMarkup.new(options)
    xml.instruct! :xml, encoding: 'UTF-8'
    xml.gotaku do
    end
  end
end
