## kubectl for CKA[D]

`kubectl` can be used imperatively (complex command lines), declaratively (submit a yaml file to the API server), or as
a hybrid of both.  There is no 'right way' and possibly the 'best way' depends on how one is approaching the exam, such
as whether priority is being given to speed over thoroughness.

### Setting up the environment

#### Aliasing `kubectl` to `k`

It appears to be a widespread practice within some circles to alias `kubectl` to `k`.  It is probably just as easy to
type `ku<tab>` for autocompletion.

But if one insists:

```{text}
alias k=kubectl
```

#### BASH Autocompletion

`kubectl` supports extensive autocompletion from command line sysntax to introspecting running objects.

```{text}
source <(kubectl completion bash)
```

To fix autocompletion for the `k` alias:

```{text}
source <(kubectl completion bash | sed 's/kubectl/k/g')
```

It may be quicker, and less error prone, to save the autocompletion to a file and sourcing it:

```{text}
kubectl completion bash > kubectl.autocomplete
kubectl completion bash | sed 's/kubectl/k/g' >> kubectl.autocomplete 
source ./kubectl.autocomplete 
```

In CKA[D] test environments, auto completeion may be already enabled.

### Inspecting your k8s installation

It may help to have a quick look around what access is configured.

```{text}
kubectl config get-clusters
```

```{text}
kubectl config get-contexts
```

```{text}
kubectl cluster-info
```

```{text}
kubectl version
```

### Command line syntax help

Getting help on `kubectl` or a specific sub-command.

```{text}
kubectl help
```

```{text}
kubectl help get
```

### Querying the API

#### API objects available

What API versions are supported?

```{text}
kubectl api-versions
```

What API resources are available?

```{text}
kubectl api-resources
```

#### Browsing documentation on an API object.

```{text}
kubectl explain [--api-version=apps/v1] deploy[.spec[.template[...]]]
```

### Inspecting K8s objects

* `describe` an object
* `get` an object 
    * `-o wide` <-- good habit
    * `--show-labels` <- also a good habit
    * `--watch` - occasionaly useful
* view the `logs` for a container
    * `-c` to explicitly choose which container in pod
    * `-f` to follow
* `get` the `events` objects
    * `--sort-by='.metadata.creationTimestamp'
    * `Event` is a namespaced resource (`kubectl api-resources`)

```{text}
kubectl get deployments.apps -o wide --show-labels
```

```{text}
kubectl describe pod my-app-6ccf94859-md9gw
```

#### Selecting objects

By name:

```{text}
kubectl get deployments.apps my-app -o wide
```

By labels:

```{text}
kubectl get pods -l app=my-app,pod-template-hash=8567898f89
```

#### Sorting events by JSONPath

```{text}
kubectl get events --sort-by=.metadata.creationTimestamp

### Creating jobs imperatively

* `kubectl <verb> <details>`
    * `run` - Pod (Deployments may work but is deprecated)
    * `create` - most objects
    * `expose` - Service
* `... --dry-run -o yaml` - output yaml to achieve same *declaratively*

```{text}
kubectl run my-pod --image=busybox --command --restart=Never -- /bin/sleep infinity
```

```{text}
kubectl run my-pod --image=nginx --restart=Never --port=80
```

```{text}
kubectl run my-pod --image=busybox --restart=Never -- ls
```

```{text}
kubectl create job my-job --image=busybox -- /bin/sh -c "sleep 5; echo I am done here"
```

```{text}
kubectl create service clusterip hello --tcp=80:5000
```

```{text}
kubectl run blah --image=nginx --port=80 --restart=Never
kubectl expose pod blah
```

### Interactive testing

It is often useful to run a shell within a pod for troubleshooting purposes.

```{text}
kubectl run meh --image=nginx --port=80 --restart=Never
kubectl exec -it meh -- /bin/sh
```

At other times, it may be useful to create an ephemeral Pod for the sole purpose of runnign a command within the
cluster.  Ephemeral as in the pod gets deleted after completion.

Note: Without the `--rm` the Pod will remain in `Completed` status.

```{text}
kubectl run blah --image=busybox --restart=Never --rm -it -- wget -q -O - http://example.com/
```

```{text}
kubectl run blah --image=alpine --restart=Never --rm -it -- nslookup kube-dns.kube-system.svc.cluster.local
```

### Time saving tips

#### Piping dry-run output into vim

```{text}
kubectl run meh --image=nginx --port=80 -o yaml --dry-run | vim -
```
#### Editing before creation from manifest

```{text}
kubectl create -f meh.yaml --edit
```

#### Interactively hammering a resource into shape

A vanilla resource is first created.

```{text}
kubectl create deployment my-dep --image=nginx
```

Other parameters, such as replicas and ports for a deployment, edited in interactively.

```{text}
kubectl edit deployments.apps my-dep 
```

#### Kill an object rudely
```{text}
kubectl delete deployments.apps my-dep --force --grace-period=0
```

### Deprecations

Along with Kubernetes in general, `kubectl` has been evolving over the release cycles, adding features, and deprecating
others.  In particular:
* `kubectl get <object> -o yaml --export` - previously used to create a manifest from a running object
* `kubectl run my-deployment --image=nginx --restart=Always` - old way of creating a Deployment imperatively
* `kubectl run hello --image=busybox --restart=OnFailure -- /bin/echo hello` - old way of creating a Job

### References

* [Overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* [JSONPath Support](https://kubernetes.io/docs/reference/kubectl/jsonpath/)
