# frozen_string_literal: true

class MyModuleShareableLinksController < ApplicationController
  before_action :load_my_module
  before_action :load_shareable_link, only: %i(update destroy)
  before_action :check_view_permissions, only: :show
  before_action :check_manage_permissions, except: :show

  def show
    render json: @my_module.shareable_link
  end

  def create
    @my_module.shareable_link.create!(
      signed_id: @my_module.signed_id,
      description: params[:description],
      team: @my_module.team,
      created_by: current_user
    )

    log_activity(:task_link_sharing_enabled, @my_module, current_user)

    render json: @my_module.shareable_link
  end

  def update
    @my_module.shareable_link.update!(
      description: params[:description],
      last_modified_by: current_user
    )

    log_activity(:shared_task_message_edited, @my_module, current_user)

    render json: @my_module.shareable_link
  end

  def destroy
    @my_module.shareable_link.destroy!

    log_activity(:task_link_sharing_disabled, @my_module, current_user)

    render json: {}
  end

  private

  def load_my_module
    @my_module = MyModule.find_by(id: params[:my_module_id])
    render_404 unless @my_module
  end

  def check_view_permissions
    render_403 unless can_view_my_module?(@my_module)
  end

  def check_manage_permissions
    render_403 unless can_manage_my_module?(@my_module)
  end

  def log_activity(type_of, my_module, user)
    Activities::CreateActivityService
      .call(activity_type: type_of,
            owner: user,
            team: my_module.team,
            project: my_module.project,
            subject: my_module,
            message_items: {
              my_module: my_module.id,
              user: user.id
            })
  end
end
