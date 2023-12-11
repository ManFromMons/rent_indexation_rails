# frozen_string_literal: true
require "date"

module Api
  module V1
    class IndexationController < ActionController::API
      include IndexationHelper

      def fetch_and_calculate
        form_args = validate_form_data(form_data).symbolize_keys

        unless form_args[:has_error]
          form_args[:current_date] = Date.today if form_data[:current_date].blank?
          form_args[:current_date] = Date.parse(form_data[:current_date]) unless form_data[:current_date].blank?

          indexation_result = calculate form_args

          render json: indexation_result, status: :ok

          return
        end

        form_args.reject! { |k| k == :has_error || form_args[k].empty? }

        render json: form_args, status: :bad_request

      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :bad_request
      rescue StandardError => error
        render json: { error: error }, status: :bad_request
      end

      private

      def validate_form_data(form_params)
        error_collection = { has_error: false, start_date: [], signed_on: [], base_rent: [], region: [] }

        if form_params["start_date"].empty?
          error_collection[:start_date].append("missing")
          error_collection[:has_error] = true
        end
        unless date_is_valid? form_params["start_date"]
          error_collection[:start_date].append("invalid")
          error_collection[:has_error] = true
        end
        if form_params["signed_on"].empty?
          error_collection[:signed_on].append("missing")
          error_collection[:has_error] = true
        end
        unless date_is_valid? form_params["signed_on"]
          error_collection[:signed_on].append "invalid"
          error_collection[:has_error] = true
        end

        if is_number? form_params["base_rent"]
          unless form_params["base_rent"].to_i.positive?
            error_collection[:base_rent].append "must_be_positive"
            error_collection[:has_error] = true
          end
        else
          error_collection[:base_rent].append "invalid"
          error_collection[:has_error] = true
        end

        if form_params["region"].empty?
          error_collection[:region].append "missing"
          error_collection[:has_error] = true
        end
        unless %w[brussels flanders wallonia].include?(form_params["region"].downcase)
          error_collection[:region].append "invalid"
          error_collection[:has_error] = true
        end

        return error_collection if error_collection[:has_error]

        form_args = {
          base_rent: form_params["base_rent"].to_f,
          region: form_params["region"],
          start_date: Date.parse(form_params["start_date"]),
          signed_on: Date.parse(form_params["signed_on"]),
          has_error: error_collection[:has_error]
        }

        unless form_args[:start_date] <= Date.today
          error_collection[:start_date].append "must_be_in_the_past"
          error_collection[:has_error] = true
        end

        unless form_args[:signed_on] <= Date.today
          error_collection[:signed_on].append "must_be_in_the_past"
          error_collection[:has_error] = true
        end

        return error_collection if error_collection[:has_error]

        form_args
      end

      # guards against missing and excess parameters, allowing for the option current_date
      def form_data
        # required_params = %w[start_date signed_on base_rent region]
        # all_params = %w[start_date signed_on current_date base_rent region]
        params.require(:indexation).permit(all_params)
      end
    end
  end
end
