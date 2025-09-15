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

Mostrar todas as requisições sendo recebidas

```sh
redis-cli monitor
```

Informações de acessos
```sh
redis-cli info
```

* connected_clients: Número de clientes conectados.

* blocked_clients: Quantos clientes estão bloqueados aguardando uma operação.

* used_memory_rss: Memória RAM usada pelo processo Redis.

* keyspace_hits / keyspace_misses: Taxa de acerto/erro do cache.

* evicted_keys: Chaves removidas devido à política de maxmemory.

* instantaneous_ops_per_sec: Operações por segundo.