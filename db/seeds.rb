50.times do
  counter = SecureRandom.hex(4)
  email = "example#{counter}@example.com"

  created_at = Time.zone.local(2024, rand(1..7), rand(1..28), rand(0..23), rand(0..59), rand(0..59))

  User.create!(
    first_name: "Example#",
    last_name: "User",
    email: email,
    password: Devise::Encryptor.digest(User, 'password123'),
    full_name: "Example# User",
    created_at: created_at,
    balance: 0,
    confirmed_at: Time.now.utc
  )
end
