# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

roles = Role.create([
  {name: 'admin'},
  {name: 'user'}
]) if Role.count == 0

admin_role = Role.where(name: 'admin')

admin_user = User.new(login:  "admin",
             email: "noone@nowhere.com",
             password:              "changeme",
             password_confirmation: "changeme")

admin_user.roles << admin_role

admin_user.save


Page.create(name: "home", content: "fill me")

samples = FactoryGirl.create_list(:sample,10)
