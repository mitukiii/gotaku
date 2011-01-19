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
end
