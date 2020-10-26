# Tanzu Build Service Dependencies Updater

**DISCLAIMER: Use it at your own risk. Not supported by the VMware Tanzu team or myself.**

Open the `tbs-deps-updater-configmap.yaml` and configure the following:
* **pivnetconfig** - Repalace the API_TOKEN variable with your Tanzu Network (a.k.a. PivNet) token.
* **config.json** - Using your docker cli, make sure you log in to the Tanzu/Pivotal Harbor Repo and to the repository where you store your TBS installation dependencies and copy the contents from your ~/.docker/config.json file.
* **kubeconfig** - Replace the contents with your kubeconfig file with access to the Kubernetes where you have Tanzu Build Service installed.

> You don't need to run this Job/CronJob on the same cluster of your Tanzu Build Service instance.

Now let's apply your ConfigMap to your Kubernetes cluster:
```
kubectl apply -f tbs-deps-updater-configmap.yaml
```

With your ConfigMap in place, now it's time to run either the Job or CronJob provided:
* Use the `tbs-deps-updater-job.yaml` if you want to run this manually.
* Use the `tbs-deps-updater-cronjob.yaml` if you want to set-up a CronJob in Kubernetes (runs once a day).

To run the Job:
```
kubectl apply -f tbs-deps-updater-job.yaml
```

To run the CronJob:
```
kubectl apply -f tbs-deps-updater-cronjob.yaml
```

You should be able to see the output of the logs by using `kubectl logs` and pointing at the Pods created by the Job or CronJob.

The files inside the `docker` directory are just FYI with details of how the build of the container image used by the Job was created.

If you have any questions, contributions, please reach out.