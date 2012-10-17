class AttachmentsController < ApplicationController
  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.create(params[:attachment])
  end
end
