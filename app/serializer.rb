class Serializer

  # added this to keep track of attributes
  @@attrs = {}
  # add this to keep the object for proc objects as their scope is for class level
  @@object = nil

  def self.attribute key, &block
    @@attrs[key] = block
  end

  # written for proc object to call from post_serializer object.date.strftime("%d-%m-%Y")
  def self.object
    @@object
  end

  # initializing the object to class object
  def initialize object
    @@object = object
  end

  # serialize defination for the responses
  def serialize
    response = {}
    @@attrs.each do |k, v|
      # check if attribute belongs to this object
      if callable(k)
        # call the proc if that available for custom format
        if v.is_a?(Proc)
          response[k] = v.call
        else
          # only include the attribute if that has a value routed by comments model
          value = @@object.send(k)
          response[k] = value if value
        end
      end
    end
    response
  end

  def callable(key)
    @@object.methods.include?(key)
  end

end
