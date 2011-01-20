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

  describe :list do
    subject { @list = @gotaku.list }

    it 'length should == headers.map(&:size).inject(:+)' do
      subject.length.should == @gotaku.headers.map(&:size).inject(:+)
    end
  end

  describe :questions do
    before do
      @questions = @gotaku.questions
    end

    subject { @questions }

    it 'length should == list.length' do
      subject.length.should == @gotaku.list.length
    end

    context :sample do
      subject { @questions.sample }

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
    end

    subject { Nokogiri::XML @xml }

    it { @xml.should match /^<\?xml/ }
  end
end
