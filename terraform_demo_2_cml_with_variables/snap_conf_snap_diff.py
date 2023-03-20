import sys
import yaml
import variables
from pprint import pprint
from genie.conf import Genie
from genie.testbed import load
from yaml import CLoader as Loader
from genie.conf.base import Interface
from virl2_client import ClientLibrary
from genie.libs.ops.bgp.nxos.bgp import Bgp
from genie.libs.parser.nxos.show_bgp import ShowBgpVrfAllAllSummary

client = ClientLibrary(variables.address, variables.username, variables.password, ssl_verify=False)
for lab in client.all_labs():
    if lab.title == "3 Tier Topology":
        mylab = lab
cml_testbed=(mylab.get_pyats_testbed())
dict_testbed = yaml.load(cml_testbed,Loader= Loader)
for name, attributes in dict_testbed["devices"].items():
    if name == "terminal_server":
        attributes["credentials"]["default"]["username"]=variables.username
        attributes["credentials"]["default"]["password"]=variables.password
    else:
        attributes["credentials"]["default"]["username"]=variables.device_username
        attributes["credentials"]["default"]["password"]=variables.device_password

conf_testbed = Genie.init(testbed = dict_testbed)

testbed = load(dict_testbed)

data = dict()

for name,dev in testbed.devices.items():
    if not "aggr" in name:
        continue
    dev.connect(log_stdout=False)
    bgp = Bgp(dev,commands=[ShowBgpVrfAllAllSummary])
    bgp.learn()
    data[dev] = bgp 

for name,dev in conf_testbed.devices.items():
    if not "aggr1" in name:
        continue
    dev.connect(log_stdout=False)
    new_loopback = Interface(device=dev, name="Loopback1")
    new_loopback.ipv4 = "3.3.3.3"
    new_loopback.ipv4.netmask = "255.255.255.255"
    new_loopback.build_config()

for dev,pre_snapshot in data.items():
    bgp = Bgp(dev,commands=[ShowBgpVrfAllAllSummary])
    bgp.learn()
    diff = bgp.diff(pre_snapshot,exclude=r"(^msg_sent|msg_rcvd|tbl_ver|output_queue|input_queue)")
    if diff:
        print(f"Following diff found on:{dev} \n {diff}\n\n")
    else:
        print(f"No diff found on {dev}\n\n")
sys.exit(1)