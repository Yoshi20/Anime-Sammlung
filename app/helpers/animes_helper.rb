module AnimesHelper

  def sort_params_for(field, params)
  	if params[:sort] == field
  		return {sort: field, order: params[:order] == "desc" ? "asc" : "desc"}
  	end

  	{sort: field, order: "asc"}
  end

  # for the paginator the keep the sort and order parameters
  def table_params
  	{ sort:params[:sort], order:params[:order], order_by_letter:params[:order_by_letter], order_by_genre:params[:order_by_genre] }
  end

end