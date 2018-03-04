class SchemaTools
  class << self

    def set_search_path(tenant_id, include_public = false)
      path_parts = [tenant_id.to_s, ("public" if include_public)].compact
      ActiveRecord::Base.connection.schema_search_path = path_parts.join(",")
    end

    def default_search_path
      @default_search_path ||= %{"$user", public}
    end

    def restore_default_search_path
      ActiveRecord::Base.connection.schema_search_path = default_search_path
    end
    
    def create_schema(tenant_id)
      sql = %{CREATE SCHEMA "#{tenant_id}"}
      ActiveRecord::Base.connection.execute sql
    end
    
    def drop_schema(tenant_id)
      restore_default_search_path
      sql = %{DROP SCHEMA "#{tenant_id}" CASCADE}
      ActiveRecord::Base.connection.execute sql
    end

  end
end
