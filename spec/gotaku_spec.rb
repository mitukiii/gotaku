require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe :Gotaku do
  describe :parse do
    context 'with file path' do
      subject { Gotaku.parse GOTAKU_FILE }
      it { should be_is_a Gotaku }
    end

    context 'with file' do
      subject { Gotaku.parse open(GOTAKU_FILE) }
      it { should be_is_a Gotaku }
    end
  end
end
