graph_main_analysis <- function(g){

  #C Number of vertices (order)
  print('Finding graph order')
  g_order <- vcount(g)

  #C Number of edges (size)
  print('Finding graph size')
  g_size <- ecount(g)

  #C Degrees (List, Min, Max)
  print('Finding degree statistics')
  g_deg <- degree(g, mode = 'all')
  g_deg_max <- max(g_deg)
  g_deg_min <- min(g_deg)
  g_in_deg <- degree(g, mode = 'in')
  g_in_deg_max <- max(g_in_deg)
  g_in_deg_min <- min(g_in_deg)
  g_out_deg <- degree(g, mode = 'out')
  g_out_deg_max <- max(g_out_deg)
  g_out_deg_min <- min(g_out_deg)

  #C Connectivity
  print('Finding connectivity statistics')
  g_no_comp_weak <- components(g, mode = 'weak')$no
  g_no_comp_strong <- components(g, mode = 'strong')$no
  g_con <- if (g_no_comp_strong==1) {
    'strong'
  } else if (g_no_comp_weak==1) {
    'weak'
  } else {
    'not'
  }
  g_vconn <- vertex_connectivity(g)
  #g_vconn_underlying <- vertex_connectivity(as.undirected(g, 'mutual'))
  g_econn <- edge_connectivity(g)
  #g_econn_underlying <- edge_connectivity(as.undirected(g, 'mutual'))

  #C Distances
  print('Finding distance statistics')
  if (g_con == 'strong') {
    g_diam <- diameter(g, directed = TRUE, unconnected = FALSE)
    #g_diam_underlying <- diameter(g, directed = FALSE, unconnected = FALSE)
    g_apl <- mean_distance(g, directed = TRUE, unconnected = FALSE)
    #g_apl_underlying <- mean_distance(g, directed = FALSE, unconnected = FALSE)
  } else {
    g_diam <- diameter(g, directed = TRUE, unconnected = TRUE)
    #g_diam_underlying <- diameter(g, directed = FALSE, unconnected = TRUE)
    g_apl <- mean_distance(g, directed = TRUE, unconnected = TRUE)
    #g_apl_underlying <- mean_distance(g, directed = FALSE, unconnected = TRUE)
  }

  #C Transitivity
  print('Finding transitivity')
  g_trans <- transitivity(g)

  #C Highest centrality node's label

  #C Degree centrality
  print('Finding degree centrality')
  g_deg_c <- g_deg_max
  #g_deg_c_n <- max(g_deg/g_deg_max)
  g_deg_c_label <- V(g)$label[g_deg==g_deg_c]

  #C In-Degree Centrality
  #g_deg_c_in <- max(degree(g, mode = 'in'))
  #g_deg_c_in_n <- max(g_deg/g_deg_max)
  #g_deg_c_in_label <- V(g)$label[degree(g, mode = 'in')==g_deg_c_in]

  #C Eigenvector centrality
  print('Finding eigenvector centrality')
  g_eigen_c <- eigen_centrality(g, directed = TRUE)$vector
  #g_eigen_c_n <- g_eigen_c/max(g_eigen_c)
  g_eigen_c_label <- V(g)$label[g_eigen_c==max(g_eigen_c)]

  #C Underlying Eigenvector centrality
  #g_eigen_c_underlying <- eigen_centrality(g, directed = FALSE)$vector
  #g_eigen_c_underlying_label <- V(g)$label[g_eigen_c_underlying==max(g_eigen_c_underlying)]

  #C Closeness centrality (harmonic if disconnected)
  #print('Finding closeness centrality')
  #g_close_c <- closeness(g, mode = 'all')
  #g_cen_close_n <- closeness(g, mode = 'all', normalized = TRUE)
  #if (g_con!='not') {
  #g_close_c <- closeness(g, mode = 'all')
  #g_cen_close_n <- closeness(g, mode = 'all', normalized = TRUE)
  #} else {
  #g_close_c <- harmonic_centrality(g, mode = 'all')
  #g_cen_close_n <- harmonic_centrality(g, mode = 'all', normalized = TRUE)
  #}
  #g_close_c_label <- V(g)$label[g_close_c==max(g_close_c)]


  #C In-Closeness centrality
  #g_close_c_in <- closeness(g, mode = 'in')
  #g_close_c_in_n <- closeness(g, mode = 'in', normalized = TRUE)
  #g_close_c_in_label <- V(g)$label[g_close_c_in==max(g_close_c_in)]

  #C Betweenness centrality
  #print('Finding betweenness centrality')
  #g_between_c <- betweenness(g, directed = TRUE)
  #g_between_c_label <- V(g)$label[g_between_c==max(g_between_c)]

  #C Underlying betweenness centrality
  #g_between_c_underlying <- betweenness(g, directed = FALSE)
  #g_between_c_underlying_label <- V(g)$label[g_between_underlying_c==max(g_between_c_underlying)]

  #C Katz centrality
  #print('Finding Katz centrality')
  #if (g_con != 'strong') {
  #  b = 1
  #} else {
  #  b = 1
  #}
  #g_katz_c <- alpha_centrality(g, alpha = 0.5, exo=b)
  #g_katz_c_n <- g_katz_c/max(g_katz_c)
  #g_katz_c_label <- V(g)$label[g_katz_c==max(g_katz_c)]

  #C PageRank centrality
  #print('Finding PageRank centrality')
  #g_page_c <- page_rank(g, algo = 'prpack', directed = TRUE)$vector
  #g_page_c_n <- g_cen_pagevector/max(g_cen_pagevector)
  #g_page_c_label <- V(g)$label[g_page_c==max(g_page_c)]

  #C Underlying PageRank centrality

  #C Return
  res <- list(
    'order' = g_order,
    'size' = g_size,
    'degree' = g_deg,
    'degree_max' = g_deg_max,
    'degree_min' = g_deg_min,
    'indegree' = g_in_deg,
    'indegree_max' = g_in_deg_max,
    'indegree_min' = g_in_deg_min,
    'outdegree' = g_out_deg,
    'outdegree_max' = g_out_deg_max,
    'outdegree_min' = g_out_deg_min,
    'clusters' = list('weak' = g_no_comp_weak, 'strong'= g_no_comp_strong),
    'e_con' = g_econn,
    'v_con' = g_vconn,
    'diameter' = g_diam,
    'apl' = g_apl,
    'transitivity' = g_trans,
    'top_deg_c_label' = g_deg_c_label,
    'top_eigen_c_label' = g_eigen_c_label
    #'top_close_c_label' = g_close_c_label,
    #'top_between_c_label' = g_between_c_label,
    #'top_katz_c_label' = g_katz_c_label,
    #'top_page_c_label' = g_page_c_label
  )
}
bfs_subgraph <- function(graph, scale) {
  # Get starting vertex
  indegree_centrality <- degree(graph, mode = "in")
  start_vertex <- which.max(indegree_centrality)

  # Define start conditions
  target_size <- ceiling(vcount(graph) * scale)
  visited_nodes <- c()
  queue <- c(start_vertex)

  # BFS
  while (length(visited_nodes) < target_size) {
    if (length(queue) > 0) {
      # Fetch next node from cue
      current_node <- queue[1]
      queue <- queue[-1]

      # Check if it was visited and find neighbors and add to the queue
      if (!(current_node %in% visited_nodes)) {
        visited_nodes <- c(visited_nodes, current_node)
        neighbors <- neighbors(graph, current_node)
        for (neighbor in neighbors) {
          if (!(neighbor %in% visited_nodes)) {
            queue <- c(queue, neighbor)
          }
        }
      }
    } else {
      # Fetch a new starting node
      unvisited_nodes <- setdiff(1:vcount(graph), visited_nodes)
      indegree_centrality <- degree(graph, mode = "in")
      possible_nodes <- indegree_centrality[unvisited_nodes]
      current_node <- unvisited_nodes[which.max(possible_nodes)]
      visited_nodes <- c(visited_nodes, current_node)

      # Find neighbors and to the queue
      neighbors <- neighbors(graph, current_node)
      for (neighbor in neighbors) {
        if (!(neighbor %in% visited_nodes)) {
          queue <- c(queue, neighbor)
        }
      }
    }

  }

  # Create a subgraph with the visited nodes
  subgraph <- induced_subgraph(graph, visited_nodes)
  return(subgraph)
}
add_degree_attribute <- function(graph) {
  degrees <- degree(graph)
  V(graph)$degree <- degrees
  return(graph)
}
create_graph_visualization <- function(graph, layout, node_color) {
  # Calculate alpha values based on degree
  degrees <- degree(graph)
  min_degree <- min(degrees)
  max_degree <- max(degrees)
  alpha_values <- (degrees - min_degree) / (max_degree - min_degree)  # Normalize degrees to [0, 1]
  alpha_values <- 0.5 + 0.5 * alpha_values  # Scale to [0.25, 0.75]

  # Calculate sizes logarithmically scaled according to degree
  sizes <- log(degrees + 1)  # Adding 1 to avoid log(0)
  min_size <- min(sizes)
  max_size <- max(sizes)
  sizes <- 1 + 4 * ((sizes - min_size) / (max_size - min_size))  # Scale sizes to [1, 5]

  # Convert igraph to ggraph object
  g <- ggraph(graph, layout = layout) +
    geom_edge_link(edge_alpha = 0.5, edge_colour="#A0A0A0") +  # Draw edges
    geom_node_point(aes(size = sizes, fill = node_color, alpha = alpha_values),
                    shape = 21, color = "black", stroke = 0.5, show.legend = FALSE) +  # Draw nodes with size, fill, alpha, and black outline
    scale_size_continuous(range = c(1, 5)) +  # Set size range
    scale_fill_identity() +  # Use identity scale for fill colors
    scale_alpha_continuous(range = c(0.5, 1)) +  # Set alpha range
    theme_void()  # Remove axes and labels

  return(g)
}
check_append_missing_nodes <- function(edge_tbl, node_tbl) {
  if (all(edge_tbl$source %in% node_tbl$id) && all(edge_tbl$target %in% node_tbl$id)) {
    print("All vertex names have been found.")
  } else {
    print("Some vertex names are missing.")
    if (!all(edge_tbl$source %in% node_tbl$id)) {
      print("Missing source nodes")
      missing_value <- setdiff(edge_tbl$source, node_tbl$id)
      print(missing_value)
    }
    if (!all(edge_tbl$target %in% node_tbl$id)) {
      print("Missing target nodes")
      missing_value <- setdiff(edge_tbl$target, node_tbl$id)
      print(missing_value)
    }
    match_index <- which(
      str_detect(tolower(node_tbl$id), fixed(tolower(missing_value))) |
        str_detect(tolower(missing_value), fixed(tolower(node_tbl$id)))
    )
    if (length(match_index)>0) {
      print("Similar record found, overwriting by missing name")
      print(paste("Overwritten:",node_tbl$id[match_index[1]]))
      print(paste("New value:",missing_value))
      node_tbl$id[match_index[1]] <- missing_value
    } else {
      print("No similar record found, appending missing record.")
      node_tbl <- rbind(node_tbl, data.frame(id = missing_value, username = missing_value))
    }
  }
  return(node_tbl)
}
read_tsv_files <- function(folder_path) {
  # List all .tsv files in the specified folder
  tsv_files <- list.files(path = folder_path, pattern = "\\.tsv$", full.names = TRUE)

  # Read each .tsv file and store it in a list of dataframes
  list_of_dfs <- lapply(tsv_files, read.delim)

  # Combine all dataframes into one
  combined_df <- do.call(rbind, list_of_dfs)

  return(combined_df)
}
