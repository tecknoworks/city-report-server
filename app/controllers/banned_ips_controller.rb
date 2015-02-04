# CODE Refactor to use jbuilder
# CODE remove whitespace and blank lines
class BannedIpsController < ApplicationController
  # CODE in IssuesController we have a before_action :set_issue.
  # can we use something similar here?
  # this would solve the duplicate code: banned_ip = BannedIp.find(params[:id])

  def index
    @banned_ips = BannedIp.all
  end
   
  def show
    @banned_ip = find_by_id(params[:id])[:id] 
  end
   
  def create
    @address = params["banned_ip"]["address"]
    BannedIp.create(params["banned_ip"]) 
  end
  
  def update
    banned_ip = find_by_id(params[:id])
    banned_ip.update(address: params["banned_ip"]["address"]) 
    @address = banned_ip['address']
  end
  
  def destroy
    banned_ip = BannedIp.find(params[:id])
    @id = banned_ip['id'] 
    banned_ip.delete
  end

  protected
  
  def find_by_id id
    BannedIp.find(id)
  end
  
end
