class JournalEntriesController < ApplicationController
  def index
    year = params[:year].to_i
    month = params[:month].to_i

    orders = Order.where("EXTRACT(YEAR FROM ordered_at) = ? AND EXTRACT(MONTH FROM ordered_at) = ?", year, month)

    total_sales = orders.sum { |o| o.price_per_item * o.quantity }
    total_shipping = orders.sum(&:shipping)
    total_taxes = orders.sum { |o| (o.price_per_item * o.quantity) * o.tax_rate }
    total_payments = Payment.where(order: orders).sum(&:payment_amount)

    # While this data could possibly be stored in DB for performance matters I decided to make it simpler here
    journal_entry = [
      { account: "Accounts Receivable", debit: total_sales, credit: nil, description: "Cash expected for orders" },
      { account: "Revenue", debit: nil, credit: total_sales, description: "Revenue for orders" },
      { account: "Accounts Receivable", debit: total_shipping, credit: nil, description: "Cash expected for shipping on orders" },
      { account: "Shipping Revenue", debit: nil, credit: total_shipping, description: "Revenue for shipping" },
      { account: "Accounts Receivable", debit: total_taxes, credit: nil, description: "Cash expected for taxes" },
      { account: "Sales Tax Payable", debit: nil, credit: total_taxes, description: "Cash to be paid for sales tax" },
      { account: "Cash", debit: total_payments, credit: nil, description: "Cash received" },
      { account: "Accounts Receivable", debit: nil, credit: total_payments, description: "Removal of expectation of cash" }
    ]

    render json: { journal_entry: journal_entry, total_debit: total_sales + total_shipping + total_taxes + total_payments, total_credit: total_sales + total_shipping + total_taxes + total_payments }
  end

end