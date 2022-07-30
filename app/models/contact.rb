class Contact < ApplicationRecord
  belongs_to :kind

  def author
    "Victor de Oliveira"
  end

  def translate
    { 
      contact: 
      {
        id: self.id,
        name: self.name,
        email: self.email,
        birthdate: (I18n.l(self.birthdate) unless self.birthdate.blank?),
        kind: self.kind.description,
        author: author,
        language: I18n.default_locale  
      }
    }
  end

  def as_json(options={})
    super(
      root: true,  
      )
  end
end
