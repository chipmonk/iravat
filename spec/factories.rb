# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "tanu"
  user.email                 "tanu@bilnq.in"
  user.password              "dnwmb9ho"
  user.password_confirmation "dnwmb9ho"
end

