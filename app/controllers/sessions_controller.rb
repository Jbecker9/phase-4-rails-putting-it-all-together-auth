class SessionsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_unauthorized_response

    def create
        user = User.find_by!(username: params[:username])
        if user.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
          else
            render json: { errors: "Password invalid." }, status: :unauthorized
          end
    end

    def destroy
        if session[:user_id]
            session.delete :user_id
            head :no_content
        else
            render json: { errors: ["User not logged in."] }, status: :unauthorized
        end
    end

private

    def render_unauthorized_response(not_found)
        render json: { errors: [not_found] }, status: :unauthorized
    end

end
