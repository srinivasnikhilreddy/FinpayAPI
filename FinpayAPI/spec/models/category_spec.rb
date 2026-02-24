require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is valid with valid attributes" do
    category = Category.new(name: "Travel")
    expect(category).to be_valid
  end

  it "is invalid without name" do
    category = Category.new(name: nil)
    expect(category).not_to be_valid
  end

  it "enforces uniqueness" do
    Category.create!(name: "Food")
    duplicate = Category.new(name: "Food")
    expect(duplicate).not_to be_valid
  end
end