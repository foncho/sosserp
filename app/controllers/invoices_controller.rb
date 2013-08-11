# encoding: UTF-8

class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_invoice, only: [:show, :edit, :update, :destroy, :invoice_to_pdf]
  #caches_action :index

  def index
    @invoices = Kaminari.paginate_array(Invoice.search(create_hash_from_params).sort.reverse).page(params[:page]).per(30)
    @invoices_results ||= select_invoices
  end

  def show
  end
  
  def invoice_to_pdf
    html = render_to_string "invoice_to_pdf", layout: false
    kit = PDFKit.new(html)
    kit.stylesheets << "#{Rails.root}/public/assets/application.css"
    send_data kit.to_pdf,
      filename: "#{@invoice.number}_#{@invoice.client.name.split(" ").map { |w| w.downcase }.join("_")}.pdf",
      type: "application/pdf",
      disposition: "attachment"
  end

  def new
    @invoice = Invoice.new
    @invoice.number = Invoice.any? ? Invoice.last.number + 1 : 1
    @invoice.line_items.build
    2.times do |i|
      @invoice.rates.build
    end
  end

  def edit
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.client = Client.find_by_name(invoice_params[:client_id].strip)
    unless Invoice.where(number: invoice_params[:number]).empty?
      last_invoice = Invoice.all.sort.last
      @invoice.number = last_invoice.number + 1
    end
    @invoice.save ? redirect_to(invoices_path, notice: 'Factura correctamente añadida al sistema.') : redirect_to(new_invoice_path, alert: @invoice.errors.full_messages.join("\n"))
  end

  def update
    @invoice.update_attributes(invoice_params)
    @invoice.client = Client.find_by_name(invoice_params[:client_id].strip)
    @invoice.save ? redirect_to(invoices_path, notice: 'Factura correctamente actualizada.') : redirect_to(invoice_path(@invoice), alert: @invoice.errors.full_messages.join("\n"))
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path
  end
  
  def import
    if not params[:file].nil?
      Invoice.import(params[:file])
      redirect_to invoices_path, alert: "Factura subidas correctamente al sistema."
    else
      redirect_to invoices_path, alert: "No has seleccionado ningún fichero. Por favor, selecciona uno."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find_by_number(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params[:invoice]
    end
    
    def create_hash_from_params
      aux = {}
      aux[:begin_date] = (params[:begin_date].nil? or params[:begin_date].blank?) ? (Invoice.any? ? Invoice.all.sort_by { |i| i.expiration_date }.first.expiration_date : (DateTime.parse "01/01/2012")) : params[:begin_date]
      aux[:end_date] = (params[:end_date].nil? or params[:end_date].blank?) ? (Invoice.any? ? Invoice.all.sort_by { |i| i.expiration_date }.last.expiration_date : (DateTime.parse "31/12/2013")) : params[:end_date] 
      aux[:client_id] = params[:client_id] unless params[:client_id].nil?
      aux[:status] = params[:status] unless params[:status].nil?
      aux[:payment_method_id] = params[:payment_method_id] unless params[:payment_method_id].nil?
      return aux
    end
    
    def select_invoices
      aux = create_hash_from_params
      LineItem.select("li.invoice_id, li.estimate_id, li.product_id, li.quantity")
        .joins("AS li INNER JOIN invoices AS i ON li.invoice_id = i.id")
        .joins("INNER JOIN rates AS r ON r.invoice_id = i.id")
        .joins("INNER JOIN clients AS c ON i.client_id = c.id")
        .where("i.expiration_date BETWEEN ? AND ? AND i.client_id IN (?)", aux[:begin_date], aux[:end_date], ((aux[:client_id].nil? or aux[:client_id].blank?) ? Client.all : aux[:client_id]))
        .group("li.id, li.invoice_id, li.estimate_id, li.product_id, li.quantity, i.created_at")
        .where("li.product_id IN (?)", (aux[:product_id].nil? or aux[:product_id].blank?) ? Product.all : aux[:product_id])
    end
end
