FactoryGirl.define do
  factory :backdrop do
    name "bg"
    source File.new(Rails.root + 'spec/factories/images/rails.png')
  end
end
