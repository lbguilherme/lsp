module LSP
  module Initializer
    macro included
      {% verbatim do %}
      def self.new(**args)
        instance = self.allocate
        instance.initialize(args)
        instance
      end

      private def initialize(args : NamedTuple)
        {% for ivar in @type.instance_vars %}
          {% default_value = ivar.default_value %}
          {% if ivar.type.nilable? %}
            @{{ivar.id}} = args["{{ivar.id}}"]? {% if ivar.has_default_value? %}|| {{ default_value }}{% end %}
          {% else %}
            {% if ivar.has_default_value? %}
              @{{ivar.id}} = args["{{ivar.id}}"]? || {{ default_value }}
            {% else %}
              @{{ivar.id}} = args["{{ivar.id}}"]
            {% end %}
          {% end %}
        {% end %}
      end
      {% end %}
    end
  end

  # An JSON fiendly string enum.
  macro string_enum(name, *, downcase = true, mappings = nil, &block)
    enum {{ name.id }}
      {{ block.body }}

      def self.new(pull : JSON::PullParser) : self
        string = pull.read_string
        {% if mappings %}
          {% for key, value in mappings %}
            return self.new({{ key }}) if string == {{ value }}
          {% end %}
        {% end %}
        parse?(string) || pull.raise "Unknown enum #{self} value: #{pull.string_value.inspect}"
      end

      def to_json(builder : JSON::Builder)
        builder.string self.to_s{% if downcase %}.downcase{% end %}
      end

      def to_s(io : IO) : Nil
        io << self.to_s
      end

      def to_s : String
        {% if mappings %}
          {% for key, value in mappings %}
            return {{ value }} if self == {{ key }}
          {% end %}
        {% end %}
        super{% if downcase %}.downcase{% end %}
      end
    end
  end
end
