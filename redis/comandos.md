To open the Redis CLI, enter the command as:

```sh
$ redis-cli
```


```sh
SET CO "Colorado"
```

```sh
GET CO
```


```sh
KEYS *
```


Delete All Keys In Redis

Delete all keys from all Redis databases:
```sh
$ redis-cli FLUSHALL
```

Delete all keys of the currently selected Redis database:

```sh
$ redis-cli FLUSHDB
```

Delete all keys of the specified Redis database:

```sh
$ redis-cli -n <database_number> FLUSHDB
```