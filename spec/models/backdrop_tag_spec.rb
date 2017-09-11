require 'rails_helper'

describe BackdropTag do
  describe '#Associations' do
    it { should belong_to :backdrop }
    it { should belong_to :tag }
  end

  describe '#Validations' do
    it { should validate_presence_of(:backdrop) }
    it { should validate_presence_of :tag }

    it { should validate_uniqueness_of(:backdrop).scoped_to(:tag) }
    it { should validate_uniqueness_of(:tag).scoped_to(:backdrop) }
  end
end
