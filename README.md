# Road to K8s - the failure

This is my attempt to get a k8s cluster running on Oracle Cloud using terraform and ansible [following this blog post.](https://faun.pub/free-ha-multi-architecture-kubernetes-cluster-from-oracle-c66b8ce7cc37)

Terraform state managed by GitLab.

## linking to gitlab

```shell
export PROJECT_ID="GITLAB_PROJECT_ID"
export TF_USERNAME="GITLAB_USERNAME"       
export TF_PASSWORD="GITLAB_PERSONAL_ACCESS_TOKEN"    
export TF_ADDRESS="https://gitlab.com/api/v4/projects/${PROJECT_ID}/terraform/state/tf_state"   
```

```shell
terraform init \
  -backend-config=address=${TF_ADDRESS} \
  -backend-config=lock_address=${TF_ADDRESS}/lock \
  -backend-config=unlock_address=${TF_ADDRESS}/lock \
  -backend-config=username=${TF_USERNAME} \
  -backend-config=password=${TF_PASSWORD} \
  -backend-config=lock_method=POST \
  -backend-config=unlock_method=DELETE \
  -backend-config=retry_wait_min=5
  ```
