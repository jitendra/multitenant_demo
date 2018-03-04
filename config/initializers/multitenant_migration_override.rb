module ActiveRecord  
  class Migration
    ## Original Definition
    # def method_missing(method, *arguments, &block)
    #   arg_list = arguments.map(&:inspect) * ", "

    #   say_with_time "#{method}(#{arg_list})" do
    #     unless connection.respond_to? :revert
    #       unless arguments.empty? || [:execute, :enable_extension, :disable_extension].include?(method)
    #         arguments[0] = proper_table_name(arguments.first, table_name_options)
    #         if [:rename_table, :add_foreign_key].include?(method) ||
    #           (method == :remove_foreign_key && !arguments.second.is_a?(Hash))
    #           arguments[1] = proper_table_name(arguments.second, table_name_options)
    #         end
    #       end
    #     end
    #     return super unless connection.respond_to?(method)
    #     connection.send(method, *arguments, &block)
    #   end
    # end

    def method_missing(method, *arguments, &block)
      arg_list = arguments.map(&:inspect) * ", "

      say_with_time "#{method}(#{arg_list})" do
        unless connection.respond_to? :revert
          unless arguments.empty? || [:execute, :enable_extension, :disable_extension].include?(method)
            arguments[0] = proper_table_name(arguments.first, table_name_options)
            if [:rename_table, :add_foreign_key].include?(method) ||
              (method == :remove_foreign_key && !arguments.second.is_a?(Hash))
              arguments[1] = proper_table_name(arguments.second, table_name_options)
            end
          end
        end

        return super unless connection.respond_to?(method)

        if self.class.superclass.to_s == "TenantMigration"
          result = nil
          Tenant.all.each do |tenant|
            connection.schema_search_path = tenant.id.to_s
            result = connection.send(method, *arguments, &block)
          end
          connection.schema_search_path = "\"$user\",public"
          result
        else
          connection.send(method, *arguments, &block)
        end
      end
    end
  end
end
