require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
   @chef=Chef.create!(chefname: "sushma", email: "sush@gmail.com")
   @recipe=Recipe.create(name:"vegetable soute", description: "great vegetable soute , add vegeatble and oil")
   @recipe2=@chef.recipes.create(name:"Bread rasmalai", description: "A quick bread snack recipe")
   @recipe2.save
  end
  
  test "should get recipes index" do
    get recipes_path
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]" , recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]" , recipe_path(@recipe2), text: @recipe2.name
  end
  
  test "should get recipes show" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
  
  test "to create valid recipes" do 
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "vegetable biryani"
    description_of_recipe = "add rice,add vegetables, cook for 2 min"
    assert_difference 'Recipe.count', 1 do 
      post recipes_path, params: {recipe: {name: name_of_recipe, description: description_of_recipe }}
    end
    follow_redirect! 
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end
  
  test "to create invalid recipes " do 
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: {name: " ", description: " "} } 
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end