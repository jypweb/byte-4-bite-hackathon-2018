# Create Admin
User.create(name: "Trevor Taylor", email: "trevor@pxp200.com", password: "954953priv", is_admin: true)
p "Created user Trevor Taylor with the standard test password"

# Create Food Options
foods = ["Canned Carrots", "Fresh Steak Meal", "Turkey Dinner", "Canned Sweet Corn", "Jello", "Soup", "Oatmeal", "Canned Tuna", "Peanut Butter", "Bread"]

foods.each do |food|
  FoodOption.create(name: food)
  p "Created Food: #{food}"
end
