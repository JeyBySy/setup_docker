#!/bin/bash
get_password() {
    clear
    printf "Enter your sudo pasword: "
    read -s pass
}
check_and_update(){
    echo $pass | sudo -S apt update
}

required_packages(){
    sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg -y

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

main(){
    while [ !check_and_update ];
    do
        get_password
        check_and_update
        if [ $? -eq 0 ]; then
            required_packages 
            break
        fi
    done
}

main
