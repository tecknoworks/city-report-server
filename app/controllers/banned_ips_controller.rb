class BannedIpsController < ApplicationController
  
  resource_description do
    description <<-EOS
    EOS
  end
  
  before_action :set_banned_ip, only: [:show, :update, :destroy]
    
  api :GET, '/banned_ips.json', 'Return list of banned_ip'
  description <<-EOS
    Example response here[/banned_ips.json]

    Curl example:
    
     curl -X GET -H 'Content-Type: application/json' #{Repara.base_url}banned_ips.json
  EOS
  def index
    @banned_ips = BannedIp.all
  end
   
  api :GET, '/banned_ip/:id.json', 'Return an specific banned_ip'
  description <<-EOS
    Curl example:

     curl -X GET -H 'Content-Type: application/json' #{Repara.base_url}banned_ip/:BANNED_ID.json
  EOS
  def show
  end  
  
  api :POST, '/banned_ip.json', 'Create an banned_ip'
  description <<-EOS
    Curl example:

     curl -X GET -H 'Content-Type: application/json' #{Repara.base_url}banned_ip.json
  EOS
  def create
    @banned_ip = BannedIp.create(params["banned_ip"]) 
  end
  
  api :PATCH, '/banned_ip/:id.json', 'Update an banned_ip'
  description <<-EOS
    Curl example:

     curl -X GET -H 'Content-Type: application/json' #{Repara.base_url}banned_ip/:BANNED_ID.json
  EOS
  def update 
    @banned_ip.update(address: params["banned_ip"]["address"])  
  end
  
  api :DELETE, '/banned_ip/:id.json', 'Delete an banned_ip'
  description <<-EOS
    Curl example:

     curl -X GET -H 'Content-Type: application/json' #{Repara.base_url}bannned_ip/:BANNED_ID.json
  EOS
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
