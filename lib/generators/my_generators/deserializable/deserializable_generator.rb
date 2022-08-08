module MyGenerators
  class DeserializableGenerator < Rails::Generators::NamedBase
    def create_helper_file
      create_file "app/deserializable/deserializable_#{file_name}.rb", <<-FILE
class Deserializable#{class_name} < JSONAPI::Deserializable::Resource
  attributes
end
      FILE
    end
  end
end
