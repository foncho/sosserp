# encoding: UTF-8

class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.order(:code).page(params[:page]).per(15)
    @var = Product.order(:code)
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data @var.to_csv }
      format.xls { send_data @var }
    end
  end

  def show
  end

  def new
    @product = Product.new
    @product.items.build
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    #@product.description = Description.find_or_create_by_title(product_params[:description_attribute][:title])
    @product.save ? (redirect_to products_path, notice: 'Producto creado satisfactoriamente.') : (render :new)
  end

  def update
    #@product.description = Description.find_or_create_by_title(product_params[:description_attributes][:title])
    @product.update_attributes(product_params) ? redirect_to(products_path, notice: 'Producto actualizado.') : render(action: "edit")
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end
  
  def import
    if not params[:file].nil?
      Product.import(params[:file])
      redirect_to products_path, notice: "Productos importados e insertados en la base de datos de forma correcta."
    else
      redirect_to products_path, alert: "El fichero no existe. Por favor, elige uno."
    end
  end
  
  def get_names
    @products = Product.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: @products.tokens(params[:q]) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      param = params[:product_id] ? params[:product_id] : params[:id]
      @product = Product.find(param)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params[:product]
    end
end
