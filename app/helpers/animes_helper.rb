module AnimesHelper

  # def sort_params_for(field, params)
  # 	if params[:sort] == field
  # 		return {sort: field, order: params[:order] == "desc" ? "asc" : "desc"}
  # 	end

  # 	{ sort: field, order: "asc" }
  # end

  # for the paginator the keep the sort and order parameters
  def table_params
    {
      sort: params[:sort],
      order: params[:order],
      order_by_letter: params[:order_by_letter],
      target_audience_id: params[:target_audience_id],
      genre_id: params[:genre_id],
      search: params[:search]
    }
  end

end
