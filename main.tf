locals{
    eks_worker_name = "${var.env}-${var.application}"
    eks_worker_name2 = "${var.env}-${var.application}2"
    eks_worker_role_name = "${var.env}-${var.application}"
    eks_role_name     =  "${var.env}-${var.application}-0"
    cluster_name = "${var.env}-${var.application}"
}