namespace :db do
  desc "Fill database with sample data"
  task sample_data: :environment do
    create_user
    create_tweets
    create_relationships
  end
end

def create_user
  (1..100).each do |n|
    name  = Faker::Name.name
    slug  = name.parameterize
    email = "example-#{n + 1}@agilis.as"
    password = "password"

    User.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password,
      slug: slug
    )
  end
end

def create_tweets
  users = User.all
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.tweets.create!(content: content) }
  end
end

def create_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
