# frozen_string_literal: true

module Api
  module V1
    class UserProjectsController < BaseController
      before_action :load_team
      before_action :load_project
      before_action :load_user_project, only: :show

      def index
        user_projects = @project.user_projects
                           .page(params.dig(:page, :number))
                           .per(params.dig(:page, :size))

        render jsonapi: user_projects, each_serializer: UserProjectSerializer
      end

      def show
        render jsonapi: @user_project, serializer: UserProjectSerializer
      end

      private

      def load_team
        @team = Team.find(params.require(:team_id))
        render jsonapi: {}, status: :forbidden unless can_read_team?(@team)
      end

      def load_project
        @project = @team.projects.find(params.require(:project_id))
        render jsonapi: {}, status: :forbidden unless can_read_project?(
          @project
        )
      end

      def load_user_project
        @user_project = @project.user_projects.find(params.require(:id))
        render jsonapi: {}, status: :not_found if @user_project.nil?
      end
    end
  end
end
