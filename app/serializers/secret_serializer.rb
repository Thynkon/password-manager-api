class SecretSerializer < ActiveModel::Serializer
  attributes :id, :value, :nonce
  # has_one :user

  def nonce
    return "" if object.nonce.nil?

    Base64.encode64(object.nonce)
  end
end
