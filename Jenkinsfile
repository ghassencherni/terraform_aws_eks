node {
  git 'https://github.com/ghassencherni/terraform_aws_eks.git'
  
  if(action == 'Deploy') {
    stage('init') {
        sh """
            terraform init
        """
    }
    stage('plan') {
      sh label: 'terraform plan', script: "export AWS_ACCESS_KEY_ID=${aws_access_key_id};export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key};terraform plan -out=tfplan -input=false -var aws_region=${aws_region} -var vpc_cidr=${vpc_cidr} '-var=public_cidr_subnet=[\"${public_cidr_subnet_1}\",\"${public_cidr_subnet_2}\"]' '-var=private_cidr_subnet=[\"${private_cidr_subnet_1}\",\"${private_cidr_subnet_2}\"]' -var identifier=${identifier} -var dbname=${dbname} -var dbuser=${dbuser} -var dbpassword=${dbpassword}"
      script {
          timeout(time: 10, unit: 'MINUTES') {
              input(id: "Deploy Gate", message: "Deploy environment?", ok: 'Deploy')
          }
      }
    }
    stage('apply') {
        sh label: 'terraform apply', script: "export AWS_ACCESS_KEY_ID=${aws_access_key_id};export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key};terraform apply -lock=false -input=false tfplan"
        archiveArtifacts artifacts: 'rds_conn_configmap.yaml, config', followSymlinks: false
    stage ('Trigger wordpress_k8s')
       build job: 'wordpress_k8s', parameters: [string(name: 'Action', value: 'Deploy Wordpress'), string(name: 'aws_access_key_id', value: '${aws_access_key_id}'), string(name: 'aws_secret_access_key', value: '${aws_secret_access_key}')]
  } 
    }

  if(action == 'Destroy') {
    stage('plan_destroy') {
      sh label: 'terraform plan destroy', script: "export AWS_ACCESS_KEY_ID=${aws_access_key_id};export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key};terraform plan -destroy -out=tfdestroyplan -input=false -var aws_region=${aws_region} -var vpc_cidr=${vpc_cidr} '-var=public_cidr_subnet=[\"${public_cidr_subnet_1}\",\"${public_cidr_subnet_2}\"]' '-var=private_cidr_subnet=[\"${private_cidr_subnet_1}\",\"${private_cidr_subnet_2}\"]' -var identifier=${identifier} -var dbname=${dbname} -var dbuser=${dbuser} -var dbpassword=${dbpassword}"
    }
    stage('destroy') {
      script {
          timeout(time: 10, unit: 'MINUTES') {
              input(id: "Destroy Gate", message: "Destroy environment?", ok: 'Destroy')
          }
      }
      sh label: 'Destroy environment', script: "export AWS_ACCESS_KEY_ID=${aws_access_key_id};export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key};terraform apply -lock=false -input=false tfdestroyplan"
    }
  }
}
