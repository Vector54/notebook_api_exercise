class Contact < ApplicationRecord
  def author
    "Victor de Oliveira"
  end

  def as_json(options={})
    super(methods: :author, root: true, except: [:created_at, :updated_at])
  end
end
