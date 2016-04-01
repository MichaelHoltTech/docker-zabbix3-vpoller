---
vsphere:
  hostname: VS_HOST

vpoller:
  endpoint: tcp://localhost:10123
  retries: 3
  timeout: 3000

zabbix:
  hostname: http://localhost/
  username: ZB_UN
  password: ZB_PW

  vsphere_object_datacenter:
    templates:
      - Template VMware vSphere Datacenter - vPoller Native
    macros:
      VSPHERE.HOST: VS_HOST
    groups:
      - Datacenters

  vsphere_object_clusters_as_zabbix_host:
    templates:
      - Template VMware vSphere Clusters - vPoller Native
    macros:
      VSPHERE.HOST: VS_HOST
    groups:
      - Clusters

  vsphere_object_host:
    templates:
      - Template VMware vSphere Hypervisor - vPoller Native
    macros:
      VSPHERE.HOST: VS_HOST
    groups:
      - Hypervisors

  vsphere_object_vm:
    templates:
      - Template VMware vSphere Virtual Machine - vPoller Native
    macros:
      VSPHERE.HOST: VS_HOST
    groups:
      - Virtual Machines

  vsphere_object_datastore:
    templates:
      - Template VMware vSphere Datastore - vPoller Native
    macros:
      VSPHERE.HOST: VS_HOST
    groups:
      - Datastores
