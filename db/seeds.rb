# Create admin user
admin = User.create!(
  first_name:"Admin",
  last_name: "User",
  email: "admin@example.com",
  password: "password123!",
  role: "admin",
  confirmed_at: Time.now.utc,
  approved: 1
)
admin.skip_confirmation!
admin.save!

# Create sample users
50.times do |i|
  user = User.new(
    first_name: "Example#{i}",
    last_name: "User",
    email: "example#{i}@example.com",
    password: "password123!",
    created_at: rand(Date.new(2024, 1, 1)..Date.new(2024,7,31)),
    approved: 1
  )
  user.skip_confirmation!
  user.save
end

# Create sample transactions
100.times do
  user = User.offset(rand(User.count)).first
  stock_symbols = %w[AAPL MSFT GOOG]
  transaction = Transaction.create!(
    symbol: stock_symbols.sample,
    transaction_type: rand(2),
    price: rand(1.0..100.0).round(2),
    quantity: rand(1..10),
    currency: 'USD',
    user_id: user.id,
    created_at: rand(Date.new(2024, 1, 1)..Date.new(2024,7,31))
  )
end
