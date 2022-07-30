namespace :dev do
  desc "Configura ambiente de desenvolvimento"
  task setup: :environment do
    puts 'Cadastrando tipos de contato.'.bg_green
    kinds = %w(Amigo Comercial Conhecido)

    kinds.each do |kd|
      print '.'.green
      Kind.create(
        description: kd
      )
    end
    puts "\nTipos de contatos cadastrados com sucesso.".bg_green

    puts 'Cadastrando contatos.'.bg_green
    100.times do |i|
      print '.'.green
      Contact.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        birthdate: Faker::Date.between(from: 65.years.ago, to: 18.years.ago),
        kind_id: Kind.all.sample.id
      )
    end
    puts "\nContatos cadastrados com sucesso.".bg_green
  end
end