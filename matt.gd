server {
        server_name matt.gd www.matt.gd;

        location / {
                proxy_pass http://127.0.0.1:8080;
                include proxy_params;
        }

        location /cms {
                return 301 https://$host/cms/;
        }

        location ~* ^/cms(/.*)$ {
                set $upstream 127.0.0.1:8055;
                proxy_pass http://$upstream$1$is_args$args;
        }


        listen [::]:443 ssl ipv6only=on; # managed by Certbot
        listen 443 ssl; # managed by Certbot
        ssl_certificate /etc/letsencrypt/live/matt.gd/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/matt.gd/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


        error_page 502 504 =502 /holding.html;

        location /holding {
                root /var/www;
        }
}

server {
        if ($host = www.matt.gd) {
            return 301 https://$host$request_uri;
        } # managed by Certbot


        if ($host = matt.gd) {
            return 301 https://$host$request_uri;
        } # managed by Certbot


            listen 80;
            listen [::]:80;

            server_name matt.gd www.matt.gd;
        return 404; # managed by Certbot
}