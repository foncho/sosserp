# encoding: UTF-8

class ClientsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_client, only: [:show, :edit, :update, :destroy]

  def index
    aux = {}
    clients = Client.search(aux).sort_by {"id asc"}
    @clients = Kaminari.paginate_array(clients.sort{ |x, y| x.code[3..-1].to_i <=> y.code[3..-1].to_i }).page(params[:page]).per(30)
    
    client_list = unless params[:term].nil? or params[:term].blank?
      Client.where(["name LIKE ? OR name LIKE ? OR name LIKE ?", "%#{params[:term]}%", "%#{params[:term]}%".upcase, "%#{params[:term]}%".downcase]).sort
    else
      Client.all.sort
    end
    
    var = Client.order(:code)
    list = client_list.map { |l| Hash[ id: l.id, label: "#{l.name} #{l.surname if l.respond_to?(:surname)}", name: l.name ] }
    
    respond_to do |format|
      format.html
      format.js
      format.json { render json: list.to_json }
      format.csv { send_data var.to_csv }
    end
  end

  def show
  end

  def new
    clients = Client.all.sort{ |x, y| x.code[3..-1].to_i <=> y.code[3..-1].to_i }
    @client = Client.new
    @client.code = if clients.last
      aux = ""
      clients.last.code.each_byte { |x| aux << x unless x != 48 }
      aux + (clients.last.code.to_i + 1).to_s
    else
      "0001"
    end
  end
  
  def discount
    client = Client.find(params[:id])
    @discount = Discount.find_by_client_id(client.id).value
  end

  def edit
  end

  def create
    @client = Client.new(client_params)
    #@client.client_type = ClientType.find(client_params[:client_type_id].split(";").first.to_i)
    @client.discount = Discount.new(value: params[:client][:discount_attributes][:value])
    unless Client.where(code: client_params[:code]).empty?
      last_client = Client.all.sort.last
      @client.code = last_client.code + 1
    end
    @client.save ? (redirect_to clients_path, notice: 'Cliente creado correctamente.') : (redirect_to new_client_path, alert: @client.errors.full_messages.join("\n"))
  end

  def update
    unless @client.discount.value == params[:client][:discount_attributes][:value]
      @client.discount.attributes = { value: params[:client][:discount_attributes][:value] }
      @client.discount.save!
    end
    @client.update_attributes(client_params) ? (redirect_to clients_path(type: link), notice: 'Cliente actualizado correctamente.') : (redirect_to edit_client_path(@client), alert: @client.errors.full_messages.join("\n"))
  end

  def destroy
    @client.destroy
    redirect_to clients_path
  end
  
  def import
    if not params[:file].nil?
      Client.import(params[:file])
      redirect_to clients_path, notice: "Client list successfully imported."
    else
      redirect_to clients_path, alert: "No has seleccionado ningún fichero. Por favor, selecciona uno."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params[:client]
    end
    
    def link
      params[:type]
    end
end
