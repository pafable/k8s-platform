# Kong Mesh Module

You will need to run this twice. The first time will not install traffic-permission.tf because CRDs have not been deployed yet. 
The second time will install traffic-permission.tf.

### What have I done so far?
- Configured the Kong Mesh module to install Kong Mesh on the cluster.
- Applied MTLs on the ghost deployment (see [ghost.tf](..%2F..%2Flocal-cluster%2Fghost%2Fghost.tf))

### TO DO
- Manage incoming traffic with gateways 
- Route and traffic shaping
- Service discovery
- Tracing