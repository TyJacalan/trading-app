user = User.find(1)

Transaction.create!(
  symbol: 'AAPL',
  transaction_type: 0,
  price: 150.25,
  amount: 100,
  currency: 'USD',
  user: user
)

Transaction.create!(
  symbol: 'AAPL',
  transaction_type: 0,
  price: 150.25,
  amount: 200,
  currency: 'USD',
  user: user
)

Transaction.create!(
  symbol: 'AAPL',
  transaction_type: 1,
  price: 154.25,
  amount: 50,
  currency: 'USD',
  user: user
)

Transaction.create!(
  symbol: 'GOOGL',
  transaction_type: 1,
  price: 2750.50,
  amount: 50,
  currency: 'USD',
  user: user
)

Transaction.create!(
  symbol: 'MSFT',
  transaction_type: 0,
  price: 300.75,
  amount: 75,
  currency: 'USD',
  user: user
)
