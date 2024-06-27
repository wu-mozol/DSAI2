# LIBRARIES
library(tidyverse)
library(dplyr)
library(igraph)
library(ggraph)
library(svglite)

#FUNCTIONS
#Check and append missing nodes (adapted for Truth Social format)
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
      missing_usernames <- node_tbl$username[node_tbl$id %in% missing_value]
      print(missing_value)
    }
    print("Appending missing record.")
    node_tbl <- rbind(node_tbl, data.frame(id = missing_value, username = missing_value))
  }
  return(node_tbl)
}
#Graph analysis (uncomment versions and add them at return for different approaches (e.g. direction))
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

#READ TS DATA
ts_data_path = paste(getwd(),"/data/truth_social", sep="")
ts_node_data <- file.path(ts_data_path, "users.tsv")
ts_edge_data <- file.path(ts_data_path, "follows.tsv")
ts_nodes <- read_tsv(ts_node_data)
ts_edges <- read_tsv(ts_edge_data)
ts_nodes <- ts_nodes %>% select(id, username)
ts_edges <- ts_edges %>% select(follower, followed)
colnames(ts_nodes)<-c("id", "username")
colnames(ts_edges)<-c("source", "target")
ts_nodes <- check_append_missing_nodes(ts_edges, ts_nodes)

#CREATE TS GRAPH AND ANALYZE IT
(g_ts <- igraph::graph_from_data_frame(
  d = ts_edges,
  directed = TRUE,
  vertices = ts_nodes
))
g_ts_stats <- graph_main_analysis(g_ts)

#CREATE COMPARISON GRAPHS AND ANALYZE
# Erdős-Rényi graph
if(file.exists("gnp.csv")){
  gnp <- read_graph("gnp.csv", "edgelist", directed=TRUE)
} else {
  gnp <- sample_gnp(n=g_ts_stats$order, p=(g_ts_stats$size/(g_ts_stats$order*(g_ts_stats$order-1))), directed=TRUE)
  no.clusters(gnp)
  is_connected(gnp)
  if(no.clusters(gnp) | is_connected(gnp)){
    write_graph(gnp,"gnp.csv","edgelist")
  } else {
    print("Failed to create Gnp graph")
  }
}
gnp_stats <- graph_main_analysis(gnp)

# Watts-Strogatz graph
if(file.exists("swg.csv")){
  swg <- read_graph("swg.csv", "edgelist", directed=TRUE)
} else {
  swg <- sample_smallworld(dim=1, size=g_ts_stats$order, nei=round(g_ts_stats$size/g_ts_stats$order,0), p=0.025)
  no.clusters(swg)
  is_connected(swg)
  if(no.clusters(swg) | is_connected(swg)){
    write_graph(swg,"swg.csv","edgelist")
  } else {
    print("Failed to create SWG graph")
  }
}
swg_stats <- graph_main_analysis(swg)

# Barabási-Albert graph
if(file.exists("pag.csv")){
  pag <- read_graph("pag.csv", "edgelist", directed=FALSE)
} else {
  pag <- sample_pa(n=g_ts_stats$order, m=round(g_ts_stats$size/g_ts_stats$order,0), directed=TRUE)
  no.clusters(pag)
  is_connected(pag)
  if(no.clusters(pag) | is_connected(pag)){
    write_graph(pag,"pag.csv","edgelist")
  } else {
    print("Failed to create PAG graph")
  }
}
pag_stats <- graph_main_analysis(pag)