# --- IN USE ---

# Function to get followees
get_followees <- function(user_id) {
  followees <- get_account_following(id = user_id)
  return(followees)
}

# Function to get the account info
get_account_info <- function(user_id) {
  account_info <- get_account(id = user_id)
  return(list(id = account_info$id, name = account_info$username, followers_count = account_info$followers_count))
}

# Main BFS mastodon scraper
perform_bfs <- function(start_user_id, state = NULL) {
  # Initialize state if not provided
  if (is.null(state)) {
    queue <- list(start_user_id)
    nodes <- data.frame(id = character(), name = character(), followers_count = integer(), stringsAsFactors = FALSE)
    edges <- data.frame(follower = character(), followee = character(), stringsAsFactors = FALSE)
    visited <- character()
  } else {
    queue <- state$queue
    nodes <- state$nodes
    edges <- state$edges
    visited <- state$visited
  }
  
  counter <- 0
  while (length(queue) > 0 && counter<7) {
    current_user_id <- queue[[1]]
    queue <- queue[-1]
    
    # Skip if the user is already visited
    if (current_user_id %in% visited) {
        next
    }
    
    # Get account info of the current user
    cat("Get next node: ", current_user_id, "\n")
    current_user_info <- get_account_info(current_user_id)
    
    # Add the current user to the nodes data frame
    nodes <- rbind(nodes, data.frame(id = current_user_info$id, 
                                     name = current_user_info$name, 
                                     followers_count = current_user_info$followers_count,
                                     stringsAsFactors = FALSE))
    counter <- counter + 1
    cat("Node added: ", current_user_id, "\n")
    
    # Get followees of the current user
    cat("Get followees of node: ", current_user_id,"\n")
    followees <- get_followees(current_user_id)
    
    # Handle empty followees
    if (length(followees) == 0) {
      print("No followees")  
      next
    }
    
    # Get follower counts for followees
    followee_infos <- list()
    for (id in followees$id){
      cat("Get followee: ", id, "\n")
      followee_info <- get_account_info(id)
      followee_infos <- append(followee_infos, list(followee_info))
    }
    followees_infos <- do.call(rbind.data.frame, followee_infos)
    
    # Sort followees by follower count in descending order
    followees_infos <- followees_infos[order(-followees_infos$followers_count), ]
    
    # Add to edges and queue
    print("Adding followees to edges and queue")
    for (i in 1:nrow(followees_infos)) {
        followee_info <- followees_infos[i, ]
        edges <- rbind(edges, data.frame(follower = current_user_id, 
                                         followee = followee_info$id,
                                         stringsAsFactors = FALSE))
        queue <- c(queue, followee_info$id)
    }
    
    # Mark the current user as visited
    visited <- c(visited, current_user_id)
  }
  
  # Return updated state
  list(queue = queue, nodes = nodes, edges = edges, visited = visited)
}








# --- OLD ---

## Initialize a queue for BFS and a visited set
#queue <- list(start_user_id)
#nodes <- data.frame(id = character(), name = character(), followers_count = integer(), stringsAsFactors = FALSE)
#edges <- data.frame(follower = character(), followee = character(), stringsAsFactors = FALSE)
#visited <- character()
#
## BFS to build the graph
#while (length(queue) > 0 && nrow(nodes) < 10) {
#    current_user_id <- queue[[1]]
#    queue <- queue[-1]
#    
#    # Skip if the user is already visited
#    if (current_user_id %in% visited) {
#        next
#    }
#    
#    # Get account info of the current user
#    print("Get account start")
#    current_user_info <- get_account_info(current_user_id)
#    
#    # Add the current user to the nodes data frame
#    nodes <- rbind(nodes, data.frame(id = current_user_info$id, 
#                                     name = current_user_info$name, 
#                                     followers_count = current_user_info$followers_count,
#                                     stringsAsFactors = FALSE))
#    
#    # Get followees of the current user
#    print("Get followees start")
#    followees <- get_followees(current_user_id)
#    print(followees)
#    
#    # Handle empty followees
#    if (length(followees) == 0) {
#        next
#    }
#    
#    # Get follower counts for followees
#    followee_infos <- list()
#    print(followees)
#    print("Get account start")
#    for (id in followees$id){
#      print(id)
#      followee_info <- get_account_info(id)
#      followee_infos <- append(followee_infos, list(followee_info))
#    }
#    print("Get account end")
#    followees_infos <- do.call(rbind.data.frame, followee_infos)
#    
#    # Sort followees by follower count in descending order
#    followees_infos <- followees_infos[order(-followees_infos$followers_count), ]
#    
#    # Add to edges and queue
#    for (i in 1:nrow(followees_infos)) {
#        followee_info <- followees_infos[i, ]
#        edges <- rbind(edges, data.frame(follower = current_user_id, 
#                                         followee = followee_info$id,
#                                         stringsAsFactors = FALSE))
#        queue <- c(queue, followee_info$id)
#    }
#    
#    # Mark the current user as visited
#    visited <- c(visited, current_user_id)
#}