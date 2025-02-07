module Api
  class LinksController < ApplicationController
    protect_from_forgery with: :null_session

    def create
      link = Link.new(link_params)

      if link.save
        render json: { action: "inserted", tid: link.id }
      else
        render json: { action: "error", errors: link.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      link = Link.find_by(id: params[:id])

      if link&.destroy
        render json: { action: "deleted" }
      else
        render json: { action: "error", errors: ["Link not found"] }, status: :not_found
      end
    end

    private

    def link_params
      params.permit(:source_id, :target_id, :link_type)
    end
  end
end
