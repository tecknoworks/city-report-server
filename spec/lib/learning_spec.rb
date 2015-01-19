require 'spec_helper'

# making this class should teach you about working with ActiveRecord
class Learning
  
  def self.first
    Issue.first
  end
  
  def self.create_issue(issue_attr)
    issue = Issue.new(issue_attr)
    issue.save
  end
  
  def self.update_issue(id, issue)
    Issue.where(id: id).update(name: issue[:name])
  end
end


describe Learning do
  
  it 'returns the first issue' do
    Issue.delete_all
    issue = create :issue
    create :issue 
    expect(Learning.first.id.to_s).to eq issue.id.to_s
  end

  # for this do not use 'create :issue' or 'build :issue'
  it 'creates an issue' do
    expect {
      issue_attr = FactoryGirl.attributes_for(:issue)
      Learning.create_issue(issue_attr)
    }.to change { Issue.count }.by 1
  end

  it 'updates the name of the issue' do
    new_name = 'new_name'
    issue = create :issue

    Learning.update_issue(issue.id, { name: new_name })
    issue.reload

    expect(issue.name).to eq new_name
  end

end
