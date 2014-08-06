class Datagrid::Renderer

  # Monkey patches DataGrid to render partials based on collection more efficiently.
  def rows(grid, assets, options = {})
    result = @template.render({
      :partial => File.join(options[:partials] || 'datagrid', 'row'),
      :collection => assets,
      :as => :asset,
      :locals => {
        :grid => grid,
        :options => options
      }
    })

    _safe(result)
  end

end
