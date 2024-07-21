locals {
  edt_tz           = timeadd(timestamp(), "-4h") # EDT is -4h from UTC
  seed_branch      = "jenkins-seed"
  seed_git_url     = "https://github.com/pafable/k8s-platform.git"
  seed_script_path = "cicd/seedjob/test.groovy"

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

        jobs = [
          {
            script = <<-EOT
            pipelineJob('seed job') {
              description('seed job for jenkins.local')

              definition {
                cpsScm {
                  lightweight()

                  scm {
                    git{
                      branch("${local.seed_branch}")

                      remote {
                        url("${local.seed_git_url}")
                      }
                    }
                  }

                  scriptPath("${local.seed_script_path}")
                }
              }

              properties {
                disableConcurrentBuilds()
              }
            }

            EOT
          }
        ]

        security = {
          scriptApproval = {
            approvedScriptHashes = [
              "SHA512:b2ce6c70defc8b0c35d412b5ec9c09fabb66443a61cbed9606f62f42d0e5fb601ab7f3ddeb3b5aee006f952dd7e7795b76dd22d1182656dc49a5b8e1e7a00e84",
              "SHA512:6c985b8810ea05eca5881306b0a87cadbef3030e480000f36fb0ade96b8a4e8bf746acfb28d41fdf1f5a4f06a00dd9cbbd8307687b8f2e274977f06b31524290"
            ]
          }
        }

        unclassified = {
          timestamper = {
            allPipelines = true
          }
        }

        tool = {
          terraform = {
            installations = [
              {
                name = "tf-1-8-5"
                properties = [
                  {
                    installSource = {
                      installers = [
                        {
                          terraformInstaller = {
                            id = "1.8.5-linux-amd64"
                          }
                        }
                      ]
                    }
                  }
                ]
              },
              {
                name = "tf-1-9-2"
                properties = [
                  {
                    installSource = {
                      installers = [
                        {
                          terraformInstaller = {
                            id = "1.9.2-linux-amd64"
                          }
                        }
                      ]
                    }
                  }
                ]
              }
            ]
          }
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