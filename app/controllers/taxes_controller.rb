# encoding: UTF-8

class TaxesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_tax, only: [:show, :edit, :update, :destroy]

  def index
    @taxes = Tax.all.sort_by { |t| t.name }
  end

  def show
  end

  def new
    @tax = Tax.new
  end

  def edit
  end

  def create
    @tax = Tax.new(tax_params)
    @tax.save ? redirect_to(taxes_path, alert: 'Impuesto creado con éxito') : render(action: "new")
  end

  def update
    @tax.update_attributes(tax_params) ? redirect_to(taxes_path, alert: 'Impuesto actualizado correctamente.') : render(action: "edit")
  end

  def destroy
    @tax.destroy
    redirect_to taxes_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @tax = Tax.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tax_params
      params[:tax]
    end
end
