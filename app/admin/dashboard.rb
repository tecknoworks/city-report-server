ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  controller do
    def index
      @issues = Issue.all
    end
  end

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel 'Category' do
          render 'pie_chart_categories'
        end
      end

      column do
        panel 'Status' do
          render 'pie_chart_statuses'
        end
      end
    end
  end
end
