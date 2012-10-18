class AttachmentsController < ApplicationController
  def new
    @attachment = Attachment.new
  end

  # this is only for TESTING purposes
  def create
    unless params[:image].blank?
      temp = params[:image]
      File.open(params[:image_file_name],"wb") do |file|
        file.write(ActiveSupport::Base64.decode64(temp))
      end
      puts params[:image]
      f = File.open(params[:image_file_name])
      @issue = Issue.find(params[:issue_id])
      @attachment = Attachment.new
      @attachment.image = f
      @attachment.save
      @issue.attachment = @attachment
      File.delete(params[:image_file_name])
      render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issue:@attachment})
    end
  end
end
