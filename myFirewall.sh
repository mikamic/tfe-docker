#!/bin/bash
 
# Flush all current rules from iptables
iptables -F
 
# Set default policies for INPUT, FORWARD and OUTPUT chains
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
 
# ---
 
# Accept packets belonging to established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
# Set access for localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
 
# ICMP (ping)
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A INPUT  -p icmp  -j ACCEPT
 
# ---
 
# Allow SSH connections
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
 
# DNS In/Out
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
 
# NTP Out
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
 
# ---
 
# Save settings
/sbin/service iptables save
 
# List rules
iptables -L -n
