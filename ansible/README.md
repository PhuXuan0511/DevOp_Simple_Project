Ansible playbook to build images, push to registry, and deploy to Kubernetes (production-ready)

Prerequisites
-------------

- Docker CLI
- `kubectl` configured for the target cluster (or set `KUBECONFIG`)
- Ansible 2.10+
- Install required Ansible collections:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

Basic run
---------

Set registry credentials as env vars (or export in CI):

```bash
export REGISTRY_USER=youruser
export REGISTRY_PASSWORD=yourpassword
export BUILD_TAG=ci-${GIT_COMMIT:0:7}
export KUBECONFIG=~/.kube/config
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

Helm chart
----------

This repo now contains a Helm chart at `helm/devop-simple-project`. The Ansible playbook deploys this chart using `helm upgrade --install`.

Install Helm (client) before running the playbook or in your CI agent.

Example helm CLI (equivalent to what the playbook runs):

```bash
helm upgrade --install devop-simple-project helm/devop-simple-project \
	--namespace default --create-namespace \
	--set backend.image=docker.io/youruser/devop-simple-project-backend:TAG \
	--set frontend.image=docker.io/youruser/devop-simple-project-frontend:TAG
```

Jenkins integration
-------------------

The project's `Jenkinsfile` has been updated to run the Ansible playbook as part of the pipeline. The pipeline pushes images to the registry and then calls `ansible-playbook` to deploy to Kubernetes. Ensure Jenkins has a credential (username/password) entry (example id: `docker-creds`) and that the Jenkins agent has `ansible`, `docker` and `kubectl` available.

Notes and cautions
------------------
- This playbook uses `community.docker` and `kubernetes.core` collections for idempotent operations.
- If you manage cluster resources with `terraform/`, avoid applying conflicting changes from both Terraform and Ansible for the same resources.

Want me to:
- Add image signing and vulnerability scanning steps in the pipeline.
- Wire image tags to Git commit SHAs automatically.
- Fetch `namespace` and image names from `terraform/variables.tf` automatically.
Ansible playbook to build images, push to registry, and deploy to Kubernetes (production-ready)

Prerequisites
-------------

- Docker CLI
- `kubectl` configured for the target cluster (or set `KUBECONFIG`)
- Ansible 2.10+
- Install required Ansible collections:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

Basic run
---------

Set registry credentials as env vars (or export in CI):

```bash
export REGISTRY_USER=youruser
export REGISTRY_PASSWORD=yourpassword
export BUILD_TAG=ci-${GIT_COMMIT:0:7}
export KUBECONFIG=~/.kube/config
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

Jenkins integration
-------------------

The project's `Jenkinsfile` has been updated to run the Ansible playbook as part of the pipeline. The pipeline pushes images to the registry and then calls `ansible-playbook` to deploy to Kubernetes. Ensure Jenkins has a credential (username/password) entry (example id: `docker-creds`) and that the Jenkins agent has `ansible`, `docker` and `kubectl` available.

Notes and cautions
------------------
- This playbook uses `community.docker` and `kubernetes.core` collections for idempotent operations.
- If you manage cluster resources with `terraform/`, avoid applying conflicting changes from both Terraform and Ansible for the same resources.

Want me to:
- Add image signing and vulnerability scanning steps in the pipeline.
- Wire image tags to Git commit SHAs automatically.
- Fetch `namespace` and image names from `terraform/variables.tf` automatically.

