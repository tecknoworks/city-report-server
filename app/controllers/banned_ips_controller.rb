class BannedIpsController < ApplicationController
  require 'json'

  def index
    @banned_ips
  end
  
  def show
    banned_ip = BannedIp.find(params[:id])
    render json: {id: banned_ip[:id]} 
  end
  
  def create
    address = params["banned_ip"]["address"]
    BannedIp.create(params["banned_ip"]) 
  end
  
  def update
    print params
    @banned_ip = BannedIp.find(params[:id])
    @banned_ip.update(address: params["banned_ip"]["address"]) 
    render json: @banned_ip
  end
  
  def destroy
    banned_ip = BannedIp.find(params[:id  ])  
    banned_ip.delete
  end

end