locals {
  edt_tz = timeadd(timestamp(), "-4h")

  jcasc_scripts = [
    {
      name = "main-config"
      script = {
        jenkins = {
          systemMessage = format(
            "${title(var.owner)}'s Jenkins Server. Created on %s EDT",
            formatdate("DD MMM YYYY hh:mm", local.edt_tz)
          )
        }
      }
    }
  ]

  jcasc_scripts_indexed_map = zipmap(
    [for i in range(length(local.jcasc_scripts)) : format("%03d", i)], local.jcasc_scripts
  )

  jcasc_scripts_map = {
    for k, v in local.jcasc_scripts_indexed_map : "${k}-${v.name}.yaml" => yamlencode(v.script)
  }
}