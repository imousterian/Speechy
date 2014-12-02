require 'rails_helper'

RSpec.describe Tagging, :type => :model do

    let(:tagging){FactoryGirl.create(:tagging)}
    subject{tagging}
    it{should belong_to :tag}
    it{should belong_to :content}
end
