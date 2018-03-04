db_namespace = namespace :db do
  task :_dump do
    if ActiveRecord::Base.dump_schema_after_migration
      case ActiveRecord::Base.schema_format
      when :ruby
        db_namespace["schema:dump"].invoke
        db_namespace["tenant_schema:dump"].invoke
      when :sql  then db_namespace["structure:dump"].invoke
      else
        raise "unknown schema format #{ActiveRecord::Base.schema_format}"
      end
    end
    # Allow this task to be called as many times as required. An example is the
    # migrate:redo task, which calls other two internally that depend on this one.
    db_namespace["_dump"].reenable
  end

  namespace :tenant_schema do
    desc "Dump tenant schema to db/tenant_schema.rb"
    task dump: [:environment, :load_config] do
      if Rails.env.to_s == "development"
        require "active_record/schema_dumper"
        filename = ENV["TENANT_SCHEMA"] || File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, "tenant_schema.rb")

        conn = ActiveRecord::Base.connection

        File.open(filename, "w:utf-8") do |file|
          tenant = Tenant.first
          if tenant
            conn.schema_search_path = tenant.id.to_s
            ActiveRecord::SchemaDumper.dump(conn, file)
          end
        end
        db_namespace["tenant_schema:dump"].reenable
      end
    end
  end
end
