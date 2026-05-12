# lib/real_estate_web/components/pagination.ex
defmodule RealEstateWeb.Components.Pagination do
  use Phoenix.Component

  def pagination(assigns) do
    ~H"""
    <div :if={@total_pages > 1} class="flex items-center justify-center gap-2 mt-8">
      <%!-- Previous --%>
      <%= if @page_number > 1 do %>
        <.link
          href={"#{@path}?#{build_params(@params, @page_number - 1)}"}
          class="px-3 py-2 text-sm border rounded hover:bg-gray-100"
        >
          ← Prev
        </.link>
      <% else %>
        <span class="px-3 py-2 text-sm border rounded text-gray-300 cursor-not-allowed">← Prev</span>
      <% end %>
       <%!-- Page numbers --%>
      <%= for page <- page_range(@page_number, @total_pages) do %>
        <%= if page == @page_number do %>
          <span class="px-3 py-2 text-sm border rounded bg-blue-600 text-white">{page}</span>
        <% else %>
          <.link
            href={"#{@path}?#{build_params(@params, page)}"}
            class="px-3 py-2 text-sm border rounded hover:bg-gray-100"
          >
            {page}
          </.link>
        <% end %>
      <% end %>
       <%!-- Next --%>
      <%= if @page_number < @total_pages do %>
        <.link
          href={"#{@path}?#{build_params(@params, @page_number + 1)}"}
          class="px-3 py-2 text-sm border rounded hover:bg-gray-100"
        >
          Next →
        </.link>
      <% else %>
        <span class="px-3 py-2 text-sm border rounded text-gray-300 cursor-not-allowed">Next →</span>
      <% end %>
    </div>
    """
  end

  defp page_range(current, total) do
    start_page = max(1, current - 2)
    end_page = min(total, current + 2)
    Enum.to_list(start_page..end_page)
  end

  defp build_params(params, page) do
    params
    |> Enum.into(%{})
    |> Map.put("page", page)
    |> URI.encode_query()
  end
end
