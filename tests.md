## Sample Manifests

### Restrict all to a test namespace

```{text}
$ kubectl create ns testverse
namespace/testverse created
```

### Load all the manifests

```{text}
$ kubectl create -n testverse -f manifests/
secret/config-data created
pod/test-pod created
deployment.apps/my-app created
service/my-app created
```

### Have some fun

```{text}
(
    for cnt in `seq 0 999`
    do
        kubectl -n testverse exec -it test-pod -c alpine -- wget -q -O - http://my-app.testverse.svc/hostname.txt
    done
) | sort | uniq -c
```

