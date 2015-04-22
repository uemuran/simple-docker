FROM phusion/baseimage
MAINTAINER uemuran <uemura.yusuke@gmail.com>

RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD /sbin/my_init --enable-insecure-key