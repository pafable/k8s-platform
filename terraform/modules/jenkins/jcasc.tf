locals {
  jcasc_scripts = [
    {
      name = "main-config"
      script = {
        jenkins = {
          systemMessage = format(
            "${var.owner}'s Jenkins Server. Created on %s",
            formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
          )
        }
      }
    }
  ]

  jcasc_scripts_indexed_map = zipmap(
    [
      for index in range(length(local.jcasc_scripts)) : format("%03d", index)
    ], local.jcasc_scripts
  )

  jcasc_scripts_map = {
    for k, v in local.jcasc_scripts_indexed_map : "${k}-${v.name}.yaml" =>
    yamlencode(v.script)
  }
}