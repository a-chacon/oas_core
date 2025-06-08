# frozen_string_literal: true

module OasCore
  class OasRoute
    # TODO: Check what variables are in use and remove the ones that are not.
    attr_accessor :controller_class, :controller_action, :controller, :controller_path, :method_name, :verb, :path,
                  :docstring, :source_string
    attr_writer :tags

    def initialize(attributes = {})
      attributes.each { |key, value| send("#{key}=", value) }
    end

    def path_params
      @path.to_s.scan(/\{(\w+)\}/).flatten
    end

    def tags(name = nil)
      return @tags if name.nil?

      @tags.select { |tag| tag.tag_name.to_s == name.to_s }
    end
  end
end
