module Kaminari
  module Helpers
    class Tag
      def page_url_for(page)
        params = params_for(page)
        params[:only_path] = true
        @template.refinery.url_for params
      end
    end
  end
end
