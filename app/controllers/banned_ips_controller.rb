# CODE Refactor to use jbuilder
# CODE remove whitespace and blank lines
class BannedIpsController < ApplicationController
  # CODE in IssuesController we have a before_action :set_issue.
  # can we use something similar here?
  # this would solve the duplicate code: banned_ip = BannedIp.find(params[:id])

  # CODE remove this
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
    @banned_ip = BannedIp.find(params[:id])
    @banned_ip.update(address: params["banned_ip"]["address"]) 
    render json: @banned_ip
  end
  
  # TODO find out other ways to delete
  def destroy
    banned_ip = BannedIp.find(params[:id  ])  
    banned_ip.delete
  end

end
