#基础镜像
FROM freedoms1988/centos7-sshd:v2

#作者
MAINTAINER freedoms1988 zzt328697768@gmail.com

#用户
USER root

#安装httpd依赖
RUN yum install -y apr-devel apr apr-util apr-util-devel pcre-devel

#复制编译好的httpd文件到容器（要求在相同环境下编译好apache2，并将目录复制至dockfile保存目录）
COPY apache2 /usr/local/apache2

#开放端口
EXPOSE 80

#启动镜像时，启动sshd与httpd
CMD /usr/sbin/sshd & /usr/local/apache2/bin/httpd -D FOREGROUND