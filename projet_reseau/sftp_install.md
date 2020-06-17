```shell
   # Sur le terminal de ma vm, voici les commandes :
   
   85  sudo mkdir -p /data/sftp
   87  sudo chmod 701 /data
   89  sudo groupadd sftpusers
   90  sudo useradd -g sftpusers -d /upload -s /sbin/nologin mysftpuser
   92  sudo passwd mysftpuser
   94  sudo mkdir -p /data/mysftpuser/upload
   96  sudo chown -R root:sftpusers /data/mysftpuser
   97  su -
   98  sftp mysftpuser@192.168.1.11 # (IP de mon ordi)
   
  # A partir d'ici, vous avez la suite juste en dessous avec le résultat # des commandes sinon, ici c'est juste les commandes en brut :
   
  100  cd /data/mysftpuser/upload
  108  touch testing_file.txt
  109  sudo touch testing_file.txt
  110  ls
```

```shell
# Toujours sur le terminal de ma VM :

[leadu@localhost ~]$ cd /data/mysftpuser/upload
[leadu@localhost upload]$ touch testing_file.txt
touch: cannot touch 'testing_file.txt': Permission denied
[leadu@localhost upload]$ sudo !!
sudo touch testing_file.txt
[leadu@localhost upload]$ ls
testing_file.txt
[leadu@localhost upload]$ 
```

```shell
# Sur le terminal de votre ordi :

➜  ~ ifconfig
lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
	[...]
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	ether a4:83:e7:56:dd:32 
	inet6 fe80::1085:5f0f:d760:5d0%en0 prefixlen 64 secured scopeid 0x9 
	inet 192.168.1.11 netmask 0xffffff00 broadcast 192.168.1.255
	inet6 2a01:cb19:570:c500:1c96:e0d5:1993:b1fb prefixlen 64 autoconf secured 
	[...]
vboxnet8: flags=8943<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1500
	ether 0a:00:27:00:00:08 
	inet 10.9.8.1 netmask 0xffffff00 broadcast 10.9.8.255
➜  ~ sftp mysftpuser@10.9.8.2  # (IP de ma VM)
mysftpuser@10.9.8.2's password: 
Connected to mysftpuser@10.9.8.2.
sftp> pwd
Remote working directory: /upload
sftp> ls
testing_file.txt    
sftp> get testing_file.txt        
Fetching /upload/testing_file.txt to testing_file.txt
sftp> quit
➜  ~ ssh mysftpuser@10.9.8.2     
mysftpuser@10.9.8.2's password: 
This service allows sftp connections only.
Connection to 10.9.8.2 closed.

# Voilà, HIP HIP HIP HOURRA ! Les doigts dans le nez, j'adoooooore
```

