class SecretSerializer < ActiveModel::Serializer
  attributes :id, :value
  # has_one :user
end
