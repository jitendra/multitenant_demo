# frozen_string_literal: true

class Tenant < ApplicationRecord

  validates :name, :slug, presence: true
  validates :name, :slug, uniqueness: true

  after_create :prepare_schema
  before_destroy :drop_schema

  private
  	def prepare_schema
  		create_schema
      load_tables
  	end

    def create_schema
      SchemaTools.create_schema(id)
    end

    def load_tables
      SchemaTools.set_search_path(id)
      load "#{Rails.root}/db/tenant_schema.rb"
      SchemaTools.restore_default_search_path
    end

    def drop_schema
      SchemaTools.drop_schema(id)
    end

end
