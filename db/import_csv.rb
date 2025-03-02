require 'csv'

# Define a method to import the CSV
def import_csv(file_path)
  # Open the CSV file and iterate through each row
  CSV.foreach(file_path, headers: true) do |row|
    # Extract necessary data from each row
    ordered_at = Date.parse(row['ordered_at'])
    price_per_item = row['price_per_item'].to_f
    quantity = row['quantity'].to_i
    shipping = row['shipping'].to_f
    tax_rate = row['tax_rate'].to_f
    payment_1_amount = row['payment_1_amount'].to_f
    payment_2_amount = row['payment_2_amount'].to_f

    # Create the order record
    order = Order.create!(
      ordered_at: ordered_at,
      price_per_item: price_per_item,
      quantity: quantity,
      shipping: shipping,
      tax_rate: tax_rate
    )

    # If there are payments associated with the order, insert them into the Payments table
    # If the CSV has multiple rows per order (e.g., multiple payments per order), iterate through them.
    if payment_1_amount > 0
      Payment.create!(
        order_id: order.id,
        paid_at: ordered_at, # Assuming payment_date is same as ordered_at in the CSV, modify as needed
        payment_amount: payment_1_amount
      )
    end

    if payment_2_amount > 0
      Payment.create!(
        order_id: order.id,
        paid_at: ordered_at, # Assuming payment_date is same as ordered_at in the CSV, modify as needed
        payment_amount: payment_2_amount
      )
    end
  end

  puts "CSV import completed successfully."
end

# Call the import method with the path to your CSV file
import_csv('db/data.csv')
