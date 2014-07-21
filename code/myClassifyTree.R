##################
####
#分类树ID3
#1,确定母节点的所有分割点
#2,找出最优分割点
#3,用最优分割点确定子节点
#4,对所有子节点重复1-3,直到子节点entropy小于某一数值
####

MyClassifyTree <- function(data, max_nodes_num, min_inpurity) {
	#变量初始化
	nodes_num <- 1
	tab <- paste(names(table(data[, 1])), 
							 table(data[, 1]), collapse=" ")
	root_node <- as.data.frame(list(dat=AString(1:nrow(data)),
																	path="root", 
																	tab=tab,
																	is_leaf=FALSE))
	all_nodes <- root_node
	is_end <- FALSE
	#初始化所需函数
	AString <- function(vec) paste(vec, collapse=",")
	StringToVector <- function(str) as.numeric(unlist(strsplit(str,split=",")))
	#######
	#step,1
	AllSplits <- function(m) {#通过node m中的样本确认可能的分割点,假定不存在名义变量
	all_splits <- NULL
	index <- StringToVector(as.character(m$dat))
	#可能的split_point不包括每个preditor中的最小值
	var_min <- apply(data[index, -1], 2, min)
	min_index <- NULL
	for(i in 1:length(var_min)) {
		min_index <- c(min_index, which(data[index, i+1] == var_min[i]))
	}
	index <- index[which(is.na(match(index, unique(min_index))))]
	for(i in 2:ncol(data)) {
		all_splits <- rbind(all_splits, cbind(i, data[index, i]))
	}
	all_splits <- as.data.frame(all_splits)	
	names(all_splits) <- c("VAR", "VALUE")
	return(all_splits)
 	}
  #######
	#step，2
	GetBestSplitPoint <- function(m) {
		all_splits <- AllSplits(m)
		best_point <- list(IG=0)
		for(ind in 1:nrow(all_splits)) {#分割点split包含所属变量名和相应的变量值
			split_point <- all_splits[ind, ]
			current_IG <- GetInfoGain(split_point, m)
			if(current_IG > best_point$IG) {
				best_point <- list(point=split_point, IG=current_IG)
			}
		}
		return(best_point)
	}
		
	GetInfoGain <- function(split_point, m) {
		index <- StringToVector(as.character(m$dat))
		#通过分割点和所在节点计算每个分割点能带来的信息增益
		possible_daughters <- DaughterNodes(split_point, m)
		prob <- length(which(
			data[index, split_point$VAR] < split_point$VALUE))/length(index)
		return(Info(m) - prob*ifelse(is.nan(Info(possible_daughters$left)), 
																 0, Info(possible_daughters$left))-
					 	(1-prob)*ifelse(is.nan(Info(possible_daughters$right)),
					 									0, Info(possible_daughters$right)))
	}
	
	DaughterNodes <- function(split_point, m) {#计算子节点
		index <- StringToVector(as.character(m$dat))
		left_index <- intersect(index, 
														which(data[, split_point$VAR] < split_point$VALUE))
		right_index <- intersect(index, 
														which(data[, split_point$VAR] >= split_point$VALUE))
		left_table <- paste(names(table(data[left_index, 1])), 
												table(data[left_index, 1]), collapse=" ")
		right_table <- paste(names(table(data[right_index, 1])), 
												 table(data[right_index, 1]), collapse=" ")
		
		left <- list(dat=AString(left_index), 
								 path=paste(m$path, paste(names(data)[split_point$VAR], "<", 
								 												 split_point$VALUE), collapse=","),
								 tab=left_table,
								 is_leaf=FALSE)
		right <- list(dat=AString(right_index),
									path=paste(m$path, paste(names(data)[split_point$VAR], ">=", 
																					 split_point$VALUE), collapse=","),
									tab=right_table,
									is_leaf=FALSE)
		return(list(left=left, right=right))
	}
	
	Info <- function(m) {#计算信息熵，使用基尼系数
		index <- StringToVector(as.character(m$dat))
		tab <- table(data[index, 1])
		labels_prob <- tab/sum(tab)
		gini <- NULL
		for(prob in labels_prob) {
			gini <- cbind(gini, prob*(1-prob))
		}
		return(sum(gini))
	}
	
	
	RecursivePartition <- function(nodes) {
		######
		#step，3
		#是否跳出递归
#		if(is_end) return(1)
		all_daughters <- NULL
		current_level_nodes_num <- 0
		for(row_num in 1:nrow(nodes)) {
			m <- nodes[row_num, ]
			current_node_info <- Info(m)
			current_level_nodes_num <- current_level_nodes_num + 1
			#判断某一分支是否结束
			if(current_node_info < min_inpurity) {
				all_nodes[(nodes_num - nrow(nodes) + current_level_nodes_num), 4] <- TRUE
				next
			}
			p <- GetBestSplitPoint(m)   #通过node m计算最佳分割点			
			daughter_nodes <- DaughterNodes(p$point, m) #确认子节点
			all_daughters <- rbind(all_daughters, 
														 daughter_nodes$left, 
														 daughter_nodes$right)
		}
		all_nodes <<- rbind(as.matrix(all_nodes), all_daughters)
		nodes_num <<- ifelse(is.null(all_daughters), 0, nrow(all_daughters)) + nodes_num
		#结束条件判断
		if(nodes_num > max_nodes_num || is.null(all_daughters)) {
			return(1)
		}
		#递归调用
		else return(RecursivePartition(all_daughters))
	}	 
	
	#调用递归函数
	RecursivePartition(root_node)
#	print(c(nodes_num, max_nodes_num))
	return(all_nodes)
}



##################
#用iris数据测试
require(caret)
data(iris)

####按种类统计鸢尾花数据
#table(iris$Species)

####设置训练集和预测集
set.seed(123)
trainIndex <- createDataPartition(iris$Species, p=0.5, list=F)
training <- iris[trainIndex, c(5, 1:4)]
testing <- iris[-trainIndex, c(5, 1:4)]

a <- MyClassifyTree(dat=training, max_nodes_num=10, min_inpurity=0.2)

model <- train(Species ~ ., method="rpart", data=training)
#GetInfoGain(list(VAR=4, VALUE=2.5), root_node) ==
#	GetInfoGain(list(VAR=4, VALUE=3.3), root_node)
#model$finalModel
