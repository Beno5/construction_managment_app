module Api
  class LinksController < ApplicationController
    protect_from_forgery with: :null_session

    def create
      source_id = normalize_id(params[:source_id])
      target_id = normalize_id(params[:target_id])

      link = Link.new(
        source_id: source_id,
        target_id: target_id,
        link_type: params[:link_type]
      )

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

    # Skida prefiks "t_" ili "st_" i vraća integer ID
    def normalize_id(raw_id)
      return nil if raw_id.blank?

      raw_id.to_s.sub(/^t_/, "").sub(/^st_/, "").to_i
    end
  end
end
