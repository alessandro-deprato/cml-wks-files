address  = "https://REPLACE_ME"
username = "REPLACE_ME"
# For security reasons prefer an environment variable. "export TF_VAR_password=your_password"
# In below or env are neither set Terraform will request the password
password = "REPLACE_ME"
#Uncomment this one below if you do not want to start the nodes automatically
#state = "DEFINED_ON_CORE"
topology_name = "topology.yaml"
configuration_variables = {
  device_username = "REPLACE_ME"
  device_password   = "REPLACE_ME"
  external_bridge   = "REPLACE_ME"
}
