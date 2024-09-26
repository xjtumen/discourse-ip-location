import { h } from "virtual-dom";
import { withPluginApi } from "discourse/lib/plugin-api";
import { ajax } from "discourse/lib/ajax";

const PLUGIN_ID = "ip_location";

function initializeIpLocation(api, siteSettings) {
  const ipLocationEnabled = siteSettings.ip_location_enabled;

  if (!ipLocationEnabled) {
    return;
  }
  api.decorateWidget("poster-name:after", helper => {
    let result = "none";
    console.log(helper.attrs);
    if (helper.attrs && helper.attrs.user && helper.attrs.user.ip_location) {
      result = helper.attrs.user.ip_location;
    }

    if (!result || result === "none") {
      return;
    }
    try {
      return helper.h("p", I18n.t("discourse_ip_location.ip_location") + " " + result);
    } catch (e) {
      return helper.h("p", "IP: " + result);
    }
    return helper.h("img", { // display the flag
      className: "nationalflag-post",
      attributes: {
        src: "/plugins/discourse-nationalflags/images/nationalflags/" + result + ".png"
      }
    });
  });

}

export default {
  name: "ip_location",
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    withPluginApi("0.1", api => initializeIpLocation(api, siteSettings));
  }
};
