# encoding: UTF-8

namespace :product do
  desc "Initialize product costs"
  task :initial_cost do
    Product.all.each do |product|
      product.costs.new(
        value: product.name.include?("Diacare") ? 19.17 : (product.name.include?("Plus") ?  17.82 : 16.47)
      )
      product.save!(validate: false)
    end
  end
end