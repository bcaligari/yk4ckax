# YAML for CKA[D]

## YAML Ain't a Markup Language

### Objectives

* Enough YAML for the CKA[D] exams.
* More specifically, restricted to the YAML I've used in creating Kubernetes manifests.
* The vocabulary used was chosen to loosely correspond to Kubernetes documentation and kubectl error messages.

### YAML

* *Human readable data-serialisation language*
* Works well enough to *declare* the configuration of a Kubernetes object.
* Kubernetes objects can be composed in JSON and submitted to the API sever with `kubectl`.
* `kubectl` can also conveiently accept manifests written in YAML and transparently takes care of translating the YAML to JSON for submission.
* Got it's own [official website ](https://yaml.org/).

## Document structure

* Plain text - assuming this is UTF-8
* Indentation - 2 spaces
    * unless the next line starts with a `-` (array item) in which case it should align with the *key*
* If it doesn't look right, then there's probably something wrong.
* Mutliple objects in the same document are separated by a `---` line.
* API objects such as `Deployments` may contain templates for other API objects.  Indentation can be a pain.

## YAML objects

* `key : value` pairs
* Keys - a string
* Values
    * Scalars
    * Maps
    * Arrays

## Scalars

* **Boolean** - `true`, `false`
* **Integer** - `80`
* **String** - `hello`, `"hello world", `0.1`

### Multi Line strings

```{yaml}
stringData:
  haiku: |2
    Eclipse of the moon
    The sun shining brightly
    Smoke filling the room
```

### Base 64 encoded strings

* encoding - `echo -n "something something" | base64`
* decoding - `echo c29tZXRoaW5nIHNvbWV0aGluZw== | base64 -d`
* Keys are likely to be PEM files encoded as a long base 64 string.

## Maps

```{yaml}
data:
  user: c3lzb3A=
  password: UzR2aWxsMw==
```

### Single line map

```{yaml}
      requests: {memory: 100Mi, cpu: 0.1}
```

### Emtpy map

```{yaml}
    emptyDir: {}
```

## Arrays

Note: Prefix each array item with a `-` aligned under the key.

```{yaml}
  volumes:
  - name: scratchpad
    emptyDir: {}
  - name: config-data
    secret:
      secretName: config-data
```

### Single line

```{yaml}
    command: ["/usr/bin/tail", "-f", "/dev/null"]
```

### Empty array

```{yaml}
    args: []
```

