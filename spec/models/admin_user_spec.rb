require 'spec_helper'

describe AdminUser do
  it { expect(subject).to have_many :category_admin }
end
