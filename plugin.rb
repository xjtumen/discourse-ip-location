# frozen_string_literal: true

# name: discourse-ip-location
# about: show ip location in front
# version: 0.2
# authors: Jiajun Du, xjtumen
# url: https://github.com/xjtumen/discourse-ip-location
# required_version: 2.7.0

enabled_site_setting :ip_location_enabled
DiscoursePluginRegistry.serialized_current_user_fields << "ip_location"

module ::IpLocationPluginModule
  PLUGIN_NAME = "discourse-ip-location"
end


after_initialize do
  # Code which should run after Rails has finished booting
  User.register_custom_field_type('ip_location', :text)
  register_editable_user_custom_field :ip_location if defined? register_editable_user_custom_field

  ip_location_block = Proc.new {
    if object.ip_address == nil
      return I18n.t("discourse_ip_location.unknown")
    end

    if object.ip_address.private?
      return I18n.t("discourse_ip_location.private")
    end
    info = DiscourseIpInfo.get(object.ip_address, locale: "zh_CN")
    if info == {}
      return I18n.t("discourse_ip_location.unknown")
    end

    # if info[:country_code] != "CN"
    #   return info[:country]
    # end

    return info[:location] if info[:location] != nil
    return info[:region] if info[:region] != nil
    return info[:country]
  }

  add_to_serializer(:current_user, :ip_location, &ip_location_block)
  add_to_serializer(:user, :ip_location, &ip_location_block)
  add_to_serializer(:user_card, :ip_location, &ip_location_block)
  # add_to_serializer(:user, :custom_fields, &ip_location_block)
end
