# Krateo FinOps CrateDB Helm Chart

This is a [Helm Chart](https://helm.sh/docs/topics/charts/) which initializes a CrateDB instance.

## How to install

```sh
$ helm repo add krateo https://charts.krateo.io
$ helm repo update krateo
$ helm install cratedb krateo/cratedb
```

## Configuration for StorageClasses

### storageClassName

If you do not provide a `storageClassName` in your custom `values.yaml`, the chart will use the default storage class of your Kubernetes cluster. 

If you want to use a specific storage class, you can specify it in your `values.yaml` file:

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

#### Additional permissions

It may be neccessary to use the `fsGroup` settings under `podSecurityContext` in your `values.yaml` file to set the correct permissions for the mounted volumes:

```yaml
podSecurityContext:
  fsGroup: 1000
```

Currently, this is the case, for instance, when using the `managed-csi` storage class on Azure Kubernetes Service (AKS). The `fsGroup` setting will ensure that the mounted volumes have the correct permissions for the CrateDB pod to access them.
On the other hand, if you are using a different storage class, such as `azurefile-csi` on AKS, you don't need to set the `fsGroup` setting in your `values.yaml` file. In this case, the default permissions should be sufficient for the CrateDB pod to access the mounted volumes.
