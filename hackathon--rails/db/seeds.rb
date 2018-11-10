# Create Admin
User.create(name: "Trevor Taylor", email: "trevor@pxp200.com", password: "954953priv", is_admin: true)
p "Created admin trevor@pxp200.com with the standard test password"

User.create(name: "Trevor Taylor", email: "jypemail@gmail.com", password: "954953priv")
p "Created user jypemail@gmail.com with the standard test password"

# Create Food Options
foods = ["Carrots", "Steak", "Turkey", "Corn", "Jello", "Soup", "Oatmeal", "Tuna", "Peanut Butter", "Bread"]

foods.each do |food|
  FoodOption.create(name: food)
  p "Created Food: #{food}"
end
