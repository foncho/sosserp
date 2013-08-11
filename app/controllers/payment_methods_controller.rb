# encoding: UTF-8

class PaymentMethodsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_payment_method, only: [:show, :edit, :update, :destroy]

  def index
    @payment_methods = PaymentMethod.all.sort
  end

  def show
  end

  def new
    @payment_method = PaymentMethod.new
  end

  def edit
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    @payment_method.save ? redirect_to(@payment_method, notice: 'Nuevo método de pago creado.') : render(action: "new")
  end

  def update
    @payment_method.update_attributes(payment_method_params) ? redirect_to(@payment_method, notice: 'Método de pago actualizado.') : render(action: "edit")
  end

  def destroy
    @payment_method.destroy
    redirect_to payment_methods_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_method
      @payment_method = PaymentMethod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_method_params
      params[:payment_method]
    end
end
