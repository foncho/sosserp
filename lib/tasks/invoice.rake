namespace :invoice do
  desc "Create payment methods for invoice payment"
  task :create_payment_methods do
    ["Transferencia bancaria", "Ingreso en efectivo"].each do |name|
      PaymentMethod.create(name: name)
    end
  end
end