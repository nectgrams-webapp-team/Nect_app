# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Member.create!(
  name: "テスト管理者",
  email: "admin@ac.jp",
  student_id: "TK22000",
  password: "adminkey",
  member_role: 2
)

5.times do |n|
Member.create(
  name: "テスト太郎#{n+1}", 
  email: "test#{n+1}@ac.jp", 
  student_id: "TK2200#{n+1}", 
  password: "abcde#{n+1}"
)
end
