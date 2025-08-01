module ScheduledTasksUi
  class ApplicationController < ScheduledTasksUi.parent_controller.constantize
    BULMA_CDN = "https://cdn.jsdelivr.net"

    content_security_policy do |policy|
      policy.style_src_elem(
        BULMA_CDN,
        "'sha256-WHHDQLdkleXnAN5zs0GDXC5ls41CHUaVsJtVpaNx+EM='",
      )
      policy.script_src_elem(
        "'sha256-NiHKryHWudRC2IteTqmY9v1VkaDUA/5jhgXkMTkgo2w='",
      )

      policy.require_trusted_types_for # disable because we use new DOMParser().parseFromString
      policy.frame_ancestors(:self)
      policy.connect_src(:self)
      policy.form_action(:self)
    end

    protect_from_forgery with: :exception
  end
end