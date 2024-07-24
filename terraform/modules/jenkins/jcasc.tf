locals {
  edt_tz           = timeadd(timestamp(), "-4h") # EDT is -4h from UTC
  seed_branch      = "refs/heads/master"
  seed_git_url     = "https://github.com/pafable/k8s-platform.git"
  seed_script_path = "cicd/seedjob/Jenkinsfile"

  jcasc_scripts = [
    {
      name = "main-config"
      script = {
        jenkins = {
          clouds = [
            {
              kubernetes = {
                templates = [
                  {
                    id        = "add41f93e0173b79975347df36192e09c18755cd0f19a8d850790a0df21d99a0"
                    label     = "jenkins-my-jenkins-agent"
                    name      = "my-jenkins-agent"
                    namespace = "jenkins"
                    volumes = [
                      {
                        hostPathVolume = {
                          hostPath  = "/var/run"
                          mountPath = "/var/run"
                        }
                      }
                    ]
                  }
                ]
              }
            }
          ]
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

        appearance = {
          prism = {
            theme = "TWILIGHT"
          }
        }

        security = {
          globalJobDslSecurityConfiguration = {
            useScriptSecurity = false
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