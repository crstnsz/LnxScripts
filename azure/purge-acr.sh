az acr run --cmd "acr purge --filter 'docspider.mq.service:.*' --ago 10d --untagged" --registry docspiderdev /dev/null

