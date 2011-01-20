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
      position = Header::LENGTH * i
      @file.seek(position, IO::SEEK_SET)
      buffer = @file.read(Header::LENGTH)
      @headers << Header.parse(buffer, index: i)
    end

    @headers
  end

  def questions
    return @questions if @questions

    @questions = []
    headers.each_with_index do |h, i|
      h.size.times do |j|
        position = Header::LENGTH * h.skip + Question::LENGTH * j
        @file.seek(position, IO::SEEK_SET)
        buffer = @file.read(Question::LENGTH)
        @questions << Question.parse(buffer)
      end
    end

    @questions
  end

  def verify?
    headers.all?(&:verify?)
  end

  def to_xml(options = {})
    options = {
      indent: 2,
      margin: 0
    }.update(options)

    xml = Builder::XmlMarkup.new(options)
    xml.instruct! :xml, encoding: 'UTF-8'
    xml.gotaku do
    xml.headers do
      headers.each_with_index do |h, i|
        xml.header id: i do
          xml.type h.type
          xml.file h.file
          xml.code h.code
        end
      end
    end
    xml.questions do
      questions.each_with_index do |q, i|
        xml.question id: i do
          xml.message q.message
          xml.choices do
            q.choices.each_with_index do |c, j|
              xml.choice c, id: j
            end
          end
        end
      end
    end
    end
  end
end
