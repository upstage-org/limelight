require 'rails_helper'

describe BackdropTag do
  describe '#Associations' do
    it { should belong_to :backdrop }
    it { should belong_to :tag }
  end

  describe '#Validations' do
    it { should validate_presence_of(:backdrop) }
    it { should validate_presence_of :tag }

    it 'validates backdrop uniqueness' do
      user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
      b = Backdrop.create(:name => "bg1")
      t = Tag.create(:name => "tag1")
      BackdropTag.create(:backdrop => b, :tag => t)
      should validate_uniqueness_of(:backdrop).scoped_to(:tag_id)
    end

    it 'validates tag uniqueness' do
      user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })  
      b = Backdrop.create(:name => "bg1")
      t = Tag.create(:name => "tag1")
      BackdropTag.create(:backdrop => b, :tag => t)
      should validate_uniqueness_of(:tag).scoped_to(:backdrop_id)
    end

  end
end
