class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_unauthorized_response  
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response  

    def show
            user = User.find_by!(id: session[:user_id])
            recipes = user.recipes.where(user_id: session[:user_id])
            render json: recipes, include: :user
    end

    def create
            user = User.find_by!(id: session[:user_id])
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, include: :user, status: :created
    end

private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def render_unauthorized_response(not_found)
        render json: { errors: [not_found] }, status: :unauthorized
        # byebug
    end

    def render_unprocessable_entity_response(invalid)
        # byebug
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
