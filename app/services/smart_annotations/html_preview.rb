# frozen_string_literal: true

module SmartAnnotations
  class HtmlPreview
    class << self
      def html(name, type, object)
        send("generate_#{type}_snippet", name, object)
      end

      private

      ROUTES = Rails.application.routes.url_helpers

      def generate_prj_snippet(_, object)
        if object.archived?
          return "<span class='sa-type'>Prj</span>#{object.name} #{I18n.t('atwho.res.archived')}"
        end
        "<a href='#{ROUTES.project_path(object)}'><span class='sa-type'>Prj</span>#{object.name}</a>"
      end

      def generate_exp_snippet(_, object)
        if object.archived?
          return "<span class='sa-type'>Exp</span>#{object.name} #{I18n.t('atwho.res.archived')}"
        end
        "<a href='#{ROUTES.canvas_experiment_path(object)}'><span class='sa-type'>Exp</span>#{object.name}</a>"
      end

      def generate_tsk_snippet(_, object)
        if object.archived?
          return "<span class='sa-type'>Tsk</span>#{object.name} #{I18n.t('atwho.res.archived')}"
        end
        "<a href='#{ROUTES.protocols_my_module_path(object)}'>" \
        "<span class='sa-type'>Tsk</span>#{object.name}</a>"
      end

      def generate_rep_item_snippet(name, object)
        if object&.repository
          repository_name = fetch_repository_name(object)
          if object.archived?
            return "<span class='sa-type'>#{trim_repository_name(repository_name)}</span> " \
                   "#{object.name} #{I18n.t('atwho.res.archived')}"
          else
            return "<a href='#{ROUTES.repository_repository_row_path(object.repository, object)}' " \
                   "class='record-info-link'><span class='sa-type'>#{trim_repository_name(repository_name)}</span>#{object.name}</a>"
          end
        end
        "<span class='sa-type'>Inv</span> " \
        "#{name} #{I18n.t('atwho.res.deleted')}"
      end

      def trim_repository_name(name)
        splited_name = name.split
        size = splited_name.size
        return name.strip.slice(0..2).capitalize if size == 1
        generate_name_from_array(splited_name, size).capitalize
      end

      def generate_name_from_array(names, size)
        return "#{names[0].slice(0..1)}#{names[1][0]}" if size == 2
        "#{names[0][0]}#{names[1][0]}#{names[2][0]}"
      end

      def fetch_repository_name(object)
        return object.repository.name if object.repository
        repository = Repository.with_discarded.find_by_id(object.repository_id)
        return 'Inv' unless repository
        repository.name
      end
    end
  end
end
