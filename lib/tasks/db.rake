File.expand_path("#{Rails.root}/config/application",  __FILE__)
require File.expand_path("#{Rails.root}/config/boot",  __FILE__)
require File.expand_path("#{Rails.root}/config/environment", __FILE__)

namespace :db do
  desc "Import data from CSV file to database"
  task :import_client_types do
    file = File.new ARGV.last, "r"
    spreadsheet = case File.extname(file)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file}"
    end
    
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row.to_hash.each do |key, value|
        ClientType.create name: value
      end
    end
    puts "File imported successfully"
  end
  
  desc "Import zones data from CSV file to database"
  task :import_zones do
    file = File.new ARGV.last, "r"
    spreadsheet = case File.extname(file)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file}"
    end
    
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row.to_hash.each do |key, value|
        Zone.create name: value
      end
    end
    puts "File imported successfully"
  end
  
  desc "Import zones data from CSV file to database"
  task :import_delegates do
    file = File.new "#{Rails.root}/tmp/csvs/delegates.csv", "r"
    spreadsheet = case File.extname(file)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file}"
    end
  
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      puts "#{row}"
      debugger
      user = User.new(
        name: row["name"],
        surname: row["surname"],
        username: row["username"],
        role: row["role"],
        zone_id: row["zone_id"],
        observations: row["observations"],
        address: row["address"],
        phone: row["phone"],
        email: row["email"],
        password: row["password"],
        password_confirmation: row["password_confirmation"]
      )
      puts "#{user.to_json}"
      debugger
      user.save!
    end
    
    puts "Delegates information imported successfully"
  end
    
  desc "Bulk import of delivery notes"
  task :import_delivery_notes do
    root = "/Users/fon/Dropbox/ALBARANES\ GCN/ALBARANES/"
    entries = Dir.entries("/Users/fon/Dropbox/ALBARANES\ GCN/ALBARANES/")
    
    entries[3..-1].each do |entry|
      Dir.glob(root + entry + "/**/*.xls*").each do |file|
        puts file
        DeliveryNote.import file
      end
    end
  end
  
  desc "Bulk import of invoices"
  task :import_invoices do
    root = "/Users/fon/Dropbox/ALBARANES\ GCN/FACTURAS\ EMITIDAS/"
    entries = Dir.entries("/Users/fon/Dropbox/ALBARANES\ GCN/FACTURAS\ EMITIDAS/")
    entries[4..-1].each do |entry|
      Dir.glob(root + entry + "/**/*.xls*").each do |file|
        puts file
        Invoice.import file
      end
    end
  end
  
  desc "Create default description for products"
  task :default_description do
    description = Description.create
    puts "#{descritpion.title} added to database by default."
  end
end