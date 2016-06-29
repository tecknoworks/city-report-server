require 'spec_helper'

describe Category do
  it { expect(subject).to have_many :category_admin }
  it { expect(subject).to validate_presence_of :name }
end
