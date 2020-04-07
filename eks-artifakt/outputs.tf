#
# Outputs
#

output "cluster-endpoint" {
  value = "${aws_eks_cluster.artifakt-cluster.endpoint}"
}

output "cert-auth" {
  value = "${aws_eks_cluster.artifakt-cluster.certificate_authority.0.data}"
}

#resource "local_file" "kubeconfig" {
#    content     = <<KUBECONFIG
#apiVersion: v1
#clusters:
#- cluster:
#    server: ${aws_eks_cluster.artifakt-cluster.endpoint}
#    certificate-authority-data: ${aws_eks_cluster.artifakt-cluster.certificate_authority.0.data}
#  name: kubernetes
#contexts:
#- context:
#    cluster: kubernetes
#    user: aws
#  name: aws
#current-context: aws
#kind: Config
#preferences: {}
#users:
#- name: aws
#  user:
#    exec:
#      apiVersion: client.authentication.k8s.io/v1alpha1
#      command: aws-iam-authenticator
#      args:
#        - "token"
#        - "-i"
#        - "artifakt-cluster"
#KUBECONFIG
#
#    filename = "${var.kubeconfigpath}"
#}

