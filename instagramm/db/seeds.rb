Pic.destroy_all
num = 0

10.times do |pic|
  temp = Pic.create!(
    title: Faker::Hipster.sentence, 
    description: Faker::Hipster.paragraph(20), 
    user_id: rand(1..2)
  )
  num = pic.to_s
  temp.featured_image.attach(
    io: File.open('/Users/mac/Documents/Sites/allRailsTuts/udemy-rails-8apps/instagramm/app/assets/images/image'+num+'.png'),
    filename: 'image'+num+'.png'
  )
end
puts '10 pics have been created'