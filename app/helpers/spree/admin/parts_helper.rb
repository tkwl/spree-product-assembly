module Spree
  module Admin
    module PartsHelper
      def variant_including_master_options(variant)
        variant.is_master? ? 'Master' : variant.options_text
      end
    end
  end
end
