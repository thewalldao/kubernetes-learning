sudo virsh net-start default
sudo virsh net-autostart default
sudo virsh list --all
sudo virsh net-list --all
sudo virsh net-dhcp-leases default 
sudo virsh undefine manjaro-terraform
sudo systemctl enable --now virtlogd
sudo systemctl enable --now libvirtd.service
sudo terraform plan -out execution-plan.out
sudo terraform apply -input=false execution-plan.out