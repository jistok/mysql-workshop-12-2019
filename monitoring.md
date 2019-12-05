# Monitoring of Pivotal MySQL Service Instances
 
Per the MySQL PMs:
> 
> We have done some work to show dashboards for service instances in the Health
> Watch tile using Indicator Protocol.  We will likely release it in the next
> patch of 2.7 or in 2.8, so aiming for a 2019 release!
> 
> Percona's tool, I believe, is PMM, which we have not integrated with just yet.
> No plans to do so in the near future, unless there's a specific customer
> blocked on it. And it also depends on the size of opportunity etc.
> 
> FWIW, in the absence of indicator protocol, I’ve been suggesting hooking up
> Grafana to metrics store/logcache, or configuring Prometheus to consume from
> the firehose. we also have the cf tail log-cache cf [CLI plugin](https://plugins.cloudfoundry.org/#log-cache)
> for developers.

