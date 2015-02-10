class BannedIpsController < ApplicationController
  
  before_action :set_banned_ip, only: [:show, :update, :destroy]
    
  def index
    @banned_ips = BannedIp.all
  end
   
  def show
  end
   
  def create
    @banned_ip = BannedIp.create(params["banned_ip"]) 
  end
  
  def update  
    @banned_ip.update(address: params["banned_ip"]["address"])  
  end
  
  def destroy
    @banned_ip.delete
  end

  protected

  def set_banned_ip
    @banned_ip = BannedIp.find(params[:id])
    if @banned_ip.blank?
      render_response("banned_ip with id #{params[:id]} not found", NOT_FOUND)
    end
  end
  
end
