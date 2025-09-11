defmodule BackendWeb.View do
  use Phoenix.View,
    root: "lib/backend_web/templates",
    namespace: BackendWeb

  # A central place to import helpers into all template-based views
  defmacro __using__(_opts) do
    quote do
      import Phoenix.Controller,
        only: [get_flash: 2, view_module: 1]

      import Phoenix.View
      alias BackendWeb.Router.Helpers, as: Routes
    end
  end
end
