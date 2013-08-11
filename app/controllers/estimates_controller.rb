# encoding: UTF-8

class EstimatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_estimate, only: [:show, :edit, :update, :destroy, :invoice_converter, :estimate_to_pdf]

  def index
    @estimates = Kaminari.paginate_array(Estimate.search(create_hash_from_params).sort.reverse).page(params[:page]).per(30)
  end

  def show
  end
  
  def estimate_to_pdf
    html = render_to_string "estimate_to_pdf", layout: false
    kit = PDFKit.new(html)
    kit.stylesheets << "#{Rails.root}/public/assets/application.css"
    send_data kit.to_pdf,
      filename: "#{@estimate.id}_#{@estimate.client.name.split(" ").map { |w| w.downcase }.join("_")}.pdf",
      type: "application/pdf",
      disposition: "attachment"
  end

  def new
    estimates = Estimate.all.sort { |x, y| x.id <=> y.id }
    @estimate = Estimate.new
    @estimate.number = unless estimates.empty?
      estimates.last.number.to_i + 1
    else
      1
    end
    @estimate.build_project
    @estimate.line_items.build
  end

  def edit
  end

  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.client = Client.find_by_name(estimate_params[:client_id].strip)
    @estimate.user = User.find_by_name_and_surname(estimate_params[:client_id].split(" ").first, estimate_params[:client_id].split(" ")[1..-1].join(" "))
    unless Estimate.where(number: estimate_params[:number]).empty?
      last_estimate = Estimate.all.sort.last
      @estimate.number = last_estimate.number + 1
    end
    @estimate.create_project(estimate_params[:project])
    @estimate.save ? redirect_to(@estimate, notice: 'Albarán creado satisfactoriamente.') : redirect_to(new_estimate_path, alert: @estimate.errors.full_messages.join("\n"))
  end

  def update
    @estimate.update_attributes(estimate_params)
    @estimate.client = Client.find_by_name(estimate_params[:client_id])
    @estimate.user = User.find_by_name_and_surname(estimate_params[:client_id].split(" ").first, estimate_params[:client_id].split(" ")[1..-1].join(" "))
    estimate_params[:project][:description] = estimate_params[:project][:description].html_safe
    project = if not @estimate.project.nil? and @estimate.project
      @estimate.project.update_attributes(estimate_params[:project])
    else
      @estimate.create_project(estimate_params[:project])
    end
    @estimate.save ? redirect_to(@estimate, notice: 'Albarán actualizado correctamente.') : redirect_to(edit_estimate_path(@estimate), alert: @estimate.errors.full_messages.join("\n"))
  end

  def destroy
    @estimate.destroy
    redirect_to estimates_path, notice: "Albarán eliminado correctamente."
  end
  
  def import
    if not params[:file].nil?
      Estimate.import(params[:file])
      redirect_to estimates_path, alert: "Albaranes subidos correctamente al sistema."
    else
      redirect_to estimates_path, alert: "No has seleccionado ningún fichero. Por favor, selecciona uno."
    end
  end

=begin  
  def invoice_converter
    @invoice = Invoice.find_or_initialize_by_id_and_client_id_and_created_at(
      (Invoice.any? ? (Invoice.last.id + 1) : 1),
      @estimate.client_id,
      @estimate.created_at
    )
    
    if @invoice.valid?
      @invoice.rates.find_or_initialize_by_tax_id(@estimate.tax_id)
      @invoice.save
      @estimate.line_items.map do |line|
        line.attributes = { invoice_id: @invoice.id }
        line.save
      end
      redirect_to invoice_path(@invoice), notice: "Factura creada satisfactoriamente. Puedes verla #{view_context.link_to 'aquí', invoice_path(@invoice)}"
    else
      redirect_to estimate_path(@estimate), alert: "La creación de la factura ha fallado."
    end
  end
=end

  private
    def set_estimate
      @estimate = Estimate.find_by_number(params[:id])
    end

    def estimate_params
      params[:estimate]
    end
    
    def create_hash_from_params
      aux = {}
      aux[:year] = params[:year] unless params[:year].nil?
      aux[:client_id] = params[:client_id] unless params[:client_id].nil?
      return aux
    end
end
