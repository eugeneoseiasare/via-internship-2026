# Metasploitable2 Exploitation Report

**Name:** Eugene Osei Asare
**Index Number:** 1680825
**School:** KNUST
**Target IP:** 192.168.56.102
**Attacker IP:** 192.168.56.101
**Date:** September 20, 2026

---

## Reconnaissance Summary

**Tool Used:** nmap -sV -sC -O -p- 192.168.56.102

**Scan Output:**
Nmap scan report for 192.168.56.102
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
22/tcp   open  ssh         OpenSSH 4.7p1 Debian
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
80/tcp   open  http        Apache 2.2.8
139/tcp  open  netbios-ssn Samba smbd 3.0.20-Debian
445/tcp  open  netbios-ssn Samba smbd 3.0.20-Debian
1099/tcp open  java-rmi    GNU Classpath grmiregistry
1524/tcp open  bindshell   Metasploitable root shell
3306/tcp open  mysql       MySQL 5.0.51a-3ubuntu5
3632/tcp open  distccd     distccd v1
5432/tcp open  postgresql  PostgreSQL DB 8.3.0
5900/tcp open  vnc         VNC (protocol 3.3)
6667/tcp open  irc         UnrealIRCd 3.2.8.1
8180/tcp open  http        Apache Tomcat/Coyote JSP engine 1.1
