#!/bin/bash

read -p "Введіть імена користувачів через пробіл: " -a users

cd /home || exit 1

for user in "${users[@]}"; do
    if [[ -d "/home/$user" ]]; then
        echo "Директорія для $user вже існує"
        continue
    fi
    
    if ! id "$user" &> /dev/null; then
        echo "Створення нового користувача $user"
        useradd -m "$user" || {
            echo "Помилка створення користувача $user"
            continue
        }
    else
        echo "Користувач $user вже існує"
    fi
    
    password=$(openssl rand -base64 12)
    echo "$password" > "/root/${user}_password.txt"
    echo "${user}:${password}" | chpasswd
    
    ssh_dir="/home/$user/.ssh"
    key_file="$ssh_dir/id_rsa"
    
    if [[ ! -f "$key_file" ]]; then
        mkdir -p "$ssh_dir"
        ssh-keygen -q -t rsa -b 4096 -N "" -f "$key_file"
        chown -R "$user:$user" "$ssh_dir"
        chmod 700 "$ssh_dir"
        chmod 600 "$key_file"
        chmod 644 "${key_file}.pub"
        echo "Приватний ключ для $user створено"
    else
        echo "SSH ключ для $user вже існує"
    fi
done

exit 0

