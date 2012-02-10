class Visitor::Base
  class << self
    def visitor_for *klasses, &block
      klasses.each do |klass|
        define_method(:"visit_#{to_class_name(klass)}", block)
      end
    end

    def add_accept_method! *args
      name, options = parse_accept_args(args)
      klasses = Array(options[:to] || Object)
      visitor_klass = self
      klasses.each do |klass|
        klass.send :define_method, name do
          visitor_klass.new.visit(self)
        end
      end
    end

    def to_class_name(duck)
      if duck.respond_to? :name then duck.name else duck end
    end

    def parse_accept_args(args)
      options = if args.last.is_a? Hash then args.pop else {} end
      name = args.first || self.name.gsub(/Visitor$/, '').gsub(/.+([A-Z])/, "_\1").downcase
      return name, options
    end
  end

  def visit thing
    thing.class.ancestors.each do |ancestor|
      method_name = :"visit_#{ancestor.name}"
      next unless respond_to? method_name
      return send method_name, thing
    end

    raise "Can't handle #{thing.class}"
  end
end
