# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe :Gotaku do
  describe :parse do
    context 'with file path' do
      subject { Gotaku.parse GOTAKU_FILE }
      it { should be_is_a Gotaku }
      it { should be_verify }
    end

    context 'with file' do
      subject { Gotaku.parse open(GOTAKU_FILE) }
      it { should be_is_a Gotaku }
      it { should be_verify }
    end

    context 'with invalid file path' do
      it do
        lambda { Gotaku.parse INVALID_FILE }.should raise_error Errno::ENOENT
      end
    end
  end

  before do
    @gotaku = Gotaku.parse GOTAKU_FILE
  end

  describe :headers do
    before do
      @headers = @gotaku.headers
    end

    subject { @headers }

    it { should have(8).items }

    context :sample do
      subject { @headers.sample }

      it 'index should be is a numeric' do
        subject.index.should be_is_a Numeric
      end

      it 'type should match /ジャンル\d/' do
        subject.type.should match /ジャンル\d/
      end

      it 'file should == "TEST.5TD"' do
        subject.file.should == 'TEST.5TD'
      end

      it 'code should == "5TAKUQDT"' do
        subject.code == '5TAKUQDT'
      end
    end
  end

  describe :questions do
    before do
      @questions = @gotaku.questions
    end

    subject { @questions }

    it 'length should == headers.map(&:size).inject(:+)' do
      subject.length.should == @gotaku.headers.map(&:size).inject(:+)
    end

    context :sample do
      subject { @questions.sample }

      it 'genre should be is a Numeric' do
        subject.genre.should be_is_a Numeric
      end

      it 'index should be is a Numeric' do
        subject.index.should be_is_a Numeric
      end

      it 'message should == "TestQuestion"' do
        subject.message.should == 'TestQuestion'
      end

      it 'choices should have 5 items' do
        subject.choices.should have(5).items
      end
    end
  end

  describe :to_xml do
    before do
      @xml = @gotaku.to_xml
      @doc = Nokogiri::XML @xml
    end

    subject { @doc }

    it { @xml.should match /^<\?xml/ }

    it 'at "gotaku" should not be nil' do
      subject.at('gotaku').should_not be_nil
    end

    context :headers do
      before do
        @headers = @doc.at('headers')
      end

      subject { @headers }

      it { should_not be_nil }

      it 'search "header" have 8 items' do
        subject.search('header').should have(8).items
      end

      context :sample do
        subject { @headers.search('header').to_a.sample }

        it 'get_attribute "id" should not be nil' do
          subject.get_attribute('id').should_not be_nil
        end

        it 'at "type" text should match /ジャンル\d/' do
          subject.at('type').text.should match /ジャンル\d/
        end

        it 'at "file" text should == "TEST.5TD"' do
          subject.at('file').text.should == 'TEST.5TD'
        end

        it 'at "code" text should == "5TAKUQDT"' do
          subject.at('code').text == '5TAKUQDT'
        end
      end
    end

    context :questions do
      before do
        @questions = @doc.at('questions')
      end

      subject { @questions }

      it { should_not be_nil }

      it 'search "question" length == headers.map(&:size).inject(:+)' do
        subject.search('question').length.should ==
          @gotaku.headers.map(&:size).inject(:+)
      end

      context :sample do
        subject { @questions.search('question').to_a.sample }

        it 'at "message" text should == "TestQuestion"' do
          subject.at('message').text.should == 'TestQuestion'
        end

        it 'search "choice" have 5 items' do
          subject.search('choice').should have(5).items
        end
      end
    end
  end
end
