namespace :dev do
  desc "Configs development enviroment"
  task setup: :environment do
    puts 'Reseting database...'.bg_red

    %x(rails db:reset)

    puts 'Creating kinds of contacts.'.bg_green
    kinds = %w(Friend Commercial Known)

    kinds.each do |kd|
      Kind.create(
        description: kd
      )
      print '.'.green
    end
    puts "\n#{Kind.count} kinds of contacts were created successfully.".bg_green

    puts 'Creating contacts.'.bg_green
    100.times do |i|
      Contact.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        birthdate: Faker::Date.between(from: 65.years.ago, to: 18.years.ago),
        kind_id: Kind.all.sample.id
      )
      print '.'.green
    end
    puts "\n#{Contact.count} contacts were created successfully.".bg_green

    puts 'Creating phones.'.bg_green
    Contact.all.each do |ctt|
      Random.rand(5).times do |i|
        Phone.create!(
          number: Faker::PhoneNumber.cell_phone,
          contact: ctt
        )
        print '.'.green
      end
    end
    puts "\n#{Phone.count} phones were created successfully.".bg_green

    puts 'Creating addresses.'.bg_green
    Contact.all.each do |ctt|
      Address.create!(
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        contact: ctt
      )
      print '.'.green
    end
    puts "\n#{Address.count} addresses were created successfully.".bg_green
  end
end