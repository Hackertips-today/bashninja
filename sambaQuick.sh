# Setup Samba in Ubuntu quick
Setting up a Samba server on an Ubuntu server to share /home/subz is straightforward. Follow these quick steps:


1. Install Samba
Run the following command to install Samba:
sudo apt update
sudo apt install samba -y

2. Create a Samba User
Add a Samba user to match the system user (user in this case):

sudo smbpasswd -a user
Enter and confirm the password for the Samba user.

3. Backup the Samba Configuration
Backup the current Samba configuration file:
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

4. Configure Samba
Edit the Samba configuration file:

sudo nano /etc/samba/smb.conf
   # Add the following section to the end of the file to define the shared folder:

[user Home]
   path = /home/user
   valid users = user
   browsable = yes
   writable = yes
   read only = no
   create mask = 0755
   directory mask = 0755
Replace user with the username if different.

5. Set Permissions
Ensure the Samba user has access to the shared directory:
sudo chmod -R 755 /home/user
sudo chown -R user. /home/user

6. Restart Samba
Restart the Samba service to apply the changes:
sudo systemctl restart smbd
sudo systemctl enable smbd

7. Test the Configuration
Check if the Samba configuration is valid:
testparm

8. Access the Share
On a client machine (e.g., Windows or Linux), access the shared folder:

Linux:
smbclient //server-ip/userhome -U user         #
Windows: Open \\server-ip\user                   # in File Explorer and provide the credentials.

Troubleshooting:
If the share isn’t accessible, ensure the firewall allows Samba traffic:
sudo ufw allow samba
or
sudo iptables -L


Confirm the Samba service is running:
sudo systemctl status smbd
