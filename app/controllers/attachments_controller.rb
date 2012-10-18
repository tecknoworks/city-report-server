class AttachmentsController < ApplicationController
  def new
    @attachment = Attachment.new
  end

  # this is only for TESTING purposes
  def create
    unless params[:image].blank?
      @issue = Issue.find(params[:issue_id])
      @issue.add_attachment(params[:image], params[:image_name])
      render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issue:@issue})
    end
  end

end
