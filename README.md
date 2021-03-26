# Submit Consul Configurations

A GitHub Action that finds all configuration files and uploads them to a Consul Server
## Features

Searches all subdirectories of `location` using `regex` expression. All matched files will be uploaded to the Consul Server at `addr`.

## Example Usage
```
    - name: consul
      uses: pennsignals/consul_configs_submit_action@main
      with:
        addr: 'http://10.146.0.5:8500/v1/kv' # required
        config: './deploy_config.yml' # required
        env: 'staging'
```