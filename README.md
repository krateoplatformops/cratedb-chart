# Krateo FinOps CrateDB Helm Chart

This is a [Helm Chart](https://helm.sh/docs/topics/charts/) which initializes a CrateDB instance.

## Configuration for StorageClasses

### storageClassName

If you do not provide a `storageClassName` in your custom `values.yaml` (you leave the corresponding line commented), the chart will use the default storage class of your Kubernetes cluster. 

If you want to use a specific storage class, you can specify it in your `values.yaml` file in the following way:

```yaml
volumeClaims:
- metadata:
    name: data
  spec:
    accessModes:
    - ReadWriteOnce
    storageClassName: YOUR_STORAGE_CLASS_NAME # Replace with your desired storage class
    resources:
      requests:
        storage: 128Mi
```

## How to install

```sh
helm repo add krateo https://charts.krateo.io
helm repo update krateo
helm install cratedb krateo/cratedb
```
