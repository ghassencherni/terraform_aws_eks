#----root/outputs.tf----
resource "local_file" "kubeconfig" {
  content = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.eks-artifakt.cluster-endpoint}
    certificate-authority-data: ${module.eks-artifakt.cert-auth}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "artifakt-cluster"
KUBECONFIG

  filename = "${var.kubeconfigpath}"
}

output "wordpress_db_endpoint" {
  value = "${module.rds.wordpress_db_endpoint}"
}

resource "local_file" "rdsenv" {
  content = <<RDSENV
WORDPRESS_DB_HOST = "${module.rds.wordpress_db_endpoint}"
WORDPRESS_DB_NAME = "${var.dbname}"
WORDPRESS_DB_PASSWORD = "${var.dbpassword}"
WORDPRESS_DB_USER = "${var.dbuser}"
RDSENV

  filename = "rds.env"
}
