# simple-docker

## Description

Vagrantのdocker providerでssh接続可能なdocker imageを立ち上げるサンプル。

Mac上で確認したため、dockerのHostVMはvagrantデフォルトのboot2dockerが自動で立ち上がる。
dockerがMacで動作しないためvagrant providerが自動的に補足してくれる。
もし、デフォルトでないHostVMを利用したい場合は以下のようにHostVMを定義を記述したVagrantfileを指定してあげると良い。
HostVMにはDockerを立ち上げるためdockerのインストール等を行う必要があり正しく動くように作るには結構手間がかかりそう。boot2dockerを参考にして作ればよさそう。

```
Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.vagrant_vagrantfile = "../path/to/Vagrantfile"
  end
end
```

次にDockerfileはphusion/baseimageのイメージをもとに作成している。sshの使えるように設定を追加。phusion/baseimageのgitリポジトリに使用方法は記載されている。

```
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD /sbin/my_init --enable-insecure-key
```

vagrant ssh でdockerにsshできるように設定を追加。
portを指定しないと繋がらなかったので注意。
insecure_keyはphusion/baseimageにある鍵をダウンロードして使用。

```
Vagrant.configure("2") do |config|
    config.vm.define "phusion" do |v|
        v.vm.provider "docker" do |d|
            d.build_dir = "."
            d.has_ssh = true
        end
        v.ssh.username = "root"
        v.ssh.private_key_path = "insecure_key"
        v.ssh.port = 22
        v.vm.provision "shell", inline: "echo hello"
    end
end
```

あとはvagrant upしてvagrant sshすればdockerにsshでログインできる。

## 使い方

dockerイメージの作成と実行　

```
vagrant up
```

dcokerイメージにssh

```
vagrant ssh
```

vagrantステータス確認

```
vagrant global-status
```

>
「id:8f2bcf0」のdockerのHostVM、「id:8f2bcf0」のdockerイメージが起動していることが見ることができます。
>
| id|name|provider|state|directory|
|:--|:--:|:------:|:---:|:--------|
|8f2bcf0|default|virtualbox|running|/Users/a13000/.vagrant.d/data/docker-host|
|49a6671|phusion|docker|host state unknown|/Users/a13000/simple-docker|


## 参考
<https://www.vagrantup.com/>
<https://vagrantcloud.com/> 
<https://www.docker.com/>
<https://registry.hub.docker.com/>
<https://github.com/phusion/baseimage-docker/>
<https://github.com/boot2docker/boot2docker/>