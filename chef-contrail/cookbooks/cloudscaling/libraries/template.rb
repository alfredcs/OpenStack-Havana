#
# This is a backpart of the render-partial feature
# of CHEF 11 to CHEF 10. This should be deleted
# upon upgrade. -- Eric Windisch
#

require 'tempfile'
require 'erubis'

class Chef
  module Mixin
    module Template
      module ChefContext
        def render(partial_name, options = {})
          raise "You cannot render partials in this context" unless @template_finder

          if variables = options.delete(:variables)
            context = {}
            context.merge!(variables)
            context[:node] = @node
            context[:template_finder] = @template_finder
          else
            context = self.dup
          end

          template_location = @template_finder.find(partial_name, options)
          eruby = Erubis::Eruby.new(IO.read(template_location))
          output = eruby.evaluate(context)
        end
      end
    end
  end
end

class Chef
  class Provider

    class TemplateFinder

      def initialize(run_context, cookbook_name, node)
        @run_context = run_context
        @cookbook_name = cookbook_name
        @node = node
      end

      def find(template_name, options = {})
        return template_name if options[:local]

        cookbook_name = options[:cookbook] ? options[:cookbook] : @cookbook_name

        cookbook = @run_context.cookbook_collection[cookbook_name]

        cookbook.preferred_filename_on_disk_location(@node, :templates, template_name)
      end
    end
  end
end

class Chef
  class Provider
    class Template < Chef::Provider::File
      def template_finder
        @template_finder ||= begin
          TemplateFinder.new(run_context, cookbook_name, node)
        end
      end

      def template_location
        template_finder.find(@new_resource.source, :local => @new_resource.local, :cookbook => @new_resource.cookbook)
      end

      def render_with_context(template_location, &block)
        context = {}
        context.merge!(@new_resource.variables)
        context[:node] = node
        context[:template_finder] = template_finder
        render_template(IO.read(template_location), context, &block)
      end
    end
  end
end
