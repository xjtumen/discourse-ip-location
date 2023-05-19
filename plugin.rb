# frozen_string_literal: true

# name: discourse-ip-location
# about: show ip location in front
# version: 0.0.1
# authors: Jiajun Du
# url: https://github.com/ShuiyuanSJTU/discourse-ip-location
# required_version: 2.7.0

enabled_site_setting :plugin_ip_location_enabled

module ::IpLocationPluginModule
  PLUGIN_NAME = "discourse-ip-location"
end


after_initialize do
  # Code which should run after Rails has finished booting
  add_to_serializer(:user, :ip_location) do
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

    if info[:country_code] != "CN"
      return info[:country]
    end

    return info[:region] if info[:region] != nil
    
    return info[:country]
  end
end
