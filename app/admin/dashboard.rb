ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Issues" do
          ul do
            Issue.all.desc(:_id).limit(5).map do |issue|
              li link_to(issue.name, admin_issue_path(issue))
            end
          end
        end
      end

      column do
        panel "Info" do
          Category.all.to_api.each do |cat|
            para "#{cat} #{Issue.where(category: cat).count}"
          end
        end
      end
    end
  end
end
