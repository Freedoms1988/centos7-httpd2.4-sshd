#基础镜像
FROM centos:latest

#作者
MAINTAINER freedoms1988 zzt328697768@gmail.com

#用户
USER root

#更新yum
RUN yum update -y

#安装vim wget openssh-server openssh-clients
RUN yum install -y vim wget openssh-server openssh-clients

#修改ssh配置
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -i '/^#Host_Key/'d /etc/ssh/sshd_config
RUN sed -i '/^Host_Key/'d /etc/ssh/sshd_config
RUN echo 'HostKey /etc/ssh/ssh_host_rsa_key'>/etc/ssh/sshd_config

#生成ssh-key与配置ssh-key
RUN ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
RUN mkdir -p /root/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNYXyDd8RLahbcgW7uLzoJgg9LHxNbl9EO82jdCh2VTOKl4ky/oK94wNeifdX8dpty9yjvV/47JU84CQWxUPm5d4xuV9zraq0G0COOMFZ0bNPQHYKaJGyDIVKbi0eWXBRxy+Doq7GCYAP1zKJSpsmHKkInJ0JOvzzcxbAFmzfgTV+2AKTv8W6o8fKFr8uA81XHbHSnUCHiiZbbQxpMaBlOPufZI1RB0E9TflGsBmjuLmVUhoDHKessZ65Mk47SSLL6B23hRWNgLdfkS6N2zAKpBUBubO4MUYwhmWLRzrvMjI7PtuhypoyKCGvd53gOzeRbtsq+q7PaGVpoRa4I0xlF freedoms@Freedoms.local'>/root/.ssh/authorized_keys

#修改root用户登录密码
RUN echo 'root:zztXXXXzzt'|chpasswd

#安装httpd依赖
RUN yum install -y apr-devel apr apr-util apr-util-devel pcre-devel gcc make

#下载httpd
RUN cd /usr/local/src
RUN wget http://apache.01link.hk/httpd/httpd-2.4.39.tar.gz
RUN tar -zxvf httpd-2.4.39.tar.gz

#编译httpd
RUN ./httpd-2.4.39/configure --prefix=/usr/local/apache2 --enable-mods-shared=most --enable-so
RUN make && make install

#修改httpd配置
RUN sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/g' /usr/local/apache2/conf/httpd.conf
RUN /usr/local/apache2/bin/httpd
#RUN systemctl enable httpd.service

#开放端口
EXPOSE 80 22

#启动镜像时，启动sshd与httpd
CMD /usr/sbin/sshd & /usr/local/apache2/bin/httpd -D FOREGROUND